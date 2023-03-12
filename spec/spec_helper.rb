require 'selenium-webdriver'
require_relative '../lib/pages/base_page'
require_relative '../lib/pages/google_search_page'
require_relative '../lib/pages/yahoo_search_page'

class SpecHelper
  def setup
    case ENV['BROWSER']
    when 'chrome'
      driver_path = File.join(File.absolute_path('../support', __dir__), 'chromedriver')
      Selenium::WebDriver::Chrome::Service.driver_path = driver_path
      driver = Selenium::WebDriver.for :chrome
    when 'firefox'
      driver_path = File.join(File.absolute_path('../support', __dir__), 'geckodriver')
      Selenium::WebDriver::Firefox::Service.driver_path = driver_path
      driver = Selenium::WebDriver.for :firefox
    else
      raise "Invalid browser specified: #{ENV['BROWSER']}"
    end

    # Clear cookies
    driver.manage.delete_all_cookies

    # Maximize browser window
    driver.manage.window.maximize

    return driver
  end
end

RSpec.configure do |config|
  config.before(:all) do
    @spec_helper = SpecHelper.new
    @driver = @spec_helper.setup

    # Initialize google
    @google_search_page = GoogleSearchPage.new(@driver)

    # Initialize yahoo
    @yahoo_search_page = YahooSearchPage.new(@driver)
  end

  config.after(:all) do
    @driver.quit
  end
end
