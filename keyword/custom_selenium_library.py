import time

from Selenium2Library import Selenium2Library
from robot.api.deco import keyword
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
# from asyncio.tasks import sleep
from selenium.webdriver.support.wait import WebDriverWait


# from logilab.common.proc import TimeoutError

# create new class that inherits from Selenium2Library
class custom_selenium_library(Selenium2Library):
    # create a new keyword called "get webdriver instance"

    def get_current_title(self):
        driver = self._current_browser()
        title = driver.title
        print(title)
        return title

    # generate random domain name
    @keyword
    def handle_firefox_alert(self):
        driver = self._current_browser()
        driver.switch_to.alert.accept()

    @keyword
    def generate_plan_name(self):
        timestamp = int(round(time.time()))
        planname = 'testplan' + str(timestamp)
        return planname

    @keyword
    def end_of_text_area(self, xpath, text):
        driver = self._current_browser()
        driver.find_element_by_xpath(xpath).send_keys(Keys.END + text)

    @keyword
    def generate_customer_username(self):
        timestamp = int(round(time.time()))
        customer_name = 'testcustomer' + str(timestamp)
        return customer_name

    @keyword
    def get_current_url(self):
        driver = self._current_browser()
        return driver.current_url

    @keyword
    def set_page_load_timeout(self, time):
        driver = self._current_browser()
        driver.set_page_load_timeout(time)

    @keyword
    def click_element_custom(self, locator_xpath):
        driver = self._current_browser()
        # driver.set_window_size(1920,1080)
        # driver.set_page_load_timeout(120)
        print("found element")
        element = driver.find_elements_by_xpath('//div[@id="manage-profile-holder"]/a')
        print(len(element))
        print(element[0])
        print("clicking element")
        element[0].click()
        time.sleep(5)
        actions = ActionChains(driver)
        size = driver.get_window_size()
        actions.click_and_hold(driver.find_element_by_xpath('//div[@id="manage-profile-holder"]/a')).perform()
        print(size)
        element = WebDriverWait(driver, 20).until(
            EC.element_to_be_clickable(By.LINK_TEXT, "Sign Out"));
        print(element)
        print(element.get_attribute('href'))
        # actions.move_to_element(element).click(element).perform()
        driver.get(element.get_attribute('href'))
        # element.click()
        # element.send_keys(Keys.RETURN)
        print("clicked")

    def wait_until_atleast_one_element_contains(self, locator_array, expected):
        expectedfound = False
        elements = self.find_elements(locator_array)
        texts = []
        for element in elements:
            if element is not None:
                if element.text == expected:
                    expectedfound = True
                    break
        if expectedfound == False:
            message = "Elements '%s' should have contained text '%s' but " \
                      "its text was not found." % (locator_array, expected)
            raise AssertionError(message)

        self.info("Elements '%s' contains text '%s'." % (locator_array, expected))
