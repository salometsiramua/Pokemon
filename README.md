# Pokemon

Application fetching pokemons list from https://pokeapi.co/.

Showing images and names. Upon clicking one pokemon shows details of that one.

I have not used any third party library. (Was planning to use Rx but because of the external libraries restriction I decided to keep it out)

Pattern is MVVM.

Added some unit tests as well.

UI is from code.

Application supports offline mode partially. (List is being saved, pokemon details not)

Styles, Colors, Fonts are centralized.


P.S.

Service for the list of pokemons did not have image url inside, so I did a small workaround and generated the ULR from image index.
(Currently it's working but I also understand that if image path will be changed it will break this solution)
