#!/usr/bin/env ruby

require 'gtk2'

module EWS
  class SampleApp
    def initialize
      window = Gtk::Window.new
      window.set_default_size(320, 240)
      window.show_all
      window.signal_connect("destroy") { Gtk.main_quit }

      Gtk.main
    end
  end
end

if $PROGRAM_NAME == __FILE__
  EWS::SampleApp.new
end
