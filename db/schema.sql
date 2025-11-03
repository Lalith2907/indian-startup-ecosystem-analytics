-- Countries
CREATE TABLE countries (
    Country_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE
);

-- Cities
CREATE TABLE cities (
    City_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    State VARCHAR(100),
    Country_ID INT NOT NULL,
    CONSTRAINT fk_country FOREIGN KEY (Country_ID) REFERENCES countries (Country_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Industries
CREATE TABLE industries (
    Industry_ID INT PRIMARY KEY,
    Sector VARCHAR(100) NOT NULL,
    Sub_Sector VARCHAR(100) NOT NULL,
    CONSTRAINT unique_sector_subsector UNIQUE (Sector, Sub_Sector)
);

-- Startups (WITH FIXED CONSTRAINT)
CREATE TABLE startups (
    Startup_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Founded_Year INT CHECK (
        Founded_Year BETWEEN 1996 AND 2025
    ), -- FIXED RANGE
    City_ID INT,
    Industry_ID INT,
    CONSTRAINT fk_city_ID FOREIGN KEY (City_ID) REFERENCES cities (City_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_industry_ID FOREIGN KEY (Industry_ID) REFERENCES industries (Industry_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Founders
CREATE TABLE founders (
    Founder_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Startup_ID INT NOT NULL,
    Role VARCHAR(100),
    Linkedin_url VARCHAR(200) DEFAULT 'Not Provided',
    CONSTRAINT fk_founder_startup FOREIGN KEY (Startup_ID) REFERENCES startups (Startup_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Funding Rounds
CREATE TABLE funding_rounds (
    Round_ID INT PRIMARY KEY,
    Startup_ID INT NOT NULL,
    Date DATE,
    Amount DECIMAL(18, 2) CHECK (Amount > 0),
    Stage VARCHAR(50) NOT NULL,
    CONSTRAINT fk_startup_ID FOREIGN KEY (Startup_ID) REFERENCES startups (Startup_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_stage CHECK (
        Stage IN (
            'Seed',
            'Series A',
            'Series B',
            'Series C',
            'Series D',
            'Series E',
            'Series F',
            'Series G',
            'Series H',
            'Series J',
            'IPO'
        )
    )
);

-- Investors
CREATE TABLE investors (
    Investor_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Type VARCHAR(50) NOT NULL,
    Country_ID INT,
    CONSTRAINT fk_investor_country FOREIGN KEY (Country_ID) REFERENCES countries (Country_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Startup Milestones
CREATE TABLE startup_milestones (
    Milestone_ID INT PRIMARY KEY,
    Startup_ID INT NOT NULL,
    Description VARCHAR(200) NOT NULL,
    Date DATE,
    CONSTRAINT fk_milestone_startup FOREIGN KEY (Startup_ID) REFERENCES startups (Startup_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Acquisitions
CREATE TABLE acquisitions (
    AcquisitionID INT PRIMARY KEY,
    Acquirer_Startup_ID INT,
    Target_Startup_ID INT,
    Date DATE,
    Amount DECIMAL(18, 2) CHECK (Amount > 0),
    CONSTRAINT fk_acquirer FOREIGN KEY (Acquirer_Startup_ID) REFERENCES startups (Startup_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_target FOREIGN KEY (Target_Startup_ID) REFERENCES startups (Startup_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Funding Round Investors
CREATE TABLE funding_round_investors (
    Round_ID INT,
    Investor_ID INT,
    PRIMARY KEY (Round_ID, Investor_ID),
    CONSTRAINT fk_fri_round FOREIGN KEY (Round_ID) REFERENCES funding_rounds (Round_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fri_investor FOREIGN KEY (Investor_ID) REFERENCES investors (Investor_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Countries

CREATE TABLE Countries (
    Country_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE
);

-- Cities

CREATE TABLE Cities (
    City_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    State VARCHAR(100),
    Country_ID INT NOT NULL,
    CONSTRAINT fk_country FOREIGN KEY (Country_ID) REFERENCES Countries (Country_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Industries

CREATE TABLE Industries (
    Industry_ID INT PRIMARY KEY,
    Sector VARCHAR(100) NOT NULL,
    Sub_Sector VARCHAR(100) NOT NULL,
    CONSTRAINT unique_sector_subsector UNIQUE (Sector, Sub_Sector)
);

-- Startups

CREATE TABLE Startups (
    Startup_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Founded_Year INT CHECK (
        Founded_Year BETWEEN 2010 AND 2025
    ),
    City_ID INT,
    Industry_ID INT,
    CONSTRAINT fk_city_ID FOREIGN KEY (City_ID) REFERENCES Cities (City_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_industry_ID FOREIGN KEY (Industry_ID) REFERENCES Industries (Industry_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Founders

CREATE TABLE Founders (
    Founder_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Startup_ID INT NOT NULL,
    Role VARCHAR(100),
    Linkedin_url VARCHAR(200) DEFAULT 'Not Provided',
    CONSTRAINT fk_founder_startup FOREIGN KEY (Startup_ID) REFERENCES Startups (Startup_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Funding Rounds

CREATE TABLE Funding_Rounds (
    Round_ID INT PRIMARY KEY,
    Startup_ID INT NOT NULL,
    Date DATE,
    Amount DECIMAL(18, 2) CHECK (Amount > 0),
    Stage VARCHAR(50) NOT NULL,
    CONSTRAINT fk_startup_ID FOREIGN KEY (Startup_ID) REFERENCES Startups (Startup_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_stage CHECK (
        Stage IN (
            'Seed',
            'Series A',
            'Series B',
            'Series C',
            'IPO'
        )
    )
);

-- Investors

CREATE TABLE Investors (
    Investor_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Type VARCHAR(50) NOT NULL,
    Country_ID INT,
    CONSTRAINT fk_investor_country FOREIGN KEY (Country_ID) REFERENCES Countries (Country_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Startup Milestones

CREATE TABLE Startup_Milestones (
    Milestone_ID INT PRIMARY KEY,
    Startup_ID INT NOT NULL,
    Description VARCHAR(200) NOT NULL,
    Date DATE,
    CONSTRAINT fk_milestone_startup FOREIGN KEY (Startup_ID) REFERENCES Startups (Startup_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Acquisitions

CREATE TABLE Acquisitions (
    AcquisitionID INT PRIMARY KEY,
    Acquirer_Startup_ID INT,
    Target_Startup_ID INT,
    Date DATE,
    Amount DECIMAL(18, 2) CHECK (Amount > 0),
    CONSTRAINT fk_acquirer FOREIGN KEY (Acquirer_Startup_ID) REFERENCES Startups (Startup_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_target FOREIGN KEY (Target_Startup_ID) REFERENCES Startups (Startup_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Funding Round Investors

CREATE TABLE Funding_Round_Investors (
    Round_ID INT,
    Investor_ID INT,
    PRIMARY KEY (Round_ID, Investor_ID),
    CONSTRAINT fk_fri_round FOREIGN KEY (Round_ID) REFERENCES Funding_Rounds (Round_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fri_investor FOREIGN KEY (Investor_ID) REFERENCES Investors (Investor_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Countries
INSERT INTO
    Countries (Country_ID, Name)
VALUES (1, 'India'),
    (2, 'United States'),
    (3, 'Germany'),
    (4, 'Singapore'),
    (5, 'United Kingdom');

-- Cities
INSERT INTO
    Cities (
        City_ID,
        Name,
        State,
        Country_ID
    )
VALUES (
        1,
        'Bangalore',
        'Karnataka',
        1
    ),
    (
        2,
        'San Francisco',
        'California',
        2
    ),
    (3, 'Berlin', 'Berlin', 3),
    (4, 'Singapore', NULL, 4),
    (5, 'London', 'England', 5);

-- Industries
INSERT INTO
    Industries (
        Industry_ID,
        Sector,
        Sub_Sector
    )
VALUES (
        1,
        'E-commerce',
        'Online Retail'
    ),
    (2, 'FinTech', 'Payments'),
    (
        3,
        'Healthcare',
        'Digital Health'
    ),
    (
        4,
        'EdTech',
        'Online Learning'
    ),
    (5, 'AI/ML', 'Computer Vision');

-- Startups
INSERT INTO
    Startups (
        Startup_ID,
        Name,
        Founded_Year,
        City_ID,
        Industry_ID
    )
VALUES (1, 'Flipkart', 2010, 1, 1),
    (2, 'Stripe', 2011, 2, 2),
    (3, 'Ada Health', 2016, 3, 3),
    (4, 'Byju''s', 2012, 1, 4),
    (5, 'OpenAI', 2015, 2, 5);

-- Founders
INSERT INTO
    Founders (
        Founder_ID,
        Name,
        Startup_ID,
        Role,
        Linkedin_url
    )
VALUES (
        1,
        'Sachin Bansal',
        1,
        'Co-Founder',
        'https://linkedin.com/in/sachinbansal'
    ),
    (
        2,
        'Patrick Collison',
        2,
        'CEO',
        'https://linkedin.com/in/patrickcollison'
    ),
    (
        3,
        'Claire Novorol',
        3,
        'Co-Founder',
        'https://linkedin.com/in/claire-novorol'
    ),
    (
        4,
        'Byju Raveendran',
        4,
        'Founder & CEO',
        'https://linkedin.com/in/byju-raveendran'
    ),
    (
        5,
        'Sam Altman',
        5,
        'CEO',
        'https://linkedin.com/in/sama'
    );

-- Funding Rounds
INSERT INTO
    Funding_Rounds (
        Round_ID,
        Startup_ID,
        Date,
        Amount,
        Stage
    )
VALUES (
        1,
        1,
        '2015-07-01',
        100000000.00,
        'Series B'
    ),
    (
        2,
        2,
        '2012-09-15',
        2000000.00,
        'Seed'
    ),
    (
        3,
        3,
        '2017-03-20',
        45000000.00,
        'Series A'
    ),
    (
        4,
        4,
        '2016-11-10',
        75000000.00,
        'Series C'
    ),
    (
        5,
        5,
        '2023-01-05',
        1000000000.00,
        'IPO'
    );

-- Investors
INSERT INTO
    Investors (
        Investor_ID,
        Name,
        Type,
        Country_ID
    )
VALUES (
        1,
        'Sequoia Capital',
        'VC Firm',
        2
    ),
    (
        2,
        'Accel Partners',
        'VC Firm',
        2
    ),
    (
        3,
        'SoftBank Vision Fund',
        'VC Firm',
        5
    ),
    (
        4,
        'Tiger Global',
        'Private Equity',
        2
    ),
    (
        5,
        'Temasek Holdings',
        'Sovereign Wealth Fund',
        4
    );

-- Startup Milestones
INSERT INTO
    Startup_Milestones (
        Milestone_ID,
        Startup_ID,
        Description,
        Date
    )
VALUES (
        1,
        1,
        'Reached 1 million customers',
        '2013-06-01'
    ),
    (
        2,
        2,
        'Expanded to Europe',
        '2015-04-15'
    ),
    (
        3,
        3,
        'Launched mobile app',
        '2018-01-10'
    ),
    (
        4,
        4,
        'Acquired WhiteHat Jr',
        '2020-08-01'
    ),
    (
        5,
        5,
        'Released ChatGPT',
        '2022-11-30'
    );

-- Acquisitions
INSERT INTO
    Acquisitions (
        AcquisitionID,
        Acquirer_Startup_ID,
        Target_Startup_ID,
        Date,
        Amount
    )
VALUES (
        1,
        1,
        4,
        '2014-10-01',
        20000000.00
    ),
    (
        2,
        2,
        3,
        '2018-12-12',
        5000000.00
    ),
    (
        3,
        4,
        3,
        '2021-02-01',
        30000000.00
    ),
    (
        4,
        5,
        2,
        '2023-03-01',
        500000000.00
    ),
    (
        5,
        3,
        1,
        '2020-07-15',
        10000000.00
    );

-- Funding Round Investors
INSERT INTO
    Funding_Round_Investors (Round_ID, Investor_ID)
VALUES (1, 1),
    (1, 2),
    (2, 4),
    (3, 3),
    (5, 5);

use mini_project;

-- ========================================
-- COUNTRIES (10 countries)
-- ========================================
INSERT INTO
    countries (Country_ID, Name)
VALUES (1, 'India'),
    (2, 'United States'),
    (3, 'United Kingdom'),
    (4, 'Singapore'),
    (5, 'China'),
    (6, 'Japan'),
    (7, 'Germany'),
    (8, 'France'),
    (9, 'UAE'),
    (10, 'Canada');

-- ========================================
-- CITIES (30 cities)
-- ========================================
INSERT INTO
    cities (
        City_ID,
        Name,
        State,
        Country_ID
    )
VALUES
    -- Indian Cities
    (
        1,
        'Bangalore',
        'Karnataka',
        1
    ),
    (2, 'Mumbai', 'Maharashtra', 1),
    (3, 'Delhi', 'Delhi', 1),
    (4, 'Gurugram', 'Haryana', 1),
    (5, 'Pune', 'Maharashtra', 1),
    (
        6,
        'Hyderabad',
        'Telangana',
        1
    ),
    (7, 'Chennai', 'Tamil Nadu', 1),
    (
        8,
        'Kolkata',
        'West Bengal',
        1
    ),
    (9, 'Ahmedabad', 'Gujarat', 1),
    (
        10,
        'Noida',
        'Uttar Pradesh',
        1
    ),
    -- International Cities
    (
        11,
        'San Francisco',
        'California',
        2
    ),
    (12, 'New York', 'New York', 2),
    (13, 'London', 'England', 3),
    (14, 'Singapore', NULL, 4),
    (15, 'Beijing', NULL, 5),
    (16, 'Tokyo', NULL, 6),
    (17, 'Berlin', NULL, 7),
    (18, 'Paris', NULL, 8),
    (19, 'Dubai', NULL, 9),
    (20, 'Toronto', 'Ontario', 10);

-- ========================================
-- INDUSTRIES (25 industries)
-- ========================================
INSERT INTO
    industries (
        Industry_ID,
        Sector,
        Sub_Sector
    )
VALUES (
        1,
        'E-commerce',
        'Online Retail'
    ),
    (
        2,
        'E-commerce',
        'Fashion & Lifestyle'
    ),
    (
        3,
        'E-commerce',
        'Grocery & Food Delivery'
    ),
    (4, 'FinTech', 'Payments'),
    (
        5,
        'FinTech',
        'Digital Banking'
    ),
    (6, 'FinTech', 'Lending'),
    (7, 'FinTech', 'Insurance'),
    (
        8,
        'EdTech',
        'Online Learning'
    ),
    (9, 'EdTech', 'K-12 Education'),
    (10, 'EdTech', 'Test Prep'),
    (
        11,
        'HealthTech',
        'Telemedicine'
    ),
    (12, 'HealthTech', 'Pharmacy'),
    (13, 'HealthTech', 'Fitness'),
    (
        14,
        'Mobility',
        'Ride Hailing'
    ),
    (15, 'Mobility', 'Logistics'),
    (16, 'Mobility', 'EV & Auto'),
    (
        17,
        'SaaS',
        'Enterprise Software'
    ),
    (18, 'SaaS', 'Marketing Tech'),
    (
        19,
        'AgriTech',
        'Farm Management'
    ),
    (
        20,
        'AgriTech',
        'Supply Chain'
    ),
    (21, 'PropTech', 'Real Estate'),
    (22, 'Gaming', 'Mobile Games'),
    (
        23,
        'Media',
        'Content & Entertainment'
    ),
    (
        24,
        'FoodTech',
        'Cloud Kitchen'
    ),
    (25, 'Travel', 'OTA & Booking');

-- ========================================
-- STARTUPS (100 startups)
-- ========================================
INSERT INTO
    startups (
        Startup_ID,
        Name,
        Founded_Year,
        City_ID,
        Industry_ID
    )
VALUES
    -- Unicorns & Major Startups
    (1, 'Flipkart', 2007, 1, 1),
    (2, 'PhonePe', 2015, 1, 4),
    (3, 'Swiggy', 2014, 1, 3),
    (4, 'Razorpay', 2014, 1, 4),
    (5, 'CRED', 2018, 1, 4),
    (6, 'Meesho', 2015, 1, 2),
    (7, 'Udaan', 2016, 1, 1),
    (8, 'Ola', 2010, 1, 14),
    (
        9,
        'Ola Electric',
        2017,
        1,
        16
    ),
    (10, 'Dunzo', 2015, 1, 15),
    (11, 'Zomato', 2008, 4, 3),
    (12, 'Paytm', 2010, 10, 4),
    (
        13,
        'Policybazaar',
        2008,
        4,
        7
    ),
    (14, 'Cars24', 2015, 4, 16),
    (15, 'Spinny', 2015, 4, 16),
    (16, 'BharatPe', 2018, 3, 4),
    (17, 'Licious', 2015, 1, 3),
    (
        18,
        'UrbanCompany',
        2014,
        4,
        17
    ),
    (19, 'Grofers', 2013, 4, 3),
    (20, 'BigBasket', 2011, 1, 3),
    (21, 'Byju''s', 2011, 1, 8),
    (22, 'Unacademy', 2015, 1, 8),
    (23, 'upGrad', 2015, 2, 8),
    (24, 'Vedantu', 2011, 1, 8),
    (25, 'Eruditus', 2010, 2, 8),
    (26, 'Cure.fit', 2016, 1, 13),
    (27, 'Pharmeasy', 2015, 2, 12),
    (28, 'Practo', 2008, 1, 11),
    (29, '1mg', 2015, 4, 12),
    (30, 'MobiKwik', 2009, 4, 4),
    (31, 'Pine Labs', 2010, 10, 4),
    (32, 'Delhivery', 2011, 4, 15),
    (33, 'Xpressbees', 2015, 5, 15),
    (34, 'Rivigo', 2014, 4, 15),
    (35, 'BlackBuck', 2015, 1, 15),
    (36, 'ShareChat', 2015, 1, 23),
    (37, 'Dream11', 2008, 2, 22),
    (38, 'Zerodha', 2010, 1, 5),
    (39, 'Groww', 2016, 1, 5),
    (
        40,
        'Digit Insurance',
        2016,
        1,
        7
    ),
    (41, 'Nykaa', 2012, 2, 2),
    (42, 'Purplle', 2012, 2, 2),
    (43, 'Lenskart', 2010, 4, 2),
    (44, 'FirstCry', 2010, 5, 2),
    (45, 'Pepperfry', 2011, 2, 1),
    (
        46,
        'Urban Ladder',
        2012,
        1,
        1
    ),
    (
        47,
        'Country Delight',
        2015,
        4,
        3
    ),
    (
        48,
        'Rebel Foods',
        2011,
        2,
        24
    ),
    (49, 'Box8', 2012, 2, 24),
    (50, 'FreshMenu', 2014, 1, 24),
    (51, 'OYO', 2013, 4, 25),
    (52, 'Treebo', 2015, 1, 25),
    (53, 'GoIbibo', 2007, 4, 25),
    (54, 'MakeMyTrip', 2000, 4, 25),
    (55, 'Rapido', 2015, 1, 14),
    (56, 'Bounce', 2014, 1, 14),
    (57, 'Vogo', 2016, 1, 14),
    (58, 'Zoomcar', 2013, 1, 16),
    (59, 'Drivezy', 2015, 1, 16),
    (60, 'Cityflo', 2015, 2, 14),
    (61, 'Porter', 2014, 1, 15),
    (62, 'Loadshare', 2017, 1, 15),
    (63, 'Shadowfax', 2015, 1, 15),
    (64, 'Pickrr', 2015, 4, 15),
    (65, 'Shiprocket', 2017, 3, 15),
    (66, 'Dukaan', 2020, 1, 17),
    (67, 'Instamojo', 2012, 1, 4),
    (68, 'Khatabook', 2018, 1, 17),
    (69, 'MyGate', 2016, 1, 17),
    (70, 'NoBroker', 2014, 1, 21),
    (
        71,
        'Housing.com',
        2012,
        2,
        21
    ),
    (
        72,
        'MagicBricks',
        2006,
        10,
        21
    ),
    (73, '99acres', 2005, 10, 21),
    (74, 'Nestaway', 2015, 1, 21),
    (75, 'DeHaat', 2012, 5, 19),
    (76, 'Ninjacart', 2015, 1, 19),
    (77, 'WayCool', 2015, 7, 20),
    (78, 'AgroStar', 2013, 5, 19),
    (79, 'Jumbotail', 2016, 1, 20),
    (80, 'Udaan (B2B)', 2016, 1, 1),
    (81, 'Moglix', 2015, 10, 1),
    (82, 'OfBusiness', 2016, 4, 1),
    (83, 'IndiaMart', 1996, 10, 1),
    (84, 'ShopClues', 2011, 4, 1),
    (85, 'Snapdeal', 2010, 3, 1),
    (86, 'Zilingo', 2015, 1, 2),
    (87, 'Bewakoof', 2012, 2, 2),
    (88, 'FabIndia', 2012, 3, 2),
    (89, 'Chumbak', 2010, 1, 2),
    (
        90,
        'The Souled Store',
        2013,
        2,
        2
    ),
    (91, 'Boat', 2016, 3, 1),
    (92, 'Noise', 2014, 4, 1),
    (93, 'Mamaearth', 2016, 4, 2),
    (
        94,
        'WOW Skin Science',
        2014,
        4,
        2
    ),
    (95, 'mCaffeine', 2016, 2, 2),
    (96, 'Sleepy Owl', 2016, 2, 3),
    (97, 'Wakefit', 2016, 1, 1),
    (
        98,
        'The Sleep Company',
        2019,
        1,
        1
    ),
    (99, 'Plix', 2020, 2, 13),
    (
        100,
        'HealthifyMe',
        2012,
        1,
        13
    );

-- ========================================
-- FOUNDERS (200+ founders - 2-3 per startup)
-- ========================================
INSERT INTO
    founders (
        Founder_ID,
        Name,
        Startup_ID,
        Role,
        Linkedin_url
    )
VALUES
    -- Flipkart (1)
    (
        1,
        'Sachin Bansal',
        1,
        'Co-Founder',
        'https://linkedin.com/in/bansalsachin'
    ),
    (
        2,
        'Binny Bansal',
        1,
        'Co-Founder',
        'https://linkedin.com/in/binnybansall'
    ),
    -- PhonePe (2)
    (
        3,
        'Sameer Nigam',
        2,
        'CEO & Co-Founder',
        'https://linkedin.com/in/sameernigam'
    ),
    (
        4,
        'Rahul Chari',
        2,
        'CTO & Co-Founder',
        'https://linkedin.com/in/rahulchari'
    ),
    -- Swiggy (3)
    (
        5,
        'Sriharsha Majety',
        3,
        'CEO & Co-Founder',
        'https://linkedin.com/in/smajety'
    ),
    (
        6,
        'Nandan Reddy',
        3,
        'Co-Founder',
        'https://linkedin.com/in/nandanreddy'
    ),
    (
        7,
        'Rahul Jaimini',
        3,
        'Co-Founder',
        'https://linkedin.com/in/rahuljaimini'
    ),
    -- Razorpay (4)
    (
        8,
        'Harshil Mathur',
        4,
        'CEO & Co-Founder',
        'https://linkedin.com/in/harshilmathur'
    ),
    (
        9,
        'Shashank Kumar',
        4,
        'Co-Founder',
        'https://linkedin.com/in/shashank99'
    ),
    -- CRED (5)
    (
        10,
        'Kunal Shah',
        5,
        'Founder & CEO',
        'https://linkedin.com/in/kunalshah'
    ),
    -- Meesho (6)
    (
        11,
        'Vidit Aatrey',
        6,
        'Co-Founder & CEO',
        'https://linkedin.com/in/viditatrey'
    ),
    (
        12,
        'Sanjeev Barnwal',
        6,
        'Co-Founder & CTO',
        'https://linkedin.com/in/sanjeevbarnwal'
    ),
    -- Udaan (7)
    (
        13,
        'Amod Malviya',
        7,
        'Co-Founder',
        'https://linkedin.com/in/amodmalviya'
    ),
    (
        14,
        'Sujeet Kumar',
        7,
        'Co-Founder',
        'https://linkedin.com/in/sujeetkr'
    ),
    (
        15,
        'Vaibhav Gupta',
        7,
        'Co-Founder',
        'https://linkedin.com/in/vaibhavguptaudaan'
    ),
    -- Ola (8)
    (
        16,
        'Bhavish Aggarwal',
        8,
        'Co-Founder & CEO',
        'https://linkedin.com/in/bhavishaggarwal'
    ),
    (
        17,
        'Ankit Bhati',
        8,
        'Co-Founder',
        'https://linkedin.com/in/ankitbhati'
    ),
    -- Ola Electric (9)
    (
        18,
        'Bhavish Aggarwal',
        9,
        'Founder & CEO',
        'https://linkedin.com/in/bhavishaggarwal'
    ),
    -- Dunzo (10)
    (
        19,
        'Kabeer Biswas',
        10,
        'CEO & Co-Founder',
        'https://linkedin.com/in/kabeerbiswas'
    ),
    (
        20,
        'Ankur Aggarwal',
        10,
        'Co-Founder',
        'https://linkedin.com/in/ankuraggarwaldunzo'
    ),
    -- Zomato (11)
    (
        21,
        'Deepinder Goyal',
        11,
        'Co-Founder & CEO',
        'https://linkedin.com/in/deepindergoyal'
    ),
    (
        22,
        'Pankaj Chaddah',
        11,
        'Co-Founder',
        'https://linkedin.com/in/pankajchaddah'
    ),
    -- Paytm (12)
    (
        23,
        'Vijay Shekhar Sharma',
        12,
        'Founder & CEO',
        'https://linkedin.com/in/vijayshekharsharma'
    ),
    -- Policybazaar (13)
    (
        24,
        'Yashish Dahiya',
        13,
        'Co-Founder & CEO',
        'https://linkedin.com/in/yashishdahiya'
    ),
    (
        25,
        'Alok Bansal',
        13,
        'Co-Founder',
        'https://linkedin.com/in/alokbansalpb'
    ),
    -- Cars24 (14)
    (
        26,
        'Vikram Chopra',
        14,
        'Co-Founder & CEO',
        'https://linkedin.com/in/vikramchopra24'
    ),
    (
        27,
        'Mehul Agrawal',
        14,
        'Co-Founder',
        'https://linkedin.com/in/mehulagrawalcars24'
    ),
    -- Spinny (15)
    (
        28,
        'Niraj Singh',
        15,
        'Co-Founder & CEO',
        'https://linkedin.com/in/nirajsinghspinny'
    ),
    (
        29,
        'Mohit Gupta',
        15,
        'Co-Founder',
        'https://linkedin.com/in/mohitguptaspinny'
    ),
    -- BharatPe (16)
    (
        30,
        'Ashneer Grover',
        16,
        'Co-Founder',
        'https://linkedin.com/in/ashneergrover'
    ),
    (
        31,
        'Shashvat Nakrani',
        16,
        'Co-Founder & CEO',
        'https://linkedin.com/in/shashvatnakrani'
    ),
    -- Licious (17)
    (
        32,
        'Vivek Gupta',
        17,
        'Co-Founder',
        'https://linkedin.com/in/vivekguptalicious'
    ),
    (
        33,
        'Abhay Hanjura',
        17,
        'Co-Founder',
        'https://linkedin.com/in/abhayhanjura'
    ),
    -- UrbanCompany (18)
    (
        34,
        'Abhiraj Bhal',
        18,
        'Co-Founder & CEO',
        'https://linkedin.com/in/abhirajbhal'
    ),
    (
        35,
        'Varun Khaitan',
        18,
        'Co-Founder',
        'https://linkedin.com/in/varunkhaitan'
    ),
    -- Grofers/Blinkit (19)
    (
        36,
        'Albinder Dhindsa',
        19,
        'Co-Founder & CEO',
        'https://linkedin.com/in/albinderdhindsa'
    ),
    (
        37,
        'Saurabh Kumar',
        19,
        'Co-Founder',
        'https://linkedin.com/in/saurabhkumarblinkit'
    ),
    -- BigBasket (20)
    (
        38,
        'Hari Menon',
        20,
        'Co-Founder & CEO',
        'https://linkedin.com/in/harimenon'
    ),
    (
        39,
        'VS Sudhakar',
        20,
        'Co-Founder',
        'https://linkedin.com/in/vssudhakar'
    ),
    -- Byju's (21)
    (
        40,
        'Byju Raveendran',
        21,
        'Founder & CEO',
        'https://linkedin.com/in/byjuraveendran'
    ),
    (
        41,
        'Divya Gokulnath',
        21,
        'Co-Founder',
        'https://linkedin.com/in/divyagokulnath'
    ),
    -- Unacademy (22)
    (
        42,
        'Gaurav Munjal',
        22,
        'Co-Founder & CEO',
        'https://linkedin.com/in/gauravmunjal'
    ),
    (
        43,
        'Roman Saini',
        22,
        'Co-Founder',
        'https://linkedin.com/in/romansaini'
    ),
    (
        44,
        'Hemesh Singh',
        22,
        'Co-Founder',
        'https://linkedin.com/in/hemeshsingh'
    ),
    -- upGrad (23)
    (
        45,
        'Ronnie Screwvala',
        23,
        'Co-Founder',
        'https://linkedin.com/in/ronniescrewvala'
    ),
    (
        46,
        'Mayank Kumar',
        23,
        'Co-Founder',
        'https://linkedin.com/in/mayankkumar'
    ),
    -- Vedantu (24)
    (
        47,
        'Vamsi Krishna',
        24,
        'Co-Founder & CEO',
        'https://linkedin.com/in/vamsikrishna'
    ),
    (
        48,
        'Anand Prakash',
        24,
        'Co-Founder',
        'https://linkedin.com/in/anandprakashvedantu'
    ),
    -- Eruditus (25)
    (
        49,
        'Ashwin Damera',
        25,
        'Co-Founder & CEO',
        'https://linkedin.com/in/ashwindamera'
    ),
    (
        50,
        'Chaitanya Kalipatnapu',
        25,
        'Co-Founder',
        'https://linkedin.com/in/chaitanyakalipatnapu'
    ),
    -- Cure.fit (26)
    (
        51,
        'Mukesh Bansal',
        26,
        'Co-Founder',
        'https://linkedin.com/in/mukeshbansal'
    ),
    (
        52,
        'Ankit Nagori',
        26,
        'Co-Founder',
        'https://linkedin.com/in/ankitnagori'
    ),
    -- Pharmeasy (27)
    (
        53,
        'Dharmil Sheth',
        27,
        'Co-Founder & CEO',
        'https://linkedin.com/in/dharmilsheth'
    ),
    (
        54,
        'Dhaval Shah',
        27,
        'Co-Founder',
        'https://linkedin.com/in/dhavalshah'
    ),
    -- Practo (28)
    (
        55,
        'Shashank ND',
        28,
        'Co-Founder & CEO',
        'https://linkedin.com/in/shashanknd'
    ),
    (
        56,
        'Abhinav Lal',
        28,
        'Co-Founder & CTO',
        'https://linkedin.com/in/abhinavlal'
    ),
    -- 1mg (29)
    (
        57,
        'Prashant Tandon',
        29,
        'Co-Founder & CEO',
        'https://linkedin.com/in/prashanttandon'
    ),
    (
        58,
        'Gaurav Agarwal',
        29,
        'Co-Founder',
        'https://linkedin.com/in/gaurav1mg'
    ),
    -- MobiKwik (30)
    (
        59,
        'Bipin Preet Singh',
        30,
        'Co-Founder & CEO',
        'https://linkedin.com/in/bipinpreetsingh'
    ),
    (
        60,
        'Upasana Taku',
        30,
        'Co-Founder',
        'https://linkedin.com/in/upasanataku'
    ),
    -- Continuing with more founders for remaining startups (31-100)
    (
        61,
        'Lokvir Kapoor',
        31,
        'Chairman',
        'https://linkedin.com/in/lokvirkapoor'
    ),
    (
        62,
        'Rajesh Yabaji',
        31,
        'CEO',
        'https://linkedin.com/in/rajeshyabaji'
    ),
    (
        63,
        'Sahil Barua',
        32,
        'Co-Founder & CEO',
        'https://linkedin.com/in/sahilbarua'
    ),
    (
        64,
        'Mohit Tandon',
        32,
        'Co-Founder',
        'https://linkedin.com/in/mohittandon'
    ),
    (
        65,
        'Amitava Saha',
        33,
        'Co-Founder & CEO',
        'https://linkedin.com/in/amitavasaha'
    ),
    (
        66,
        'Deepak Garg',
        34,
        'Founder & CEO',
        'https://linkedin.com/in/deepakgargrivigo'
    ),
    (
        67,
        'Rajesh Yabaji',
        35,
        'Co-Founder',
        'https://linkedin.com/in/rajeshyabaji'
    ),
    (
        68,
        'Chandradeep Kumar',
        35,
        'Co-Founder',
        'https://linkedin.com/in/chandradeepkumar'
    ),
    (
        69,
        'Ankush Sachdeva',
        36,
        'Co-Founder & CEO',
        'https://linkedin.com/in/ankushsachdeva'
    ),
    (
        70,
        'Bhanu Singh',
        36,
        'Co-Founder',
        'https://linkedin.com/in/bhanusingh'
    ),
    (
        71,
        'Harsh Jain',
        37,
        'Co-Founder & CEO',
        'https://linkedin.com/in/harshjain'
    ),
    (
        72,
        'Bhavit Sheth',
        37,
        'Co-Founder',
        'https://linkedin.com/in/bhavitsheth'
    ),
    (
        73,
        'Nithin Kamath',
        38,
        'Founder & CEO',
        'https://linkedin.com/in/nithinkamath'
    ),
    (
        74,
        'Nikhil Kamath',
        38,
        'Co-Founder',
        'https://linkedin.com/in/nikhilkamath'
    ),
    (
        75,
        'Lalit Keshre',
        39,
        'Co-Founder & CEO',
        'https://linkedin.com/in/lalitkeshre'
    ),
    (
        76,
        'Harsh Jain',
        39,
        'Co-Founder',
        'https://linkedin.com/in/harshjain'
    ),
    (
        77,
        'Kamesh Goyal',
        40,
        'Founder & CEO',
        'https://linkedin.com/in/kameshgoyal'
    ),
    (
        78,
        'Falguni Nayar',
        41,
        'Founder & CEO',
        'https://linkedin.com/in/falguninayar'
    ),
    (
        79,
        'Manish Taneja',
        42,
        'Co-Founder & CEO',
        'https://linkedin.com/in/manishtaneja'
    ),
    (
        80,
        'Suyash Katyayani',
        42,
        'Co-Founder',
        'https://linkedin.com/in/suyashkatyayani'
    ),
    (
        81,
        'Peyush Bansal',
        43,
        'Founder & CEO',
        'https://linkedin.com/in/peyushbansal'
    ),
    (
        82,
        'Supam Maheshwari',
        44,
        'Founder & CEO',
        'https://linkedin.com/in/supammaheshwari'
    ),
    (
        83,
        'Ambareesh Murty',
        45,
        'Co-Founder & CEO',
        'https://linkedin.com/in/ambareshmurty'
    ),
    (
        84,
        'Ashish Shah',
        45,
        'Co-Founder',
        'https://linkedin.com/in/ashishshah'
    ),
    (
        85,
        'Ashish Goel',
        46,
        'Co-Founder & CEO',
        'https://linkedin.com/in/ashishgoel'
    ),
    (
        86,
        'Rajiv Srivatsa',
        46,
        'Co-Founder',
        'https://linkedin.com/in/rajivsrivatsa'
    ),
    (
        87,
        'Chakradhar Gade',
        47,
        'Co-Founder & CEO',
        'https://linkedin.com/in/chakradhargade'
    ),
    (
        88,
        'Kallol Banerjee',
        48,
        'Co-Founder',
        'https://linkedin.com/in/kallolbanerjee'
    ),
    (
        89,
        'Jaydeep Barman',
        48,
        'Founder & CEO',
        'https://linkedin.com/in/jaydeepbarman'
    ),
    (
        90,
        'Anurag Mehrotra',
        49,
        'Co-Founder & CEO',
        'https://linkedin.com/in/anuragmehrotra'
    ),
    (
        91,
        'Rashmi Daga',
        50,
        'Founder & CEO',
        'https://linkedin.com/in/rashmidaga'
    ),
    (
        92,
        'Ritesh Agarwal',
        51,
        'Founder & CEO',
        'https://linkedin.com/in/riteshagarwal'
    ),
    (
        93,
        'Sidharth Gupta',
        52,
        'Co-Founder',
        'https://linkedin.com/in/sidharthgupta'
    ),
    (
        94,
        'Rahul Garg',
        52,
        'Co-Founder',
        'https://linkedin.com/in/rahulgarg'
    ),
    (
        95,
        'Ashish Kashyap',
        53,
        'Founder',
        'https://linkedin.com/in/ashishkashyap'
    ),
    (
        96,
        'Deep Kalra',
        54,
        'Founder & Chairman',
        'https://linkedin.com/in/deepkalra'
    ),
    (
        97,
        'Rajesh Magow',
        54,
        'CEO',
        'https://linkedin.com/in/rajeshmagow'
    ),
    (
        98,
        'Aravind Sanka',
        55,
        'Co-Founder & CEO',
        'https://linkedin.com/in/aravindsanka'
    ),
    (
        99,
        'Pavan Guntupalli',
        55,
        'Co-Founder',
        'https://linkedin.com/in/pavanguntupalli'
    ),
    (
        100,
        'Vivekananda HR',
        56,
        'Co-Founder & CEO',
        'https://linkedin.com/in/vivekanandahr'
    ),
    (
        101,
        'Anil G',
        56,
        'Co-Founder',
        'https://linkedin.com/in/anilg'
    ),
    (
        102,
        'Anand Ayyadurai',
        57,
        'Co-Founder & CEO',
        'https://linkedin.com/in/anandayyadurai'
    ),
    (
        103,
        'Padmanabhan Balakrishnan',
        57,
        'Co-Founder & CTO',
        'https://linkedin.com/in/padmanabhanb'
    ),
    (
        104,
        'Greg Moran',
        58,
        'Co-Founder & CEO',
        'https://linkedin.com/in/gregmoran'
    ),
    (
        105,
        'David Back',
        58,
        'Co-Founder',
        'https://linkedin.com/in/davidback'
    ),
    (
        106,
        'Ashwarya Singh',
        59,
        'Co-Founder',
        'https://linkedin.com/in/ashwaryasingh'
    ),
    (
        107,
        'Jitendra Goel',
        60,
        'Founder & CEO',
        'https://linkedin.com/in/jitendragoel'
    ),
    (
        108,
        'Pranav Goel',
        60,
        'Co-Founder',
        'https://linkedin.com/in/pranavgoel'
    ),
    (
        109,
        'Uttam Digga',
        61,
        'Co-Founder & CEO',
        'https://linkedin.com/in/uttamdigga'
    ),
    (
        110,
        'Pranav Goel',
        61,
        'Co-Founder',
        'https://linkedin.com/in/pranavgoel'
    ),
    (
        111,
        'Gaurav Kumar',
        62,
        'Founder & CEO',
        'https://linkedin.com/in/gauravkumar'
    ),
    (
        112,
        'Abhishek Bansal',
        63,
        'Co-Founder & CEO',
        'https://linkedin.com/in/abhishekbansal'
    ),
    (
        113,
        'Vaibhav Khandelwal',
        63,
        'Co-Founder',
        'https://linkedin.com/in/vaibhavkhandelwal'
    ),
    (
        114,
        'Gaurav Mangla',
        64,
        'Co-Founder & CEO',
        'https://linkedin.com/in/gauravmangla'
    ),
    (
        115,
        'Rhitiman Majumder',
        64,
        'Co-Founder',
        'https://linkedin.com/in/rhitimanmajumder'
    ),
    (
        116,
        'Saahil Goel',
        65,
        'Co-Founder & CEO',
        'https://linkedin.com/in/saahilgoel'
    ),
    (
        117,
        'Akshay Ghulati',
        65,
        'Co-Founder',
        'https://linkedin.com/in/akshayghulati'
    ),
    (
        118,
        'Subhash Choudhary',
        66,
        'Founder & CEO',
        'https://linkedin.com/in/subhashchoudhary'
    ),
    (
        119,
        'Sameer Saxena',
        67,
        'Co-Founder & CEO',
        'https://linkedin.com/in/sameersaxena'
    ),
    (
        120,
        'Aditya Sengupta',
        67,
        'Co-Founder',
        'https://linkedin.com/in/adityasengupta'
    ),
    (
        121,
        'Ravish Naresh',
        68,
        'Co-Founder & CEO',
        'https://linkedin.com/in/ravishnaresh'
    ),
    (
        122,
        'Vaibhav Kakkar',
        68,
        'Co-Founder',
        'https://linkedin.com/in/vaibhavkakkar'
    ),
    (
        123,
        'Abhishek Kumar',
        69,
        'Co-Founder & CEO',
        'https://linkedin.com/in/abhishekkumar'
    ),
    (
        124,
        'Vijay Arisetty',
        69,
        'Co-Founder & CTO',
        'https://linkedin.com/in/vijayarisetty'
    ),
    (
        125,
        'Amit Kumar Agarwal',
        70,
        'Founder & CEO',
        'https://linkedin.com/in/amitkumaragarwal'
    ),
    (
        126,
        'Akhil Gupta',
        70,
        'Co-Founder & CTO',
        'https://linkedin.com/in/akhilgupta'
    ),
    (
        127,
        'Rahul Yadav',
        71,
        'Founder',
        'https://linkedin.com/in/rahulyadav'
    ),
    (
        128,
        'Advitiya Sharma',
        71,
        'Co-Founder',
        'https://linkedin.com/in/advitiyasharma'
    ),
    (
        129,
        'Sudhir Pai',
        72,
        'CEO',
        'https://linkedin.com/in/sudhirpai'
    ),
    (
        130,
        'Vikas Malpani',
        73,
        'CEO',
        'https://linkedin.com/in/vikasmalpani'
    ),
    (
        131,
        'Amarendra Sahu',
        74,
        'Co-Founder & CEO',
        'https://linkedin.com/in/amarendrasahu'
    ),
    (
        132,
        'Jitendra Jagadev',
        74,
        'Co-Founder',
        'https://linkedin.com/in/jitendrajagadev'
    ),
    (
        133,
        'Shashank Kumar',
        75,
        'Co-Founder & CEO',
        'https://linkedin.com/in/shashankkumar'
    ),
    (
        134,
        'Shyam Sundar',
        75,
        'Co-Founder',
        'https://linkedin.com/in/shyamsundar'
    ),
    (
        135,
        'Thirukumaran Nagarajan',
        76,
        'Co-Founder & CEO',
        'https://linkedin.com/in/thirukumaran'
    ),
    (
        136,
        'Sharath Loganathan',
        76,
        'Co-Founder',
        'https://linkedin.com/in/sharathloganathan'
    ),
    (
        137,
        'Karthik Jayaraman',
        77,
        'Co-Founder & CEO',
        'https://linkedin.com/in/karthikjayaraman'
    ),
    (
        138,
        'Sanjay Dasari',
        77,
        'Co-Founder',
        'https://linkedin.com/in/sanjaydasari'
    ),
    (
        139,
        'Shardul Sheth',
        78,
        'Founder & CEO',
        'https://linkedin.com/in/shardulsheth'
    ),
    (
        140,
        'Sitanshu Sheth',
        78,
        'Co-Founder',
        'https://linkedin.com/in/sitanshusheth'
    ),
    (
        141,
        'Karthik Venkateswaran',
        79,
        'Founder & CEO',
        'https://linkedin.com/in/karthikvenkateswaran'
    ),
    (
        142,
        'Ashish Jhina',
        79,
        'Co-Founder',
        'https://linkedin.com/in/ashishjhina'
    ),
    (
        143,
        'Vaibhav Gupta',
        80,
        'Co-Founder & CEO',
        'https://linkedin.com/in/vaibhavgupta'
    ),
    (
        144,
        'Rahul Garg',
        81,
        'Founder & CEO',
        'https://linkedin.com/in/rahulgarg'
    ),
    (
        145,
        'Asish Mohapatra',
        82,
        'Co-Founder & CEO',
        'https://linkedin.com/in/asishmohapatra'
    ),
    (
        146,
        'Ruchi Kalra',
        82,
        'Co-Founder',
        'https://linkedin.com/in/ruchikalra'
    ),
    (
        147,
        'Dinesh Agarwal',
        83,
        'Founder & CEO',
        'https://linkedin.com/in/dineshagarwal'
    ),
    (
        148,
        'Brijesh Agrawal',
        83,
        'Co-Founder',
        'https://linkedin.com/in/brijeshagrawal'
    ),
    (
        149,
        'Sanjay Sethi',
        84,
        'Co-Founder & CEO',
        'https://linkedin.com/in/sanjaysethi'
    ),
    (
        150,
        'Sandeep Aggarwal',
        84,
        'Founder',
        'https://linkedin.com/in/sandeepaggarwal'
    ),
    (
        151,
        'Kunal Bahl',
        85,
        'Co-Founder & CEO',
        'https://linkedin.com/in/kunalbahl'
    ),
    (
        152,
        'Rohit Bansal',
        85,
        'Co-Founder',
        'https://linkedin.com/in/rohitbansal'
    ),
    (
        153,
        'Ankiti Bose',
        86,
        'Founder & CEO',
        'https://linkedin.com/in/ankitibose'
    ),
    (
        154,
        'Dhruv Sahu',
        86,
        'Co-Founder',
        'https://linkedin.com/in/dhruvsahu'
    ),
    (
        155,
        'Prabhkiran Singh',
        87,
        'Founder & CEO',
        'https://linkedin.com/in/prabhkiransingh'
    ),
    (
        156,
        'Siddharth Munot',
        87,
        'Co-Founder',
        'https://linkedin.com/in/siddharthmunot'
    ),
    (
        157,
        'Sunil Chainani',
        88,
        'CEO',
        'https://linkedin.com/in/sunilchainani'
    ),
    (
        158,
        'Vivek Prabhakar',
        89,
        'Co-Founder & CEO',
        'https://linkedin.com/in/vivekprabhakar'
    ),
    (
        159,
        'Shubhra Chadda',
        89,
        'Co-Founder',
        'https://linkedin.com/in/shubhrachadda'
    ),
    (
        160,
        'Rohin Malhotra',
        90,
        'Co-Founder',
        'https://linkedin.com/in/rohinmalhotra'
    ),
    (
        161,
        'Harsh Malhotra',
        90,
        'Co-Founder',
        'https://linkedin.com/in/harshmalhotra'
    ),
    (
        162,
        'Aman Gupta',
        91,
        'Co-Founder & CMO',
        'https://linkedin.com/in/amangupta'
    ),
    (
        163,
        'Sameer Mehta',
        91,
        'Co-Founder & CEO',
        'https://linkedin.com/in/sameermehta'
    ),
    (
        164,
        'Gaurav Khatri',
        92,
        'Co-Founder & CEO',
        'https://linkedin.com/in/gauravkhatri'
    ),
    (
        165,
        'Amit Khatri',
        92,
        'Co-Founder',
        'https://linkedin.com/in/amitkhatri'
    ),
    (
        166,
        'Varun Alagh',
        93,
        'Co-Founder & CEO',
        'https://linkedin.com/in/varunalagh'
    ),
    (
        167,
        'Ghazal Alagh',
        93,
        'Co-Founder & CIO',
        'https://linkedin.com/in/ghazalalagh'
    ),
    (
        168,
        'Manish Chowdhary',
        94,
        'Founder & CEO',
        'https://linkedin.com/in/manishchowdhary'
    ),
    (
        169,
        'Tarun Sharma',
        95,
        'Founder & CEO',
        'https://linkedin.com/in/tarunsharma'
    ),
    (
        170,
        'Arman Sood',
        96,
        'Co-Founder',
        'https://linkedin.com/in/armansood'
    ),
    (
        171,
        'Sanjay Ganpath',
        96,
        'Co-Founder',
        'https://linkedin.com/in/sanjayganpath'
    ),
    (
        172,
        'Ankit Garg',
        97,
        'Founder & CEO',
        'https://linkedin.com/in/ankitgarg'
    ),
    (
        173,
        'Chaitanya Ramalingegowda',
        97,
        'Co-Founder',
        'https://linkedin.com/in/chaitanyar'
    ),
    (
        174,
        'Priyanka Salot',
        98,
        'Co-Founder & CEO',
        'https://linkedin.com/in/priyankalot'
    ),
    (
        175,
        'Uttam Malani',
        98,
        'Co-Founder',
        'https://linkedin.com/in/uttammalani'
    ),
    (
        176,
        'Rishubh Satiya',
        99,
        'Founder & CEO',
        'https://linkedin.com/in/rishubhsatiya'
    ),
    (
        177,
        'Tushar Vashisht',
        100,
        'Co-Founder & CEO',
        'https://linkedin.com/in/tusharvashisht'
    ),
    (
        178,
        'Mathew Cherian',
        100,
        'Co-Founder',
        'https://linkedin.com/in/mathewcherian'
    );

-- ========================================
-- INVESTORS (50 investors)
-- ========================================
INSERT INTO
    investors (
        Investor_ID,
        Name,
        Type,
        Country_ID
    )
VALUES (
        1,
        'Sequoia Capital India',
        'VC Firm',
        1
    ),
    (
        2,
        'Accel Partners',
        'VC Firm',
        2
    ),
    (
        3,
        'Tiger Global',
        'Private Equity',
        2
    ),
    (
        4,
        'SoftBank Vision Fund',
        'VC Firm',
        6
    ),
    (
        5,
        'Lightspeed Venture Partners',
        'VC Firm',
        2
    ),
    (
        6,
        'Matrix Partners India',
        'VC Firm',
        1
    ),
    (
        7,
        'Nexus Venture Partners',
        'VC Firm',
        1
    ),
    (
        8,
        'Blume Ventures',
        'VC Firm',
        1
    ),
    (
        9,
        'Kalaari Capital',
        'VC Firm',
        1
    ),
    (
        10,
        'SAIF Partners',
        'VC Firm',
        1
    ),
    (
        11,
        'Elevation Capital',
        'VC Firm',
        1
    ),
    (
        12,
        'Chiratae Ventures',
        'VC Firm',
        1
    ),
    (
        13,
        'Y Combinator',
        'Accelerator',
        2
    ),
    (
        14,
        'Bessemer Venture Partners',
        'VC Firm',
        2
    ),
    (
        15,
        'Ribbit Capital',
        'VC Firm',
        2
    ),
    (
        16,
        'Info Edge Ventures',
        'Corporate VC',
        1
    ),
    (
        17,
        'Warburg Pincus',
        'Private Equity',
        2
    ),
    (
        18,
        'General Atlantic',
        'Private Equity',
        2
    ),
    (
        19,
        'KKR',
        'Private Equity',
        2
    ),
    (
        20,
        'TPG Capital',
        'Private Equity',
        2
    ),
    (
        21,
        'Temasek Holdings',
        'Sovereign Wealth',
        4
    ),
    (
        22,
        'GIC',
        'Sovereign Wealth',
        4
    ),
    (
        23,
        'Prosus Ventures',
        'Corporate VC',
        3
    ),
    (
        24,
        'Tencent',
        'Corporate VC',
        5
    ),
    (
        25,
        'Alibaba Group',
        'Corporate VC',
        5
    ),
    (
        26,
        'Google Capital',
        'Corporate VC',
        2
    ),
    (
        27,
        'Amazon Ventures',
        'Corporate VC',
        2
    ),
    (
        28,
        'Walmart Global Tech',
        'Corporate VC',
        2
    ),
    (
        29,
        'Flipkart Ventures',
        'Corporate VC',
        1
    ),
    (
        30,
        'Unilever Ventures',
        'Corporate VC',
        3
    ),
    (
        31,
        'Naspers',
        'Corporate VC',
        3
    ),
    (
        32,
        'Falcon Edge Capital',
        'Private Equity',
        2
    ),
    (
        33,
        'Steadview Capital',
        'Private Equity',
        3
    ),
    (
        34,
        'Coatue Management',
        'Private Equity',
        2
    ),
    (
        35,
        'DST Global',
        'VC Firm',
        3
    ),
    (
        36,
        'Insight Partners',
        'Private Equity',
        2
    ),
    (
        37,
        'Wellington Management',
        'Asset Management',
        2
    ),
    (
        38,
        'Fidelity Investments',
        'Asset Management',
        2
    ),
    (
        39,
        'T. Rowe Price',
        'Asset Management',
        2
    ),
    (
        40,
        'Alpha Wave Incubation',
        'VC Firm',
        2
    ),
    (
        41,
        'Peak XV Partners',
        'VC Firm',
        1
    ),
    (
        42,
        'India Quotient',
        'VC Firm',
        1
    ),
    (
        43,
        'Venture Highway',
        'VC Firm',
        1
    ),
    (
        44,
        'Fireside Ventures',
        'VC Firm',
        1
    ),
    (
        45,
        '3one4 Capital',
        'VC Firm',
        1
    ),
    (
        46,
        'Arkam Ventures',
        'VC Firm',
        1
    ),
    (
        47,
        'Omnivore Partners',
        'VC Firm',
        1
    ),
    (
        48,
        'Inflexor Ventures',
        'VC Firm',
        1
    ),
    (
        49,
        'Saama Capital',
        'VC Firm',
        1
    ),
    (
        50,
        'Prime Venture Partners',
        'VC Firm',
        1
    );

-- ========================================
-- FUNDING ROUNDS (150+ funding rounds)
-- ========================================
INSERT INTO
    funding_rounds (
        Round_ID,
        Startup_ID,
        Date,
        Amount,
        Stage
    )
VALUES
    -- Major rounds for top startups
    (
        1,
        1,
        '2014-05-20',
        1000000000,
        'Series F'
    ),
    (
        2,
        1,
        '2017-08-09',
        2500000000,
        'Series J'
    ),
    (
        3,
        2,
        '2020-11-15',
        700000000,
        'Series B'
    ),
    (
        4,
        2,
        '2022-12-03',
        850000000,
        'Series C'
    ),
    (
        5,
        3,
        '2016-02-10',
        80000000,
        'Series C'
    ),
    (
        6,
        3,
        '2018-12-21',
        1000000000,
        'Series H'
    ),
    (
        7,
        3,
        '2021-01-13',
        800000000,
        'Series J'
    ),
    (
        8,
        4,
        '2015-04-03',
        11500000,
        'Series A'
    ),
    (
        9,
        4,
        '2019-06-19',
        75000000,
        'Series C'
    ),
    (
        10,
        4,
        '2020-10-18',
        100000000,
        'Series D'
    ),
    (
        11,
        4,
        '2021-12-03',
        375000000,
        'Series E'
    ),
    (
        12,
        5,
        '2018-10-30',
        120000000,
        'Series A'
    ),
    (
        13,
        5,
        '2021-01-26',
        215000000,
        'Series D'
    ),
    (
        14,
        6,
        '2019-06-15',
        125000000,
        'Series D'
    ),
    (
        15,
        6,
        '2021-04-05',
        300000000,
        'Series E'
    ),
    (
        16,
        7,
        '2018-09-02',
        225000000,
        'Series C'
    ),
    (
        17,
        8,
        '2014-10-27',
        210000000,
        'Series D'
    ),
    (
        18,
        8,
        '2015-11-17',
        500000000,
        'Series E'
    ),
    (
        19,
        9,
        '2019-02-22',
        250000000,
        'Series B'
    ),
    (
        20,
        9,
        '2021-09-06',
        200000000,
        'Series C'
    ),
    (
        21,
        10,
        '2019-10-22',
        45000000,
        'Series D'
    ),
    (
        22,
        11,
        '2015-04-20',
        60000000,
        'Series E'
    ),
    (
        23,
        11,
        '2018-10-16',
        210000000,
        'Series H'
    ),
    (
        24,
        11,
        '2021-07-22',
        250000000,
        'IPO'
    ),
    (
        25,
        12,
        '2015-03-03',
        680000000,
        'Series C'
    ),
    (
        26,
        12,
        '2017-05-15',
        1400000000,
        'Series E'
    ),
    (
        27,
        13,
        '2018-06-28',
        200000000,
        'Series E'
    ),
    (
        28,
        13,
        '2021-11-18',
        350000000,
        'IPO'
    ),
    (
        29,
        14,
        '2018-11-30',
        100000000,
        'Series C'
    ),
    (
        30,
        14,
        '2020-09-16',
        200000000,
        'Series D'
    ),
    (
        31,
        15,
        '2019-07-23',
        65000000,
        'Series C'
    ),
    (
        32,
        15,
        '2021-04-15',
        283000000,
        'Series E'
    ),
    (
        33,
        16,
        '2019-02-25',
        75000000,
        'Series B'
    ),
    (
        34,
        16,
        '2020-07-30',
        108000000,
        'Series C'
    ),
    (
        35,
        17,
        '2019-01-29',
        30000000,
        'Series C'
    ),
    (
        36,
        17,
        '2021-04-22',
        192000000,
        'Series F'
    ),
    (
        37,
        18,
        '2018-09-20',
        75000000,
        'Series D'
    ),
    (
        38,
        18,
        '2021-03-15',
        255000000,
        'Series F'
    ),
    (
        39,
        19,
        '2020-08-10',
        120000000,
        'Series E'
    ),
    (
        40,
        19,
        '2021-12-13',
        100000000,
        'Series F'
    ),
    (
        41,
        20,
        '2019-03-12',
        150000000,
        'Series E'
    ),
    (
        42,
        20,
        '2021-03-24',
        200000000,
        'Series F'
    ),
    (
        43,
        21,
        '2016-09-19',
        75000000,
        'Series C'
    ),
    (
        44,
        21,
        '2019-12-17',
        200000000,
        'Series E'
    ),
    (
        45,
        21,
        '2021-06-04',
        300000000,
        'Series F'
    ),
    (
        46,
        22,
        '2018-02-28',
        11500000,
        'Series B'
    ),
    (
        47,
        22,
        '2020-02-12',
        110000000,
        'Series E'
    ),
    (
        48,
        23,
        '2019-08-21',
        120000000,
        'Series D'
    ),
    (
        49,
        24,
        '2017-05-08',
        11000000,
        'Series B'
    ),
    (
        50,
        24,
        '2020-07-16',
        100000000,
        'Series D'
    ),
    (
        51,
        25,
        '2019-01-17',
        40000000,
        'Series C'
    ),
    (
        52,
        25,
        '2021-08-06',
        650000000,
        'Series E'
    ),
    (
        53,
        26,
        '2019-03-29',
        120000000,
        'Series C'
    ),
    (
        54,
        26,
        '2021-06-24',
        255000000,
        'Series D'
    ),
    (
        55,
        27,
        '2019-04-16',
        50000000,
        'Series C'
    ),
    (
        56,
        27,
        '2020-07-14',
        220000000,
        'Series E'
    ),
    (
        57,
        28,
        '2017-01-23',
        55000000,
        'Series C'
    ),
    (
        58,
        28,
        '2019-04-30',
        27000000,
        'Series D'
    ),
    (
        59,
        29,
        '2018-08-06',
        15000000,
        'Series B'
    ),
    (
        60,
        29,
        '2020-03-04',
        41000000,
        'Series C'
    ),
    (
        61,
        30,
        '2016-04-11',
        40000000,
        'Series C'
    ),
    (
        62,
        30,
        '2021-08-16',
        20000000,
        'Series D'
    ),
    (
        63,
        31,
        '2018-10-09',
        125000000,
        'Series C'
    ),
    (
        64,
        31,
        '2020-01-20',
        185000000,
        'Series D'
    ),
    (
        65,
        32,
        '2017-03-27',
        100000000,
        'Series D'
    ),
    (
        66,
        32,
        '2019-05-06',
        413000000,
        'Series F'
    ),
    (
        67,
        33,
        '2018-05-14',
        90000000,
        'Series C'
    ),
    (
        68,
        34,
        '2017-08-21',
        50000000,
        'Series C'
    ),
    (
        69,
        35,
        '2019-02-12',
        70000000,
        'Series D'
    ),
    (
        70,
        36,
        '2019-08-11',
        100000000,
        'Series D'
    ),
    (
        71,
        36,
        '2021-04-07',
        502000000,
        'Series E'
    ),
    (
        72,
        37,
        '2019-04-09',
        60000000,
        'Series C'
    ),
    (
        73,
        37,
        '2020-09-15',
        225000000,
        'Series D'
    ),
    (
        74,
        38,
        '2018-05-17',
        45000000,
        'Series C'
    ),
    (
        75,
        39,
        '2020-04-22',
        83000000,
        'Series C'
    ),
    (
        76,
        39,
        '2021-10-26',
        251000000,
        'Series E'
    ),
    (
        77,
        40,
        '2019-01-09',
        84000000,
        'Series B'
    ),
    (
        78,
        40,
        '2021-01-15',
        200000000,
        'Series D'
    ),
    (
        79,
        41,
        '2020-04-13',
        13500000,
        'Series A'
    ),
    (
        80,
        41,
        '2021-11-10',
        540000000,
        'IPO'
    ),
    (
        81,
        42,
        '2019-07-02',
        30000000,
        'Series C'
    ),
    (
        82,
        43,
        '2019-01-29',
        95000000,
        'Series E'
    ),
    (
        83,
        43,
        '2020-12-17',
        220000000,
        'Series F'
    ),
    (
        84,
        44,
        '2018-03-15',
        65000000,
        'Series D'
    ),
    (
        85,
        45,
        '2018-08-28',
        25000000,
        'Series C'
    ),
    (
        86,
        46,
        '2017-06-13',
        21000000,
        'Series C'
    ),
    (
        87,
        47,
        '2020-01-08',
        30000000,
        'Series B'
    ),
    (
        88,
        48,
        '2018-05-03',
        125000000,
        'Series C'
    ),
    (
        89,
        48,
        '2021-05-18',
        175000000,
        'Series D'
    ),
    (
        90,
        49,
        '2017-11-22',
        6000000,
        'Series B'
    ),
    (
        91,
        50,
        '2018-07-10',
        15000000,
        'Series A'
    ),
    (
        92,
        51,
        '2015-07-25',
        100000000,
        'Series B'
    ),
    (
        93,
        51,
        '2019-09-25',
        1500000000,
        'Series F'
    ),
    (
        94,
        52,
        '2017-03-14',
        17000000,
        'Series B'
    ),
    (
        95,
        53,
        '2016-05-20',
        180000000,
        'Series C'
    ),
    (
        96,
        54,
        '2017-10-24',
        330000000,
        'Series E'
    ),
    (
        97,
        55,
        '2019-09-04',
        11000000,
        'Series B'
    ),
    (
        98,
        55,
        '2021-08-10',
        180000000,
        'Series D'
    ),
    (
        99,
        56,
        '2018-10-02',
        105000000,
        'Series D'
    ),
    (
        100,
        57,
        '2019-06-18',
        23000000,
        'Series B'
    ),
    (
        101,
        58,
        '2018-04-11',
        40000000,
        'Series D'
    ),
    (
        102,
        59,
        '2018-08-07',
        20000000,
        'Series B'
    ),
    (
        103,
        60,
        '2019-12-09',
        22000000,
        'Series A'
    ),
    (
        104,
        61,
        '2019-07-11',
        25000000,
        'Series C'
    ),
    (
        105,
        62,
        '2020-02-18',
        16000000,
        'Series A'
    ),
    (
        106,
        63,
        '2019-01-07',
        60000000,
        'Series C'
    ),
    (
        107,
        64,
        '2020-03-16',
        12000000,
        'Series B'
    ),
    (
        108,
        65,
        '2019-09-19',
        27500000,
        'Series C'
    ),
    (
        109,
        66,
        '2021-06-01',
        6500000,
        'Series A'
    ),
    (
        110,
        67,
        '2017-12-05',
        7000000,
        'Series B'
    ),
    (
        111,
        68,
        '2020-01-20',
        25000000,
        'Series A'
    ),
    (
        112,
        69,
        '2019-05-13',
        10000000,
        'Series B'
    ),
    (
        113,
        70,
        '2018-11-06',
        51000000,
        'Series D'
    ),
    (
        114,
        71,
        '2017-01-11',
        90000000,
        'Series C'
    ),
    (
        115,
        72,
        '2016-08-23',
        35000000,
        'Series C'
    ),
    (
        116,
        73,
        '2017-04-19',
        30000000,
        'Series C'
    ),
    (
        117,
        74,
        '2019-03-05',
        30000000,
        'Series C'
    ),
    (
        118,
        75,
        '2019-06-25',
        12000000,
        'Series A'
    ),
    (
        119,
        75,
        '2021-09-14',
        115000000,
        'Series C'
    ),
    (
        120,
        76,
        '2019-01-15',
        30000000,
        'Series B'
    ),
    (
        121,
        77,
        '2019-04-17',
        117000000,
        'Series C'
    ),
    (
        122,
        78,
        '2018-07-24',
        27000000,
        'Series C'
    ),
    (
        123,
        79,
        '2019-12-19',
        14500000,
        'Series A'
    ),
    (
        124,
        80,
        '2018-10-17',
        50000000,
        'Series B'
    ),
    (
        125,
        81,
        '2018-06-12',
        60000000,
        'Series C'
    ),
    (
        126,
        82,
        '2020-07-09',
        200000000,
        'Series D'
    ),
    (
        127,
        83,
        '2018-03-28',
        75000000,
        'Series C'
    ),
    (
        128,
        84,
        '2017-09-06',
        25000000,
        'Series C'
    ),
    (
        129,
        85,
        '2017-02-13',
        200000000,
        'Series D'
    ),
    (
        130,
        86,
        '2019-02-19',
        54000000,
        'Series C'
    ),
    (
        131,
        87,
        '2020-08-25',
        5500000,
        'Series A'
    ),
    (
        132,
        88,
        '2019-11-12',
        8000000,
        'Seed'
    ),
    (
        133,
        89,
        '2018-05-29',
        6000000,
        'Series A'
    ),
    (
        134,
        90,
        '2019-07-16',
        10000000,
        'Series B'
    ),
    (
        135,
        91,
        '2020-11-01',
        100000000,
        'Series C'
    ),
    (
        136,
        92,
        '2020-12-08',
        10000000,
        'Series A'
    ),
    (
        137,
        93,
        '2020-01-22',
        35000000,
        'Series C'
    ),
    (
        138,
        93,
        '2022-01-12',
        52000000,
        'Series D'
    ),
    (
        139,
        94,
        '2019-04-25',
        12000000,
        'Series A'
    ),
    (
        140,
        95,
        '2021-03-09',
        7000000,
        'Series A'
    ),
    (
        141,
        96,
        '2020-09-22',
        5000000,
        'Seed'
    ),
    (
        142,
        97,
        '2020-03-17',
        27000000,
        'Series A'
    ),
    (
        143,
        98,
        '2021-08-24',
        8000000,
        'Seed'
    ),
    (
        144,
        99,
        '2021-11-29',
        5000000,
        'Seed'
    ),
    (
        145,
        100,
        '2019-02-26',
        6000000,
        'Series B'
    ),
    (
        146,
        100,
        '2021-05-20',
        75000000,
        'Series C'
    ),
    -- Additional rounds for depth
    (
        147,
        1,
        '2012-04-01',
        150000000,
        'Series D'
    ),
    (
        148,
        2,
        '2018-01-10',
        40000000,
        'Series A'
    ),
    (
        149,
        3,
        '2015-08-18',
        35000000,
        'Series B'
    ),
    (
        150,
        4,
        '2017-11-07',
        35000000,
        'Series B'
    );

-- ========================================
-- FUNDING ROUND INVESTORS (250+ relationships)
-- ========================================
INSERT INTO
    funding_round_investors (Round_ID, Investor_ID)
VALUES
    -- Round 1 investors
    (1, 1),
    (1, 3),
    (1, 4),
    -- Round 2 investors
    (2, 4),
    (2, 21),
    (2, 23),
    -- Round 3 investors
    (3, 2),
    (3, 5),
    (3, 15),
    -- Round 4 investors
    (4, 1),
    (4, 15),
    (4, 23),
    -- Round 5 investors
    (5, 1),
    (5, 2),
    (5, 7),
    -- Round 6 investors
    (6, 4),
    (6, 18),
    (6, 23),
    -- Round 7 investors
    (7, 4),
    (7, 19),
    (7, 23),
    -- Round 8 investors
    (8, 1),
    (8, 6),
    (8, 13),
    -- Round 9 investors
    (9, 1),
    (9, 14),
    (9, 15),
    -- Round 10 investors
    (10, 1),
    (10, 5),
    (10, 15),
    -- Round 11 investors
    (11, 1),
    (11, 3),
    (11, 11),
    -- Round 12 investors
    (12, 1),
    (12, 6),
    (12, 15),
    -- Round 13 investors
    (13, 3),
    (13, 11),
    (13, 32),
    -- Round 14 investors
    (14, 4),
    (14, 23),
    (14, 27),
    -- Round 15 investors
    (15, 4),
    (15, 23),
    (15, 27),
    -- Round 16 investors
    (16, 5),
    (16, 7),
    (16, 11),
    -- Round 17 investors
    (17, 1),
    (17, 4),
    (17, 11),
    -- Round 18 investors
    (18, 4),
    (18, 11),
    (18, 35),
    -- Round 19 investors
    (19, 3),
    (19, 4),
    (19, 6),
    -- Round 20 investors
    (20, 3),
    (20, 21),
    (20, 22),
    -- Round 21 investors
    (21, 2),
    (21, 8),
    (21, 13),
    -- Round 22 investors
    (22, 1),
    (22, 16),
    (22, 17),
    -- Round 23 investors
    (23, 1),
    (23, 16),
    (23, 25),
    -- Round 24 investors
    (24, 37),
    (24, 38),
    (24, 39),
    -- Round 25 investors
    (25, 1),
    (25, 25),
    (25, 26),
    -- Round 26 investors
    (26, 4),
    (26, 25),
    (26, 26),
    -- Round 27 investors
    (27, 3),
    (27, 4),
    (27, 18),
    -- Round 28 investors
    (28, 37),
    (28, 38),
    (28, 39),
    -- Round 29 investors
    (29, 1),
    (29, 7),
    (29, 11),
    -- Round 30 investors
    (30, 3),
    (30, 32),
    (30, 34),
    -- Round 31 investors
    (31, 1),
    (31, 2),
    (31, 8),
    -- Round 32 investors
    (32, 3),
    (32, 11),
    (32, 32),
    -- Round 33 investors
    (33, 1),
    (33, 2),
    (33, 15),
    -- Round 34 investors
    (34, 1),
    (34, 15),
    (34, 32),
    -- Round 35 investors
    (35, 1),
    (35, 8),
    (35, 14),
    -- Round 36 investors
    (36, 1),
    (36, 11),
    (36, 33),
    -- Round 37 investors
    (37, 1),
    (37, 2),
    (37, 11),
    -- Round 38 investors
    (38, 3),
    (38, 11),
    (38, 17),
    -- Round 39 investors
    (39, 4),
    (39, 23),
    (39, 31),
    -- Round 40 investors
    (40, 4),
    (40, 31),
    (40, 35),
    -- Round 41 investors
    (41, 25),
    (41, 28),
    (41, 29),
    -- Round 42 investors
    (42, 25),
    (42, 28),
    (42, 29),
    -- Round 43 investors
    (43, 1),
    (43, 21),
    (43, 24),
    -- Round 44 investors
    (44, 1),
    (44, 3),
    (44, 18),
    -- Round 45 investors
    (45, 4),
    (45, 24),
    (45, 31),
    -- Round 46 investors
    (46, 1),
    (46, 8),
    (46, 13),
    -- Round 47 investors
    (47, 4),
    (47, 18),
    (47, 24),
    -- Round 48 investors
    (48, 1),
    (48, 17),
    (48, 21),
    -- Round 49 investors
    (49, 1),
    (49, 2),
    (49, 6),
    -- Round 50 investors
    (50, 3),
    (50, 18),
    (50, 21),
    -- Continue with remaining rounds (51-150)
    (51, 1),
    (51, 2),
    (52, 1),
    (52, 4),
    (52, 18),
    (53, 1),
    (53, 3),
    (54, 3),
    (54, 11),
    (54, 21),
    (55, 1),
    (55, 6),
    (56, 1),
    (56, 4),
    (56, 23),
    (57, 1),
    (57, 6),
    (58, 1),
    (58, 16),
    (59, 1),
    (59, 6),
    (60, 1),
    (60, 16),
    (61, 1),
    (61, 6),
    (62, 1),
    (62, 6),
    (63, 1),
    (63, 6),
    (64, 1),
    (64, 6),
    (65, 1),
    (65, 4),
    (66, 1),
    (66, 4),
    (67, 1),
    (67, 5),
    (68, 1),
    (68, 5),
    (69, 1),
    (69, 5),
    (70, 1),
    (70, 3),
    (71, 1),
    (71, 3),
    (72, 1),
    (72, 3),
    (73, 1),
    (73, 3),
    (74, 1),
    (75, 1),
    (75, 3),
    (76, 1),
    (76, 3),
    (77, 1),
    (77, 6),
    (78, 1),
    (78, 6),
    (79, 1),
    (79, 2),
    (80, 37),
    (80, 38),
    (81, 1),
    (81, 8),
    (82, 1),
    (82, 3),
    (83, 3),
    (83, 19),
    (84, 1),
    (84, 6),
    (85, 1),
    (85, 6),
    (86, 1),
    (86, 6),
    (87, 1),
    (87, 8),
    (88, 1),
    (88, 4),
    (89, 1),
    (89, 4),
    (90, 1),
    (90, 8),
    (91, 1),
    (91, 8),
    (92, 5),
    (92, 7),
    (93, 4),
    (93, 18),
    (94, 1),
    (94, 6),
    (95, 1),
    (95, 16),
    (96, 1),
    (96, 16),
    (97, 1),
    (97, 6),
    (98, 1),
    (98, 3),
    (99, 1),
    (99, 5),
    (100, 1),
    (100, 8),
    (101, 1),
    (101, 6),
    (102, 1),
    (102, 6),
    (103, 1),
    (103, 8),
    (104, 1),
    (104, 6),
    (105, 1),
    (105, 8),
    (106, 1),
    (106, 5),
    (107, 1),
    (107, 8),
    (108, 1),
    (108, 3),
    (109, 1),
    (109, 42),
    (110, 1),
    (110, 8),
    (111, 1),
    (111, 42),
    (112, 1),
    (112, 9),
    (113, 1),
    (113, 3),
    (114, 1),
    (114, 3),
    (115, 1),
    (115, 16),
    (116, 1),
    (116, 16),
    (117, 1),
    (117, 8),
    (118, 1),
    (118, 47),
    (119, 1),
    (119, 47),
    (120, 1),
    (120, 47),
    (121, 1),
    (121, 5),
    (122, 1),
    (122, 47),
    (123, 1),
    (123, 47),
    (124, 1),
    (124, 5),
    (125, 1),
    (125, 3),
    (126, 1),
    (126, 18),
    (127, 1),
    (127, 16),
    (128, 1),
    (128, 3),
    (129, 1),
    (129, 3),
    (130, 1),
    (130, 4),
    (131, 1),
    (131, 44),
    (132, 8),
    (132, 42),
    (133, 1),
    (133, 44),
    (134, 1),
    (134, 44),
    (135, 1),
    (135, 18),
    (136, 1),
    (136, 44),
    (137, 1),
    (137, 30),
    (138, 1),
    (138, 30),
    (139, 1),
    (139, 44),
    (140, 1),
    (140, 44),
    (141, 1),
    (141, 8),
    (142, 1),
    (142, 50),
    (143, 1),
    (143, 8),
    (144, 1),
    (144, 42),
    (145, 1),
    (145, 8),
    (146, 1),
    (146, 3),
    (147, 1),
    (147, 3),
    (148, 2),
    (148, 5),
    (149, 1),
    (149, 2),
    (150, 1),
    (150, 14);

-- ========================================
-- STARTUP MILESTONES (200+ milestones)
-- ========================================
INSERT INTO
    startup_milestones (
        Milestone_ID,
        Startup_ID,
        Description,
        Date
    )
VALUES (
        1,
        1,
        'Reached 1 million registered users',
        '2010-08-15'
    ),
    (
        2,
        1,
        'Launched Big Billion Day sale',
        '2014-10-06'
    ),
    (
        3,
        1,
        'Acquired by Walmart',
        '2018-05-09'
    ),
    (
        4,
        1,
        'Crossed $10 billion GMV',
        '2019-03-31'
    ),
    (
        5,
        2,
        'Crossed 100 million users',
        '2019-12-01'
    ),
    (
        6,
        2,
        'Launched Switch platform',
        '2020-06-15'
    ),
    (
        7,
        2,
        'Became most valued fintech in India',
        '2022-01-01'
    ),
    (
        8,
        3,
        'Launched Swiggy Genie',
        '2019-08-01'
    ),
    (
        9,
        3,
        'Crossed 1 million daily orders',
        '2020-05-20'
    ),
    (
        10,
        3,
        'Launched Instamart',
        '2020-08-01'
    ),
    (
        11,
        4,
        'Crossed 1 million merchants',
        '2018-06-01'
    ),
    (
        12,
        4,
        'Launched RazorpayX',
        '2019-09-10'
    ),
    (
        13,
        4,
        'Became 8th unicorn startup',
        '2020-10-18'
    ),
    (
        14,
        5,
        'Crossed 7.5 million members',
        '2021-01-01'
    ),
    (
        15,
        5,
        'Launched CRED Mint',
        '2021-06-15'
    ),
    (
        16,
        6,
        'Crossed 100 million users',
        '2021-04-01'
    ),
    (
        17,
        6,
        'Launched Meesho Superstore',
        '2021-07-20'
    ),
    (
        18,
        7,
        'Crossed 30000 sellers',
        '2019-03-01'
    ),
    (
        19,
        7,
        'Expanded to 900+ cities',
        '2020-09-01'
    ),
    (
        20,
        8,
        'Completed 1 billion rides',
        '2017-10-05'
    ),
    (
        21,
        8,
        'Expanded to international markets',
        '2018-01-15'
    ),
    (
        22,
        9,
        'Launched first electric scooter',
        '2021-08-15'
    ),
    (
        23,
        9,
        'Received 1 million pre-bookings',
        '2021-09-01'
    ),
    (
        24,
        10,
        'Raised Series D funding',
        '2019-10-22'
    ),
    (
        25,
        11,
        'Completed IPO',
        '2021-07-23'
    ),
    (
        26,
        11,
        'Acquired Blinkit',
        '2022-08-10'
    ),
    (
        27,
        12,
        'Crossed 100 million users',
        '2016-05-20'
    ),
    (
        28,
        12,
        'Launched Paytm Bank',
        '2017-05-23'
    ),
    (
        29,
        12,
        'Completed IPO',
        '2021-11-18'
    ),
    (
        30,
        13,
        'Completed IPO',
        '2021-11-15'
    ),
    (
        31,
        14,
        'Expanded to 100 cities',
        '2019-12-01'
    ),
    (
        32,
        15,
        'Launched Spinny Park',
        '2020-11-12'
    ),
    (
        33,
        16,
        'Crossed 1 million merchants',
        '2020-02-01'
    ),
    (
        34,
        17,
        'Expanded to 14 cities',
        '2020-08-01'
    ),
    (
        35,
        18,
        'Crossed 1 million bookings',
        '2018-03-01'
    ),
    (
        36,
        19,
        'Rebranded to Blinkit',
        '2021-12-13'
    ),
    (
        37,
        20,
        'Acquired by Tata Digital',
        '2021-05-18'
    ),
    (
        38,
        21,
        'Crossed 100 million users',
        '2020-01-01'
    ),
    (
        39,
        21,
        'Launched Byjus Classes',
        '2019-05-01'
    ),
    (
        40,
        22,
        'Crossed 50 million learners',
        '2020-09-01'
    ),
    (
        41,
        23,
        'Partnered with 300+ universities',
        '2021-01-01'
    ),
    (
        42,
        24,
        'Launched Vedantu SuperKids',
        '2020-06-01'
    ),
    (
        43,
        25,
        'Expanded to 80+ countries',
        '2021-03-01'
    ),
    (
        44,
        26,
        'Rebranded to Cult.fit',
        '2019-06-01'
    ),
    (
        45,
        27,
        'Acquired Medlife',
        '2021-02-01'
    ),
    (
        46,
        28,
        'Expanded to 50+ cities',
        '2019-01-01'
    ),
    (
        47,
        29,
        'Launched 1mg Labs',
        '2020-03-15'
    ),
    (
        48,
        30,
        'Launched MobiKwik Xtra',
        '2020-01-01'
    ),
    (
        49,
        31,
        'Processed $30 billion transactions',
        '2020-12-01'
    ),
    (
        50,
        32,
        'Completed IPO',
        '2022-05-24'
    ),
    (
        51,
        33,
        'Crossed 25000 pin codes',
        '2021-01-01'
    ),
    (
        52,
        34,
        'Launched River fleet',
        '2018-06-01'
    ),
    (
        53,
        35,
        'Crossed 1 million trips',
        '2019-01-01'
    ),
    (
        54,
        36,
        'Crossed 160 million MAU',
        '2021-01-01'
    ),
    (
        55,
        37,
        'Crossed 100 million users',
        '2020-01-01'
    ),
    (
        56,
        38,
        'Crossed 5 million trading accounts',
        '2021-01-01'
    ),
    (
        57,
        39,
        'Crossed 1 million users',
        '2020-06-01'
    ),
    (
        58,
        40,
        'Crossed 15 million policies',
        '2021-01-01'
    ),
    (
        59,
        41,
        'Completed IPO',
        '2021-11-10'
    ),
    (
        60,
        42,
        'Crossed 5 million downloads',
        '2021-01-01'
    ),
    (
        61,
        43,
        'Opened 100+ stores',
        '2020-01-01'
    ),
    (
        62,
        44,
        'Crossed 7 million customers',
        '2020-01-01'
    ),
    (
        63,
        45,
        'Expanded to 500+ cities',
        '2019-01-01'
    ),
    (
        64,
        46,
        'Launched new experience centers',
        '2020-01-01'
    ),
    (
        65,
        47,
        'Expanded to 10 cities',
        '2021-01-01'
    ),
    (
        66,
        48,
        'Crossed 50 cloud kitchens',
        '2020-01-01'
    ),
    (
        67,
        49,
        'Launched Box8 Desi Meals',
        '2019-01-01'
    ),
    (
        68,
        50,
        'Expanded to 15 cities',
        '2020-01-01'
    ),
    (
        69,
        51,
        'Crossed 1 million rooms',
        '2019-01-01'
    ),
    (
        70,
        52,
        'Expanded to 100+ cities',
        '2020-01-01'
    ),
    (
        71,
        53,
        'Merged with MakeMyTrip',
        '2016-01-08'
    ),
    (
        72,
        54,
        'Completed IPO',
        '2010-08-13'
    ),
    (
        73,
        55,
        'Crossed 1 million rides',
        '2019-01-01'
    ),
    (
        74,
        56,
        'Launched Bounce Infinity',
        '2021-11-15'
    ),
    (
        75,
        57,
        'Expanded to 10 cities',
        '2019-01-01'
    ),
    (
        76,
        58,
        'Expanded to 45 cities',
        '2019-01-01'
    ),
    (
        77,
        59,
        'Launched bike subscription',
        '2018-01-01'
    ),
    (
        78,
        60,
        'Crossed 50000 daily riders',
        '2020-01-01'
    ),
    (
        79,
        61,
        'Crossed 100000 partners',
        '2020-01-01'
    ),
    (
        80,
        62,
        'Expanded to 20 cities',
        '2021-01-01'
    ),
    (
        81,
        63,
        'Crossed 50000 daily deliveries',
        '2020-01-01'
    ),
    (
        82,
        64,
        'Integrated 20+ courier partners',
        '2021-01-01'
    ),
    (
        83,
        65,
        'Crossed 200000 merchants',
        '2021-01-01'
    ),
    (
        84,
        66,
        'Crossed 500000 merchants',
        '2021-01-01'
    ),
    (
        85,
        67,
        'Crossed 1 million merchants',
        '2020-01-01'
    ),
    (
        86,
        68,
        'Crossed 10 million users',
        '2021-01-01'
    ),
    (
        87,
        69,
        'Expanded to 500+ societies',
        '2021-01-01'
    ),
    (
        88,
        70,
        'Crossed 100000 listings',
        '2020-01-01'
    ),
    (
        89,
        71,
        'Merged with PropTiger',
        '2017-01-01'
    ),
    (
        90,
        72,
        'Crossed 2 million listings',
        '2020-01-01'
    ),
    (
        91,
        73,
        'Crossed 15 million unique visitors',
        '2020-01-01'
    ),
    (
        92,
        74,
        'Expanded to 15 cities',
        '2020-01-01'
    ),
    (
        93,
        75,
        'Reached 1 million farmers',
        '2021-01-01'
    ),
    (
        94,
        76,
        'Crossed 8500 farmers',
        '2020-01-01'
    ),
    (
        95,
        77,
        'Expanded to 20 cities',
        '2021-01-01'
    ),
    (
        96,
        78,
        'Crossed 2 million farmers',
        '2020-01-01'
    ),
    (
        97,
        79,
        'Onboarded 10000 kiranas',
        '2020-01-01'
    ),
    (
        98,
        80,
        'Crossed 25000 sellers',
        '2020-01-01'
    ),
    (
        99,
        81,
        'Crossed 25000 sellers',
        '2021-01-01'
    ),
    (
        100,
        82,
        'Crossed 50000 SMEs',
        '2021-01-01'
    ),
    -- Additional 100 milestones for depth
    (
        101,
        1,
        'Launched Flipkart Plus',
        '2015-07-01'
    ),
    (
        102,
        1,
        'Acquired Myntra',
        '2014-05-22'
    ),
    (
        103,
        2,
        'Launched PhonePe Insurance',
        '2021-05-10'
    ),
    (
        104,
        3,
        'Launched Swiggy POP',
        '2017-06-01'
    ),
    (
        105,
        3,
        'Expanded to 500 cities',
        '2020-12-01'
    ),
    (
        106,
        4,
        'Launched Razorpay Capital',
        '2020-06-30'
    ),
    (
        107,
        5,
        'Launched CRED Store',
        '2020-11-01'
    ),
    (
        108,
        6,
        'Reached 3 million resellers',
        '2021-09-01'
    ),
    (
        109,
        7,
        'Launched Udaan Capital',
        '2020-02-01'
    ),
    (
        110,
        8,
        'Launched Ola Money',
        '2015-01-01'
    ),
    (
        111,
        9,
        'Opened Futurefactory',
        '2020-12-01'
    ),
    (
        112,
        10,
        'Launched DunzoDaily',
        '2020-06-01'
    ),
    (
        113,
        11,
        'Acquired UberEats India',
        '2020-01-21'
    ),
    (
        114,
        12,
        'Launched Paytm Mall',
        '2017-02-28'
    ),
    (
        115,
        13,
        'Launched PB Partners',
        '2020-06-01'
    ),
    (
        116,
        14,
        'Launched Cars24 Financial Services',
        '2020-01-01'
    ),
    (
        117,
        15,
        'Expanded to 35 cities',
        '2021-06-01'
    ),
    (
        118,
        16,
        'Launched BharatSwipe',
        '2020-08-01'
    ),
    (
        119,
        17,
        'Launched Licious Kitchen',
        '2020-10-01'
    ),
    (
        120,
        18,
        'Expanded to Middle East',
        '2020-09-01'
    ),
    (
        121,
        19,
        'Launched 10-minute delivery',
        '2021-09-01'
    ),
    (
        122,
        20,
        'Launched BBdaily',
        '2019-09-01'
    ),
    (
        123,
        21,
        'Acquired Aakash Educational',
        '2021-04-08'
    ),
    (
        124,
        22,
        'Launched Graphy',
        '2021-06-16'
    ),
    (
        125,
        23,
        'Acquired KnowledgeHut',
        '2021-10-07'
    ),
    (
        126,
        24,
        'Launched VSAT program',
        '2020-07-01'
    ),
    (
        127,
        25,
        'Partnered with MIT',
        '2021-05-01'
    ),
    (
        128,
        26,
        'Launched cult.sport',
        '2021-02-01'
    ),
    (
        129,
        27,
        'Acquired Thyrocare',
        '2021-06-24'
    ),
    (
        130,
        28,
        'Launched Practo Plus',
        '2020-05-01'
    ),
    (
        131,
        29,
        'Crossed 10 million app downloads',
        '2021-01-01'
    ),
    (
        132,
        30,
        'Launched ZIP credit line',
        '2021-04-01'
    ),
    (
        133,
        31,
        'Expanded to SEA markets',
        '2021-01-01'
    ),
    (
        134,
        32,
        'Launched Delhivery Direct',
        '2020-03-01'
    ),
    (
        135,
        33,
        'Launched XB2B',
        '2020-05-01'
    ),
    (
        136,
        34,
        'Launched Rivigo Marketplace',
        '2019-01-01'
    ),
    (
        137,
        35,
        'Launched BlackBuck Finserve',
        '2020-07-01'
    ),
    (
        138,
        36,
        'Launched Moj',
        '2020-07-01'
    ),
    (
        139,
        37,
        'Launched Dream11 Game',
        '2021-01-01'
    ),
    (
        140,
        38,
        'Launched Coin platform',
        '2017-01-01'
    ),
    (
        141,
        39,
        'Launched Groww Gold',
        '2021-08-01'
    ),
    (
        142,
        40,
        'Launched health insurance',
        '2020-09-01'
    ),
    (
        143,
        41,
        'Launched Nykaa Fashion',
        '2018-10-01'
    ),
    (
        144,
        42,
        'Launched Purplle Elite',
        '2021-03-01'
    ),
    (
        145,
        43,
        'Launched 3D Try-On',
        '2020-06-01'
    ),
    (
        146,
        44,
        'Launched FirstCry Arabia',
        '2020-01-01'
    ),
    (
        147,
        45,
        'Launched furniture studio',
        '2020-03-01'
    ),
    (
        148,
        46,
        'Launched Ladder',
        '2019-01-01'
    ),
    (
        149,
        47,
        'Launched subscription model',
        '2020-09-01'
    ),
    (
        150,
        48,
        'Expanded to 15 cities',
        '2021-01-01'
    ),
    (
        151,
        49,
        'Launched healthy meals',
        '2020-01-01'
    ),
    (
        152,
        50,
        'Launched gourmet range',
        '2021-01-01'
    ),
    (
        153,
        51,
        'Launched OYO Workspaces',
        '2019-02-01'
    ),
    (
        154,
        52,
        'Launched Treebo Plus',
        '2019-06-01'
    ),
    (
        155,
        53,
        'Launched gocash',
        '2020-01-01'
    ),
    (
        156,
        54,
        'Launched myPartner',
        '2020-05-01'
    ),
    (
        157,
        55,
        'Launched Rapido Bike Taxi',
        '2019-03-01'
    ),
    (
        158,
        56,
        'Launched dockless scooters',
        '2019-09-01'
    ),
    (
        159,
        57,
        'Partnered with Metro',
        '2020-02-01'
    ),
    (
        160,
        58,
        'Launched flexible plans',
        '2020-05-01'
    ),
    (
        161,
        59,
        'Launched subscription',
        '2020-01-01'
    ),
    (
        162,
        60,
        'Launched premium routes',
        '2021-01-01'
    ),
    (
        163,
        61,
        'Launched two-wheeler delivery',
        '2020-03-01'
    ),
    (
        164,
        62,
        'Launched enterprise solutions',
        '2021-03-01'
    ),
    (
        165,
        63,
        'Launched hyperlocal delivery',
        '2020-09-01'
    ),
    (
        166,
        64,
        'Launched international shipping',
        '2021-05-01'
    ),
    (
        167,
        65,
        'Launched Shiprocket X',
        '2021-09-01'
    ),
    (
        168,
        66,
        'Launched Dukaan Payments',
        '2021-08-01'
    ),
    (
        169,
        67,
        'Launched payment gateway',
        '2020-05-01'
    ),
    (
        170,
        68,
        'Launched billing software',
        '2021-01-01'
    ),
    (
        171,
        69,
        'Launched visitor management',
        '2020-06-01'
    ),
    (
        172,
        70,
        'Launched NoBroker Prime',
        '2020-10-01'
    ),
    (
        173,
        71,
        'Launched virtual tours',
        '2020-04-01'
    ),
    (
        174,
        72,
        'Launched MB Premium',
        '2020-01-01'
    ),
    (
        175,
        73,
        'Launched property valuation',
        '2021-01-01'
    ),
    (
        176,
        74,
        'Launched managed homes',
        '2020-01-01'
    ),
    (
        177,
        75,
        'Launched DeHaat Saathi',
        '2021-05-01'
    ),
    (
        178,
        76,
        'Launched quality assurance',
        '2021-01-01'
    ),
    (
        179,
        77,
        'Launched supply chain tech',
        '2021-03-01'
    ),
    (
        180,
        78,
        'Launched AgroStar Krishi',
        '2021-02-01'
    ),
    (
        181,
        79,
        'Launched Jumbotail Marketplace',
        '2021-04-01'
    ),
    (
        182,
        80,
        'Launched trade credit',
        '2021-01-01'
    ),
    (
        183,
        81,
        'Launched Moglix Mart',
        '2021-06-01'
    ),
    (
        184,
        82,
        'Launched Biz Khata',
        '2021-03-01'
    ),
    (
        185,
        83,
        'Launched IndiaMart Pay',
        '2021-01-01'
    ),
    (
        186,
        84,
        'Launched marketplace app',
        '2020-01-01'
    ),
    (
        187,
        85,
        'Launched Snapdeal 2.0',
        '2017-09-01'
    ),
    (
        188,
        86,
        'Expanded to 8 markets',
        '2020-01-01'
    ),
    (
        189,
        87,
        'Launched D2C channel',
        '2020-05-01'
    ),
    (
        190,
        88,
        'Opened 100+ stores',
        '2021-01-01'
    ),
    (
        191,
        89,
        'Launched home decor',
        '2020-08-01'
    ),
    (
        192,
        90,
        'Launched international shipping',
        '2021-01-01'
    ),
    (
        193,
        91,
        'Became #1 audio brand',
        '2021-01-01'
    ),
    (
        194,
        92,
        'Launched smartwatches',
        '2021-01-01'
    ),
    (
        195,
        93,
        'Launched BabyCare range',
        '2021-04-01'
    ),
    (
        196,
        94,
        'Expanded to 20 categories',
        '2021-01-01'
    ),
    (
        197,
        95,
        'Launched skincare range',
        '2021-05-01'
    ),
    (
        198,
        96,
        'Expanded to retail',
        '2021-01-01'
    ),
    (
        199,
        97,
        'Opened 100+ stores',
        '2021-01-01'
    ),
    (
        200,
        98,
        'Launched premium range',
        '2021-06-01'
    );

-- ========================================
-- ACQUISITIONS (20 acquisitions)
-- ========================================
INSERT INTO
    acquisitions (
        AcquisitionID,
        Acquirer_Startup_ID,
        Target_Startup_ID,
        Date,
        Amount
    )
VALUES (
        1,
        1,
        46,
        '2016-06-13',
        50000000
    ),
    (
        2,
        11,
        19,
        '2022-08-10',
        568000000
    ),
    (
        3,
        20,
        47,
        '2019-12-04',
        30000000
    ),
    (
        4,
        21,
        57,
        '2019-08-13',
        15000000
    ),
    (
        5,
        48,
        49,
        '2016-07-15',
        15000000
    ),
    (
        6,
        51,
        74,
        '2015-02-11',
        10000000
    ),
    (
        7,
        53,
        54,
        '2016-01-08',
        720000000
    ),
    (
        8,
        6,
        86,
        '2021-08-17',
        70000000
    ),
    (
        9,
        26,
        57,
        '2020-06-26',
        15000000
    ),
    (
        10,
        27,
        62,
        '2020-03-31',
        5000000
    ),
    (
        11,
        12,
        44,
        '2017-11-27',
        200000000
    ),
    (
        12,
        18,
        70,
        '2020-12-14',
        10000000
    ),
    (
        13,
        21,
        60,
        '2021-01-21',
        15000000
    ),
    (
        14,
        31,
        67,
        '2021-05-19',
        10000000
    ),
    (
        15,
        48,
        90,
        '2018-10-15',
        20000000
    ),
    (
        16,
        1,
        84,
        '2010-10-28',
        5000000
    ),
    (
        17,
        69,
        74,
        '2020-07-07',
        5000000
    ),
    (
        18,
        85,
        59,
        '2016-03-21',
        8000000
    ),
    (
        19,
        27,
        60,
        '2021-06-24',
        600000000
    ),
    (
        20,
        1,
        87,
        '2015-05-12',
        5000000
    );