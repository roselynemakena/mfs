require 'test-unit'
require 'selenium-webdriver'
require 'json'

class CodingMFS < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @url = "http://automationpractice.com/"

    @driver.manage.timeouts.implicit_wait = 20

    # Login
    @driver.get(@url)
    @driver.manage.window.maximize

    sign_in_link = @driver.find_element(:class_name, "login")
    sign_in_link.click

    # Wait for 30 seconds until title shows
    waiting_time(30).until { @driver.title.include? "Login - My Store" }

    username = @driver.find_element(:id, "email")
    username.send_keys("testautomationmfs@gmail.com")
    sleep(2)

    password = @driver.find_element(:id, "passwd")
    password.send_keys("TestAutomation@123")
    sleep(3)

    login_btn = @driver.find_element(:id, "SubmitLogin")
    login_btn.click
    sleep(2)

    waiting_time(30).until { @driver.title.include? "My account - My Store" }
    sleep(2)

    # Go to homepage
    @driver.get(@url)
  end

  def test_data_driven
    test_data_from_data_source = File.read('./data.json')
    test_data = JSON.parse(test_data_from_data_source)

    menu_items = test_data['menu_items'].split(",")
    website_title = test_data['website_title']
    footer_description = test_data['footer_description']

    menu_items_elements = @driver.find_elements(:xpath, '//*[@id="block_top_menu"]/ul')

    menu_items_elements.each_with_index do |li, pos|
      menu_item = li.find_elements(:xpath, '//*[@id="block_top_menu"]/ul/li[1]/a')[0].text
      assert_equal(menu_items[pos], menu_item)
      puts menu_item
    end


    website_title_element = @driver.find_elements(:xpath, '//*[@id="editorial_block_center"]/h1')
    # @driver.action.move_to(website_title_element).perform

    assert_equal(website_title_element.text, website_title)[0]

    footer_description_element = @driver.find_elements(:xpath, '//*[@id="editorial_block_center"]/h2').text.strip
    assert_equal(footer_description_element, footer_description)
    sleep(2)

    puts '---------END------------'

  end

  def waiting_time(time)
    Selenium::WebDriver::Wait.new(:timeout => time)
  end

  def teardown
    @driver.quit
  end

end