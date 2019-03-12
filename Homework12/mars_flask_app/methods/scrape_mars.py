#BeautifulSoup
from bs4 import BeautifulSoup as bs
import pandas as pd
import random
#splinter library and set path value.
from splinter import Browser


def init_browser():
    executable_path = {'executable_path': "/usr/local/bin/chromedriver"}
    browser = Browser("chrome", **executable_path, headless=False)
    return browser

def scrape_data():
    mars_data_dictionary = {}
    browser = init_browser();
    mars_data_dictionary['news'] = get_nasa_news(browser)
    mars_data_dictionary['images'] = get_nasa_images(browser)
    mars_data_dictionary['tweets'] = get_nasa_tweets(browser)
    mars_data_dictionary['facts'] = get_nasa_facts(browser)
    mars_data_dictionary['random'] = random.randint(0, len(mars_data_dictionary['images']))
    return mars_data_dictionary

def get_nasa_news(browser):
    #mars url
    url = "https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest"
    browser.visit(url)

    # Scrape page into Soup
    html = browser.html
    soup = bs(html, "html.parser")

    article_headers = soup.findAll("li", {"class": "slide"})
    print(len(article_headers))

    #data scrap sample
    a_date = [x.text for x in soup.select("div.list_date")]
    a_title = soup.select("div.content_title")
    a_title[0].find('a')

    # article list scrap
    article_list = soup.select('li.slide')
    a_date = []
    a_title = []
    a_teaser = []
    for li in article_list:
        a_date.append(li.find('div',{'class': 'list_date'}).text)
        a_title.append(li.find('div', {'class': 'content_title'}).text)
        a_teaser.append(li.find('div', {'class':'article_teaser_body'}).text)
    print('Number of date scrape: '+ str(len(a_date)))
    print('Number of title scrape: '+ str(len(a_title)))
    print('Number of teaser scrape: '+ str(len(a_teaser)))

    return {'title' : a_title, 'date': a_date, 'teaser': a_teaser}

def get_nasa_images(browser):
    image_url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=featured#submit"
    browser.visit(image_url)
    image_html = browser.html
    image_soup = bs(image_html, 'html.parser')

    feature_image_url = []
    #get images url
    images_selector = image_soup.select('div.image_and_description_container > div.img > img.thumb')

    for img in images_selector:
        feature_image_url.append('https://www.jpl.nasa.gov' + img['src'])

    print(len(feature_image_url))
    return feature_image_url

def get_nasa_tweets(browser):
    twitter_url = "https://twitter.com/marswxreport?lang=en"
    browser.visit(twitter_url)
    twitter_html = browser.html
    twitter_soup = bs(twitter_html, 'html.parser')

    temperature_list = []

    #temp_selector = twitter_soup.select('li.js-stream-item > div.content > div.js-tweet-text-container > p.TweetTextSize')
    #temp_selector

    temp_selector = twitter_soup.select('div.content > div.js-tweet-text-container > p.TweetTextSize')
    for temp in temp_selector:
        temperature_list.append(temp.text)
    print(len(temperature_list))
    return temperature_list

def get_nasa_facts(browser):
    #retrieve data from mars facts
    facts_url = 'https://space-facts.com/mars/'
    browser.visit(facts_url)
    facts_html = browser.html
    facts_soup = bs(facts_html, 'html.parser')


    #transform html to pandas dataframe
    facts_html_table = facts_soup.select('table#tablepress-mars')
    #print(facts_html_table[0])
    facts_df = pd.read_html(str(facts_html_table[0]))
    return facts_df[0].to_html()
