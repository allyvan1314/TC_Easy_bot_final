# -*- coding: utf-8 -*-
*** Settings ***
Documentation     Trust Connect 2nd auto-fill bot on Easy Credit website
Library           RPA.Browser
Library           RPA.HTTP
Library           DateTime
Library           RPA.Database
Library           DatabaseLibrary
Library           RPA.Excel.Files


*** Keywords *** ***
Get Applications From Database
    ${port}=    Convert To Integer    1235
    RPA.Database.Connect To Database  pymysql  bot_data  bot  fvK@120jg7  203.205.21.92   ${port}
    @{table}            RPA.Database.Query    SELECT * FROM ec_transfer_data WHERE REMARK = 1;
    [Return]    ${table}

*** Keywords ***
Execute Step 0
    [Arguments]     ${Application}
    # Job type
    Click Element   //button[@data-id="employeeType"]
    Select From List By Label   id:employeeType     ${Application}[JOB_TYPE]
    # Docs
    Click Element   //button[@data-id="documents"]
    Select From List By Label   id:documents    ${Application}[DOCS]
    # LA
    ${w}    ${h}=   Get Element Size    id:js-rangeslider-0
    ${w}=           Evaluate    ${w}-15
    ${LA_min}=      Get Element Attribute  name:amtSlider   min
    ${LA_max}=      Get Element Attribute  name:amtSlider   max
    ${LA_step}=     Get Element Attribute  name:amtSlider   step
    ${LA_val}=      Get Element Attribute  id:amount   value
    ${Request_LA}=      set variable    ${Application}[REQUEST_LA]
    
    ${px_step}=     Evaluate    ${w}/((${LA_max}-${LA_min})/${LA_step})
    ${px_move}=     Evaluate    ((${Request_LA}-${LA_val})/${LA_step})*${px_step}
    
    log  ${w},${h},${LA_min},${LA_max},${LA_step},${LA_val},${Request_LA},${px_step},${px_move}
    Drag And Drop By Offset   //*[@id="js-rangeslider-0"]/div[2]   ${px_move}  0
    
    ## Tenor
    ${w}    ${h}=   Get Element Size    id:js-rangeslider-1
    ${T_min}=      Get Element Attribute  id:periodSlider   min
    ${T_max}=      Get Element Attribute  id:periodSlider   max
    ${T_step}=     Get Element Attribute  id:periodSlider   step
    ${T_val}=      Get Element Attribute  id:period   value
    ${Request_tenor}=   set variable    ${Application}[REQUEST_TENOR]
    
    ${px_step}=     Evaluate    ${w}/((${T_max}-${T_min})/${T_step})
    ${px_move}=     Evaluate    ((${Request_tenor}-${T_val})/${T_step})*${px_step}
    
    log  ${w},${h},${T_min},${T_max},${T_step},${T_val},${px_step},${px_move}
    Drag And Drop By Offset   //*[@id="js-rangeslider-1"]/div[2]   ${px_move}  0
    
    ## Submit
    Click Button   id:apply


*** Keywords ***
Execute Step 1
    [Arguments]     ${Application}
    
    # Personal Information
    ## Name
    Input Text  id:fullName     ${Application}[CUSTOMER_NAME]
    ## Gender
    Run Keyword If  '${Application}[GENDER]' == '1'     Click Element  //label[./input[@type="radio" and @value="M"]]
    Run Keyword If  '${Application}[GENDER]' == '2'     Click Element  //label[./input[@type="radio" and @value="F"]]
    ## DOB
    ${temp}=    Convert To String   ${Application}[DAY_OF_BIRTH]
    Click Element   //button[@data-id="birthDay"]
    Select From List By Label   id:birthDay     ${temp}
    ## MOB
    ${temp}=    Convert To String   ${Application}[MONTH_OF_BIRTH]
    Click Element   //button[@data-id="birthMonth"]
    Select From List By Value   id:birthMonth     ${temp}
    ## YOB
    ${temp}=    Convert To String   ${Application}[YEAR_OF_BIRTH]
    Click Element   //button[@data-id="birthYear"]
    Select From List By Label   id:birthYear     ${temp}
    ## Living province
    Click Element   //button[@data-id="province"]
    Select From List By Label   id:province     ${Application}[LIVING_ADDRESS_PROVINCE]
    
    # Identity document
    ## ID number
    Input Text  id:idNumber     ${Application}[ID_CARD]
    ## ID Issue Date
    ${temp}=    Convert To String   ${Application}[ID_ISSUE_DAY]
    Click Element   //button[@data-id="idDay"]
    Select From List By Label   id:idDay     ${temp}
    ## Month
    ${temp}=    Convert To String   ${Application}[ID_ISSUE_MONTH]
    Click Element   //button[@data-id="idMonth"]
    Select From List By Value   id:idMonth     ${temp}
    ## Year
    ${temp}=    Convert To String   ${Application}[ID_ISSUE_YEAR]
    Click Element   //button[@data-id="idYear"]
    Select From List By Label   id:idYear     ${temp}
    ## ID Issue Place
    Click Element   //button[@data-id="idIssuePlace"]
    Select From List By Label   id:idIssuePlace     ${Application}[ID_ISSUE_PROVINCE]
    
    # Contact Information
    ${id}=      Convert To String   ${Application}[LEAD_ID]
    ${var}=     Catenate   ${id}    @gmail.com
    Input Text  id:email        ${var}
    Input Text  id:cellPhone    ${Application}[CUSTOMER_PHONE]
    ## Check box
    Click Element    //label[./input[@type="checkbox" and @id="loanAppForm1Chbx"]]
    Click Element    //label[./input[@type="checkbox" and @id="loanAppForm1Chbx2"]]
    
    # Apply
    Click Button    id:nextButton

