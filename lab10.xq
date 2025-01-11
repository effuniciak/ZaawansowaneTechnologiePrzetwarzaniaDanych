(: Zad 5 :)
for $author in doc("db/bib/bib.xml")//book/author/last
return $author

(: Zad 6 :)
for $book in doc("db/bib/bib.xml")//book
return 
<ksiazka> 
  {$book/author} {$book/title}
</ksiazka>

(: Zad 7 :)
for $book in doc("db/bib/bib.xml")//book
for $autor in $book/author
let $autor_full_name := concat($autor/last, $autor/first)
return 
<ksiazka>
  <autor>
  {$autor_full_name}
  </autor>
  <tytul>
  {$book/title/text()}
  </tytul>
</ksiazka>

(: Zad 8 :)
for $book in doc("db/bib/bib.xml")//book
for $autor in $book/author
let $autor_full_name := concat($autor/last, ' ', $autor/first)
return 
<ksiazka>
  <autor>
  {$autor_full_name}
  </autor>
  <tytul>
  {$book/title/text()}
  </tytul>
</ksiazka>

(: Zad 9 :)
<wynik>
{
  for $book in doc("db/bib/bib.xml")//book
    for $autor in $book/author
    let $autor_full_name := concat($autor/last, ' ', $autor/first)
    return 
    <ksiazka>
      <autor>
      {$autor_full_name}
      </autor>
      <tytul>
      {$book/title/text()}
      </tytul>
    </ksiazka>
}
</wynik>

(: Zad 10 :)
<imiona>
{
  for $autor_name in doc("db/bib/bib.xml")//book[title="Data on the Web"]//author//first
  return <imie>{$autor_name/text()}</imie>
}
</imiona>


(: Zad 11 :)
(: a) :)
<DataOnTheWeb>
{doc("db/bib/bib.xml")//book[title = "Data on the Web"]}
</DataOnTheWeb>

(: b :)
<DataOnTheWeb>
{
  for $book_info in doc("db/bib/bib.xml")//book
    where $book_info/title = "Data on the Web"
    return $book_info
}
</DataOnTheWeb>

(: Zad 12 :)
<Data>
{
  for $book_info in doc("db/bib/bib.xml")//book
    where contains($book_info/title, "Data")
    return $book_info/author/last
}
</Data>

(: Zad 13 :)
for $book_info in doc("db/bib/bib.xml")//book
  where contains($book_info/title, "Data")
  return 
  <Data>
    <title>{$book_info/title/text()}</title>
    {
      for $autor_info in $book_info/author
        return <nazwisko>{$autor_info/last/text()}</nazwisko>
    }
  </Data>
  
(: Zad 14 :) 
for $book_info in doc("db/bib/bib.xml")//book
where count($book_info/author) <= 2
return <ksiazka>{$book_info/title}</ksiazka>

(: Zad 15 :)
for $book_info in doc("db/bib/bib.xml")//book
return <ksiazka>
  {$book_info/title}
  <autorow>{count($book_info/author)}</autorow>
</ksiazka>

(: Zad 16 :)
let $all_years := doc("db/bib/bib.xml")//book/@year
return <przedział>{min($all_years)} - {max($all_years)}</przedział>

(: Zad 17 :)
let $ceny := doc("db/bib/bib.xml")//book/price
return <różnica>
{
  max($ceny)-min($ceny)
}
</różnica>

(: Zad 18 :)
let $najmniejszaCena := min(doc("db/bib/bib.xml")//book/price)
return
<najtańsze>
{
  for $book_info in doc("db/bib/bib.xml")//book[price = $najmniejszaCena]
  return
  <najtańsza>
  <title>{$book_info/title/text()}</title>
  {
      for $autor_info in $book_info/author
      return <author>{$autor_info/last}{$autor_info/first}</author>
  }
  </najtańsza>
}
</najtańsze>

(: Zad 19 :)
for $autor_nazwisko in distinct-values(doc("db/bib/bib.xml")//author/last)
return
<autor>
<last>
{$autor_nazwisko}
</last>
{
  for $book_info in doc("db/bib/bib.xml")//book[author/last = $autor_nazwisko]
      return 
      <title>
      {
        $book_info/title/text()
      }
      </title>
}
</autor>

(: Zad 20 :)
<wynik>
{
  for $tytul in collection("db/shakespeare")//PLAY/TITLE
  return $tytul
}
</wynik>

(: Zad 21 :)
for $play_info in collection("db/shakespeare")//PLAY
where some $line in $play_info//LINE satisfies contains($line, "or not to be")
return $play_info/TITLE

(: Zad 22 :)
<wynik>
{
  for $play_info in collection("db/shakespeare")//PLAY
  return 
  <sztuka tytul="{$play_info/TITLE}">
  <postaci>
    {count($play_info//PERSONA)}
  </postaci>
  <aktow>
    {count($play_info//ACT)}
  </aktow>
  <scen>
    {count($play_info//SCENE)}
  </scen>
  </sztuka>
}
</wynik>