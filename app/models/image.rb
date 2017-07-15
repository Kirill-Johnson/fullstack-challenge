class Image < ActiveRecord::Base
  include Protectable
  attr_accessor :image_content

  def basename
    caption || "image-#{id}"
  end

end
