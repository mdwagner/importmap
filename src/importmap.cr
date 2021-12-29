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

  record Opts, preload : Bool = false

  class Map
    property json : Json
    property import_opts = Hash(String, Opts).new(Opts.new)

    def self.from_json(s : String, & : Map ->)
      new(Json.from_json(s)).tap { |x| yield x }
    end

    def self.from_json(s : String)
      from_json(s) { }
    end

    def self.draw(& : Map ->)
      new(Json.with_defaults).tap { |x| yield x }
    end

    private def self.new
    end

    def initialize(@json)
    end

    def pin(name, to : String? = nil, preload = false) : Nil
      @json.imports[name] = to ? "/#{to}" : "/#{name}.js"
      @import_opts[name] = @import_opts[name].copy_with(preload: preload)
    end

    def preload(name) : Nil
      @import_opts[name] = @import_opts[name].copy_with(preload: true)
    end

    def to_importmap_json
      @json.to_json
    end

    def to_importmap_html_tags(preloads = false)
      String.build do |s|
        if preloads
          @import_opts.each do |name, opts|
            if opts.preload
              s << importmap_link_tag(@json.imports[name])
              s << "\n"
            end
          end
        end
        s << importmap_script_tag
      end
    end

    private def importmap_script_tag
      <<-HTML
      <script type="importmap">
      #{to_importmap_json}
      </script>
      HTML
    end

    private def importmap_link_tag(link)
      <<-HTML
      <link rel="modulepreload" href="#{link}">
      HTML
    end
  end
end
