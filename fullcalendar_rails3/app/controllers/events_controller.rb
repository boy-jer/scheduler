class EventsController < ApplicationController
  before_filter :require_user, :except => [:index,:list]

  def list
		@events = Event.soon_on_call
	end
  # GET /events
  # GET /events.xml
  def index
		@allevents = Event.all #not needed but spec refuses to work because html response looks for events with strange dates
    @events = Event.where(["startDate >= :start AND endDate <= :end", {:start=>Time.at(params[:start].to_i).to_formatted_s(:db), :end=>Time.at(params[:end].to_i).to_s(format = :db) }])
    
		eventsArray = [] 
    @events.each do |event|
      if current_user
        eventsArray << {:id => event.id,:allDay => event.all_day, :editable => true, :title => "#{event.supporter.name}", :start => "#{event.startDate.to_s + " " + event.startTime.to_s[11..18]}", :end => "#{event.endDate.to_s + " " + event.endTime.to_s[11..18]}", :className => "#{event.supporter.role}"}
      else
        eventsArray << {:id => event.id,:allDay => event.all_day, :title => "#{event.supporter.name}", :start => "#{event.startDate.to_s + " " + event.startTime.to_s[11..18]}", :end => "#{event.endDate.to_s + " " + event.endTime.to_s[11..18]}", :className => "#{event.supporter.role}"}
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
			format.json  { render :json => eventsArray }
    end
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
   # @event = Event.new
		@event = Event.new(:endTime => 1.hour.from_now)
    respond_to do |format|
      format.html { redirect_to events_path } # new.html.erb
      format.xml  { render :xml => @event }
			format.js
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
		respond_to do |format|
      format.html { redirect_to events_path } # edit.html.erb
      format.xml  { render :xml => @event }
			format.js
    end
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
		if @event.save		  
		  respond_to do |format|
		    format.html { redirect_to events_path }
		    format.js
		  end
		end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html {redirect_to events_path }
        format.xml  { head :ok }
				format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
				format.js
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
			format.js
    end
  end

	def move
    @event = Event.find(params[:id])
    if @event
      # @event.startDate = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.startDate))
      # @event.endDate = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endDate))
      @event.startDate = (params[:day_delta].to_i).days.from_now(@event.startDate)
      @event.endDate = (params[:day_delta].to_i).days.from_now(@event.endDate)
      #@event.all_day = params[:all_day]
      @event.save
    end
    render :nothing => true
  end
  
  def resize
    @event = Event.find(params[:id])
    if @event
      @event.endDate = (params[:day_delta].to_i).days.from_now(@event.endDate)
      #@event.endDate = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endDate))
      #@event.endTime = (params[:minute_delta].to_i).minutes.from_now(@event.endTime)
      @event.save
    end
    render :nothing => true    
  end
end
