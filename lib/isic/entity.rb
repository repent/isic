class Isic
  class Entity
  
    attr_reader :code

    def initialize(code)
      @code = code
    end

    def classify(options = {})
      translation = options[:translation] || :en
      all_codes.inject({}) do |hash, (key, value)|
        hash[key] = Isic::Search.new(value, translation: translation).first
        hash
      end
    end
    
    def level
      [ :section, :division, :group, :class ][@code.length-1]
    end
    
    def subcategories(options = {})
      translation = options[:translation] || :en
      return [] if @code.length > 3
      searches = (level == :section) ? DIVISIONS[@code].collect{|n| /#{n}\d/} : [ /#{@code}\d/ ]
      hashes = searches.inject([]) do |entities, search|
        entities + Search.new( search, translation: translation ).all
      end
      hashes.collect{|e| Entity.new(e[:code])}
    end
    
    def ==(other)
      @code == other.code
    end

    private

    def all_codes
      case @code
        when /\d{4}/
          {class: @code, group: @code[0..2], division: @code[0..1], section: section(@code[0..1])}
        when /\d{3}/
          {group: @code, division: @code[0..1], section: section(@code[0..1])}
        when /\d{2}/
          {division: @code, section: section(@code)}
        when /[A-Z]/
          {section: @code}
      end
    end

    def section(division)
      Isic::DIVISIONS.select { |k,v| v.include?(division) }.keys.first
    end

  end
end