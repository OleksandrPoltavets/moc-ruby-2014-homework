require 'json'

RESPONSE = '{"person":{"personal_data":{"name": "John Doe", "gender":"male", "age":56},"social_profiles":["https://www.facebook.com/john.doe","https://twitter.com/JohnDoe"],"additional_info":{"hobby":["pubsurfing","drinking","hiking","travelling", "outsourcing"], "pets":[{"name":"Mittens","species":"Felis silvestris catus"},{"name":"Mister","species":"Scottish"}]}}}'

module PersonIdentify

  module ClassMethods
    def parse_data(data)
      parsed_data = JSON.parse(data)
      if parsed_data.key?("person")
        Struct.new("Person", *parsed_data["person"].keys.collect(&:to_sym))
        Struct::Person.new(*parsed_data["person"].values)
      end
    end

    def has_name?(name)
      !name.empty?
    end

    def gender_call(gender)
      if gender == 'male'
        %w(he his)
      elsif gender == 'female'
        %w(she her)
      else
        'it'
      end
    end

    def man_woman(gender)
      if gender == 'male'
        'man'
      elsif gender == 'female'
        'woman'
      end
    end

    def full_name?
      name.split(' ').length > 1
    end

    def adult?(age)
      age >= 18 ? 'Yes!' : ' No!'
    end

    def have_hobbies?(info)
      info.length > 0
    end

    def facebook_account?(path)
      path.include?('facebook.com')
    end

    def twitter_account?(path)
      path.include?('twitter.com')
    end

    def social_id(path)
      path.split('/').last
    end

  end

  # avoid extend and include
  def self.included(base)
    base.extend(ClassMethods)
  end

end

class PersonClass
  include PersonIdentify
end

person = PersonClass
data = person.parse_data(RESPONSE)

name = data.personal_data["name"].capitalize
calling = person.gender_call(data.personal_data["gender"]).last.capitalize
appeal = person.gender_call(data.personal_data["gender"]).first.capitalize
age = data.personal_data["age"]
gender_alias = person.man_woman(data.personal_data["gender"])
hobbies = data.additional_info["hobby"]
pets = data.additional_info["pets"]

p 'Here is the profile of the user we received from server:'
p '========================================================'
p "#{calling} name is '#{name}', and #{appeal} is #{age} years old #{gender_alias}."
p "Does #{person.gender_call(data.personal_data["gender"]).last} adult?: #{person.adult?(data.personal_data["age"])}"
if data.social_profiles.length > 0
  p '================'
  p "Social profiles: "
  data.social_profiles.each do |path|
    p "- facebook: #{person.social_id(path)}" if person.facebook_account?(path)
    p "- twitter: #{person.social_id(path)}" if person.twitter_account?(path)
    p "- other social: "
  end
end
if hobbies
  p '================'
  p 'Hobbies:'
  hobbies.each do |hobby|
    p "- #{hobby}"
  end
end
if pets
  p '==================='
  p "Pets quantity (#{pets.length}):"
  pets.each do |pet|
    p "- name: #{pet["name"]}"
    p "- species: #{pet["species"]}"
  end
end