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

--- <p>Handler f&uuml;r ein einzelnes mb des ISO-10646-Zeichensatzes.</p>
--   Der Programmierer mu&szlig; diese Methode entsprechend
--   &uuml;berladen.
--  @param mb ein mb des ISO-10646-Zeichensatzes in Form einer
--   Zeichenkette
function handle_flow(self, mb)
end

--- <p>Handler</p>
--   Der Programmierer mu&szlig; diese Methode entsprechend
--   &uuml;berladen.
--  @param nr 32bit-Integerwert, der Position eines Zeichens im
--   ISO-10646-Zeichenvorrat angibt.  Dieses Zeichen wird der
--   Methode <code>ml.char.handle_flow</code> &uuml;bergeben.
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
--   <code>ml.char.handle_remaining_entity</code> mu&szlig; ggf.
--   der Programmierer &uuml;berladen.
--  @param tok entity-Bezeichner wie "auml", wie sie in
--   SGML/HTML/XML-Dokumenten als entitys wie &amp;auml; vorkommen.
function handle_remaining_entity(self, tok)
 if     (tok == "nbsp")
 then   self:handle_char(160)
 elseif (tok == "iexcl")
 then   self:handle_char(161)
 elseif (tok == "cent")
 then   self:handle_char(162)
 elseif (tok == "pound")
 then   self:handle_char(163)
 elseif (tok == "curren")
 then   self:handle_char(164)
 elseif (tok == "yen")
 then   self:handle_char(165)
 elseif (tok == "brvbar")
 then   self:handle_char(166)
 elseif (tok == "sect")
 then   self:handle_char(167)
 elseif (tok == "uml")
 then   self:handle_char(168)
 elseif (tok == "copy")
 then   self:handle_char(169)
 elseif (tok == "ordf")
 then   self:handle_char(170)
 elseif (tok == "laquo")
 then   self:handle_char(171)
 elseif (tok == "not")
 then   self:handle_char(172)
 elseif (tok == "shy")
 then   self:handle_char(173)
 elseif (tok == "reg")
 then   self:handle_char(174)
 elseif (tok == "macr")
 then   self:handle_char(175)
 elseif (tok == "deg")
 then   self:handle_char(176)
 elseif (tok == "plusmn")
 then   self:handle_char(177)
 elseif (tok == "sup2")
 then   self:handle_char(178)
 elseif (tok == "sup3")
 then   self:handle_char(179)
 elseif (tok == "acute")
 then   self:handle_char(180)
 elseif (tok == "micro")
 then   self:handle_char(181)
 elseif (tok == "para")
 then   self:handle_char(182)
 elseif (tok == "middot")
 then   self:handle_char(183)
 elseif (tok == "cedil")
 then   self:handle_char(184)
 elseif (tok == "sup1")
 then   self:handle_char(185)
 elseif (tok == "ordm")
 then   self:handle_char(186)
 elseif (tok == "raquo")
 then   self:handle_char(187)
 elseif (tok == "frac14")
 then   self:handle_char(188)
 elseif (tok == "frac12")
 then   self:handle_char(189)
 elseif (tok == "frac34")
 then   self:handle_char(190)
 elseif (tok == "iquest")
 then   self:handle_char(191)
 elseif (tok == "Agrave")
 then   self:handle_char(192)
 elseif (tok == "Aacute")
 then   self:handle_char(193)
 elseif (tok == "Acirc")
 then   self:handle_char(194)
 elseif (tok == "Atilde")
 then   self:handle_char(195)
 elseif (tok == "Auml")
 then   self:handle_char(196)
 elseif (tok == "Aring")
 then   self:handle_char(197)
 elseif (tok == "AElig")
 then   self:handle_char(198)
 elseif (tok == "Ccedil")
 then   self:handle_char(199)
 elseif (tok == "Egrave")
 then   self:handle_char(200)
 elseif (tok == "Eacute")
 then   self:handle_char(201)
 elseif (tok == "Ecirc")
 then   self:handle_char(202)
 elseif (tok == "Euml")
 then   self:handle_char(203)
 elseif (tok == "Igrave")
 then   self:handle_char(204)
 elseif (tok == "Iacute")
 then   self:handle_char(205)
 elseif (tok == "Icirc")
 then   self:handle_char(206)
 elseif (tok == "Iuml")
 then   self:handle_char(207)
 elseif (tok == "ETH")
 then   self:handle_char(208)
 elseif (tok == "Ntilde")
 then   self:handle_char(209)
 elseif (tok == "Ograve")
 then   self:handle_char(210)
 elseif (tok == "Oacute")
 then   self:handle_char(211)
 elseif (tok == "Ocirc")
 then   self:handle_char(212)
 elseif (tok == "Otilde")
 then   self:handle_char(213)
 elseif (tok == "Ouml")
 then   self:handle_char(214)
 elseif (tok == "times")
 then   self:handle_char(215)
 elseif (tok == "Oslash")
 then   self:handle_char(216)
 elseif (tok == "Ugrave")
 then   self:handle_char(217)
 elseif (tok == "Uacute")
 then   self:handle_char(218)
 elseif (tok == "Ucirc")
 then   self:handle_char(219)
 elseif (tok == "Uuml")
 then   self:handle_char(220)
 elseif (tok == "Yacute")
 then   self:handle_char(221)
 elseif (tok == "THORN")
 then   self:handle_char(222)
 elseif (tok == "szlig")
 then   self:handle_char(223)
 elseif (tok == "agrave")
 then   self:handle_char(224)
 elseif (tok == "aacute")
 then   self:handle_char(225)
 elseif (tok == "acirc")
 then   self:handle_char(226)
 elseif (tok == "atilde")
 then   self:handle_char(227)
 elseif (tok == "auml")
 then   self:handle_char(228)
 elseif (tok == "aring")
 then   self:handle_char(229)
 elseif (tok == "aelig")
 then   self:handle_char(230)
 elseif (tok == "ccedil")
 then   self:handle_char(231)
 elseif (tok == "egrave")
 then   self:handle_char(232)
 elseif (tok == "eacute")
 then   self:handle_char(233)
 elseif (tok == "ecirc")
 then   self:handle_char(234)
 elseif (tok == "euml")
 then   self:handle_char(235)
 elseif (tok == "igrave")
 then   self:handle_char(236)
 elseif (tok == "iacute")
 then   self:handle_char(237)
 elseif (tok == "icirc")
 then   self:handle_char(238)
 elseif (tok == "iuml")
 then   self:handle_char(239)
 elseif (tok == "eth")
 then   self:handle_char(240)
 elseif (tok == "ntilde")
 then   self:handle_char(241)
 elseif (tok == "ograve")
 then   self:handle_char(242)
 elseif (tok == "oacute")
 then   self:handle_char(243)
 elseif (tok == "ocirc")
 then   self:handle_char(244)
 elseif (tok == "otilde")
 then   self:handle_char(245)
 elseif (tok == "ouml")
 then   self:handle_char(246)
 elseif (tok == "divide")
 then   self:handle_char(247)
 elseif (tok == "oslash")
 then   self:handle_char(248)
 elseif (tok == "ugrave")
 then   self:handle_char(249)
 elseif (tok == "uacute")
 then   self:handle_char(250)
 elseif (tok == "ucirc")
 then   self:handle_char(251)
 elseif (tok == "uuml")
 then   self:handle_char(252)
 elseif (tok == "yacute")
 then   self:handle_char(253)
 elseif (tok == "thorn")
 then   self:handle_char(254)
 elseif (tok == "yuml")
 then   self:handle_char(255)
 elseif (tok == "quot")
 then   self:handle_char(34)
 elseif (tok == "amp")
 then   self:handle_char(38)
 elseif (tok == "lt")
 then   self:handle_char(60)
 elseif (tok == "gt")
 then   self:handle_char(62)
 elseif (tok == "OElig")
 then   self:handle_char(338)
 elseif (tok == "oelig")
 then   self:handle_char(339)
 elseif (tok == "Scaron")
 then   self:handle_char(352)
 elseif (tok == "scaron")
 then   self:handle_char(353)
 elseif (tok == "Yuml")
 then   self:handle_char(376)
 elseif (tok == "circ")
 then   self:handle_char(710)
 elseif (tok == "tilde")
 then   self:handle_char(732)
 elseif (tok == "ensp")
 then   self:handle_char(8194)
 elseif (tok == "emsp")
 then   self:handle_char(8195)
 elseif (tok == "thinsp")
 then   self:handle_char(8201)
 elseif (tok == "zwnj")
 then   self:handle_char(8204)
 elseif (tok == "zwj")
 then   self:handle_char(8205)
 elseif (tok == "lrm")
 then   self:handle_char(8206)
 elseif (tok == "rlm")
 then   self:handle_char(8207)
 elseif (tok == "ndash")
 then   self:handle_char(8211)
 elseif (tok == "mdash")
 then   self:handle_char(8212)
 elseif (tok == "lsquo")
 then   self:handle_char(8216)
 elseif (tok == "rsquo")
 then   self:handle_char(8217)
 elseif (tok == "sbquo")
 then   self:handle_char(8218)
 elseif (tok == "ldquo")
 then   self:handle_char(8220)
 elseif (tok == "rdquo")
 then   self:handle_char(8221)
 elseif (tok == "bdquo")
 then   self:handle_char(8222)
 elseif (tok == "dagger")
 then   self:handle_char(8224)
 elseif (tok == "Dagger")
 then   self:handle_char(8225)
 elseif (tok == "permil")
 then   self:handle_char(8240)
 elseif (tok == "lsaquo")
 then   self:handle_char(8249)
 elseif (tok == "rsaquo")
 then   self:handle_char(8250)
 elseif (tok == "euro")
 then   self:handle_char(8364)
 elseif (tok == "fnof")
 then   self:handle_char(402)
 elseif (tok == "Alpha")
 then   self:handle_char(913)
 elseif (tok == "Beta")
 then   self:handle_char(914)
 elseif (tok == "Gamma")
 then   self:handle_char(915)
 elseif (tok == "Delta")
 then   self:handle_char(916)
 elseif (tok == "Epsilon")
 then   self:handle_char(917)
 elseif (tok == "Zeta")
 then   self:handle_char(918)
 elseif (tok == "Eta")
 then   self:handle_char(919)
 elseif (tok == "Theta")
 then   self:handle_char(920)
 elseif (tok == "Iota")
 then   self:handle_char(921)
 elseif (tok == "Kappa")
 then   self:handle_char(922)
 elseif (tok == "Lambda")
 then   self:handle_char(923)
 elseif (tok == "Mu")
 then   self:handle_char(924)
 elseif (tok == "Nu")
 then   self:handle_char(925)
 elseif (tok == "Xi")
 then   self:handle_char(926)
 elseif (tok == "Omicron")
 then   self:handle_char(927)
 elseif (tok == "Pi")
 then   self:handle_char(928)
 elseif (tok == "Rho")
 then   self:handle_char(929)
 elseif (tok == "Sigma")
 then   self:handle_char(931)
 elseif (tok == "Tau")
 then   self:handle_char(932)
 elseif (tok == "Upsilon")
 then   self:handle_char(933)
 elseif (tok == "Phi")
 then   self:handle_char(934)
 elseif (tok == "Chi")
 then   self:handle_char(935)
 elseif (tok == "Psi")
 then   self:handle_char(936)
 elseif (tok == "Omega")
 then   self:handle_char(937)
 elseif (tok == "alpha")
 then   self:handle_char(945)
 elseif (tok == "beta")
 then   self:handle_char(946)
 elseif (tok == "gamma")
 then   self:handle_char(947)
 elseif (tok == "delta")
 then   self:handle_char(948)
 elseif (tok == "epsilon")
 then   self:handle_char(949)
 elseif (tok == "zeta")
 then   self:handle_char(950)
 elseif (tok == "eta")
 then   self:handle_char(951)
 elseif (tok == "theta")
 then   self:handle_char(952)
 elseif (tok == "iota")
 then   self:handle_char(953)
 elseif (tok == "kappa")
 then   self:handle_char(954)
 elseif (tok == "lambda")
 then   self:handle_char(955)
 elseif (tok == "mu")
 then   self:handle_char(956)
 elseif (tok == "nu")
 then   self:handle_char(957)
 elseif (tok == "xi")
 then   self:handle_char(958)
 elseif (tok == "omicron")
 then   self:handle_char(959)
 elseif (tok == "pi")
 then   self:handle_char(960)
 elseif (tok == "rho")
 then   self:handle_char(961)
 elseif (tok == "sigmaf")
 then   self:handle_char(962)
 elseif (tok == "sigma")
 then   self:handle_char(963)
 elseif (tok == "tau")
 then   self:handle_char(964)
 elseif (tok == "upsilon")
 then   self:handle_char(965)
 elseif (tok == "phi")
 then   self:handle_char(966)
 elseif (tok == "chi")
 then   self:handle_char(967)
 elseif (tok == "psi")
 then   self:handle_char(968)
 elseif (tok == "omega")
 then   self:handle_char(969)
 elseif (tok == "thetasym")
 then   self:handle_char(977)
 elseif (tok == "upsih")
 then   self:handle_char(978)
 elseif (tok == "piv")
 then   self:handle_char(982)
 elseif (tok == "bull")
 then   self:handle_char(8226)
 elseif (tok == "hellip")
 then   self:handle_char(8230)
 elseif (tok == "prime")
 then   self:handle_char(8242)
 elseif (tok == "Prime")
 then   self:handle_char(8243)
 elseif (tok == "oline")
 then   self:handle_char(8254)
 elseif (tok == "frasl")
 then   self:handle_char(8260)
 elseif (tok == "weierp")
 then   self:handle_char(8472)
 elseif (tok == "image")
 then   self:handle_char(8465)
 elseif (tok == "real")
 then   self:handle_char(8476)
 elseif (tok == "trade")
 then   self:handle_char(8482)
 elseif (tok == "alefsym")
 then   self:handle_char(8501)
 elseif (tok == "larr")
 then   self:handle_char(8592)
 elseif (tok == "uarr")
 then   self:handle_char(8593)
 elseif (tok == "rarr")
 then   self:handle_char(8594)
 elseif (tok == "darr")
 then   self:handle_char(8595)
 elseif (tok == "harr")
 then   self:handle_char(8596)
 elseif (tok == "crarr")
 then   self:handle_char(8629)
 elseif (tok == "lArr")
 then   self:handle_char(8656)
 elseif (tok == "uArr")
 then   self:handle_char(8657)
 elseif (tok == "rArr")
 then   self:handle_char(8658)
 elseif (tok == "dArr")
 then   self:handle_char(8659)
 elseif (tok == "hArr")
 then   self:handle_char(8660)
 elseif (tok == "forall")
 then   self:handle_char(8704)
 elseif (tok == "part")
 then   self:handle_char(8706)
 elseif (tok == "exist")
 then   self:handle_char(8707)
 elseif (tok == "empty")
 then   self:handle_char(8709)
 elseif (tok == "nabla")
 then   self:handle_char(8711)
 elseif (tok == "isin")
 then   self:handle_char(8712)
 elseif (tok == "notin")
 then   self:handle_char(8713)
 elseif (tok == "ni")
 then   self:handle_char(8715)
 elseif (tok == "prod")
 then   self:handle_char(8719)
 elseif (tok == "sum")
 then   self:handle_char(8721)
 elseif (tok == "minus")
 then   self:handle_char(8722)
 elseif (tok == "lowast")
 then   self:handle_char(8727)
 elseif (tok == "radic")
 then   self:handle_char(8730)
 elseif (tok == "prop")
 then   self:handle_char(8733)
 elseif (tok == "infin")
 then   self:handle_char(8734)
 elseif (tok == "ang")
 then   self:handle_char(8736)
 elseif (tok == "and")
 then   self:handle_char(8743)
 elseif (tok == "or")
 then   self:handle_char(8744)
 elseif (tok == "cap")
 then   self:handle_char(8745)
 elseif (tok == "cup")
 then   self:handle_char(8746)
 elseif (tok == "int")
 then   self:handle_char(8747)
 elseif (tok == "there4")
 then   self:handle_char(8756)
 elseif (tok == "sim")
 then   self:handle_char(8764)
 elseif (tok == "cong")
 then   self:handle_char(8773)
 elseif (tok == "asymp")
 then   self:handle_char(8776)
 elseif (tok == "ne")
 then   self:handle_char(8800)
 elseif (tok == "equiv")
 then   self:handle_char(8801)
 elseif (tok == "le")
 then   self:handle_char(8804)
 elseif (tok == "ge")
 then   self:handle_char(8805)
 elseif (tok == "sub")
 then   self:handle_char(8834)
 elseif (tok == "sup")
 then   self:handle_char(8835)
 elseif (tok == "nsub")
 then   self:handle_char(8836)
 elseif (tok == "sube")
 then   self:handle_char(8838)
 elseif (tok == "supe")
 then   self:handle_char(8839)
 elseif (tok == "oplus")
 then   self:handle_char(8853)
 elseif (tok == "otimes")
 then   self:handle_char(8855)
 elseif (tok == "perp")
 then   self:handle_char(8869)
 elseif (tok == "sdot")
 then   self:handle_char(8901)
 elseif (tok == "lceil")
 then   self:handle_char(8968)
 elseif (tok == "rceil")
 then   self:handle_char(8969)
 elseif (tok == "lfloor")
 then   self:handle_char(8970)
 elseif (tok == "rfloor")
 then   self:handle_char(8971)
 elseif (tok == "lang")
 then   self:handle_char(9001)
 elseif (tok == "rang")
 then   self:handle_char(9002)
 elseif (tok == "loz")
 then   self:handle_char(9674)
 elseif (tok == "spades")
 then   self:handle_char(9824)
 elseif (tok == "clubs")
 then   self:handle_char(9827)
 elseif (tok == "hearts")
 then   self:handle_char(9829)
 elseif (tok == "diams")
 then   self:handle_char(9830)
 end
end

--- <p>Handler</p>
--  @param tok entity-Bezeichner wie "auml", wie sie in
--   SGML/HTML/XML-Dokumenten als entitys wie &amp;auml; vorkommen.
--   Entities, die hier nicht behandelt werden, werden in der Methode
--   <code>ml.char.handle_remaining_entity</code> behandelt, die ggf.
--   der Programmierer entsprechend &uuml;berladen mu&szlig;.
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
 else   self:handle_remaining_entity(tok)
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
--   Wird dieser Parameter nicht angegeben, gilt <code>source = self</code>.
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
