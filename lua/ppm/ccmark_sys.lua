if SERVER then
	net.Receive("player_pony_cm_send",function(len,ply)
		ply.ponydata._cmark=ply.ponydata._cmark or ""
		local pnum=net.ReadFloat()

		if pnum==-1 then
			PPM.cmarksys_clearcmark(ply)
			if true then return end
		end

		local pall=net.ReadFloat()
		local newdata=net.ReadData(32768)

		if pnum==0 then
			ply.ponydata._cmark=""
		end

		ply.ponydata._cmark=ply.ponydata._cmark..newdata

		--//print("received packet num: ",pnum," of all packets count ",pall," new data len ",string.len(newdata)," current length ",string.len(ply.ponydata._cmark))
		if pnum+1==pall then
			--rebroadcast
			--//print("Starting rebroadcast")
			PPM.cmarksys_beginsend(ply,ply.ponydata._cmark)
		end
	end)

	function PPM.cmarksys_clearcmark(ply)
		ply.ponydata._cmark=nil
		net.Start("player_pony_cm_send")
		net.WriteEntity(ply)
		net.WriteFloat(-1)
		net.Broadcast()
	end

	function PPM.ccmakr_onplyinitspawn(ply)
		local plyray=player.GetAll()
		local sendcount=0

		for i=1,table.Count(plyray) do
			local ent=plyray[i]

			if ent.ponydata~=nil and ent.ponydata._cmark~=nil then
				--//print("SENDING DATA OF ",ent," to ",ply)
				timer.Simple(1*sendcount,function()
					PPM.cmarksys_beginsend(ent,ent.ponydata._cmark,ply)
				end)

				sendcount=sendcount+1
			end
		end
	end

	function PPM.cmarksys_beginsend(ent,data,ply)
		bool_sending=true
		local packcount=math.ceil(string.len(data) / 32768)

		--print("PREPARING TO SEND DATA PACKET COUNT: ",packcount)
		for i=1,packcount do
			timer.Simple(0.5*i,function()
				PPM.cmarksys_send(ent,data,i-1,packcount,ply)
			end)

			--print("PACKET: ",i-1," PREPARED!")
			if i==packcount then
				bool_sending=false
			end
		end
	end

	function PPM.cmarksys_send(ent,data,packetnumber,packetcount,ply)
		--for 256*256*3=6 packets
		local packetoffcet=packetnumber*32768
		net.Start("player_pony_cm_send")
		local subdata=string.sub(data,packetoffcet,packetoffcet+32768)
		net.WriteEntity(ent)
		net.WriteFloat(packetnumber)
		net.WriteFloat(packetcount)
		net.WriteData(subdata,32768)

		if ply==nil then
			net.Broadcast()
		else
			net.Send(ply)
		end
		--//print("subdata offcet: ",packetoffcet," length ",string.len(subdata))
		--//print("sent packet num: ",packetnumber," of all packets count ",packetcount)
	end
end

if CLIENT then
	local bool_sending=false

	function PPM.cmarksys_beginsend(data)
		bool_sending=true
		local packcount=math.ceil(string.len(data) / 32768)

		--//
		print("PREPARING TO SEND DATA PACKET COUNT: ",packcount)
		for i=1,packcount do
			timer.Simple(0.22*i,function()
				PPM.cmarksys_send(data,i-1,packcount)
			end)

			--//print("PACKET: ",i-1," PREPARED!")
			if i==packcount then
				bool_sending=false
			end
		end
	end

	function PPM.cmarksys_send(data,packetnumber,packetcount)
		--for 256*256*3=6 packets
		local packetoffcet=packetnumber*32768
		net.Start("player_pony_cm_send")
		local subdata=string.sub(data,packetoffcet,packetoffcet+32768)
		net.WriteFloat(packetnumber)
		net.WriteFloat(packetcount)
		net.WriteData(subdata,32768)
		--//
		print("BytesWritten: " ,net.BytesWritten( ))
		net.SendToServer()
		--//
		print("subdata offcet: ",packetoffcet," length ",string.len(subdata))
		--//
		print("sent packet num: ",packetnumber," of all packets count ",packetcount)
	end

	function PPM.cmarksys_clearcmark()
		net.Start("player_pony_cm_send")
		net.WriteFloat(-1)
		net.SendToServer()
	end

	net.Receive("player_pony_cm_send",function(len)
		local ent=net.ReadEntity()
		local pnum=net.ReadFloat()

		if pnum==-1 then
			ent.ponydata._cmark_loaded=false
			ent.ponydata._cmark=nil
			return
		elseif pnum==0 then
			ent.ponydata._cmark=""
		end

		local pall=net.ReadFloat()
		local newdata=net.ReadData(32768)
		ent.ponydata._cmark_loaded=false
		ent.ponydata._cmark=ent.ponydata._cmark or ""


		ent.ponydata._cmark=ent.ponydata._cmark..newdata

		--//print("received packet num: ",pnum," of all packets count ",pall
		--//," new data len ",string.len(newdata or "")," current length ",string.len(ply.ponydata._cmark or ""))
		if pnum+1==pall then
			ent.ponydata._cmark_loaded=true
			--then do texture render shit
		end
	end)
end