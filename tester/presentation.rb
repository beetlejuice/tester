class Presentation
  def initialize(url)
    $driver.navigate.to url
    $driver.manage.window.resize_to(1044, 898)
  end

  def goto_chapter(chapter)
    switch_to_current_frame

    # click to show menu
    #TODO: change point to move because now it's coordinates are relative
    $driver.action.move_by(172, 70).click.perform

    # go to chapter
    chapter = $driver.find_element(:xpath => "//div[@id='menu']//button[@data-chapter='#{chapter}']")
    wait = Selenium::WebDriver::Wait.new(:timeout => 2)
    wait.until { chapter.displayed? && chapter.enabled? && chapter.location.x > 0}
    chapter.click
    sleep(1)
    switch_to_current_frame
  end

  #TODO: add 'like' parameter
  def next_slide
    switch_to_current_frame
    body = $driver.find_element(:tag_name => "body")
    $driver.mouse.move_to(body, 3*body.size.width/4, body.size.height/4)
    $driver.mouse.down
    $driver.mouse.move_by(-body.size.width/2, 0)
    $driver.mouse.up
    sleep(1)
    switch_to_current_frame
  end

  def previous_slide
    switch_to_current_frame
    body = $driver.find_element(:tag_name => "body")
    $driver.mouse.move_to(body, body.size.width/4, body.size.height/4)
    $driver.mouse.down
    $driver.mouse.move_by(body.size.width/2, 0)
    $driver.mouse.up
    sleep(1)
    switch_to_current_frame
  end

  def set_slider(value)
    switch_to_current_frame
    slider = $driver.find_element(:xpath => "//div[@class='slider' and @rv-slider]/div[@class='slider-handler']")
    scale_max = $driver.find_element(:xpath => "//*[contains(@class,'scale') and not(preceding-sibling::\
                                                *[contains(@class,'pie-slider')]) and not(following-sibling::\
                                                *[contains(@class,'pie-slider')])]/*[last()]").text.to_i
    scale_length = $driver.find_element(:xpath => "//div[@class='slider' and @rv-slider]").size.width
    slider_size = slider.size.width
    offset = value * (scale_length - slider_size) / scale_max
    $driver.action.drag_and_drop_by(slider, offset, 0).perform
    sleep(1)
  end

  def set_pie_slider(value)
    switch_to_current_frame
    
    pie_slider = $driver.find_element(:class => "pie-slider")
    pie_slider_max = pie_slider.attribute("max").to_i

    calc_radius = pie_slider.size.height / 2
    calc_angle = 360 * value / pie_slider_max

    pie_slider_pointer = $driver.find_element(:xpath => "//div[@class='pie-slider']//div[@class='pointer']")

    prev_x = 0
    prev_y = 0
    a = 0

    # Rotating the slider
    $driver.action.click_and_hold(pie_slider_pointer).perform

    while a < calc_angle do
      # Setup rotate step (in degrees)
      step = 5

      if a <= calc_angle - step then
        a += step
      else
        a = calc_angle
      end

      a_rad = a * Math::PI / 180
      abs_offset_x = calc_radius * Math::sin(a_rad)
      abs_offset_y = calc_radius * (1 - Math::cos(a_rad))

      offset_x = (abs_offset_x - prev_x)
      offset_y = (abs_offset_y - prev_y)

      prev_x = abs_offset_x
      prev_y = abs_offset_y

      $driver.action.move_by(offset_x, offset_y).perform
    end

    $driver.action.release.perform
    sleep(1)
  end

  def enter_value(xpath, value)
    $driver.find_element(:xpath => xpath).send_keys(value.to_s)
  end

  def pick_element(element_name)

  end

  def drag_element(element_name, p0, p1)
    
  end

  def get_kpi
    raw_kpi = $driver.execute_script("return window.localStorage.getItem('KPI')")
    JSON.parse(raw_kpi)
  end

  def finish
    $driver.quit
  end

  private

  def switch_to_current_frame
    $driver.switch_to.default_content
    current_frame = $driver.find_element(:xpath => "//div[@class='slide current']/iframe").attribute("id")
    $driver.switch_to.frame current_frame
  end
end
