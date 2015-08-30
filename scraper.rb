#!/usr/bin/env ruby

require 'nokogiri'
require 'fileutils'
require 'open-uri'
require 'json'
require 'csv'

CONFIG_FILE = 'setup.json'
URL_PATTERN = '%s/index.php?hdn_rtype=p&hdn_precinct=%d'
OUTPUT_PATTERN = 'output/%s.csv'
PRECINCTS = 1..143

config = JSON.parse(File.read(CONFIG_FILE))
election_url = config['url']
races = config['races']

for race in races
    candidates = race['candidates'].keys
    output_candidates = []
    for candidate in candidates
        output_candidates << race['candidates'][candidate]['output_spelling']
        race['candidates'][candidate]['total_votes'] = 0
    end
    race['results'] = [['PRECINCT'] + output_candidates + ['TOTAL']]
end

for vtd in PRECINCTS
    puts "Scraping precinct #{vtd}"

    url = URL_PATTERN % [election_url, vtd]
    page = Nokogiri::HTML(open url)

    for race in races
        title_div = page.at('[text()*="%s"]' % race['title'])

        if !title_div then next end
        
        votes_table = title_div.parent.next_element

        vtd_results = [vtd]
        precinct_votes = 0

        for candidate in race['candidates'].keys
            selector = '.office_candidate_label:contains("%s")' % candidate
            votes = votes_table.at(selector)
                .next_element.text
                .gsub(',','')

            vtd_results.push(votes)
            precinct_votes += votes.to_i

            race['candidates'][candidate]['total_votes'] += votes.to_i
        end

        vtd_results.push(precinct_votes)
        race['results'].push(vtd_results)
    end
end

for race in races
    all_votes = ["ALL-PRECINCTS"]
    all_precinct_votes = 0

    for candidate in race['candidates'].keys
        all_votes << race['candidates'][candidate]['total_votes']
        all_precinct_votes += race['candidates'][candidate]['total_votes']
    end

    all_votes << all_precinct_votes
    race['results'].push(all_votes)

    safe_title = race['title'].downcase.gsub(' ', '-')
    output_path = OUTPUT_PATTERN % safe_title

    output_dir = File.dirname(output_path)
    unless File.directory?(output_dir)
      FileUtils.mkdir_p(output_dir)
    end

    File.open(output_path,'w') { |f|
        f.write(race['results'].inject([]) { |csv, row|
            csv << CSV.generate_line(row)
        }.join(""))
    }
end