(:Zad. 26:)

(:for $k in doc('file:///C:/Users/48792/Downloads/XPath-XSLT/swiat.xml')/SWIAT/KONTYNENTY/KONTYNENT:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:Zad. 27:)

(:for $k in doc('file:///C:/Users/48792/Downloads/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:Zad 28:)

(:for $k in doc('file:///C:/Users/48792/Downloads/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA,'A')]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:Zad 29:)

(:for $k in doc('file:///C:/Users/48792/Downloads/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA,substring(STOLICA, 1,1))]:)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:Zad 30:)

(:doc('file:///C:/Users/48792/Downloads/XPath-XSLT/swiat.xml')//KRAJ:)

(:Zad 31:)

(:doc('file:///C:/Users/48792/Downloads/XPath-XSLT/zesp_prac.xml'):)

(:Zad 32:)

(:doc('file:///C:/Users/48792/Downloads/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)

(:Zad 33:)

(:doc('file:///C:/Users/48792/Downloads/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA='SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO:)

(:Zad 34:)

(:count(doc('file:///C:/Users/48792/Downloads/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=10]/PRACOWNICY/ROW):)

(:Zad 35:)

(:doc('file:///C:/Users/48792/Downloads/XPath-XSLT/zesp_prac.xml')//ROW[ID_SZEFA='100']/NAZWISKO:)

(:Zad 36:)

(:sum(doc('file:///C:/Users/48792/Downloads/XPath-XSLT/zesp_prac.xml')//ROW[PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP=ID_ZESP]/PRACOWNICY/ROW/PLACA_POD):)