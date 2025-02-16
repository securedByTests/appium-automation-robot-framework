*** Settings ***
Library       BuiltIn
Library       String
Library       robot.utils
Library       DependencyLibrary
Library       AppiumLibrary
Library       DateTime
Library       custom_selenium_library.py
Library       custom_library.py
Resource      ../Keyword/prelogin/login.robot
Variables     ../Variable/common.py
Variables     ../Locator/common.py
Variables     ../Variable/environment.py
Variables     ../Variable/appium_config.py
Variables     ../Locator/appium_locators.py
Variables     ../Variable/${ENV}_authentication_variables.py

*** Keywords ***
Start Browser
    [Arguments]   ${category}   ${browser}
        ${Base_URL}=    Get Control Panel Base URL      ${category}
        Log To Console      ${Base_URL}
        Common Open Browser     ${Base_URL}     ${browser}
        Run Keyword If    '${environmentToRunTest}' != 'MOBILE'      Maximize Browser Window

Common Open Browser
    [Documentation]  keyword to have the open browser
    [Arguments]   ${URL}    ${browser}
        Run Keyword If      '${environmentToRunTest}' == 'GRID'   Go To Grid URL    ${URL}     ${browser}
        Run Keyword If      '${environmentToRunTest}' == 'BROWSERSTACK'   Configure BrowserStack  ${URL}  ${browser}
#        Run Keyword If      '${environmentToRunTest}' != 'BROWSERSTACK' and '${environmentToRunTest}' != 'GRID'   Go to URL Headless   ${URL}     ${browser}
        Run Keyword If      '${environmentToRunTest}' == 'MOBILE'       Open Mobile Application     ${URL}     ${browser}

Open Mobile Application
    [Documentation]   Keyword will open mobile application on an emulator device
    [Arguments]    ${URL}     ${browser}
        Run Keyword If      '${browser}'=='Chrome'      Open Chrome Mobile Application For Android      ${URL}      ${browser}

Go to URL Headless
    [Arguments]  ${URL}   ${browser}
        Run Keyword If      '${browser}'=='Chrome'    Start Headless Chrome Browser
        Run Keyword If      '${browser}'=='Firefox'     Start Headless Firefox Browser
        Go To   ${URL}

Go To Grid URL
    [Arguments]   ${URL}    ${browser}
        Set Library Search Order      BuiltIn     Selenium2Library      SeleniumLibrary     AppiumLibrary
        ${chrome_dc}=   Set Chrome Browser Desired Capabilities
#        ${firefox_dc}=   Set Firefox Browser Desired Capabilities
        Run Keyword If    '${browser}'=='Chrome'    Open Browser    ${URL}     ${browser}   remote_url=${HOST_URL}     desired_capabilities=${chrome_dc}
        Run Keyword If    '${browser}'=='Firefox'     Open Browser    ${URL}     ${browser}   remote_url=${HOST_URL}     #desired_capabilities=${firefox_dc}

Configure BrowserStack
    [Arguments]     ${URL}    ${browser}
        Run Keyword If      '${browser}' == '${BS_CHROME_BROWSER}'  Set BrowserStackDesired Capabilities And Execute    ${URL}      ${BS_CHROME_BROWSER}    ${BS_CHROME_BROWSER_VERSION}     ${BS_MAC_OS}     ${BS_MAC_OS_CURRENT_VERSION}
        Run Keyword If      '${browser}' == '${BS_SAFARI_BROWSER}'  Set BrowserStackDesired Capabilities And Execute    ${URL}      ${BS_SAFARI_BROWSER}    ${BS_SAFARI_BROWSER_VERSION_NEW}     ${BS_MAC_OS}     ${BS_MAC_OS_LATEST_VERSION}
        Run Keyword If      '${browser}' == '${BS_FIREFOX_BROWSER}'  Set BrowserStackDesired Capabilities And Execute    ${URL}      ${BS_FIREFOX_BROWSER}    ${BS_FIREFOX_BROWSER_VERSION_OLD}     ${BS_WINDOWS_OS}     ${BS_WINDOWS_OS_CURRENT_VERSION}

