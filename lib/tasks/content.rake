namespace :content do

 # defining users

  MEMBERS=["mike","alice","greg","marsha","chris","cindy","sam"]
  ADMINS=["mike","alice"]
  BASE_URL="http://blog.topolyan.com/wp-content/uploads" # defining a constant

  def user_name first_name
    last_name = (first_name=="alice") ? "nelson" : "smith"
    case first_name
    when "alice"
      last_name = "nelson"
    when "sam"
      last_name = "franklin"
    else
      last_name = "smith"
    end
    "#{first_name} #{last_name}".titleize
  end
  def user_email first_name
    "#{first_name}@example.com"
  end
  def get_user first_name
    User.find_by(:email=>user_email(first_name))
  end

  def users first_names
    first_names.map {|fn| get_user(fn) }
  end
  def first_names users
    users.map {|user| user.email.chomp("@example.com") }
  end
  def admin_users
     @admin_users ||= users(ADMINS)
  end
  def member_users
     @member_users ||= users(MEMBERS)
  end
  def mike_user
    @mike_user ||= get_user("mike")
  end

 # defining images

  def create_image organizer, img
    puts "building image for #{img[:caption]}, by #{organizer.name}"
    image=Image.create(:creator_id=>organizer.id,:caption=>img[:caption])
    organizer.add_role(Role::ORGANIZER, image).save
    create_image_content img.merge(:image=>image)
  end

  def create_image_content img
    url="#{BASE_URL}/#{img[:path]}"
    puts "downloading #{url}"
    contents = open(url,{ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
    original_content=ImageContent.new(:image_id=>img[:image].id,
                                      :content_type=>"image/jpeg", 
                                      :content=>BSON::Binary.new(contents))
    ImageContentCreator.new(img[:image], original_content).build_contents.save!
  end


 # tasks

  desc "reset all data"
  task reset_all: [:users,:images] do
  end

  desc "deletes images" 
  task delete_images: :environment do
    puts "removing #{Image.count} images"
    DatabaseCleaner[:active_record].clean_with(:truncation, {:except=>%w[users]})
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  desc "delete all data"
  task delete_all: [:delete_images] do
    puts "removing #{User.count} users"
    DatabaseCleaner[:active_record].clean_with(:truncation, {:only=>%w[users]})
  end

  desc "reset users"
  task users: [:delete_all] do
    puts "creating users: #{MEMBERS}"

    MEMBERS.each_with_index do |fn,idx|
     User.create(:name  => user_name(fn),
                 :email => user_email(fn),
                 :password => "password#{idx}")
    end

    admin_users.each do |user|
      user.roles.create(:role_name=>Role::ADMIN)
    end


    puts "users:#{User.pluck(:name)}"
  end

  desc "reset images" 
  task images: [:users] do
    puts "creating images"


 # creating images

    organizer=get_user("greg")
    image= {:path=>"2017/07/sample_skyline.jpg",
     :caption=>"Skyline"
     }
    create_image organizer, image

    organizer=get_user("marsha")
    image= {:path=>"2017/07/sample_world_trade_center.jpg",
     :caption=>"World Trade Center"
     }
    create_image organizer, image

    organizer=get_user("mike")
    image= {:path=>"2017/07/rspec_matchers_documentation.jpg",
     :caption=>"Matchers"
     }
    create_image organizer, image
  end

end
