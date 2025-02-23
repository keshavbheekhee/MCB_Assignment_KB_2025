CREATE OR REPLACE PROCEDURE MEDIAN_ORDER_TOTAL_AMOUNT
AS  
    cursor1 SYS_REFCURSOR;
    median_amount NUMBER;
BEGIN 
    -- Get the median Order Total Amount
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ORDER_TOTAL_AMOUNT) 
    INTO median_amount
    FROM BCM_ORDER;

    -- Open the cursor to retrieve the order with the median amount
    OPEN cursor1 FOR
    WITH selection_criteria AS (
        SELECT DISTINCT
            LTRIM(REPLACE(A.ORDER_REF, 'PO', ''), '0') AS "Order Reference",
            TO_CHAR(A.ORDER_DATE, 'DD-MON-YYYY') AS "Order Date",
            UPPER(B.SUPPLIER_NAME) AS "Supplier Name",
            TO_CHAR(A.ORDER_TOTAL_AMOUNT, '99,999,990.00') AS "Order Total Amount",
            A.ORDER_STATUS AS "Order Status",
            (SELECT LISTAGG(INVOICE_REFERENCE, '|') 
             FROM BCM_INVOICE INV 
             WHERE INV.ORDER_ID = A.ORDER_ID) AS "Invoice Reference"
        FROM BCM_ORDER A
        INNER JOIN BCM_SUPPLIER B ON B.SUPPLIER_ID = A.SUPPLIER_ID
        WHERE A.ORDER_TOTAL_AMOUNT = median_amount
    )
    SELECT * FROM selection_criteria;
    
    DBMS_SQL.RETURN_RESULT(cursor1);
END;
/
