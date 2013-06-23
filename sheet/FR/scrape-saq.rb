#!/usr/bin/ruby
# Ubuntu: sudo apt-get install rubygem libxslt1-dev && sudo gem install mechanize
require 'rubygems'
require 'mechanize'
require 'dbm'

class ScrapeCache
  def initialize
    @databases = Hash.new { |dbs, namespace| dbs[namespace] = DBM.open(namespace) }
  end
  def put(namespace, key, value)
    if value.nil?
      puts "NULL PUT: #{key}"
    elsif (value.include?("Votre session n'est pas valide"))
      puts "INVALID PUT: #{key}"
    else
      @databases[namespace][key] = value.encode('utf-8')
    end
  end
  def get(namespace, key)
    value = validate @databases[namespace][key.to_s]
  end
  def validate(value)
    if (!value.nil? && value.include?("Votre session n'est pas valide"))
      puts "INVALID CACHE: #{key}"
      nil
    elsif value.nil?
      nil
    else
      value.force_encoding('utf-8')
    end
  end
  def include?(namespace, key)
    @databases[namespace].has_key?(key)
  end
end

if ARGV.empty? then
  puts "Usage: <script> <CUP code>"
  exit 1
end

@outfile = "fiche"
@cache = ScrapeCache.new

def get_page(cup)
  page_body = @cache.get('saq', cup)
  if (page_body.nil?)
    puts "GET SAQ: #{cup}"
    @agent = Mechanize.new
    @agent.default_encoding = 'utf-8'
    @agent.force_default_encoding = true
    page = @agent.get('http://www.saq.com/webapp/wcs/stores/servlet/SearchDisplay?storeId=20002&catalogId=50000&langId=-2&pageSize=20&beginIndex=0&searchTerm=' + cup)
    @cache.put('saq', cup, page.parser.to_s)
    page.parser
  else
    puts "CACHE SAQ: #{cup}"
    Nokogiri::HTML::Document.parse(page_body)
  end
end

`rm -f content.xml`
`unzip printable-cellar-legal-fr.odg content.xml`

ARGV.each do |cup|
  puts "---------------------------------------------------------------------"
  cup = cup.rjust(14, '0')
  page = get_page(cup)
  next unless page.css('.product-description-title').first
  nom = page.css('.product-description-title').first.content.strip
  saq = page.css('.product-description-code-saq').first.next_sibling.content.strip
  cup = page.css('.product-description-code-cpu').first.next_sibling.content.strip
  pays = page.css('.product-page-subtitle').first.content.strip
  region = page.css('.product-description-region').first.content.strip
  cepage = '' # TODO
  millesime = '' # TODO
  pastille = '' # TODO /Pastille \\| (..)/.match(pastille = page.parser.css('.product-description-table-tdR').first.content)
  alcool = '' #TODO page.css("#details/ul[3]/li[4]/div[@class='right']").first.content.strip
  degustation = page.css('#tasting/div/p').first.content.strip
  garde = page.css('#tasting/div/table').first.content.strip
  boire = garde
  temp_spacer = page.css('#tasting/div/p/span').first
  temperature = (temp_spacer.previous_sibling.content.strip + " " + " " + temp_spacer.next_sibling.content.strip).gsub(/\r\n?/, " ").gsub(/\s+/, ' ')
  prix = page.css('.price').first.content.strip
  accords = '' # TODO
  paye = '' # payé

  # cepages: #details/ul/li/div[2].right

  puts "nom: #{nom}"
  puts "SAQ: #{saq}"
  puts "CUP: #{cup}"
  puts "prix: #{prix}"
  puts "pays: #{pays}"
  puts "region: #{region}"
  puts "pastille: #{pastille}"
  puts "alcool: #{alcool}"
  puts "degustation: #{degustation}"
  puts "garde: #{garde}"
  puts "temperature: #{temperature}"

  `sed -i "s/\\\$nom/#{nom}/;s/\\$cepage/#{cepage}/;s/\\$pays/#{pays}/;s/\\$millesime/#{millesime}/;s/\\$boire/#{boire}/;s/\\$prix/#{prix}/;s/\\$temperature/#{temperature}/;s/\\$accords/#{accords}/;s/\\$alcool/#{alcool}/;s/\\$degustation/#{degustation}/;s/\\$paid/#{paye}/" content.xml`

end

`cp printable-cellar-legal-fr.odg #{@outfile}.odg`
`zip -r #{@outfile}.odg content.xml`

