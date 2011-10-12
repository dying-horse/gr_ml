require "gr_unicode"
local acceptor     = unicode.acceptor
local ml           = ml
local setmetatable = setmetatable
local tostring     = tostring


--- <p>Unterklasse der Klasse
--   <a href="/modules/ml.char.html">ml.char</a></p>
--   Mit Hilfe dieser Klasse k&ouml;nnen Objekte der Klasse
--   <code>source</code>, s. Paket <code>gr_source</code> in
--   Zeichenketten des ISO-10646-Zeichensatzes umgewandelt.
--   Dabei werden entitys wie &quot;&amp;auml;&quot;, &quot;&amp;#x...&quot;;
--   etc. wie in SGML/HTML/XML erforderlich, umgewandelt.
module "ml.string"

--- <p>Handler f&uuml;r ein einzelnes mb des ISO-10646-Zeichensatzes.</p>
--  @param mb ein mb des ISO-10646-Zeichensatzes in Form einer
--   Zeichenkette
function handle_flow(self, mb)
 self.accu = self.accu .. tostring(mb)
end

--- <p>Mit Hilfe dieser Methode kann die gewonnene Zeichenkette
--   gelesen werden.</p>
--  @return die Zeichenkette im ISO-10646-Zeichensatz
function get(self)
 local ret = self:next()
 while (ret ~= "stop")
 do    ret = self:char_or_ent()
       if     (ret == "no")
       then   ret = self:cur_char()
       elseif (ret == "unclosed")
       then   return self.accu
       end
 end

 return self.accu
end

--- <p>erzeugt ein Objekt der Klasse
--   <a href="/modules/ml.string.html">ml.string</a></p>
-- @param source Objekt der Klasse <code>source</code>, das in
--  Zeichenkette umgewandelt werden soll.
-- @param opt (optional) enth&auml;lt optionale Parameter.  Sie
--  entsprechen denen der Methode
--  <a href="/modules/ml.char.html#new">ml.char.new</a>; s. dort.
-- @return besagtes Objekt
function new(self, source, opt)
 local ret = ml.char.new(self, source, opt)
 ret.accu  = ""
 setmetatable(ret, { __index = self })
 return ret
end

