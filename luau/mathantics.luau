
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://www.mozilla.org/en-US/MPL/2.0/.

--!native
local rs = game:GetService("ReplicatedStorage")
local ETN = require(script:WaitForChild("EternityNum")) --inlined dependency (change path ofc :3) [USING OUTDATED EternityNum by FoundForces]
local mathantics,pi:number,e:number = {},math.pi,math.exp(1)

--[[ ★☆ ★☆ ★☆ ★☆ ★☆ ★☆
Mathantics Math Module, made possible by viewers like you XD
Powered By EternityNum by @FoundForces (A Mathantics NATIVE fork will be released soon :3)
Original Author: xoIitl
License: MPL v2.0 :D

notes:
this math module may not be 100% Optimized but it is fast enough for commercial roblox game usage.
]]

local function len(t:{[any]:any}):(number)local n=0 for _ in pairs(t)do n+=1 end return n end
local function rounding(v:number,precision:number,stringed:boolean?):(string|number)
	stringed=stringed or true
	local j = math.pow(10,precision)local finale=math.round(j*v)/j
	return stringed and tostring(finale) or finale
end

export type EN=ETN.EN
export type BN=ETN.BN
export type FlexNum=number|EN

--improved math.random with luck k.
function mathantics.randomize(k:number):(number)
	local x:number = math.random()
	return x/(k-k*x+x),x
end

--improved math.random with luck k and range from 0 to n.
function mathantics.randomize2(k:number,n:number):(number)
	local x:number = math.random()
	return (n*x)/(k-k*x+x)
end

--Given the most rarest chance in a set, returns k of when that rarest change hits a luck threshold of x% (default is 75%)
function mathantics.findmaxk(p:number,threshold:number?):(number)
	threshold=threshold or 0.75 return threshold*(1-p)/(p*(1-threshold))
end

--Returns the warped probability in a set of that item based on its luck k, beginning rarity s (sum up all raw chances up to the nth item in the set), and its raw chance (op).
function mathantics.luckprobability(k:number,s:number,op:number):(number)
	local sop = s+op
	return sop/(k*(1-sop)+sop)-s/(k*(1-s)+s)
end

--[★☆ OLD ★☆]
--Returns a modified log where x=0 is 0 not undefined. A is the coefficient, b is the base, and mult is the exponent. f(x)=A*log_b(x+1)^mult
function mathantics.logformula(x:number,A:number,b:number,mult:number):(number)
	return A*math.pow(math.log(x+1,b),mult)
end

--[★☆ OLD ★☆]
--Returns a XP to Level conversion function. L(xp)=Level
function mathantics.xptolevel(xp:number):(number)
	local d = math.pow(xp/4,1/3)
	local dif = math.floor((math.ceil(d)-d)*1E12)
	if dif == 0 then
		d = math.round(d)
	else
		d = math.floor(d)
	end
	return d
end

--[★☆ OLD ★☆]
--Returns a Level to Base XP conversion function. XP(L)=BaseXP
function mathantics.leveltoxp(level:number):(number)
	return 4*level^3
end

--[★☆ OLD ★☆]
--Returns XP Needed to Level up one based on Level.
function mathantics.xprequiredtonextlvl(level:number):(number)
	return 12*level*(level+1)+4
end

local OMEGA:number = 0.56714329040978387299997  --W(1, 0)
local ETNZero=ETN.new(0,0,0)

--Lambert W function. Identity: W(x*e^x)=x <Accepts ETN>
function mathantics.W(z:FlexNum,tol:number?):(FlexNum)
	local w:FlexNum,wn:FlexNum = nil tol=tol or 1e-10
	if type(z)=="table" then
		if ETN.IsZero(z)then return z end
		if ETN.toNumber(z)==1 then return ETN.fromNumber(OMEGA) end

		if ETN.le(z,10) then
			w = ETNZero
		else
			local elog=ETN.log(z,e)
			w = ETN.sub(elog,ETN.log(elog,e))
		end

		for i=1, 100 do
			wn = ETN.div(
				ETN.add(ETN.pow(w,2),ETN.mul(z,ETN.exp(ETN.mul(-1,w)))),
				ETN.add(w,1)
			)
			if ETN.le(ETN.abs(ETN.sub(wn,w)),ETN.mul(tol,ETN.abs(wn)))then
				return wn
			else
				w = wn
			end
		end
		return wn
	end
	if z == 0 then return z end
	if z == 1 then return OMEGA end

	if z < 10 then
		w = 0
	else
		w = math.log(z)-math.log(math.log(z))
	end

	for i=1, 100 do
		wn = (z * math.exp(-w) + w * w) / (w + 1)
		if math.abs(wn - w) < tol * math.abs(wn) then
			return wn
		else
			w = wn
		end
	end

	error('Failed to itterate z.... at function: Lambert W')
end

mathantics.buttoncostscaling = {
	--Multis take in, 1: General Hardness, 2: Big Button Hardness, 3: Cutoff Number
	BasicExponential={
		ButtonCost=function(n:number,costinitial:number,multis:{number}):(EN)
			return ETN.roundify(ETN.mul(costinitial,ETN.pow(multis[1],n)),2)
		end, --Buttoncost
		BigButtonCost=function(n:number,costinitial:number,multis:{number},T:number):(EN)
			local Miamis_Number=math.pow(multis[2],-multis[3])
			return ETN.mul(costinitial,ETN.pow(multis[1],ETN.add(ETN.sub(ETN.pow(multis[2],n-T-multis[3]),Miamis_Number),n)))
		end, --Bigbuttoncost
		InverseBigButtonCost=function(amt:number,costinitial:number,multis:{number},T:number):(number)
			local k=ETN.toNumber(ETN.log(ETN.div(amt,costinitial),multis[1]))
			local cutterinverseexpo=math.pow(multis[2],-multis[3])
			local ln2=math.log(multis[2])

			return math.floor(
				cutterinverseexpo+k-ETN.toNumber(ETN.div(
					mathantics.W(ETN.mul(
						ln2,
						ETN.pow(multis[2],k-(multis[3]-cutterinverseexpo)-T)
						)),
					ln2
					))
			)
		end, --Inverse Big Button Cost
	},
	BasicPolynomial={ -- Multis take in, 1: Polynomial Degree, 2: Big Button Hardness, 3: Cutoff Number
		ButtonCost=function(n:number,costinitial:number,multis:{number}):(EN)
			return ETN.roundify(ETN.mul(costinitial,ETN.pow(n+1,multis[1])),2)
		end, --Buttoncost
		BigButtonCost=function(n:number,costinitial:number,multis:{number},T:number):(EN)
			local E1=ETN.log(
				ETN.div(
					mathantics.W(ETN.div(
						ETN.pow(multis[1],ETN.pow(multis[2],-multis[3])),
						ETN.mul(costinitial,math.log(multis[2]))
						)),
					math.log(multis[1])
				),
				multis[2]
			)
			local Diony=ETN.pow(multis[1],ETN.pow(multis[2],E1))
			return ETN.mul(
				costinitial^2,
				ETN.add(
					ETN.div(ETN.pow(T,multis[1]),costinitial),
					ETN.mul(
						ETN.sub(ETN.pow(Diony,ETN.pow(multis[2],n+1-T)),Diony),
						ETN.mul(
							multis[1],
							ETN.mul(
								ETN.pow(T,multis[1]-1),
								ETN.pow(multis[1],ETN.pow(-multis[2],-multis[3]))
							))
					)
				)
			)
		end, --Bigbuttoncost
		InverseBigButtonCost=function(amt:number,costinitial:number,multis:{number},T:number):(number)
			local E1=ETN.log(
				ETN.div(
					mathantics.W(ETN.div(
						ETN.pow(multis[1],ETN.pow(multis[2],-multis[3])),
						ETN.mul(costinitial,math.log(multis[2]))
						)),
					math.log(multis[1])
				),
				multis[2]
			)
			local Diony=ETN.pow(multis[1],ETN.pow(multis[2],E1))

			return math.floor(ETN.toNumber(ETN.log(
				ETN.log(
					ETN.add(
						Diony,
						ETN.mul(
							ETN.div(
								ETN.mul(T,ETN.pow(multis[1],ETN.pow(multis[2],-multis[3]))),
								multis[1]*costinitial
							),
							ETN.sub(
								ETN.div(amt,ETN.mul(costinitial,ETN.pow(T,multis[1]))),
								1
							)
						)
					),
					Diony
				)
				,multis[2])))+T-1
		end, --Inverse Big Button Cost
	},
}

