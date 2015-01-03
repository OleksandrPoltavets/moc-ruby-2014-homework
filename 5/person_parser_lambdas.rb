require 'json'

module PersonIdentify

  def gender
    personal_data["gender"]
  end

  def name
    personal_data["name"].capitalize
  end

  def age
    personal_data["age"]
  end

  def has_name?
    !personal_data["name"].empty?
  end

  def gender_call
    if gender == 'male'
      %w(he his)
    elsif gender == 'female'
      %w(she her)
    else
      'it'
    end
  end

  def man_woman
    if gender == 'male'
      'man'
    elsif gender == 'female'
      'woman'
    end
  end

  def full_name?
    personal_data["name"].split(' ').length > 1
  end

  def adult?
    personal_data["age"] >= 18 ? 'Yes!' : ' No!'
  end

  def have_hobbies?
    additional_info.length > 0
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

  def socials
    if social_profiles.length > 0
      p '========================================================'
      p "Social profiles: "
      social_profiles.each do |path|
        p "- facebook: #{social_id(path)}" if facebook_account?(path)
        p "- twitter: #{social_id(path)}" if twitter_account?(path)
      end
    end
  end

  def list_socials
    social_names = []
    if social_profiles.length > 0
      social_profiles.each do |path|
        if facebook_account?(path)
          social_names.push({name: 'Facebook', id: social_id(path)})
        elsif twitter_account?(path)
          social_names.push({name: 'Twitter', id: social_id(path)})
        else
          social_names.push({name: 'Other social', id: social_id(path)})
        end
      end
    end
    social_names
  end

  def hobbies
    if additional_info["hobby"]
      p '========================================================'
      p 'Hobbies:'
      additional_info["hobby"].each do |hobby|
        p "- #{hobby}"
      end
    end
  end

  def pets
    if additional_info["pets"]
      p '========================================================'
      p "Pets quantity (#{additional_info["pets"].length}):"
      additional_info["pets"].each do |pet|
        p '..................................'
        p "- name: #{pet["name"]}"
        p "- species: #{pet["species"]}"
      end
    end
  end

  def posting(data, posts)
    posts.each_with_index { |post, index| post.call(data[index]) }
  end

end

class PostsFactory

  def self.create_post(name, id, &block)

    ->(own_block) do
      p'-------------------------------------------'
      p "New #{name} post from user (#{id}):"
      own_block.call
      p "-- posted on: #{Time.new}"
      yield
    end

  end

end

RESPONSE = '{"person":{"personal_data":{"name": "John Doe", "gender":"male", "age":56},"social_profiles":["https://www.facebook.com/john.doe","https://twitter.com/JohnDoe","https://plus.google.com/OleksandrPoltavets"],"additional_info":{"hobby":["pubsurfing","drinking","hiking","travelling", "outsourcing"], "pets":[{"name":"Mittens","species":"Felis silvestris catus"},{"name":"Mister","species":"Scottish"}]}}}'

parsed_data = JSON.parse(RESPONSE)
if parsed_data.key?("person")
  person_object = Struct.new("Person", *parsed_data["person"].keys.collect(&:to_sym))
  person = person_object.new(*parsed_data["person"].values)
end

messages = []
messages.push -> { p "Breaking news for Android owners." }
messages.push -> { p "Updates for iPhone devices has critical issue." }
messages.push -> { p "Christmass is coming..." }

person.extend(PersonIdentify)

posts = []
person.list_socials.each do |social|
  posts.push PostsFactory.create_post(social[:name], social[:id]) { p "Posted succesefully!" }
end

p 'Here is the profile of the user we received from server:'
p '========================================================'
p "#{person.gender_call.last.capitalize} name is '#{person.name}' and #{person.gender_call.first.capitalize} is #{person.age} years old #{person.man_woman}."
p "Does #{person.gender_call.first} adult?: #{person.adult?}"
person.socials
person.hobbies
person.pets

person.posting(messages, posts)
