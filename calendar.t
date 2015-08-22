import Grid in "grid.tu", Calendar in "calendar_shift.tu", sButton in "button.tu"
setscreen ("graphics:560;560")


var GridObject : pointer to Grid
new Grid, GridObject

var backButton : pointer to sButton
new sButton, backButton

var nextButton : pointer to sButton
new sButton, nextButton


const months : array 1 .. 12 of string := init ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

%variables used to store date/time information
var day, hour, minute, second, dayOfWeek, year, month : int := -1

%variables that are used to store mouse information
var mouseX, mouseY : int := -1
var mouseButton : int := -1
var buttonUpDown : int := -1




procedure drawGrid (x1 : int, y1 : int, x2 : int, y2 : int, vert : int, hor : int, color : int)
    var xinterval := floor ((x2-x1) div vert)
    var yinterval := floor ((y2-y1) div hor)
    
    GridObject -> initialize (x1, y1, x2, y2, xinterval, yinterval, color)
    GridObject -> drawGridLines
end drawGrid









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
    
    drawCalendarG (days, shift, month, year, 6)
end drawCalendar

procedure drawButtons
    backButton -> initialize (5, maxy - 30, 30, maxx - 5)
    backButton -> draw(0)
    nextButton -> initialize (maxx - 30, maxy - 30, maxx - 5, maxy - 5)
    nextButton -> draw(1)
end drawButtons

procedure waitForButtonPress
    Mouse.ButtonWait ("down", mouseX, mouseY, mouseButton, buttonUpDown)
    Mouse.ButtonWait ("up", mouseX, mouseY, mouseButton, buttonUpDown)
end waitForButtonPress

procedure processButtonPress
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
end processButtonPress

%%=================MAIN PROGRAM=======================
%%====================================================

Time.SecParts (Time.Sec, year, month, day, dayOfWeek, hour, minute, second) %get current time/date info.

loop
    Draw.FillBox (0, 0, maxx, maxy, black)
    drawGrid (5, 5, 550, 500, 7, 7, green)
    drawButtons
    drawCalendar (month, year)
    waitForButtonPress
    processButtonPress
    cls
end loop