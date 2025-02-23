-- Orders summary Procedure
CREATE OR REPLACE PROCEDURE ORDERS_SUMMARY
    AS
    cursor1 SYS_REFCURSOR;
    BEGIN
        open cursor1 for
    SELECT "Order Reference", "Order Period", "Supplier Name", "Order Total Amount", "Order Status", "Invoice Reference", "Invoice Total Amount", "Action" FROM (

    -- Extracting numeric order reference by removing 'PO' prefix and leading zeros
    SELECT DISTINCT LTRIM(REPLACE(B.ORDER_REF, 'PO',''), '0') AS "Order Reference",
    -- Formatting order date to 'MON-YY'
    TO_CHAR(B.ORDER_DATE, 'MON-YY') AS "Order Period",
    -- Formatting supplier name to have only the first letter of each word capitalized
    INITCAP(C.SUPPLIER_NAME) AS "Supplier Name",
    -- Formatting order total amount with proper currency formatting
    TO_CHAR(B.ORDER_TOTAL_AMOUNT, '99,999,990.00') AS "Order Total Amount",
    -- Keeping the order status as it is in the database
    B.ORDER_STATUS AS "Order Status",
    A.INVOICE_REFERENCE AS "Invoice Reference",
    -- Formatting invoice total amount
    TO_CHAR(A.INVOICE_AMOUNT, '99,999,990.00') AS "Invoice Total Amount",   
    -- Calling the function Action to transform the invoice status accordingly
    ACTION(A.INVOICE_STATUS) AS "Action",
    ORDER_DATE
    FROM BCM_INVOICE A
    -- Joining the tables to fetch proper details
    INNER JOIN BCM_ORDER B ON B.ORDER_ID = A.ORDER_ID
    INNER JOIN BCM_SUPPLIER C ON C.SUPPLIER_ID = B.SUPPLIER_ID
    );
    DBMS_SQL.RETURN_RESULT(cursor1);
    END;
    /            