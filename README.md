Mathantics is a set of roblox Luau libraries based in the luau interpreted language and used for my incremental game on roblox.
It includes, Mathantics and it is integrated with nETN (WIP)

Here are the descriptions of both libraries:

# Mathantics
```lua
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://www.mozilla.org/en-US/MPL/2.0/.

--[[ ★☆ ★☆ ★☆ ★☆ ★☆ ★☆
Mathantics Math Module, made possible by viewers like you XD
Powered By EternityNum by @FoundForces (A Mathantics NATIVE fork will be released soon :3)
Original Author: xoIitl
License: MPL v2.0 :D

notes:
this math module may not be 100% Optimized but it is fast enough for commercial roblox game usage.
]]
```

a Demo scriptc using Mathantics (v1.008 RR) [Using Outdated EternityNum will swtich to nETN after it is in v1.008 RR]:

```lua
local mathantics=require(script:WaitForChild("Mathantics"))

local function thewrapper(R)
	print("----------------")
	for i,v in pairs(R)do
		print("Solution "..tostring(i)..":",v)
	end
	print("----------------")
end

--Our Cool Functions X3
print("Solve equation x^3+x^2+1")
local solutions=mathantics.solvepolynomialequation(0,1,1,0,1)
thewrapper(solutions)
print("Format the solutions X3 in string form for display and give them a decimal precision of 2 :3")
thewrapper(mathantics.complextostring(solutions,2))
print("More Precise answers >w<")
thewrapper(mathantics.complextostring(solutions,15))
print("Dont Like Complex Solutions? Try mathantics.complextoreal")
thewrapper(mathantics.complextoreal(solutions))

local function formatequation(polynomial)
	for i,v in ipairs(polynomial)do
		if v~=0 then
			local x_term=i==4 and "x"or i==5 and ""or "x^"..tostring(5-i)
			local plus_minus=v<0 and "-"or i==1 and ""or"+"
			polynomial[i]=plus_minus..tostring(math.abs(v))..x_term
		else
			polynomial[i]=""
		end
	end
	return table.concat(polynomial,"")
end

local RNG=Random.new(1)
local randomequation={}
for i=1,5 do
	table.insert(randomequation,2*RNG:NextNumber()-1)
end
print("Lets now generate a random quartic equation")
print(formatequation(table.clone(randomequation)))
print("And then solve :3")
solutions=mathantics.solvepolynomialequation(unpack(randomequation))
thewrapper(mathantics.complextostring(solutions,7))
thewrapper(mathantics.complextoreal(solutions))
print("You Can verify this at desmos and the answers are correct :D \n\n\n")

local function sumfunction(n)
	return n
end
local function thewrapper2(r)
	print("-------------------")
	print(r)
	print("-------------------")
end
--Our next flagship 5 functions are the summation functions :D
print("Lets try a summing 1+2+3+4+5+6... all the way to 1,045,023")
print("Using the PowerTotalCost which covers all n^k functions our 1+2+3+4+5+6... is really n^1")
print("And we are not using ETN (Ignore if not using The ETN BigNum Library) I will make a native version soon")
thewrapper2(mathantics.PowerTotalCost(sumfunction,1045023))
print("We can even try sums of cubes, 1+8+27+64+125+...1,045,023^3")
sumfunction = function(n)
	return n^3
end
thewrapper2(mathantics.PowerTotalCost(sumfunction,1045023))
print("ORRR EVEN SUMS OF POWERS OF 23 :D")
sumfunction = function(n)
	return n^23
end
thewrapper2(mathantics.PowerTotalCost(sumfunction,1045023))
print("AND ALL OF THIS IN JUST O(k) SPEED, with k being the power SO YEA n doesnt even affect time complexity XD \n\n\n")
print("BUT WE ALSO CAN EVALUATE Sums of Powers TIMES Exponentials")
print("For example, 2*1 + 4*8 + 8*27 + 16*64 + 32*125...2^n*n^3","n from 1 to 20")
sumfunction = function(n)
	return 2^n*n^3
end
for i=1,20 do print("n="..tostring(i),mathantics.PowerMExpTotalCost(sumfunction,i))end
print("----------------\n\n\n")
print(" We are cover Geometric Costs like 2^1 + 2^2 + 2^3 +...2^100")
sumfunction = function(n)
	return 2^n
end 
thewrapper2(mathantics.GeometricTotalCost(sumfunction,100))

sumfunction = function(x)
	return math.pow(math.log10(x+1),8)+math.sqrt(x)+3434/x
end
print("\n\n\n Now for our Flagship Function, MEET mathantics.ArbitraryTotalCost()")
print("This function can evaluate any sum of the form f(x)")
print("For example f(n)=log10(x+1)^8 + 3434/x + sqrt(x)")
print("There n values from 1 to 1,000,000 are \n")
for O=0,5 do print("\n")
	for i=10^O,9*10^O,10^O do print("n="..tostring(i),sumfunction(i))end
end
print("Lets now evaluate the sum of this graph at various n")
for O=0,5 do print("\n")
	for i=10^O,9*10^O,3*10^O do print("n="..tostring(i),mathantics.ArbitraryTotalCost(sumfunction,i))end
end
print("Nooww for the speed test :D")
print("Lets evaluate this function at n=1 decillion or 1e33")
print("And we will track its time to finish")local ti=os.clock()
print(mathantics.ArbitraryTotalCost(sumfunction,1e33))
print("--------------------------")
local TDelta=math.round(1e7*(os.clock()-ti))/1e4
print("\n Finished in ",TDelta,"ms")
print("--------------------------")
print("\n\n In LESS THAN "..tostring(math.ceil(100*TDelta)/100).."ms WE ALREADY ACCURATELY EVALUATED THE SUM OF THIS RANDOM ARBITRARY FUNCTION WITH LITERAL 1/x+square roots and Complex things")
print("To put that in perspective, A for loop would've tooken more time than the existence of the universe to compute that sum ;w;")
print("And yes.. this was made by a femboy who isnt a furry (yea ik thats rare every knowledgable tech person is furry):3")
print("And it was made possible from viewers like u :D","Anyone can contribute and use this in there projects (but you have to make your forked version public and open source or i will issue DMCAs [If you Mod one in your game and you dont publish that modded version that is a DMCA, But you do not have to make your game open sourced (its just the library your using has to. Understand?)])")
```

