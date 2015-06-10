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
      code = @code || ''
      [ :none, :section, :division, :group, :class ][code.length]
    end
    
    # returns an array of hashes containing :code and :description
    def subcategories( options = {} )
      translation = options[:translation] || :en
      return Isic::sections( translation: translation ) if !@code || @code.empty?
      return [] if @code.length > 3
      searches = (level == :section) ? DIVISIONS[@code].collect{|n| "#{n}"} : [ "#{@code}\\d" ]
      hashes = searches.inject([]) do |entities, search|
        entities + Search.new( search, translation: translation ).all
      end
    end
    
    def ==(other)
      return false unless other.class == Isic::Entity
      @code == other.code
    end
    
    def exists?
      Isic::Search.new(@code).first.class == Hash
    end
    
    def description(options = {})
      translation = options[:translation] || :en
      result = Isic::Search.new(@code, options).first
      result ? result[:description] : ''
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