mathantics.buttongainscaling = {
	BasicExponential={
		GainFormula=function(n:number,gaininitial:number,multis:{number}):(EN)
			return ETN.mul(gaininitial,ETN.pow(multis[1],n))
		end, -- Button Gain
	},
	BasicPolynomial={
		GainFormula=function(n:number,gaininitial:number,multis:{number}):(EN)
			return ETN.mul(gaininitial,ETN.pow(n+1,multis[1]))
		end, -- Button Gain
	},
}

--Factorial function for INTEGERS ONLY! (Use mathantics.gamma(x) for the Gamma Function)
function mathantics.factorial(n:number,stopping:number?):(number)
	n=math.round(n)stopping=stopping or 2
	stopping=math.round(stopping)>n and n or math.round(stopping)
	if n < 0 or n ~= n then return 0 end
	if n==0 or n==1 then return 1 end local result = n
	if n==stopping or n==2 then return result end
	for i=n-1,(stopping>=2 and stopping or 2),-1 do 
		result*=i if result==math.huge then break end
	end return result
end

local ETNOne=ETN.new(1,0,1)
--Factorial function for INTEGERS ONLY! (Use mathantics.gamma(x) for the Gamma Function) <Returns ETN>
function mathantics.etnfactorial(n:number,stopping:number):(EN)
	n=math.round(n)stopping=stopping or 2
	stopping=math.round(stopping)>n and n or math.round(stopping) 
	if n < 0 or n ~= n then return ETNZero end
	if n==0 or n==1 then return ETNOne end local result = ETN.new(1,0,n)
	if n==stopping or n==2 then return result end
	for i=n-1,(stopping>=2 and stopping or 2),-1 do result = ETN.mul(result,ETN.new(1,0,i)) end return result
end

local AChooseB:{[string]:EN},ABMAX:number={},10
local B:{EN},BMAX:number = {ETNOne},10
local QNumbers:{{EN}},QMAX:number = {{ETNOne},{ETNOne,ETNOne}},10
local GUASS_NODES:{{nodes:{number},weights:{number}}},Gmax:number={},10

--Calculates Chebyshev roots used for inputting x into the mathantics.getFornbergW :3
function mathantics.chebyshevRoots(p:number,x0:number,SCALE:number):({number})
	local points={}for j=1,p do points[j]=x0+SCALE*math.cos(pi*(2*j-1)/(2*p))end return points
end
--Calculates Fornberg weights up to max_order used for calculating differientations :3
function mathantics.getFornbergW(x:{number},x0:number,max_order:number):({{number}})
	local n=#x if n==0 then return end if max_order<0 then return end
	local c1,c4,c=1,x[1]-x0,{}for k=0,max_order do c[k+1]=table.create(n,0)end c[1][1]=1
	for i=2,n do local mn,c2,c5,i1=math.min(i,max_order+1),1,c4,i-1 c4=x[i]-x0
		for j=1,i1 do local c3=x[i]-x[j]c2*=c3
			if j==i1 then
				for k = mn, 2, -1 do local k1=k-1 c[k][i]=c1*(k1*c[k1][i1]-c5*c[k][i1])/c2 end
				c[1][i]=-c1*c5*c[1][i1]/c2
			end 
			for k=mn,2,-1 do local k1=k-1 c[k][j]=(c4*c[k][j]-k1*c[k1][j])/c3 end c[1][j]=c4*c[1][j]/c3
		end c1=c2
	end return c
end

--Calculates the Gaussian Nodes and Weights used in the Guassian Quadrature integration approximation formulas :3 (Use mathantics.getGuassLayer if you priortize speed. THIS FUNCTION DOES NOT CACHE!)
function mathantics.computeGLayer(n:number,returnB:boolean):({nodes:{number},weights:{number}}?)
	local GuassLegend={nodes={},weights={}}
	for i=1,n do local x=math.cos(math.pi*(i-0.25)/(n+0.5))
		for iter=1,20 do --newtons method
			local p_prev,p=1,x for k=2,n do
				local p_next=((2*k-1)*x*p-(k-1)*p_prev)/k p_prev=p p=p_next
			end
			local p_deriv=n*(x*p-p_prev)/(x*x-1)
			local dx=p/p_deriv x=x-dx
			if math.abs(dx) < 1e-15 then break end
		end GuassLegend.nodes[i]=x
		local p_prev,p=1,x for k=2,n do
			local p_next=((2*k-1)*x*p-(k-1)*p_prev)/k p_prev=p p=p_next
		end
		local p_deriv=n*(x*p-p_prev)/(x*x-1)
		GuassLegend.weights[i]=2/((1-x^2)*p_deriv*p_deriv)
	end GUASS_NODES[n]=GuassLegend
	return returnB and GuassLegend or nil
end for i=1,Gmax do mathantics.computeGLayer(i,false)end

--Calculates the Binomial Coefficient "a choose b" :3 (Use mathantics.Binomial if you priortize speed. THIS FUNCTION DOES NOT CACHE!) <Returns ETN>
function mathantics.computeACB(a:number,b:number,returnB:boolean):(EN?)
	local binomial=ETNOne if a==b or b==0 then 
		AChooseB[tostring(a).."_"..tostring(b)]=binomial
		return returnB and binomial or nil
	end local venusianNumber=a/2-math.abs(b-a/2)
	binomial=ETN.div(
		mathantics.etnfactorial(a,a-venusianNumber+1),
		mathantics.etnfactorial(venusianNumber)
	)
	AChooseB[tostring(a).."_"..tostring(b)]=binomial
	return returnB and binomial or nil
end 
for a=0,ABMAX do for b=0,a do mathantics.computeACB(a,b,false)end end

--Calculates the Eulerian Numbers up to n :3 (Use mathantics.getQNumbers for production. THIS FUNCTION IS ONLY USED TO GENERATE!) <Returns ETN>
function mathantics.computeEu(n:number,returnB:boolean):({EN}?)
	local Ld=#QNumbers for QR=Ld+1,n do
		local qnumbers={ETNOne}
		for i=2,QR-1 do local qn1=QNumbers[Ld]
			local Up=ETN.mul(i,qn1[i])
			local TopLeft=ETN.mul(Ld-i+2,qn1[i-1])
			table.insert(qnumbers,ETN.add(Up,TopLeft))
		end
		table.insert(qnumbers,ETNOne)
		Ld+=1 QNumbers[Ld]=qnumbers
	end
	return QNumbers[n]
end mathantics.computeEu(QMAX,false)

--Returns the Binomial Coefficient "a choose b", normal=true on default. if normal=false then it returns an ETN value.
function mathantics.Binomial(a:number,b:number,normal:boolean?):(FlexNum)
	if type(normal)=="nil"then normal=true end local cached=AChooseB[tostring(a).."_"..tostring(b)]
	if cached then return normal and ETN.toNumber(cached)or cached end
	cached=mathantics.computeACB(a,b,true)
	return normal and ETN.toNumber(cached)or cached
