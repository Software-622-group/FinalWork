class Course < ActiveRecord::Base

  has_many :grades
  has_many :users, through: :grades

  belongs_to :teacher, class_name: "User"

  validates :name, :course_type, :course_time, :course_week,
            :class_room, :credit, :teaching_type, :exam_type, presence: true, length: {maximum: 50}

  def get_coursetime_for_str
    strcoursetime="周"
    intweek=self.course_time[1].to_i
    dayweekstr = ["", "一", "二", "三", "四", "五", "六", "七"]
    strcoursetime = strcoursetime + dayweekstr[intweek]
    strcoursetime =strcoursetime+"("
    strcoursetime=strcoursetime+self.course_time[2..5]
    strcoursetime=strcoursetime.insert(5, '-')
    strcoursetime=strcoursetime+")"
  end
end
