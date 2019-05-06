#!/usr/bin/env ruby

# GTFSデータをSQLに変換するスクリプトです。
# 使用例：
#   $ # 北恵那交通株式会社(http://www.kitaena.co.jp)のGTFSデータ。
#   $ curl -s -o kitaena.zip 'http://www.kitaena.co.jp/info/GTFS%282019-03-13_1606%29.zip'
#   $ gtfs_csv2sql.rb > output.sql

require 'fileutils'

gtfs_files = [
  'office_jp.txt',
  'routes.txt',
  'calendar.txt',
  'shapes.txt',
  'agency.txt',
  'agency_jp.txt',
  'routes_jp.txt',
  'fare_rules.txt',
  'stops.txt',
  'stop_times.txt',
  'fare_attributes.txt',
  'translations.txt',
  'transfers.txt',
  'feed_info.txt',
  'frequencies.txt',
  'calendar_dates.txt',
  'trips.txt',
]

if ARGV.length < 1
  file_lists = gtfs_files
else
  file_lists = ARGV
end

file_lists.each do |file_name|
  next unless FileTest.exist?(file_name)

  table_name = file_name.sub(/.txt/, '')

  File.open(file_name, 'r:BOM|UTF-8') do |f|
    line_count = 1
    header = ''
    f.readlines.each do |line|
      if line_count == 1
        header = line.chomp.split(',')
      else
        values = line.chomp.split(',', -1).map{|field| "'#{field}'" }.join(',')
        sql = <<_EOS
  INSERT INTO #{table_name}(#{header.join(',')}) VALUES (#{values}) ;
_EOS
        puts(sql)
      end
      line_count = line_count + 1
    end
  end
end

