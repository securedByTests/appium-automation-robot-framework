# step 1
txt_email_locator = '//input[@name="email"]'
txt_password_locator = '//input[@name="password"]'
btn_continue_locator = '//button[(text()="Sign Up")]'

# step 2
label_email_text_locator = '//span[@class="email-text"]'
img_edit_email_locator = '//img[@class="image-container cursor-pointer"]'
img_back_icon_locator = '//img[@class="back-image-container cursor-pointer"]'

txt_firstname_locator = '//input[@name="firstName"]'
txt_lastname_locator = '//input[@name="lastName"]'

drpdown_country_locator = 'xpath=(//input[@type="text" and contains(@id,"react-select-")])[1]'
dropdown_list_svg_locator = 'xpath=//div[@id="react-select-2-option-1"]'
txt_zipcode_locator = '//input[@name="zipCode"]'

drpdown_state_locator = 'xpath=//*[text()="Maharashtra"]'
txt_city_locator = '//input[@name="city"]'
txt_st_address_locator = '//input[@name="address"]'
txt_phonecode_locator = '//input[@name="code"]'
txt_phoneno_locator = '//input[@name="phone"]'
chkbox_terms_locator = '//input[@name="check"]'
btn_create_webpro_acc_locator = '//button[text()="Create Maestro Account"]'

validation_firstname_locator = '//div[contains(text(),"Please enter first name")]'
validation_lastname_locator = '//div[contains(text(),"Please enter last name")]'
validation_zip_locator = '//div[contains(text(),"Please enter zipcode")]'
validation_phonecc_locator = '//div[contains(text(),"Please enter country phone code")]'
validation_phoneno_locator = '//div[contains(text(),"Please enter phone number")]'
validation_street_locator = '//div[contains(text(),"Please enter address")]'
validation_city_locator = '//div[contains(text(),"Please enter city")]'

validation_invalid_zip_locator = '//div[contains(text(),"Invalid input, alphanumeric required")]'