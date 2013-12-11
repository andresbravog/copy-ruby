module Copy
  class Revision < Base

    attr_accessor :id, :revision_id, :modified_time, :size, :latest, :conflict,
      :type, :creator

    def initialize(attributes = {})
      super(attributes)
      parse_creator
    end

    protected

    def parse_creator
      return unless creator
      @creator = Copy::User.new(creator)
    end

    # Parses UNIX timestamps and creates Time objects.
    def parse_timestamps
      super
      @modified_time = Time.at(modified_time) if modified_time
    end
  end
end
