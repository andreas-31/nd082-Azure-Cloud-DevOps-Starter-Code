# #!/usr/bin/env python
from selenium import webdriver

# Start the browser and navigate to http://automationpractice.com/index.php.
driver = webdriver.Chrome()
driver.get('http://automationpractice.com/index.php')
driver.find_element_by_css_selector("input[id='search_query_top']").send_keys("t shirt")

# <button type="submit" name="submit_search" class="btn btn-default button-search">
#			<span>Search</span>
#		</button>
driver.find_element_by_css_selector("button[class='btn btn-default button-search']").click()
