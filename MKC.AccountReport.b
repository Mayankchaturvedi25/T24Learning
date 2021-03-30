    SUBROUTINE MKC.AccountReport
*------------------------------------------------------------------
* Routine to fetch the account balance and name
*------------------------------------------------------------------
* Developer: Mayank Chaturvedi
* Date     : 30/03/2021
* Version  : 0.0.1
* -----------------------------------------------------------------   

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.SECTOR
    $INSERT I_F.CUSTOMER

    fn_acc = 'F.ACCOUNT'
    f_acc = ''
    acc_rec = ''

    fn_cat = 'F.CATEGORY'
    f_cat = ''
    cat_rec = ''
    cat_desc = ''

    fn_sec = 'F.SECTOR'
    f_sec = ''
    sec_rec = ''
    sec_desc = ''

    fn_cus = 'F.CUSTOMER'
    f_cus = ''
    cus_rec = ''
   
    acc_bal = '' ;  acc_title = '' ; category = '' ; cust_id = ''
    
    outdata = 'Account Nb*Customer Id*Account Title*Category (Description)*Currency*Working Balance'
    outdata := '*Customer Sector (Description)'
    folder = '../bnk.log/MAYANK.LOG'
    report_name = 'account-report.csv'

    CALL OPF(fn_acc, f_acc)
    CALL OPF(fn_cat, f_cat)
    CALL OPF(fn_sec, f_sec)
    CALL OPF(fn_cus, f_cus)

    sel_cmd = 'SELECT ': fn_acc :' WITH WORKING.BALANCE GT 0'
    CALL EB.READLIST(sel_cmd, acc_list, '', total_rec, ret_code)

    FOR i = 1 TO total_rec
        acc_id = acc_list<i>
        CALL F.READ(fn_acc, acc_id, acc_rec, f_acc, err)
        cust_id   = acc_rec<AC.CUSTOMER>
        acc_category  = acc_rec<AC.CATEGORY>
        acc_title = acc_rec<AC.ACCOUNT.TITLE.1>
        acc_bal   = acc_rec<AC.WORKING.BALANCE>
        acc_currency = acc_rec<AC.CURRENCY>

        CALL F.READ(fn_cus, cust_id, cus_rec, f_cus, err)
        sector  = cus_rec<Customer_Sector>

        CALL F.READ(fn_sec, sector, sec_rec, f_sec, err)
        sec_desc = sec_rec<Sector_Description>

        CALL F.READ(fn_cat, acc_category, cat_rec, f_cat, err)
        cat_desc  = cat_rec<Category_Description>

        outdata<-1> = acc_id :'*': cust_id :'*': acc_title :'*': cat_desc :'*': acc_currency :'*': acc_bal :'*': sec_desc
    NEXT i

    CHANGE FM TO CHAR(10) IN outdata

    CALL WriteFile(folder, report_name, outdata, err)

    RETURN
END
