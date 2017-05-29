REM F1 inc red  F2 dec red  F3 inc green  F4 dec green  F5 inc blue  F6 dec blue 'color drives
REM F7 inc alpha F8 dec alpha  F9 slow FPS  F10 increase FPS  ESC to Exit
REM Source Ashish http://www.qb64.net/forum/index.php?action=profile;u=55989
REM Mods by smokingwheels https://twitter.com/smokingwheels
SCREEN _NEWIMAGE(700, 500, 32)
TYPE vector
    x AS SINGLE
    y AS SINGLE
END TYPE
TYPE Particle
    pos AS vector
    vel AS vector
    fade AS SINGLE
    active AS _BYTE
    b AS SINGLE
END TYPE
TYPE rocket
    x AS SINGLE
    y AS SINGLE
    xs AS SINGLE
    ys AS SINGLE
    dead AS _BYTE
END TYPE
DEFINT A-Z
RANDOMIZE TIMER
TIMER ON
ON TIMER(10) GOSUB framecount
FOR i = 1 TO 10
    KEY(i) ON
NEXT
ON KEY(1) GOSUB decred
ON KEY(2) GOSUB incred
ON KEY(3) GOSUB decgreen
ON KEY(4) GOSUB incgreen
ON KEY(5) GOSUB decblue
ON KEY(6) GOSUB incblue
ON KEY(7) GOSUB decalpha
ON KEY(8) GOSUB incalpha
ON KEY(9) GOSUB decrate
ON KEY(10) GOSUB incrate
GOSUB getdata 'must run line 39 store first
'red = 100: green = 100: blue = 100: alpha = 50: rate# = 25
'GOSUB store 'adjust to suit path. run line above.
DIM rockets(5) AS rocket
DIM MaxExplosion
MaxExplosion = 60
DIM particles(UBOUND(rockets) * MaxExplosion * 100) AS Particle
FOR i = 1 TO UBOUND(particles)
    particles(i).vel.x = RND * 2
    particles(i).vel.y = RND * 2
    particles(i).fade = RND * 3 + 1
    particles(i).b = 255
    IF RND * 2 > 1 THEN particles(i).vel.x = -particles(i).vel.x
    IF RND * 2 > 1 THEN particles(i).vel.y = -particles(i).vel.y
NEXT
FOR i = 1 TO UBOUND(rockets)
    rockets(i).y = _HEIGHT
    rockets(i).x = RND * _WIDTH
    rockets(i).dead = -1
    rockets(i).xs = RND * 4
    rockets(i).ys = RND * 4
NEXT
DO
    a$ = INKEY$
    IF a$ = CHR$(27) THEN STOP
    IF a$ = "s" OR a$ = "S" THEN GOSUB store
    IF a$ = "r" OR a$ = "R" THEN GOSUB getdata
    'LOCATE 3, 1
    'PRINT USING "###.##"; rate#
    'PRINT red; green; blue; alpha
    hz = hz + 1
    r = RND * red
    g = RND * green
    b = RND * blue
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(r, g, b, alpha), BF
    '  WHILE _MOUSEINPUT: WEND
    'mx = _MOUSEX
    'my = _MOUSEY
    FOR i = 1 TO UBOUND(rockets)
        IF rockets(i).dead THEN
            rockets(i).dead = 0
            rockets(i).x = RND * _WIDTH
            rockets(i).y = _HEIGHT
            rockets(i).xs = RND * 4
            rockets(i).ys = RND * 4
        ELSE
            n = 0
            WHILE n < MaxExplosion
                v = v + 1
                IF v > UBOUND(particles) THEN v = 0: EXIT WHILE
                IF NOT particles(v).active THEN particles(v).pos.x = rockets(i).x: particles(v).pos.y = rockets(i).y: particles(v).active = -1: n = n + 1
            WEND
            rockets(i).x = rockets(i).x + rockets(i).xs
            rockets(i).y = rockets(i).y - rockets(i).ys
            rockets(i).ys = rockets(i).ys + .1
            rockets(i).xs = rockets(i).xs - .05
            PSET (rockets(i).x, rockets(i).y)
            IF rockets(i).y < 0 THEN rockets(i).dead = -1: k = k + 1
        END IF
    NEXT
    FOR i = 1 TO UBOUND(particles)
        IF particles(i).active THEN
            PSET (particles(i).pos.x, particles(i).pos.y), _RGB(particles(i).b, particles(i).b, 0)
            particles(i).pos.x = particles(i).pos.x + particles(i).vel.x
            particles(i).pos.y = particles(i).pos.y + particles(i).vel.y
            particles(i).vel.y = particles(i).vel.y + .05
            IF particles(i).b > 0 THEN particles(i).b = particles(i).b - particles(i).fade
        END IF
        IF particles(i).b < 0 THEN
            particles(i).active = 0
            particles(i).vel.x = RND * 2
            particles(i).vel.y = RND * 2
            particles(i).b = 255
            IF RND * 2 > 1 THEN particles(i).vel.x = -particles(i).vel.x
            IF RND * 2 > 1 THEN particles(i).vel.y = -particles(i).vel.y
        END IF
    NEXT
    _LIMIT rate#
    _DISPLAY
LOOP
STOP

incred:
'TIMER OFF
red = red + 5
IF red > 254 THEN red = 255
LOCATE 4, 1
PRINT red; green; blue; alpha
'TIMER ON
RETURN

incgreen:
green = green + 5
IF green > 254 THEN green = 255
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

incblue:
blue = blue + 5
IF blue > 254 THEN blue = 255
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

decred:
red = red - 5
IF red < 1 THEN red = 0
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

decgreen:
green = green - 5
IF green < 1 THEN green = 0
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

decblue:
blue = blue - 5
IF blue < 1 THEN blue = 0
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

incalpha:
alpha = alpha + 1
IF alpha > 254 THEN alpha = 255
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

decalpha:
alpha = alpha - 1
IF alpha < 1 THEN alpha = 0
LOCATE 4, 1
PRINT red; green; blue; alpha
RETURN

incrate:
rate# = rate# + .1
IF rate# > 254 THEN rate# = 255 'set your max frame rate here
LOCATE 3, 1
PRINT USING "###.##"; rate#
RETURN

decrate:
rate# = rate# - .1
IF rate# < .2 THEN rate# = .2 ' min value .0167
LOCATE 3, 1
PRINT USING "###.##"; rate#
RETURN

store:
OPEN "/home/john/Downloads/qb64/forum/rockets.dat" FOR OUTPUT AS #1
WRITE #1, red, green, blue, alpha, rate#, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
CLOSE #1
RETURN

getdata:
OPEN "/home/john/Downloads/qb64/forum/rockets.dat" FOR INPUT AS #1
INPUT #1, red, green, blue, alpha, rate#
CLOSE #1
RETURN


framecount:
'TIMER STOP
LOCATE 1, 1
a = a + 1
hz10 = hz10 + hz
PRINT hz * .1
PRINT hz101! * .01
PRINT USING "###.##"; rate#
PRINT red; green; blue; alpha
IF a = 10 THEN
    a = 0
    hz101! = hz10
    hz10 = 0
    LOCATE 2, 1
    PRINT hz101! * .01
END IF
hz = 0
RETURN
