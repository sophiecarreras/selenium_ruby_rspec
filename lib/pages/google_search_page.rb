require 'selenium-webdriver'
require_relative 'base_page'

class GoogleSearchPage < BasePage
  SEARCH_BAR = { name: 'q' }
  SEARCH_RESULTS = 'div.result'
  SEARCH_RESULT_LINK = 'a'
  SEARCH_RESULT_TITLE = 'h3'
  SEARCH_RESULT_DESCRIPTION = 'span.st'

  def search(keyword)
    puts "Searching for #{keyword}..."
    @driver.find_element(SEARCH_BAR).send_keys(keyword)
    @driver.find_element(SEARCH_BAR).submit
    puts "Search complete."
  end

  def get_results
    puts "Getting search results..."
    search_results = []
    result_items = @driver.find_elements(:css, SEARCH_RESULTS)
    result_items.each do |item|
      link = item.find_element(:css, SEARCH_RESULT_LINK).attribute('href')
      title = item.find_element(:css, SEARCH_RESULT_TITLE).text
      description = item.find_element(:css, SEARCH_RESULT_DESCRIPTION).text
      search_results << { link: link, title: title, description: description }
    end
    puts "Search results: #{search_results}"
    search_results
  end

  def results_contain_keyword?(keyword)
    puts "Checking if search results contain #{keyword}..."
    search_results = get_results
    search_results.any? do |result|
      result[:link].downcase.include?(keyword.downcase) ||
        result[:title].downcase.include?(keyword.downcase) ||
        result[:description].downcase.include?(keyword.downcase)
    end
  end
end
