*** Settings ***
Resource        ../common.robot
Variables       ../../locators/prelogin/login.py
Variables       ../../variables/prelogin/login.py

*** Keywords ***
Enter Login Credentials
    [Documentation]   This keyword is to locate and input the login email and password fields
    [Arguments]     ${email}      ${password}
        Custom Run Keyword If Element Present And Click      ${img_appium_googletranslateclose_locator}
        Input Text ${email} In ${input_email_locator}
        Input Text ${password} In ${input_pwd_locator}

Click On Login Button
    [Documentation]   This will locate the login button and clicks on it
        Wait Until Page Contains Element And Click    ${btn_login_locator}
        Custom Run Keyword If Element Present And Click      ${btn_appium_neversavepassword_locator}
