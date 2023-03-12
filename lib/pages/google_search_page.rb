require_relative 'base_page'

class GoogleSearchPage < BasePage
  SEARCH_BAR = { name: 'q' }
  SEARCH_RESULTS = 'div.g'
  SEARCH_RESULT_LINK = 'a'
  SEARCH_RESULT_TITLE = 'h3'
  SEARCH_RESULT_DESCRIPTION = 'div.VwiC3b'

  def url
    BasePage::GOOGLE_URL
  end

  def search(keyword)
    puts "Searching for #{keyword}..."
    @driver.find_element(SEARCH_BAR).send_keys(keyword)
    @driver.find_element(SEARCH_BAR).submit
    puts "Search complete."
  end

  def get_results

    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until { sleep(1); @driver.find_elements(:css, SEARCH_RESULTS).size > 0 }
    
    puts "Excluding videos and so on..."
    results = @driver.find_elements(:css, SEARCH_RESULTS)

    search_results = []
  
    results.each do |result|
      begin
        url = result.find_element(css: SEARCH_RESULT_LINK).attribute('href')
        title = result.find_element(css: SEARCH_RESULT_TITLE).text
        description = result.find_element(css: SEARCH_RESULT_DESCRIPTION).text

        search_results << {
          url: url,
          title: title,
          description: description
        }
      rescue StandardError => e
      end
    end
  
    return search_results 
  end

  def results_contain_keyword?(keyword)
    puts "Checking if search results contain #{keyword}..."
    search_results = get_results
    keyword = keyword.downcase
    results_contain_keyword = search_results.select do |result|
      result[:url].downcase.include?(keyword) ||
        result[:title].downcase.include?(keyword) ||
        result[:description].downcase.include?(keyword)
    end
    if results_contain_keyword.empty?
      puts "No results found containing #{keyword}"
    else
      puts "Found #{results_contain_keyword.size} results containing #{keyword}:"
      results_contain_keyword.each do |result|
        puts "Title: #{result[:title]}"
        puts "Url: #{result[:url]}"
        puts "Description: #{result[:description]}"
        puts "-" * 50
      end
    end
    puts "Results not containing #{keyword}:"
    search_results.each do |result|
      unless results_contain_keyword.include?(result)
        puts "Title: #{result[:title]}"
        puts "Url: #{result[:url]}"
        puts "Description: #{result[:description]}"
        puts "-" * 50
      end
    end
    return !results_contain_keyword.empty?
  end  
end
