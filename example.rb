require_relative 'tester'

presentation = Presentation.new('http://0.0.0.0/klacid')
presentation.goto_chapter('potential')
presentation.next_slide
presentation.set_slider(20)
# presentation.set_pie_slider(37)
# presentation.next_slide
kpi = presentation.get_kpi
p kpi["evaluations"][0]["productEvaluations"][0]["loyalty"]["count"]

# presentation.previous_slide

sleep(1)

presentation.finish