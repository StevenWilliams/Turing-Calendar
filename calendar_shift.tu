unit
module Calendar
    export  getShift, isLeap, getDays, drawCalendar
    
    function isLeap (year : real) : boolean
    var days : int := -1
    if year mod 400 = 0 then    
        days := 29
        result true
    elsif year mod 100 = 0 then
        days := 28
        result false
    elsif year mod 4 = 0 then
        days := 29
        result true
    else
        days := 28
        result false
    end if
end isLeap
    
    function getDays(month : real, year :real) : int
        var days : int := -1
        if month = 1 or month = 3 or month = 5 or month = 7 or month = 8 or month = 10 or month = 12 then
            days := 31
        elsif month = 4 or month = 6 or month = 9 or month = 11 then
            days := 30
        elsif month = 2 then
            if isLeap(year) then
                days := 29
            else
                days := 28
            end if
        end if
        result days
    end getDays
    
    function getMonthVal(month : real, year : real) : int
        var monthval : int
        if  month = 1 then
            if isLeap(year) then
                monthval := 5
            else 
                monthval := 6
            end if
        elsif month = 2 then
            if isLeap(year) then
                monthval := 1
            else
                monthval := 2
            end if
        elsif month = 3 or month = 11 then
            monthval := 2
        elsif month = 4 or month = 7 then
            monthval := 5
        elsif month = 5 then
            monthval := 0
        elsif month = 6 then 
            monthval := 3
        elsif month = 8 then
            monthval := 1
        elsif month = 9 then
            monthval := 4
        elsif month = 10 then
            monthval := 6
        elsif month = 11 then
            monthval := 2
        elsif month = 12 then
            monthval := 4
        end if
        result monthval
    end getMonthVal
    
    function getAnchorDay(year : int) : int
        
        %%%REPEAT ON FOUR YEAR CYCLE!!!!! 
        %TODO
        %GET FIRST TWO DIGITS
        %LOOP THROUGH CENTRIES UNTIL IT IS REACHED
        %HAVE A COUNTER, and mod it by 4. 
        %Assign cycle based on mod operation results
        %TODO!!!
        var anchoryearday : int := -1
        
        var firsttwodigits : int := strint(intstr(year)(1..2))
 %       put "F2 digits ",  firsttwodigits
        
        var counter : int := 0
        loop
            if counter mod 4 = 0 then
                anchoryearday := 2 %2000s
            elsif counter mod 4 = 1 then
                anchoryearday := 0 %2100s
            elsif counter mod 4 = 2 then %1800
                anchoryearday := 5
            elsif counter mod 4 = 3 then %1900s
                anchoryearday := 3
            end if
                        counter := counter + 1
            exit when counter > firsttwodigits
        end loop
/*
        if year >=1800 and year <=1899 then
            anchoryearday := 5
        elsif year >= 1900 and year <= 1999 then
            anchoryearday := 3
        elsif year >= 2000 and year <= 2099 then
            anchoryearday := 2
        elsif year >= 2100 and year <= 2199 then         %100s 
            anchoryearday := 0
        end if
*/
%        put "ANCHOR DAY" , anchoryearday
        result anchoryearday
    end getAnchorDay
    
    function getDoomsdayDate(month : real, year :real) : int
        var doomsdaydate : int := -1
        if month = 1 then
            if isLeap(year) then
                doomsdaydate  := 4
            else
                doomsdaydate := 3
            end if
        elsif month  = 2 then
            if isLeap(year) then
                doomsdaydate  := 29
            else
                doomsdaydate := 28
            end if
        elsif month = 3 then
            doomsdaydate := 7
        elsif month = 4 then
            doomsdaydate := 4
        elsif month = 5 then
            doomsdaydate := 9
        elsif month = 6 then
            doomsdaydate := 6
        elsif month = 7 then
            doomsdaydate := 11
        elsif month = 8 then
            doomsdaydate := 8
        elsif month = 9 then
            doomsdaydate := 5
        elsif month = 10 then
            doomsdaydate := 10
        elsif month = 11 then
            doomsdaydate := 7
        elsif month = 12 then
            doomsdaydate :=12
        end if
        result doomsdaydate
    end getDoomsdayDate
    
    function getShift(month : int, year :int) : real
        var startingdaynum : int := -1
        %var monthval := -1
        %monthval := getMonthVal(month, year)
        
        var anchoryearday : int := -1
        anchoryearday := getAnchorDay(year)
        
        var lasttwodigits : int := strint(intstr(year)(3..4))
 %       put lasttwodigits
        
        var doomswday : real
        doomswday := (((lasttwodigits - (lasttwodigits mod 12)) /12) + (lasttwodigits mod 12) + floor(((lasttwodigits mod 12)  - (lasttwodigits mod 12) mod 2)/4) + anchoryearday) mod 7
 %       put "doomsdayweekday ", doomswday %The "doomsday" weekday
        
        var doomsdaydate : real := -1
        doomsdaydate := getDoomsdayDate(month, year)
        
  %      put "doomsdaydate ", doomsdaydate
        
        
        var shift : real  := -1
        if doomsdaydate < 7 then
            shift := doomswday - doomsdaydate + 1
        else 
            shift := (doomswday) - (doomsdaydate mod 7) + 1
            % shift := (doomsdaydate) mod  7 + (doomswday  + 1)
        end if
        
 %       put "shift ", shift
        result shift
    end getShift
    
    
    
    
    %%DRAWS GENERIC CALENDAR FROM INSTRUCTIONS
procedure drawCalendarG(days : real, shift : real, month : int, year : int)
    var startingday : real:= (shift) mod 7
    put "STARTING DAY ", startingday
   cls
        
    var months : array 1..12 of string := init("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
    put months(month) + " " + intstr(year)
    
    var daynames : array 0..6 of string := init ( "Sun", "Mon", "Tue", "Wed" , "Thu", "Fri", "Sat")

   %DRAW weekday names
    for i  : 0..6
        put daynames (i) : 4 .. 
    end for
        put  " "
        
    %Draw days:       
    var i : int := 1
    var day: int := 1
    
    loop
        if i <= startingday then
            put  "":4..
        else 
            if (i) mod 7 = 0 then % to make sure days align with the 7 weekdays
                put day:4
                % put i
                %put ""
                day := day + 1
            else
                put day:4..
                day := day + 1
            end if 
        end if
        
        i := i + 1
        exit when day > days
    end loop
    put ""
    
end drawCalendarG

procedure drawCalendar(month : int, year : int)
    var days : int := -1
    days := Calendar.getDays(month, year)
    
    var shift : real:= -1
    shift := Calendar.getShift(month, year)
    
    %Draws calendar
    
    drawCalendarG(days, shift, month, year)
end drawCalendar
    
end Calendar