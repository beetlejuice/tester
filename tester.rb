require 'selenium-webdriver'
require_relative 'lib/presentation'

$driver = Selenium::WebDriver.for :chrome,
                                  :switches => %w[--ignore-certificate-errors
                                                      --disable-popup-blocking
                                                      --disable-translate
                                                      --test-type]

# $driver = Selenium::WebDriver.for :remote, :url => 'http://192.168.0.52:4444/wd/hub', :desired_capabilities => :chrome