*** Settings ***
Test Timeout    ${TEST_TIMEOUT_CONTROLPANEL}
Test Setup        Start Browser     ${signup_url_category}     ${BROWSER}
Test Teardown     Close All Browsers
Force Tags      signup      ui

Resource          ../../Keyword/prelogin/signup.robot
Resource          ../../Keyword/common.robot

*** Test Cases ***
Test Case 1 : Signup A Webpro
    [Documentation]    This is to create a webpro going through the step1 and step2 signup forms
    [Timeout]       ${TEST_TIMEOUT_LONG}
    [Tags]            critical   valid       ignoreinprod
        Common Signup Process For New User
        Verify Dashboard Url