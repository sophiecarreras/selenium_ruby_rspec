require 'selenium-webdriver'
require 'rspec'

class BasePage
  GOOGLE_URL = 'https://www.google.com/ncr'.freeze
  YAHOO_URL = 'https://search.yahoo.com/'.freeze

  def initialize(driver)
    @driver = driver
  end

  def visit
    @driver.get(url)
  end

  def visit_search_engine(search_engine)
    case search_engine.downcase
    when 'google'
      @driver.get(GOOGLE_URL)
    when 'yahoo'
      @driver.get(YAHOO_URL)
    else
      raise ArgumentError, "Unsupported search engine: #{search_engine}"
    end
  end

  def url
    raise NotImplementedError, 'Subclasses should implement url method'
  end

  def find(locator)
    @driver.find_element(locator)
  end

  def find_all(locator)
    @driver.find_elements(locator)
  end

  def click(locator)
    find(locator).click
  end

  def fill_in(locator, with:)
    find(locator).send_keys(with)
  end

  def wait_for(timeout: 5, message: nil)
    Selenium::WebDriver::Wait.new(timeout: timeout).until { yield }
  rescue Selenium::WebDriver::Error::TimeOutError
    message ||= "Timed out after #{timeout} seconds waiting for condition."
    raise message
  end

  def displayed?(locator)
    find(locator).displayed?
  end

  def wait_for_element(locator, timeout: 10)
    wait_for(timeout: timeout, message: "Element not found: #{locator}") do
      @driver.find_element(locator)
    end
  end

  def wait_until_elements_visible(locator, timeout: 10)
    wait_for(timeout: timeout, message: "Elements not visible: #{locator}") do
      elements = find_all(locator)
      elements.all?(&:displayed?)
    end
  end

  def wait_until_elements_not_visible(locator, timeout: 10)
    wait_for(timeout: timeout, message: "Elements still visible: #{locator}") do
      elements = find_all(locator)
      elements.none?(&:displayed?)
    end
  end

  def wait_until_element_text(locator, expected_text, timeout: 10)
    wait_for(timeout: timeout, message: "Element text not matching: #{locator}") do
      element = find(locator)
      element.text == expected_text
    end
  end

  def quit
    @driver.quit
  end
end
