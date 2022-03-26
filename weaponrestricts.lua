weapontable = {

	['pistol'] = {
		'm9k_colt1911',
	},
	
	['submachines'] = {
		'm9k_honeybadger',
	},
	
	['arifles'] = {
		'm9k_acr',
	},
	
	['heavy'] = {
		'm9k_ares_shrike',
	},
	
	['shotgun'] = {
		'm9k_m3',
	},
	
	['sniper'] = {
		'm9k_aw50',
	},
	
	['all'] = {},
	
}

allowed = {
	['TEAM_CITIZEN'] = 'pistol',
	['TEAM_POLICE'] = 'all',
	['TEAM_FBI'] = 'all',
	['TEAM_NARK'] = { 'pistol', 'submachines' },
	['TEAM_SWAT'] = 'all',
	['TEAM_CHIEF'] = { 'pistol', 'submachines' },
	['TEAM_SWATL'] = 'all',
	['TEAM_SOLDAT'] = {'heavy','pistol'},
	['TEAM_SNIPER'] = {'sniper','pistol'},
	['TEAM_MEDIC'] = 'pistol',
	['TEAM_SECURITY'] = 'all',
	['TEAM_THIEFF'] = 'pistol',
	['TEAM_GANG'] = 'all',
	['TEAM_VIPBANDIT'] = 'all',
	['TEAM_MERC'] = 'all',
	['TEAM_VIPKILLER'] = 'all',
	['TEAM_MOB'] = {'pistol', 'submachines'},
	['TEAM_ALLAH'] = 'all'
}

for k,v in pairs( weapontable ) do
	if k != 'all' then
		table.Add( weapontable.all, v )
	end
end

--PrintTable( weapontable.all )

local function GetTeamAllowed(t)
	local a = {}
	for k,v in pairs( allowed ) do
		if _G[k] != t then
			continue
		end
		if type( v ) == 'string' then
			table.Add( a, weapontable[v] )
		else
			for _, w in pairs( v ) do
				table.Add( a, weapontable[w] )
			end
		end
	end
	return a
end

local function IsTeamAllowed( t, class )
	if table.HasValue( weapontable.all, class ) then
		local tbl = GetTeamAllowed( t )
		if table.HasValue( tbl, class ) then
			return true
		end
		return false
	end
	return true
end

local function NoticeMe( ply, class )
	
	ply.noticed = ply.noticed or CurTime()
	
	if ply.noticed > CurTime() then
		return
	end
	
	ply.noticed = CurTime() + 1
	
	local a = {}
	
	for k,v in pairs( allowed ) do
		if _G[k] ==  ply:Team() then
			table.Add( a, type(v)=='string' and {v} or v )
			break
		end
	end

	ply:ChatPrint( 'Вы не можете подобрать '..class..'. Это оружие запрещено для данной профессии' )
	ply:ChatPrint( 'Разрешенное оружие: ' .. (#a == 0 and 'нет разрешенного оружия' or string.Implode( ', ', a )) )
	ply:ChatPrint( '---------------------------------------------------' )
	
end

hook.Add( 'PlayerCanPickupWeapon', '!such nonrp faggots', function( ply, wep )
	if not IsTeamAllowed( ply:Team(), wep:GetClass() ) then
		NoticeMe( ply, wep:GetClass() )
		return false
	end
end )