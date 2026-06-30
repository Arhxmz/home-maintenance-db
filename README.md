# 🏠 Home Maintenance Service Management System (HMSMS)

A fully normalized relational database project built using **Microsoft SQL Server** for managing home maintenance and repair services.

The project simulates a real-world service platform where customers can book home services such as plumbing, electrical work, AC repair, appliance maintenance, carpentry, painting, and cleaning. It demonstrates relational database design, normalization, SQL programming, and transactional data management.

---

## 📌 Project Overview

The Home Maintenance Service Management System (HMSMS) manages the complete workflow of a home service platform, including:

* Customer registration
* Service catalog management
* Technician management and skills
* Booking creation and technician assignment
* Payment processing
* Promotional discounts
* Customer reviews
* Complaint management

The database follows relational database principles and is designed to minimize redundancy while maintaining data integrity.

---

# ✨ Features

### 👤 Customer Management

* Customer registration
* Multiple bookings per customer
* Booking history

### 🛠 Service Management

* Service categories
* Service pricing
* Estimated service duration
* Multiple services per booking

### 👨‍🔧 Technician Management

* Technician profiles
* Skill mapping
* Booking assignments
* Technician performance tracking

### 💳 Payment System

* Multiple payment methods
* Payment status tracking
* Transaction history

### 🎁 Promotions

* Promo codes
* Discount management
* Usage limits

### ⭐ Reviews & Complaints

* Customer ratings
* Written reviews
* Complaint submission
* Resolution tracking

---

# 🗂 Database Modules

| Table              | Purpose                           |
| ------------------ | --------------------------------- |
| CITY               | Stores city information           |
| CUSTOMER           | Customer records                  |
| SERVICE_CATEGORY   | Categories of services            |
| SERVICE            | Available services                |
| TECHNICIAN         | Technician information            |
| TECHNICIAN_SKILL   | Technician skill mapping          |
| BOOKING            | Booking records                   |
| BOOKING_ITEM       | Services included in each booking |
| BOOKING_ASSIGNMENT | Technician assignments            |
| PAYMENT            | Payment transactions              |
| PAYMENT_METHOD     | Payment method details            |
| REVIEW             | Customer reviews                  |
| COMPLAINT          | Customer complaints               |
| PROMOTION          | Promotional offers                |
| BOOKING_PROMOTION  | Promotions applied to bookings    |

---

# 🧱 Database Design

The project follows **Third Normal Form (3NF)** to ensure:

* Reduced data redundancy
* Improved consistency
* Referential integrity
* Efficient querying

Relationships are enforced using:

* Primary Keys
* Foreign Keys
* Constraints

---

# 📂 Project Structure

```text
home-maintenance-db/
│
├── docs/
│   ├── ERD.png
│   ├── Database_Documentation.pdf
│   └── HMSMS_Statistical_Dashboard.html
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_views.sql
│   ├── 04_queries.sql
│   ├── 05_procedures.sql
│   ├── 06_triggers.sql
│   └── 07_sample_reports.sql
│
├── screenshots/
│   ├── ERD.png
│   ├── Dashboard.png
│   └── Sample_Query.png
│
├── LICENSE
└── README.md
```

---

# 🛠 Technologies Used

* Microsoft SQL Server
* SQL
* SQL Server Management Studio (SSMS)
* Visual Studio Code
* Git
* GitHub

---

# 📊 Database Concepts Demonstrated

* Relational Database Design
* Normalization (up to 3NF)
* Primary & Foreign Keys
* Joins
* Aggregate Functions
* Views
* Stored Procedures
* Triggers
* Transactions
* Constraints
* Indexing

---

# 🚀 Getting Started

1. Clone the repository.

```bash
git clone https://github.com/yourusername/home-maintenance-db.git
```

2. Open SQL Server Management Studio.

3. Create a new database.

4. Execute the SQL files in the following order:

* 01_create_tables.sql
* 02_insert_data.sql
* 03_views.sql
* 04_queries.sql
* 05_procedures.sql
* 06_triggers.sql

---

# 📈 Future Improvements

* Authentication system
* Technician location tracking
* Dynamic pricing
* AI-based technician recommendation
* Customer mobile application integration
* Admin dashboard

---

# 👨‍💻 Author

**Muhammed Arham Hassan**

Database Design • SQL • Microsoft SQL Server

If you found this project useful, consider giving it a ⭐ on GitHub.
