require 'http'

module API
  class UnsupportedResourceError < StandardError; end

  class Loader
    BASE_URL = "https://pokeapi.co/api/v2/".freeze
    RESOURCES = %w(pokemon)
    attr_reader :resource

    # todo: add resourced

    def initialize(resource)
      if !RESOURCES.include?(resource)
        raise UnsupportedResourceError.new "Unsupported resource: #{resource}"
      end

      @resource = resource
    end

    def get(resource_name)
      response = ResourceLoader.new(@resource, resource_name).query
      if response.success?
        response.message
      else
        raise UnsupportedResourceError.new "Query error: #{response.message}"
      end
    end

    private

    class ResourceLoader
      attr_reader :resource, :name
      def initialize(resource, name)
        @resource = resource
        @name = name
      end

      def resource_url
        "#{BASE_URL}#{@resource}/#{@name}"
      end

      def query
        q = HTTP
          .headers(:accept => "application/json")
          .get(resource_url)

        if q.status.ok?
          SuccessfulQuery.new(q.to_s)
        else
          FailedQuery.new(q.to_s)
        end
      end

      class SuccessfulQuery
        attr_reader :data
        def initialize(data)
          @data = data
        end

        def success?
          true
        end

        def message
          JSON.parse(data)
        end
      end

      class FailedQuery
        attr_reader :data
        def initialize(data);
          @data = data
        end

        def success?
          false
        end

        def message
          data.to_s
        end
      end
    end
  end
end