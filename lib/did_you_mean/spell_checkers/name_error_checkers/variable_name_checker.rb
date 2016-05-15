# -*- frozen-string-literal: true -*-

module DidYouMean
  if RUBY_ENGINE == 'jruby' && org.jruby.RubyInstanceConfig.FULL_TRACE_ENABLED
    require 'did_you_mean/jruby_support'
    JRubySupport.start_capturing_binding!
  end

  class VariableNameChecker
    attr_reader :name, :method_names, :lvar_names, :ivar_names, :cvar_names

    def initialize(exception)
      @name       = exception.name.to_s.tr("@", "")
      receiver    = exception.receiver
      @lvar_names = if RUBY_ENGINE == 'jruby'
                      b = exception.instance_variable_get(:@frame_binding)
                      b ? b.local_variables : []
                    else
                      exception.local_variables
                    end

      @method_names = receiver.methods + receiver.private_methods
      @ivar_names   = receiver.instance_variables
      @cvar_names   = receiver.class.class_variables
      @cvar_names  += receiver.class_variables if receiver.kind_of?(Module)
    end

    def corrections
      @corrections ||= SpellChecker
                     .new(dictionary: (lvar_names + method_names + ivar_names + cvar_names))
                     .correct(name)
    end
  end
end
