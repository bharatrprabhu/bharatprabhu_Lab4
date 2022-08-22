-- Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
--
select t2.cus_gender as Gender,count(t2.cus_gender) as Gender_Count from (SELECT customer.CUS_ID, customer.CUS_NAME, customer.cus_gender,sum(orderS.ord_amount)
FROM customer
INNER JOIN orders ON orders.CUS_ID=customer.CUS_ID group by customer.cus_id having sum(orders.ord_amount)>3000) as t2
group by t2.cus_gender;
--
-- Display all the orders along with product name ordered by a customer having Customer_Id=2
--
SELECT orders.*,product.pro_name
  FROM orders
  INNER JOIN supplier_pricing
  ON orders.pricing_id = supplier_pricing.pricing_id
  INNER JOIN product
  ON supplier_pricing.pro_id = product.pro_id where orders.cus_id=2 order by orders.ord_date;
 -- 
 -- Display the Supplier details who can supply more than one product.
 --
  SELECT supplier.*, count(*) as Products FROM supplier
   INNER JOIN supplier_pricing
  ON supplier.supp_id = supplier_pricing.supp_id group by supplier.supp_id having count(*)>1 order by products desc;
  -- 
  -- Find the least expensive product from each category and print the table with category id, name, product name and price of the product
  SELECT category.*, product.pro_name, min(supplier_pricing.supp_price) as price FROM category
  inner join product on category.cat_id=product.cat_id
  inner join supplier_pricing on product.pro_id=supplier_pricing.pro_id
  group by category.cat_id;
  -- 
  -- Display the Id and Name of the Product ordered after “2021-10-05”.
  --
  SELECT product.pro_id, product.pro_name, orders.ord_date  FROM orders
   inner join supplier_pricing on orders.pricing_id=supplier_pricing.pricing_id
   inner join product on supplier_pricing.pro_id=product.pro_id
  WHERE orders.ord_date>'2021-10-05';
  --
  -- Display customer name and gender whose names start or end with character 'A'.
  --
  select cus_Name,Cus_Gender from customer where cus_name like 'A%' or cus_name like '%A';
 
  --
  -- Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
  --
  drop procedure if exists DisplaySupplier;
  DELIMITER #
  create procedure DisplaySupplier()
  Begin
	SELECT  supplier.SUPP_ID, supplier.SUPP_NAME,
    case 
    when rating.RAT_RATSTARS=5 then 'Excellent Service'
    when  rating.RAT_RATSTARS>4 then 'Good Service'
    when  rating.RAT_RATSTARS>2 then 'Average Service'
    else 'Poor Service'
    end as 'Type of Service'
    FROM supplier
    inner join supplier_pricing on supplier.SUPP_ID= supplier_pricing.SUPP_ID
    inner join orders on  supplier_pricing.PRICING_ID=orders.PRICING_ID
    inner join rating on  orders.ord_id=rating.ord_id Group by supplier.SUPP_ID order by avg(rating.RAT_RATSTARS) desc;
  End#
  DELIMITER ;
  
  call DisplaySupplier();
  