require_relative 'spec_helper'

describe 'Search Engines' do

  it 'searches for a keyword and verifies the results on Google' do
    @google_search_page.visit
    @google_search_page.search('ruby')
    expect(@google_search_page.results_contain_keyword?('ruby')).to eq true
  end

  it 'searches for a keyword and verifies the results on Yahoo' do
    @yahoo_search_page.visit
    @yahoo_search_page.search('ruby')
    expect(@yahoo_search_page.results_contain_keyword?('ruby')).to eq true
  end

  it 'compares search results between Google and Yahoo' do
    @google_search_page.visit
    @google_search_page.search('ruby')
    @google_results = @google_search_page.get_results

    @yahoo_search_page.visit
    @yahoo_search_page.search('ruby')
    @yahoo_results = @yahoo_search_page.get_results

    common_results = []

    @google_results.each do |google_result|
      @yahoo_results.each do |yahoo_result|
        if google_result[:url] =~ /#{Regexp.escape(yahoo_result[:url])}/i ||
          yahoo_result[:url] =~ /#{Regexp.escape(google_result[:url])}/i
          common_results << google_result
        end
      end
    end

    if common_results.empty?
      puts 'No common results found.'
    else
      puts "Found #{common_results.size} common results:"
      common_results.each do |result|
        puts "Title: #{result[:title]}"
        puts "Url: #{result[:url]}"
        puts "Description: #{result[:description]}"
        puts '-' * 50
      end
    end
  end
end