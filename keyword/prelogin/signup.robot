*** Settings ***
Resource        ../common.robot
Variables       ../../locators/prelogin/signup.py
Variables       ../../variables/prelogin/signup.py

*** Keywords ***
Common Signup Process For New User
    [Documentation]     this is a common keyword to perform the signup process for a new user
        Enter Signup Step 1 Credentials
        Enter Signup Step 2 Credentials
        Click On Step 2 Create Webpro Account Button

Enter Signup Step 1 Credentials
    [Documentation]  Enters the user credentials, navigates to step 2 page
        ${random_test_email}=   Generate Random Username
        Set Suite Variable      ${SUITE_RANDOM_USER_EMAIL}      ${random_test_email}
        Enter Step 1 Signup Credentials     ${random_test_email}    ${USER_PASSWORD_VARIABLE}
        Click On Step 1 Continue Button
     [Return]   ${random_test_email}

Enter Signup Step 2 Credentials
    [Documentation]   Performs all the step 2 signup form input actions
        Wait Until Keyword Succeeds    10x    5s    Enter Firstname and Lastname in step 2 Signup   ${signup_test_firstname_variable}   ${signup_test_lastname_variable}
        Enter The Country And The Zipcode Fields In Signup     ${signup_test_country_variable}      ${signup_test_zipcode_variable}
        Run Keyword If  '${signup_test_street_address_variable}' != '${sdn_test_street_address_variable}'     Wait Until Keyword Succeeds    10x    5s    Validate If The State City Phonecode Fields Are Prepopulated    ${signup_test_state_variable}    ${signup_test_city_variable}    ${signup_test_phonecode_variable}
        Run Keyword If  '${signup_test_street_address_variable}' == '${sdn_test_street_address_variable}'     Wait Until Keyword Succeeds    10x    5s    Validate Sdn State And City
        Enter User Street Address And Phone Number Fields For Signup    ${signup_test_street_address_variable}   ${signup_test_phoneno_variable}
        Select The Terms And Conditions Checkbox

Validate SDN State and City
    [Documentation]     this keyword validates the state not prepopulated for an SDN user
        Wait Until Element Is Visible   ${drpdown_state_locator}     timeout=${EXPLICIT_TIMEOUT}
        Click Element   ${drpdown_state_locator}
        Input Text ${signup_test_state_variable} In ${drpdown_state_locator}
        Wait Until Page Contains Element And Click    ${dropdown_state_list_svg_locator}
        Click Element   ${drpdown_state_locator}
        Wait Until Page Contains Element    ${txt_city_locator}     timeout=${EXPLICIT_TIMEOUT}
        Input Text ${signup_test_city_variable} In ${txt_city_locator}

Verify Dashboard Url
    [Documentation]  Verifying the dashboard url
        Wait Until Page Contains    ${welcome_screen_variable}     timeout=${EXPLICIT_TIMEOUT}
        ${status}=    Run Keyword And Return Status      Wait Until Keyword Succeeds    5x  5s      Page Should Contain    ${client_profiling_form_variable}
        Run Keyword If    '${status}' == 'True'     Complete Intermediate Client Profiling Form Post Signup And Validate
        Run Keyword If    '${status}' != 'True'     Validate Client Navigation To Client Dashboard

Complete Intermediate Client Profiling Form Post Signup And Validate
    [Documentation]  Complete the intermediate Client Profiling Form
        ${client_profiling_url}=   Get Control Panel Base URL  ${client_profiling_url_category}
        Verify If User Created Successfully     ${client_profiling_url}
        Instantly Fill Up Client Profiling Form Details

Validate Client Navigation To Client Dashboard
    [Documentation]  Validate client navigation to Client Dashboard
        ${clients_url}=   Get Control Panel Base URL  ${client_url_category}
        Verify If User Created Successfully     ${clients_url}

Enter Step 1 Signup Credentials
    [Documentation]    This is to enter the email and password in the step 1 signup page
    [Arguments]    ${email}    ${pwd}
        Input Text ${email} In ${txt_email_locator}
        Input Text ${pwd} In ${txt_password_locator}

Click On Step 1 Continue Button
    [Documentation]    Clicks the continue button
        Wait Until Page Contains Element And Click    ${txt_email_locator}
        Wait Until Page Contains Element And Click    ${btn_continue_locator}

Enter Firstname And Lastname In Step 2 Signup
    [Documentation]   Enters the firstname and lastname for the user signup
    [Arguments]     ${firstname}    ${lastname}
        Input Text ${firstname} In ${txt_firstname_locator}
        Input Text ${lastname} In ${txt_lastname_locator}

