require "gr_ml_char"
require "gr_ml_parse"
require "gr_ml_string"
require "gr_unicode"
setmetatable(ml.char,   { __index = unicode.acceptor })
setmetatable(ml.parse,  { __index = ml.char })
setmetatable(ml.string, { __index = ml.char })
