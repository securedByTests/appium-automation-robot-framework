*** Settings ***
Library     AppiumLibrary
Variables    ../variables/AmazonVariable.py
Variables    ../locators/AmazonLocator.py
Variables    ../variables/CommonVariables.py


*** Keywords ***
Launching And Signing In To Amazon Shopping Application
     [Arguments]     ${EMAIL_ID}   ${PASSWORD}
      Open Application     ${APPIUM_SERVER}     udid=emulator-5554   platformName=${APPIUM_PLATFORMNAME}     deviceName=${APPIUM_DEVICE_NAME}     appPackage=${APPIUM_PACKAGE_NAME}   appActivity=${APPIUM_ACTIVITY_NAME}
      Click Element   ${SIGN_IN}
      sleep  3s
      Wait Until Page Contains Element   ${EMAIL_ID_TEXTFIELD}
      Wait Until Element Is Visible   ${EMAIL_ID_TEXTFIELD}
      Input Text   ${EMAIL_ID_TEXTFIELD}   ${EMAIL_ID}
      Click Element   ${CONTINUE_BTN}
      Wait Until Page Contains Element   ${EMAIL_PASSWORD}
      Input Password   ${EMAIL_PASSWORD}    ${PASSWORD}
      Wait Until Page Contains Element     ${LOGIN_BTN}
      Click Element     ${LOGIN_BTN}
