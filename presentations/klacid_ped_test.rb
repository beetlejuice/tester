require_relative '../tester'

json = File.read("klacid_ped_data.json")
test_data = JSON.parse(json)
exp_loyalty = test_data["loyalty"]

presentation = Presentation.new('http://0.0.0.0/klacid')

# Set loyalty
presentation.goto_chapter('potential')
presentation.next_slide
presentation.set_slider(exp_loyalty)

# Check loyalty
kpi = presentation.get_kpi
act_loyalty = kpi["evaluations"][0]["productEvaluations"][0]["loyalty"]["count"]

puts act_loyalty == exp_loyalty ? "#{act_loyalty}(Actual loyalty) = #{exp_loyalty}(Expected loyalty)\nTest PASS" :
         "#{act_loyalty}(Actual loyalty) != #{exp_loyalty}(Expected loyalty)\nTest FAILED"