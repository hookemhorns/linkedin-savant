require 'nokogiri'
require 'json'
require 'open-uri'

class DreamOn::Controllers::Profile < Sinatra::Base

  def not_found msg
    return msg
  end

  get '/profile/:id' do
    content_type :json

    not_found unless params[:id]
    doc = Nokogiri::HTML(open("https://www.linkedin.com/in/#{params[:id]}"))
    education_hash = {}

    education_hash[:educations] = []
    education = doc.css('.education')
    education.css('.summary').each do |element|
      single_education = {}
      
      # get name of the university
      single_education[:name] = element.content.strip

      degree_element = element.parent.css('.degree')

      # get degree
      single_education[:degree] = degree_element[0].content.strip unless degree_element.empty?

      major_a = element.parent.css('.major')
      major = major_a[0].content.strip unless major_a.empty?

      single_education[:major] = major if major      
      education_hash[:educations] << single_education
    end

    body education_hash.to_json
  end
end
