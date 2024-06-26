---author:schmeling65	current maintainer:schmeling65 v0.2
--Giftreiter, die eine Spur aus Giftwolken hinter sich herziehen.
--Jeweils nur einzelne Reiter ohne Soldaten.
--Gift mach 33% Schaden
--Bevorzugt in KIs statt Spielern verwenden, da sonst das Nachkaufen von Soldaten verhindert werden muss.
--Falls mit Bombenreitern gespielt wird, zuerst Bombenreiter-Strukturen initiallisieren.
--Distanzberechnung über den Satz des Pythagoras ohne Auflösen der Wurzel
--
--CreatePoisonRider 			Erstellt für den Spieler an der vorgegeben Position (Table) einen Giftreiter. Kann eine Funktion optional mit der ID des Reiters optional ausführen
--AddPoisonRider				Fügt eine Entity als Giftreiter hinzu und lässt sie Giftwerfen
--
--

gvTypesToTrack = {}
PlayerUnits = {}
PoisonPos = {}
Giftreiter = {}
PoisonCounter = 1

function GetAllEntitiesOfPlayerOfType(_player, _type)
    local units = {}
    local n, first = Logic.GetPlayerEntities(_player, _type, 1)
    if n > 0 then
        local entity = first
        repeat
            table.insert(units, entity)
            entity = Logic.GetNextEntityOfPlayerOfType(entity)
        until entity == first
    end
    
    return units
end

for k,v in pairs(Entities) do
        if (string.find(k, "CU_", 1, true) or string.find(k, "PU_", 1, true) or string.find(k, "PV_",1,true)) and not string.find(k, "Soldier", 1, true) and not string.find(k, "Hawk",1,true) and not string.find(k,"Hero2_",1,true) then
            gvTypesToTrack[v] = true
        end
end
	
for type, _ in pairs(gvTypesToTrack) do
	for _playerID = 1, (CUtil and 16) or 8, 1 do
		local units = GetAllEntitiesOfPlayerOfType(_playerID, type);
		for i = 1,table.getn(units) do
			PlayerUnits[units[i]] = true;
		end
	end
end

function PXEntityCreated()
	local id = Event.GetEntityID()
	local type = Logic.GetEntityType(id)
	if gvTypesToTrack[type] then
		PlayerUnits[id] = true
	end
end

function PXEntityDestroied()
    local id = Event.GetEntityID()
    if PlayerUnits[id] then
       PlayerUnits[id] = nil
    end
end

EntityCreatedTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED,nil,"PXEntityCreated",1,nil,nil)
EntityDestroiedTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED,nil,"PXEntityDestroied",1,nil,nil)

function PoisenThrowerWithBombriders()
	for j = table.getn(PoisonPos),1,-1 do
		local giftspot = PoisonPos[j]
		if giftspot.Dauer > 0 then
			local _entitiesInPoisonTalbe = {Logic.GetEntitiesInArea(nil, giftspot.X, giftspot.Y, 600, 16, 2)}
			if _entitiesInPoisonTalbe[1] >= 1 then
				for _tableentry = 2,table.getn(_entitiesInPoisonTable),1 do
					local  _entID = _entitiesInPoisonTalbe[_tableentry]
					if PlayerUnits[_entID] then
						if Logic.GetDiplomacyState(PoisonPos.Player, Logic.EntityGetPlayer(_entID)) == Diplomacy.Hostile then
							if GetSimpleDistanceSquared(giftspot,GetPosition(_entID)) < 360000 then
								if Logic.IsLeader(id) == 1 then
									if bombriders[id] then
										bobmersHP[id] = bobmersHP[id] - (500*0.33)
										MakeVulnerable(id)
										SetHealth(id,math.floor(((bobmersHP[id]/500)*100)+0.5))
										MakeInvulnerable(id)
									else
										local soldiers = {Logic.GetSoldiersAttachedToLeader(id)}
										local dmg = (soldiers[1])*(Logic.GetEntityMaxHealth(soldiers[2])*0.33)+Logic.GetEntityMaxHealth(id)*0.33
										if soldiers[1] > 0 then
											local changedDmg
											for i = soldiers[1]+1,2,-1 do
												local currentHP = Logic.GetEntityHealth(soldiers[i])
												changedDmg = math.min(currentHP,dmg)
												Logic.HurtEntity(soldiers[i],changedDmg)
												dmg = dmg - changedDmg
												if dmg <= 0 then
													break;
												end
											end
										end
										Logic.HurtEntity(id,dmg)
									end
								else
									Logic.HurtEntity(id,Logic.GetEntityMaxHealth(id)*0.33)
								end
							end
						end
					end
				end
			end
			giftspot.Dauer = giftspot.Dauer - 1
		else
			table.remove(PoisonPos,j)
		end
	end
	for j = table.getn(Giftreiter),1,-1 do
		if IsAlive(Giftreiter[j].ID) then
			if Giftreiter[j].PoisonCounter <= 0 then
				local _x,_y = Logic.GetEntityPosition(Giftreiter[j].ID)
				table.insert(PoisonPos, {X=_x;Y=_y;Dauer=20; Player=Logic.EntityGetPlayer(Giftreiter[j].ID}))
				Logic.CreateEffect(GGL_Effects.FXKalaPoison,_x,_y,0)

				Giftreiter[j].PoisonCounter = 2
			else
				Giftreiter[j].PoisonCounter = PoisonCounter - 1
			end
		else
			table.remove(Giftreiter,j)
		end
	end
	return false