Set BrowserStackDesired Capabilities And Execute
    [Arguments]     ${URL}      ${BS_BROWSER}    ${BS_BROWSER_VERSION}    ${BS_OS}    ${BS_OS_VERSION}
        ${BS_REMOTE_URL}=   Set Variable    http://${username}:${accessKey}@hub.browserstack.com/wd/hub
        ${timestamp}=    Get Current Date    result_format=%d-%m-%Y
        ${BS_BUILD_TIMESTAMP}=    Catenate    ${BS_PROJECT}   ${timestamp}
        ${BROWSER_OS_CONFIG}=   Set Variable    ${BS_BROWSER}-${BS_BROWSER_VERSION}&${BS_OS}-${BS_OS_VERSION}
        ${BS_BUILD}=    Catenate    ${BS_BUILD_TIMESTAMP}   ${BROWSER_OS_CONFIG}
        Open Browser   url=${URL}   browser=${BS_BROWSER}   remote_url=${BS_REMOTE_URL}   desired_capabilities=browser:${BS_BROWSER},browser_version:${BS_BROWSER_VERSION},os:${BS_OS},os_version:${BS_OS_VERSION},project:${BS_PROJECT},name:${BS_NAME},build:${BS_BUILD},browserstack.idleTimeout:${TEST_TIMEOUT_LONG},browserstack.autoWait:${EXPLICIT_TIMEOUT},browserstack.networkLogs:true,browserstack.debug:true,resolution:${BS_DEFAULT_RESOLUTION},browserstack.geoLocation:${BS_INDIA},browserstack.maskBasicAuth:true,browserstack.wsLocalSupport:true,browserstack.console:errors

Set Chrome Browser Desired Capabilities
    [Documentation]  Create the desired capabilities object with which to instantiate the Chrome browser
        ${options}=    Evaluate   sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        Call Method  ${options}  add_argument  --no-sandbox
        Call Method  ${options}  add_argument   --disable-dev-shm-usage
        Call Method  ${options}  add_argument  ignore-certificate-errors
        ${caps}=    Call Method    ${options}    to_capabilities
    [Return]   ${caps}

Set Firefox Browser Desired Capabilities
    [Documentation]  Create the desired capabilities object with which to instantiate the Firefox browser
        ${profile}=    Evaluate   sys.modules['selenium.webdriver'].FirefoxProfile()   sys, selenium.webdriver
        ${caps}=    Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
        Set To Dictionary    ${caps}    marionette=True
        Call Method  ${profile}  add_argument  --no-sandbox
        Call Method  ${profile}  add_argument   --disable-dev-shm-usage
        Call Method  ${profile}  add_argument  ignore-certificate-errors
        ${caps}=    Call Method    ${profile}    to_capabilities
    [Return]   ${caps}

Open Chrome Mobile Application For Android
    [Documentation]   Keyword to Open a chrome browser Mobile Application on an emulator
    [Arguments]    ${URL}      ${browser}
        Set Library Search Order      AppiumLibrary      BuiltIn     Selenium2Library      SeleniumLibrary
        Open Application     ${APPIUM_SERVER}     udid=8BMX1CPET      browserName=${browser}      platformName=${APPIUM_PLATFORMNAME}     deviceName=${APPIUM_DEVICE_NAME}     appPackage=${APPIUM_PACKAGE_NAME}   appActivity=${APPIUM_ACTIVITY_NAME}     platformVersion=${APPIUM_PLATFORM_VERSION}     app_url=${APPIUM_APP}     automationName=${APPIUM_AUTOMATION_NAME}    browserstack.geoLocation=IN     proxy_type=node     browserstack.debug=true
        Custom Run Keyword If Element Present And Click     ${btn_appium_chrome_acceptandcontinue_locator}
        Custom Run Keyword If Element Present And Click      ${btn_appium_chrome_next_locator}
        Custom Run Keyword If Element Present And Click     ${lnk_appium_chrome_nothanks_locator}
        Input Text ${URL} In ${txt_appium_chrome_searchbar_locator}
        Wait Until Page Contains Element And Click     ${lbl_appium_chrome_searchbar_selecturl_locator}

Start Headless Chrome Browser
    [Documentation]    Starts a chrome browser to be stimualted on xvfb.
        ${options}=    Evaluate   sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        Call Method  ${options}  add_argument  --no-sandbox
        Call Method  ${options}  add_argument   --headless
        Call Method  ${options}  add_argument   --window-size\=1920x1080
        Call Method  ${options}  add_argument   --disable-dev-shm-usage
        Call Method  ${options}  add_argument  --start-maximized
        Call Method  ${options}  add_argument  ignore-certificate-errors
        Create Webdriver  Chrome  chrome_options=${options}
        Set Selenium Timeout    120s

