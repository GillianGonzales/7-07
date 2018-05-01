-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created By Gillian Gonzales
-- Created On April 30 2018
--
-- This code will shoot a kuni from the character
-----------------------------------------------------------------------------------------

-- Adding Physics
local physics = require( "physics" )

physics.start()
physics.setGravity(0, 50)
--physics.setDrawMode( "hybrid" )

--Adding list of bullets
local playerBullets = {}

-- Adding Images

local ground1 = display.newImage("./assets/sprites/land1.png")
ground1.x = display.contentCenterX - 500
ground1.y = display.contentHeight - 400
ground1.id = "ground1"
physics.addBody( ground1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local ground2 = display.newImage("./assets/sprites/land2.png")
ground2.x = display.contentCenterX + 500
ground2.y = display.contentHeight - 100
ground2.id = "ground2"
physics.addBody( ground2, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local badCharacter = display.newImage( "./assets/sprites/enemy.png" )
badCharacter.x = 1520
badCharacter.y = display.contentHeight - 1000
badCharacter.id = "bad character"
physics.addBody( badCharacter, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local landSquare = display.newImage( "./assets/sprites/landSquare.png" )
landSquare.x = 620
landSquare.y = display.contentHeight - 1000
landSquare.id = "land Square"
physics.addBody( landSquare, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local  leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
leftWall.alpha = 0.0
physics.addBody( leftWall, "static",{
	friction = 0.5,
	bounce = 0.3
	} )

local Ninja = display.newImage( "./assets/sprites/Ninja.png" )
Ninja.x = display.contentCenterX - 900
Ninja.y = display.contentCenterY
Ninja.id = "the ninja"
physics.addBody( Ninja, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3
    } )
Ninja.isFixedRotation = true

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5


local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 150
dPad.alpha = 0.50
dPad.id = "d-pad"

local upArrow = display.newImage( "./assets/sprites/upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 260
upArrow.id = "up arrow"

local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 150
rightArrow.id = "right arrow"

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 150
leftArrow.id = "left arrow"

local downArrow = display.newImage( "./assets/sprites/downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight - 40
downArrow.id = "down arrow"

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5


-- Making functions

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function checkingPlayerBulletsOutOfBounds()
	-- check if any bullets have gone off the screen
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.id == "bad character" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "bad character" ) ) then
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )
 
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            -- remove character
            badCharacter:removeSelf()
            badCharacter = nil

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

        end
    end
end


function upArrow:touch( event )
	-- This function will move the character up
    if ( event.phase == "ended" ) then
        transition.moveBy( Ninja, { 
        	x = 0, 
        	y = -50, 
        	time = 100 
        	} )
    end

    return true
end

function rightArrow:touch( event )
	-- This function will move the character to the right
    if ( event.phase == "ended" ) then
        transition.moveBy( Ninja, { 
        	x = 50, 
        	y = 0, 
        	time = 100 
        	} )
    end

    return true
end

function leftArrow:touch( event )
	-- This function will move the character to the left
    if ( event.phase == "ended" ) then
        transition.moveBy( Ninja, { 
        	x = -50, 
        	y = 0, 
        	time = 100 
        	} )
    end

    return true
end

function downArrow:touch( event )
	-- This function will move the character down
    if ( event.phase == "ended" ) then
        transition.moveBy( Ninja, { 
        	x = 0, 
        	y = 50, 
        	time = 100 
        	} )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        Ninja:setLinearVelocity( 0, -750 )
    end

    return true
end

function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if Ninja.y > display.contentHeight + 500 then
        Ninja.x = display.contentCenterX - 200
        Ninja.y = display.contentCenterY
    end
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
        aSingleBullet.x = Ninja.x
        aSingleBullet.y = Ninja.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )
        aSingleBullet.isFixedRotation = true

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

-- Touch Events 
upArrow:addEventListener( "touch", upArrow )
rightArrow:addEventListener( "touch", rightArrow )
leftArrow:addEventListener( "touch", leftArrow )
downArrow:addEventListener( "touch", downArrow )
jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

--Runtime Events
Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkingPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )

Ninja.collision = characterCollision
Ninja:addEventListener( "collision" )
