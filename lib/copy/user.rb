module Copy
  class User < Base
    include Copy::Operations::Show
    include Copy::Operations::Update

    attr_accessor :id, :email, :first_name, :last_name, :developer, :created_time,
      :emails, :storage, :confirmed, :user_id

    def id
      @id || @user_id
    end

    class << self

      # TODO: should be users
      #
      def api_resource_name(method=nil)
        'user'
      end

    end

  end
end
