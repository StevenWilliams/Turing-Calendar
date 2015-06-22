unit
class sButton
    export initialize, pointInButton, draw
    var x1, x2, y1, y2 : int
    procedure initialize (vx1, vy1, vx2, vy2 : int)
	x1 := vx1
	x2 := vx2
	y1 := vy1
	y2 := vy2
    end initialize

    function pointInButton (x, y : int) : boolean
	if x1 < x and y1 < y and x2 > x and y2 > y then
	    result true
	end if
	result false
    end pointInButton

    procedure draw (prevornext : int)
	Draw.FillBox (x1, y1, x2, y2, red)
	var height := abs(y2 - y1)
	var x := x1 %+ abs(x2 - x1) div 2
	var y := y1 + abs(y2 - y1) div 2
	const TRIANGLE_COLOUR := yellow
	if prevornext = 0 then %point backwords
	    for i : 0 .. height div 2
		drawline (x + height div 3 + i,
		    y + i,
		    x + height div 3 + i,
		    y - i, TRIANGLE_COLOUR)
	    end for
	elsif prevornext = 1 then %point forwards
	    for i : 0 .. height div 2
		drawline (x + height div 3 + i,
		    y + height div 2 - i,
		    x + height div 3 + i,
		    y - height div 2 + i, TRIANGLE_COLOUR)
	    end for
	end if
    end draw

end sButton
