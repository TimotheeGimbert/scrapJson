class Scraper

  def scrap_city_name(city_url)
  # scraps a city page and return city name as a STRING
    page = Nokogiri::HTML(URI.open(city_url))
    nodeset = page.xpath('/html/body/div/main/section[1]/div/div/div/h1').text
    return city_name = nodeset[0..-9]
  end
  
  def scrap_city_email(city_url)
  # scraps a city page and return city email as a STRING
    page = Nokogiri::HTML(URI.open(city_url))
    nodeset = page.xpath('//main/section[2]//tbody/tr[4]/td[2]').text
    return city_email = nodeset
  end
  
  def scrap_dpt_urls(dpt_url)
  # scraps a department page and return an ARRAY with all cities urls
    page = Nokogiri::HTML(URI.open(dpt_url))
    nodeset = page.xpath('//a[contains(@href, "./")]/@href').to_a
    urls_array = nodeset.map! do |url| 
      url.to_s[1..-1].prepend('https://www.annuaire-des-mairies.com')
    end
    return urls_array
  end
  
  def scrap_cities_emails(cities_urls_array)
  # manages scraping of urls then of names and emails, and return an
    data = Array.new
    cities_urls_array.each do |url| 
      city_name = scrap_city_name(url)
      city_email = scrap_city_email(url)
      data << { city_name => city_email } 
      puts city_name + " => " + city_email
    end
    return data # ARRAY of HASHES
  end

  def save_in_new_json(data)
    File.open('db/scraped_data.json', 'w') do |f|
      obj = Hash.new
      data.each do |hash| # For each hash in the array data
        hash.each {|k,v| obj[k] = v } # each pair key,value is written into the json object
      end
      f.write(JSON.pretty_generate(obj))
    end
    puts puts
    puts "Les données ont été scrappées et sont stockées dans un fichier json dans le directory /db"
  end
  
  def perform
    system('clear')
    url_95 = 'https://www.annuaire-des-mairies.com/val-d-oise.html'
    urls = scrap_dpt_urls(url_95)
    data = scrap_cities_emails(urls)
    save_in_new_json(data)
  end

end