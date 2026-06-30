Create Database home_maintenance_db;
Use home_maintenance_db;

-- Table 01 : City
Create Table CITY (
      CityID INT Primary Key,
      CityName Varchar(100)
      );



-- Table 02 : Customer
-- CityID links each customer to their city (CITY table)
Create Table CUSTOMER (
    CustomerID  INT Primary Key,
    CityID      INT,
    FullName    Varchar(100),
    Phone       Varchar(100)     Unique,
    Email       Varchar(100)    Unique,
    JoinDate    Date,
    Foreign Key (CityID) References CITY(CityID)
    );


-- Table 03 : Service Category
Create Table SERVICE_CATEGORY(
     CategoryID INT Primary Key,
     CategoryName Varchar(100)
     );


-- Table 04 : Service
-- CategoryID groups this service under a category (SERVICE_CATEGORY table)
Create Table SERVICE (
    ServiceID       INT Primary Key,
    CategoryID      INT,
    ServiceName     Varchar(150),
    BasePrice       Decimal(10,2),
    DurationMin     INT,
    Foreign Key (CategoryID) References SERVICE_CATEGORY(CategoryID)
    );

-- Table 05 : Technician
-- CityID links each technician to the city they operate in (CITY table)
Create Table TECHNICIAN(
      TechnicianID INT Primary Key,
      CityID INT,
      FullName Varchar(100),
      Phone Varchar (100) UNIQUE,
      CNIC Varchar(100) UNIQUE,
      IsVerified BIT,
      JoinDate Date,
      Foreign Key (CityID) References CITY(CityID)
      );

-- Table 06 : Technician Skill
-- ServiceID tells which service this skill applies to (SERVICE table)
-- TechnicianID links the skill record to a specific technician (TECHNICIAN table)
Create Table TECHNICIAN_SKILL (
    TechnicianSkillID   INT  Primary Key,
    ServiceID     INT,
    TechnicianID  INT,
    SkillLevel    Varchar(100),
    YearsExperience     INT,
    Foreign Key (ServiceID) References SERVICE(ServiceID),
    Foreign Key (TechnicianID) References TECHNICIAN(TechnicianID)
    );

-- Table 07 : Booking
-- CustomerID identifies who made the booking (CUSTOMER table)
-- ServiceCityID records the city where service is requested (CITY table)
Create Table BOOKING (
    BookingID       INT Primary Key,
    CustomerID      INT,
    ServiceCityID   INT,
    BookingDate     Date,
    ScheduledDate   Date,
    Status          Varchar(50),
    Address         Varchar(255),
    Foreign Key (CustomerID) References CUSTOMER(CustomerID),
    Foreign Key (ServiceCityID) References CITY(CityID)
);

-- Table 08 : BookingItem
-- BookingID ties this line item to its parent booking (BOOKING table)
-- ServiceID identifies which service was booked (SERVICE table)
Create Table BOOKING_ITEM (
    ItemID      INT Primary Key,
    BookingID   INT,
    ServiceID   INT,
    Quantity    INT,
    UnitPrice   Decimal(10,2),
    Foreign Key (BookingID) References BOOKING(BookingID),
    Foreign Key (ServiceID) References SERVICE(ServiceID)
);

-- Table 09 : BookingAssignment
-- BookingID links this assignment to the relevant booking (BOOKING table)
-- TechnicianID identifies which technician is assigned (TECHNICIAN table)
Create Table BOOKING_ASSIGNMENT (
    AssignmentID        INT Primary Key,
    BookingID           INT,
    TechnicianID        INT,
    AssignedAt          DATETIME,
    ArrivalTime         DATETIME,
    CompletionTime      DATETIME,
    AssignmentStatus    Varchar(50),
    Foreign Key (BookingID) References BOOKING(BookingID),
    Foreign Key (TechnicianID) References TECHNICIAN(TechnicianID)
);
 
-- Table 13: Promotion  (created before BookingPromotion)
Create Table PROMOTION (
    PromotionID     INT          Primary Key,
    PromoCode       Varchar(50)  UNIQUE,
    DiscountPct     Decimal(5,2),
    ValidFrom       Date,
    ValidTo         Date,
    MaxUsage        INT
);

-- Table 14 : BookingPromotion (M:M junction)
-- BookingID references the booking a promo was applied to (BOOKING table)
-- PromotionID references which promotion was used (PROMOTION table)
Create Table BOOKING_PROMOTION (
    ID               INT Primary Key,
    BookingID       INT,
    PromotionID     INT,
    DiscountApplied Decimal(10,2),
    UNIQUE (BookingID, PromotionID),
    Foreign Key (BookingID) References BOOKING(BookingID),
    Foreign Key (PromotionID) References PROMOTION(PromotionID)
);

-- Table 15 : PaymentMethod (created before Payment)
Create Table PAYMENT_METHOD (
    MethodID    INT Primary Key,
    MethodName  Varchar(100)
);


-- Table 10 : Payment
-- BookingID links the payment to its booking (BOOKING table)
-- MethodID identifies how the payment was made (PAYMENT_METHOD table)
Create Table PAYMENT (
    PaymentID       INT Primary Key,
    BookingID       INT,
    MethodID        INT,
    Amount          Decimal(10,2),
    PaymentDate     Date,
    Status          Varchar(50),
    Foreign Key (BookingID) References BOOKING(BookingID),
    Foreign Key (MethodID) References PAYMENT_METHOD(MethodID)
);


-- Table 11 : Review
-- AssignmentID links the review to a specific technician assignment (BOOKING_ASSIGNMENT table)
Create Table REVIEW (
    ReviewID        INT Primary Key,
    AssignmentID    INT,
    Rating          INT,
    Comments        Text,
    ReviewDate      Date,
    Foreign Key (AssignmentID) References BOOKING_ASSIGNMENT(AssignmentID)
);

-- Table 12 : Complaint
-- BookingID links the complaint to the booking it concerns (BOOKING table)
Create Table COMPLAINT (
    ComplaintID     INT Primary Key,
    BookingID       INT,
    Description     Text,
    Status          Varchar(50),
    FiledDate       Date,
    ResolvedDate    Date,
    Foreign Key (BookingID) References BOOKING(BookingID)
);
