module DiscordBot
  module Events
    class Command < Base
      def user
        @event.user
      end

      def whois
        "@#{user.name}"
      end

      def options
        @event.options
      end

      def voice_channel
        @event.user.voice_channel
      end

      def ran_by_admin?
        Config.admin_users.include?(user)
      end

      def respond_with(response)
        @event.respond(content: response)
      end

      def update_response(response)
        @event.edit_response(content: response)
      end
    end
  end
end
