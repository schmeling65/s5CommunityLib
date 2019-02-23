if mcbPacker then --mcbPacker.ignore
mcbPacker.require("s5CommunityLib/comfort/table/CopyTable")
mcbPacker.require("s5CommunityLib/comfort/math/vector")
mcbPacker.require("s5CommunityLib/comfort/math/GetDistance")
end --mcbPacker.ignore

--- author:mcb		current maintainer:mcb		v1.0
-- Einfache Lua OOP implementierung eines Polygons mit Punkttests.
-- 
-- polygon.new(...)					Erzeugt ein neues Polygon mit aus den Vorgegebenen Punkten.
-- 											Aufeinanderfolgende Punkte sowie der erste und letzte sind verbunden.
-- 
-- polygon:getDistanceToPoint(p)	Gibt die absolute Entfernung eines Punktes zur Polygon Außenseite.
-- polygon:isPointInside(p)			Gibt zurück, ob der Punkt im Polygon liegt. (-1->außen, 1->innen, 0->auf der Kante)
-- polygon:reverse()				Tauscht innen/außen des Polygons.
-- polygon:getModifiedDistance(p)	Gibt die modifizierte Entfernung zum Polynom zurück (<0->innen, >0->außen, ==0->Kante).
-- 
-- Benötigt:
-- - CopyTable
-- - vector
-- - GetDistance
polygon = {}

function polygon.new(...)
	local t = CopyTable(polygon)
	t.points = {}
	for k,v in ipairs(arg) do
		if IsValid(v) then
			t.points[k] = GetPosition(v)
		else
			t.points[k] = v
		end
	end
	t.reversed = 1
	return t
end

function polygon:getDistanceToPoint(p)
	local d, ind = nil, nil
	for i=1,table.getn(self.points) do
		local a = self.points[i]
		local b = self.points[i+1] or self.points[1]
		local d2 = self:getLinePointDistance(a, b, p)
		if (not d) or d>d2 then
			d = d2
			ind = i
		end
	end
	return d, ind
end

function polygon:isPointInside(p)
	local t = -1
	for i=1,table.getn(self.points) do
		local a = self.points[i]
		local b = self.points[i+1] or self.points[1]
		t = t * self:isPointInsideDotTest(p, a, b)
		if t==0 then
			return 0
		end
	end
	return t * self.reversed
end

function polygon:reverse()
	self.reversed = self.reversed * -1
end

function polygon:getModifiedDistance(p)
	local d, ind = self:getDistanceToPoint(p)
	return d * self:isPointInside(p) * -1, ind
end

function polygon:getLinePointDistance(p1, p2, p)
	local v = vector.new({p2.X-p1.X, p2.Y-p1.Y})
	local w = vector.new({p.X-p1.X, p.Y-p1.Y})
	
	local c1 = w:dot(v)
	if c1 <= 0 then
		return GetDistance(p, p1)
	end
	
	local c2 = v:dot(v)
	if c2 <= c1 then
		return GetDistance(p, p2)
	end
	
	local b = c1 / c2
	local pb = vector.new({p1.X, p1.Y}) + b * v
	return GetDistance(p, pb)
end

function polygon:isPointInsideDotTest(a, b, c)
	if a.Y == b.Y and a.Y == c.Y then
		if (b.X <= a.X and a.X <= c.X) or (c.X <= a.X and a.X <= b.X) then
			return 0
		else
			return 1
		end
	end
	if a.X==b.X and a.Y==b.Y then
		return 0
	end
	if b.Y > c.Y then
		b, c = c, b
	end
	if a.Y <= b.Y or a.Y > c.Y then
		return 1
	end
	local d = (b.X-a.X) * (c.Y-a.Y) - (b.Y-a.Y) * (c.X-a.X)
	if d > 0 then
		return -1
	elseif d < 0 then
		return 1
	else
		return 0
	end
end
