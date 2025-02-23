-- function Action
CREATE OR REPLACE FUNCTION Action(v_INVOICE_STATUS in VARCHAR2)
    RETURN VARCHAR2 
IS 
    v_OUTPUT VARCHAR2(15);
BEGIN
    -- If v_INVOICE_STATUS is NULL, assign 'To verify' as default; otherwise, keep its original value
    v_OUTPUT := NVL( v_INVOICE_STATUS, 'To verify');
    -- Replacing 'Paid' with 'OK'
    v_OUTPUT := REPLACE( v_OUTPUT, 'Paid', 'OK');
    -- Replacing 'Pending' with 'To follow up'
    v_OUTPUT := REPLACE( v_OUTPUT, 'Pending', 'To follow up');
RETURN v_OUTPUT;
END;
/