img_appium_googletranslateclose_locator = 'id=com.android.chrome:id/infobar_close_button'
input_email_locator = 'xpath=//android.view.View[1]/android.widget.EditText[@index=1]'
input_pwd_locator = 'xpath=//android.view.View[2]/android.widget.EditText[@index=1]'

btn_login_locator = '//android.view.View[4]/android.widget.Button'
btn_appium_neversavepassword_locator = 'id=com.android.chrome:id/button_secondary'
tab_clients_locators = '//android.view.View/android.view.View[2]/android.widget.ListView/android.view.View[1]/android.view.View'
btn_add_client_locator = '//android.view.View[1]/android.view.View/android.view.View/android.view.View[1]/android.widget.Button'

# Error Messages
auth_error_locator = '//span[@class="help-block"]/div[contains(text(),"Login failed. Please try again.")]'
emailreq_error_locator = '//span[@class="help-block"]/div[contains(text(),"Please enter email address")]'
pwdreq_error_locator = '//span[@class="help-block"]/div[contains(text(),"Please enter password")]'
emailnotvalid_locator = '//span[@class="help-block"]/div[contains(text(),"Email not valid")]'
