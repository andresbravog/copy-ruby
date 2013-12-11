module Copy
  class User < Base
    include Copy::Operations::Show
    include Copy::Operations::Update

    attr_accessor :id, :email, :first_name, :last_name, :developer, :created_time,
      :emails, :storage

  end
end
