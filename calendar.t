
import Grid in "grid.tu", Calendar in "calendar_shift.tu", sButton in "button.tu"
setscreen ("graphics:560;560")


function getInteger (prompt : string) : int
    var stringa : string
    var inta : int := -1
    loop % prompts until user enters a valid integer
        put prompt + " " ..
        get stringa
        exit when strintok (stringa)
    end loop
    inta := strint (stringa)
    result inta
end getInteger




var GridObject : pointer to Grid
new Grid, GridObject

var backButton : pointer to sButton
new sButton, backButton

var nextButton : pointer to sButton
new sButton, nextButton

var xinterval : int := 50
var yinterval : int := 50




%GridObject -> initialize(50, 50, 500, 500, xinterval, yinterval, green)


procedure drawGrid (x1 : int, y1 : int, x2 : int, y2 : int, vert : int, hor : int, color : int)
    
    var xspace := x2 - x1
    var yspace := y2 - y1
    
    var xinterval := floor (xspace div vert)
    var yinterval := floor (yspace div hor)
    
    GridObject -> initialize (x1, y1, x2, y2, xinterval, yinterval, color)
    GridObject -> drawGridLines
end drawGrid


procedure putColor (error : string, pcolor : int)
    var defcolor : int := whatcolor ()
    color (pcolor)
    put error
        color (defcolor)
end putColor
    
var months : array 1 .. 12 of string := init ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")






procedure drawCalendarG (days : real, shift : real, month : int, year : int, toprow : int)
    var column : int := 0
    
    var font : int := -1
    font := Font.New ("courier:25:bold")
    Draw.Text (months (month) + " " + intstr (year), 150, maxy - 40, font, yellow)
    Font.Free (font)
    var daynames : array 0 .. 6 of string := init ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
    
    var startingday : real := (shift) mod 7
    
    %Draw days:
    var i : int := 1
    var day : int := 1
    
    var row : int := toprow
    
    for weekday : 0 .. 6
        GridObject -> setGridBoxText (row, column, daynames (weekday), yellow)
        column := column + 1
    end for
        row := row - 1
    column := 0
    
    loop
        if i <= startingday then
            column := column + 1
        else
            if (i) mod 7 = 0 then % to make sure days align with the 7 weekdays
                GridObject -> setGridBoxText (row, column, intstr (day), yellow)
                day := day + 1
                row := row - 1
                column := 0
            else
                GridObject -> setGridBoxText (row, column, intstr (day), yellow)
                day := day + 1
                column := column + 1
            end if
        end if
        i := i + 1
        exit when day > days
    end loop
    column := 0
end drawCalendarG


procedure drawCalendar (month : int, year : int)
    var days : int := -1
    days := Calendar.getDays (month, year)
    
    var shift : real := -1
    shift := Calendar.getShift (month, year)
    
    %Draws calendar
    
    drawCalendarG (days, shift, month, year, 6)
end drawCalendar

procedure drawButtons
    backButton -> initialize (5, maxy - 30, 30, maxx - 5)
    backButton -> draw(0)
    nextButton -> initialize (maxx - 30, maxy - 30, maxx - 5, maxy - 5)
    nextButton -> draw(1)
end drawButtons





%%=================MAIN PROGRAM=======================
%%====================================================
var month : int := -1
var year : int := -1
var days : int := -1
var monthstring : int := -1



%RANDOM TIME STUFF
var day : int := -1
var hour : int := -1
var minute : int := -1
var second : int := -1
var dayOfWeek : int := -1
Time.SecParts (Time.Sec, year, month, day, dayOfWeek, hour, minute, second)

%variables that control mouse
var mouseX, mouseY : int := -1
var mouseButton : int := -1
var buttonUpDown : int := -1


procedure waitForMouseClick
    Mouse.ButtonWait ("down", mouseX, mouseY, mouseButton, buttonUpDown)
    Mouse.ButtonWait ("up", mouseX, mouseY, mouseButton, buttonUpDown)
end waitForMouseClick

procedure processMouseClick
    if backButton -> pointInButton (mouseX, mouseY) then
        month := month - 1
        if month = 0 then
            month := 12
            year := year - 1
        end if
    end if
    if nextButton -> pointInButton (mouseX, mouseY) then
        month := month + 1
        if month = 13 then
            month := 1
            year := year + 1
        end if
    end if
    
end processMouseClick


loop
    if month > 12 or month < 1 then
        putColor ("Month is invalid", 12)
    elsif length (intstr (year)) not= 4 then
        putColor ("Only supports 4 digit years", 12) % for now...
    else
        Draw.FillBox (0, 0, maxx, maxy, black)
        drawGrid (5, 5, 550, 500, 7, 7, green)
        drawButtons
        drawCalendar (month, year)
    end if
    waitForMouseClick
    processMouseClick
    /*
    loop
    %Wait for mouse click
    %Check if mouse click is on the button
    exit when hasch
    end loop
    year := getInteger("Enter a year:")
    month := getInteger("Enter a month:")
    */
    cls
end loop






/*
for day : 1..28
GridObject -> setGridBoxText(row, column, intstr(day))
column := column + 1
if day mod 7 = 0 then
row := row - 1
column := 0
end if
%drawline(xcoord, 0, xcoord, maxy, red)
%drawline(0, ycoord, maxx, ycoord, red)
end for
*/



/*
%Grid.drawGridLines(50, 50, 300, 300, 30, 30, black)


drawGrid(50, 50, 300, 300, 7, 8, black)
*/
