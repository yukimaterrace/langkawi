# frozen_string_literal: true

require 'cloudinary'

class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process tags: ['picture_a']

  # Process files as they are uploaded:
  # process scale: [200, 300]
  process resize_to_fit: [200, 200], if: :picture_a?

  # version :thumb do
  #   process resize_to_fit: [100, 100], if: :picture_a?
  # end

  def picture_a?
    mounted_as.to_sym == :picture_a
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
