--!optimize 2
--!native

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
	• Used in high scale commerical roblox games.
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

--// Start of NewEternityNum
----------------------------------------------------------------------------------------------------------------
local pi=math.pi
local tau=2*pi
local e=math.e
local INFINITY=math.huge
local nan=0/0
local ln:(v:number)->(number)=math.log
local log10:(v:number)->(number)=math.log10
local pow10:(v:number)->(number)=function(v)return 10^v end
local floor:(v:number)->(number)=math.floor
local abs:(v:number)->(number)=math.abs
local LOG10_E = 0.4342944819032518
local LN10 = 2.302585092994046
local FLOAT_INT_LIMIT = 9007199254740992
local FLOAT_HALF_INT_LIMIT = 4503599627370495.5
local POW10_EPSILON = 4.821736528239456e-17
local MACHINE_EPSILON = 2.220446049250313e-16
local MACHINE_EPSILON_HALF = 1.1102230246251565e-16

local MAX_LUA_FLOAT=1.7976931348623157e308
local MIN_LUA_FLOAT=2.2250738585072014e-308
local LOG10_MAX = 308.254715559916718   -- Above this, pow10 → INFINITY
local LOG10_MIN = 307.652655568588755  -- Below this, pow10 → 0
local DigitLimit=300

local MIAMIS_NUMBER=-16.31680545889046562
local LUMIS_NUMBER=-16.617835454554445
local DADES_NUMBER=log10(DigitLimit)
local DRACULAURAS_NUMBER=-16.255619765854984
local TWYLAS_NUMBER=-15.954589770191003
local CLAWDEENS_NUMBER=4.8216373327664367e-17
local CLEO_DENILES_NUMBER=-2.4108186663832186e-17
local MAX_LAYER=2

export type ETN = {Sign:boolean,Layer:number,Val1:number,Val2:number}
export type FlexNum = number|ETN
type BigNum={number}
type EN={Sign:number,Layer:number,Exp:number}
local nETN = {}

--Creates an ETN without corrections.
function nETN.RawNew(Sign:boolean,Layer:number,Value:number,Sigfigs:number?):ETN
	Sigfigs=Sigfigs or 0 
	return{Sign=Sign,Layer=Layer,Val1=Value,Val2=Sigfigs}
end

local ZERO = nETN.RawNew(true,0,0)
local ONE = nETN.RawNew(true,0,1)
local MinusONE = nETN.RawNew(false,0,1)
local NaN = nETN.RawNew(true,-1,1)
local Inf = nETN.RawNew(true,-2,1)
local MinusInf = nETN.RawNew(false,-2,1)
local TEN,MinusTEN=nETN.RawNew(true,0,10,0),nETN.RawNew(false,0,10,0)

local readonly=table.freeze
readonly(ZERO)
readonly(ONE)
readonly(MinusONE)
readonly(NaN)
readonly(Inf)
readonly(MinusInf)
readonly(TEN)
readonly(MinusTEN)

nETN.Zero=ZERO
nETN.One=ONE
nETN.MinusOne=MinusONE
nETN.NaN=NaN
nETN.Inf=Inf
nETN.MinusInf=MinusInf
nETN.Ten=TEN
nETN.MinusTen=MinusTEN

--Checks if a FlexNum is NaN
function nETN.IsNaN(Value:FlexNum):boolean
	if type(Value)=="number"then return Value~=Value end
	return Value.Layer==-1 
end

--Checks if a FlexNum is Infinity
function nETN.IsInf(Value:FlexNum):boolean
	if type(Value)=="number"then return math.isinf(Value) end local Layer=Value.Layer
	local val1=Value.Val1 return Layer==-2 or val1==INFINITY
end

--Checks if a FlexNum is Zero
function nETN.IsZero(Value:FlexNum):boolean
	if type(Value)=="number"then return Value==0 end
	local Layer=Value.Layer
	if Layer==0 then
		return Value.Val1==0 and Value.Val2==0
	elseif Layer>=1 then
		return Value.Val1==-INFINITY
	else return false end
end

--Checks if a FlexNum is an integer
function nETN.IsInteger(Value:FlexNum):boolean
	if type(Value)=="number"then return Value==floor(Value)end
	local Layer=Value.Layer
	if Layer>=2 then return true end
	if Layer==0 then
		return Value.Val2==0
	elseif Layer==1 then
		if Value.Val1==-INFINITY then return true end
		return Value.Val1>16
	else return false end
end

local MIN_ABSOLUTE_RANGE=pow10(-DigitLimit)
local MAX_ABSOLUTE_RANGE=pow10(DigitLimit)

local function NUMBERRANGE(x)return x<=MIN_ABSOLUTE_RANGE or x>=MAX_ABSOLUTE_RANGE end
local function MAGRANGE(M)return M>-DigitLimit and M<DigitLimit end
local function MAGRANGEABS(M)return M<DigitLimit end
local function MAGRANGEABS2(M)return M>=MAX_ABSOLUTE_RANGE end
local function LOGRANGE_A(L)return L<=-MAX_ABSOLUTE_RANGE end
local function LOGRANGE_B(L)return L>=MAX_ABSOLUTE_RANGE end

--Legacy EN.new Function UPDATED :D [Use this to create Layer 2 numbers 10e(10e309+)]
--Creates an ETN with corrections. (Use nETN.Create for accurate values 10e(10e14) and above!)
function nETN.new(Sign:boolean|number,Layer:number,Value:number):ETN
	if type(Sign)=="number"then Sign=Sign>=0 end
	if Layer<-2 or Layer>MAX_LAYER then Layer=0 end
	if Layer==-2 then
		return Sign and Inf or MinusInf
	elseif Layer==-1 then
		return NaN
	end
	if Layer==0 then
		if Value==0 then return ZERO end
		if Value<0 then Value=-Value Sign=not Sign end
		if Value==INFINITY then return Sign and Inf or MinusInf end
		
		if NUMBERRANGE(Value)then
			local logvalue=log10(Value)
			local flooredLog=floor(logvalue)
			return nETN.RawNew(Sign,1,flooredLog,logvalue-flooredLog)
		end
		local flooredint=floor(Value)
		return nETN.RawNew(Sign,0,flooredint,Value-flooredint)
	elseif Layer==1 then
		if Value==0 then return Sign and ONE or MinusONE end
		if Value==INFINITY then return Sign and Inf or MinusInf end
		if Value==-INFINITY then return ZERO end
		
		if MAGRANGE(Value)then
			local powvalue=pow10(Value)
			local flooredint=floor(powvalue)
			return nETN.RawNew(Sign,0,flooredint,powvalue-flooredint)
		end
		local flooredLog=floor(Value)
		if MAGRANGEABS2(flooredLog) then
			local Dlog=log10(flooredLog)
			local flooredDlog=floor(Dlog)
			return nETN.RawNew(Sign,2,flooredDlog,Dlog-flooredDlog)
		end
		return nETN.RawNew(Sign,1,flooredLog,Value-flooredLog)
	else
		if Value==INFINITY then return Sign and Inf or MinusInf end
		if Value<MIAMIS_NUMBER then return Sign and ONE or MinusONE end
		local val22=Value Value=pow10(Value)if Value<DigitLimit then
			local powpow10=pow10(Value)
			local flooredpp10=floor(powpow10)
			return nETN.RawNew(Sign,0,flooredpp10,powpow10-flooredpp10)
		end
		if Value<MAX_ABSOLUTE_RANGE then
			local floored=floor(Value)
			return nETN.RawNew(Sign,1,floored,Value-floored)
		end local floored=floor(val22)
		return nETN.RawNew(Sign,2,floored,val22-floored)
	end
end

--Creates an ETN with a Mantissa and Magnitude (Magnitude should be an integer) [Layer 2 numbers USE nETN.new]
function nETN.Create(Sign:boolean,Mantissa:number,Magnitude:number):ETN
	if Mantissa==0 then return ZERO end
	if Mantissa<0 then Mantissa=-Mantissa Sign=not Sign end
	if Mantissa==INFINITY and Magnitude==-INFINITY then return NaN end
	if Magnitude==INFINITY or Mantissa==INFINITY then return Sign and Inf or MinusInf end
	if Magnitude==-INFINITY then return ZERO end

	Magnitude=floor(Magnitude)
	local logmantissa=log10(Mantissa)
	local added=floor(logmantissa)

	local madded=Magnitude+added
	if math.isinf(madded)then return madded<0 and MinusInf or Inf end
	
	if MAGRANGEABS2(madded)then
		local doublelog=log10(madded)
		local flooredDlog=floor(doublelog)
		return nETN.RawNew(Sign,2,flooredDlog,doublelog-flooredDlog)
	end
	if MAGRANGE(madded) then
		local MtimesMag=Mantissa*pow10(Magnitude)
		local flooredMtimesMag=floor(MtimesMag)
		return nETN.RawNew(Sign,0,flooredMtimesMag,MtimesMag-flooredMtimesMag)
	else
		return nETN.RawNew(Sign,1,madded,logmantissa-added)
	end
