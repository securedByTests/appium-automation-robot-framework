
*** Settings ***
Library     AppiumLibrary
Resource    ../Keyword/Amazon.robot


*** Test Cases ***
Signing In To Amazon Shopping Account With Valid Credentials
    [Documentation]   checking login is happening with valid creds or not
        Launching And Signing In To Amazon Shopping Application   ${VALID_EMAIL_ID}    ${VALID_PASSWORD}
        Wait Until Page Contains Element     ${LEFT_NAV_PANEL}
        Sleep  3s
        Click Element   ${LEFT_NAV_PANEL}
        Page Should Contain Text   Hello, heena
        [Teardown]     Close Application


Signing In To Amazon Shopping Account With Invalid Credentials
    [Documentation]   checking login is happening with invalid creds or not
        Launching And Signing In To Amazon Shopping Application   ${VALID_EMAIL_ID}    ${INVALID_PASSWORD}
        Wait Until Page Contains Element   ${ERROR_PASSWORD}
        Page Should Contain Element  ${ERROR_PASSWORD}
        [Teardown]     Close Application


Searching And Adding Searched Product To Cart
    [Documentation]   checking products
    [Tags]   final
        Launching And Signing In To Amazon Shopping Application   ${VALID_EMAIL_ID}    ${VALID_PASSWORD}
        Sleep  3s
        Wait Until Page Contains Element    ${SEARCH}
        Click Element   ${SEARCH}
        sleep   10s
        Input Text   ${SEARCH_TEXT}   OnePlus 7T (Glacier Blue, 8GB RAM, Fluid AMOLED Display, 128GB Storage, 3800mAH Battery)
        Click Element   	id=in.amazon.mShop.android.shopping:id/action_bar_cart_count
#        Wait Until Page Contains Element    //android.widget.Button[content-desc='Buy Amazon Fresh Items']
        Sleep  3s
        Click Element At Coordinates   45   279
        Sleep  3s
        Click Element At Coordinates    507   1503
        Close Application
