---@class Complex # Complex number class
---@field real number # real part of a complex number
---@field imagin number # imagin part of a complex number
local Complex = {}

---@return Complex?
local function convert_to_complex(a)
    if type(a) == "table" then
        return Complex:new(a.real,a.imagin)
    elseif type(a) == "number" then
        return Complex:new(a,0)
    end
end

---Create a new complex number
---@param real number?
---@param imagin number?
---@return Complex
function Complex.new(self,real,imagin)
    local num = setmetatable({},self)
    num.real = real or 0
    num.imagin = imagin or 0
    return num
end

--- calculate squared module of the complex number. return  an error if input cannot be convert into complex number
---@param self Complex | number
---@return number?
---@return string? #error log
function Complex.sqr_len(self)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end

    return self.real^2 + self.imagin^2
end

---calculate conjugation of complex number
---@param self  Complex | number
---@return Complex?
---@return string? #error log
function Complex.conjugate(self)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end

    return Complex:new(self.real,-self.imagin)
end

---calculate module of the complex number
---@param self Complex | number
---@return number?
---@return string? #error log
function Complex.len(self)
    local self = convert_to_complex(self)
    if not self then return nil,"agument is not a number" end

    return  math.sqrt(Complex.sqr_len(self) or 1)
end



--- multiply two complex numbers
---@param a Complex | number
---@param b Complex | number
---@return Complex?
---@return string? #error log
function Complex.__mul(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end

    return Complex:new(a.real*b.real - a.imagin*b.imagin , a.real*b.imagin + a.imagin*b.real)
end

--- summ two complex numbers
---@param a Complex | number
---@param b Complex | number
---@return Complex?
---@return string? #error log
function Complex.__add(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end

    return Complex:new(a.real + b.real , a.imagin + b.imagin)
end

--- subtract first complex number from second one
---@param a Complex | number
---@param b Complex | number
---@return Complex?
---@return string? #error log
function Complex.__sub(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end
    
    return Complex:new(a.real - b.real,a.imagin - b.imagin)
end


---@param a Complex | number
---@return Complex?
---@return string? #error log
function Complex.__unm(a)
    local a = convert_to_complex(a)
    if not a then return nil,"agument is not a number" end
    return Complex:new(-a.real,-a.imagin)
end

--- divide first complex number from second one
---@param a Complex | number
---@param b Complex | number
---@return Complex?
---@return string? #error log
function Complex.__div(a,b)
    local a = convert_to_complex(a)
    local b = convert_to_complex(b)
    if not a or not b then return nil,"agument is not a number" end

    local b_sqr_len = Complex.sqr_len(b)
    local real = a.real*b.real + a.imagin*b.imagin
    local imagin = a.imagin*b.real- a.real*b.imagin 
    return  Complex:new(real/b_sqr_len,imagin/b_sqr_len)
end


function Complex.__tostring(self)
    return string.format("( %s , %s )",self.real,self.imagin)
end

return Complex