end

--Converts a Luau float (IEEE 754) to ETN
function nETN.fromNumber(Value:number):ETN
	if Value~=Value then return NaN end
	if Value==0 then return ZERO end
	local magnitude,sign=abs(Value),Value>=0
	if magnitude==INFINITY then return sign and Inf or MinusInf end
	if NUMBERRANGE(magnitude) then
		local logvalue=log10(magnitude)
		local flooredLog=floor(logvalue)
		return nETN.RawNew(sign,1,flooredLog,logvalue-flooredLog)
	else
		local flooredint=floor(magnitude)
		return nETN.RawNew(sign,0,flooredint,magnitude-flooredint)
	end
end

--Converts a string (in the form of XeY) to ETN
function nETN.fromScientific(Value:string):ETN
	local slice = string.split(Value,"e")
	local Mantissa,Magnitude = tonumber(slice[1]),tonumber(slice[2])
	if Mantissa==nil or Magnitude==nil then return NaN end
	return nETN.Create(true,Mantissa,Magnitude)
end

--Converts a string (in the form of nETN's S;L;V1;V2 OR V) to ETN
--WE DO NOT ACCEPT EN (L;V) [USE nETN.fromENString]]
function nETN.fromString(Value:string):ETN
	if Value=="NaN" or Value=="nan" then return NaN end
	if Value=="Inf" or Value=="inf" then return Inf end
	if Value=="-Inf" or Value=="-inf" then return MinusInf end
	if Value=="0" then return ZERO end
	if Value=="" then return ZERO end
	
	local N=tonumber(Value)if N then
		if math.isinf(N)or (N==0 and string.find(Value,"e")) then return nETN.fromScientific(Value)end
		return nETN.fromNumber(N)
	end if not string.find(Value,";")then return NaN end
	local slice = string.split(Value,";")
	local Sign,Layer,Val1,Val2=tonumber(slice[1]),tonumber(slice[2]),tonumber(slice[3]),tonumber(slice[4])
	if Sign==nil or Layer==nil or Val1==nil or Val2==nil then return NaN end
	return nETN.RawNew(Sign==1,Layer,Val1,Val2)
end

--Converts an EN to an ETN
function nETN.fromEN(Sign:number,Layers:number,Exp:number):ETN
	Sign=Sign>=0 
	if Layers>3 then --Information Loss here (EN numbers with Layer 3 and above break down anyways)
		return Sign and Inf or MinusInf
	elseif Layers==3 then 
		Exp=pow10(Exp)if Exp==0 then return Sign and ONE or MinusONE end
		if Exp==INFINITY then return Sign and Inf or MinusInf end
		Layers=2
	end
	return nETN.new(Sign,Layers,Exp)
end
--Converts a string from the legacy EN format (L;V) to ETN
function nETN.fromENString(Value:string):ETN
	if Value=="NaN" or Value=="nan" then return NaN end
	if Value=="Inf" or Value=="inf" then return Inf end
	if Value=="-Inf" or Value=="-inf" then return MinusInf end
	if Value=="0" then return ZERO end
	if Value=="" then return ZERO end

	local N=tonumber(Value)if N then
		if math.isinf(N)or (N==0 and string.find(Value,"e")) then return nETN.fromScientific(Value)end
		return nETN.fromNumber(N)
	end if not string.find(Value,";")then return NaN end
	local slice=string.split(Value,";")
	local Layers,Exp=tonumber(slice[1]),tonumber(slice[2])
	if Layers==nil or Exp==nil then return NaN end 
	return nETN.fromEN(Layers,abs(Layers),Exp)
end

