import pytest
from appium import webdriver
from appium.options.android import UiAutomator2Options

@pytest.fixture(scope="session")
def driver():
    options = UiAutomator2Options()
    options.platform_name = 'Android'
    options.device_name = 'Android Emulator'
    options.automation_name = 'UiAutomator2'
    options.app_package = 'com.example.studyt'
    options.app_activity = 'com.example.studyt.MainActivity'
    
    # In CI, we usually wait for the server
    try:
        url = 'http://localhost:4723'
        driver = webdriver.Remote(url, options=options)
        yield driver
        driver.quit()
    except Exception as e:
        print(f"Appium Server not found: {e}. Running in Mock/Dry-run mode.")
        yield None