end

--Calculates the Bernoulli Numbers up to n :3 (Use mathantics.B for production. THIS FUNCTION IS ONLY USED TO GENERATE!) <Returns ETN>
function mathantics.computeB(n:number,returnB:boolean):(EN?)
	if B[n+1]then return returnB and B[n+1]or nil end
	if n%2==1 and n>1 then B[n+1]=ETNZero return B[n+1]end
	local accumulated=ETNZero for k=0,n-1 do 
		accumulated=ETN.add(accumulated,
			ETN.mul(mathantics.Binomial(n+1,k,false),mathantics.computeB(k,true))
		)
	end
	accumulated=ETN.div(accumulated,n+1)accumulated.Sign*=-1 B[n+1]=accumulated return accumulated
end mathantics.computeB(BMAX,false)

--Returns the nth Bernoulli Number, normal=true on default. if normal=false then it returns an ETN value.
function mathantics.B(n:number,normal:boolean?):(FlexNum)
	if type(normal)=="nil"then normal=true end local cached=B[n+1]
	if n==1 then return normal and 0.5 or ETN.new(1,0,0.5) end
	if cached then return normal and ETN.toNumber(cached)or cached end
	cached=mathantics.computeB(n,true) 
	return normal and ETN.toNumber(cached)or cached
end

--Returns the nth set of Eulerian Numbers, normal=true on default. if normal=false then it returns an ETN value.
function mathantics.getQNumbers(n:number,normal:boolean?):({FlexNum})
	if type(normal)=="nil"then normal=true end local cached=QNumbers[n]
	if cached then if normal then
			for i,v in ipairs(cached)do cached[i]=ETN.toNumber(v)end
		end return cached
	end cached=mathantics.computeEu(n,true)if normal then
		for i,v in ipairs(cached)do cached[i]=ETN.toNumber(v)end
	end return cached
end

--Returns the nth layer of Gaussian Nodes and Weights used in Guassian Quadrature algorithms.
function mathantics.getGuassLayer(n:number):({nodes:{number},weights:{number}})
	local cached=GUASS_NODES[n]if cached then return cached end
	return mathantics.computeGLayer(n,true)
end

local Q:{(number)->(EN)}={function()return ETNOne end}
--Given the degree of the polynomial and the x value, it returns a nth-deg Eulerian Polynomial and is evaluated at x. <Accepts ETN>
function mathantics.q(deg:number,x:FlexNum,normal:boolean?):(FlexNum)
	if type(normal)=="nil"then normal=true end
	if not Q[deg+1]then
		local qcoefficients=mathantics.getQNumbers(deg,false)
		Q[deg+1]=function(x)local sum=ETNZero
			for i,coefficient in ipairs(qcoefficients)do
				sum=ETN.add(sum,ETN.mul(coefficient,ETN.pow(x,i-1)))
			end return sum
		end
	end
	local qanswer=Q[deg+1](x)return normal and ETN.toNumber(qanswer)or qanswer
end

--Accurate Direct summation algorithm from Kahan :3 [DO NOT put big n (>100,000) for this one or your game will suffer from lag use mathantics.ArbitraryTotalCost or any of the closed form TotalCost functions if your function is those formats] <Accepts ETN>
function mathantics.KahanSum(Fx:(FlexNum)->(FlexNum),n:number,isetn:boolean?,StoreNumbers:boolean?):(FlexNum,{FlexNum}?)
	if type(isetn)~="boolean"then isetn=false end if type(StoreNumbers)~="boolean"then StoreNumbers=false end 
	local sum,comp,StoredNumbers=ETNZero,ETNZero,{}if isetn then
		for i=1,n do --Kahan
			local y=ETN.sub(Fx(i),comp)
			local t=ETN.add(sum,y)
			local tminussum=ETN.sub(t,sum)
			comp=ETN.sub(tminussum,y)
			sum=t
			if StoreNumbers then StoredNumbers[i]=sum end
		end return sum,StoreNumbers and StoredNumbers or nil
	else sum,comp=0,0
		for i=1,n do --Kahan
			local y=Fx(i)-comp
			local t=sum+y
			comp=(t-sum)-y
			sum=t
			if StoreNumbers then StoredNumbers[i]=sum end
		end return sum,StoreNumbers and StoredNumbers or nil
	end
end


--Given a function F(x), and limits of integration a to b plus optional parameters like isetn (If your function uses ETN then mark it as true otherwise false) and n (the higher the n the more accurate but then the function will take slightly longer ;-;, for balance n is set to 5), Returns the area F(x) with its left and right bounds being x=a,x=b and the x-axis (if F(x) returns negative values then the area subtracts). <Accepts ETN>
function mathantics.Integrate(Fx:(FlexNum)->(FlexNum),a:number,b:number,isetn:boolean?,n:number?):(FlexNum)
	n=n or 10 if type(isetn)~="boolean"then isetn=false end
	local GLAYER=mathantics.getGuassLayer(n)
	local mid,half,sum=0.5*(a+b),0.5*(b-a),isetn and ETNZero or 0
	if isetn then
		for i=1,n do local x=mid+half*GLAYER.nodes[i]
			sum=ETN.add(sum,ETN.mul(GLAYER.weights[i],Fx(x)))
		end
		sum=ETN.mul(half,sum)
	else
		for i=1,n do local x=mid+half*GLAYER.nodes[i]
			sum+=GLAYER.weights[i]*Fx(x)
		end
		sum*=half
	end return sum
end

local function parseetn(etn:EN)
	local mantissa=etn.Layer==1 and tostring(math.pow(10,etn.Exp-math.floor(etn.Exp)))or tostring(etn.Exp/math.pow(10,math.log10(etn.Exp)))
	return (etn.Sign==-1 and "-"or"+")..mantissa.." E "..(etn.Layer==1 and math.floor(etn.Exp)or math.floor(math.log10(etn.Exp)))
end
--[THIS IS A MORE ACCURATE VERSION of mathantics.Integrate but is slower (one/two calls wont affect speed its still super fast)] Given a function F(x), and limits of integration a to b plus optional parameters like isetn (If your function uses ETN then mark it as true otherwise false) and n (the higher the n the more accurate but then the function will take slightly longer ;-;, for balance n is set to 5), tol is the tolerance value of accurary of the approximation (default set to 1e-8), max_depth is how much iterations the stack should do before it stops (prevents lag + default is 50). Returns the area F(x) with its left and right bounds being x=a,x=b and the x-axis (if F(x) returns negative values then the area subtracts). <Accepts ETN>
function mathantics.Integrate2(Fx:(FlexNum)->(FlexNum),a:number,b:number,isetn:boolean?,n:number?,tol:number?,max_depth:number?):(FlexNum)
	n=n or 10 tol=tol or 1e-8 max_depth=max_depth or 20 if type(isetn)~="boolean"then isetn=false end
	local stack={{a,b,0}}
	local total=isetn and ETNZero or 0
	while #stack>0 do
		local a_i,b_i,depth=table.unpack(table.remove(stack))
		local mid=(a_i+b_i)*0.5
		local coarse=mathantics.Integrate(Fx,a_i,b_i,isetn,n)

		local fine_left=mathantics.Integrate(Fx,a_i,mid,isetn,n)
		local fine_right=mathantics.Integrate(Fx,mid,b_i,isetn,n)
		local fine=isetn and ETN.add(fine_left,fine_right)or fine_left+fine_right

		local error_val=isetn and ETN.abs(ETN.sub(fine,coarse))or math.abs(fine-coarse)
		local scale=isetn and ETN.add(ETN.abs(fine),1e-9)or math.abs(fine)+1e-15

		local cod if isetn then
			cod=ETN.leeq(error_val,ETN.mul(tol,scale))
		else
			cod=error_val<=tol*scale
		end

		if cod or depth>=max_depth then
			total=isetn and ETN.add(total,fine)or total+fine
		else
			table.insert(stack,{a_i,mid,depth+1})
			table.insert(stack,{mid,b_i,depth+1})
		end
	end return total
