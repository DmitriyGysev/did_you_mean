require 'did_you_mean/binding_capturer'

module DidYouMean
  module JRubySupport
    java_import org.yukinishijima.dym.InterceptionEventHook
    NameError.send(:attr, :frame_binding)

    def self.start_capturing_binding!
      old_verbose, $VERBOSE = $VERBOSE, nil
      JRuby.runtime.add_event_hook(hook)
    ensure
      $VERBOSE = old_verbose
    end

    def self.stop_capturing_binding!
      JRuby.runtime.remove_event_hook(hook)
    end

    def self.hook
      @hook ||= InterceptionEventHook.new
    end
  end
end
