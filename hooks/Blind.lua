press_play_ref = Blind.press_play
drawn_to_hand_ref = Blind.drawn_to_hand

function Blind.drawn_to_hand(self)
    if G.STATE == G.STATES.SELECTING_HAND then
        Timer.Duration = 5
        Timer.TickPastCallback = function()
            ease_dollars(-1, true)        
        end

        Timer.start()
    end 
    drawn_to_hand_ref(self)
end

function Blind.press_play(self)
    Timer.stop()
    press_play_ref(self)
end
