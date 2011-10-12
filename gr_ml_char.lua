require "bit32"
require "gr_iconv"
require "gr_langinfo"
require "gr_unicode"
local acceptor     = unicode.acceptor
local bit32        = bit32
local codeset      = langinfo.codeset
local iconv        = iconv
local setmetatable = setmetatable
local source       = source
local string       = string
local tostring     = tostring
local towc         = unicode.towc


--- <p>Unterklasse der Klasse <code>unicode.acceptor</code></p>
module "ml.char"

--- <p>erzeugt ein Objekt der Klasse
--   <a href="/modules/ml.char.html">ml.char</a></p>
--  @param source Objekt der Klasse <code>source</code>, das wc vom
--   Typ <code>gr_unicode_wc</code> auswirft.  Der von dieser Funktion
--   bereitgestellte Parser wird dann mit diesen wc gef&uuml;ttert.
--  @param opt (optional) &uuml;bergibt optionale Parameter
--   <ul>
--    <li>Schlu&uuml;ssel <code>iconv_out</code>:  ein Objekt der
--     Klasse <code>iconv</code> aus dem Package <code>gr_iconv</code>.
--     Gew&ouml;hnlich werden Objekte von Unterklassen dieser
--     Klasse hier &uuml;bergenen, bei der die fehleranzeigenden
--     Methoden <code>except_...</code> durch geeignete
--     Fehlerbehandlungsroutinen &uuml;berladen werden.</li>
--   </ul>
--  @return besagtes Objekt der Klasse
--   <a href="/modules/ml.char.html">ml.char</a>
function new(self, source, opt)
 local ret = acceptor.new(self, source)
 ret.opt = opt or {}
 ret.iconv_out = ret.opt.iconv_out or iconv:new()

 local status = ret.iconv_out:open(codeset(), "ISO-10646")
 while  (status == "pull")
 do     ret:handle_flow(ret.iconv_out:pull())
        status = ret.iconv_out:go()
 end

 return ret
end

--- <p>Handler</p>
--  @param nr 32bit-Integerwert, der Position eines Zeichens im
--   ISO-10646-Zeichenvorrat angibt.  Dieses Zeichen wird der
--   Methode <code>ml.char.handle_flow</code> &uuml;bergeben.
--   Der Programmierer mu&szlig; diese Methode entsprechend
--   &uuml;berladen.
function handle_char(self, nr)
 local n = nr
 local accu = ""

 for i = 1,4
 do  accu = string.char(bit32.band(n, 255)) .. accu
     n = bit32.rshift(n, 8)
 end

 self:handle_flow(accu)
end

--- <p>Handler</p>
--  @param tok entity-Bezeichner wie "auml", wie sie in
--   SGML/HTML/XML-Dokumenten als entitys wie &amp;auml; vorkommen.
--   Die meisten entity-Bezeichner werden von der Methode
--   <code>ml.char-handle_remainig_entity</code> behandelt, die
--   der Programmierer entsprechen &uuml;berladen mu&szlig;.
function handle_entity(self, tok)
 if     (tok == "amp")
 then   self:handle_char(38)
 elseif (tok == "apos")
 then   self:handle_char(39)
 elseif (tok == "gt")
 then   self:handle_char(62)
 elseif (tok == "lt")
 then   self:handle_char(60)
 elseif (tok == "quot")
 then   self:handle_char(34)
 else   self:handle_remaining_entity(self, tok)
 end
end

--- <p>Hilfsroutine, nicht direkt aufrufen!</p>
function char_or_ent(self)
 local ret = self:sc("&")
 if     (ret == "no")
 then   return "no"
 elseif (ret == "stop")
 then   return "unclosed"
 end

 ret = self:sc("#")
 if     (ret == "stop")
 then   self:ascii_char(0)
        return "stop"
 elseif (ret == "go")
 then   -- &#
        ret = self:sc("x")
        local nr
        if     (ret == "stop")
        then   self:ascii_char(0)
               return "stop"
        elseif (ret == "go")
        then   -- &#x
               ret, nr = self:hexnr()
        else   ret, nr = self:decnr()
        end
        self:handle_char(nr)
        if     (ret == "stop")
        then   return "stop"
        end
 else   local tok
        ret, tok = self:name()
        if     (ret == "no")
        then   tok = ""
        end
        self:handle_entity(tok)
        if     (ret == "stop")
        then   return "stop"
        end
 end
 ret = self:sc(';')
 if     (ret == "stop")
 then   return "stop"
 else   return "go"
 end
end

--- <p>wandelt das am Acceptor liegende Zeichen in den
--   ISO-10646-Zeichensatz um, und ruft dann die Methode
--   <code>ml.char.handle_flow</code> auf, die vom Programmierer
--   entsprechend &uuml;berladen werden mu&szlig;.  Danach r&uuml;ckt
--   der Acceptor eine Position weiter.
--  @param (optional) Objekt der Klasse <code>source</code> aus dem Paket
--   <code>gr_source</code>.  Dieses Objekt mu&szlig; wc auswerfen
--   vom Typ <code>gr_unicode_wc</code>, s. Paket <code>gr_unicode</code>
--   Wird dieser Parameter nicht angegen, gilt <code>source = self</code>.
--  @return eine der folgenden Zeichenketten
--   <ul>
--    <li><code>"stop"</code>es gibt keine Zeichen mehr, die der Acceptor
--     lesen k&ouml;nnte</li>
--    <li><code>"go"</code> sonst</li>
--   </ul>
function cur_char(self, source)
 local ret
 local src = source or self
 repeat
 do     self.iconv_out:push(tostring(src:cur()))
        local status = self.iconv_out:go()
        while (status == "pull")
        do    self:handle_flow(self.iconv_out:pull())
              status = self.iconv_out:go()
        end

        if    (status == "ok")
        then  self:handle_flow(self.iconv_out:pull())
        end

        ret = src:next()
        if    (ret == "stop")
        then  return "stop"
        end
 end
 until  (status ~= "push")

 return ret
end

--- <p>Wandelt ein einzelnes mb in den ISO-10646-Zeichensatz um,
--   und &uuml;bergibt es der Methode
--   <code>ml.char.handle_flow</code>.  Diese Methode mu&szlig;
--   vom Programmierer &uuml;berladen werden.</p>
--  @param str das mb als Zeichenkette
--  @return eine der folgenden Zeichenketten
--   <ul>
--    <li><code>"stop"</code>es gibt keine Zeichen mehr, die der Acceptor
--     lesen k&ouml;nnte</li>
--    <li><code>"go"</code> sonst</li>
--   </ul>
function feed_flow(self, str)
 local src = source.str:new(str)
 local ret = src:next()
 if     (ret == "stop")
 then   return "stop"
 end
 return self:cur_char(src)
end
