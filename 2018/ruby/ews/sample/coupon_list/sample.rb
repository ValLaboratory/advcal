#!/usr/bin/env ruby

require 'gtk2'
require 'open-uri'
require 'json'

module EWS
  class CouponApp
    ACCESS_KEY = '駅すぱあとWebサービスのアクセスキー'

    # ツリービューで表示するカラムのインデックスを示す定数を定義する
    COLUMN_NAME, COLUMN_COUNT, COLUMN_AMOUNT, COLUMN_VARID_PERIOD = *(0..3).to_a

    def initialize
      # 上記のCOLUMN_*の定数の順で表示するGtk:LListStoreを作成
      @store = Gtk::ListStore.new(String, String, String, String)

      #
      # 回数券の名称リストを格納するためのコンボボックス作成
      #
      combo = Gtk::ComboBox.new
      # WebAPIから取得した回数券の名称をコンボボックスのテキストに設定する
      get_coupon_names.each {|coupon_name| combo.append_text(coupon_name) }
      # コンボボックスのアイテムが選択されたら、回数券の名称を引数にしてget_coupon()を呼ぶ
      combo.signal_connect("changed") {|widget| get_coupon(widget.active_text) }

      #
      # 回数券の詳細表示用のツリービュー(表示は表形式)を作成
      #
      treeview = Gtk::TreeView.new(@store)
      treeview.rules_hint = true
      treeview.search_column = COLUMN_NAME

      add_columns(treeview, '定期券名称', COLUMN_NAME)
      add_columns(treeview, '回数券の枚数', COLUMN_COUNT)
      add_columns(treeview, '合計金額', COLUMN_AMOUNT)
      add_columns(treeview, '有効期間(月)', COLUMN_VARID_PERIOD)

      # 表示するデータが多い場合にスクロールバーが表示されるように設定する
      sw = Gtk::ScrolledWindow.new(nil, nil)
      sw.shadow_type = Gtk::SHADOW_ETCHED_IN
      sw.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC)
      sw.add(treeview)

      # GUI部品を縦に配置する
      vbox = Gtk::VBox.new(false, 8)
      vbox.pack_start(Gtk::Label.new('駅すぱあとWebサービスの回数券一覧APIサンプル'), false, false, 0)
      vbox.pack_start(combo, false, false, 0)
      vbox.pack_start(sw, true, true, 0)

      # メインウインドウにGUI部品を乗せて表示したのち、Gtkのメインループを呼ぶ
      window = Gtk::Window.new
      window.add(vbox)
      window.set_default_size(640, 480)
      window.show_all
      window.signal_connect("destroy") { Gtk.main_quit }

      Gtk.main
    end

    # ツリービューにカラムを追加する
    def add_columns(treeview, name, index)
      renderer = Gtk::CellRendererText.new
      column = Gtk::TreeViewColumn.new(name, renderer, 'text' => index)
      column.set_sort_column_id(index)
      treeview.append_column(column)
    end

    # 駅すぱあとWebサービスの回数券一覧(/coupon/list)から、回数券の名称リストを取得する
    # http://docs.ekispert.com/v1/api/coupon/list.html
    def get_coupon_names
      url = "http://api.ekispert.jp/v1/json/coupon/list?key=#{ACCESS_KEY}"
      coupon_res = open(url).read

      JSON.parse(coupon_res)['ResultSet']['Coupon'].collect {|coupon| coupon['Name'] }
    end

    # 駅すぱあとWebサービスの回数券詳細(/coupon/detail)から、回数券の詳細情報を取得してツリービューを更新する
    # http://docs.ekispert.com/v1/api/coupon/detail.html
    def get_coupon(coupon_name)
      url = "http://api.ekispert.jp/v1/json/coupon/detail?key=#{ACCESS_KEY}&name=#{URI.escape(coupon_name)}"
      coupon_detail_res = open(url).read

      data = []
      JSON.parse(coupon_detail_res)['ResultSet']['Coupon'].each do |item|
        next if item.class != Hash
        data.push([
          item['Name'],
          item['Detail']['Count'],
          item['Detail']['Price']['Amount'],
          item['Detail']['ValidPeriod']
        ])
      end

      @store.clear  # 現在のツリービューの内容をクリアする

      # 作成した回数券の詳細データをツリービューに反映させる
      data.each do |coupon|
        iter = @store.append
        coupon.each_with_index do |value, index|
          iter[index] = value
        end
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  EWS::CouponApp.new
end

