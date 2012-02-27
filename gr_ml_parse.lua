require "gr_ml_string"
require "gr_unicode"
require "gr_source"
local acceptor       = unicode.acceptor
local ml             = ml
local setmetatable   = setmetatable
local source         = source
local tostring       = tostring
local unicode        = unicode


--- <p>Unterklasse der Klasse
--   <a href="/modules/ml.char.html">ml.char</a></p>
module "ml.parse"


isspecial = false

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r decls, also
--  so etwas: &quot;&lt;!...&gt;&quot;</p>
--  @param str der Text zwischen &quot;&lt;!&quot; und
--   &quot;&gt;&quot;
function handle_decl(self, str)
end

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r Kommentare, also
--  so etwas: &quot;&lt;!--...--&gt;&quot;</p>
--  @param str der Text zwischen &quot;&lt;!--&quot; und
--   &quot;--&gt;&quot;
function handle_comment(self, str)
end

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r pis, also
--  so etwas: &quot;&lt;?...&gt;&quot;</p>
--  @param str der Text zwischen &quot;&lt;?&quot; und
--   &quot;&gt;&quot;
function handle_pi(self, str)
end

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r cdatas, also
--  so etwas: &quot;&lt;![CDATA[...]]&gt;&quot;</p>
--  @param str der Text zwischen &quot;&lt;![CDATA[&quot; und
--   &quot;]]&gt;&quot;
function handle_cdata(self, str)
end

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r starttags</p>
--  <p>Man beachte bitte, da&szlig; f&uuml;r die Tags <code>script</code>
--   und <code>style</code> notwendig sind.  Beim &Uuml;berladen
--   sollte diese Methode von der Unterklasse aus aufgerufen werden.</p>
--  @param tag der tag in Kleinbuchstaben als Zeichenkette
--  @param attrs table mit Attributen als Schl&uuml;ssel in Form
--   von Zeichenketten und den diesen Attributen zugewiesenen Werten
--   als zu diesen Schl&uuml;sseln eingetragene Werte in Form von
--   Zeichenketten
function handle_starttag(self, tag, attrs)
 if     (tag == "script" or tag == "style")
 then   self.isspecial = true
 end
end

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r stoptags</p>
--  <p>Man beachte bitte, da&szlig; f&uuml;r die Tags <code>script</code>
--   und <code>style</code> notwendig sind.  Beim &Uuml;berladen
--   sollte diese Methode von der Unterklasse aus aufgerufen werden.</p>
--  @param tag der tag in Kleinbuchstaben als Zeichenkette
function handle_stoptag(self, tag)
 if     (tag == "script" or tag == "style")
 then   self.isspecial = false
 end
end

--- <p>Zum &Uuml;berladen bestimmter Handler f&uuml;r startstoptags,
--  also mit stoptags kombinierte starttags, wie sie in XML
--  &uuml;blich sind</p>
--  @param tag der tag in Kleinbuchstaben als Zeichenkette
--  @param attrs table mit Attributen als Schl&uuml;ssel in Form
--   von Zeichenketten und den diesen Attributen zugewiesenen Werten
--   als zu diesen Schl&uuml;sseln eingetragene Werte in Form von
--   Zeichenketten
function handle_startstoptag(self, tag, attrs)
 self:handle_starttag(tag, attrs)
 self:handle_stoptag(tag)
end

--- <p><code>unicode.acceptor.namestartchar</code> wurde hier
--   &uuml;berladen; s. dort im Paket <code>gr_unicode</code>.</p>
function namestartchar(self)
 local ret, wc = acceptor.namestartchar(self)
 if     (wc)
 then   return ret, unicode.tolower(wc)
 else   return ret
 end
end

--- <p><code>unicode.acceptor.namechar</code> wurde hier
--   &uuml;berladen; s. dort im Paket <code>gr_unicode</code>.</p>
function namechar(self)
 local ret, wc = acceptor.namechar(self)
 if     (wc)
 then   return ret, unicode.tolower(wc)
 else   return ret
 end
end

--- <p>Nicht direkt aufrufen!</p>
function no_space_nor_closing_par(self)
 local accu = ""

 while true
 do    if     (unicode.isspace(self:cur()))
       then   return "go", accu
       end

       if     (self:cur() == unicode.towc(">"))
       then   return "go", accu
       end

       accu = accu .. tostring(self:cur())

       local ret = self:next()
       if     (ret == "stop")
       then   return "stop", accu
       end
 end
end

--- <p>Parser f&uuml;r Attributwerte in Tags</p>
--  <p>s. Beschreibung <code>unicode.acceptor</code></p>
--  @return eine der Zeichenketten
--   <ul>
--    <li><code>"no"</code>am Acceptor liegt kein Attributwert an</li>
--    <li><code>"stop"</code>am Acceptor liegt ein Attributwert an.
--     Nun gibt es aber keine Zeichen mehr f&uuml;r den Acceptor.</li>
--    <li><code>"unclosed"</code>der am Acceptor anliegende
--     Attributwert ist unvollst&auml;ndig.  Der Acceptor hat alle Zeichen
--     verbraucht.</li>
--    <li><code>"go"</code> sonst</li>
--   </ul>
--  @return Diesen R&uuml;ckgabewert gibt es nur, wenn der erste nicht
--   <code>"no"</code> betrug.  Er gibt den gelesenen Attributwert ohne
--   die einschlie&szlig;enden Anf&uuml;hrungszeichen in Form einer
--   ISO-10646-Zeichenkette zur&uuml;ck.
function attr_val(self)
 local ret, accu = self:anyqstr()
 if     (ret == "no")
 then   ret, accu = self:no_space_nor_closing_par()
 end

 return ret, accu
