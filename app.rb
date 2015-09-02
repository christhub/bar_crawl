require("bundler/setup")
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

require('pry')

get('/') do
  erb(:index)
end

get('/intro') do
  erb(:intro)
end

get('/about') do
  erb(:about)
end

get('/new_character') do
  erb(:new_character)
end


post('/new_character') do
  name = params.fetch("name")
  game = Game.create(:name => name, :money => 50, :energy => 30, :happiness => 30, :stop_id => 0 )
  redirect("/turn/1")
end

get('/turn/:id') do
  turn = 1
  bar = Styling.new
  @green_status = bar.status_bar(turn)
  erb(:turn)
end

##################### BAR ######################

patch('/random_events/bar') do
  @game = Game.all.last
  @event = RandomEvent.new_random_event

  @game.update({happiness: @game.happiness + 15}) # because drink beer

  if @game.lose == 2
    redirect('/lose')
  elsif # update random events
    if @event.change_happiness != nil
      @game.update({happiness: @game.happiness - @event.change_happiness})
    end

    if @event.change_energy != nil
      @game.update({energy: @game.energy - @event.change_energy})
    end

    if @event.change_money != nil
      @game.update({money: @game.money - @event.change_money})
    end
  end

  if @game.lose != 4 # lose by energy/happiness conditions
    redirect('/lose')
  end

  new_turn = @game.stop_id.to_i + 1 # haven't died, increase stop
  @game.update({stop_id: new_turn})

  if @game.win_stop # check if win by stop, or win by kyle now that death condition eliminated
    redirect('/win_stop')
  elsif @event.bar.include?("Kyle")
    redirect('/win_kyle')
  else
    @beer = true
    @coffee = false
    erb(:turn_event)
  end
end

######################## CAFE ########################

patch('/random_events/cafe') do

#   @game = Game.all()
#   turn = params.fetch('id').to_i + 10
#   bar = Styling.new
#   @green_status = bar.status_bar(turn)
#   erb(:turn)
# end
#
# get('/random_event/bar') do
#   @game = Game.all.last
#   @event = RandomEvent.new_random_event
#
#   # @game.update({happiness: @game.happiness - @event.change_happiness}) if @event.change_happiness != nil
#   # @game.update({energy: @game.energy - @event.change_energy}) if @event.change_energy != nil
#   # @game.update({money: @game.money - @event.change_money}) if @event.change_money != nil
#   turn = 10
#   bar = Styling.new
#   @green_status = bar.status_bar(turn)
#   erb(:turn_event)
# end
#
# patch('/random_event/bar') do
#   turn = 1
#   bar = Styling.new
#   @green_status = bar.status_bar(turn)

  @game = Game.all.last
  @event = RandomEvent.new_random_event

  @game.update({happiness: @game.energy + 15}) # because drink beer

  if @game.lose == 2
    redirect('/lose')
  elsif # update random events
    if @event.change_happiness != nil
      @game.update({happiness: @game.happiness - @event.change_happiness})
    end

    if @event.change_energy != nil
      @game.update({energy: @game.energy - @event.change_energy})
    end

    if @event.change_money != nil
      @game.update({money: @game.money - @event.change_money})
    end
  end

  if @game.lose != 4 # lose by energy/happiness conditions
    redirect('/lose')
  end

  new_turn = @game.stop_id.to_i + 1 # haven't died, increase stop
  @game.update({stop_id: new_turn})

  if @game.win_stop # check if win by stop, or win by kyle now that death condition eliminated
    redirect('/win_stop')
  else
    @beer = false
    @coffee = true
    erb(:turn_event)
  end
end

########################

get('/win_stop') do
  erb(:win)
end

get('/win_kyle') do
  erb(:win)
end

get('/lose') do
  erb(:lose)
end

get('/running') do
  erb(:running_page)
end
