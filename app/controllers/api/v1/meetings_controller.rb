module Api
  module V1
    class MeetingsController < BaseController
      def notify
        authorize :meeting, :notify?

        users = User.where(role: :socio)
        result = Notifications::NotifyMeetingService.call(
          users: users,
          title: params.require(:title),
          body: params.require(:body)
        )

        render_result(result)
      end
    end
  end
end
