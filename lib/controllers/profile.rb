require 'nokogiri'
require 'json'
require 'open-uri'

class DreamOn::Controllers::Profile < Sinatra::Base

  def not_found msg="resource not found"
    return 404, msg
  end

  get '/profile' do
    content_type :json

    return not_found unless params[:id] || params[:url]

    begin
      if params[:id]
        open_decriptor = open("https://www.linkedin.com/in/#{params[:id]}")
      elsif params[:url]
        params[:url].gsub!('http', 'https') if params[:url].scan('https').empty?
				arr = params[:url].split(",,")

				puts "-------------"
				arr.map! do |x|
					arr1 = x.split("--");
					parse(open(arr1[0].strip), arr1[1])
				end
        # open_decriptor = open("#{params[:url].strip}")
				# process and group arr and send back
				puts arr
				arr1 = process(arr)
				puts "--=-=-=-=-="
				puts arr1
				arr1.each do |k,v|
					v.each do |k,degree|
						degree.each do |d|
							d[1] = []
							arr.each do |match|
								puts "+++++"
								puts match[:educations].to_json, d[0]
								if match[:educations].to_json.downcase.include? d[0].downcase
									d[1] << match[:number]
								end
							end
						end
					end
				end
				puts arr1
				body arr1.to_json
      end
    rescue RuntimeError
      return not_found("dude! use https url.")
    rescue OpenURI::HTTPError
      return not_found("User not found: #{params[:id]}")
    end

		# dict = parse(open_decriptor)

    # body education_hash.to_json
  end
end

def process(arr)
	major = {"graduate"=>[], "undergrad"=>[], "rest"=>[]}
	school = {"graduate"=>[], "undergrad"=>[], "rest"=>[]}
	arr.each do |edu_dict|
		edu_arr = edu_dict[:educations]
		edu_arr.each do |edu|
			next unless edu[:degree]
			if edu[:degree].starts_with?("M") || edu[:degree].starts_with?("P")
				major["graduate"] << edu[:major] if edu[:major]
				school["graduate"] << edu[:name] if  edu[:name]
				elsif edu[:degree].starts_with?("B")
				major["undergrad"] << edu[:major] if edu[:major]
				school["undergrad"] << edu[:name] if  edu[:name]
			else
				major["rest"] << edu[:major] if edu[:major] 
				school["rest"] << edu[:name] if  edu[:name]
			end
		end
	end
		major["graduate"] = (major["graduate"].group_by(&:capitalize).map {|k,v| [k, v.length]}).sort_by{|x| -x[1]}[0..1]
		major["undergrad"] = (major["undergrad"].group_by(&:capitalize).map {|k,v| [k, v.length]}).sort_by{|x| -x[1]}[0..1]
		major["rest"] = (major["rest"].group_by(&:capitalize).map {|k,v| [k, v.length]}).sort_by{|x| -x[1]}[0..1]
		school["graduate"] = (school["graduate"].group_by(&:capitalize).map {|k,v| [k, v.length]}).sort_by{|x| -x[1]}[0..1]
		school["undergrad"] = (school["undergrad"].group_by(&:capitalize).map {|k,v| [k, v.length]}).sort_by{|x| -x[1]}[0..1]
		school["rest"] = (school["rest"].group_by(&:capitalize).map {|k,v| [k, v.length]}).sort_by{|x| -x[1]}[0..1]
		{:major => major, :school => school}
end

def parse(open_decriptor, num)
    doc = Nokogiri::HTML(open_decriptor)
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
    education_hash[:number] = num
		education_hash
end
