# Indian Startup Ecosystem Analytics Platform

A database management system to track and analyze the Indian startup ecosystem using MySQL and Streamlit.

## Overview

DBMS Mini Project for tracking startups, funding rounds, investors, founders, and acquisitions in the Indian startup ecosystem.

## Features

- Full CRUD operations for all entities
- Real-time analytics dashboard
- 100+ startups, 200+ founders, 50+ investors
- Triggers, stored procedures, and functions
- Interactive visualizations

## Technology Stack

- **Database**: MySQL 8.0
- **Backend**: Python 3.10+
- **Frontend**: Streamlit
- **Visualization**: Plotly Express
- **Libraries**: pandas, mysql-connector-python

## Database Schema

**9 Core Tables**:
- countries, cities, industries
- startups, founders, investors
- funding_rounds, acquisitions, startup_milestones
- funding_round_investors (junction table)

## Installation

1. **Database Setup**
```sql
CREATE DATABASE mini_project;
mysql -u root -p mini_project < db/schema.sql
mysql -u root -p mini_project < db/dml.sql
mysql -u root -p mini_project < db/triggeres_procedures_functions.sql
```

2. **Python Setup**
```bash
pip install -r requirements.txt
```

3. **Environment Variables** - Create `.env`:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=mini_project
DB_PORT=3306
```

4. **Run Application**
```bash
streamlit run app.py
```

## Advanced SQL Features

**Triggers**:
- Prevent deletion of startups with recent funding
- Validate acquisitions (no self-acquisition)

**Stored Procedures**:
- `add_funding()` - Add funding round with multiple investors
- `record_acq()` - Record acquisition transaction

**Functions**:
- `get_total_funding()` - Calculate total funding
- `count_milestones()` - Count startup milestones

---