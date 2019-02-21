require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    student_card = doc.css(".student-card")

    student_card.each do |student|
      students << {
        :name => "#{student.css(".student-name").text}",
        :location => "#{student.css(".student-location").text}",
        :profile_url => "#{student.css("a").first['href']}"
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    info = {}
    doc = Nokogiri::HTML(open(profile_url))

    info[:twitter] = ""
    info[:linkedin] = ""
    info[:github] = ""
    info[:blog] = ""

    doc.css(".social-icon-container").each do |link|
      info[:twitter] = "#{link.css("a")['href']}" if link.include? "twitter"
      info[:linkedin] = "#{link.css("a")['href']}" if link.include? "linkedin"
      info[:github] = "#{link.css("a")['href']}" if link.include? "github"
      info[:blog] = "#{link.css("a")['href']}" if link.include? Student.name
    end

    binding.pry

    info[:profile_quote] = "#{doc.css(".profile-quote").text}"
    info[:bio] = "#{doc.css(".bio-content").css(".description-holder").css("p").text}"

    info
  end

end