end

--- <p>Soll nicht direkt vom Programmierer aufgerufen werden.</p>
function char_or_ent(self)
 if    (self.isspecial)
 then  return "no"
 end

 return ml.char.char_or_ent(self)
end

--- <p>Sollte nicht direkt vom Programmierer aufgerufen werden.</p>
function partial_string(self, cs)
 local ccs = cs
 local cc
 local crem = ""

 while true
 do    if     (ccs == "")
       then   return "go", crem
       end

       cc  = ccs:sub(1, 1)
       ccs = ccs:sub(2)

       if     (self:cur() ~= unicode.towc(cc))
       then   return "break", crem
       end

       crem = crem .. cc

       ret = self:next()
       if     (ret == "stop")
       then   return "unclosed", crem
       end

 end
  
end
 
--- <p>Sollte nicht direkt vom Programmierer aufgerufen werden.</p>
function cdata_or_comment_or_decl(self)
 local ret, pstr = self:partial_string('--')
 local accu
 if     (ret == "unclosed")
 then   return "unclosed"
 elseif (ret == "go")
 then   ret, accu = self:stopped_str('-->')
        self:handle_comment(accu)
        return ret, accu
 end

 if     (pstr == "")
 then   ret, pstr = self:partial_string('[cdata[')
        if     (ret == "unclosed")
        then   return "unclosed"
        elseif (ret == "go")
        then   ret, accu = self:stopped_str(']]>')
               self:handle_cdata(accu)
               return ret, accu
        end
 end

 ret, accu = self:stopped_str('>')
 accu = pstr .. accu
 self:handle_decl(accu)
 return ret, accu
end

function starttag(self)
 local ret

 ret = self:skipspace()
 if     (ret == "stop")
 then   return "unclosed"
 end

 local tag
 ret, tag = self:space_after(self:name())
 if     (ret ~= "go")
 then   return "unclosed"
 end

 local attrs = {}
 while true
 do    ret = self:sc('/')
       if     (ret == "stop")
       then   return "unclosed"
       elseif (ret == "go")
-- 'self:sc('>')' kann man hier nicht verwenden.
-- Nach "<meta http-equiv='Content-Type' content='text/html; charset=...'>"
-- muß das System ja den Zeichensatz neu einstellen können,
-- bevor das erste Zeichen gelesen wird.
       then   while (self:cur() ~= unicode.towc('>'))
              do    local ret = self:next()
                    if     (ret == "stop")
                    then   return "unclosed"
                    end
              end
              self:handle_startstoptag(tag, attrs)
              return self:next()
       end

-- Hier gilt das gleiche.
       if     (self:cur() == unicode.towc('>'))
       then   self:handle_starttag(tag, attrs)
              return self:next()
       end

       local key, val
       ret, key = self:space_after(self:name())
       if     (ret == "stop")
       then   return "unclosed"
       elseif (ret == "no")
       then   key = ""
       end

       ret = self:space_after(self:sc('='))
       if     (ret == "stop")
       then   return "unclosed"
       end

       ret, val = self:space_after(self:attr_val())
       if     (ret == "stop")
       then   return "unclosed"
       end

       local mlstring = ml.string:new(
        unicode.source:new(
         source.str:new(val) ))

       attrs[key] = mlstring:get()

 end

end

--- <p>Sollte nicht direkt vom Programmierer aufgerufen werden.</p>
function markup_mode(self)
 local ret = self:sc('<')
 if     (ret == "no")
 then   return "no"
 elseif (ret == "stop")
 then   return "unclosed"
 end

 local accu

 ret = self:sc('?')
 if     (ret == "stop")
 then   return "unclosed"
 elseif (ret == "go")
 then   -- <?
        if     (self.isspecial)
        then   self:feed_flow("<")
               self:feed_flow("?")
               return "special"
        end
        ret, accu = self:stopped_str('>')
        if (ret == "unclosed")
        then   return "unclosed"
        end
        self:handle_pi(accu)
        return ret
 end

 ret = self:space_after(self:sc('/'))
 if     (ret == "stop")
 then   return "unclosed"
 elseif (ret == "go")
 then   -- </
        ret, accu = self:name()
        if     (ret == "stop")
        then   return "unclosed"
        end
        self:handle_stoptag(accu)
        ret, accu = self:stopped_str('>')
        return ret
 end

 ret = self:sc('!')
 if     (ret == "stop")
 then   return "unclosed"
 elseif (ret == "go")
 then   -- <!
        if     (self.isspecial)
        then   self:feed_flow("<")
               self:feed_flow("!")
               return "special"
        end
        return self:cdata_or_comment_or_decl()
 end

 -- < .

 if    (self.isspecial)
 then  self:feed_flow("<")
       return "special"
 end
 return self:starttag()

end

--- <p>Startet das Parsen von SGML/HTML/XML-Dokumenten</p>
function parse(self)
 local ret = self:next()
 if     (ret ~= "go")
 then   return ret
 end

 while true
 do    ret = self:char_or_ent()
       if     (ret == "stop")
       then   return "stop"
       elseif (ret == "unclosed")
       then   return "unclosed"
       elseif (ret == "no")
       then   ret = self:markup_mode()
              if     (ret == "stop")
              then   return "stop"
              elseif (ret == "unclosed")
              then   return "unclosed"
              elseif (ret == "no")
              then   ret = self:cur_char()
                     if     (ret == "stop")
                     then   return "stop"
                     end
              end
       end
 end
end