--Converts an ETN to a string (in the form of nETN's S;L;V1;V2)
function nETN.toString(Value:ETN):string
	local Layer=Value.Layer
	if nETN.IsNaN(Value) then return "NaN" end
	if nETN.IsInf(Value) then return Value.Sign and "Inf" or "-Inf" end
	if nETN.IsZero(Value) then return "0" end
	local val1,val2=Value.Val1,Value.Val2
	if val2==0 then val2=0 end
	return (Value.Sign and "1" or "0")..";"..Layer..";"..val1..";"..val2
end

--Converts an ETN to a string (in the form of nETN's S;L;V1;V2) [More safer]
function nETN.toStringDefensive(Value:ETN):string
	if type(Value) ~= "table" then return "NaN" end
	if nETN.IsNaN(Value) then return "NaN" end
	if nETN.IsZero(Value) then return "0" end
	if nETN.IsInf(Value) then return Value.Sign and "Inf" or "-Inf" end

	local Sign=Value.Sign and 1 or 0
	local Layer=Value.Layer or 0
	local Val1 = Value.Val1 or 0
	local Val2 = Value.Val2 or 1

	if Val2==0 then Val2=0 end
	return Sign..";"..Layer..";"..Val1..";"..Val2
end

--Converts an ETN to a Luau number (IEEE 754)
function nETN.toNumber(Value:ETN):number
	local Layer,val1,Sign,val2=Value.Layer,Value.Val1,Value.Sign,Value.Val2
	local signMul=Sign and 1 or -1
	if Layer>=2 then return Sign and INFINITY or -INFINITY end
	if Layer==1 then
		local logval=val1+val2
		if logval>LOG10_MAX then return signMul*INFINITY end
		if logval<-LOG10_MIN then return 0 end
		return signMul*pow10(logval)
	elseif Layer==0 then
		if val1==0 and val2==0 then return 0 end
		return (val1+val2)*signMul
	elseif Layer==-2 then
		return signMul*INFINITY
	else return nan end
end

--Converts any valid input to an ETN
--VALID INPUTS: number, ETN strings, EN strings, Scientific Notation, BigNum Values (From deprecated BigNum Lib) and EN Values (From deprecated EternityNum lib)
type ValidInput=number|string|BigNum|EN|ETN
function nETN.convert(Input:ValidInput):ETN
	local typ=type(Input)
	if typ=="table"then
		if Input.Val2~=nil then return Input end --Fast Fallback for valid ETNs
		if #Input==2 then local i1=Input[1]
			if i1==0 then return ZERO end
			return nETN.new(i1,1,Input[2])
		end --BigNum support
		local exp=Input.Exp if exp~=nil then --People are still using Eternitynum so adding support for it
			return nETN.fromEN(Input.Sign,Input.Layer,exp)
		end return NaN
	end
	if typ=="number" then return nETN.fromNumber(Input)end
	if typ=="string" then
		local result=nETN.fromString(Input)
		if not nETN.IsNaN(result)then
			return result
		elseif string.find(Input,";")then
			return nETN.fromENString(Input)
		end
	end
	return NaN
end

--Compares absolute values of two ETNs.
--1==a is bigger, -1==b is bigger,0==a and b are equal
function nETN.cmpAbs(a:ETN,b:ETN):number
	local aLayer,bLayer=a.Layer,b.Layer local beq2=bLayer==-2
	if aLayer==-2 then return beq2 and 0 or 1 end
	if beq2 then return -1 end 
	local aVal1,bVal1=a.Val1,b.Val1 if aLayer==bLayer then
		if aVal1~=bVal1 then return aVal1>bVal1 and 1 or -1 end
		if aLayer==-1 then return 0 end
		local aVal2,bVal2=a.Val2,b.Val2
		if aVal2~=bVal2 then return aVal2>bVal2 and 1 or -1 end
		return 0
	end
	if aLayer>bLayer then return a.Val1<0 and -1 or 1 end
	return b.Val1<0 and 1 or -1
end

--Compares values of two ETNs.
--1==a is bigger, -1==b is bigger,0==a and b are equal
function nETN.cmp(a:ETN,b:ETN):number
	if a.Sign~=b.Sign then return a.Sign and 1 or -1 end
	local c=nETN.cmpAbs(a,b)return a.Sign and c or -c
end

--Returns the ETN with the larger absolute magnitude. (Must use nETN.convert to convert other types to ETN)
function nETN.maxAbs(a:ETN,b:ETN):ETN
	return nETN.cmpAbs(a,b)>=0 and a or b
end

--Returns the ETN with the larger value. (Must use nETN.convert to convert other types to ETN)
function nETN.max(a:ETN,b:ETN):ETN
	return nETN.cmp(a,b)>=0 and a or b
end

--Returns the ETN with the smaller absolute magnitude. (Must use nETN.convert to convert other types to ETN)
function nETN.minAbs(a:ETN,b:ETN):ETN
	return nETN.cmpAbs(a,b)<0 and a or b
end

--Returns the ETN with the smaller value. (Must use nETN.convert to convert other types to ETN)
function nETN.min(a:ETN,b:ETN):ETN
	return nETN.cmp(a,b)<0 and a or b
end

-- Less Than (a<b) Operator
function nETN.le(a:ValidInput,b:ValidInput):boolean
	return nETN.cmp(nETN.convert(a),nETN.convert(b))==-1
end

-- Greater Than (a>b) Operator
function nETN.me(a:ValidInput,b:ValidInput):boolean
	return nETN.cmp(nETN.convert(a),nETN.convert(b))==1
end

-- Equal (a=b) Operator
function nETN.eq(a:ValidInput,b:ValidInput):boolean
	return nETN.cmp(nETN.convert(a),nETN.convert(b))==0
end

-- Not Equal (a~=b) Operator
function nETN.neq(a:ValidInput,b:ValidInput):boolean
	return nETN.cmp(nETN.convert(a),nETN.convert(b))~=0
end

-- Less Than or Equal (a<=b) Operator
function nETN.leeq(a:ValidInput,b:ValidInput):boolean
	return nETN.cmp(nETN.convert(a),nETN.convert(b))~=1
end

-- Greater Than or Equal (a>=b) Operator
function nETN.meeq(a:ValidInput,b:ValidInput):boolean
	return nETN.cmp(nETN.convert(a),nETN.convert(b))~=-1
end

--Returns the Absolute Value of an ETN
function nETN.abs(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	if Value.Sign then return Value end
	return nETN.RawNew(true,Value.Layer,Value.Val1,Value.Val2)
end

--Mutates and edits an ETN to become an absolute value
--WARNING: DO NOT pass nETN constants (Inf,MinusInf,ZERO,ONE,MinusONE,NaN) as they will be mutated globally
function nETN.absMutated(Value:ValidInput):ETN
	Value=nETN.convert(Value)Value.Sign=true return Value
end

--Returns the Negated Value of an ETN
function nETN.neg(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	return nETN.RawNew(not Value.Sign,Value.Layer,Value.Val1,Value.Val2)
end

--Mutates and edits an ETN to become its Negated value
--WARNING: DO NOT pass nETN constants (Inf,MinusInf,ZERO,ONE,MinusONE,NaN) as they will be mutated globally
function nETN.negMutated(Value:ValidInput):ETN
	Value=nETN.convert(Value)Value.Sign=not Value.Sign return Value
end

local function recipfast(Value:ETN):ETN
	if nETN.IsZero(Value)then return Value.Sign and Inf or MinusInf end
	local Layer=Value.Layer if Layer>=3 then return ZERO end
	local val1,val2,sign=Value.Val1,Value.Val2,Value.Sign
	if Layer==2 then
		local poweredval=pow10(val1+val2)
		if poweredval==INFINITY then return ZERO end
		return nETN.RawNew(sign,1,-poweredval,0)
	end
	if Layer==0 then
		if val2==0 then
			if val1==1 then return sign and ONE or MinusONE end
			return nETN.RawNew(sign,0,0,1/val1)
		else
			local inverse=1/(val1+val2)
			local flooredinverse=floor(inverse)
			return nETN.RawNew(sign,0,flooredinverse,inverse-flooredinverse)
		end
	elseif Layer==1 then
		local added=val1+val2
		if added<=-MAX_ABSOLUTE_RANGE then
			added=-added local logval=log10(added)
			local flooredlog=floor(logval)
			return nETN.RawNew(sign,2,flooredlog,logval-flooredlog)
		end
		if val2==0 then
			if val1==0 then return sign and ONE or MinusONE end
			return nETN.RawNew(sign,1,-val1,0)
		else
			return nETN.RawNew(sign,1,-val1-1,1-val2)
		end
	elseif Layer==-2 then return ZERO else return NaN end
end
--Returns the reciprocal of an ETN
function nETN.recip(Value:ValidInput):ETN
	Value=nETN.convert(Value)return recipfast(Value)
end

--Returns the log10 of an ETN
function nETN.log10(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	if not Value.Sign then return NaN end
	local Layer = Value.Layer
	if Layer==-2 then return Inf end
	if Layer==-1 then return NaN end
	local val1,val2=Value.Val1,Value.Val2
	local result=val1+val2
	if Layer==0 then
		if val1==0 and val2==0 then return MinusInf end
		if result==1 then return ZERO end
		local L10=log10(result)
		local resultSign=L10>=0 if not resultSign then L10=-L10 end
		local flooredlog=floor(L10)
		return nETN.RawNew(resultSign,0,flooredlog,L10-flooredlog)
	elseif Layer==1 then
		if LOGRANGE_A(result) then
			local L10=log10(-result)
			local flooredlog=floor(L10)
			return nETN.RawNew(false,1,flooredlog,L10-flooredlog)
		else
			local resultSign=result>=0 if not resultSign then
				val1=-val1
				if val2~=0 then
					val2=1-val2
					val1-=1
				end
			end
			return nETN.RawNew(resultSign,0,val1,val2)
		end
	end
	if LOGRANGE_B(result)then
		local L10=log10(result)
		local flooredlog=floor(L10)
		return nETN.RawNew(true,Layer,flooredlog,L10-flooredlog)
	else
		return nETN.RawNew(true,Layer-1,val1,val2)
	end
end

--MAGIC SOLVER
local function algol(Value:ETN,MULTIPLIER:number):ETN
	if not Value.Sign then return NaN end
	local Layer = Value.Layer
	if Layer==-2 then return Inf end
	if Layer==-1 then return NaN end
	local val1,val2=Value.Val1,Value.Val2
	local result=val1+val2
	
	if Layer==0 then
		if val1==0 and val2==0 then return MinusInf end
		if result==1 then return ZERO end
		local L10=log10(result)*MULTIPLIER
		local RS=L10<0 if RS then L10=-L10 end
		local flooredlog=floor(L10)
		return nETN.RawNew(not RS,0,flooredlog,L10-flooredlog)
	end
	
	--MULTIPLIER DOMAIN 3.24407040516e-3 to 2.0739842734e15

	local resultSign=result>=0
	if Layer==1 then
		result*=MULTIPLIER --1;1;-1e299;0
		if not resultSign then result=-result end
		-- 1;1;-1e299;0 false
		if LOGRANGE_B(result)then --L>=1e300
			if not resultSign then val1=-val1 val2=-val2 end
			local L10=log10(val1+val2)+log10(MULTIPLIER)
			local flooredlog=floor(L10)
			return nETN.RawNew(resultSign,1,flooredlog,L10-flooredlog)
		end
		val1*=MULTIPLIER val2*=MULTIPLIER
		--result 300 to 1e300
		--MRESULT ~0.975 TO 2.0739842734e315
	elseif Layer==2 then
		local multLog=log10(MULTIPLIER)
		result+=multLog
		if result<DigitLimit then
			local pow10=pow10(result)
			local flooredval=floor(pow10)
			return nETN.RawNew(resultSign,0,flooredval,pow10-flooredval)
		end
		val2+=multLog
	end
	if math.isinf(result)then return resultSign and MinusInf or Inf end
	
	if LOGRANGE_B(result)then -- L>=1e300
		local L10=log10(result)
		local flooredlog=floor(L10)
		return nETN.RawNew(resultSign,Layer,flooredlog,L10-flooredlog)
	else
		if not resultSign then
			val1=-val1
			if val2~=0 then
				val2=1-val2
				val1-=1
			end
		end
		if val1<=FLOAT_HALF_INT_LIMIT then
			local flooredval=floor(val1)
			val2+=val1-flooredval val1=flooredval
		end
		if val2>=1 or val2<0 then
			local flooredval2=floor(val2)
			val2-=flooredval2 val1+=flooredval2
		end
		return nETN.RawNew(resultSign,Layer-1,val1,val2)
	end
end

local BASE_LIMIT=1e308
local BASE_LIMIT_RECIP=1/BASE_LIMIT
--Returns arbitrary base (b) log of an ETN. If no base is specified, natural log is assumed.
function nETN.log(Value:ValidInput,Base:number):ETN
	Value=nETN.convert(Value)
	if not Base then return algol(Value,LN10)end
	if type(Base)~="number"then Base=nETN.toNumber(Base)end
	if Base>0 and Base~=1 then
		Base=math.clamp(Base,BASE_LIMIT_RECIP,BASE_LIMIT)
		local LOG10BASE=log10(Base)
		if LOG10BASE<0 then
			local log=algol(Value,-1/LOG10BASE)
			return nETN.RawNew(not log.Sign,log.Layer,log.Val1,log.Val2)
		end
		return algol(Value,1/LOG10BASE)
	end
	return NaN
end

--Returns the pow10 of an ETN
function nETN.pow10(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	if nETN.IsZero(Value)then return ONE end
	local Layer,sign = Value.Layer,Value.Sign
	if Layer==-2 then return sign and Inf or ZERO end
	if Layer==-1 then return NaN end
	local val1,val2=Value.Val1,Value.Val2
	local added=val1+val2
	if Layer==MAX_LAYER then
		if not sign then return ZERO end
		local result=pow10(added)
		if result==INFINITY then return Inf end
		return nETN.RawNew(true,MAX_LAYER,result,0)
	end
	if Layer==0 then
		if MAGRANGEABS(added)then
			if added<=POW10_EPSILON then return ONE end
			if not sign then added=-added end
			local result=pow10(added)
			local flooredresult=floor(result)
			return nETN.RawNew(true,0,flooredresult,result-flooredresult)
		else
			if not sign then val1=-val1
				if val2~=0 then
					val2=1-val2
					val1-=1
				end
			end
			return nETN.RawNew(true,1,val1,val2)
		end
	end
	if Layer==1 then
		if added<0 then return ONE end
		if not sign then 
			local result=pow10(added)
			if result==INFINITY then return ZERO end
			local flooredresult=floor(result)
			return nETN.RawNew(true,1,flooredresult,result-flooredresult)
		end
	elseif not sign then return ZERO end
	return nETN.RawNew(true,Layer+1,val1,val2)
end

--L1 CASE
--Demotion case (LOGBASE = 1e300, Value = {1;1;-300;0})
--1e300*10^X = 10^10^(X+loggedbase)
--Domain LOGBASE 4.8216373327664656e-17 to 1e308
--logged_LOGBASE -16.31680545889046562 to 308
--Domain Value -1e300 to -300 OR 300 to 1e308
--Inner exp to L0 -16.31680545889046562 to DADES_NUMBER

--INNER EXP LIMIT -1e300 TO 1e300
--INNER EXP LIMIT: -16.31680545889046562 TO 1e300 -> 10^10^X
-- INNER EXP LIMIT L0 LUMIS NUMBER TO <300 -> L0 NUMBER

local function anubis(LOGBASE:number,Value:ETN):ETN
	if LOGBASE==0 then return ONE end
	if nETN.IsZero(Value)then return ONE end
	
	local MultiplierSign=LOGBASE>=0
	local Layer,sign = Value.Layer,Value.Sign
	if not MultiplierSign then
		LOGBASE=-LOGBASE sign=not sign
	end
	if Layer==-2 then return sign and Inf or ZERO end
	if Layer==-1 then return NaN end
	
	local val1,val2=Value.Val1,Value.Val2
	local added=val1+val2
	
	local R_CHECK,result=true,0
	if Layer==0 then local ALOG=added*LOGBASE --L2 checks (LOGBASE = 1e299, Value = {1;0;1e299;0}) [SOLVED]
		if ALOG<=POW10_EPSILON then return ONE end
		if not sign and ALOG==INFINITY then return ZERO end
		if sign and MAGRANGEABS2(ALOG) then -- >=1e300
			result=log10(added)+log10(LOGBASE)
			local floored=floor(result)
			return nETN.RawNew(true,2,floored,result-floored)
		end
		R_CHECK=not MAGRANGEABS(ALOG) -- M>=300
		if R_CHECK then
			val1*=LOGBASE
			val2*=LOGBASE
		else if not sign then ALOG=-ALOG end result=pow10(ALOG)end
	elseif Layer==1 then local logged_LOGBASE=log10(LOGBASE) --[SOLVED]
		local InnerExp=added+logged_LOGBASE
		if sign and InnerExp<=MIAMIS_NUMBER then return ONE end
		if not sign and InnerExp<=LUMIS_NUMBER then return ONE end
		local pow10Exp=pow10(InnerExp)
		if not sign and pow10Exp==INFINITY then return ZERO end
		if pow10Exp<DigitLimit then
			if not sign then pow10Exp=-pow10Exp end
			result=pow10(pow10Exp)
			local floored=floor(result)
			return nETN.RawNew(true,0,floored,result-floored)
		end
		if not sign then R_CHECK=false result=-pow10Exp else
			R_CHECK=InnerExp>=DigitLimit
		end
		if R_CHECK then
			local flooredloggedlogbase=floor(logged_LOGBASE)
			val1+=flooredloggedlogbase
			val2+=logged_LOGBASE-flooredloggedlogbase
		else
			result=pow10Exp
		end
	elseif Layer==MAX_LAYER then
		if not sign then return ZERO end
		result=pow10(added)
		if result==INFINITY then return Inf end
		return nETN.RawNew(true,MAX_LAYER,result,0)
	else
		if sign then
			return nETN.RawNew(true,Layer+1,val1,val2)
		else return ZERO end
	end
	if R_CHECK then
		if not sign then val1=-val1
			if val2~=0 then
				val2=1-val2
				val1-=1
			end
		end
		if val1<=FLOAT_HALF_INT_LIMIT then
			local flooredval=floor(val1)
			val2+=val1-flooredval val1=flooredval
		end
		if val2>=1 or val2<0 then
			local flooredval2=floor(val2)
			val2-=flooredval2 val1+=flooredval2
		end
		return nETN.RawNew(true,Layer+1,val1,val2)
	else
		local flooredresult=floor(result)
		return nETN.RawNew(true,Layer,flooredresult,result-flooredresult)
	end
end
--Returns the e^x of an ETN
function nETN.exp(Value:ValidInput):ETN
	Value=nETN.convert(Value)return anubis(LOG10_E,Value)
end

local function fastpowX(A:number,Value:ETN):ETN
	local sign,layer,val1,val2=Value.Sign,Value.Layer,Value.Val1,Value.Val2
	if not sign and val1==1 and val2==0 then return recipfast(Value)end
	if layer==-1 then return NaN end

	if A==0 then
		if not sign then return Inf end
		if nETN.IsZero(Value)then return ONE else return ZERO end
	end
	if A<0 then
		A=math.clamp(-A,BASE_LIMIT_RECIP,BASE_LIMIT)
		if not nETN.IsInteger(Value)then return NaN end
		local absPow=anubis(log10(A),Value)
		if absPow.Layer<0 then return absPow end
		if layer==0 and val1<=FLOAT_INT_LIMIT then
			if bit32.band(val1,1)==0 then return absPow end
			return nETN.RawNew(not absPow.Sign,absPow.Layer,absPow.Val1,absPow.Val2)
		else
			local elsa=bit32.band(math.floor(FLOAT_INT_LIMIT*val2),1)==0
			if not sign then elsa=not elsa end
			return nETN.RawNew(elsa,absPow.Layer,absPow.Val1,absPow.Val2)
		end
	end
	A=math.clamp(A,BASE_LIMIT_RECIP,BASE_LIMIT)
	local LOG10BASE=log10(A)
	return anubis(LOG10BASE,Value)
end

local function fastpowY(L1:ETN,Value:ETN):ETN
	local sign,layer,val1,val2=Value.Sign,Value.Layer,Value.Val1,Value.Val2
	if layer==-1 then return NaN end
	local added=L1.Val1+L1.Val2
	if not L1.Sign then
		if not nETN.IsInteger(Value)then return NaN end
		local absPow=anubis(added,Value)
		if absPow.Layer<0 then return absPow end
		if layer==0 and val1<=FLOAT_INT_LIMIT then
			if bit32.band(val1,1)==0 then return absPow end
			return nETN.RawNew(not absPow.Sign,absPow.Layer,absPow.Val1,absPow.Val2)
		else
			local elsa=bit32.band(math.floor(FLOAT_INT_LIMIT*val2),1)==0
			if not sign then elsa=not elsa end
			return nETN.RawNew(elsa,absPow.Layer,absPow.Val1,absPow.Val2)
		end
	end
	return anubis(added,Value)
end
--Returns the A^x of an ETN
function nETN.powX(A:number,Value:ValidInput):ETN
	if A==1 then return ONE end
	Value=nETN.convert(Value)
	return fastpowX(A,Value)
end

local MIN_ABSOLUTE_RANGE_SQRT=math.sqrt(MIN_ABSOLUTE_RANGE)
local MAX_ABSOLUTE_RANGE_SQRT=math.sqrt(MAX_ABSOLUTE_RANGE)
local Itas_Number,Ritas_Number=0.3010299956639812,0.47712125471966244

local function fastsquare(Value:ETN):ETN
	local Layer=Value.Layer
	if Layer>=3 then return nETN.RawNew(true,Value.Layer,Value.Val1,Value.Val2) end
	if Layer==-2 then return Inf end
	if Layer==-1 then return NaN end
	if nETN.IsZero(Value)then return ZERO end
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return ONE end
	if Layer==2 then
		val2+=Itas_Number
		if val2>=1 then
			val1+=1
			val2-=1
		end
		return nETN.RawNew(true,2,val1,val2)
	end
	if Layer==0 then local val1iszero=val1==0
		if(val1iszero and val2<=MIN_ABSOLUTE_RANGE_SQRT)or(val1>=MAX_ABSOLUTE_RANGE_SQRT)then
			local added=2*log10(val1+val2)
			local flooredlog=floor(added)
			return nETN.RawNew(true,1,flooredlog,added-flooredlog)
		end
		if val1iszero then return nETN.RawNew(true,0,0,val2^2)end
		local a,b1,b2=val1^2,2*val1*val2,val2^2
		if b1<=FLOAT_HALF_INT_LIMIT then
			local flooredb1=floor(b1)
			b2+=b1-flooredb1 b1=flooredb1
		end a+=b1
		if b2>=1 then
			local flooredb2=floor(b2)
			a+=flooredb2 b2-=flooredb2
		end
		return nETN.RawNew(true,0,a,b2)
	end
	val1=val1*2 val2=val2*2
	if val1==-INFINITY then return ZERO end
	if MAGRANGEABS2(val1) then
		val1=log10(val1)local floored=floor(val1)
		return nETN.RawNew(true,2,floored,val1-floored)
	end
	if val2>=1 then local carry=floor(val2)
		val2-=carry val1+=carry
	end
	return nETN.RawNew(true,1,val1,val2)
end
--Returns the square of an ETN
function nETN.squared(Value:ValidInput):ETN
	Value=nETN.convert(Value)return fastsquare(Value)
end

local MIN_ABSOLUTE_RANGE_CBRT=pow10(-DigitLimit/3)
local MAX_ABSOLUTE_RANGE_CBRT=pow10(DigitLimit/3)

--Returns the cube of an ETN
function nETN.cubed(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	local Layer,sign=Value.Layer,Value.Sign
	if Layer>=3 then return Value end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end
	if nETN.IsZero(Value)then return ZERO end
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		val2+=Ritas_Number
		if val2>=1 then
			val1+=1
			val2-=1
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	if Layer==0 then local val1iszero=val1==0
		if(val1iszero and val2<=MIN_ABSOLUTE_RANGE_CBRT)or(val1>=MAX_ABSOLUTE_RANGE_CBRT)then
			local added=3*log10(val1+val2)
			local flooredlog=floor(added)
			return nETN.RawNew(sign,1,flooredlog,added-flooredlog)
		end
		if val1iszero then return nETN.RawNew(sign,0,0,val2^3)end
		local a,b1,b2,b3=val1^3,3*val1^2*val2,3*val1*val2^2,val2^3
		if b2<=FLOAT_HALF_INT_LIMIT then
			local floored=floor(b2)
			b3+=b2-floored b2=floored
			if b1<=FLOAT_HALF_INT_LIMIT then
				floored=floor(b1)
				b3+=b1-floored b1=floored
			end
		end a+=b2+b1
		if b3>=1 then
			local floored=floor(b3)
			a+=floored b3-=floored
		end
		return nETN.RawNew(sign,0,a,b3)
	end
	val1=val1*3 val2=val2*3
	if val1==-INFINITY then return ZERO end
	if MAGRANGEABS2(val1) then
		val1=log10(val1)local floored=floor(val1)
		return nETN.RawNew(sign,2,floored,val1-floored)
	end
	if val2>=1 then local carry=floor(val2)
		val2-=carry val1+=carry
	end
	return nETN.RawNew(sign,1,val1,val2)
end

local function factorial(n:number,stopping:number?):(number)
	n=math.round(n)stopping=stopping or 2
	stopping=math.round(stopping)>n and n or math.round(stopping)
	if n < 0 or n ~= n then return 0 end
	if n==0 or n==1 then return 1 end local result = n
	if n==stopping or n==2 then return result end
	for i=n-1,(stopping>=2 and stopping or 2),-1 do 
		result*=i if result==math.huge then break end
	end return result
end
local AChooseB:{[string]:number},ABMAX:number={},10
local absoluteranged:{{number}},AbsRangeMax:number={},10
local function computeACB(a:number,b:number,returnB:boolean):(number?)
	local binomial=1 if a==b or b==0 then 
		AChooseB[tostring(a).."_"..tostring(b)]=binomial
		return returnB and binomial or nil
	end local venusianNumber=a/2-abs(b-a/2)
	binomial=factorial(a,a-venusianNumber+1)/factorial(venusianNumber)
	AChooseB[tostring(a).."_"..tostring(b)]=binomial
	return returnB and binomial or nil
end
local function computerangelim(degree:number,returnB:boolean):{number}?
	local MinLimit,MaxLimit=-DigitLimit/degree,DigitLimit/degree
	return returnB and {MinLimit,MaxLimit}or nil
end
for a=0,ABMAX do for b=0,a do computeACB(a,b,false)end end
for a=2,AbsRangeMax do computerangelim(a,false)end
local function binom(a:number,b:number):(number)
	local cached=AChooseB[tostring(a).."_"..tostring(b)]
	if cached then return cached end
	cached=computeACB(a,b,true)return cached
end
local function absolute_ranges(degree:number):{number}
	local cached=absoluteranged[degree]
	if cached then return cached end
	cached=computerangelim(degree,true)return cached
end

local function teleiopartA(Value:ETN,x:number):ETN
	x=math.min(x,BASE_LIMIT)
	local Layer,sign=Value.Layer,Value.Sign
	if x%2==0 then sign=true end
	if Layer>=3 then return nETN.RawNew(sign,Value.Layer,Value.Val1,Value.Val2) end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end
	if nETN.IsZero(Value)then return ZERO end
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		val2+=log10(x)
		if val2>=1 then
			local added=floor(val2)
			val1+=added
			val2-=added
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	if Layer==0 then
		local absoluterange,val1iszero=absolute_ranges(x),val1==0
		local log10val=log10(val1+val2)
		if(val1iszero and log10(val2)<=absoluterange[1])or(log10val>=absoluterange[2])then
			local added=x*log10val
			if added==-INFINITY then return ZERO end
			if added>=MAX_ABSOLUTE_RANGE then
				local logspaceadded=log10(log10val)+log10(x)
				local floored=floor(logspaceadded)
				return nETN.RawNew(sign,2,floored,logspaceadded-floored)
			end
			local flooredlog=floor(added)
			return nETN.RawNew(sign,1,flooredlog,added-flooredlog)
		end
		if val1iszero then return nETN.RawNew(sign,0,0,val2^x)end
		if val1>1e10 and val2>0 and x<=500 then
			local a,b,extracted=val1^x,val2^x,x
			for K=x-1,1,-1 do
				local term=binom(x,K)*val1^(x-K)*val2^K
				if term<=FLOAT_HALF_INT_LIMIT then
					local floored=floor(term)
					b+=term-floored a+=floored
					extracted=K
				else break end
			end
			if extracted~=1 then
				for K=1,extracted-1,1 do
					local term=binom(x,K)*val1^(x-K)*val2^K
					if term>MACHINE_EPSILON_HALF*a then
						local floored=term
						if term<=FLOAT_HALF_INT_LIMIT then floored=floor(term)b+=term-floored end
						a+=floored
					else break end
				end
			end
			if b>=1 then
				local floored=floor(b)
				a+=floored b-=floored
			end
			return nETN.RawNew(sign,0,a,b)
		end
		local result=(val1+val2)^x
		local a=floor(result)
		local b=result-a
		return nETN.RawNew(sign,0,a,b)
	end
	val2=val2*x
	if val1==-INFINITY then return ZERO end
	if MAGRANGEABS2(val1*x) then
		val1=log10(val1)+log10(x)local floored=floor(val1)
		return nETN.RawNew(sign,2,floored,val1-floored)
	end val1*=x
	if val2>=1 then local carry=floor(val2)
		val2-=carry val1+=carry
	end
	return nETN.RawNew(sign,1,val1,val2)
end

--Returns the x^n of an ETN [n must be an integer] (most accurate)
function nETN.powerInt(Value:ValidInput,x:number):ETN
	if x==0 then return ONE end
	if x==-1 then return nETN.recip(Value)end
	Value=nETN.convert(Value)
	if x==1 then return Value end
	x=math.floor(x)
	if math.isinf(x)then return x<0 and ZERO or Inf end
	if x<0 then return teleiopartA(recipfast(Value),-x)end
	return teleiopartA(Value,x)
end

--Returns the sqrt(x) of an ETN
function nETN.sqrt(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	local Layer,sign=Value.Layer,Value.Sign
	if not sign then return NaN end
	if Layer>=3 then return Value end
	if Layer==-2 then return Inf end
	if Layer==-1 then return NaN end
	if nETN.IsZero(Value)then return ZERO end
	
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return ONE end
	if Layer==2 then
		val2-=Itas_Number
		if val2<0 then
			val1-=1
			val2+=1
		end local inner=val1+val2
		if inner<DigitLimit then
			return nETN.RawNew(true,1,pow10(inner),0)
		end
		return nETN.RawNew(true,2,val1,val2)
	end
	local added=val1+val2 if Layer==1 then
		val1*=0.5 val2*=0.5 added*=0.5
		if abs(added)<DigitLimit then
			return nETN.RawNew(true,0,pow10(added),0)
		end
		local floored=floor(val1)
		val2+=val1-floored val1=floored
		if val2>=1 then local carry=floor(val2)
			val2-=carry val1+=carry
		end
		return nETN.RawNew(true,1,val1,val2)
	end
	local result=math.sqrt(added)
	local a=floor(result)
	local b=result-a
	return nETN.RawNew(true,0,a,b)
end

--Returns the cbrt(x) of an ETN
function nETN.cbrt(Value:ValidInput):ETN
	Value=nETN.convert(Value)
	local Layer,sign=Value.Layer,Value.Sign
	if Layer>=3 then return Value end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end
	if nETN.IsZero(Value)then return ZERO end
	
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		val2-=Ritas_Number
		if val2<0 then
			val1-=1
			val2+=1
		end local inner=val1+val2
		if inner<DigitLimit then
			return nETN.RawNew(sign,1,pow10(inner),0)
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	local added=val1+val2 if Layer==1 then
		val1/=3 val2/=3 added/=3
		if abs(added)<DigitLimit then
			return nETN.RawNew(sign,0,pow10(added),0)
		end
		local floored=floor(val1)
		val2+=val1-floored val1=floored
		if val2>=1 then local carry=floor(val2)
			val2-=carry val1+=carry
		end
		return nETN.RawNew(sign,1,val1,val2)
	end
	local result=abs(added)^(1/3)
	local a=floor(result)
	local b=result-a
	return nETN.RawNew(sign,0,a,b)
end

--The root formula
local function teleiopartB(Value:ETN,x:number):ETN
	local Layer,sign=Value.Layer,Value.Sign
	x=math.min(x,BASE_LIMIT)
	if x%2==0 or x%1~=0 then if not sign then return NaN end sign=true end
	if Layer>=3 then return Value end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end
	
	if nETN.IsZero(Value)then return ZERO end

	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		val2-=log10(x)
		if val2<0 then
			local added=-floor(val2)
			val1-=added
			val2+=added
		end local inner=val1+val2
		if inner<DigitLimit then
			local demoted=pow10(inner)
			local floored=floor(demoted)
			if demoted<DigitLimit then
				demoted=pow10(demoted)
				floored=floor(demoted)
				return nETN.RawNew(sign,0,floored,demoted-floored)
			end
			return nETN.RawNew(sign,1,floored,demoted-floored)
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	local added=val1+val2 if Layer==1 then
		val1/=x val2/=x added/=x
		if abs(added)<DigitLimit then
			local K=pow10(added)
			local floored=floor(K)
			return nETN.RawNew(sign,0,floored,K-floored)
		end
		local floored=floor(val1)
		val2+=val1-floored val1=floored
		if val2>=1 then local carry=floor(val2)
			val2-=carry val1+=carry
		end
		return nETN.RawNew(sign,1,val1,val2)
	end
	local result=abs(added)^(1/x)
	local a=floor(result)
	local b=result-a
	return nETN.RawNew(sign,0,a,b)
end

--Works for non integers
local function teleiopartC(Value:ETN,x:number):ETN
	local Layer,sign=Value.Layer,Value.Sign
	x=math.min(x,BASE_LIMIT)
	if x%1~=0 and not sign then return NaN end
	if x%2==0 then sign=true end
	if Layer>=3 then return nETN.RawNew(sign,Value.Layer,Value.Val1,Value.Val2) end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end
	if nETN.IsZero(Value)then return ZERO end
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		val2+=log10(x)
		if val2>=1 then
			local added=floor(val2)
			val1+=added
			val2-=added
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	if Layer==0 then
		local absoluterange,val1iszero=absolute_ranges(x),val1==0
		local log10val=log10(val1+val2)
		if(val1iszero and log10(val2)<=absoluterange[1])or(log10val>=absoluterange[2])then
			local added=x*log10val
			if added==-INFINITY then return ZERO end
			if added>=MAX_ABSOLUTE_RANGE then
				local logspaceadded=log10(log10val)+log10(x)
				local floored=floor(logspaceadded)
				return nETN.RawNew(sign,2,floored,logspaceadded-floored)
			end
			local flooredlog=floor(added)
			return nETN.RawNew(sign,1,flooredlog,added-flooredlog)
		end
		if val1iszero then return nETN.RawNew(sign,0,0,val2^x)end
		local result=(val1+val2)^x
		local a=floor(result)
		local b=result-a
		return nETN.RawNew(sign,0,a,b)
	end
	val2=val2*x
	if val1==-INFINITY then return ZERO end
	if MAGRANGEABS2(val1*x) then
		val1=log10(val1)+log10(x)local floored=floor(val1)
		return nETN.RawNew(sign,2,floored,val1-floored)
	end val1*=x
	if val2>=1 then local carry=floor(val2)
		val2-=carry val1+=carry
	end
	return nETN.RawNew(sign,1,val1,val2)
end

local function teleiopartB_L1(Value:ETN,L1:number):ETN
	local Layer,sign=Value.Layer,Value.Sign
	if Layer>=4 then return Value end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end

	if nETN.IsZero(Value)then return ZERO end

	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		local flooredL1=floor(L1)
		val2-=L1-flooredL1
		val1-=flooredL1
		if val2<0 then
			local added=-floor(val2)
			val1-=added
			val2+=added
		end
		local inner=val1+val2
		if inner<DigitLimit then
			local demoted=pow10(inner)
			local floored=floor(demoted)
			if demoted<DigitLimit then
				demoted=pow10(demoted)
				floored=floor(demoted)
				return nETN.RawNew(sign,0,floored,demoted-floored)
			end
			return nETN.RawNew(sign,1,floored,demoted-floored)
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	local added=val1+val2 if Layer==1 then
		local ASIGN=added<0
		local LOG_A=log10(abs(added))
		added=pow10(LOG_A-L1) -- L1 is 300.908243580534098543
		if added<DigitLimit then
			if ASIGN then added=-added end
			local K=pow10(added)
			local floored=floor(K)
			return nETN.RawNew(sign,0,floored,K-floored)
		end
		local Log_V1,Log_V2=log10(abs(val1)),log10(abs(val2))
		local V1sign,V2sign=val1<0,val2<0
		val1=pow10(Log_V1-L1)if V1sign then val1=-val1 end
		val2=pow10(Log_V2-L1)if V2sign then val2=-val2 end
		local floored=floor(val1)
		val2+=val1-floored val1=floored
		if val2>=1 or val2<0 then local carry=floor(val2)
			val2-=carry val1+=carry
		end
		return nETN.RawNew(sign,1,val1,val2)
	end
	--[[if Layer==3 then
		local differance=log10(L1)-added
		if differance==0 then return sign and TEN or MinusTEN end
		if differance>0 then return sign and ONE or MinusONE end
		if differance<DRACULAURAS_NUMBER then return Value end
		
		--TAYLOR POLYNOMIAL
		local X=added+log10(1-pow10(differance))
		if X<DigitLimit then
			X=pow10(X)
			return nETN.RawNew(sign,2,X,0)
		end
		local flooredX=floor(X)
		return nETN.RawNew(sign,3,flooredX,X-flooredX)
	end]]
	return sign and ONE or MinusONE
end

local function teleiopartC_L1(Value:ETN,L1:number):ETN
	local Layer,sign=Value.Layer,Value.Sign
	if Layer>=4 then return Value end
	if Layer==-2 then return sign and Inf or MinusInf end
	if Layer==-1 then return NaN end

	if nETN.IsZero(Value)then return ZERO end
	
	local val1,val2=Value.Val1,Value.Val2
	if val1==1 and val2==0 then return sign and ONE or MinusONE end
	if Layer==2 then
		local flooredL1=floor(L1)
		val2+=L1-flooredL1
		val1+=flooredL1
		if val2>=1 then
			local added=floor(val2)
			val1+=added
			val2-=added
		end
		local inner=val1+val2
		if inner==INFINITY then return sign and Inf or MinusInf end
		--[[if inner>=MAX_ABSOLUTE_RANGE then
			local promoted=log10(inner)
			local floored=floor(promoted)
			return nETN.RawNew(sign,3,floored,promoted-floored)
		end]]
		return nETN.RawNew(sign,2,val1,val2)
	end
	local added=val1+val2 if Layer==1 then
		local ASIGN=added<0
		local LOG_A=log10(abs(added)) -- 2.4 to 300
		added=LOG_A+L1 -- x+300
		if ASIGN then
			if added==INFINITY then return ZERO end
			added=-added
			local K=pow10(added)
			local floored=floor(K)
			return nETN.RawNew(sign,1,floored,K-floored)
		end
		
		if added>LOG10_MAX then return sign and Inf or MinusInf end
		--[[if added>=DigitLimit then
			local floored=floor(added)
			return nETN.RawNew(sign,3,floored,added-floored)
		end]]
		local Log_V1,Log_V2=log10(val1),log10(val2)
		val1=pow10(Log_V1+L1)
		val2=pow10(Log_V2+L1)
		
		local floored=floor(val1)
		val2+=val1-floored val1=floored
		if val2>=1 or val2<0 then local carry=floor(val2)
			val2-=carry val1+=carry
		end
		return nETN.RawNew(sign,2,val1,val2)
	end
	if Layer==0 then
		local val1iszero=val1==0
		local log10val=log10(val1+val2)
		
		local added=pow10(L1)*log10val
		if added==-INFINITY then return ZERO end
		if added>=MAX_ABSOLUTE_RANGE then
			local logspaceadded=log10(log10val)+L1
			local floored=floor(logspaceadded)
			return nETN.RawNew(sign,2,floored,logspaceadded-floored)
		end
		local flooredlog=floor(added)
		return nETN.RawNew(sign,1,flooredlog,added-flooredlog)
	end
	--REMODIFY
	--[[if Layer==3 then
		local differance=log10(L1)-added
		if differance==0 then return sign and TEN or MinusTEN end
		if differance>0 then return sign and ONE or MinusONE end
		if differance<DRACULAURAS_NUMBER then return Value end
		
		--TAYLOR POLYNOMIAL
		local X=added+log10(1-pow10(differance))
		if X<DigitLimit then
			X=pow10(X)
			return nETN.RawNew(sign,2,X,0)
		end
		local flooredX=floor(X)
		return nETN.RawNew(sign,3,flooredX,X-flooredX)
	end]]
end

--Returns the x^(1/n) of an ETN
function nETN.root(Value:ValidInput,n:number):ETN
	if type(n)~="number"then n=nETN.toNumber(n)end
	if n==0 then return NaN end
	if n==-1 then return nETN.recip(Value)end
	Value=nETN.convert(Value)
	if n==1 then return Value end
	if n<0 then 
		if n>-1 then return teleiopartC(recipfast(Value),-1/n)end
		return teleiopartB(recipfast(Value),-n)
	end
	if n<1 then return teleiopartC(Value,1/n)end
	return teleiopartB(Value,n)
end

local function fastpower(Value:ETN,x:number):ETN
	if x==1 then return Value end
	if x<0 then x=-x
		if x<1 then return teleiopartB(recipfast(Value),1/x)end
		return teleiopartC(recipfast(Value),x)
	else
		if x<1 then return teleiopartB(Value,1/x)end
		return teleiopartC(Value,x)
	end
end

local function fastpowerY(Value:ETN,L1:ETN):ETN
	local MAGNITUDE=Value.Val1+Value.Val2
	local layer=Value.Layer
	local resultSign=MAGNITUDE>=0 
	if not resultSign and not Value.Sign then return NaN end
	if not L1.Sign then
		if not resultSign then return teleiopartB_L1(recipfast(Value),-MAGNITUDE)end
		return teleiopartC_L1(recipfast(Value),MAGNITUDE)
	else
		if not resultSign then return teleiopartB_L1(Value,-MAGNITUDE)end
		return teleiopartC_L1(Value,MAGNITUDE)
	end
end
--Returns the x^A of an ETN
function nETN.power(Value:ValidInput,x:number):ETN
	if x==0 then return ONE end
	if x==-1 then return nETN.recip(Value)end
	Value=nETN.convert(Value)
	return fastpower(Value,x)
end

-- Returns the x^y of both ETNs (Optimized)
function nETN.pow(x:ValidInput,y:ValidInput):ETN
	x=nETN.convert(x)y=nETN.convert(y)
	local xsign,ysign=x.Sign,y.Sign
	local xlayer,ylayer=x.Layer,y.Layer
	if xlayer==-1 or ylayer==-1 then return NaN end
	if xlayer==0 then
		local A=(x.Val1+x.Val2)*(xsign and 1 or -1)
		if A==1 then return ONE end
		return fastpowX(A,y)
	end
	if xlayer==1 then return fastpowY(x,y)end
	if ylayer==0 then
		local A=(y.Val1+y.Val2)*(ysign and 1 or -1)
		if A==0 then return ONE end
		if A==-1 then return recipfast(x)end
		return fastpower(x,A)
	end
	if ylayer==1 then return fastpowerY(x,y)end
	if not xsign and not nETN.IsInteger(y) then return NaN end
	
	if not ysign then return ZERO end
	if ylayer==-2 or xlayer==-2 then return Inf end
	local v1,v2=(x.Val1+x.Val2),(y.Val1+y.Val2)
	local thesign=xsign or bit32.band(math.floor(FLOAT_INT_LIMIT*y.Val2),1)==0
	local loggedv1=log10(v1) local differance=v2-loggedv1

	--[[if differance<TWYLAS_NUMBER then
		local floored=floor(v1)
		return nETN.RawNew(thesign,2,floored,v1-floored)
		local floored=floor(loggedv1)
		return nETN.RawNew(thesign,3,floored,loggedv1-floored)
	end]]
	if differance>-TWYLAS_NUMBER then
		local pow10=pow10(v2)
		if pow10==INFINITY then return Inf end
		return nETN.RawNew(thesign,2,pow10,0)
	end
	local X=pow10(loggedv1+log10(1+pow10(differance)))
	if X==INFINITY then return Inf end
	return nETN.RawNew(thesign,2,X,0)
	--local flooredX=floor(X)
	--return nETN.RawNew(thesign,3,flooredX,X-flooredX)
end

local function mul2(Value:ETN):ETN
	local sign,layer=Value.Sign,Value.Layer
	if layer>=2 then return Value end
	local v1,v2=Value.Val1,Value.Val2
	if layer==1 then
		v2+=Itas_Number
		local added=v1+v2
		if added<0 and added>-DigitLimit then
			return nETN.RawNew(sign,0,0,pow10(added))
		end
		if v2>=1 then
			v1+=1
			v2-=1
		end
		return nETN.RawNew(sign,1,v1,v2)
	end
	v1*=2
	if v1>=MAX_ABSOLUTE_RANGE then
		local logv1=log10(v1)
		local floored=floor(logv1)
		return nETN.RawNew(sign,1,floored,logv1-floored)
	end
	v2*=2
	if v2>=1 then
		v1+=1
		v2-=1
	end
	return nETN.RawNew(sign,0,v1,v2)
end

local function fastadd(a:ETN,b:ETN):ETN
	if nETN.IsZero(a)then return b end
	if nETN.IsZero(b)then return a end
	
	local asign,bsign=a.Sign,b.Sign local thesign=asign==bsign
	if not thesign and not asign then
		a,b=b,a asign,bsign=bsign,asign
	end
	local alayer,blayer=a.Layer,b.Layer
	local av1,av2,bv1,bv2=a.Val1,a.Val2,b.Val1,b.Val2
	
	if alayer==-1 or blayer==-1 then return NaN end
	local ainf,binf=alayer==-2,blayer==-2
	if ainf and binf then
		if thesign then return a end return ZERO
	end
	if ainf then return a end if binf then return b end
	if nETN.cmpAbs(a,b)==0 then
		if asign==bsign then return mul2(a)end return ZERO
	end
	if alayer==blayer then
		if alayer==0 then
			if thesign then
				local pa=av1+bv1
				if pa>=MAX_ABSOLUTE_RANGE then
					local loggedpa=log10(pa)
					local floored=floor(loggedpa)
					return nETN.RawNew(asign,1,floored,loggedpa-floored)
				end
				local pb=av2+bv2 if pb>=1 then
					pa+=1
					pb-=1
				end
				return nETN.RawNew(asign,0,pa,pb)
			end
			local pb=av2-bv2 local rs2=pb>=0
			if not rs2 then pb=-pb end
			if av1==bv1 then
				if pb<=MIN_ABSOLUTE_RANGE then
					local loggedpb=log10(pb)
					local floored=floor(loggedpb)
					return nETN.RawNew(rs2,1,floored,loggedpb-floored)
				end
				return nETN.RawNew(rs2,0,0,pb)
			end
			local pa=av1-bv1 local rs=pa>=0
			if not rs then pa=-pa end
			if rs2~=rs then
				pb=1-pb
				pa-=1
			end
			return nETN.RawNew(rs,0,pa,pb)
		elseif alayer==1 then
			local statement,difference=av1==bv1,nil
			if statement then difference=bv2-av2 else
				difference=(bv1-av1)+(bv2-av2)
				if difference>-TWYLAS_NUMBER then return b end
				if thesign then
					if difference<TWYLAS_NUMBER then return a end
				else
					if difference<DRACULAURAS_NUMBER then return a end
				end
			end
			local M,bob=thesign and 1 or -1,nil
			if difference<CLAWDEENS_NUMBER and difference>CLEO_DENILES_NUMBER then
				bob=thesign and 2 or -LN10*difference
			else bob=1+M*pow10(difference)end
			local bobsign=bob>=0
			if not bobsign and not thesign then bob=-bob end
			local logterm=log10(bob)
			local flooredlog=floor(logterm)
			local remainder=logterm-flooredlog
			local pa,pb=av1+flooredlog,av2+remainder
			local added=pa+pb
			if thesign then
				if added<0 and added>-DigitLimit then
					return nETN.RawNew(asign,0,0,pow10(added))
				end
			else
				if abs(added)<DigitLimit then
					local pow=pow10(added)
					local floored=floor(pow)
					return nETN.RawNew(bobsign,0,floored,pow-floored)
				end
			end
			if pb>=1 then
				pa+=1
				pb-=1
			end
			local Multi if thesign then Multi=asign else Multi=bobsign end
			return nETN.RawNew(Multi,1,pa,pb)
		else
			if av1~=bv1 then if av1>bv1 then return a end return b end
			
		end
	end
	if alayer>blayer then 
		a,b=b,a
		alayer,blayer=blayer,alayer
		av1,av2,bv1,bv2=bv1,bv2,av1,av2
	end
	if alayer==0 then
		if blayer==1 then
			
		else return b end
	elseif alayer==1 then
		if blayer==2 then
			
		else return b end
	end
end
--Adds two ETNs together like a+b
function nETN.add(a:ValidInput,b:ValidInput):ETN
	a=nETN.convert(a)b=nETN.convert(b)
	return fastadd(a,b)
end

--Subtracts two ETNs like a-b
function nETN.sub(a:ValidInput,b:ValidInput):ETN
	a=nETN.convert(a)b=nETN.convert(b)
	return fastadd(a,nETN.RawNew(not b.Sign,b.Layer,b.Val1,b.Val2))
end

--Multiplies two ETNs together like a*b
--for L2 AND ABOVE USE nETN.div() taking the reciprocal of an L2 will yield 0, we plan to add L2+ tiny numbers in 2.XXX+ RR.
function nETN.mul(a:ValidInput,b:ValidInput):ETN
	a=nETN.convert(a)b=nETN.convert(b)
	if nETN.IsZero(a)then return ZERO end
	if nETN.IsZero(b)then return ZERO end
	
	local alayer,blayer=a.Layer,b.Layer
	local av1,av2,bv1,bv2=a.Val1,a.Val2,b.Val1,b.Val2
	local thesign=a.Sign==b.Sign
	
	if alayer==-1 or blayer==-1 then return NaN end
	if alayer==-2 or blayer==-2 then return thesign and Inf or MinusInf end
	if av1==1 and av2==0 then
		return nETN.RawNew(thesign,b.Layer,b.Val1,b.Val2)
	end
	if bv1==1 and bv2==0 then
		return nETN.RawNew(thesign,a.Layer,a.Val1,a.Val2)
	end
	if nETN.cmp(a,b)==0 then return fastsquare(a)end
	if alayer==blayer then
		if alayer==0 then
			local logspace=log10(av1+av2)+log10(bv1+bv2)
			if abs(logspace)>=DigitLimit then
				local floored=floor(logspace)
				return nETN.RawNew(thesign,1,floored,logspace-floored)
			end
			if av1==0 and bv1==0 then return nETN.RawNew(thesign,0,0,av2*bv2) end
			if av2==0 and bv2==0 then return nETN.RawNew(thesign,0,av1*bv1,0) end
			local pa,pb=av1*bv1,av2*bv2
			local b11,b12=av1*bv2,av2*bv1
			if b11~=0 then
				if b11<=FLOAT_HALF_INT_LIMIT then
					local floored=floor(b11)
					pb+=b11-floored
					pa+=floored
				else pa+=b11 end
			end
			if b12~=0 then
				if b12<=FLOAT_HALF_INT_LIMIT then
					local floored=floor(b12)
					pb+=b12-floored
					pa+=floored
				else pa+=b12 end
			end
			if pb>=1 then
				local flooredval2=floor(pb)
				pb-=flooredval2 pa+=flooredval2
			end
			return nETN.RawNew(thesign,0,pa,pb)
		elseif alayer==1 then
			local pa=av1+bv1
			if pa>=MAX_ABSOLUTE_RANGE then
				local loggedpa=log10(pa)
				local floored=floor(loggedpa)
				return nETN.RawNew(thesign,2,floored,loggedpa-floored)
			elseif pa==-INFINITY then return ZERO end
			local pb=av2+bv2 local added=pa+pb
			local addedsign=added>=0
			if addedsign and added<DigitLimit then
				local powed=pow10(added)
				local floored=floor(powed)
				return nETN.RawNew(thesign,0,floored,powed-floored)
			end
			if not addedsign and added>-DigitLimit then
				local powed=pow10(added)
				return nETN.RawNew(thesign,0,0,powed)
			end
			if pb>=1 then
				pb-=1
				pa+=1
			end --WHAT U DO X3  WHAT U DO X3  WHAT U DO 2 ME X3 
			return nETN.RawNew(thesign,1,pa,pb)
		elseif alayer==2 then
			local av,bv=av1+av2,bv1+bv2
			local difference=bv-av
			if difference<TWYLAS_NUMBER then
				return nETN.RawNew(thesign,2,av1,av2)
			end
			if difference>-TWYLAS_NUMBER then
				return nETN.RawNew(thesign,2,bv1,bv2)
			end
			local factor=log10(1+pow10(difference))
			local flooredfactor=floor(factor)
			local remainder=factor-flooredfactor
			local pa,pb=av1+flooredfactor,av2+remainder
			if pb>=1 then
				pb-=1
				pa+=1
			end
			return nETN.RawNew(thesign,2,pa,pb)
		end
	end
	if alayer>blayer then 
		a,b=b,a
		alayer,blayer=blayer,alayer
		av1,av2,bv1,bv2=bv1,bv2,av1,av2
	end
	if alayer==0 then
		if blayer==1 then
			local logA=log10(av1+av2)
			if abs(logA+bv1+bv2)<DigitLimit then
				local powBv=pow10(bv1+bv2)
				local b1,b2=powBv,0
				if powBv<=FLOAT_HALF_INT_LIMIT then
					local floored=floor(powBv)
					b1=floored b2=powBv-floored
				end
				if av1==0 and b1==0 then return nETN.RawNew(thesign,0,0,av2*b2) end
				if av2==0 and b2==0 then return nETN.RawNew(thesign,0,av1*b1,0) end
				local pa,pb=av1*b1,av2*b2
				local b11,b12=av1*b2,av2*b1
				if b11~=0 then
					if b11<=FLOAT_HALF_INT_LIMIT then
						local floored=floor(b11)
						pb+=b11-floored
						pa+=floored
					else pa+=b11 end
				end
				if b12~=0 then 
					if b12<=FLOAT_HALF_INT_LIMIT then
						local floored=floor(b12)
						pb+=b12-floored
						pa+=floored
					else pa+=b12 end
				end
				if pb>=1 then
					local flooredval2=floor(pb)
					pb-=flooredval2 pa+=flooredval2
				end
				return nETN.RawNew(thesign,0,pa,pb)
			end
			local floored=floor(logA)
			local remainder=logA-floored
			local pa,pb=bv1+floored,bv2+remainder
			if pb>=1 then
				pb-=1
				pa+=1
			end
			return nETN.RawNew(thesign,1,pa,pb)
		elseif blayer==2 then
			--Accuracy will be added in future updates
			return nETN.RawNew(thesign,blayer,bv1,bv2)
		end
		-- add future L0*anything handler
	elseif alayer==1 then
		if blayer==2 then
			local bv=bv1+bv2
			local powBv=pow10(bv1+bv2)
			local preval=powBv+av1
			if preval<MAX_ABSOLUTE_RANGE then
				local pav=preval+av2 if abs(pav)<300 then
					local powPav=pow10(pav)
					local floored=floor(powPav)
					return nETN.RawNew(thesign,0,floored,powPav-floored)
				end
				if preval<=FLOAT_HALF_INT_LIMIT then
					local floored=floor(preval)
					av2+=preval-floored
					preval=floored
					if av2>= 1 then
						av1-=1
						preval+=1
					end
				end
				return nETN.RawNew(thesign,1,preval,av2)
			end
			-- we use gir's method with Twyla cutoffs
			--step 1 calculate girs number and Sign (S)
			local av=av1+av2
			local SIGNS=av<0
			local S=SIGNS and -1 or 1
			local gir=log10(S*av)
			--step 2 calculate the Girian Difference (B1+B2-Gir)
			local Girian_Difference=bv-gir
			--step 3 use the Twyla's number discovered in monster high to see if we need return early :3
			if Girian_Difference>-TWYLAS_NUMBER then
				return nETN.RawNew(thesign,2,bv1,bv2)
			end local bob
			if Girian_Difference<CLAWDEENS_NUMBER and Girian_Difference>CLEO_DENILES_NUMBER then
				bob=1+S+LN10*Girian_Difference
				if bob==0 then
					local mantissa=pow10(av2)
					local floored=floor(mantissa)
					return nETN.RawNew(thesign,0,floored,mantissa-floored)
				end
			else bob=S+pow10(Girian_Difference)end
			--step 4 after that check we apply Gir's Method
			local Result=gir+log10(bob)
			--step 5 we split the result
			local floored=floor(Result)
			return nETN.RawNew(thesign,2,floored,Result-floored)
		end
		-- add future L1*anything handler
	end
end

--Divides two ETNs together like a/b
function nETN.div(a:ValidInput,b:ValidInput):ETN
	a=nETN.convert(a)b=nETN.convert(b)
	
end

return nETN

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