end

local Derivparams={
	[1]={1e6,25,0.01},
	[2]={1e10,30,0.002},
	[3]={math.huge,30,0.001},
}

--Calculates the Derivative of any function f(x) at x and its order (defaults to 1). Or in simple terms, calculates the instantenous rate of change at point x. <Accepts ETN>
function mathantics.Derivative(Fx:(FlexNum)->(FlexNum),x:number,order:number|{number}?,isetn:boolean?,n:number?,s:number?):(FlexNum|{FlexNum})
	order=order or 1 local OLIST=type(order)=="table"
	if OLIST then local pos=table.find(order,0)if pos then table.remove(order,pos)end
		if len(order)==0 then warn("Redundant use of mathantics.Derivative set order higher than 0")return Fx(x)end 
	else
		if order==0 then warn("Redundant use of mathantics.Derivative set order higher than 0")return Fx(x)end
		if order<0 then return end order={order}
	end
	local xa=math.abs(x)if xa<1 then xa=1 end if type(n)~="number"or type(s)~="number"then
		local D for _,newD in ipairs(Derivparams)do D=newD if newD[1]>=xa then break end end n=n or D[2] s=s or D[3]
	end if type(isetn)~="boolean"then isetn=false end s*=xa
	local X,ST,SM=mathantics.chebyshevRoots(n,x,s),{},0
	for i=2,n do if X[i]==X[i-1] then return isetn and ETNOne or 1 end end
	for i=1,n do ST[i]=X[i]-x local a=math.abs(ST[i])if a>SM then SM=a end end
	local HIGHESTORDER=0 for _,NO in ipairs(order)do if NO>HIGHESTORDER then HIGHESTORDER=NO end end
	for i=1,n do ST[i] /=SM end local listofweights=mathantics.getFornbergW(ST,0,HIGHESTORDER)

	local Fxxq={}for q=1,n do Fxxq[X[q]]=Fx(X[q])end
	local Derivatives={}for _,dorder in ipairs(order)do
		local weights=listofweights[dorder+1]if isetn then local sum=ETNZero
			for q=1,n do sum=ETN.add(sum,ETN.mul(weights[q],Fxxq[X[q]]))end
			Derivatives[dorder]=ETN.div(sum,ETN.pow(SM,dorder))
		else 
			local sum,c=0,0 for q=1,n do
				local y=weights[q]*Fxxq[X[q]]-c
				local t=sum+y
				c=(t-sum)-y sum=t
			end Derivatives[dorder]=sum/math.pow(SM,dorder)
		end
	end if not OLIST then
		return Derivatives[order[1]]
	end return Derivatives
end

--Calculates the sum of constants (∑ [n=1 → k] C) <Accepts ETN>
function mathantics.ConstantTotalCost(Constant:FlexNum,n:FlexNum,isetn:boolean?):(FlexNum)
	if type(isetn)~="boolean"then isetn=type(Constant)=="table"end
	if isetn then return ETN.mul(Constant,n)else return Constant*n end
end

--Calculates the sum of powers  (∑ [n=1 → k] b*n^p), given a power function (F(x)=b*x^p) <Accepts ETN>
function mathantics.PowerTotalCost(Power:(FlexNum)->(FlexNum),n:number,isetn:boolean?):(FlexNum)
	if type(isetn)~="boolean"then isetn=false end if n==0 then return isetn and ETNZero or 0 end
	local b = Power(0)
	local C=isetn and ETN.roundify(ETN.sub(Power(1),b),12)or math.round((Power(1)-b)*1E10)/1E10
	local k=isetn and ETN.toNumber(ETN.log(ETN.div(ETN.sub(Power(0.5),b),C),2))or math.log((Power(1/2)-b)/C,2)
	local p,accumulated = math.round(-1E4*k)/1E4,0 local p1 = p+1 if isetn then
		for j=0,p do local j1 = p1-j
			accumulated = ETN.add(
				ETN.mul(
					mathantics.Binomial(p1,j,false),
					ETN.mul(
						mathantics.B(j,false),
						ETN.pow(n,j1)
					)
				),
				accumulated
			)
		end return ETN.add(ETN.mul(b,n),ETN.mul(C,ETN.div(accumulated,p1)))
	else
		for j=0,p do local j1 = p1-j
			accumulated += mathantics.Binomial(p1,j)*mathantics.B(j)*n^j1
		end return b*n+C*accumulated/p1
	end
end

--Calculates the sums of exponentials (∑ [n=1 → k] b*a^n), given a geometric function (F(x)=b*a^x) <Accepts ETN>
function mathantics.GeometricTotalCost(Geometric:(FlexNum)->(FlexNum),n:number,isetn:boolean?):(FlexNum)
	if type(isetn)~="boolean"then isetn=false end if n==0 then return isetn and ETNZero or 0 end
	local b,a=Geometric(0),Geometric(1)
	if isetn then a=ETN.div(a,b)
		if ETN.eq(a,1)then return mathantics.ConstantTotalCost(b,n)end
		return ETN.div(
			ETN.mul(
				b,
				ETN.mul(
					a,
					ETN.mul(
						ETN.sub(
							1,
							ETN.pow(a,n)
						)
					)
				)
			),
			ETN.sub(1,a)
		)
	else a/=b
		if a==1 then return mathantics.ConstantTotalCost(b,n) end
		return b*a*(1-a^n)/(1-a)
	end
end

--Calculates the sums of power times exponentials ( ∑ [n=1 → k] b*(n^p)*(a^n) ), given a function, F(x)=b*(x^p)*(a^x) <Accepts ETN>
function mathantics.PowerMExpTotalCost(PowerMExp:(FlexNum)->(FlexNum),n:number,isetn:boolean?):(FlexNum)
	if type(isetn)~="boolean"then isetn=false end if n==0 then return isetn and ETNZero or 0 end
	local q0,q1,q2=PowerMExp(1),PowerMExp(2),PowerMExp(0.5)
	local a,b,k,cod if isetn then
		if ETN.IsZero(q0)then return ETNZero end
		a=ETN.toNumber(ETN.div(
			ETN.pow(ETN.mul(q1,q2),2),
			ETN.pow(q0,4)
			))b=ETN.toNumber(ETN.div(q0,a))
		k=ETN.toNumber(ETN.sub(ETN.sub(
			ETN.mul(9/3,ETN.log(q0,2)),
			ETN.log(q1,2)),
			ETN.mul(2,ETN.log(q2,2))
			))
	else
		if q0==0 then return 0 end 
		a=math.pow(q1*q2,2)/math.pow(q0,4)b=q0/a
		k=9*math.log(q0,2)/3-math.log(q1,2)-2*math.log(q2,2)
	end
	a=math.round(a*1E10)/1E10 b=math.round(b*1E10)/1E10 k=math.round(k)
	if a==1 then return mathantics.PowerTotalCost(PowerMExp,n,isetn)end
	if k==0 then return mathantics.GeometricTotalCost(PowerMExp,n,isetn)end
	local a1,accumulated=1-a,ETNZero for m=0,k do
		accumulated=ETN.add(accumulated,ETN.mul(ETN.mul(
			mathantics.Binomial(k,m,false),
			ETN.pow(
				ETN.mul(n,a1),
				k-m
			)),
			mathantics.q(m,a,false)
			))
	end
	accumulated=ETN.mul(ETN.pow(a,n),accumulated)
	local result=ETN.div(
		ETN.mul(ETN.mul(
			b,
			a),
			ETN.sub(mathantics.q(k,a,false),accumulated)
		),
		ETN.pow(a1,k+1)
	)
	return isetn and result or ETN.toNumber(result)
