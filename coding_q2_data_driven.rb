require 'test-unit'
require 'selenium-webdriver'
require 'json'

class DataDrivenTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @url = "http://automationpractice.com/"

    @driver.manage.timeouts.implicit_wait = 40

    # Visit URL
    @driver.get(@url)
    @driver.manage.window.maximize
  end

  def test_data_driven
    test_data_from_data_source = File.read('./data.json') #Can be any preferred data source
    test_data = JSON.parse(test_data_from_data_source)

    facebook_block_title_1_data = test_data['facebook_block_title_1']
    info_block_title_1_data = test_data['info_block_title_1']
    info_block_title_2_data = test_data['info_block_title_2']
    info_block_paragraph_1_data = test_data['info_block_paragraph_1']

    #Block 1
    #Title 1
    facebook_block = @driver.find_element(:id, 'facebook_block')
    facebook_block_title = facebook_block.find_element(:tag_name, 'h4')
    assert_equal(facebook_block_title.text, facebook_block_title_1_data)

    #Block 2
    #Title 1
    info_block = @driver.find_element(:id, 'cmsinfo_block')
    info_block_title_1 = info_block.find_elements(:tag_name, 'h3')[0]
    assert_equal(info_block_title_1.text, info_block_title_1_data)

    #Paragraph 1
    paragraph_1_block = info_block.find_elements(:xpath, '//*[@id="cmsinfo_block"]/div[1]/ul/li[1]/div/p')[0]
    assert_equal(paragraph_1_block.text, info_block_paragraph_1_data)
    sleep(2)

    #Title 2
    info_block_title_2 = info_block.find_elements(:tag_name, 'h3')[1]
    assert_equal(info_block_title_2.text, info_block_title_2_data)

    puts '---------END------------'

  end

  def waiting_time(time)
    Selenium::WebDriver::Wait.new(:timeout => time)
  end

  def teardown
    @driver.quit
  end

end