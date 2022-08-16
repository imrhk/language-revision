import 'package:language_learning/main.dart';

Map<String, String> get englishToFrench => <String, String>{}..addAll(() {
    final lines = data.split('\n');
    final map = <String, String>{};
    for (var i = 0; i < lines.length; i += 2) {
      map[lines[i + 1]] = lines[i];
    }
    final entries = map.entries.toList();
    if (shuffle) {
      entries.shuffle();
    }
    return Map.fromEntries(entries);
  }());

Map<String, String> get frenchToEnglish => <String, String>{}..addAll(() {
    final lines = data.split('\n');
    final map = <String, String>{};
    for (var i = 0; i < lines.length; i += 2) {
      map[lines[i]] = lines[i + 1];
    }
    final entries = map.entries.toList();
    if (shuffle) {
      entries.shuffle();
    }
    return Map.fromEntries(entries);
  }());

const data = r'''salut
hi; bye
ça va ?
are you good?
oui
yes
génial !
great!
ça va, et toi ?
I'm good, and you?
non
no
quoi ?
what?
c'est dommage !
that's a shame!
je suis désolé
I'm sorry (said by a man)
je suis désolée
I'm sorry (said by a woman)
t'inquiète pas
don't worry
comment ?
how?
comment tu t'appelles ?
what's your name?
je m'appelle ...
my name is ...
j'adore !
I love it!
merci
thank you
de rien
you're welcome
au revoir
goodbye
parler
to speak; to talk
un peu
a little
je parle un peu français
I speak a little French
merde !
shit!
où sont les toilettes ?
where are the toilets?
vous avez du Wi-Fi ?
do you have Wi-Fi? (formal)
c'est parfait !
that's perfect!
t'es un génie
you're a genius
je t'aime
I love you
ah bon ?
really?
moi aussi
me too
bonne chance !
good luck!
bonjour
hello; good morning
quoi de neuf ?
what's new?
enchanté; enchantée
nice to meet you
s'il te plaît
please (informal)
s'il vous plaît
please (plural; formal)
j'ai faim
I'm hungry
j'ai soif
I'm thirsty
bien sûr
of course
pas de problème
no problem
voilà
here you go
bon appétit !
enjoy your meal!
santé !
cheers! (when drinking)
c'est combien ?
how much is it?
ce n'est pas possible
it's not possible
pourquoi ?
why?
je n'ai pas d'argent
I don't have money
pourquoi pas ?
why not?
je ne sais pas
I don't know
parce que
because
excusez-moi
excuse me (plural; formal)
vous parlez anglais ?
do you speak English? (plural; formal)
je ne comprends pas
I don't understand
lentement
slowly
parlez plus lentement, s'il vous plaît
speak more slowly, please (formal)
d'accord
OK
qu'est-ce que c'est ?
what's that?
dire
to say; to tell
qu'est-ce que ça veut dire ?
what does that mean?
vous pouvez répéter, s'il vous plaît ?
can you repeat, please? (formal)
je n'ai pas le temps
I don't have time
arrête !
stop it!
laisse-moi tranquille
leave me alone
au secours !
help!
vous pouvez m'aider, s'il vous plaît ?
can you help me, please? (formal)
je n'ai pas envie
I don't feel like it
allez, quoi !
come on, already!
on y va !
let's go!
je ne pense pas
I don't think so
bonne nuit
good night
félicitations !
congratulations!
à bientôt !
see you soon!
qui ?
who?
être
to be
je suis anglais
I'm English (said by a man)
je suis anglaise
I'm English (said by a woman)
on se connaît ?
do we know each other? (informal)
tu es français ?
are you French? (said to a man)
tu es française ?
are you French? (said to a woman)
habiter
to live (somewhere)
j'habite ...
I live...
en Angleterre
in England
j'habite en France
I live in France
où ?
where?
tu habites où ?
where do you live?
venir de
to come from
alors
so
tu viens d'où ?
where do you come from?
je viens de Paris
I come from Paris
mais
but
au fait ...
by the way...
il y a
there is; there are
beaucoup de
a lot of
un touriste; une touriste
a tourist (masc.; fem.)
il y a beaucoup de touristes
there are a lot of tourists
c'est la vie !
that's life!
faire
to do; to make
tu fais quoi ?
what are you doing?
tu fais quoi dans la vie ?
what do you do for a living?
j'étudie ...
I study...
à l'université
at university
j'étudie à l'université
I study at university
un danseur; une danseuse
a dancer
un enseignant; une enseignante
a teacher
je suis enseignant
I'm a teacher
je travaille comme danseuse
I work as a dancer
ça te plaît ?
do you like it?
le pays
the country
la région
the region
les gens
the people
avoir
to have
j'ai un chat
I have a cat
tu as un chien ?
do you have a dog?
un animal de compagnie
a pet
tu es marié ?
are you married? (speaking to a man)
je suis célibataire
I am single
ça te dit de ... ?
do you feel like...?
prendre un verre
to have a drink
ça te dit de prendre un verre ?
do you feel like having a drink?
c'est moi !
it's me!
c'est moi qui offre
it's my treat
quand ?
when?
j'adorerais
I would love to
un
one
deux
two
trois
three
quatre
four
cinq
five
six
six
sept
seven
huit
eight
neuf
nine
onze
eleven
dix
ten
douze
twelve
treize
thirteen
quatorze
fourteen
quinze
fifteen
seize
sixteen
dix-sept
seventeen
dix-huit
eighteen
dix-neuf
nineteen
vingt
twenty
aimer
to love; to like
tu aimes l'art ?
do you like art?
je n'aime pas l'art
I don't like art
j'aime beaucoup la musique
I like music a lot
l'humour
humour
j'aime vivre à Paris
I like living in Paris
c'est une bonne idée
it's a good idea
pas vraiment
not really
je ne suis pas d'accord
I don't agree
moi non plus
me neither
ce week-end
this weekend
visiter
to visit (a place)
un musée
a museum
une galerie d'art
an art gallery
un concert
a concert
une histoire
a story
un ciné
a cinema (casual)
quel genre de films tu aimes ?
what kind of films do you like?
un film d'action
an action film
un film de science-fiction
a sci-fi movie
un film d'horreur
a horror film
je suis ouvert à tout
I'm open to everything
en ce moment
at the moment
ou
or
sinon
otherwise
je veux aller ...
I want to go ...
tu veux aller ...
you want to go...
au théâtre
to the theatre
au cinéma
to the cinema
je veux aller au théâtre
I want to go to the theatre
tu veux aller au cinéma ?
do you want to go to the cinema?
on peut aller ...
we can go...
à la place de ...
instead of...
je pense que ...
I think that...
ça a l'air bien
it seems good
je déteste ...
I hate...
je trouve ça ...
I find that...
très
very
ennuyeux
boring
incroyable
incredible
époustouflant
breathtaking
lourd
unsubtle; heavy
je pense que c'est intéressant
I think that it's interesting
je trouve ça nul
I find that rubbish
en plus ...
what's more...
surtout ...
above all...
par contre ...
on the other hand...
meilleur
best
un acteur; une actrice
an actor; an actress
préféré; préférée
favourite
un comédien
an actor; a comedian
une comédienne
an actress; a comedian
ce n'est pas mon truc
that's not my thing
ça ne me dérange pas
I don't mind
ça me tente bien
I'm tempted
si tu veux
if you want
j'en ai marre
I'm fed up
à chacun ses goûts
to each their own
c'est n'importe quoi
it's nonsense''';