end

--[★☆ OLD ★☆]
--Used for Friend Boost Formulas 
function mathantics.xpboosts(friends:number):(number)
	friends=math.min(friends,5)
	return 1+(4*friends+friends^2)/45
end

--COMPLEX MODULE
export type CTN={RealPart:number,ComplexPart:number}
export type MixedNum=CTN|number

--Create a new CTN from real part,a and imaginary part,b.
function mathantics.CTNnew(a:number,b:number):(CTN)return{RealPart=a,ComplexPart=b}end
local CTNOrigin=mathantics.CTNnew(0,0)
--Convert Number to CTN
function mathantics.convtoz(realnumber:number):(CTN)return{RealPart=realnumber,ComplexPart=0}end
--sqrt(x) the Number and then convert it to a CTN
function mathantics.sqrttoz(realnumber:number):(CTN)
	if realnumber>=0 then
		return{RealPart=math.sqrt(realnumber),ComplexPart=0}
	else 
		return{RealPart=0,ComplexPart=math.sqrt(math.abs(realnumber))}
	end
end
--Returns the Conjugate of a CTN
function mathantics.conjugate(z:CTN):(CTN)return{RealPart=z.RealPart,ComplexPart=-z.ComplexPart}end
--Returns a CTN but its sign flip
function mathantics.flip(z:CTN):(CTN)return{RealPart=-z.RealPart,ComplexPart=-z.ComplexPart}end
--Returns a CTN with its real part sign flipped
function mathantics.neg(z:CTN):(CTN)return{RealPart=-z.RealPart,ComplexPart=z.ComplexPart}end
--Returns a CTN with only positive values
function mathantics.positivitize(z:CTN):(CTN)return{RealPart=math.abs(z.RealPart),ComplexPart=math.abs(z.ComplexPart)}end
--Returns a CTN with only negative values
function mathantics.negitivitize(z:CTN):(CTN)return{RealPart=-math.abs(z.RealPart),ComplexPart=-math.abs(z.ComplexPart)}end
--Returns a CTN but multiplied by a factor k.
function mathantics.complexscale(z:CTN,k:number):(CTN)
	return{RealPart=z.RealPart*k,ComplexPart=z.ComplexPart*k}
end
--Returns the absolute value of a CTN (tocomplex param set to false on default)
function mathantics.complexabs(z:CTN,tocomplex:boolean?):(MixedNum)
	if type(tocomplex)~="boolean"then tocomplex=false end
	local k=math.sqrt(z.RealPart^2+z.ComplexPart^2)
	if tocomplex then return{RealPart=k,ComplexPart=0}else return k end
end
--Returns magnitude and theta from a CTN
function mathantics.topolarform(z:CTN):(number,number)
	return mathantics.complexabs(z),math.atan2(z.ComplexPart,z.RealPart)
end
--Truncates floating point errors from a CTN :3
function mathantics.beautifycomplex(z:CTN):(CTN)
	return {RealPart=math.round(z.RealPart*1E14)/1E14+0,ComplexPart=math.round(z.ComplexPart*1E14)/1E14+0}
end

local function formula1(r:number,n:number,k:number,theta:number):(CTN)
	local P,q=(theta+2*pi*k)/n,math.pow(r,1/n)return{RealPart=q*math.cos(P),ComplexPart=q*math.sin(P)}
end
local function formula2(r:number,n:number,theta:number):(CTN)
	local P,q=theta*n,math.pow(r,n)return{RealPart=q*math.cos(P),ComplexPart=q*math.sin(P)}
end
--Returns the square of a CTN
function mathantics.complexsquared(z:CTN):(CTN)
	return{RealPart=z.RealPart^2-z.ComplexPart^2,ComplexPart=2*z.RealPart*z.ComplexPart}
end
--Returns the cube of a CTN
function mathantics.complexcubed(z:CTN):(CTN)
	if z.RealPart==0 and z.ComplexPart==0 then return CTNOrigin end
	local r,theta=mathantics.topolarform(z)return formula2(r,3,theta)
end
--Returns the kth power of a CTN (n must be an integer)
function mathantics.complexintpow(z:CTN,k:number):(CTN)
	if z.RealPart==0 and z.ComplexPart==0 then return CTNOrigin end
	local r,theta=mathantics.topolarform(z)return formula2(r,k,theta)
end
--Returns the kth power of a CTN (n must be a real number)
function mathantics.complexpow(z:CTN,k:number,range:{{min:number,max:number}}?):({CTN})
	if z.RealPart==0 and z.ComplexPart==0 then return {CTNOrigin} end
	range=range or {{min=0,max=0}}local r,theta=mathantics.topolarform(z)local T={}
	r=math.pow(r,k)theta*=k local M=2*pi*(k%1)
	for _,RR in ipairs(range)do for i=RR.min,RR.max do
		if T[i+1] then continue end local angle=theta+M*i
		T[i+1]=mathantics.beautifycomplex({RealPart=r*math.cos(angle),ComplexPart=r*math.sin(angle)})
	end end return T
end
--Returns the square root of a CTN
function mathantics.complexsqrt(z:CTN,multiplicity:boolean?):({CTN})
	if type(multiplicity)~="boolean"then multiplicity=true end 
	if z.RealPart==0 and z.ComplexPart==0 then return multiplicity and table.create(2,CTNOrigin)or{CTNOrigin}end 
	local r,SIGN=mathantics.complexabs(z),math.sign(z.ComplexPart)
	if SIGN==0 then local p=mathantics.sqrttoz(z.RealPart)return{p,mathantics.flip(p)}end
	local k={RealPart=math.sqrt((r+z.RealPart)/2),ComplexPart=SIGN*math.sqrt((r-z.RealPart)/2)}
	return{k,mathantics.flip(k)}
end
--Returns the cube root of a CTN
function mathantics.complexcbrt(z:CTN,multiplicity:boolean?):({CTN})
	if type(multiplicity)~="boolean"then multiplicity=true end 
	if z.RealPart==0 and z.ComplexPart==0 then return multiplicity and table.create(3,CTNOrigin)or{CTNOrigin}end
	local r,theta=mathantics.topolarform(z)local T={}for k=0,2 do T[k+1]=formula1(r,3,k,theta)end return T 
end
--Returns the nth root of a CTN (n must be an integer)
function mathantics.complexnthroot(z:CTN,n:number,multiplicity:boolean?):({CTN})
	if type(multiplicity)~="boolean"then multiplicity=true end
	if z.RealPart==0 and z.ComplexPart==0 then return multiplicity and table.create(n,CTNOrigin)or{CTNOrigin}end 
	local r,theta=mathantics.topolarform(z)local T={}for k=0,n-1 do T[k+1]=formula1(r,n,k,theta)end return T
