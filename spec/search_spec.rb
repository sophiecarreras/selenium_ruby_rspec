require 'selenium-webdriver'
require_relative '../lib/pages/google_search_page'

describe 'Search Engines' do
  before(:all) do
    # Initialize browser
    @driver = Selenium::WebDriver.for :chrome

    # Clear cookies
    @driver.manage.delete_all_cookies

    # Maximize browser window
    @driver.manage.window.maximize

    # Initialize page object
    @google_url = 'https://www.google.com/'
    @google_search_page = GoogleSearchPage.new(@driver, @google_url)
  end

  after(:all) do
    @driver.quit
  end

  it 'searches for a keyword and verifies the results on Google' do
    @google_search_page.visit
    @google_search_page.search('ruby')
    expect(@google_search_page.results_contain_keyword?('ruby')).to eq true
  end
end
