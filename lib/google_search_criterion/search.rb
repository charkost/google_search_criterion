require "mechanize"

module GoogleSearchCriterion
  module Search
    extend self

    def results(keyphrase)
      result_stats = scrape_result_stats(keyphrase)
      tokens = result_stats.split(' ')

      case tokens.first
      when "About"
        tokens[1].to_i
      else
        tokens.first.to_i
      end
    end

    private

    def scrape_result_stats(keyphrase)
      results = nil

      agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }

      agent.get('http://google.com/en') do |page|
        search_result = page.form_with(:name => 'gbqf') do |search|
          search.q = keyphrase
        end.submit

        results = search_result.search("div#resultStats").text
      end

      results
    end
  end
end