end
-- Adds a CTN to an another CTN
function mathantics.complexadd(c1:CTN,c2:CTN):(CTN)return{RealPart=c1.RealPart+c2.RealPart,ComplexPart=c1.ComplexPart+c2.ComplexPart}end
-- Subtracts a CTN from an another CTN
function mathantics.complexsub(c1:CTN,c2:CTN):(CTN)return{RealPart=c1.RealPart-c2.RealPart,ComplexPart=c1.ComplexPart-c2.ComplexPart}end
-- Multiplies a CTN to an another CTN
function mathantics.complexmult(c1:CTN,c2:CTN):(CTN)
	return{RealPart=c1.RealPart*c2.RealPart-c1.ComplexPart*c2.ComplexPart,ComplexPart=c1.RealPart*c2.ComplexPart+c1.ComplexPart*c2.RealPart}
end
-- Divides a CTN by an another CTN
function mathantics.complexdiv(c1:CTN,c2:CTN):(CTN)
	return mathantics.complexscale(mathantics.complexmult(c1,mathantics.conjugate(c2)),1/(c2.RealPart^2+c2.ComplexPart^2))
end
--Given a list of CTNs, it will convert to real solutions (Will exclude Complex numbers b~=0)
function mathantics.complextoreal(solutions:{CTN}):({number})
	local newsolutions={}for _,solution in ipairs(solutions)do
		if solution.ComplexPart~=0 then continue end table.insert(newsolutions,solution.RealPart)
	end return newsolutions end
--Checks if this CTN has a complex part not equal to 0 :3
function mathantics.iscomplex(z:CTN):(boolean)
	return z.ComplexPart~=0
end
--Given a list of CTNs, it will convert to a+bi string If b=0 then it will be a stringed number
function mathantics.complextostring(solutions:{CTN},precision:number?):{string}
	precision=precision or 5 local newsolutions={}for i,solution in ipairs(solutions)do
		local newnum=rounding(solution.RealPart,precision)if not mathantics.iscomplex(solution)then newsolutions[i]=newnum continue end
		newsolutions[i]=newnum..(math.sign(solution.ComplexPart)>0 and "+" or "-")..(rounding(math.abs(solution.ComplexPart),precision)).."i"
	end return newsolutions
end
--Compares if 2 CTNs are the same value :3
function mathantics.CTNeq(z1:CTN,z2:CTN):(boolean)
	return (z1.RealPart==z2.RealPart)and(z1.ComplexPart==z2.ComplexPart)
end

local function helper(roots)
	local tocancel={}for i,z:CTN in ipairs(roots)do roots[i]=mathantics.beautifycomplex(z)
		local index=table.find(tocancel,z.RealPart)if type(index)=="number"and (not mathantics.iscomplex(z)) then roots[i]=nil continue end roots[i]=z tocancel[i]=z.RealPart
	end return roots
end
--Solves the roots of any polynomial up to a quartic in closed form. a is the 4th degree coefficient, b is the 3rd degree coefficient, c is the 2nd degree coefficient, d is the 1st degree coefficient, and e is the 0th degree coefficient
function mathantics.solvepolynomialequation(a:number,b:number,c:number,d:number,e:number):({CTN})
	if a==0 then
		if b==0 then if c==0 then if d==0 then return{}end return{mathantics.convtoz(-e/d)}else
				local l=-d/(2*c)local D=d^2-4*c*e if D==0 then return{mathantics.convtoz(l)}else
					local nD=math.sqrt(math.abs(D))/(2*c)if D<0 then
						return{mathantics.CTNnew(l,nD),mathantics.CTNnew(l,-nD)}
					else return{mathantics.convtoz(l+nD),mathantics.convtoz(l-nD)}end
				end
			end else local p=-c/(3*b)local u=27*b^2*e if c^2==3*b*d and c^3==u then return{mathantics.convtoz(p)}end
			local q,k=2*c^3-9*b*c*d+u,c^2-3*b*d local Q=q^2-4*k^3 k=mathantics.convtoz(k)
			local C=mathantics.complexcbrt(mathantics.complexscale(mathantics.complexadd(mathantics.sqrttoz(Q),mathantics.convtoz(q)),0.5))
			local roots,tocancel={},{}for _,z in ipairs(C)do 
				local S=mathantics.complexsub(mathantics.convtoz(p),mathantics.complexadd(mathantics.complexscale(z,1/(3*b)),mathantics.complexdiv(k,mathantics.complexscale(z,3*b))))
				S=mathantics.beautifycomplex(S)if not mathantics.iscomplex(S) then if type(table.find(tocancel,S.RealPart))=="number"then continue end table.insert(tocancel,S.RealPart)end table.insert(roots,S)
			end return roots
		end
	else local q3=8*a*c local q0,q1,q2=16*a^2*d,256*a^3*e,q3-3*b^2 local P=mathantics.convtoz(-b/(4*a))if q2==0 and q0==b^3 and q1==b^4 then return{P}end
		local p,q,r=q2/(8*a^2),(2*b^3-q3*b+q0)/(16*a^3),(b^2*(2*q3-3*b^2)-4*q0*b+q1)/(256*a^4)
		local lambda=mathantics.complextoreal(mathantics.solvepolynomialequation(0,1,p,p^2/4-r,-q^2/8))[1]
		local B,Ca=mathantics.sqrttoz(2*lambda),mathantics.convtoz(lambda+p/2)
		if mathantics.CTNeq(B,CTNOrigin) then local D=mathantics.complexsqrt(mathantics.complexsub(mathantics.complexsquared(Ca),mathantics.convtoz(r)))
			local Cm=mathantics.flip(Ca)local roots={}
			local delta1=mathantics.complexsqrt(mathantics.complexadd(Cm,D[1]))
			local delta2=mathantics.complexsqrt(mathantics.complexadd(Cm,D[2]))
			roots[1]=delta1[1]roots[2]=delta1[2]roots[3]=delta2[1]roots[4]=delta2[2]
			for i,v in ipairs(roots)do roots[i]=mathantics.complexadd(P,v)end return helper(roots)
		end
		local Bn,Cb=mathantics.flip(B),mathantics.complexdiv(mathantics.convtoz(q),mathantics.complexscale(B,2))
		local B2=mathantics.complexsquared(B)local delta1=mathantics.complexsqrt(mathantics.complexsub(B2,mathantics.complexscale(mathantics.complexsub(Ca,Cb),4)))
		local delta2=mathantics.complexsqrt(mathantics.complexsub(B2,mathantics.complexscale(mathantics.complexadd(Ca,Cb),4)))local roots={}
		local D3,D4=mathantics.beautifycomplex(delta1[1]),mathantics.beautifycomplex(delta2[1])		
		if mathantics.CTNeq(D3,CTNOrigin)then roots[1]=mathantics.complexadd(mathantics.complexscale(Bn,0.5),P)else
			roots[1]=mathantics.complexadd(mathantics.complexscale(mathantics.complexadd(Bn,delta1[1]),0.5),P)
			roots[2]=mathantics.complexadd(mathantics.complexscale(mathantics.complexadd(Bn,delta1[2]),0.5),P)
		end if mathantics.CTNeq(D4,CTNOrigin) then table.insert(roots,mathantics.complexadd(mathantics.complexscale(B,0.5),P))else
			table.insert(roots,mathantics.complexadd(mathantics.complexscale(mathantics.complexadd(B,delta2[1]),0.5),P))
			table.insert(roots,mathantics.complexadd(mathantics.complexscale(mathantics.complexadd(B,delta2[2]),0.5),P))
		end return helper(roots)
	end
end

local derivcache,arbitcache={},{} --optimized
local function fetchDerivat1(Arbitrary,AD,isetn)
	local cached=derivcache[Arbitrary]if cached then
		local flag=false for _,k in ipairs(AD)do
			if not cached[k]then flag=true break end
		end
		if flag then 
			cached=mathantics.Derivative(Arbitrary,1,AD,isetn)
			derivcache[Arbitrary]=cached
		end
	else
		cached=mathantics.Derivative(Arbitrary,1,AD,isetn)
		derivcache[Arbitrary]=cached
	end return cached
