unit
class Grid
    export drawGridLines, initialize, getXCoordinate, getYCoordinate, setGridBoxText
    
    var x1 : int
    var x2 : int
    var y1 : int
    var y2 : int
    var colorv : int
    
    var xinterval : int
    var yinterval : int
    
    procedure initialize (x1_, y1_, x2_, y2_, xinterval_, yinterval_, color_ : int)
        x1 := x1_
        y1 := y1_
        x2 := x2_
        y2 := y2_
        xinterval := xinterval_
        yinterval := yinterval_
        colorv := color_
    end initialize
    
    
    
    
    function getLastLine (x1 : int, x2 : int, xinterval : int) : int
        var x : int := x1
        loop
            if x + xinterval <= x2 then
                x := x + xinterval
            else
                exit
            end if
        end loop
        result x
    end getLastLine
    
    function getXCoordinate (sX : int) : int
        var counter := 0
        var x : int := x1
        loop
            if counter >= sX then
                result x
            end if
            if x + xinterval <= x2 then
                x := x + xinterval
            else
                exit
            end if
            counter := counter + 1
        end loop
        
        result x
    end getXCoordinate
    
    
    function getYCoordinate (sY : int) : int
        var counter := 0
        var y : int := y1
        loop
            if counter >= sY then
                result y
            end if
            if y + yinterval <= y2 then
                y := y + yinterval
            else
                exit
            end if
            counter := counter + 1
        end loop
        
        result y
    end getYCoordinate
    
    /**********************
    name: setGridBoxText
    parameters: 
    sX is an integer, sX represents the vertical column (starting from the left)
    sX is an integer, sY represents the horizontal row(starting from the bottom)
    **********************/
    procedure setGridBoxText (sX : int, sY : int, text : string, colr : int)
        
        var font : int := -1
        font := Font.New ("courier:15:bold")
        var xcoord : int := getXCoordinate (sY)
        var ycoord : int := getYCoordinate (sX)
        Draw.Text (text, xcoord + (xinterval div 3), ycoord + (yinterval div 3), font, colr)
        Font.Free (font)
    end setGridBoxText
    
    
    %Draws a grid a set interval
    procedure drawGridLines
        
        var x : int := x1
        var y : int := y1
        
        var lastXLine := getLastLine (x1, x2, xinterval)
        var lastYLine := getLastLine (y1, y2, yinterval)
        
        
        %Draws vertical lines
        loop
            if x > x2 then
                exit
            end if
            drawline (x, y1, x, lastYLine, colorv)
            x := x + xinterval
        end loop
        
        %Draws horizontal lines
        loop
            if y > y2 then
                exit
            end if
            drawline (x1, y, lastXLine, y, colorv)
            y := y + yinterval
            
        end loop
    end drawGridLines
    
end Grid
