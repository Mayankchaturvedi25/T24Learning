    SUBROUTINE MKC.PreventFT
*------------------------------------------------------------------
* New check Routine to allow only INPUTTER (user) to Authorise FT records for a given version FT,MKC.NEW
*------------------------------------------------------------------
* Developer: Mayank Chaturvedi
* Date     : 28/03/2021
* Version  : 0.0.1
*-------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
   
    Input_user = R.NEW(FT.INPUTTER)

    IF V$FUNCTION = 'A' THEN
        IF FIELD(Input_user,'_',2) NE OPERATOR THEN
           E = 'Only ': FIELD(Input_user,'_',2):' is allowed to perform this action'
           
        END
    END
    RETURN
END