Start Headless Firefox Browser
      [Documentation]  starts a firefox browser to be stimualted on xvfb
      ${profile}=    Evaluate   sys.modules['selenium.webdriver'].FirefoxProfile()   sys, selenium.webdriver
      ${caps}=  Evaluate  sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX  sys
      Set To Dictionary  ${caps}  CapabilityType.UNEXPECTED_ALERT_BEHAVIOUR=UnexpectedAlertBehaviour.ACCEPT
      #call method  ${profile}  add_argument  --start-maximized
      Create Webdriver  Firefox  firefox_profile=${profile}

Get Control Panel Base URL
    [Arguments]     ${url_category}
      ${BASE_URL}=  Catenate  ${controlpanel_protocol}://${controlpanel_environment}${url_category}
    [Return]  ${BASE_URL}


#####  Test Setup #####
Test Setup To Start Browser And To Login To A Webpro
    [Documentation]  keyword which will be executed as a setup for every test case
    [Arguments]   ${login_email}    ${login_password}   ${url_category}
        Start Browser     ${login_url_category}     ${BROWSER}
        Login To A Webpro And Verify Successful Login     ${login_email}    ${login_password}   ${url_category}

### Login to a webpro through UI ###
Login To A Webpro And Verify Successful Login
    [Documentation]  this keyword will login to a webpro using given credentials also validates if the user is logged in successfully
    [Arguments]   ${login_email}    ${login_password}   ${url_category}
        Enter Login Credentials     ${login_email}   ${login_password}
        Click On Login Button

Verify Page Url For Profiling Or Client Dashboard
    [Documentation]  this keyword will validate page url based on client profiling or client dashboard
    [Arguments]   ${url_category}
        Wait Until Page Contains Element    ${btn_add_client_locator}       timeout=${EXPLICIT_TIMEOUT}
        ${clients_url}=   Get Control Panel Base URL  ${url_category}
        Assert Page Url   ${clients_url}

Assert Page Url
    [Documentation]   this keyword checks if the login is successful by validating the dashboard url
    [Arguments]     ${expected_url}
        ${actual_url}=     Get Location
        Should Be Equal     ${actual_url}   ${expected_url}

Assert Page Url From Android Device
    [Documentation]   this keyword checks if the login is successful from an android device by validating the dashboard url
    [Arguments]     ${expected_url}
        ${actual_url}=     Get Text     ${appium_browser_url_locator}
        Should Contain   ${expected_url}     ${actual_url}

########################################
#### Logout from the user ####
Logout From The User Session
    [Documentation]   keyword to logout from the user
    [Arguments]   ${expected_url}
        Wait Until Page Contains Element    ${icon_user_avatar_locator}     timeout=${EXPLICIT_TIMEOUT}
        Wait Until Keyword Succeeds    5x    5s    Click Element    ${icon_user_avatar_locator}
        Wait Until Page Contains Element And Click    ${lnk_user_logout_locator}
        Wait Until Page Contains Element    ${btn_login_locator}       timeout=${EXPLICIT_TIMEOUT}
        ${actual_url}=     Get Location
        Should Be Equal     ${actual_url}   ${expected_url}
##########################################
Strip The Protocol From The Website Name
    [Documentation]  since the website after adding the http(s) protocol will be removed
    [Arguments]    ${website_name}
        ${https}=   Run Keyword And Return Status     Should Contain    ${website_name}    https://
        ${http}=   Run Keyword And Return Status     Should Contain    ${website_name}    http://
        ${website_name}=    Run Keyword If  '${https}' == 'True'   Remove String    ${website_name}     https://
        ...    ELSE IF    '${http}' == 'True'    Remove String    ${website_name}     http://
        ...    ELSE       Set Variable     ${website_name}
    [Return]   ${website_name}

Add The Protocol To The Website Name If Not Present
    [Documentation]  since the website after adding the http(s) protocol will be removed
    [Arguments]    ${website_name}
        ${http}=   Run Keyword And Return Status     Should Contain    ${website_name}    http
        ${website_name}=    Run Keyword If  '${http}' == 'False'   Catenate    https://${website_name}
        ...    ELSE       Set Variable     ${website_name}
    [Return]   ${website_name}

Open New Window With Link
    [Documentation]  to open a new window to access the link
    [Arguments]    ${url}
        Execute Javascript   window.open()
        Switch Window   locator=NEW
        Go To   ${url}

