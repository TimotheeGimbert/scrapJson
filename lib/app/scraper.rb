class Scraper

  def scrap_city_name(city_url)
    # returns a name as a STRING
    page = Nokogiri::HTML(URI.open(city_url))
    name_scraped = page.xpath('/html/body/div/main/section[1]/div/div/div/h1').text
    return city_name = name_scraped[0..-9]
  end
  
  def scrap_city_email(city_url)
    # returns an email as a STRING
    page = Nokogiri::HTML(URI.open(city_url))
    return email_scraped = page.xpath('//main/section[2]//tbody/tr[4]/td[2]').text
  end
  
  def scrap_dpt_urls(dpt_url)
    # returns an ARRAY of urls as STRINGS
    page = Nokogiri::HTML(URI.open(dpt_url))
    dpt_urls_partial = page.xpath('//a[contains(@href, "./")]/@href').to_a
    return dpt_urls = dpt_urls_partial.map! { |url| url.to_s[1..-1].prepend('https://www.annuaire-des-mairies.com') }
  end
  
  def scrap_dpt_emails(cities_urls_array)
    # return an ARRAY of HASHES
    data = Array.new
    cities_urls_array.each do |url| 
      city_name = scrap_city_name(url)
      print city_name + " => "
      city_email = scrap_city_email(url)
      puts city_email
      data.push( { city_name => city_email } )  
    end
    return data 
  end

  def save_in_new_json(data)
    File.open('db/scraped_data.json', 'w') do |f|
      f.write(JSON.pretty_generate(data))
    end
  end
  
  def perform
    system('clear')
    url_95 = 'https://www.annuaire-des-mairies.com/val-d-oise.html'
    urls = scrap_dpt_urls(url_95)
    data = scrap_dpt_emails(urls)
    save_in_new_json(data)
    puts puts
    puts "Les données ont été scrappées et sont stockées dans un fichier json dans le directory /db"
  end

end