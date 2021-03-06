require 'set'

module Railblazer
  class AdapterDetection
    # The name on the left is the gem, the name on the right is the
    # adapter name that should appear in the database.yml.
    ADAPTERS = {
      'mysql'                               => 'mysql',
      'mysql2'                              => 'mysql2',
      'pg'                                  => 'postgresql',
      'activerecord-jdbcpostgresql-adapter' => 'postgresql'
    }.freeze

    attr_reader :gems

    def initialize minimal_gemfile
      @gems = minimal_gemfile.gems
    end

    def run
      ADAPTERS[adapter_gem]
    end

    private

    def adapter_gem
      adapter_gems = gems & ADAPTERS.keys.to_set

      raise "More than one adapter gem found in Gemfile! #{gems.to_a.join(', ')}" if adapter_gems.count > 1
      raise "Unable to detect any database adapters in database.yml" if adapter_gems.empty?

      adapter_gems.first
    end
  end
end
