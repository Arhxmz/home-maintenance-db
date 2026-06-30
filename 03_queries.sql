
-- Queries Section --
-- ___________________________ PART - III __________________________________ 

-- Question 01:
--		List all completed bookings for a specific customer, with total amount paid

SELECT
    b.BookingID, 
    b.BookingDate, 
    b.ScheduledDate, 
    b.Address, 
    c.FullName  AS CustomerName, 
    ci.CityName, 
    SUM(p.Amount) AS TotalAmountPaid
FROM
        Booking b
        JOIN Customer   c  
        ON b.CustomerID    = c.CustomerID
        JOIN City       ci 
        ON b.ServiceCityID = ci.CityID
        JOIN Payment    p  
        ON b.BookingID     = p.BookingID
WHERE  b.Status  = 'Completed' AND 
       c.CustomerID = 2001   -- change this ID to any customer you want
       AND p.Status   = 'Paid'
GROUP BY
    b.BookingID,
    b.BookingDate,
    b.ScheduledDate,
    b.Address,
    c.FullName,
    ci.CityName
ORDER BY
    b.BookingDate DESC;


-- Question 02: 
--     Show verified technicians with their average ratings and total reviews in each service category

SELECT
    sc.CategoryName,
    t.TechnicianID,
    t.FullName  AS TechnicianName,
    ci.CityName,
    COUNT(r.ReviewID)  AS TotalReviews,
    ROUND(AVG(CAST(r.Rating AS FLOAT)), 2) AS AverageRating
FROM
    Service_Category  sc
    JOIN Service   sv  
    ON sc.CategoryID   = sv.CategoryID
    JOIN Technician_Skill ts  
    ON sv.ServiceID    = ts.ServiceID
    JOIN Technician      t   
    ON ts.TechnicianID = t.TechnicianID
    JOIN Booking_Assignment ba 
    ON t.TechnicianID  = ba.TechnicianID
    JOIN Review          r   
    ON ba.AssignmentID = r.AssignmentID
    JOIN City            ci  
    ON t.CityID        = ci.CityID
WHERE
    t.IsVerified = 1
GROUP BY
    sc.CategoryID,
    sc.CategoryName,
    t.TechnicianID,
    t.FullName,
    ci.CityName
ORDER BY 
    AverageRating DESC;
-- Question 03:
--         Count bookings by status (Pending / Confirmed / Completed / Cancelled) per city

Select 
    count(b.BookingID) as TotalBookings,
    b.Status , c.CityName 
FROM
     Booking AS b
     JOIN City as c
     on c.CityID = b.ServiceCityID
GROUP BY
     b.Status , c.CityName
ORDER BY 
    c.CityName ASC, TotalBookings DESC;

-- Question 04 :
--      Which two services are most frequently booked together?

SELECT TOP 5
    s1.ServiceName     AS Service_1,
    s2.ServiceName     AS Service_2,
    COUNT(*)           AS TimesBookedTogether
 FROM
    Booking_Item        bi1
    JOIN Booking_Item   bi2 
    ON bi1.BookingID = bi2.BookingID
                    AND bi1.ServiceID < bi2.ServiceID
    JOIN Service       s1  
    ON bi1.ServiceID = s1.ServiceID
    JOIN Service       
    s2  ON bi2.ServiceID = s2.ServiceID
GROUP BY
    s1.ServiceName,
    s2.ServiceName
ORDER BY
    COUNT(*) DESC;

-- Question 05
-- Average time (in hours) between booking date and technician arrival
-- on the same day

SELECT
    AVG(DATEDIFF(HOUR, b.BookingDate, ba.ArrivalTime))
        AS AverageArrivalTime_Hours
FROM
    Booking AS b
    JOIN Booking_Assignment AS ba ON b.BookingID = ba.BookingID
WHERE
    ba.ArrivalTime IS NOT NULL
    AND CAST(ba.ArrivalTime AS DATE) = CAST(b.BookingDate AS DATE);

-- Question 06
--       Which promo codes generated the highest total discount in a given month?
Select 
    P.PromoCode, 
    sum(BP.DiscountApplied) as TotalDiscount,  
    FORMAT(B.BookingDate, 'MM-yyyy') as Month
From
     Booking_Promotion as BP
    JOIN Booking as B
    ON b.BookingID = BP.BookingID
    Join Promotion AS P
    ON P.PromotionID = BP.PromotionID
    --where FORMAT(B.BookingDate, 'MM-yyyy') = '01-2024' 
