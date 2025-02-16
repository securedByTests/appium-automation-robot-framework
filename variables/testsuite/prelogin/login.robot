*** Settings ***
Test Timeout    ${TEST_TIMEOUT_CONTROLPANEL}
Test Setup        Start Browser     ${login_url_category}     ${BROWSER}
Test Teardown     Close Application
Force Tags      login   ui

Resource          ../../Keyword/prelogin/login.robot

*** Test Cases ***
Test Case 1 : Login As A Webpro
    [Documentation]   This test case will login in to a webpro profile using existing email
    [Tags]            critical    valid       prod
        Enter Login Credentials     ${USER_EMAIL_VARIABLE}   ${USER_PASSWORD_VARIABLE}
        Click On Login Button
        Run Keyword If     '${environmentToRunTest}' != 'MOBILE'      Wait Until Page Contains Element    ${btn_add_client_locator}
        Run Keyword If     '${environmentToRunTest}' == 'MOBILE'      Wait Until Page Contains Element    ${tab_clients_locators}
        ${clients_url}=   Get Control Panel Base URL  ${client_url_category}
        Run Keyword If     '${environmentToRunTest}' != 'MOBILE'      Assert Page Url   ${clients_url}
        Run Keyword If     '${environmentToRunTest}' == 'MOBILE'      Assert Page Url From Android Device    ${clients_url}
