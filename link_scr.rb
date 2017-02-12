require 'rubygems'
require 'open-uri'
require 'nokogiri'

Dir.mkdir("lib")

url = 'https://www9.atwiki.jp/f_go/pages/713.html'

flpath = "#{File.expand_path(File.dirname(__FILE__))}\/"

charset = nil

html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
linktables = doc.search('a').to_s

linktables =~ /こちら<\/a>(.+)<a href=\"https:\/\/twitter/m #mをつけることで改行も任意の文字列の対象に
result = ($1)

result = result.gsub(/<\/a>/,"<\/a>\n")
result = result.gsub(/href="/,"href=\"https:")

wikilink=[]

result.each_line do |l|
  wikilink << l.scan(/href=\"(.+)\" title/)
end

wikilink = wikilink.flatten!.drop(1)

wikilink.each do |link|

  #url = link
  charset = nil
  html = open(link) do |f|
  charset = f.charset
  f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)
  tables = doc.search('table').to_s
  doc.title =~ / - (.+)/
  filename = ($+)

#p tables.kind_of?(String)

  tables =~ /再臨用素材(.+)伝承結晶/m #mをつけることで改行も任意の文字列の対象に
  result = ($1)

  result=result.insert(0, "再臨用素材\n") #わかりづらいので頭につけとく
  result=result.insert(-1, "伝承結晶x1\n") #わかりづらいので尻につけとく

  result=result.gsub(/<(.+)>/,"")
  result=result.gsub(/\p{katakana}{3}変動/,"")
  result=result.gsub(/強化素材/,"")
  result=result.gsub(/,/,"")
  result=result.gsub(/QP/,"")
  result=result.gsub(/ /,"\n")
  result=result.gsub(/\//,"")
  result=result.gsub(/^\n/,"")
  result=result.gsub(/\nx/,"x")
  result=result.gsub(/Lv.([0-9]+)\n→\n([0-9]+)/,'Lv.\1→\2')

  doc.title =~ / - (.+)/
  filename = ($+).gsub(/\//,"_")
  filename = filename.gsub(/〔/,"(")
  filename = filename.gsub(/〕/,")")
  filename = filename.gsub(/“/,"")
  filename = filename.gsub(/”/,"")
  filename = filename.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')

  File.open("#{flpath}lib/#{filename}","w") do |file|
    file << result
  end
end

puts "scraping end"