WHERE 
    B.BookingDate >= '2024-02-01' 
    AND B.BookingDate < '2024-03-01' 
GROUP BY  
    P.PromoCode,FORMAT(B.BookingDate, 'MM-yyyy') 
ORDER BY    
    TotalDiscount DESC;

-- Question 07
-- List technicians who have zero complaints in the last 6 months
Select 
    BA.TechnicianID, T.FullName 
From
     Booking_Assignment as BA
    Join Technician as T
    On T.TechnicianID = BA.TechnicianID
    Join  Booking as B 
    On B.BookingID =    BA.BookingID
    Left Join Complaint as c 
    On c.BookingID = b.BookingID   
        and   C.FiledDate >= DATEADD(MONTH, -6, GETDATE())
Group By 
    BA.TechnicianID, T.FullName 
Having 
    Count( c.ComplaintID ) = 0

-- Question 08
--           Monthly revenue breakdown by payment method (Cash, JazzCash, EasyPaisa, Card)

Select  
    PM.MethodName , SUM(P.amount) as revenue 
From 
    Payment as P
    Join Payment_Method as PM
    ON P.MethodID = PM.MethodID 
Where  
    P.PaymentDate >= '2024-02-01' 
        and  P.PaymentDate < '2024-03-01'
Group By 
    P.MethodID , PM.MethodName
Order By 
    SUM(P.amount) desc

-- Question 09
--  Identify loyal customers who booked more than 3 times in the last quarter

Select 
    c.CustomerID,c.FullName
From 
    Booking as B 
    Join Customer as C
    On c.CustomerID = B.CustomerID
Where 
    B.BookingDate >= '2024-01-01' and  B.BookingDate < '2024-04-01'
Group By 
    c.CustomerID,c.FullName
Having 
    Count(b.BookingID) > 3

-- Question 10
--      Find services that have never been booked (dead inventory)

SELECT  
     s.ServiceID, s.ServiceName
From
    Service as s 
    Left JOIN Booking_Item AS bi
    On s.ServiceID = bi.ServiceID
    Left JOIN Booking AS B
    On B.BookingID = BI.BookingID
Group By 
    s.ServiceID, s.ServiceName
Having
     Count (b.BookingID) = 0

-- Question 11
--     Which technician handled the highest number of bookings in a given month?
Select TOP 1 
    T.FullName , 
    Count(BA.AssignmentID) AS highestnumberofbookings
From 
    Technician as T
    Join  Booking_Assignment as BA
    On T.TechnicianID = BA.TechnicianID
Where 
    BA.AssignedAt >= '2024-02-01' and  BA.AssignedAt < '2024-03-01'
Group By 
    T.FullName 
ORDER BY 
    Count(BA.AssignmentID) desc

-- Question 12 
--      Average customer rating per service category
Select 
   AVG(CAST(R.Rating AS FLOAT)) AS AverageRating , SC.CategoryName
From 
    Review as R
    -- 1 Review --> Booking_Assignment
    join Booking_Assignment as BA
    on BA.AssignmentID = R.AssignmentID
    -- 2 Booking_Assignment --> Booking
    JOIN Booking as B
    on B.BookingID = BA.BookingID
    -- 3 Booking --> Booking_Item
    join Booking_Item as BI
    on BI.BookingID = B.BookingID
    -- 4 Booking_Item --> Service
    join Service as s 
    on s.ServiceID = BI.ServiceID
    -- 5 Service --> Service_Category
    JOIN Service_Category as SC
    ON SC.CategoryID = s.CategoryID
GROUP BY    
    SC.CategoryName
ORDER BY 
    AverageRating DESC;
-- Question 13
--      Complaints that took more than 7 days to resolve
select 
    c.ComplaintID, 
    c.Description, 
    DATEDIFF(DAY,c.FiledDate,c.ResolvedDate) as timetaken
From 
    Complaint as c
Where 
    C.ResolvedDate IS NOT NULL and 
        DATEDIFF(DAY,c.FiledDate,c.ResolvedDate) > 7

-- Question 14
--       Total earnings generated per technician for the current month   

Select 
    SUM(P.Amount) AS TotalEarnings , T.FullName