*** Keywords ***
Fill Permanent Address
    [Arguments]     ${Application}
    ${var}=     Convert To String   ${Application}[REG_ADDRESS_PROVINCE]
    Click Element   //button[@data-id="cityP"]
    Select From List By Label   id:cityP    ${var}
    ## District
    ${var}=     Convert To String   ${Application}[REG_ADDRESS_DISTRICT]
    Click Element   //button[@data-id="districtP"]
    Select From List By Label   id:districtP    ${var}
    ## Ward
    ${var}=     Convert To String   ${Application}[REG_ADDRESS_WARD]
    Click Element   //button[@data-id="wardP"]
    Select From List By Label   id:wardP    ${var}
    ## Street
    Input Text  id:streetP  ${Application}[REG_ADDRESS_STREET]

*** Keywords ***
Execute Step 2
    [Arguments]     ${Application}
    
    # Current Address
    ## District
    ${var}=     Convert To String   ${Application}[LIVING_ADDRESS_DISTRICT]
    Click Element   //button[@data-id="districtC"]
    Select From List By Label   id:districtC    ${var}
    ## Ward
    ${var}=     Convert To String   ${Application}[LIVING_ADDRESS_WARD]
    Click Element   //button[@data-id="wardC"]
    Select From List By Label   id:wardC    ${var}
    ## Street
    Input Text  id:streetC  ${Application}[LIVING_ADDRESS_STREET]
    
    # Permanent Address
    
    ## If same
    Run Keyword If  '${Application}[REGULAR_LIVING_ADDRESS]' == '1'     Click Element   //label[./input[@type="checkbox" and @id="sameAddr"]]
    ## If different
    Run Keyword If  '${Application}[REGULAR_LIVING_ADDRESS]' == '0'     Fill Permanent Address  ${Application}
    # Employment Information
    Click Element   //button[@data-id="jobType"]
    Select From List By Value   id:jobType  ${Application}[JOB_DETAIL_TYPE]
    
    # Submit
    Click Button    id:loanAppForm2Btn

*** Keywords ***
Execute Step 3
    [Arguments]     ${Application}
    
    # Income
    ## Salary Method
    Click Element   //button[@data-id="salaryMethod"]
    Select From List By Value   id:salaryMethod     ${Application}[SALARY_METHOD]
    ## Income expense
    Input Text  id:monthlyIncome              ${Application}[REAL_INCOME_MONTHLY]
    Input Text  id:otherIncome                ${Application}[OTHER_INCOME]
    Input Text  id:totalHouseHoldExpence      ${Application}[TOTAL_EXPENSE_MONTHLY]
    
    # Workplace
    ## Job title
    Select From List By Value   id:jobTitle     ${Application}[JOB_POSITION]
    ## Company name
    Input Text  name:employerName   ${Application}[COMPANY_NAME]
    ## Working province
    ${var}=     Convert To String   ${Application}[WORKING_ADDRESS_PROVINCE]
    Click Element   //button[@data-id="city"]
    Select From List By Label   id:city     ${var}
    ## District
    ${var}=     Convert To String   ${Application}[WORKING_ADDRESS_DISTRICT]
    Click Element   //button[@data-id="district"]
    Select From List By Label   id:district     ${var}
    ## Ward
    ${temp}=    Convert To String   ${Application}[WORKING_ADDRESS_WARD]
    Click Element   //button[@data-id="ward"]
    Select From List By Label   id:ward     ${temp}
    ## Street
    Input Text  name:employerAddress    ${Application}[WORKING_ADDRESS_STREET]
    
    #Submit
    Click Button    id:loanAppForm3Btn

