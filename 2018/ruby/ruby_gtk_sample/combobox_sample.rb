#!/usr/bin/env ruby

require 'gtk2'

module EWS
  class SampleApp
    def initialize
      window = Gtk::Window.new

      combo = Gtk::ComboBox.new
      %w[apple grape orange banana].each do |label|
        combo.append_text(label)
      end
      combo.signal_connect("changed") do |widget|
        puts(widget.active_text)
      end

      window.add(combo)
      window.show_all
      window.signal_connect("destroy") { Gtk.main_quit }

      Gtk.main
    end
  end
end

if $PROGRAM_NAME == __FILE__
  EWS::SampleApp.new
end