From
    Payment as P
    -- 1 Payment --> Booking
    Join Booking as B
    On B.BookingID = p.BookingID
    -- 2 Booking --> Booking_Assignment
    Join Booking_Assignment as BA
    ON BA.BookingID = B.BookingID

    JOIN Technician AS T
    ON T.TechnicianID = BA.TechnicianID
Where
     BA.AssignedAt >= '2024-02-01' and  BA.AssignedAt < '2024-03-01'
Group By 
    T.FullName
ORDER BY 
    TotalEarnings DESC;
-- Question 15
--      Customers who applied a promo code, then re-booked without any promo

SELECT DISTINCT 
    C.CustomerID,
    C.FullName
FROM 
    Customer AS C
    -- 1 Booking with promo
    JOIN Booking AS B1
        ON B1.CustomerID = C.CustomerID
    -- 2 Booking_Promotion for the first booking
    JOIN Booking_Promotion AS BP
        ON BP.BookingID = B1.BookingID
    -- 3 Booking without promo after the first booking
    JOIN Booking AS B2
        ON B2.CustomerID = C.CustomerID
    -- 4 Ensure the second booking does not have a promotion
    LEFT JOIN Booking_Promotion AS BP2
        ON BP2.BookingID = B2.BookingID

WHERE
    -- First booking has a promotion
     BP.PromotionID IS NOT NULL
     -- Second booking does not have a promotion
    AND BP2.PromotionID IS NULL
    -- Ensure the second booking is after the first booking
    AND B2.BookingDate > B1.BookingDate;

-- Question 16
--          List all bookings where the scheduled date passed but status is still Pending

SELECT 
    B.BookingID
FROM
     Booking AS B
WHERE
     CAST(B.ScheduledDate AS DATE) < CAST(GETDATE() AS DATE) and b.Status = 'Pending'
    --WHERE B.ScheduledDate <  GETDATE() and b.Status = 'Pending'

-- Question 17
-- Which city generates the highest revenue for the company?

select TOP 1 
    SUM(P.Amount) AS revenue ,
    C.CityName
From
    Payment AS P 
    JOIN Booking AS B
    ON B.BookingID = P.BookingID
    JOIN City AS C
    ON C.CityID = B.ServiceCityID
GROUP BY 
    C.CityName
ORDER BY 
    SUM(P.Amount) DESC

-- Question 18
--      Technicians who are skilled in more than 3 service categories
SELECT 
    COUNT(DISTINCT  SC.CategoryID) AS Category_number ,
    T.FullName
FROM
    Technician AS T
    JOIN Technician_Skill AS TS
    ON T.TechnicianID = TS.TechnicianID
    JOIN Service AS S
    ON S.ServiceID = TS.ServiceID
    JOIN Service_Category AS SC
    ON SC.CategoryID = S.CategoryID
Group By 
    T.FullName
Having 
    COUNT(DISTINCT  SC.CategoryID) > 3

-- Question 19
--      -- Show the complete history of a specific booking
-- (items, technician, payment, review)

SELECT 
    B.BookingID,
    SC.CategoryName,
    S.ServiceName,
    T.FullName,
    P.Amount,
    R.Comments
FROM 
    Booking AS B
    --  Booking --> Booking_Item
    JOIN Booking_Item AS BI
        ON BI.BookingID = B.BookingID
    -- Booking_Item --> Service
    JOIN Service AS S
        ON S.ServiceID = BI.ServiceID
    -- Service --> Service_Category
    JOIN Service_Category AS SC
        ON SC.CategoryID = S.CategoryID
    -- Booking --> Booking_Assignment
    JOIN Booking_Assignment AS BA
        ON BA.BookingID = B.BookingID
    -- Booking_Assignment --> Technician
    JOIN Technician AS T
        ON T.TechnicianID = BA.TechnicianID
    -- Booking --> Payment
    LEFT JOIN Payment AS P
        ON P.BookingID = B.BookingID
    -- Booking_Assignment --> Review
    LEFT JOIN Review AS R
        ON R.AssignmentID = BA.AssignmentID
WHERE 
    B.BookingID = 7001;

-- Question 20
--      Rank all services by number of bookings in descending order

SELECT 
    S.ServiceName,
    COUNT(BI.BookingID) AS TotalBookings
FROM 
    Service AS S
    JOIN Booking_Item AS BI
        ON BI.ServiceID = S.ServiceID
GROUP BY 
    S.ServiceName
ORDER BY 
    TotalBookings DESC;