*** Keywords ***
Fill Bank Info
    [Arguments]     ${Application}
    ## Bank name
    Wait Until Page Contains Element    name:bankName
    Click Element   //*[@id="bankInfo1"]/div/div/div/button
    Select From List By Label   name:bankName   ${Application}[CUSTOMER_BANK_NAME]
    ## Bank province
    Wait Until Page Contains Element    name:bankCity
    Click Element   //*[@id="bankInfo2"]/div/div/div/button
    Select From List By Label   name:bankCity   ${Application}[CUSTOMER_BANK_PROVINCE]
    ## Bank branch
    Wait Until Page Contains Element    name:bankLocation
    Click Element    //*[@id="bankInfo3"]/div/div/div/button
    Select From List By Index   name:bankLocation   1
    ## Bank account
    Input Text  id:accountNumber    ${Application}[CUSTOMER_BANK_ACCOUNT]

*** Keywords ***
Execute Step 4
    [Arguments]     ${Application}
    
    # Marital
    Select From List By Value   name:martialStatus  ${Application}[MARRITAL_STATUS]
    Select From List By Value   name:loanPurpose    ${Application}[LEND_PURPOSE]
    ${temp}=    Convert To String   ${Application}[DISBURSE_METHOD]
    Select From List By Value   name:disbursementChannel    ${temp}
    Run Keyword If  '${Application}[DISBURSE_METHOD]' == '2'    Fill Bank Info  ${Application}
    
    # Refference relationship
    Select From List By Value   name:relationshipType   ${Application}[REFERENCE_1_RELATIONSHIP]
    Input Text  name:relationshipName   ${Application}[REFERENCE_1_NAME]
    Input Text  id:relationshipPhone   ${Application}[REFERENCE_1_PHONE]
    
    Select From List By Value   name:relationshipType2   ${Application}[REFERENCE_2_RELATIONSHIP]
    Input Text  name:relationshipName2   ${Application}[REFERENCE_2_NAME]
    Input Text  id:relationshipPhone2   ${Application}[REFERENCE_2_PHONE]
    
    # Submit
    Click Button    id:loanAppFinalFormBtn

*** Keywords ***
Update status
    [Arguments]     ${Application}  ${status}
    ${port}=    Convert To Integer    1235
    DatabaseLibrary.Connect To Database  pymysql  bot_data  bot  fvK@120jg7  203.205.21.92   ${port}
    
    ${str}=     Catenate    UPDATE ec_transfer_data SET REMARK =    ${status}
    ${str}=     Catenate    ${str}       WHERE LEAD_ID = 
    ${str}=     Catenate    ${str}      ${Application}[LEAD_ID]
    ${str}=     Catenate    ${str}      ;
    Execute SQL String  ${str}

*** Tasks ***
Attach to running Chrome Browser
    Attach Chrome Browser    9222
    Go To    https://portal.easycredit.vn/extranet/loanRequestLanding.jsp?extranet=true]

*** Tasks ***
Execute Fill Form
    ${Applications}=    Get Applications From Database
    ${file}=   Get Current Date    UTC
    ${file_name}=   Catenate    ${file}     .xlsx
    Create Workbook     ${file_name}  
    FOR  ${Application}  IN  @{Applications}
        ${ex}=       Get Current Date    UTC
        ${res0}=     Run Keyword And Ignore Error    Execute Step 0  ${Application}
        ${res1}=     Run Keyword And Ignore Error    Execute Step 1  ${Application}
        ${res2}=     Run Keyword And Ignore Error    Execute Step 2  ${Application}
        ${res3}=     Run Keyword And Ignore Error    Execute Step 3  ${Application}
        ${res4}=     Run Keyword And Ignore Error    Execute Step 4  ${Application}
        
        
        ${res0}=     Convert To String   ${res0}
        ${res1}=     Convert To String   ${res1}
        ${res2}=     Convert To String   ${res2}
        ${res3}=     Convert To String   ${res3}
        ${res4}=     Convert To String   ${res4}
        
        &{row}=       Create Dictionary
        ...           Exec Time     ${ex}
        ...           Lead ID   ${Application}[LEAD_ID]
        ...           Step0   ${res0}
        ...           Step1   ${res1}
        ...           Step2   ${res2}
        ...           Step3   ${res3}
        ...           Step4   ${res4}
        
        Append Rows To Worksheet    ${row}  header=${TRUE}
        
        ${success_res}=     Convert To String    ('PASS', None)
        
        Run Keyword If    ${res4} == ${success_res}    Update status   ${Application}   3
        Run Keyword If    ${res4} != ${success_res}    Update status   ${Application}   2
        
        Go To    https://portal.easycredit.vn/extranet/loanRequestLanding.jsp?extranet=true]
    END
    Save Workbook