# nETN (New Eternity Num) [v0.100\]
```lua
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://www.mozilla.org/en-US/MPL/2.0/

--[[
Original EternityNum Creator: @FoundForces, https://create.roblox.com/store/asset/12144172446/EternityNum-2
Original Name: EternityNum
Original Description: A library to handle numbers upto 10↑↑2^1024 (https://googology.fandom.com/wiki/Arrow_notation)

꒰ঌ૮ ᴗ͈ . ᴗ͈ ྀིა໒꒱

EternityNum was great and served Button Incremental(200k+ visits)
and GBI Grand Button Incremental (1.2m+ visits)
but it had some performance bottlenecks for Button Incremental Infinity (20m? visits).

So @xoIitl introduces...


	             ▄████████     ███     ███▄▄▄▄     
	            ███    ███ ▀█████████▄ ███▀▀▀██▄   
	███▄▄▄▄     ███    █▀     ▀███▀▀██ ███   ███   
	███▀▀▀██▄  ▄███▄▄▄         ███   ▀ ███   ███   
	███   ███ ▀▀███▀▀▀         ███     ███   ███   
	███   ███   ███    █▄      ███     ███   ███   
	███   ███   ███    ███     ███     ███   ███   
	 ▀█   █▀    ██████████    ▄████▀    ▀█   █▀    

	introducing nETN (newEternityNum)
	
	• The New standard BigNum library for incremental games :D
	• Numbers can go up to 10^10^(2^1024) at blazing fast and accurate speeds x3 
	• Backwords Compatibility with the original EternityNum2
	• 100% Refactored and Maintained by the Bulletin of Cute Femboys
	• 100% Open Source and Free 4EVER X3
	• Used in high scale commerical roblox games. (my game maybe)
	• Made possible and maintained from viewers like you (pbs kids)
	• Automatically Compatible with Mathantics (another BCF maintained project)
	• nETN is apart of the Mathantics Ecosystem as well as
	Mathantics (nETN supported), Mathantics (NATIVE and no nETN dependency)
	and nETN itself (which you are viewing RN)
	
So thank you viewer for using the nETN project... We will now provide Documentation embedded within each function x3

Original Author by @xoIitl
Maintained by The Bulletin of Cute Femboys
VERSION v0.100
]]
```

--TEST SCRIPT WIP

# MORE INFO
A C++ port will eventually start once both dependencies are in v1.008 RR (release)
But for now as of June 20, 2026 They will be in Luau (roblox) modules.

The Roadmap for the Mathantics repo:
Mathantics (with nETN as a dependency) - ✅
Mathantics NATIVE (no dependencys) - WIP
nETN - WIP
