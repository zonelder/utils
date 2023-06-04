---@class ComplexClass
---@operator call(number):Complex
local Complex_class = {}

---@class Complex : ComplexClass # Complex number class
---@operator add:Complex
---@operator sub:Complex
---@operator unm:Complex
---@operator mul:Complex
---@operator div:Complex
local ComplexNumber = {}



---@return Complex?
local function convert_to_complex(a)
    if type(a) == "table" then
        return setmetatable(a,ComplexNumber)
    elseif type(a) == "number" then
        return Complex_class.new(a,0)
    end
end

---Create a new complex number
---@param real number?
---@param imagin number?
---@return Complex
function Complex_class.new(real,imagin)
    local num = setmetatable({},ComplexNumber)
    num[1] = real or 0
    num[2] = imagin or 0
    return num
end

--- calculate squared module of the complex number. return  an error if input cannot be convert into complex number
---@param self Complex | number[]
---@return number?
---@return string? #error log
function Complex_class.sqr_len(self)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end

    return self[1]^2 + self[2]^2
end

---calculate conjugation of complex number
---@param self  Complex | number[]
---@return Complex?
---@return string? #error log
function Complex_class.conjugate(self)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end

    return Complex_class.new(self[1],-self[2])
end

---get\set module of the complex number
---@param self Complex | number[]
---@param value number?
---@return number?
---@return string? #error log
function Complex_class.len(self,value)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end
    if value then
        local m = value/self:len()
        self[1] = self[1]*m
        self[2] = self[2]*m
        return value
    end
    return  math.sqrt(Complex_class.sqr_len(self) or 1)
end

--- return angle of the number
---@param self Complex | number[]
---@param value number? # new value in radians for angle
---@return number?
---@return string? #error log
function Complex_class.Fi(self,value)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end
    local len  = self:len()
    if value then
        self[1] = len*math.cos(value)
        self[2] = len*math.sin(value)
        return value
    end
    return math.acos(self[1]/len)
end


--- get\set real part of the number
---@param self Complex | number[]
---@param value number? # new value for real part
---@return number?
---@return string? #error log
function Complex_class.Re(self,value)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end
    if value then self[1] = value end
    return self[1]
end

--- get\set imagin of the number
---@param self Complex | number[]
---@param value number? # new value for imagin part
---@return number?
---@return string? #error log
function Complex_class.Im(self,value)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end
    if value then self[2] = value end
    return self[2]
end


--- multiply two complex numbers
---@param a Complex | number[]
---@param b Complex | number[]
---@return Complex?
---@return string? #error log
function ComplexNumber.__mul(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end

    return Complex_class.new(a[1]*b[1] - a[2]*b[2] , a[1]*b[2] + a[2]*b[1])
end

--- summ two complex numbers
---@param a Complex | number[]
---@param b Complex | number[]
---@return Complex?
---@return string? #error log
function ComplexNumber.__add(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end

    return Complex_class.new(a[1] + b[1] , a[2] + b[2])
end

--- subtract first complex number from second one
---@param a Complex | number[]
---@param b Complex | number[]
---@return Complex?
---@return string? #error log
function ComplexNumber.__sub(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end
    
    return Complex_class.new(a[1] - b[1],a[2] - b[2])
end


---@param a Complex | number[]
---@return Complex?
---@return string? #error log
function ComplexNumber.__unm(a)
    local a = convert_to_complex(a)
    if not a then return nil,"agument is not a number" end
    return Complex_class.new(-a[1],-a[2])
end

--- divide first complex number from second one
---@param a Complex | number[]
---@param b Complex | number[]
---@return Complex?
---@return string? #error log
function ComplexNumber.__div(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end

    local b_sqr_len = Complex_class.sqr_len(b)
    local real = a[1]*b[1] + a[2]*b[2]
    local imagin = a[2]*b[1]- a[1]*b[2] 
    return  Complex_class.new(real/b_sqr_len,imagin/b_sqr_len)
end


function ComplexNumber.__tostring(self)
    return string.format("( %s , %s )",self[1],self[2])
end

--- if number dont provide method it seek same in own class
---@return ComplexClass
function ComplexNumber.__index(self,key)
    return Complex_class[key]
end


return setmetatable(Complex_class,{
    __call = function (self,a,b)
    return Complex_class.new(a,b)
end})