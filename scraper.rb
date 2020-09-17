require 'bundler/inline'

gemfile do
    source 'https://rubygems.org'
    gem 'nokogiri'
    gem 'httparty'
    gem 'pry'
end

require 'nokogiri'
require 'httparty'
require 'pry'

image_links = []

doc = HTTParty.get("https://digitalcollections.nypl.org/search/index?filters%5Brights%5D%5B%5D=pd&filters%5Btype%5D=still+image&keywords=#")
parsed_categories_page = Nokogiri::HTML(doc)
category_links = parsed_categories_page.css('.grid-items').css('.grid-item').map{|category| category.attribute('href')}

photo_links = []

for i in 0...category_links.count
    doc = HTTParty.get(category_links[i])
    parsed_category_page = Nokogiri::HTML(doc)
    category_photo_links = parsed_category_page.css('#results-list-wrapper').css('.item').css('.icons').xpath('.//a').map{|photo| photo.attribute('href')}
    photo_links.push(category_photo_links)
end

photo_links = photo_links.flatten
binding.pry
for i in 0...photo_links.count - 1
    doc = HTTParty.get("https://digitalcollections.nypl.org/#{photo_links[i]}")
end