end
local function arbitrary1(Arbitrary)
	local cached=arbitcache[Arbitrary]if cached then
		return cached
	else
		cached=Arbitrary(1)arbitcache[Arbitrary]=cached return cached
	end
end
local AD_CACHE={}
local function getAD(k)
	if not AD_CACHE[k] then
		local AD={}
		for i=1,2*k-1,2 do table.insert(AD,i)end
		AD_CACHE[k]=AD 
		return AD
	end
	return AD_CACHE[k]
end
local B_OVER_FACT = {}  -- Module level
local function getBOverFact(i)
	local cached=B_OVER_FACT[i]
	if not cached then
		cached=ETN.div(
			mathantics.B(i,false),
			mathantics.etnfactorial(i)
		)
		B_OVER_FACT[i]=cached return cached
	end
	return cached
end
--Calculates the sum of any function  (∑ [n=1 → k] F(n)), (Use only if the function is not in any recognizable closed form summation, this will be slightly slower then the other O(1) summation calculators) <Accepts ETN>
function mathantics.ArbitraryTotalCost(Arbitrary:(FlexNum)->(FlexNum),n:number,isetn:boolean?,k:number?,remainderterm:boolean?,usecrude:boolean?):(FlexNum)
	if type(usecrude)=="nil"then usecrude=true end
	local integrateFx=usecrude and mathantics.Integrate or mathantics.Integrate2
	if type(remainderterm)=="nil"then remainderterm=false end
	if type(isetn)=="nil"then isetn=false end k=k or 3
	if n==0 then return isetn and ETNZero or 0 end
	if n<=1 then return mathantics.KahanSum(Arbitrary,n,isetn,false)else
		local AD=getAD(k)
		local allDeriv={[n]=mathantics.Derivative(Arbitrary,n,AD,isetn),[1]=fetchDerivat1(Arbitrary,AD,isetn)}
		if isetn then
			local preaccumulated,accumulated=ETN.add(
				integrateFx(Arbitrary,1,n,true,20),
				ETN.mul(
					0.5,
					ETN.add(
						arbitrary1(Arbitrary),
						Arbitrary(n)
					)
				)
			),ETNZero
			for i=2,2*k,2 do
				accumulated=ETN.add(accumulated,ETN.mul(
					getBOverFact(i),
					ETN.sub(
						allDeriv[n][i-1],allDeriv[1][i-1]
					)
					))
			end
			if remainderterm then --coming soon :3
				--preaccumulated=ETN.add(preaccumulated,0)
			end
			return ETN.add(preaccumulated,accumulated)
		else
			local preaccumulated,accumulated=0.5*(Arbitrary(n)+arbitrary1(Arbitrary))+
				integrateFx(Arbitrary,1,n,false,20),0
			for i=2,2*k,2 do
				accumulated+=mathantics.B(i)*(allDeriv[n][i-1]-allDeriv[1][i-1])/mathantics.factorial(i)
			end
			if remainderterm then --coming soon :3
				--preaccumulated+=0
			end
			return preaccumulated+accumulated
		end
	end
end

local exposubscripts={
	["0"]="⁰",
	["1"]="¹",
	["2"]="²",
	["3"]="³",
	["4"]="⁴",
	["5"]="⁵",
	["6"]="⁶",
	["7"]="⁷",
	["8"]="⁸",
	["9"]="⁹",
	["-"]="⁻",
}
--Given a number, it will convert to a superscripted exponent notation
function mathantics.formatexponent(exponent:number):(string)
	exponent=math.round(exponent)
	local list,formatted=string.split(tostring(exponent),""),""
	for _,v in ipairs(list)do formatted..=exposubscripts[v]end return formatted
end

local MAX_SAFE_INTEGER = 2^53 -- 9,007,199,254,740,992
local MIN_SAFE_INTEGER = -2^53
--Returns true if the Number is a safe integer otherwise its a float.
function mathantics.CheckNumberType(x:number):(boolean)
	if math.floor(x)~=x then return false end
	if x>MAX_SAFE_INTEGER or x<MIN_SAFE_INTEGER then
		return false
	end return true
end

return mathantics

