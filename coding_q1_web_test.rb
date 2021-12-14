require 'test-unit'
require 'selenium-webdriver'

class CodingQ1WebTest < Test::Unit::TestCase
  def setup
    @driver = Selenium::WebDriver.for :firefox
    @url = "http://automationpractice.com/"

    @driver.manage.timeouts.implicit_wait = 40

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

  def _test_login_q_1_q_2
    # Login is done on the setup
    assert_equal("My Store", @driver.title)
  end

  def test_print_label_and_price_q_2
    popular_li_tags = @driver.find_element(:id, "homefeatured")

    sleep(2)

    popular_items = popular_li_tags.find_elements(:tag_name, "li")
    products = {}
    sorted_products = {}
    popular_items.each_with_index do |li, pos|
      product_name = li.find_elements(:class_name, "product-name")[0].text
      content_price = li.find_elements(:class_name, "content_price")

      product_price = content_price[0].find_elements(:css, 'span.price.product-price')[0].attribute("innerHTML").strip

      #Add to hash for sorting
      products[product_name] = product_price

      sorted_products = products.sort_by(&:last)

    end
    puts '---------------------'
    puts "Before sorting: #{products}"
    puts '---------------------'
    puts "After sorting by price: #{sorted_products}"

  end

  def test_women_dress_add_to_cart
    women_link = @driver.find_element(:xpath, '//*[@id="block_top_menu"]/ul/li[1]/a')
    puts "#{women_link.text}"
    assert_equal("WOMEN", women_link.text)

    @driver.action.move_to(women_link).perform

    evening_dresses = @driver.find_element(:link, "Evening Dresses")
    evening_dresses.click

    waiting_time(30).until { @driver.title.include? "Evening Dresses" }
    assert_equal("Evening Dresses - My Store", @driver.title)

    #Click checkbox
    checkbox_m = @driver.find_element(:id, "layered_id_attribute_group_2")
    checkbox_m.click
    sleep(3)

    # Select Pink
    checkbox_pink = @driver.find_element(:id, "layered_id_attribute_group_24")
    checkbox_pink.click
    sleep(10)

    # Slider
    # price_slider = @driver.find_element(:id, "layered_id_attribute_group_24")
    # price_slider.link(:index => 0).send_keys :arrow_right

    # Hover over product box - on firefox.
    product_box = @driver.find_element(:xpath, '//*[@id="center_column"]/ul/li')
    @driver.action.move_to(product_box).perform

    more_btn = @driver.find_elements(:xpath, '//*[@id="center_column"]/ul/li/div/div[2]/div[2]/a[2]')[0]
    more_btn.click

    sleep(3)
    more_btn = @driver.find_elements(:xpath, '//*[@id="quantity_wanted_p"]/a[2]')[0]
    2.times do
      more_btn.click
    end

    # Select Pink
    checkbox_pink = @driver.find_element(:id, "color_24")
    checkbox_pink.click
    sleep(3)

    # select dropdown - M
    dropdown_m = @driver.find_element(:id, "group_1")
    dropdown_m.find_element(:xpath, '//*[@id="group_1"]/option[2]').click

    sleep(3)
    submit_btn = @driver.find_elements(:xpath, '//*[@id="add_to_cart"]/button')[0]
    submit_btn.click
    sleep(3)

    # Confirm Details
    item_costs = @driver.find_elements(:xpath, '//*[@id="layer_cart"]/div[1]/div[2]/div[1]/span')[0].attribute("innerHTML").strip
    assert_equal("$152.97", item_costs)
    puts "Item cost: #{item_costs}"

    attributes = @driver.find_element(:id, 'layer_cart_product_attributes').text
    assert_equal("Pink, M", attributes)
    puts "Colour and Size: #{attributes}"

    quantity = @driver.find_element(:id, 'layer_cart_product_quantity').text
    assert_equal("3", quantity)
    puts "Quantity: #{quantity}"

    shipping = @driver.find_elements(:class_name, 'ajax_cart_shipping_cost')[0].attribute("innerHTML").strip
    assert_equal("$2.00", shipping)
    puts "Shipping cost: #{shipping}"

    total_costs = @driver.find_elements(:class_name, 'ajax_block_cart_total')[0].attribute("innerHTML").strip
    assert_equal("$154.97", total_costs)
    puts "Shipping cost: #{total_costs}"

    sleep(3)
    submit_btn = @driver.find_elements(:xpath, '//*[@id="layer_cart"]/div[1]/div[2]/div[4]/a')[0]
    submit_btn.click
    sleep(3)
  end

  def waiting_time(time)
    Selenium::WebDriver::Wait.new(:timeout => time)
  end

  def teardown
    @driver.quit
  end

end