library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(ggplot2)
library(rjson)
library(readxl)
library(dplyr)
library(readr)
library(shinythemes)

#UVOZ
##VERJETNOST
#uvozimo podatke
podatki.verjetnost <- read_csv("grafi_ver.csv") %>% as.data.frame()
podatki.verjetnost <- podatki.verjetnost %>% select(-1)
podatki.verjetnost <- podatki.verjetnost %>%
  mutate(casilokalno = podatki.verjetnost$`Casi nakljucno`+podatki.verjetnost$`Casi lokalno`) %>%
  select(-"Casi lokalno")

#preimenujemo stolpce
imena.stolpcev.ver <- c("verjetnost", "nakljucno", "casinakljucno","CLP", "casiCLP", "lokalno","casilokalno")
colnames(podatki.verjetnost) <- imena.stolpcev.ver

#tabela s casi

tabela.casi <- podatki.verjetnost %>% select(c(-2,-4,-6)) %>%
  rename(
    nakljucno=casinakljucno,
    CLP=casiCLP,
    lokalno=casilokalno
  ) %>%
  gather(Algoritem, Čas, nakljucno,CLP,lokalno)

#tabela moč množice

tabela.moc <- podatki.verjetnost %>% select(c(-3,-5,-7)) %>%
  gather(Algoritem, MočMnožice, nakljucno,CLP,lokalno)


#sedaj ko smo raztegnili tabeli damo nazaj v eno

podatki.ver <- left_join(tabela.casi,tabela.moc,by=c("verjetnost","Algoritem"))


##ŠTEVILO VOZLIŠČ
#uvozimo podatke
podatki.voz <- read_csv("grafi_voz.csv") %>% as.data.frame() %>% select(-1) 
podatki.voz <- podatki.voz %>%
  mutate(casilokalno = podatki.voz$`Casi nakljucno`+podatki.voz$`Casi lokalno`) %>%
  select(-"Casi lokalno")


#preimenujemo stolpce
imena.stolpcev.voz <- c("vozlisca", "nakljucno", "casinakljucno","CLP", "casiCLP", "lokalno","casilokalno")
colnames(podatki.voz) <- imena.stolpcev.voz

#tabela s casi

tabela.casi.voz <- podatki.voz %>% select(c(-2,-4,-6)) %>%
  rename(
    nakljucno=casinakljucno,
    CLP=casiCLP,
    lokalno=casilokalno
  ) %>%
  gather(Algoritem, Čas, nakljucno,CLP,lokalno)

#tabela moč množice

tabela.moc.voz <- podatki.voz %>% select(c(-3,-5,-7)) %>%
  gather(Algoritem, MočMnožice, nakljucno,CLP,lokalno)


#sedaj ko smo raztegnili tabeli damo nazaj v eno

podatki.vozlisca <- left_join(tabela.casi.voz,tabela.moc.voz,by=c("vozlisca","Algoritem"))

##ISTA VER IN ŠT VOZ VEČKRAT GENERIRAN

podatki.ponovitve <- read_csv("grafi1000.csv") %>% as.data.frame() %>% select(-1) %>%
  mutate(ponovitev=seq(100))
podatki.ponovitve <- podatki.ponovitve[, c(7,1,2,3,4,5,6)] 
podatki.ponovitve <- podatki.ponovitve %>%
  mutate(casilokalno = podatki.ponovitve$`Casi nakljucno`+podatki.ponovitve$`Casi lokalno`) %>%
  select(-"Casi lokalno")
  
#preimenujemo stolpce
imena.stolpcev.ponovitve <- c("ponovitev", "nakljucno", "casinakljucno","CLP", "casiCLP", "lokalno","casilokalno")
colnames(podatki.ponovitve) <- imena.stolpcev.ponovitve

#tabela s casi

tabela.casi.ponovitve <- podatki.ponovitve %>% select(c(-2,-4,-6)) %>%
  rename(
    nakljucno=casinakljucno,
    CLP=casiCLP,
    lokalno=casilokalno
  ) %>%
  gather(Algoritem, Čas, nakljucno,CLP,lokalno)

#tabela moč množice

tabela.moc.ponovitve <- podatki.ponovitve %>% select(c(-3,-5,-7)) %>%
  gather(Algoritem, MočMnožice, nakljucno,CLP,lokalno)


#sedaj ko smo raztegnili tabeli damo nazaj v eno

podatki.pon <- left_join(tabela.casi.ponovitve,tabela.moc.ponovitve,by=c("ponovitev","Algoritem"))


#VIZUALIZACIJA


##VERJETNOST
#prikaže vse algoritme na enem grafu LINIJSKO
graf_ver_moc <- podatki.ver %>% ggplot(aes(x=verjetnost,y=MočMnožice,col=Algoritem))+
  geom_line()+
  theme_classic()


#prikaze vse case na enem grafu da primerjamo kako naraščajo
graf_ver_casi <- podatki.ver %>% ggplot(aes(x=verjetnost,y=Čas,col=Algoritem))+
  geom_line()+
  theme_classic()


#prikaze moč množice za posamezne vrste algoritma s stolpici

grafi_ver_moc_posamezno <- podatki.ver %>% ggplot(aes(x=verjetnost,y=MočMnožice))+
  geom_col()+
  facet_grid(. ~ Algoritem) +
  theme_bw()


##ŠTEVILO VOZLIŠČ

#na enem grafu primerjava vpliva stevila vozlisc na moc mnozice posameznega algoritma
graf_voz_moc <- podatki.vozlisca %>% ggplot(aes(x=vozlisca,y=MočMnožice,col=Algoritem))+
  geom_line()+
  theme_classic()

#primerjava vpliva st vozlisc na cas izvedbe algoritma
graf_voz_casi <- podatki.vozlisca %>% ggplot(aes(x=vozlisca,y=Čas,col=Algoritem))+
  geom_line()+
  theme_classic()
graf_voz_casi

grafi_voz_moc_posamezno <- podatki.vozlisca %>% ggplot(aes(x=vozlisca,y=MočMnožice))+
  geom_col()+
  facet_grid(. ~ Algoritem) +
  theme_bw()
grafi_voz_moc_posamezno


##PONOVITVE ISTEGA GRAFA

#primerjava nihanja moči maksimalne neodvisne množice po algoritmih
graf_pon_moc <- podatki.pon %>% ggplot(aes(x=ponovitev,y=MočMnožice))+
  geom_col()+
  facet_grid(.~ Algoritem)+
  theme_classic()

#povprečna moč maksimalne neodvisne množice po algoritmih

podatki.pon.povprecje <- podatki.pon %>%group_by(Algoritem) %>%
  summarise(povprecje = mean(MočMnožice))
graf_pon_povp <- podatki.pon.povprecje %>% ggplot(aes(x=Algoritem, y=povprecje))+
  geom_col()

#maksimalna moč maks neodv množice po algo

podatki.pon.max <- podatki.pon %>%group_by(Algoritem) %>%
  summarise(max= max(MočMnožice))
graf_pon_max <- podatki.pon.max %>% ggplot(aes(x=Algoritem, y=max))+
  geom_col()
  
#porazdelitev napak med clp in lokalnim

podatki.porazdelitev.napak <- read_csv('graf_razlik.csv') %>% select(-1)

graf_porazdelitve_napak <- podatki.porazdelitev.napak %>% ggplot(aes(x=razlika,y=pojavitev))+
  geom_col() +
  theme_classic()
graf_porazdelitve_napak
