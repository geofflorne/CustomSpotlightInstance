module Spotlight
  ###
  # Include Spotlight::ImageDerivatives in a class or module to get
  # the derivative configurations in #spotlight_image_derivatives.
  # A new derivative could theoretically be added by putting the
  # following in an initializer.
  # Spotlight::ImageDerivatives.spotlight_image_derivatives << {
  #   version: :my_version,
  #   field: :my_field,
  #   lambda: lambda {|_|
  #     version :my_version do
  #       process :resize_to_fill => [30,30]
  #     end
  #   }
  # }
  #
  # This will then create that new CarrierWave version in any class that extends this module
  # and calls the apply_spotlight_image_derivative_versions class method described below.
  module ImageDerivatives
    mattr_accessor :spotlight_image_derivatives
Rails.logger.info("\n AT:"+Time.now.strftime("%m%d %H:%M:%S:%L")+"\nIn object ddddd Image_Derivatives.rb\n\n ")
    # Extend Spotlight::ImageDerivatives in a CarrierWave uploader
    # then you can call this as a class method and all of the
    # configured versions will be available
    def apply_spotlight_image_derivative_versions
      spotlight_image_derivatives.each do |version_config|
        if (c = version_config[:lambda]).present?
          class_eval(&c)
        end
      end
    end
require 'rake'

    # Set default derivative configurations
    self.spotlight_image_derivatives ||= [
      {
        field: Spotlight::Engine.config.try(:full_image_field),
        lambda: lambda do|_|
            #process convert: [:jpeg]
        end
      },
      {
        version: :jpeg,
        field: Spotlight::Engine.config.try(:jpeg_field),
        lambda: lambda do|_|
          version :jpeg do
          	  pdf = false
          	  def full_filename(for_file)
          	  	  if for_file.pathmap("%x").include? "pdf"
          	  	  	  pdf = true
          	  	  end
				  filename  = for_file.pathmap("%n")
				  extension = ".jpg"
				  [version_name, filename].compact.join('_') + extension
			  end
			  #if !pdf
			  	  process convert: [:jpeg]
			  	  process :quality => 60
			  #end
          end
        end
      },
      {
        version: :thumb,
        field: Spotlight::Engine.config.try(:thumbnail_field),
        lambda: lambda do|_|
          version :thumb do
          	  pdf = false
			def full_filename(for_file)
			  if for_file.pathmap("%x").include? "pdf"
          	  	  	  pdf = true
          	  end
			  filename  = for_file.pathmap("%n")
			  extension = ".jpg"
			  [version_name, filename].compact.join('_') + extension
			end
			if !pdf
			  	  process resize_to_fill: [400, 400]
			  	  process convert: [:jpeg]
			end
          end
        end
      },
      {
        version: :square,
        field: Spotlight::Engine.config.try(:square_image_field),
        lambda: lambda do|_|
          version :square do
          	  pdf = false
          	def full_filename(for_file)
          	  if for_file.pathmap("%x").include? "pdf"
          	  	  	  pdf = true
          	  end
			  filename  = for_file.pathmap("%n")
			  extension = ".jpg"
			  [version_name, filename].compact.join('_') + extension
			end
			if !pdf
			  	  process resize_to_fill: [100, 100]
			  	  process convert: [:jpeg]
			end
          end
        end
      }
    ].reject { |v| v[:field].blank? }
    
  end
end
