#!/usr/bin/env ruby

require 'gtk2'

module EWS
  class SampleApp
    COLUMN_ENGLISH, COLUMN_JAPANESE = *(0..1).to_a

    def initialize
      @store = Gtk::ListStore.new(String, String)

      [
        %w[ apple  りんご   ],
        %w[ grape  ぶどう   ],
        %w[ banana ばなな   ],
        %w[ orange おれんじ ],
      ].freeze.each do |item|
        iter = @store.append
        item.each_with_index do |value, index|
          iter[index] = value
        end
      end

      treeview = Gtk::TreeView.new(@store)
      treeview.rules_hint = true
      treeview.search_column = COLUMN_ENGLISH

      add_columns(treeview, '英語',   COLUMN_ENGLISH)
      add_columns(treeview, '日本語', COLUMN_JAPANESE)

      sw = Gtk::ScrolledWindow.new(nil, nil)
      sw.shadow_type = Gtk::SHADOW_ETCHED_IN
      sw.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC)
      sw.add(treeview)

      window = Gtk::Window.new
      window.add(sw)
      window.set_default_size(320, 240)
      window.show_all
      window.signal_connect("destroy") { Gtk.main_quit }

      Gtk.main
    end

    def add_columns(treeview, name, index)
      renderer = Gtk::CellRendererText.new
      column = Gtk::TreeViewColumn.new(name, renderer, 'text' => index)
      column.set_sort_column_id(index)
      treeview.append_column(column)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  EWS::SampleApp.new
end