--[[
Mozilla Public License
Version 2.0
1. Definitions

1.1. “Contributor”

    means each individual or legal entity that creates, contributes to the creation of, or owns Covered Software.
1.2. “Contributor Version”

    means the combination of the Contributions of others (if any) used by a Contributor and that particular Contributor’s Contribution.
1.3. “Contribution”

    means Covered Software of a particular Contributor.
1.4. “Covered Software”

    means Source Code Form to which the initial Contributor has attached the notice in Exhibit A, the Executable Form of such Source Code Form, and Modifications of such Source Code Form, in each case including portions thereof.
1.5. “Incompatible With Secondary Licenses”

    means

        that the initial Contributor has attached the notice described in Exhibit B to the Covered Software; or

        that the Covered Software was made available under the terms of version 1.1 or earlier of the License, but not also under the terms of a Secondary License.

1.6. “Executable Form”

    means any form of the work other than Source Code Form.
1.7. “Larger Work”

    means a work that combines Covered Software with other material, in a separate file or files, that is not Covered Software.
1.8. “License”

    means this document.
1.9. “Licensable”

    means having the right to grant, to the maximum extent possible, whether at the time of the initial grant or subsequently, any and all of the rights conveyed by this License.
1.10. “Modifications”

    means any of the following:

        any file in Source Code Form that results from an addition to, deletion from, or modification of the contents of Covered Software; or

        any new file in Source Code Form that contains any Covered Software.

1.11. “Patent Claims” of a Contributor

    means any patent claim(s), including without limitation, method, process, and apparatus claims, in any patent Licensable by such Contributor that would be infringed, but for the grant of the License, by the making, using, selling, offering for sale, having made, import, or transfer of either its Contributions or its Contributor Version.
1.12. “Secondary License”

    means either the GNU General Public License, Version 2.0, the GNU Lesser General Public License, Version 2.1, the GNU Affero General Public License, Version 3.0, or any later versions of those licenses.
1.13. “Source Code Form”

    means the form of the work preferred for making modifications.
1.14. “You” (or “Your”)

    means an individual or a legal entity exercising rights under this License. For legal entities, “You” includes any entity that controls, is controlled by, or is under common control with You. For purposes of this definition, “control” means (a) the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or (b) ownership of more than fifty percent (50%) of the outstanding shares or beneficial ownership of such entity.

2. License Grants and Conditions
2.1. Grants

Each Contributor hereby grants You a world-wide, royalty-free, non-exclusive license:

    under intellectual property rights (other than patent or trademark) Licensable by such Contributor to use, reproduce, make available, modify, display, perform, distribute, and otherwise exploit its Contributions, either on an unmodified basis, with Modifications, or as part of a Larger Work; and

    under Patent Claims of such Contributor to make, use, sell, offer for sale, have made, import, and otherwise transfer either its Contributions or its Contributor Version.

2.2. Effective Date

The licenses granted in Section 2.1 with respect to any Contribution become effective for each Contribution on the date the Contributor first distributes such Contribution.
2.3. Limitations on Grant Scope

The licenses granted in this Section 2 are the only rights granted under this License. No additional rights or licenses will be implied from the distribution or licensing of Covered Software under this License. Notwithstanding Section 2.1(b) above, no patent license is granted by a Contributor:

    for any code that a Contributor has removed from Covered Software; or

    for infringements caused by: (i) Your and any other third party’s modifications of Covered Software, or (ii) the combination of its Contributions with other software (except as part of its Contributor Version); or

    under Patent Claims infringed by Covered Software in the absence of its Contributions.

This License does not grant any rights in the trademarks, service marks, or logos of any Contributor (except as may be necessary to comply with the notice requirements in Section 3.4).
2.4. Subsequent Licenses

No Contributor makes additional grants as a result of Your choice to distribute the Covered Software under a subsequent version of this License (see Section 10.2) or under the terms of a Secondary License (if permitted under the terms of Section 3.3).
2.5. Representation

Each Contributor represents that the Contributor believes its Contributions are its original creation(s) or it has sufficient rights to grant the rights to its Contributions conveyed by this License.
2.6. Fair Use

This License is not intended to limit any rights You have under applicable copyright doctrines of fair use, fair dealing, or other equivalents.
2.7. Conditions

Sections 3.1, 3.2, 3.3, and 3.4 are conditions of the licenses granted in Section 2.1.
3. Responsibilities
3.1. Distribution of Source Form

All distribution of Covered Software in Source Code Form, including any Modifications that You create or to which You contribute, must be under the terms of this License. You must inform recipients that the Source Code Form of the Covered Software is governed by the terms of this License, and how they can obtain a copy of this License. You may not attempt to alter or restrict the recipients’ rights in the Source Code Form.
3.2. Distribution of Executable Form

If You distribute Covered Software in Executable Form then:

    such Covered Software must also be made available in Source Code Form, as described in Section 3.1, and You must inform recipients of the Executable Form how they can obtain a copy of such Source Code Form by reasonable means in a timely manner, at a charge no more than the cost of distribution to the recipient; and

    You may distribute such Executable Form under the terms of this License, or sublicense it under different terms, provided that the license for the Executable Form does not attempt to limit or alter the recipients’ rights in the Source Code Form under this License.

3.3. Distribution of a Larger Work

You may create and distribute a Larger Work under terms of Your choice, provided that You also comply with the requirements of this License for the Covered Software. If the Larger Work is a combination of Covered Software with a work governed by one or more Secondary Licenses, and the Covered Software is not Incompatible With Secondary Licenses, this License permits You to additionally distribute such Covered Software under the terms of such Secondary License(s), so that the recipient of the Larger Work may, at their option, further distribute the Covered Software under the terms of either this License or such Secondary License(s).
3.4. Notices

You may not remove or alter the substance of any license notices (including copyright notices, patent notices, disclaimers of warranty, or limitations of liability) contained within the Source Code Form of the Covered Software, except that You may alter any license notices to the extent required to remedy known factual inaccuracies.
3.5. Application of Additional Terms

You may choose to offer, and to charge a fee for, warranty, support, indemnity or liability obligations to one or more recipients of Covered Software. However, You may do so only on Your own behalf, and not on behalf of any Contributor. You must make it absolutely clear that any such warranty, support, indemnity, or liability obligation is offered by You alone, and You hereby agree to indemnify every Contributor for any liability incurred by such Contributor as a result of warranty, support, indemnity or liability terms You offer. You may include additional disclaimers of warranty and limitations of liability specific to any jurisdiction.
4. Inability to Comply Due to Statute or Regulation

If it is impossible for You to comply with any of the terms of this License with respect to some or all of the Covered Software due to statute, judicial order, or regulation then You must: (a) comply with the terms of this License to the maximum extent possible; and (b) describe the limitations and the code they affect. Such description must be placed in a text file included with all distributions of the Covered Software under this License. Except to the extent prohibited by statute or regulation, such description must be sufficiently detailed for a recipient of ordinary skill to be able to understand it.
5. Termination

5.1. The rights granted under this License will terminate automatically if You fail to comply with any of its terms. However, if You become compliant, then the rights granted under this License from a particular Contributor are reinstated (a) provisionally, unless and until such Contributor explicitly and finally terminates Your grants, and (b) on an ongoing basis, if such Contributor fails to notify You of the non-compliance by some reasonable means prior to 60 days after You have come back into compliance. Moreover, Your grants from a particular Contributor are reinstated on an ongoing basis if such Contributor notifies You of the non-compliance by some reasonable means, this is the first time You have received notice of non-compliance with this License from such Contributor, and You become compliant prior to 30 days after Your receipt of the notice.

5.2. If You initiate litigation against any entity by asserting a patent infringement claim (excluding declaratory judgment actions, counter-claims, and cross-claims) alleging that a Contributor Version directly or indirectly infringes any patent, then the rights granted to You by any and all Contributors for the Covered Software under Section 2.1 of this License shall terminate.

5.3. In the event of termination under Sections 5.1 or 5.2 above, all end user license agreements (excluding distributors and resellers) which have been validly granted by You or Your distributors under this License prior to termination shall survive termination.
6. Disclaimer of Warranty

Covered Software is provided under this License on an “as is” basis, without warranty of any kind, either expressed, implied, or statutory, including, without limitation, warranties that the Covered Software is free of defects, merchantable, fit for a particular purpose or non-infringing. The entire risk as to the quality and performance of the Covered Software is with You. Should any Covered Software prove defective in any respect, You (not any Contributor) assume the cost of any necessary servicing, repair, or correction. This disclaimer of warranty constitutes an essential part of this License. No use of any Covered Software is authorized under this License except under this disclaimer.
7. Limitation of Liability

Under no circumstances and under no legal theory, whether tort (including negligence), contract, or otherwise, shall any Contributor, or anyone who distributes Covered Software as permitted above, be liable to You for any direct, indirect, special, incidental, or consequential damages of any character including, without limitation, damages for lost profits, loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses, even if such party shall have been informed of the possibility of such damages. This limitation of liability shall not apply to liability for death or personal injury resulting from such party’s negligence to the extent applicable law prohibits such limitation. Some jurisdictions do not allow the exclusion or limitation of incidental or consequential damages, so this exclusion and limitation may not apply to You.
8. Litigation

Any litigation relating to this License may be brought only in the courts of a jurisdiction where the defendant maintains its principal place of business and such litigation shall be governed by laws of that jurisdiction, without reference to its conflict-of-law provisions. Nothing in this Section shall prevent a party’s ability to bring cross-claims or counter-claims.
9. Miscellaneous

This License represents the complete agreement concerning the subject matter hereof. If any provision of this License is held to be unenforceable, such provision shall be reformed only to the extent necessary to make it enforceable. Any law or regulation which provides that the language of a contract shall be construed against the drafter shall not be used to construe this License against a Contributor.
10. Versions of the License
10.1. New Versions

Mozilla Foundation is the license steward. Except as provided in Section 10.3, no one other than the license steward has the right to modify or publish new versions of this License. Each version will be given a distinguishing version number.
10.2. Effect of New Versions

You may distribute the Covered Software under the terms of the version of the License under which You originally received the Covered Software, or under the terms of any subsequent version published by the license steward.
10.3. Modified Versions

If you create software not governed by this License, and you want to create a new license for such software, you may create and use a modified version of this License if you rename the license and remove any references to the name of the license steward (except to note that such modified license differs from this License).
10.4. Distributing Source Code Form that is Incompatible With Secondary Licenses

If You choose to distribute Source Code Form that is Incompatible With Secondary Licenses under the terms of this version of the License, the notice described in Exhibit B of this License must be attached.
Exhibit A - Source Code Form License Notice

    This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.

If it is not possible or desirable to put the notice in a particular file, then You may include the notice in a location (such as a LICENSE file in a relevant directory) where a recipient would be likely to look for such a notice.

You may add additional accurate notices of copyright ownership.
Exhibit B - “Incompatible With Secondary Licenses” Notice

    This Source Code Form is “Incompatible With Secondary Licenses”, as defined by the Mozilla Public License, v. 2.0.

]]
