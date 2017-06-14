module FA
  class FARule < Struct.new(:state, :character, :next_state)
    def applies_to?(state, character)
      self.state == state && self.character == character
    end

    def follow
      next_state
    end

    def to_s
      "#<FARule #{state.inspect} -- #{character} --> #{next_state.inspect}"
    end
  end

  class DFARulebook
    def initialize(rules=[])
      @rules = rules
    end

    def rule(state, character, next_state)
      @rules << FARule.new(state, character, next_state)
    end

    def next_state(state, character)
      rule_for(state, character).follow
    end

    def to_s
      "#{@rules}"
    end

    def rule_for(state, character)
      @rules.detect { |rule| rule.applies_to?(state, character) }
    end
    private :rule_for
  end

  class DFA < Struct.new(:current_state, :accept_states, :rulebook)
    def accepts?(string)
      read_string(string)
      accept_states.include?(current_state)
    end

    def read_character(character)
      self.current_state = rulebook.next_state(current_state, character)
    end

    def read_string(string)
      string.chars.each do |character|
        read_character(character)
      end
    end

    private :read_string, :read_character
  end

  class DFADesign
    def initialize(start_state, accept_states, &blk)
      @start_state = start_state
      @accept_states = accept_states

      @rules = DFARulebook.new
      @rules.instance_eval &blk
    end

    def to_dfa
      DFA.new(@start_state, @accept_states, @rules)
    end

    def accepts?(string)
      to_dfa.accepts?(string)
    end
  end
end
