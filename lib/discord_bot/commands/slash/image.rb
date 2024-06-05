module DiscordBot
  module Commands
    module Slash
      ##
      # Command for generating images via Stable Diffusion.
      #
      class Image < Base
        class << self
          def register
            # Logger.info "Registering #{command_name} command"
            Bot.register_command(command_name, description) do |command|
              command.subcommand(:generate, 'Generate an image using Stable Diffusion') do |options|
                options.string(:prompt, 'The prompt for the image', required: true)
                options.string(:negative_prompt, 'The negative prompt for the image')
                options.integer(:steps, 'How many iterations to pass over the image (default: 20)')
                options.integer(:cfg_scale, 'How closely to follow the prompt instructions (default: 7)')
                options.integer(:width, 'The width in pixels of the image (default: 512)')
                options.integer(:height, 'The height in pixels of the image (default: 512)')
                options.attachment(:base_image, 'Base image to work from for image to image')
              end
            end
          end

          def handle
            Bot.command_callback(command_name).subcommand(:generate) do |event|
              generate_image(DiscordBot::Events::Command.new(event))
            end
          end

          def description
            'Uses stable diffusion to interact with images'
          end

          def generate_image(command)
            Logger.info("Image requested by #{command.whois}")
            command.respond_with('Generating image')
            image_options = DiscordBot::StableDiffusion::ImageOptions.new(
              command.options
            )
            image = DiscordBot::StableDiffusion::Image.new(
              image_options: image_options
            )
            Logger.info 'Sending image'
            caption =
              "Generated an image requested by #{command.user.mention}:\n#{image.about}"
            command.send_image(image: image.content, caption: caption)
            Logger.info(
              "Sent image with the following options:\n#{image.about}"
            )
          rescue StandardError => e
            byebug
          end
        end
      end
    end
  end
end