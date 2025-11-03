# app.py
import streamlit as st
import mysql.connector
import pandas as pd
import plotly.express as px
from config import DB_CONFIG, APP_TITLE, APP_ICON
from datetime import datetime
import time

# Page config
st.set_page_config(
    page_title="Indian Startup Analytics",
    page_icon=APP_ICON,
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS
st.markdown("""
    <style>
        .success-box { background-color: #d4edda; padding: 1rem; border-radius: 0.5rem; }
        .error-box { background-color: #f8d7da; padding: 1rem; border-radius: 0.5rem; }
        .header-style { color: #1f77b4; font-size: 2.5em; margin-bottom: 1.5rem; }
    </style>
""", unsafe_allow_html=True)

# Database connection (NO CACHING - fresh connection each time)
def get_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except mysql.connector.Error as err:
        st.error(f"❌ Database Connection Failed: {err}")
        st.info("Make sure:\n- MySQL is running\n- Password in .env is correct\n- Database is 'mini_project'")
        return None

def execute_query(query):
    try:
        conn = get_connection()
        if conn is None:
            return None
        df = pd.read_sql(query, conn)
        conn.close()
        return df
    except Exception as e:
        st.error(f"❌ Query Error: {e}")
        return None

def execute_insert_update(query, params=None):
    try:
        conn = get_connection()
        if conn is None:
            return False
        cursor = conn.cursor()
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except mysql.connector.Error as err:
        st.error(f"❌ Operation Failed: {err}")
        return False

# Sidebar Navigation
st.sidebar.title("🚀 Navigation")
st.sidebar.markdown("---")

page = st.sidebar.radio("Go to", [
    "🏠 Dashboard", 
    "🏢 Startups", 
    "👥 Investors", 
    "💰 Funding Rounds",
    "🎯 Founders",
    "📊 Analytics",
    "🤝 Acquisitions"
])

# ===== DASHBOARD =====
if page == "🏠 Dashboard":
    st.markdown(f"<h1 class='header-style'>📊 {APP_TITLE}</h1>", unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns(4)
    
    try:
        conn = get_connection()
        if conn:
            cursor = conn.cursor()
            
            cursor.execute("SELECT COUNT(*) FROM startups")
            col1.metric("🏢 Total Startups", cursor.fetchone()[0])
            
            cursor.execute("SELECT COALESCE(SUM(Amount), 0) FROM funding_rounds")
            result = cursor.fetchone()[0]
            total_funding = float(result) if result else 0
            col2.metric("💵 Total Funding", f"₹{total_funding/1e7:.1f}Cr")
            
            cursor.execute("SELECT COUNT(*) FROM investors")
            col3.metric("👥 Total Investors", cursor.fetchone()[0])
            
            cursor.execute("SELECT COUNT(*) FROM acquisitions")
            col4.metric("🤝 Acquisitions", cursor.fetchone()[0])
            
            cursor.close()
            conn.close()
    except Exception as e:
        st.error(f"❌ Error loading metrics: {e}")
    
    st.markdown("---")
    
    st.subheader("💰 Recent Funding Rounds (Top 10)")
    query = """
    SELECT s.Name AS Startup, fr.Date, fr.Amount, fr.Stage
    FROM funding_rounds fr
    JOIN startups s ON fr.Startup_ID = s.Startup_ID
    ORDER BY fr.Date DESC
    LIMIT 10
    """
    df = execute_query(query)
    if df is not None:
        st.dataframe(df, use_container_width=True, hide_index=True)
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("🏭 Industry Distribution")
        query = """
        SELECT i.Sector, COUNT(s.Startup_ID) as Count
        FROM industries i
        LEFT JOIN startups s ON i.Industry_ID = s.Industry_ID
        GROUP BY i.Sector
        ORDER BY Count DESC
        """
        df = execute_query(query)
        if df is not None and len(df) > 0:
            fig = px.pie(df, values='Count', names='Sector')
            st.plotly_chart(fig, use_container_width=True)
    
    with col2:
        st.subheader("📈 Funding by Stage")
        query = """
        SELECT Stage, SUM(Amount) as Total
        FROM funding_rounds
        GROUP BY Stage
        ORDER BY Total DESC
        """
        df = execute_query(query)
        if df is not None and len(df) > 0:
            fig = px.pie(df, values='Total', names='Stage')
            st.plotly_chart(fig, use_container_width=True)

# ===== STARTUPS =====
elif page == "🏢 Startups":
    st.markdown("<h1 class='header-style'>🏢 Startup Management</h1>", unsafe_allow_html=True)
    
    tab1, tab2, tab3, tab4 = st.tabs(["📋 View All", "➕ Add New", "✏️ Update", "🗑️ Delete"])
    
    with tab1:
        st.subheader("All Startups")
        query = """
        SELECT s.Startup_ID, s.Name, s.Founded_Year, c.Name AS City, i.Sector
        FROM startups s
        LEFT JOIN cities c ON s.City_ID = c.City_ID
        LEFT JOIN industries i ON s.Industry_ID = i.Industry_ID
        ORDER BY s.Startup_ID ASC
        """
        df = execute_query(query)
        if df is not None:
            st.dataframe(df, use_container_width=True, hide_index=True)
    
    with tab2:
        st.subheader("Add New Startup")
        with st.form("add_startup"):
            col1, col2 = st.columns(2)
            
            with col1:
                startup_id = st.number_input("Startup ID", min_value=101, step=1)
                name = st.text_input("Name")
                founded_year = st.number_input("Founded Year", min_value=1990, max_value=2025, value=2023)
            
            with col2:
                cities_query = "SELECT City_ID, Name FROM cities ORDER BY Name"
                cities_df = execute_query(cities_query)
                if cities_df is not None:
                    cities_dict = dict(zip(cities_df['Name'], cities_df['City_ID']))
                    city = st.selectbox("City", list(cities_dict.keys()))
                
                industries_query = "SELECT Industry_ID, Sector FROM industries ORDER BY Sector"
                industries_df = execute_query(industries_query)
                if industries_df is not None:
                    industries_dict = dict(zip(industries_df['Sector'], industries_df['Industry_ID']))
                    industry = st.selectbox("Industry", list(industries_dict.keys()))
            
            if st.form_submit_button("✅ Add Startup", use_container_width=True):
                if not name:
                    st.error("Name is required")
                else:
                    query = "INSERT INTO startups (Startup_ID, Name, Founded_Year, City_ID, Industry_ID) VALUES (%s, %s, %s, %s, %s)"
                    if execute_insert_update(query, (startup_id, name, founded_year, cities_dict[city], industries_dict[industry])):
                        msg = st.success("✅ Added!")
                        time.sleep(2)
                        st.rerun()
    
    with tab3:
        st.subheader("Update Startup")
        startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Startup_ID"
        startups_df = execute_query(startups_query)
        
        if startups_df is not None and len(startups_df) > 0:
            selected = st.selectbox("Select Startup", startups_df['Name'].tolist(), key="update_select")
            startup_id = int(startups_df[startups_df['Name'] == selected]['Startup_ID'].values[0])
            
            current_query = f"SELECT * FROM startups WHERE Startup_ID = {startup_id}"
            current_df = execute_query(current_query)
            
            if current_df is not None and len(current_df) > 0:
                current = current_df.iloc[0]
                
                with st.form("update_startup_form"):
                    col1, col2 = st.columns(2)
                    
                    with col1:
                        new_name = st.text_input("Name", value=str(current['Name']))
                        new_year = st.number_input("Founded Year", value=int(current['Founded_Year']), min_value=1990, max_value=2025)
                    
                    with col2:
                        # Get current city
                        cities_query = "SELECT City_ID, Name FROM cities ORDER BY Name"
                        cities_df = execute_query(cities_query)
                        if cities_df is not None and len(cities_df) > 0:
                            cities_dict = dict(zip(cities_df['Name'], cities_df['City_ID']))
                            current_city_id = int(current['City_ID']) if current['City_ID'] else None
                            
                            # Find current city name
                            city_query = f"SELECT Name FROM cities WHERE City_ID = {current_city_id}" if current_city_id else None
                            if city_query:
                                city_result = execute_query(city_query)
                                current_city_name = city_result.iloc[0]['Name'] if city_result is not None and len(city_result) > 0 else list(cities_dict.keys())[0]
                            else:
                                current_city_name = list(cities_dict.keys())[0]
                            
                            try:
                                city_index = list(cities_dict.keys()).index(current_city_name)
                            except:
                                city_index = 0
                            
                            selected_city = st.selectbox("City", list(cities_dict.keys()), index=city_index, key="update_city")
                        
                        # Get current industry
                        industries_query = "SELECT Industry_ID, Sector FROM industries ORDER BY Sector"
                        industries_df = execute_query(industries_query)
                        if industries_df is not None and len(industries_df) > 0:
                            industries_dict = dict(zip(industries_df['Sector'], industries_df['Industry_ID']))
                            current_industry_id = int(current['Industry_ID']) if current['Industry_ID'] else None
                            
                            # Find current industry name
                            industry_query = f"SELECT Sector FROM industries WHERE Industry_ID = {current_industry_id}" if current_industry_id else None
                            if industry_query:
                                industry_result = execute_query(industry_query)
                                current_industry_name = industry_result.iloc[0]['Sector'] if industry_result is not None and len(industry_result) > 0 else list(industries_dict.keys())[0]
                            else:
                                current_industry_name = list(industries_dict.keys())[0]
                            
                            try:
                                industry_index = list(industries_dict.keys()).index(current_industry_name)
                            except:
                                industry_index = 0
                            
                            selected_industry = st.selectbox("Industry", list(industries_dict.keys()), index=industry_index, key="update_industry")
                    
                    # SUBMIT BUTTON HERE
                    if st.form_submit_button("✅ Update Startup", use_container_width=True):
                        query = "UPDATE startups SET Name = %s, Founded_Year = %s, City_ID = %s, Industry_ID = %s WHERE Startup_ID = %s"
                        if execute_insert_update(query, (new_name, int(new_year), int(cities_dict[selected_city]), int(industries_dict[selected_industry]), startup_id)):
                            msg = st.success("✅ Updated!")
                            time.sleep(2)
                            st.rerun()
    
    with tab4:
        st.subheader("Delete Startup")
        st.warning("⚠️ This will delete the startup!")
        startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Startup_ID"
        startups_df = execute_query(startups_query)
        
        if startups_df is not None and len(startups_df) > 0:
            selected = st.selectbox("Select Startup", startups_df['Name'].tolist(), key="delete")
            startup_id = int(startups_df[startups_df['Name'] == selected]['Startup_ID'].values[0])  # Convert to int
            
            if st.button("🗑️ Delete", use_container_width=True):
                if execute_insert_update("DELETE FROM startups WHERE Startup_ID = %s", (startup_id,)):
                    msg = st.success("✅ Deleted!")
                    time.sleep(2)
                    st.rerun()

# ===== INVESTORS =====
elif page == "👥 Investors":
    st.markdown("<h1 class='header-style'>👥 Investor Management</h1>", unsafe_allow_html=True)
    
    tab1, tab2, tab3, tab4 = st.tabs(["📋 View All", "➕ Add New", "✏️ Update", "🗑️ Delete"])
    
    with tab1:
        st.subheader("All Investors")
        query = """
        SELECT i.Investor_ID, i.Name, i.Type, c.Name AS Country
        FROM investors i
        LEFT JOIN countries c ON i.Country_ID = c.Country_ID
        ORDER BY i.Investor_ID ASC
        """
        df = execute_query(query)
        if df is not None:
            st.dataframe(df, use_container_width=True, hide_index=True)
    
    with tab2:
        st.subheader("Add New Investor")
        with st.form("add_investor"):
            col1, col2 = st.columns(2)
            
            with col1:
                investor_id = st.number_input("Investor ID", min_value=51, step=1)
                name = st.text_input("Name")
            
            with col2:
                investor_type = st.selectbox("Type", ["VC Firm", "Angel", "PE Firm", "Corporate VC", "Bank"])
                
                countries_query = "SELECT Country_ID, Name FROM countries ORDER BY Name"
                countries_df = execute_query(countries_query)
                if countries_df is not None:
                    countries_dict = dict(zip(countries_df['Name'], countries_df['Country_ID']))
                    country = st.selectbox("Country", list(countries_dict.keys()))
            
            if st.form_submit_button("✅ Add Investor", use_container_width=True):
                if not name:
                    st.error("Name is required")
                else:
                    query = "INSERT INTO investors (Investor_ID, Name, Type, Country_ID) VALUES (%s, %s, %s, %s)"
                    if execute_insert_update(query, (int(investor_id), name, investor_type, int(countries_dict[country]))):
                        msg = st.success("✅ Added!")
                        time.sleep(2)
                        st.rerun()
    
    with tab3:
        st.subheader("Update Investor")
        investors_query = "SELECT Investor_ID, Name FROM investors ORDER BY Investor_ID"
        investors_df = execute_query(investors_query)
        
        if investors_df is not None and len(investors_df) > 0:
            selected = st.selectbox("Select Investor", investors_df['Name'].tolist(), key="update_investor")
            investor_id = int(investors_df[investors_df['Name'] == selected]['Investor_ID'].values[0])
            
            current_query = f"SELECT * FROM investors WHERE Investor_ID = {investor_id}"
            current_df = execute_query(current_query)
            
            if current_df is not None and len(current_df) > 0:
                current = current_df.iloc[0]
                
                with st.form("update_investor_form"):
                    col1, col2 = st.columns(2)
                    
                    with col1:
                        new_name = st.text_input("Name", value=str(current['Name']))
                        type_options = ["VC Firm", "Angel", "PE Firm", "Corporate VC", "Bank"]
                        current_type = current['Type']
                        
                        # Find index safely
                        try:
                            type_index = type_options.index(current_type)
                        except ValueError:
                            type_index = 0
                        
                        new_type = st.selectbox("Type", type_options, index=type_index)
                    
                    with col2:
                        countries_query = "SELECT Country_ID, Name FROM countries ORDER BY Name"
                        countries_df = execute_query(countries_query)
                        if countries_df is not None:
                            countries_dict = dict(zip(countries_df['Name'], countries_df['Country_ID']))
                            current_country_id = int(current['Country_ID']) if current['Country_ID'] else None
                            
                            country_query = f"SELECT Name FROM countries WHERE Country_ID = {current_country_id}" if current_country_id else None
                            if country_query:
                                country_result = execute_query(country_query)
                                current_country_name = country_result.iloc[0]['Name'] if country_result is not None and len(country_result) > 0 else list(countries_dict.keys())[0]
                            else:
                                current_country_name = list(countries_dict.keys())[0]
                            
                            try:
                                country_index = list(countries_dict.keys()).index(current_country_name)
                            except ValueError:
                                country_index = 0
                            
                            selected_country = st.selectbox("Country", list(countries_dict.keys()), index=country_index, key="update_investor_country")
                    
                    if st.form_submit_button("✅ Update Investor", use_container_width=True):
                        query = "UPDATE investors SET Name = %s, Type = %s, Country_ID = %s WHERE Investor_ID = %s"
                        if execute_insert_update(query, (new_name, new_type, int(countries_dict[selected_country]), investor_id)):
                            msg = st.success("✅ Updated!")
                            time.sleep(2)
                            st.rerun()
    
    with tab4:
        st.subheader("Delete Investor")
        st.warning("⚠️ This will delete the investor!")
        investors_query = "SELECT Investor_ID, Name FROM investors ORDER BY Investor_ID"
        investors_df = execute_query(investors_query)
        
        if investors_df is not None and len(investors_df) > 0:
            selected = st.selectbox("Select Investor", investors_df['Name'].tolist(), key="delete_investor")
            investor_id = int(investors_df[investors_df['Name'] == selected]['Investor_ID'].values[0])
            
            if st.button("🗑️ Delete Investor", use_container_width=True):
                if execute_insert_update("DELETE FROM investors WHERE Investor_ID = %s", (investor_id,)):
                    msg = st.success("✅ Deleted!")
                    time.sleep(2)
                    st.rerun()

# ===== FUNDING ROUNDS =====
elif page == "💰 Funding Rounds":
    st.markdown("<h1 class='header-style'>💰 Funding Rounds</h1>", unsafe_allow_html=True)
    
    tab1, tab2, tab3, tab4 = st.tabs(["📋 View All", "➕ Add New", "✏️ Update", "🗑️ Delete"])
    
    with tab1:
        st.subheader("All Funding Rounds")
        query = """
        SELECT fr.Round_ID, s.Name AS Startup, fr.Date, fr.Amount, fr.Stage
        FROM funding_rounds fr
        JOIN startups s ON fr.Startup_ID = s.Startup_ID
        ORDER BY fr.Round_ID ASC
        """
        df = execute_query(query)
        if df is not None:
            st.dataframe(df, use_container_width=True, hide_index=True)
    
    with tab2:
        st.subheader("Add New Funding Round")
        with st.form("add_funding"):
            round_id = st.number_input("Round ID", min_value=151, step=1)
            funding_date = st.date_input("Date")
            amount = st.number_input("Amount (₹)", min_value=0.0, step=100000.0)
            stage = st.selectbox("Stage", ["Pre-Seed", "Seed", "Series A", "Series B", "Series C", "Series D", "Series E+", "IPO"])
            
            startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
            startups_df = execute_query(startups_query)
            if startups_df is not None:
                startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
                startup = st.selectbox("Startup", list(startups_dict.keys()), key="funding_startup")
            
            if st.form_submit_button("✅ Add Funding", use_container_width=True):
                query = "INSERT INTO funding_rounds (Round_ID, Startup_ID, Date, Amount, Stage) VALUES (%s, %s, %s, %s, %s)"
                if execute_insert_update(query, (int(round_id), int(startups_dict[startup]), funding_date, float(amount), stage)):
                    msg = st.success("✅ Added!")
                    time.sleep(2)
                    st.rerun()
    
    with tab3:
        st.subheader("Update Funding Round")
        rounds_query = "SELECT Round_ID, Round_ID FROM funding_rounds ORDER BY Round_ID"
        rounds_df = execute_query(rounds_query)
        
        if rounds_df is not None and len(rounds_df) > 0:
            round_options = [f"Round {r}" for r in rounds_df.iloc[:, 0]]
            selected = st.selectbox("Select Funding Round", round_options, key="update_round")
            round_id = int(selected.split()[-1])
            
            current_query = f"SELECT * FROM funding_rounds WHERE Round_ID = {round_id}"
            current_df = execute_query(current_query)
            
            if current_df is not None and len(current_df) > 0:
                current = current_df.iloc[0]
                
                with st.form("update_funding_form"):
                    col1, col2 = st.columns(2)
                    
                    with col1:
                        new_date = st.date_input("Date", value=current['Date'])
                        new_amount = st.number_input("Amount (₹)", value=float(current['Amount']), min_value=0.0, step=100000.0)
                    
                    with col2:
                        stage_options = ["Pre-Seed", "Seed", "Series A", "Series B", "Series C", "Series D", "Series E+", "IPO"]
                        try:
                            stage_index = stage_options.index(current['Stage'])
                        except ValueError:
                            stage_index = 0
                        new_stage = st.selectbox("Stage", stage_options, index=stage_index)
                        
                        startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
                        startups_df = execute_query(startups_query)
                        if startups_df is not None:
                            startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
                            startup_query = f"SELECT Name FROM startups WHERE Startup_ID = {int(current['Startup_ID'])}"
                            startup_result = execute_query(startup_query)
                            current_startup_name = startup_result.iloc[0]['Name'] if startup_result is not None and len(startup_result) > 0 else list(startups_dict.keys())[0]
                            selected_startup = st.selectbox("Startup", list(startups_dict.keys()), index=list(startups_dict.keys()).index(current_startup_name) if current_startup_name in startups_dict else 0, key="update_funding_startup")
                    
                    if st.form_submit_button("✅ Update Funding", use_container_width=True):
                        query = "UPDATE funding_rounds SET Date = %s, Amount = %s, Stage = %s, Startup_ID = %s WHERE Round_ID = %s"
                        if execute_insert_update(query, (new_date, float(new_amount), new_stage, int(startups_dict[selected_startup]), round_id)):
                            msg = st.success("✅ Updated!")
                            time.sleep(2)
                            st.rerun()
    
    with tab4:
        st.subheader("Delete Funding Round")
        st.warning("⚠️ This will delete the funding round!")
        rounds_query = "SELECT Round_ID FROM funding_rounds ORDER BY Round_ID"
        rounds_df = execute_query(rounds_query)
        
        if rounds_df is not None and len(rounds_df) > 0:
            round_options = [f"Round {r}" for r in rounds_df.iloc[:, 0]]
            selected = st.selectbox("Select Funding Round", round_options, key="delete_round")
            round_id = int(selected.split()[-1])
            
            if st.button("🗑️ Delete Funding Round", use_container_width=True):
                if execute_insert_update("DELETE FROM funding_rounds WHERE Round_ID = %s", (round_id,)):
                    msg = st.success("✅ Deleted!")
                    time.sleep(2)
                    st.rerun()

# ===== FOUNDERS =====
elif page == "🎯 Founders":
    st.markdown("<h1 class='header-style'>🎯 Founders</h1>", unsafe_allow_html=True)
    
    tab1, tab2, tab3, tab4 = st.tabs(["📋 View All", "➕ Add New", "✏️ Update", "🗑️ Delete"])
    
    with tab1:
        st.subheader("All Founders")
        query = """
        SELECT f.Founder_ID, f.Name, s.Name AS Startup, f.Role, f.LinkedIn_URL
        FROM founders f
        LEFT JOIN startups s ON f.Startup_ID = s.Startup_ID
        ORDER BY f.Founder_ID ASC
        """
        df = execute_query(query)
        if df is not None:
            st.dataframe(df, use_container_width=True, hide_index=True)
    
    with tab2:
        st.subheader("Add New Founder")
        with st.form("add_founder"):
            founder_id = st.number_input("Founder ID", min_value=179, step=1)
            name = st.text_input("Name")
            role = st.text_input("Role")
            linkedin_url = st.text_input("LinkedIn URL")
            
            startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
            startups_df = execute_query(startups_query)
            if startups_df is not None:
                startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
                startup = st.selectbox("Startup", list(startups_dict.keys()), key="founder_startup_add")
            
            if st.form_submit_button("✅ Add Founder", use_container_width=True):
                query = "INSERT INTO founders (Founder_ID, Name, Startup_ID, Role, LinkedIn_URL) VALUES (%s, %s, %s, %s, %s)"
                if execute_insert_update(query, (int(founder_id), name, int(startups_dict[startup]), role, linkedin_url)):
                    msg = st.success("✅ Added!")
                    time.sleep(2)
                    st.rerun()
    
    with tab3:
        st.subheader("Update Founder")
        founders_query = "SELECT Founder_ID, Name FROM founders ORDER BY Founder_ID"
        founders_df = execute_query(founders_query)
        
        if founders_df is not None and len(founders_df) > 0:
            selected = st.selectbox("Select Founder", founders_df['Name'].tolist(), key="update_founder")
            founder_id = int(founders_df[founders_df['Name'] == selected]['Founder_ID'].values[0])
            
            current_query = f"SELECT * FROM founders WHERE Founder_ID = {founder_id}"
            current_df = execute_query(current_query)
            
            if current_df is not None and len(current_df) > 0:
                current = current_df.iloc[0]
                linkedin_val = current['LinkedIn_URL'] if 'LinkedIn_URL' in current and current['LinkedIn_URL'] is not None else ""
                
                with st.form("update_founder_form"):
                    new_name = st.text_input("Name", value=str(current['Name']))
                    new_role = st.text_input("Role", value=str(current['Role']))
                    new_linkedin = st.text_input("LinkedIn URL", value=str(linkedin_val))
                    
                    startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
                    startups_df = execute_query(startups_query)
                    if startups_df is not None:
                        startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
                        startup_query = f"SELECT Name FROM startups WHERE Startup_ID = {int(current['Startup_ID'])}"
                        startup_result = execute_query(startup_query)
                        current_startup_name = startup_result.iloc[0]['Name'] if startup_result is not None and len(startup_result) > 0 else list(startups_dict.keys())[0]
                        selected_startup = st.selectbox("Startup", list(startups_dict.keys()), index=list(startups_dict.keys()).index(current_startup_name) if current_startup_name in startups_dict else 0, key="update_founder_startup")
                    
                    if st.form_submit_button("✅ Update Founder", use_container_width=True):
                        query = "UPDATE founders SET Name = %s, Role = %s, LinkedIn_URL = %s, Startup_ID = %s WHERE Founder_ID = %s"
                        if execute_insert_update(query, (new_name, new_role, new_linkedin, int(startups_dict[selected_startup]), founder_id)):
                            msg = st.success("✅ Updated!")
                            time.sleep(2)
                            st.rerun()
    
    with tab4:
        st.subheader("Delete Founder")
        st.warning("⚠️ This will delete the founder!")
        founders_query = "SELECT Founder_ID, Name FROM founders ORDER BY Founder_ID"
        founders_df = execute_query(founders_query)
        
        if founders_df is not None and len(founders_df) > 0:
            selected = st.selectbox("Select Founder", founders_df['Name'].tolist(), key="delete_founder")
            founder_id = int(founders_df[founders_df['Name'] == selected]['Founder_ID'].values[0])
            
            if st.button("🗑️ Delete Founder", use_container_width=True):
                if execute_insert_update("DELETE FROM founders WHERE Founder_ID = %s", (founder_id,)):
                    msg = st.success("✅ Deleted!")
                    time.sleep(2)
                    st.rerun()

# ===== ANALYTICS =====
elif page == "📊 Analytics":
    st.markdown("<h1 class='header-style'>📊 Analytics & Insights</h1>", unsafe_allow_html=True)
    
    tab1, tab2, tab3, tab4 = st.tabs(["Industry", "Top Startups", "Funding", "Cities"])
    
    with tab1:
        st.subheader("Funding by Industry")
        query = """
        SELECT i.Sector, COUNT(DISTINCT s.Startup_ID) AS Startups, 
               COALESCE(SUM(fr.Amount), 0) AS Total_Funding
        FROM industries i
        LEFT JOIN startups s ON i.Industry_ID = s.Industry_ID
        LEFT JOIN funding_rounds fr ON s.Startup_ID = fr.Startup_ID
        GROUP BY i.Sector
        ORDER BY Total_Funding DESC
        """
        df = execute_query(query)
        if df is not None and len(df) > 0:
            fig = px.bar(df, x='Sector', y='Total_Funding', title='Funding by Industry')
            st.plotly_chart(fig, use_container_width=True)
    
    with tab2:
        st.subheader("Top 10 Funded Startups")
        query = """
        SELECT s.Name, SUM(fr.Amount) AS Total_Funding, COUNT(fr.Round_ID) AS Rounds
        FROM startups s
        LEFT JOIN funding_rounds fr ON s.Startup_ID = fr.Startup_ID
        GROUP BY s.Name
        ORDER BY Total_Funding DESC
        LIMIT 10
        """
        df = execute_query(query)
        if df is not None and len(df) > 0:
            fig = px.bar(df, x='Name', y='Total_Funding', title='Top 10 Funded Startups')
            st.plotly_chart(fig, use_container_width=True)
    
    with tab3:
        st.subheader("Funding Distribution by Stage")
        query = """
        SELECT Stage, COUNT(*) AS Count, SUM(Amount) AS Total
        FROM funding_rounds
        GROUP BY Stage
        ORDER BY Total DESC
        """
        df = execute_query(query)
        if df is not None and len(df) > 0:
            fig = px.pie(df, values='Total', names='Stage', title='Funding by Stage')
            st.plotly_chart(fig, use_container_width=True)
    
    with tab4:
        st.subheader("Startups by City")
        query = """
        SELECT c.Name AS City, COUNT(s.Startup_ID) AS Startups
        FROM cities c
        LEFT JOIN startups s ON c.City_ID = s.City_ID
        GROUP BY c.Name
        ORDER BY Startups DESC
        """
        df = execute_query(query)
        if df is not None and len(df) > 0:
            fig = px.bar(df, x='City', y='Startups', title='Startups by City')
            st.plotly_chart(fig, use_container_width=True)

# ===== ACQUISITIONS =====
elif page == "🤝 Acquisitions":
    st.markdown("<h1 class='header-style'>🤝 Acquisitions</h1>", unsafe_allow_html=True)
    
    tab1, tab2, tab3, tab4 = st.tabs(["📋 View All", "➕ Add New", "✏️ Update", "🗑️ Delete"])
    
    with tab1:
        st.subheader("All Acquisitions")
        query = """
        SELECT s1.Name AS Acquirer, s2.Name AS Target, a.Date, a.Amount
        FROM acquisitions a
        JOIN startups s1 ON a.Acquirer_Startup_ID = s1.Startup_ID
        JOIN startups s2 ON a.Target_Startup_ID = s2.Startup_ID
        ORDER BY a.Date DESC
        """
        df = execute_query(query)
        if df is not None:
            st.dataframe(df, use_container_width=True, hide_index=True)
    
    with tab2:
        st.subheader("Add New Acquisition")
        with st.form("add_acquisition"):
            acq_id = st.number_input("Acquisition ID", min_value=1, step=1)
            acq_date = st.date_input("Date")
            amount = st.number_input("Amount (₹)", min_value=0.0, step=100000.0)
            
            startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
            startups_df = execute_query(startups_query)
            
            if startups_df is not None:
                startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
                acquirer = st.selectbox("Acquirer", list(startups_dict.keys()), key="acq_acquirer_add")
                target = st.selectbox("Target", list(startups_dict.keys()), key="acq_target_add")
            
            if st.form_submit_button("✅ Add Acquisition", use_container_width=True):
                if acquirer == target:
                    st.error("❌ Cannot acquire itself!")
                else:
                    query = "INSERT INTO acquisitions (AcquisitionID, Acquirer_Startup_ID, Target_Startup_ID, Date, Amount) VALUES (%s, %s, %s, %s, %s)"
                    if execute_insert_update(query, (int(acq_id), int(startups_dict[acquirer]), int(startups_dict[target]), acq_date, float(amount))):
                        msg = st.success("✅ Added!")
                        time.sleep(2)
                        st.rerun()

    
    with tab3:
        st.subheader("Update Acquisition")
        st.info("ℹ️ View all acquisitions in 'View All' tab, then use their Acquirer name to update")
        
        startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
        startups_df = execute_query(startups_query)
        if startups_df is not None:
            startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
            
            acqs_query = """
            SELECT s1.Name AS Acquirer, s2.Name AS Target, a.Date, a.Amount
            FROM acquisitions a
            JOIN startups s1 ON a.Acquirer_Startup_ID = s1.Startup_ID
            JOIN startups s2 ON a.Target_Startup_ID = s2.Startup_ID
            ORDER BY a.Date DESC
            """
            acqs_df = execute_query(acqs_query)
            
            if acqs_df is not None and len(acqs_df) > 0:
                acq_options = [f"{row['Acquirer']} → {row['Target']}" for _, row in acqs_df.iterrows()]
                selected_acq = st.selectbox("Select Acquisition", acq_options, key="update_acq_select")
                
                if selected_acq:
                    sel_idx = acq_options.index(selected_acq)
                    current = acqs_df.iloc[sel_idx]
                    
                    with st.form("update_acquisition_form"):
                        new_date = st.date_input("Date", value=current['Date'])
                        new_amount = st.number_input("Amount (₹)", value=float(current['Amount']), min_value=0.0, step=100000.0)
                        
                        selected_acquirer = st.selectbox("Acquirer", list(startups_dict.keys()), index=list(startups_dict.keys()).index(current['Acquirer']) if current['Acquirer'] in startups_dict else 0, key="update_acq_acquirer")
                        selected_target = st.selectbox("Target", list(startups_dict.keys()), index=list(startups_dict.keys()).index(current['Target']) if current['Target'] in startups_dict else 0, key="update_acq_target")
                        
                        if st.form_submit_button("✅ Update Acquisition", use_container_width=True):
                            if selected_acquirer == selected_target:
                                st.error("❌ Cannot acquire itself!")
                            else:
                                query = "UPDATE acquisitions SET Acquirer_Startup_ID = %s, Target_Startup_ID = %s, Date = %s, Amount = %s WHERE Acquirer_Startup_ID = %s AND Target_Startup_ID = %s AND Date = %s"
                                if execute_insert_update(query, (int(startups_dict[selected_acquirer]), int(startups_dict[selected_target]), new_date, float(new_amount), int(startups_dict[current['Acquirer']]), int(startups_dict[current['Target']]), current['Date'])):
                                    msg = st.success("✅ Updated!")
                                    time.sleep(2)
                                    st.rerun()
    
    with tab4:
        st.subheader("Delete Acquisition")
        st.warning("⚠️ This will delete the acquisition!")
        
        acqs_query = """
        SELECT s1.Name AS Acquirer, s2.Name AS Target, a.Date, a.Amount
        FROM acquisitions a
        JOIN startups s1 ON a.Acquirer_Startup_ID = s1.Startup_ID
        JOIN startups s2 ON a.Target_Startup_ID = s2.Startup_ID
        ORDER BY a.Date DESC
        """
        acqs_df = execute_query(acqs_query)
        
        if acqs_df is not None and len(acqs_df) > 0:
            acq_options = [f"{row['Acquirer']} → {row['Target']}" for _, row in acqs_df.iterrows()]
            selected_acq = st.selectbox("Select Acquisition", acq_options, key="delete_acq_select")
            
            if st.button("🗑️ Delete Acquisition", use_container_width=True):
                sel_idx = acq_options.index(selected_acq)
                current = acqs_df.iloc[sel_idx]
                
                startups_query = "SELECT Startup_ID, Name FROM startups ORDER BY Name"
                startups_df = execute_query(startups_query)
                startups_dict = dict(zip(startups_df['Name'], startups_df['Startup_ID']))
                
                if execute_insert_update("DELETE FROM acquisitions WHERE Acquirer_Startup_ID = %s AND Target_Startup_ID = %s AND Date = %s", (int(startups_dict[current['Acquirer']]), int(startups_dict[current['Target']]), current['Date'])):
                    msg = st.success("✅ Deleted!")
                    time.sleep(2)
                    st.rerun()