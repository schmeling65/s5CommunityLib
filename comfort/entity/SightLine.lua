if mcbPacker then --mcbPacker.ignore
mcbPacker.require("s5CommunityLib/comfort/other/S5HookLoader")
mcbPacker.require("s5CommunityLib/lib/MemoryManipulation")
mcbPacker.require("s5CommunityLib/comfort/math/Polygon")
end --mcbPacker.ignore

--- author:mcb		current maintainer:mcb		v0.1b
-- Prüft ob ein ziel von einer position gesehen werden kann. (funktioniert nicht mit gebäuden).
-- 
-- - SightLine.CheckVisibility(pos1, pos2, blockers)		Gibt zurück ob pos2 von pos1 sichtbar ist (nutzt blockers als sichtblocker, kann nil sein wenn hook vorhanden ist).
-- - SightLine.BuildTables()								Baut das table mit den blockinggrößen, benötigt hook/memman (vorgeneriertes table vorhanden, nur verwenden wenn entitytypen manipuliert wurden).
-- 
-- benötigt:
-- - Polygon
-- - S5Hook / MemoryManipulation				(optional) Unbekannte sichtblocker/blockinggrößen table bauen
SightLine = {}

function SightLine.CheckVisibility(pos1, pos2, blockers)
	if blockers then
		for _,id in ipairs(blockers) do
			if SightLine.CheckEntity(pos1, pos2, id) then
				return false
			end
		end
		return true
	else -- TODO check actual blocking, to account for non circular blocking
		for id in S5Hook.EntityIterator(Predicate.InCircle((pos1.X+pos2.X)/2, (pos1.Y+pos2.Y)/2, GetDistance(pos1, pos2))) do
			if SightLine.CheckEntity(pos1, pos2, id) then
				return false
			end
		end
		return true
	end
end

function SightLine.CheckEntity(pos1, pos2, id)
	local ty = Logic.GetEntityType(id)
	if SightLine.DistanceTable[ty] then
		if Polygon:GetLinePointDistance(pos1, pos2, GetPosition(id)) <= SightLine.DistanceTable[ty] then
			return true
		end
	end
end

function SightLine.BuildTables()
	SightLine.DistanceTable = {}
	for _, ty in pairs(Entities) do
		local di = SightLine.CalculateDistance(ty)
		if di > 0 then
			SightLine.DistanceTable[ty] = di
		end
	end
end

function SightLine.CalculateDistance(ty)
	local bl = MemoryManipulation.GetEntityTypeBlockingArea(ty)
	local di = -1
	local z = {X=0,Y=0}
	for _,ps in ipairs(bl) do
		for _,p in ipairs(ps) do
			local d = GetDistance(p, z)
			if di < d then
				di = d
			end
		end
	end
	bl = MemoryManipulation.GetEntityTypeNumBlockedPoints(ty)
	if bl > 0 then
		di = math.sqrt(bl)*100
	end
	return di
end

