Allgemeine Hinweise:

* Nutzer, die dieses lua-Modul nur installieren wollen, gehen dabei am
  besten so wie [hier](https://github.com/dying-horse/gr_rocks/#readme)
  beschrieben vor.
* Mehr Dokumentation gibt es, wenn man im Basis-Verzeichnis
  `luadoc .` aufruft.  Hierzu benötigt man das
  [luadoc](http://keplerproject.github.com/luadoc/)-System, das man sich
  mit Hilfe von [luarocks](http://luarocks.org/) beschaffen kann:
  `luarocks install luadoc`.



Das Paket `gr_ml` wird mit folgender Anweisung aktiviert:

	require "gr_ml"


Das Paket `gr_ml` enthält drei Klassen:

* Die Klasse `ml.char`.  Sie ist eine Unterklasse der Klasse
  `unicode.acceptor` aus dem
  [`gr_unicode`-Paket](https://github.com/dying-horse/gr_unicode).
  Die Objekte dieser Klasse wandeln wc aus einer Quelle, d.h.
  einem Objekt der
  [im `gr_source`-Paket definierten `source`-Klasse](https://github.com/dying-horse/gr_source)
  in Zeichen des ISO-10646-Zeichensatzes um.  Dabei werden
  char-refs und entitys aufgelöst.  Die Methode
  `ml.char.handle_flow` muß dementsprechend mit einer Funktion
  überladen werden, der diese Zeichen als Argument übergeben wird.
* Die Klasse `ml.string`.  Sie ist eine Unterklasse der Klasse
  `ml.char`.  Ähnlich wie `ml.char`, setzt die empfangenen Zeichen
  aber zu einer ISO-10646-Zeichenkette zusammen, s. Beispiel unten.
* Die Klasse `ml.parse`.  Sie ist eine weitere Unterklasse
  der Klasse `ml.char`.  Die Objekte dieser Klasse interpretieren
  HTML-Code.  Die handler müssen entsprechen überladen werden.


Anwendungsbeispiel für die Klasse `ml.string`
=============================================


	require "gr_ml"
	require "gr_source"

	-- stellt den Zeichensatz entsprechend des
	-- gültigen locales ein.
	os.setlocale("")

	-- erzeugt ein Objekt str der Klasse ml.string
	-- Die Quelle bildet die Datei "irgendeine.datei"
	str = ml.string:new(source.file:new("irgendeine.datei"))

	-- schreibt den Inhalt in eine
	-- andere Datei "irgendeineandere.datei".
	-- Er wurde in den ISO-10646-Zeichensatz
	-- konvertiert und char-refs
	-- sowie entitys wurden aufgelöst.
	fd = io.open("irgendeineandere.datei", "w")
	fd:write(str:get())
	fd:close()
