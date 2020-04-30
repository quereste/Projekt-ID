Wykonawcy projektu: Oliwia Gil, Tomasz Szczepanik

Wybranym przez nas tematem projektu jest model bazy danych samochodowej sieci dealerskiej.

Realizując temat projektu, staraliśmy się stworzyć bazę danych, która pozwoliłaby magazynować dane wyżej wymienionej sieci, składającej się z kilku filii ( w danych przykładowych jest ich siedem, są położone w wybranych miastach wojewódzkich lub powiatowych Polski).

Każdym z salonów zarządza kierownik, których ogólnokrajowe gremium tworzy zarząd opisany w tabeli kierownicy. Prócz tego opis każdego z oddziałów uzupełniony jest przez dane kontaktowe, godziny otwarcia oraz informację, czy w salonie sprzedawane są wyłącznie samochody fabrycznie nowe, czy też nie (kolumna czy_nowe).

Do salonu przypisani są doradcy, na podstawie klucza obcego id_salon, w przykładzie po średnio 2-3 do jednej filii. Każdy klient salonu zostanie skontaktowany z jednym z doradców. Samych klientów dzielimy na dwa rodzaje - osoby fizyczne i osoby prawne. W krotkach osób fizycznych muszą figurować wartości "imie" oraz "nazwisko", zaś firmy determinowane są przez kolumnę "nazwa". Wola klienta, zgłaszana przy rejestracji, dotycząca otrzymywania sieciowego newslettera, jest odnotowywana w odpowiedniej kolumnie. W tabeli klienci_salonu widnieją, obok nabywców, również osoby, które sprzedały Sieci używany przez siebie samochód.

Jako rozwiązanie implementacyjne wprowadziliśmy rozróżnienie pomiędzy tabelami samochody i modele.

W pierwszej z nich znajdują się konkretne obiekty, które fizycznie dostępne są w odpowiednich oddziałach sieci dealerskiej. W tej tabeli dane na temat kolejnych pojazdów są bardziej szczegółowe niż w tabeli modele, co wynika z tego, że modele samochodowe dostępne są w wielu wariantach, których dywersyfikacja jest tak szeroka, że niepraktyczne zdawało się opisywać każdą kombinację modelu, wyposażenia, silnika czy typu samochodu jako osobną krotkę; każda taka kombinacja implikuje zmiany w osiągach i parametrach konkretnego samochodu.

Tabela samochody zawiera dodatkowo dwie powiązane ze sobą kolumny: "id_klienta" i "nowy". Jeżeli samochód nie jest nowy, oznacza to, że miał wcześniej właściciela, u którego Sieć zakupiła dany pojazd. Na bazie tego powiązania wymuszone zostają ograniczenia związane z kolumnami "nowy","id_klienta", "przebieg", a także "bezwypadkowy".

Tabela modele zawiera z kolei ogólne informacje dotyczące modeli samochodów, które pozostają niezmienne, mimo wspomnianych wcześniej przystosowań, czego przykładem jest okres produkcji konkretnego modelu na osi czasu. Modele są połączone kluczami obcymi z markami tych pojazdów (tabela marka), zaś za pomocą tabeli przejściowych z dostępnymi dla konkretynch modelów typami samochodów (tabela typ), ich wyposażeniem (wyposazenie), wariantami napędu (możliwe trzy warianty - napęd na przednie, tylne lub - wszystkie cztery koła) oraz krajem produkcji. Taki rozdział jest uzasadniony, gdyż może się zdarzyć, że kraj pochodzenia marki nie pokrywa się z miejscem produkcji modelu.

W tabeli marki wymieniliśmy jako pole nazwę koncernu, w którego skład dana firma wchodzi.

Tabelą opisującą działalność kupno/sprzedaż wszystkich filii jest tabela historia_transakcji. Każda transakcja opisywana jest przez numer salonu, który ją finalizował, jej wartość pieniężną, informację, czy samochód został sprzedany, czy też nabyty. W obu przypadkach notujemy "id_klienta": w pierwszym przypadku klient pozyskał od Sieci pojazd, zaś w drugim
sprzedał jej swoje auto, trafiając tym samym do bazy danych. W tej tabeli, by nie pamiętać numerów identyfikacyjnych wszystkich obiektów - samochodów, które kiedykolwiek przeszły
przez oddziały sieci, zdecydowaliśmy identyfikować będące przedmiotem transakcji samochody za pomocą ich "id_modelu".

Podział pracy: 

Oliwia Gil: kreacja schematu bazy danych w formie wykresu, definicja i dane do tabel: marki, modele, typ, modele_typ, wyposażenie, modele_wyposażenie, rodzaj_napedu, model_naped, kraje, modele_kraje, definicja tabel klienci_salonu, doradcy, samochody, współdefinicja tabeli salon, współuzupełnienie tabeli samochody

Tomasz Szczepanik: współdefinicja tabeli salon, definicja tabeli kierownicy historia_transakcji, dane do tabel: klienci_salonu, salon, kierownicy, doradcy, historia_transakcji współuzupełnienie tablicy samochody, pierwsza redakcja tego pliku