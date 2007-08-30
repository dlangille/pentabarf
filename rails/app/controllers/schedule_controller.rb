class ScheduleController < ApplicationController

  before_filter :init

  def index
  end

  def css
    response.headers['Content-Type'] = 'text/css'
    render( :text => @conference.css.to_s )
  end

  def day
    @day = params[:id].to_i
#    @content_title = "#{local(:schedule)} #{local(:day)} #{@day}"
    @rooms = View_room.select({:conference_id=>@conference.conference_id, :language_id=>@current_language_id, :f_public=>'t'})
    @events = View_schedule_event.select({:day=>{:le=>@day},:conference_id=>@conference.conference_id,:translated_id=>@current_language_id},{:order=>[:title,:subtitle]})
  end

  def days
#    @content_title = local(:schedule)
    @rooms = View_room.select({:conference_id=>@conference.conference_id, :language_id=>@current_language_id, :f_public=>'t'})
    @events = View_schedule_event.select({:conference_id=>@conference.conference_id,:translated_id=>@current_language_id},{:order=>[:title,:subtitle]})
  end

  def event
    @event = View_event.select_single({:conference_id=>@conference.conference_id,:translated_id=>@current_language_id,:event_id=>params[:id]})
    @events = View_schedule_event.select({:conference_id=>@conference.conference_id,:translated_id=>@current_language_id},{:order=>[:title,:subtitle]})
    @content_title = @event.title
  end

  def events
    @events = View_schedule_event.select({:conference_id=>@conference.conference_id,:translated_id=>@current_language_id},{:order=>[:title,:subtitle]})
  end

  def speaker
    @speakers = View_schedule_person.select({:conference_id=>@conference.conference_id},{:order=>[:name]})
    @person = View_person.select_single({:person_id=>params[:id]})
    @speaker = View_conference_person.select_single({:conference_id=>@conference.conference_id,:person_id=>params[:id]})
    @content_title = @speaker.name
  end

  def speakers
    @speakers = View_schedule_person.select({:conference_id=>@conference.conference_id},{:order=>[:name]})
#    @content_title = local(:speakers)
  end

  def track_event
    @track = View_conference_track.select_single({:conference_id=>@conference.conference_id,:language_id=>@current_language_id,:tag=>params[:track]})
    @event = View_event.select_single({:conference_id=>@conference.conference_id,:translated_id=>@current_language_id,:event_id=>params[:id]})
    @events = View_schedule_event.select({:conference_id=>@conference.conference_id,:conference_track_id=>@track.conference_track_id,:translated_id=>@current_language_id}, {:order=>[:title,:subtitle]})
    @content_title = @event.title
  end

  def track_events
#    @content_title = "Lectures and workshops"
    @track = View_conference_track.select_single({:conference_id=>@conference.conference_id,:language_id=>@current_language_id,:tag=>params[:track]})
    @events = View_schedule_event.select({:conference_id=>@conference.conference_id,:conference_track_id=>@track.conference_track_id,:translated_id=>@current_language_id}, {:order=>[:title,:subtitle]})
  end

  protected

  def init
    @conference = Conference.select_single(:acronym=>params[:conference])
    @tracks = Conference_track.select(:conference_id=>@conference.conference_id)
    @current_language_id = Language.select_single(:tag=>params[:language]).language_id rescue 120
  end

end