Close Window Switch Window And Reload Page
    [Documentation]  keyword to close the window and reload the page
    [Arguments]    ${title}
        Close Window
        Switch Window    title=${title}
        Sleep   5s
        Reload Page

Common Suite Setup
    [Documentation]    This runs before Suite Execution starts.
        No Operation

Common Test Teardown
    [Documentation]    This runs after the Suite execution completes.
    [Arguments]   ${expected_url_category}
        ${expected_url}=    Get Control Panel Base URL     ${expected_url_category}
        Logout from the user session    ${expected_url}
        Close All Browsers

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})

Input Text ${value} In ${locator}
    [Documentation]  This is to input the value in the locator.
        Wait Until Page Contains Element	${locator}
		Input Text	${locator}	${value}

Wait Until Page Contains Element And Click
    [Documentation]  keyword to combine the element wait and then click on element including the explicit timeout
    [Arguments]    ${locator}
        Wait Until Page Contains Element     ${locator}
        Click Element   ${locator}

Custom Run Keyword If Element Present And Click
    [Documentation]   Keyword to execute the following code if the page contains element
    [Arguments]     ${locator}
        ${value}=   Run Keyword And Return Status    Wait Until Page Contains Element   ${locator}
        Run Keyword If    '${value}' == 'True'     Wait Until Page Contains Element And Click    ${locator}

Set Focus To Element And Click
    [Documentation]  Will focus on the element on the page and perform the click element operation
    [Arguments]    ${locator}
        Wait Until Element Is Enabled     ${locator}    timeout=${EXPLICIT_TIMEOUT}
        Set Focus To Element     ${locator}
        Wait Until Page Contains Element And Click   ${locator}

Validate Element Content
    [Documentation]   This keyword is validating the content of the element as expected according to the given locator
    [Arguments]     ${actual_value_locator}     ${expected_value}
        Wait Until Page Contains Element	${actual_value_locator}      timeout=${EXPLICIT_TIMEOUT}
        Wait Until Element Is Enabled	${actual_value_locator}
        ${actual_message}=   Get Text  ${actual_value_locator}
        Log To Console   ${actual_message}
        Should Be Equal     ${actual_message}     ${expected_value}

Validate Text Field Content
    [Documentation]   keyword to validate the text field content
    [Arguments]   ${expected_value}  ${actual_value_locator}
        Wait Until Page Contains Element	${actual_value_locator}      timeout=${EXPLICIT_TIMEOUT}
        Wait Until Element Is Enabled	${actual_value_locator}
        ${actual_message}=   Get Value  ${actual_value_locator}
        Log To Console   ${actual_message}
        Should Be Equal     ${actual_message}     ${expected_value}

Input Into Text Field
    [Arguments]    ${field}    ${text}
    [Documentation]    Keyword is just an input text keyword. That clears the text field dynamically.
    ${field text}=    Get Value    ${field}
    ${field text length}=    Get Length    ${field text}
    Clear Field of Characters    ${field}    ${field text length}
    Press Keys    ${field}    ${text}

Clear Field Of Characters
    [Arguments]    ${field}    ${character count}
    [Documentation]    This keyword pushes the delete key (ascii: \8) a specified number of times in a specified field.
    :FOR    ${index}    IN RANGE    ${character count}
     \   Press Keys    ${field}    BACKSPACE

Scroll Element Into View Dynamically
    [Documentation]   keyword to scroll the element into view dynamically
    [Arguments]    ${locator}    ${offset}
        Wait Until Page Contains Element    ${locator}      timeout=${EXPLICIT_TIMEOUT}
        ${btn_vertical_position}=   Get Vertical Position    ${locator}
        ${offset_value}=    Evaluate     ${btn_vertical_position} - ${offset}
        Scroll Page To Location    0   ${offset_value}

Select The Checkboxes With Explicit Wait And Verify
    [Documentation]  keyword to select the checkboxes
    [Arguments]     ${locator}
        Wait Until Page Contains Element    ${locator}      timeout=${EXPLICIT_TIMEOUT}
        Select Checkbox     ${locator}
        Checkbox Should Be Selected    ${locator}

Unselect The Checkboxes With Explicit Wait And Verify
    [Documentation]  keyword to unselect the checkboxes
    [Arguments]     ${locator}
        Wait Until Page Contains Element    ${locator}      timeout=${EXPLICIT_TIMEOUT}
        Unselect Checkbox     ${locator}
        Checkbox Should Not Be Selected    ${locator}