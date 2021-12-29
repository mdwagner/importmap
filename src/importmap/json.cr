require "json"

module Importmap
  class Json
    include JSON::Serializable

    alias ImportSpecifiers = Hash(String, String)
    alias ImportScopes = Hash(String, ImportSpecifiers)

    property imports : ImportSpecifiers
    property scopes : ImportScopes?

    def self.with_defaults
      from_json({"imports" => ImportSpecifiers.new}.to_json)
    end
  end
end
