class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update]
  before_action :logged_in, only: :index
#/-------------------------------------------------I add these cmments-
  def show_owned
    @course=current_user.courses

    #对课程进行排序
    @course=@course.sort_by{|e| e[:course_time]}
  end
  #课程地点时间信息
  def show_describtion
     @course=Course.find_by_id(params[:id])
  end
  #课程简介
  def course_introduction
     @course=Course.find_by_id(params[:id])
  end
  
  #用于修改课程大纲
  def update_introduction
         @course=Course.find_by_id(params[:id])
  end
  
  def select_by_time
    @course=current_user.courses

    @course=@course.sort_by{|e| e[:course_time]}
  end

  def list_by_selected
    render :text => "#{params[:str[1]]}"
    classstart = 0
    classend = 0
    selectedcourses = []
    @course = Course.all
    @course = @course-current_user.courses
    @course.each do |course|
      coursetime = course.course_time
      classstart = coursetime[2..3].to_i
      classend = coursetime[4..5].to_i
      if params[:str[1]] == coursetime[1].to_i and params[:str[0]] >= classstart and params[:str[0]] <= classend
        selectedcourses << course
      end
    end
    @course.clear
    @course = selectedcourses
    @course = @course.sort_by{|e| e[:course_time]}
  end
  
  #添加对于课程的开放与否的控制
  def open
    @course =Course.find_by_id(params[:id])

    #@course.each do
    #|course|
    #  course.course_open=true
    #end

    if @course.update_attributes(:course_open=>"true")
      redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
    else
      redirect_to courses_path,flash:{:danger => "#{@course.name} 开启课程失败！"}
    end

  end

  def close

    @course = Course.find_by_id(params[:id])

    if @course.update_attributes(:course_open=>"false")
      redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
    else
      redirect_to courses_path,flash:{:danger => "#{@course.name} 关闭课程失败！"}
    end

  end

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<< @course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功 "}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------
  def select
    @course=Course.find_by_id(params[:id])
    
  end
  
  
  def list
    @course=Course.all
    @course=@course-current_user.courses
    #添加是否开课
    openedcourses=[]
    @course.each do
      |course|
      if course.course_open==true
        openedcourses<< course
      end
    end
    @course.clear
    @course=openedcourses
    #对课程进行排序
    @course=@course.sort_by{|e| e[:course_time]}
  end
  


 ####1系统启动的时候 调用select和quit方法 登录的的账户的信息得以从数据iu中加载出来

  def select
    @course=Course.find_by_id(params[:id])

    flag=false
    flag1=false
    flag2=false
    current_user.courses.each do
        |nowcourse|
        if nowcourse.name==@course.name
          flag=true
          break
        end

        if nowcourse.course_time[1]==@course.course_time[1]
          key1 =nowcourse.course_time[2..3].to_i
          key2 =nowcourse.course_time[4..5].to_i
          key3 =@course.course_time[2..3].to_i
          key4 =@course.course_time[4..5].to_i
          if ((key2 <=key4)and(key2>=key3)) or ((key2>key4 and key1<=key4))
            flag1=true
            break
          end
        end
    end



    if (@course.limit_num > @course.student_num) ||  (@course.limit_num == 0)

      flag2=true
    end

    if flag==false
      if flag1==false and flag2==true

        @course.student_num += 1
        @course.save
        current_user.courses<< @course  ##把该用户的课程信息添加到表示当前用户变量的
                                   ##current_user中 方便之后使用。
        flash={:success => "成功选择课程: #{@course.name}"}
        redirect_to courses_path, flash: flash
      else
        flash={:danger =>"#{@course.name} 选课失败，课程选课时间冲突，请选择其他课程! "}
        redirect_to courses_path, flash: flash
      end

    else
      if flag==true
        flash={:danger =>"#{@course.name} 选课失败，同课程名冲突，请选择其他课程! "}
        redirect_to courses_path, flash: flash
      elsif flag2==false
                flash={:warning => "选课人数已满: #{@course.name} 无法选课" }
                redirect_to courses_path, flash: flash
      end


    end




    #计算开课
  end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses if teacher_logged_in?
    @course=current_user.courses if student_logged_in?
  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week,:course_open,:course_description)
  end

end