end

function PoisenThrower()
	for j = table.getn(PoisonPos),1,-1 do
		local giftspot = PoisonPos[j]
		if giftspot.Dauer > 0 then
			local _entitiesInPoisonTalbe = {Logic.GetEntitiesInArea(nil, giftspot.X, giftspot.Y, 600, 16, 2)}
			if _entitiesInPoisonTalbe[1] >= 1 then
				for _tableentry = 2,table.getn(_entitiesInPoisonTable),1 do
					local  _entID = _entitiesInPoisonTalbe[_tableentry]
					if PlayerUnits[_entID] then
						if Logic.GetDiplomacyState(PoisonPos.Player, Logic.EntityGetPlayer(_entID)) == Diplomacy.Hostile then
							if GetSimpleDistanceSquared(giftspot,GetPosition(_entID)) < 360000 then
								if Logic.IsLeader(id) == 1 then
									local soldiers = {Logic.GetSoldiersAttachedToLeader(id)}
									local dmg = (soldiers[1])*(Logic.GetEntityMaxHealth(soldiers[2])*0.33)+Logic.GetEntityMaxHealth(id)*0.33
									if soldiers[1] > 0 then
										local changedDmg
										for i = soldiers[1]+1,2,-1 do
											local currentHP = Logic.GetEntityHealth(soldiers[i])
											changedDmg = math.min(currentHP,dmg)
											Logic.HurtEntity(soldiers[i],changedDmg)
											dmg = dmg - changedDmg
											if dmg <= 0 then
												break;
											end
										end
									end
									Logic.HurtEntity(id,dmg)
								else
									Logic.HurtEntity(id,Logic.GetEntityMaxHealth(id)*0.33)
								end
							end
						end
					end
				end
			end
			giftspot.Dauer = giftspot.Dauer - 1
		else
			table.remove(PoisonPos,j)
		end
	end
	for j = table.getn(Giftreiter),1,-1 do
		if IsAlive(Giftreiter[j].ID) then
			if Giftreiter[j].PoisonCounter <= 0 then
				local _x,_y = Logic.GetEntityPosition(Giftreiter[j].ID)
				table.insert(PoisonPos, {X=_x;Y=_y;Dauer=20; Player=Logic.EntityGetPlayer(Giftreiter[j].ID}))
				Logic.CreateEffect(GGL_Effects.FXKalaPoison,_x,_y,0)

				Giftreiter[j].PoisonCounter = 2
			else
				Giftreiter[j].PoisonCounter = PoisonCounter - 1
			end
		else
			table.remove(Giftreiter,j)
		end
	end
	return false
end

function CreatePoisonRider(_Player,_Pos,_AdditionalFunc)
	local trooptable = {ID = Logic.CreateEntity(Entities.PU_LeaderHeavyCavalry2, _Pos.X, _Pos.Y, 0, _Player),PoisonCounter = 2}
	table.insert(Giftreiter,trooptable)
	if _AdditionalFunc then
		_AddtionalFunc(trooptable.ID)
	end
end

function AddPoisonRider(_EntID)
	local trooptable = {ID = _EntID, PoisonCounter = 2}
	table.insert(giftreiter,trooptable)
end

function GetSimpleDistanceSquared(_pos1,_pos2)
	return (_pos1.X - _pos2.X)^2 + (_pos1.Y - _pos2.Y)^2
end

if type(bombriders) == "table" then
	PoisenReiterTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,nil,"PoisenThrowerWithBombriders",1,nil,nil)
else
	PoisenReiterTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,nil,"PoisenThrower",1,nil,nil)
end
