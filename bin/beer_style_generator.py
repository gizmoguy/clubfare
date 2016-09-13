#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
  Generates SQL statements to insert untappd beer style list
  into clubfare database

  Usage:
    $ beer_style_generator.py > clubfare_beer_styles.sql
    $ psql clubfare < clubfare_beer_styles.sql
"""

from bs4 import BeautifulSoup
import urllib, json

def crawl():
    url = 'https://untappd.com/beer/top_rated'

    sql = """INSERT INTO styles (name, created_at, updated_at)
      SELECT '%s', now()::timestamp(0), now()::timestamp(0)
      WHERE NOT EXISTS
      (SELECT name FROM styles WHERE name = '%s');"""

    r = urllib.urlopen(url)
    soup = BeautifulSoup(r, "lxml")

    filtersdiv = soup.find('div', {'class': 'filters'})

    stylelist = soup.find('select', id='filter_picker')
    taplist = []
    for option in stylelist.findAll('option'):
        if option['value'] == "all":
            continue
        style = option.text
        stmt = sql % (style, style)
        print stmt.encode('utf-8')

if __name__ == '__main__':
    crawl()
