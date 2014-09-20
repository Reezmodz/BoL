  if myHero.charName ~= "Shaco" then return end
    --[[
            Shaco: the Demon Jester
            by: ReeZ
						Credits go to Tux and Honda for original scripts
    ]]
    local player = GetMyHero()
    local ts = TargetSelector(TARGET_LOW_HP,625,DAMAGE_MAGIC and DAMAGE_PHYSICAL,false)
    local showLocationsInRange = 3000
    local showClose = true
    local showCloseRange = 800
    local drawboxSpots = true
    local items =
    {
    BRK = {id=3153, range = 500, reqTarget = true, slot = nil },
    BWC = {id=3144, range = 400, reqTarget = true, slot = nil },
    DFG = {id=3128, range = 750, reqTarget = true, slot = nil },
    HGB = {id=3146, range = 400, reqTarget = true, slot = nil },
    RSH = {id=3074, range = 350, reqTarget = false, slot = nil},
    STD = {id=3131, range = 350, reqTarget = false, slot = nil},
    TMT = {id=3077, range = 350, reqTarget = false, slot = nil},
    YGB = {id=3142, range = 350, reqTarget = false, slot = nil}
    }
     
    boxSpots = {
    --Blue Team
     
            { x = 3529.24, y = 54.65, z = 7700.50},  -- Blue Camp
            { x = 6397.00, y = 51.67, z = 5065.00},  -- Wraith Camp
            { x = 3388.47, y = 55.61, z = 6168.49},  -- Wolf Camp
            { x = 7586.97, y = 57.00, z = 3828.58},  -- Red Camp
            { x = 7445.00, y = 55.60, z = 3365.00},  -- Red Camp(Bush, E little minion closest to bush)
            { x = 8055.41, y = 54.28, z = 2671.30},  -- Golem Camp
     
    --Purple Team
     
            { x = 10520.72, y = 54.87, z = 6927.20}, -- Blue Camp
            { x = 7645.00, y = 55.20, z = 9413.00 }, -- Wraith Camp
            { x = 10580.53, y = 65.54, z = 7958.30}, -- Wolf Camp
            { x = 6431.00, y = 54.63, z = 10535.00}, -- Red Camp
            { x = 6597.55, y = 54.63, z = 11117.78}, -- Red Camp(Bush, E little minion closest to bush)
            { x = 6143.00, y = 39.55, z = 11777.00}  -- Golem Camp
    }
     
    function OnLoad()
            ShacoConfig = scriptConfig("The Demon Jester", "Shaco")
            ShacoConfig:addParam("Active", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
            ShacoConfig:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
            ShacoConfig:addParam("Escape", "Quick escape: Q > B", SCRIPT_PARAM_ONKEYDOWN, false, 90)
            ShacoConfig:addParam("Ulti", "Ulti in Combo", SCRIPT_PARAM_ONOFF, false)
            ShacoConfig:addParam("AutoShiv", "AutoShiv if Killable", SCRIPT_PARAM_ONOFF, true)
            ShacoConfig:addParam("DrawCircles", "Ability Distance Circles", SCRIPT_PARAM_ONOFF, true)
						ShacoConfig:addParam ("Landing", "Draw landing position", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Q"))
						ShacoConfig:addParam ("Blitzsaver", "Auto W in blitz hook", SCRIPT_PARAM_ONOFF, true)
						ShacoConfig:addSubMenu("R (Hallucinate) ", "R")
						ShacoConfig.R:addParam ("S", "Let the script decide the best option", SCRIPT_PARAM_ONOFF, true)
									ShacoConfig.R:addParam("Mouse", "Move to mouse", SCRIPT_PARAM_ONOFF, false)
						ShacoConfig.R:addParam ("Random", "Run in random directions", SCRIPT_PARAM_ONOFF, false)
												ShacoConfig.R:addParam ("Escape", "Run trying to escape from enemy team", SCRIPT_PARAM_ONOFF, false)
															ShacoConfig.R:addParam("AlwaysOrbwalk", "Orbwalk the best target", SCRIPT_PARAM_ONOFF, false)
												ShacoConfig.R:addParam ("CTarget", "Attack shaco's target", SCRIPT_PARAM_ONOFF, false)
            ShacoConfig.R:addParam("Movement", "Move to Cursor", SCRIPT_PARAM_ONOFF, false)
            ShacoConfig:permaShow("Active")
            ShacoConfig:permaShow("Harass")
            ShacoConfig:permaShow("Ulti")
            ShacoConfig:permaShow("AutoShiv")
            ts.name = "Shaco"
            ShacoConfig:addTS(ts)
            PrintChat(">> Shaco - By ReeZ loaded")
    end
		
		
     
    function getHitBoxRadius(target)
     return GetDistance(target.minBBox, target.maxBBox)/2
    end
     
    function CanCast(Spell)
            return (player:CanUseSpell(Spell) == READY)
    end
     
    function UseItems(target)
            if target == nil then return end
                    for _,item in pairs(items) do
                            item.slot = GetInventorySlotItem(item.id)
                    if item.slot ~= nil then
                            if item.reqTarget and GetDistance(target) < item.range then
                                    CastSpell(item.slot, target)
                            elseif not item.reqTarget then
                                    if (GetDistance(target) - getHitBoxRadius(myHero) - getHitBoxRadius(target)) < 50 then
                                            CastSpell(item.slot)
                                    end
                            end
                    end
            end
    end
     
    function AutoShiv()
        for i=1, heroManager.iCount do
        target = heroManager:GetHero(i)
                    if target ~= nil and not target.dead and target.team ~= player.team and target.visible and player:GetDistance(target) < 625 then
                            eDmg = getDmg("E", target, player)
                            if target.health < eDmg*1.2 then
                                    CastSpell(_E, ts.target)
                end
            end    
        end
    end
     
    function OnTick()
            ts:update()    
            if ShacoConfig.AutoShiv then AutoShiv() end
            if clone ~= nil and lastCPosUpdate < GetTickCount() - 1000 then
                    lastCX = clone.x
                    lastCZ = clone.z
            end
            if ShacoConfig.Active then
                    if ValidTarget(ts.target) and CanCast(_Q) then
                            CastSpell(_Q, ts.nextPosition.x, ts.nextPosition.z)
                    end
                    if ValidTarget(ts.target, 625) then
                            myHero:Attack(ts.target)
                    end
                    if ValidTarget(ts.target, 625) then
                            UseItems(ts.target)
                    end
                    if ValidTarget(target, 425) and CanCast(_W) then
                            CastSpell(_W, ts.target.x, ts.target.z)
                    end
                    if ts.target ~= nil and (GetDistance(ts.target) - getHitBoxRadius(myHero) - getHitBoxRadius(ts.target)) > 175 then
                            CastSpell(_E, ts.target)
                    end    
            end                    
            if ShacoConfig.Active and ShacoConfig.Ulti and (ValidTarget(ts.target) and CanCast(_R)) then
                    if clone == nil then CastSpell(_R)
                            if clone ~= nil and GetDistance(clone, ts.target) > 350 then
                                    CastSpell(_R, ts.target)       
                            end
                    end
            end
							if clone then
		local ctarget = GetBestTarget(clone, ShacoConfig.Range)
		
			if ShacoConfig.Landing then
		local CastPoint = GetDistance(mousePos) <= Qrange and Vector(mousePos) or Vector(myHero) + Qrange * (Vector(mousePos)-Vector(myHero)):normalized()
		CastPoint = GetLandingPos(CastPoint)
		local Color = myHero:CanUseSpell(_Q)==READY and  ARGB(255, 0, 255, 0) or ARGB(255, 255, 0, 0)
		DrawQ(CastPoint, Color)
	end
	
		if Shacoconfig.Blitzsaver and ValidTarget(unit, 1000) and unit.charName == "Blitzcrank" and spell.name:lower():find("grab") and (myHero:CanUseSpell(_W) == READY) then
		local spoint = Vector(unit)
		local Direction = - (Vector(unit) - Vector(spell.endPos)):normalized()
		local epoint = spoint + 1050 * Direction
		local projection, line, isonsegment = VectorPointProjectionOnLineSegment(spoint, epoint, Vector(myHero) - 60 * Direction)
		--[[Maybe better evade first and the put the box :)]]
		if isonsegment and GetDistance(projection) < Wrange then
			print("W casted in blitzcrank's grab, did it work? :o")
			CastSpell(_W, projection.x, projection.z)
		end
	end
end

		
		if ShacoConfig.R.S then
			ShacoConfig.R['AlwaysOrbwalk'] = false
			ShacoConfig.R['Mouse'] = false
			ShacoConfig.R['Random'] = false
			ShacoConfig.R['Escape'] = false
			ShacoConfig.R["CTarget"] = false
			
			if ValidTarget(HTarget) and (os.clock() - Htime < 5) then
				ctarget = HTarget
				ShacoConfig.R["CTarget"] = true
			elseif ctarget and ctarget.health < ctarget.maxHealth * 0.25 then
				ShacoConfig.R['AlwaysOrbwalk'] = true
			elseif myHero.health < myHero.maxHealth * 0.25 then
				ShacoConfig.R['Escape']  = true		
			end
		end
		
		if ValidTarget(HTarget) and ShacoConfig.R.CTarget then
			if os.clock() + GetLatency()/2000 > CLastAttack + CAnimationTime+0.05 then
				CastSpell(_R, HTarget.x, HTarget.z)
			end
		elseif ShacoConfig.R.Orbwalk or ShacoConfig.R.AlwaysOrbwalk then	
			if ctarget and ValidTarget(ctarget) then
				if os.clock() + GetLatency()/2000 > CLastAttack + CAnimationTime and GetDistance(clone, ctarget) < GetTrueRange() then
					CastSpell(_R, ctarget.x, ctarget.z)
				elseif os.clock() + GetLatency()/2000 > CLastAttack + CWinduptime + 0.05 and GetDistance(clone, ctarget) < 30 then
					local Point = GetBack(ctarget)
					CastSpell(_R, ctarget.x, ctarget.z)
				elseif os.clock() + GetLatency()/2000 > CLastAttack + CWinduptime + 0.05 then
					local Point = Vector(GetBack(ctarget)) - 1000 * (Vector(clone) - Vector(GetBack(ctarget))):normalized()
					CastSpell(_R, Point.x, Point.z)
					--[[Casting CastSpell(_R, ctarget.x, ctarget.z) causes the clone to attack that unit instead of moving to that point]]
				end
			else
					CastSpell(_R, mousePos.x, mousePos.z)
			end
			
		elseif ShacoConfig.R.Random then
			local movepoint =  wp:GetWayPoints(myHero)
			local line = Vector(clone) - Vector(myHero):perpendicular()
			local Direction = (Vector(movepoint[#movepoint].x, 0, movepoint[#movepoint].z) - Vector(myHero)):mirrorOn(line):normalized()
			
			local movepos = Vector(clone) + 500 * Direction
			CastSpell(_R, movepos.x, movepos.z)
			
		elseif ShacoConfig.R.Mouse then
			CastSpell(_R, mousePos.x, mousePos.z)
			
		elseif ShacoConfig.R.Escape then
			local Point = Vector(0, 0, 0)
			local Count = 0
			for i, hero in ipairs(GetAllyHeroes()) do
				Point = Vector(Point) + Vector(hero)
				Count = Count + 1
			end
			Count = Count or 1
			Point = 1/Count * Vector(Point)
			CastSpell(_R, Point.x, Point.z)
		end
            if ShacoConfig.Escape then
                    CastSpell(_Q, mousePos.x, mousePos.z)
                            CastSpell(RECALL)
            end      
						
            if ShacoConfig.Harass then
                    if ValidTarget(ts.target, 625) and CanCast(_E) then
                            CastSpell(_E, ts.target)
                    end
                            if ValidTarget(ts.taget) and CanCast(_Q) then
                                    CastSpell(_Q, ts.nextPosition.x, ts.nextPosition.z)
                                            myHero:Attack(ts.target)

            end
            if ShacoConfig.Movement and (ShacoConfig.Active or ShacoConfig.Harass) and ts.target == nil then myHero:MoveTo(mousePos.x, mousePos.z)
            end


    function OnCreateObj(object)
     if object ~= nil and object.name:find("Jester_Copy") then
      clone = object
      lastCX = clone.x
      lastCZ = clone.z
      lastClone = GetTickCount()
      lastCPosUpdate = GetTickCount()
     end
    end
     
    function OnDeleteObj(object)
     if object ~= nil and object.name:find("Jester_Copy") then
      clone = nil
     end
    end
     
    function OnDraw()
            if not myHero.dead and ShacoConfig.DrawCircles then
                    DrawCircle(myHero.x, myHero.y, myHero.z, 625, 0x19A712) --E
                    DrawCircle(myHero.x, myHero.y, myHero.z, 500, 0x19A712) --Q
                    DrawCircle(myHero.x, myHero.y, myHero.z, 425, 0x19A712) --W
                            if ValidTarget(ts.target) then
                                    DrawCircle(ts.target.x, ts.target.y, ts.target.z, 100, 0x00FF000)
                            end
                    if clone ~= nil then
                            DrawCircle(clone.x, clone.y, clone.z, 100, 0xFF00FF00)
                            local Time = tostring(math.round((18000-(GetTickCount()-lastClone))/1000,1))
                            local objectX, objectY, onScreen = get2DFrom3D(clone.x, clone.y, clone.z)
                            DrawText(Time,15,objectX,objectY-100, 0xFF00FF00)
                    end
            end
            if drawboxSpots then
                    for x,boxSpot in pairs(boxSpots) do
                            if GetDistance(boxSpot) < showLocationsInRange then
                                    local boxColour = 0xFFFFFF
                                    if GetDistance(boxSpot, mousePos) <= 250 then
                                            boxColour = 0x00FF000
                                            drawCircles(boxSpot.x, boxSpot.y, boxSpot.z, boxColour)
                                    end
                            end
                    end
            elseif showClose then
                    for x,boxSpot in pairs(boxSpots) do
                            if GetDistance(boxSpot) <= showCloseRange then
                                    local boxColour = 0xFFFFFF
                                    drawCircles(boxSpot.x, boxSpot.y, boxSpot.z, boxColour)
                                    if GetDistance(boxSpot, mousePos) <= 250 then
                                            boxColour = 0x00FF000
                                            drawCircles(boxSpot.x, boxSpot.y, boxSpot.z, boxColour)
                                    end
                            end
                    end
            end
    end
     
    function drawCircles(x,y,z,colour)
       for i=0,5,1 do
          DrawCircle(x, y, z, 28+i, colour)
       end
       DrawCircle(x, y, z, 250, colour)
      end
		end
		end
