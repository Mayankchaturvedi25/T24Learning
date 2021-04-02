    SUBROUTINE MKC.LocalRefTable
*------------------------------------------------------------------
* Routine to update the local ref REAPORTABLE field to Y when the
* balance is GT 10000 , This code will be further used in COB process
* and T24 Service.
*------------------------------------------------------------------
* Developer: Aaron Niyonzima(aaron@mathisi.io)
* Date     : 31/03/2021
* Version  : 0.0.1
*-------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY


    fn_acc = 'F.ACCOUNT' ;  f_acc = '' ; acc_rec = ''
    fn_cur = 'F.CURRENCY' ;  f_cur = '' ; cur_rec = ''
    curr_market = 1

    CALL OPF(fn_acc, f_acc)
    CALL OPF(fn_cur, f_cur)

    sel_cmd = 'SELECT ': fn_acc :' WITH CATEGORY EQ 6001 WITH WORKING.BALANCE GT 0'
    CALL EB.READLIST(sel_cmd, sel_list, '', rec_count, ret_code)

    FOR i = 1 TO rec_count
        acc_id = sel_list<i>
        CALL F.READ(fn_acc, acc_id, acc_rec, f_acc, err)
        USD_amount = acc_rec<AC.WORKING.BALANCE>
        currency = acc_rec<AC.CURRENCY>

        IF currency NE 'USD' THEN
        CALL F.READ(fn_cur, currency, cur_rec, f_cur, err)
        FIND curr_market IN cur_rec<EB.CUR.CURRENCY.MARKET> SETTING f_pos, v_pos THEN
         rate = cur_rec<EB.CUR.MID.REVAL.RATE, v_pos>
        END

        USD_amount = USD_amount * rate
        
    END
    IF USD_amount GE 10000 THEN
        CALL GET.LOC.REF('ACCOUNT', 'REPORTABLE', ac_pos)
        acc_rec<AC.LOCAL.REF, ac_pos> = 'Y'
        CALL F.WRITE(fn_acc, acc_id, acc_rec)
        CALL JOURNAL.UPDATE(acc_id)
    END
NEXT i

RETURN
END

