
local ui = require("ui")
local sys = require("sys")
local net = require("net")
local string = require("string")

local current_ram = 0
local current_name = ""
--

local file = sys.File("settings.txt")
file:open()
-- Load values

local current_name = string.sub(file:readln(),7,-1)

local current_ram = string.sub(file:readln(),6,-1)



file:close()


local win = ui.Window("Tech-Loader","fixed",500,320)
win:center()
win:show()
--win:status(current_name)

local button_play = ui.Button(win,"Скачать",10,260,150,50)

button_play:center()
button_play.y = 260
button_play.font = "Bahnschrift"
button_play.fontstyle = { ["bold"] = false }
button_play.fontsize = 15

local ram_bar = ui.Progressbar(win,false,1,1,120,35)
ram_bar:center()
ram_bar.y = 272.5
ram_bar.x = ram_bar.x + 160
--ram_bar.range = {5,80}



local ram_text = ui.Label(win,"")
ram_text.font = "Bahnschrift"
ram_text.fontsize = 12
ram_text.textalign = "center"
ram_text.x = ram_bar.x + 20
ram_text.y = ram_bar.y - 25
ram_text:autosize()


local meminfo = io.popen('wmic OS get TotalVisibleMemorySize /Value'):read('*a')

--win:status(string.sub(meminfo,28,-1))

local mem_gb = math.floor(string.sub(meminfo,28,-1)/1000000)

--win:status(mem_gb)

local max = mem_gb 

ram_bar.range = {0, mem_gb}

ram_bar:advance(current_ram)
ram_text.text = current_ram.."gb / "..mem_gb.." gb"

--ram_text.text = " 0 gb / "..mem_gb.." gb"
ram_text.textalign = "center"
--ram_bar:advance()

function ram_bar:onClick(x,y)
	x = x+80/mem_gb
	local percent = x/120
	local one =  1
	local comp = math.floor(x*one)
	--win:status(percent)
	if percent > 0.75 then
		
		if ui.confirm("Не рекомендуеться ставить более 75% оперативной памяти, у Саши Дубнова как то раз от этого взорвался компьютер, вы уверены что хотите продолжить?","Предупреждение") == "yes" then

			current_ram = math.floor(mem_gb*percent)
			ram_bar:advance(-100)
			ram_bar:advance(math.floor(mem_gb*percent))
			--win:status(math.floor(mem_gb*percent))
			ram_text.text = math.floor(mem_gb*percent).."gb / "..mem_gb.." gb"
			ram_text:autosize()
		else


		end

	else

		current_ram = math.floor(mem_gb*percent)
		ram_bar:advance(-100)
			ram_bar:advance(math.floor(mem_gb*percent))
			--win:status(math.floor(mem_gb*percent))
			ram_text.text = math.floor(mem_gb*percent).."gb / "..mem_gb.." gb"
	end
	--ui.info(comp)

	
end


-- save values



function save_values()
	
	while win.visible do
		

		file:open("write")

		local a = file:writeln("name: "..current_name)
		file:writeln("ram: "..current_ram)
		file:close()

		--win:status(a)
		sleep(2000)
	end


end


local astask = async(save_values)
astask:wait()















repeat
	
	ui.update()
until not win.visible