SightLine.DistanceTable = {
    [1] = 670.820393249937,
    [100] = 360.555127546399,
    [101] = 360.555127546399,
    [102] = 447.213595499958,
    [103] = 282.842712474619,
    [104] = 282.842712474619,
    [105] = 282.842712474619,
    [106] = 282.842712474619,
    [107] = 360.555127546399,
    [108] = 360.555127546399,
    [109] = 360.555127546399,
    [11] = 809.506022213547,
    [110] = 447.213595499958,
    [111] = 282.842712474619,
    [112] = 282.842712474619,
    [113] = 282.842712474619,
    [114] = 282.842712474619,
    [115] = 282.842712474619,
    [116] = 360.555127546399,
    [117] = 282.842712474619,
    [118] = 282.842712474619,
    [119] = 282.842712474619,
    [12] = 809.506022213547,
    [120] = 282.842712474619,
    [122] = 282.842712474619,
    [123] = 282.842712474619,
    [124] = 1360.14705087354,
    [125] = 1345.36240470737,
    [126] = 1140.17542509914,
    [127] = 1204.15945787923,
    [128] = 848.528137423857,
    [129] = 1421.26704035519,
    [13] = 809.506022213547,
    [130] = 1421.26704035519,
    [131] = 500,
    [132] = 1272.79220613579,
    [14] = 781.024967590665,
    [15] = 781.024967590665,
    [16] = 781.024967590665,
    [17] = 722.011080247388,
    [18] = 722.011080247388,
    [186] = 141.42135623731,
    [189] = 141.42135623731,
    [19] = 722.011080247388,
    [2] = 670.820393249937,
    [20] = 961.769203083567,
    [21] = 961.769203083567,
    [22] = 961.769203083567,
    [23] = 679.411510058521,
    [24] = 679.411510058521,
    [240] = 141.42135623731,
    [241] = 141.42135623731,
    [242] = 141.42135623731,
    [243] = 100,
    [244] = 100,
    [245] = 100,
    [246] = 100,
    [247] = 141.42135623731,
    [248] = 141.42135623731,
    [249] = 141.42135623731,
    [25] = 943.39811320566,
    [250] = 100,
    [251] = 141.42135623731,
    [252] = 141.42135623731,
    [253] = 141.42135623731,
    [254] = 141.42135623731,
    [255] = 141.42135623731,
    [256] = 100,
    [257] = 100,
    [258] = 100,
    [259] = 100,
    [26] = 943.39811320566,
    [260] = 100,
    [261] = 100,
    [262] = 141.42135623731,
    [263] = 141.42135623731,
    [264] = 141.42135623731,
    [265] = 141.42135623731,
    [266] = 100,
    [267] = 100,
    [268] = 141.42135623731,
    [269] = 141.42135623731,
    [27] = 848.528137423857,
    [270] = 141.42135623731,
    [271] = 141.42135623731,
    [272] = 173.205080756888,
    [275] = 141.42135623731,
    [276] = 141.42135623731,
    [278] = 565.685424949238,
    [279] = 565.685424949238,
    [28] = 848.528137423857,
    [281] = 707.106781186548,
    [282] = 565.685424949238,
    [283] = 781.024967590665,
    [284] = 565.685424949238,
    [285] = 707.106781186548,
    [286] = 860.232526704263,
    [29] = 848.528137423857,
    [3] = 670.820393249937,
    [30] = 583.09518948453,
    [31] = 583.09518948453,
    [32] = 583.09518948453,
    [324] = 141.42135623731,
    [325] = 173.205080756888,
    [326] = 200,
    [327] = 223.606797749979,
    [328] = 264.575131106459,
    [33] = 860.232526704263,
    [331] = 173.205080756888,
    [332] = 173.205080756888,
    [333] = 200,
    [334] = 223.606797749979,
    [335] = 244.948974278318,
    [337] = 173.205080756888,
    [338] = 173.205080756888,
    [339] = 200,
    [34] = 860.232526704263,
    [342] = 141.42135623731,
    [343] = 173.205080756888,
    [344] = 200,
    [345] = 223.606797749979,
    [346] = 264.575131106459,
    [349] = 141.42135623731,
    [35] = 860.232526704263,
    [350] = 173.205080756888,
    [351] = 200,
    [352] = 223.606797749979,
    [353] = 264.575131106459,
    [354] = 223.606797749979,
    [355] = 173.205080756888,
    [356] = 223.606797749979,
    [357] = 173.205080756888,
    [358] = 244.948974278318,
    [359] = 223.606797749979,
    [36] = 848.528137423857,
    [360] = 500,
    [361] = 264.575131106459,
    [362] = 200,
    [363] = 721.110255092798,
    [364] = 538.51648071345,
    [365] = 141.42135623731,
    [366] = 141.42135623731,
    [367] = 141.42135623731,
    [368] = 141.42135623731,
    [369] = 141.42135623731,
    [37] = 848.528137423857,
    [371] = 141.42135623731,
    [372] = 141.42135623731,
    [373] = 412.310562561766,
    [374] = 141.42135623731,
    [375] = 412.310562561766,
    [376] = 141.42135623731,
    [38] = 1000,
    [380] = 141.42135623731,
    [381] = 100,
    [383] = 806.225774829855,
    [385] = 139.283882771841,
    [386] = 412.310562561766,
    [387] = 608.276253029822,
    [388] = 203.03940504247,
    [389] = 352.278299076171,
    [39] = 1000,
    [390] = 316.227766016838,
    [391] = 294.108823397055,
    [392] = 14.142135623731,
    [393] = 203.03940504247,
    [394] = 352.278299076171,
    [395] = 316.227766016838,
    [396] = 294.108823397055,
    [397] = 14.142135623731,
    [398] = 100,
    [399] = 100,
    [4] = 848.528137423857,
    [40] = 1063.01458127346,
    [400] = 100,
    [401] = 141.42135623731,
    [402] = 141.42135623731,
    [404] = 141.42135623731,
    [405] = 173.205080756888,
    [406] = 141.42135623731,
    [407] = 173.205080756888,
    [408] = 141.42135623731,
    [409] = 141.42135623731,
    [41] = 1063.01458127346,
    [410] = 100,
    [411] = 173.205080756888,
    [412] = 173.205080756888,
    [413] = 141.42135623731,
    [414] = 173.205080756888,
    [415] = 173.205080756888,
    [416] = 141.42135623731,
    [417] = 173.205080756888,
    [418] = 100,
    [419] = 100,
    [42] = 1063.01458127346,
    [420] = 141.42135623731,
    [427] = 200,
    [428] = 173.205080756888,
    [429] = 173.205080756888,
    [43] = 989.949493661167,
    [430] = 173.205080756888,
    [431] = 141.42135623731,
    [432] = 141.42135623731,
    [433] = 173.205080756888,
    [434] = 141.42135623731,
    [435] = 100,
    [436] = 100,
    [437] = 141.42135623731,
    [438] = 100,
    [439] = 100,
    [44] = 989.949493661167,
    [440] = 100,
    [442] = 141.42135623731,
    [45] = 282.842712474619,
    [450] = 173.205080756888,
    [451] = 141.42135623731,
    [454] = 100,
    [455] = 100,
    [456] = 100,
    [46] = 487.954915950234,
    [462] = 476.340214552582,
    [464] = 2005.61711201316,
    [469] = 894.427190999916,
    [47] = 282.842712474619,
    [470] = 500,
    [471] = 173.205080756888,
    [472] = 173.205080756888,
    [473] = 141.42135623731,
    [474] = 141.42135623731,
    [475] = 173.205080756888,
    [476] = 173.205080756888,
    [477] = 100,
    [478] = 100,
    [479] = 100,
    [48] = 424.264068711929,
    [480] = 100,
    [481] = 100,
    [482] = 100,
    [483] = 100,
    [485] = 223.606797749979,
    [486] = 100,
    [487] = 100,
    [488] = 100,
    [489] = 100,
    [49] = 1000,
    [490] = 100,
    [491] = 100,
    [492] = 100,
    [493] = 223.606797749979,
    [494] = 223.606797749979,
    [495] = 223.606797749979,
    [496] = 223.606797749979,
    [5] = 848.528137423857,
    [50] = 1000,
    [51] = 860.232526704263,
    [52] = 860.232526704263,
    [520] = 141.42135623731,
    [521] = 173.205080756888,
    [522] = 200,
    [523] = 223.606797749979,
    [524] = 244.948974278318,
    [525] = 244.948974278318,
    [53] = 640.312423743285,
    [532] = 360.555127546399,
    [533] = 360.555127546399,
    [534] = 223.606797749979,
    [535] = 223.606797749979,
    [536] = 360.555127546399,
    [537] = 360.555127546399,
    [538] = 806.225774829855,
    [539] = 806.225774829855,
    [54] = 640.312423743285,
    [540] = 200,
    [541] = 200,
    [542] = 200,
    [543] = 200,
    [544] = 316.227766016838,
    [545] = 316.227766016838,
    [546] = 412.310562561766,
    [547] = 412.310562561766,
    [548] = 316.227766016838,
    [549] = 316.227766016838,
    [55] = 640.312423743285,
    [550] = 173.205080756888,
    [551] = 173.205080756888,
    [552] = 141.42135623731,
    [553] = 141.42135623731,
    [554] = 141.42135623731,
    [555] = 141.42135623731,
    [56] = 640.312423743285,
    [57] = 1063.01458127346,
    [58] = 1063.01458127346,
    [59] = 1204.15945787923,
    [6] = 848.528137423857,
    [60] = 1204.15945787923,
    [61] = 141.42135623731,
    [611] = 360.555127546399,
    [612] = 447.213595499958,
    [62] = 141.42135623731,
    [625] = 141.42135623731,
    [634] = 972.432516938836,
    [636] = 1649.24225024706,
    [637] = 1649.24225024706,
    [638] = 1649.24225024706,
    [639] = 1649.24225024706,
    [64] = 141.42135623731,
    [640] = 1649.24225024706,
    [641] = 1649.24225024706,
    [642] = 2418.67732448956,
    [643] = 2418.67732448956,
    [644] = 2418.67732448956,
    [645] = 2418.67732448956,
    [646] = 2418.67732448956,
    [647] = 2418.67732448956,
    [648] = 972.432516938836,
    [649] = 972.432516938836,
    [650] = 972.432516938836,
    [651] = 707.106781186548,
    [652] = 781.024967590665,
    [653] = 781.024967590665,
    [654] = 707.106781186548,
    [655] = 707.106781186548,
    [656] = 282.842712474619,
    [657] = 721.110255092798,
    [658] = 282.842712474619,
    [659] = 282.842712474619,
    [66] = 141.42135623731,
    [660] = 282.842712474619,
    [67] = 141.42135623731,
    [684] = 223.606797749979,
    [685] = 223.606797749979,
    [686] = 141.42135623731,
    [687] = 173.205080756888,
    [688] = 141.42135623731,
    [689] = 141.42135623731,
    [69] = 141.42135623731,
    [690] = 141.42135623731,
    [691] = 173.205080756888,
    [692] = 173.205080756888,
    [693] = 141.42135623731,
    [694] = 173.205080756888,
    [695] = 173.205080756888,
    [696] = 173.205080756888,
    [697] = 173.205080756888,
    [698] = 173.205080756888,
    [699] = 173.205080756888,
    [7] = 360.555127546399,
    [700] = 141.42135623731,
    [701] = 141.42135623731,
    [702] = 141.42135623731,
    [703] = 173.205080756888,
    [704] = 173.205080756888,
    [705] = 173.205080756888,
    [71] = 70.7106781186548,
    [72] = 212.132034355964,
    [724] = 894.427190999916,
    [725] = 500,
    [726] = 200,
    [727] = 173.205080756888,
    [728] = 141.42135623731,
    [73] = 70.7106781186548,
    [731] = 141.42135623731,
    [732] = 173.205080756888,
    [733] = 200,
    [734] = 223.606797749979,
    [735] = 223.606797749979,
    [74] = 70.7106781186548,
    [75] = 70.7106781186548,
    [76] = 70.7106781186548,
    [77] = 70.7106781186548,
    [78] = 70.7106781186548,
    [780] = 500,
    [781] = 500,
    [79] = 70.7106781186548,
    [792] = 1664.33169770932,
    [793] = 1081.6653826392,
    [794] = 1063.01458127346,
    [795] = 223.606797749979,
    [796] = 173.205080756888,
    [797] = 1664.33169770932,
    [798] = 1081.6653826392,
    [799] = 1063.01458127346,
    [8] = 360.555127546399,
    [80] = 70.7106781186548,
    [800] = 223.606797749979,
    [801] = 173.205080756888,
    [804] = 141.42135623731,
    [805] = 173.205080756888,
    [806] = 200,
    [807] = 223.606797749979,
    [808] = 223.606797749979,
    [81] = 70.7106781186548,
    [811] = 141.42135623731,
    [812] = 173.205080756888,
    [813] = 200,
    [817] = 100,
    [818] = 100,
    [819] = 150,
    [82] = 70.7106781186548,
    [820] = 150,
    [821] = 150,
    [822] = 150,
    [823] = 150,
    [824] = 150,
    [825] = 150,
    [826] = 150,
    [827] = 150,
    [828] = 150,
    [829] = 150,
    [83] = 848.528137423857,
    [830] = 150,
    [831] = 100,
    [832] = 100,
    [838] = 141.42135623731,
    [84] = 848.528137423857,
    [843] = 173.205080756888,
    [85] = 1063.01458127346,
    [86] = 410.487515035476,
    [87] = 330.151480384384,
    [88] = 330.151480384384,
    [89] = 344.093010681705,
    [9] = 360.555127546399,
    [90] = 330.151480384384,
    [91] = 174.928556845359,
    [92] = 721.110255092798,
    [93] = 141.42135623731,
    [94] = 223.606797749979,
    [95] = 223.606797749979,
    [96] = 1081.6653826392,
    [97] = 360.555127546399,
    [98] = 500,
    [99] = 679.411510058521,
}