Enter The Country And The Zipcode Fields In Signup
    [Documentation]   This will enter the country and zipcode values
    [Arguments]     ${country}      ${zipcode}
        Sleep   3s
        Wait Until Keyword Succeeds     5x  5s      Wait Until Page Contains Element And Click   ${drpdown_country_locator}
        Input Text ${signup_test_country_variable} In ${drpdown_country_locator}
        Wait Until Page Contains Element And Click    ${dropdown_list_svg_locator}
        Click Element   ${drpdown_country_locator}
        Input Text      ${txt_zipcode_locator}      ${zipcode}

Enter The City Name For Signup
    [Documentation]  keyword to only update the city value
    [Arguments]   ${city}
        Input Text ${city} In ${txt_city_locator}

Enter User Street Address And Phone Number Fields For Signup
    [Documentation]   This will update input the values for user address and phone number fields
    [Arguments]   ${address}    ${phoneno}
        Input Text ${address} In ${txt_st_address_locator}
        Input Text ${phoneno} In ${txt_phoneno_locator}

Validate If The State City Phonecode Fields Are Prepopulated
    [Documentation]   This is to validate the expected values from the state city and phonecode dropdowns
    [Arguments]     ${state}    ${city}    ${phonecode}
        Click Element   ${txt_st_address_locator}
        Validate Element Content   ${drpdown_state_locator}    ${state}
        Validate Text Field Content    ${city}   ${txt_city_locator}
        Validate Text Field Content    ${phonecode}   ${txt_phonecode_locator}

Select The Terms And Conditions Checkbox
    [Documentation]   Selects the accept terms and conditions checkbox
        Wait Until Page Contains Element     ${chkbox_terms_locator}    timeout=${EXPLICIT_TIMEOUT}
        Checkbox Should Not Be Selected     ${chkbox_terms_locator}
        Select The Checkboxes With Explicit Wait And Verify     ${chkbox_terms_locator}

Click On Step 2 Create Webpro Account Button
    [Documentation]   This will click on create webpro account button
        Element Should Be Enabled    ${btn_create_webpro_acc_locator}
        Log To Console  Submit Button is Enabled
        Wait Until Page Contains Element And Click     ${btn_create_webpro_acc_locator}

Verify If User Created Successfully
    [Documentation]   this keyword checks if the login is successful by validating the dashboard url
    [Arguments]     ${expected_url}
        ${actual_url}=     Get Location
        Should Be Equal     ${actual_url}   ${expected_url}
        Log To Console  User Created Successfully

Check if Submit Button is Disabled
    [Documentation]   This will check Submit button state
    [Arguments]     ${locator}
        Scroll Element Into View Dynamically    ${locator}  ${default_offset}
        Wait Until Page Contains Element     ${locator}     timeout=${EXPLICIT_TIMEOUT}
        ${get_button_state}=    Element Should Be Disabled    ${locator}
        Log To Console  Submit Button is Disabled

Validate Empty Field Error Messages
    Input Text ${blank_data_variable} In ${txt_firstname_locator}
    Input Text ${blank_data_variable} In ${txt_lastname_locator}
    Validate Element Content   ${validation_firstname_locator}     ${validation_fname_variable}
    Input Text  ${txt_zipcode_locator}  ${blank_data_variable}
    Validate Element Content    ${validation_lastname_locator}      ${validation_lname_variable}
    Input Text ${blank_data_variable} In ${txt_phonecode_locator}
    Validate Element Content     ${validation_zip_locator}       ${validation_zip_variable}
    Input Text ${blank_data_variable} In ${txt_phoneno_locator}
    Validate Element Content   ${validation_phonecc_locator}   ${validation_phonecc_variable}
    Input Text ${blank_data_variable} In ${txt_st_address_locator}
    Validate Element Content     ${validation_phoneno_locator}   ${validation_phone_variable}
    Input Text ${blank_data_variable} In ${txt_phoneno_locator}
    Validate Element Content   ${validation_street_locator}    ${validation_street_variable}
    Check if Submit Button is Disabled      ${btn_create_webpro_acc_locator}

Enter Invalid Data For Signup
    Enter Signup Step 2 Credentials
    Input Into Text Field   ${txt_zipcode_locator}  ${invalid_data_variable}
    Input Into Text Field   ${txt_phoneno_locator}  ${invalid_data_variable}