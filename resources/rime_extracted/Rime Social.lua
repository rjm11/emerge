rime.social = rime.social or {}

function rime.social.add_ally(ally, noecho)

	ally = string.title(ally)

	if not rime.saved.allies then rime.saved.allies = {} rime.echo("Made Allies Table!") end

	if not table.contains(rime.saved.allies, ally) then
		table.insert(rime.saved.allies, ally)
		table.save(getMudletHomeDir().."/rime.saved.lua", rime.saved)
		if noecho == nil then
			rime.echo("Added "..ally.." to our allies list!")
			rime.echo("Saved \"rime.saved\" .lua")
		end
	else
		if noecho == nil then
			rime.echo(ally.." is already in the list!")
		end
	end

end


function rime.social.remove_ally(ally)

	ally = string.title(ally)

	if not table.contains(rime.saved.allies, ally) then
		rime.echo(ally.." isn't considered an ally already!")
		table.save(getMudletHomeDir().."/rime.saved.lua", rime.saved)
		rime.echo("Saved \"rime.saved\" .lua")
	else
		table.remove(rime.saved.allies, table.index_of(rime.saved.allies, ally))
		rime.echo("Yo fuck "..ally)
	end

end

