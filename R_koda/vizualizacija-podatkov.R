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
library(latex2exp)

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
  mutate(ponovitev=seq(500))
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


#----------------PRIMERJAVA ZA MAXI

podatki.ponovitve.maxi <- read_csv("grafi1000_maxi.csv") %>% as.data.frame() %>% select(-1) %>%
  mutate(ponovitev=seq(500))

podatki.ponovitve.maxi <- podatki.ponovitve.maxi[, c(9,1,2,3,4,5,6,7,8)] 
podatki.ponovitve.maxi <- podatki.ponovitve.maxi %>%
  mutate(casinajboljsilokalno = podatki.ponovitve.maxi$`Casi najboljsi nakljucno`+podatki.ponovitve.maxi$`Casi najboljsi lokalno iskanje`) %>%
  select(-"Casi najboljsi lokalno iskanje")

#preimenujemo stolpce
imena.stolpcev.ponovitve.maxi <- c("ponovitev", "najboljsinakljucno", "casinajboljsinakljucno",
                              "CLP", "casiCLP", "najboljsilokalnoiskanje","nakljucnilokalnoiskanje",
                              "casinakljucnilokalnoiskanje", "casinajboljsilokalno")
colnames(podatki.ponovitve.maxi) <- imena.stolpcev.ponovitve.maxi

#tabela s casi

tabela.casi.ponovitve.maxi <- podatki.ponovitve.maxi %>% select(c(-2,-4,-6,-7)) %>%
  rename(
    najboljsinakljucno=casinajboljsinakljucno,
    CLP=casiCLP,
    najboljsilokalnoiskanje=casinajboljsilokalno,
    nakljucnilokalnoiskanje=casinakljucnilokalnoiskanje
  ) %>%
  gather(Algoritem, Čas, najboljsinakljucno,CLP,najboljsilokalnoiskanje,nakljucnilokalnoiskanje)

#tabela moč množice

tabela.moc.ponovitve.maxi <- podatki.ponovitve.maxi %>% select(c(-3,-5,-8,-9)) %>%
  gather(Algoritem, MočMnožice, najboljsinakljucno,CLP,najboljsilokalnoiskanje,nakljucnilokalnoiskanje)


#sedaj ko smo raztegnili tabeli damo nazaj v eno

podatki.pon.maxi <- left_join(tabela.casi.ponovitve.maxi,tabela.moc.ponovitve.maxi,by=c("ponovitev","Algoritem"))




#VIZUALIZACIJA

##VERJETNOST
#prikaže vse algoritme na enem grafu LINIJSKO
graf_ver_moc <- podatki.ver %>% ggplot(aes(x=verjetnost,y=MočMnožice,col=Algoritem))+
  geom_line()+
  labs(title="Vpliv verjetnosti na moč maksimalne neodvisne množice")+
  scale_x_continuous(name = "Verjetnost", breaks = seq(0.1,0.9,0.1),expand = c(0,0))+
  scale_y_continuous(name = "Moč množice", breaks = seq(0,max(podatki.ver$MočMnožice),2))+
  theme_classic()+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.8))+ 
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))

ggsave("ver-moc.png", plot = graf_ver_moc)

#prikaze vse case na enem grafu da primerjamo kako naraščajo
graf_ver_casi <- podatki.ver %>% ggplot(aes(x=verjetnost,y=Čas,col=Algoritem))+
  geom_line()+
  ggtitle("Vpliv verjetnosti na čas izvajanja algoritma")+
  ylab("Čas [s]")+
  scale_x_continuous(name = "Verjetnost", breaks = seq(0.1,0.9,0.1), expand = c(0,0))+
  theme_classic()+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.5))+ 
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))

ggsave("ver-cas.png", plot = graf_ver_casi)

##ŠTEVILO VOZLIŠČ

#na enem grafu primerjava vpliva stevila vozlisc na moc mnozice posameznega algoritma
graf_voz_moc <- podatki.vozlisca %>% ggplot(aes(x=vozlisca,y=MočMnožice,col=Algoritem))+
  geom_line()+
  theme_classic()+
  ggtitle("Vpliv števila vozlišč na moč maksimalne neodvisne množice")+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.2, 0.8))+ 
  scale_y_continuous(name = "Moč množice", breaks = seq(0,max(podatki.vozlisca$MočMnožice),50))+
  scale_x_continuous(name = "Število vozlišč", breaks = seq(0,600,50))+
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))


ggsave("voz-moc.png", plot = graf_voz_moc)


#primerjava vpliva st vozlisc na cas izvedbe algoritma
graf_voz_casi <- podatki.vozlisca %>% ggplot(aes(x=vozlisca,y=Čas,col=Algoritem))+
  geom_line()+
  ggtitle("Vpliv števila vozlišč na čas izvajanja algoritma")+
  theme_classic()+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.2, 0.8))+ 
  scale_y_continuous(name = "Čas izvajanja [s]", breaks = seq(0,max(podatki.vozlisca$Čas),0.025))+
  scale_x_continuous(name = "Število vozlišč", breaks = seq(0,600,50))+
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))


ggsave("voz-cas.png", plot = graf_voz_casi)
##PONOVITVE ISTEGA GRAFA

#primerjava nihanja moči maksimalne neodvisne množice po algoritmih
graf_pon_moc <- podatki.pon %>% ggplot(aes(x=ponovitev,y=MočMnožice,col=Algoritem))+
  geom_line(size=.5)+
  scale_y_continuous(name = "Moč množice",expand = c(0, 0), limits = c(0,20,1)) +
  scale_x_continuous(name = "Zaporedna številka grafa",expand = c(0, 0),limits = c(0,550,50))+
  theme_classic()+
  ggtitle(TeX("Primerjava moči maksimalnih neodvisnih množic za grafe $G(50, 0.3)$"))+
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.8)) 
ggsave("pon-moc.png", plot = graf_pon_moc)


#primerjava časov algoritmov
graf_pon_casi <- podatki.pon %>% ggplot(aes(x=ponovitev,y=Čas,col=Algoritem))+
  geom_line(size=.5)+
  scale_y_continuous(name = "Čas izvajanja [s]",expand = c(0, 0)) +
  scale_x_continuous(name = "Zaporedna številka grafa",expand = c(0, 0),limits = c(0,550,50))+
  theme_classic()+
  ggtitle(TeX("Primerjava časov izvajanja algoritmov za grafe $G(50, 0.3)$"))+
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.8))
  



ggsave("pon-casi.png",plot = graf_pon_casi)

#povprečna moč maksimalne neodvisne množice po algoritmih


podatki.ponovitve1 <- read_csv("grafi1000.csv") %>% as.data.frame() %>% select(-1) %>%
  mutate(ponovitev=seq(500))
podatki.ponovitve1 <- podatki.ponovitve1[, c(7,1,2,3,4,5,6)] 
podatki.ponovitve1 <- podatki.ponovitve1 %>%
  mutate(casilokalno = podatki.ponovitve1$`Casi nakljucno`+podatki.ponovitve1$`Casi lokalno`) %>%
  select(-"Casi lokalno")



#preimenujemo stolpce
imena.stolpcev.ponovitve1 <- c("ponovitev", "Naključno", "casinakljucno","CLP", "casiCLP", "Lokalno","casilokalno")
colnames(podatki.ponovitve1) <- imena.stolpcev.ponovitve1

#tabela s casi

tabela.casi.ponovitve1 <- podatki.ponovitve1 %>% select(c(-2,-4,-6)) %>%
  rename(
    Naključno=casinakljucno,
    CLP=casiCLP,
    Lokalno=casilokalno
  ) %>%
  gather(Algoritem, Čas, Naključno,CLP,Lokalno)

#tabela moč množice

tabela.moc.ponovitve1 <- podatki.ponovitve1 %>% select(c(-3,-5,-7)) %>%
  gather(Algoritem, MočMnožice, Naključno,CLP,Lokalno)


#sedaj ko smo raztegnili tabeli damo nazaj v eno

podatki.pon1 <- left_join(tabela.casi.ponovitve1,tabela.moc.ponovitve1,by=c("ponovitev","Algoritem"))


podatki.pon.povprecje <- podatki.pon1 %>%group_by(Algoritem) %>%
  summarise(povprecje = mean(MočMnožice)) 



graf_pon_povp <- podatki.pon.povprecje %>% ggplot(aes(x=Algoritem, y=povprecje, fill=Algoritem))+
  ylab("Povprečna moč množice")+
  ggtitle("Primerjava povprečnih moči maksimalne neodvisne množice po algoritmih")+
  geom_bar(stat="identity", alpha=0.9,width = 0.6)+
  scale_fill_grey(guide="none")+
  theme_classic()

ggsave("pon-povpmoc.png", plot = graf_pon_povp)


#porazdelitev napak med clp in lokalnim

podatki.porazdelitev.napak <- read_csv('graf_razlik.csv') %>% select(-1)

graf_porazdelitve_napak <- podatki.porazdelitev.napak %>% ggplot(aes(x=razlika,y=pojavitev))+
  geom_col() +
  ggtitle("Odstopanje rešitve lokalnega iskanja od CLP")+
  ylab("Število pojavitev")+
  theme_classic()+
  scale_color_manual(values=c('darkseagreen','firebrick3', "royalblue"),
                     name="Tip algoritma",
                     labels=c("CLP"="CLP",
                              "lokalno"="Lokalno iskanje",
                              "nakljucno"="Naključni"))+
  theme(axis.title.x = element_text(margin = margin(t = 5)),
        legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.8))+
  scale_x_continuous(name = "Odstopanje lokalne rešitve od CLP", breaks = c(min(podatki.porazdelitev.napak$razlika),max(podatki.porazdelitev.napak$razlika),1))

ggsave("pon-napake.png", plot = graf_porazdelitve_napak)

## MAXI
#primerjava moči množic za maxi

graf_pon_moc_maxi <- podatki.pon.maxi %>% ggplot(aes(x=ponovitev,y=MočMnožice,col=Algoritem))+
  geom_line(size=.5,alpha=.85)+
  scale_y_continuous(name = "Moč množice",expand = c(0, 0), limits = c(0,20,1)) +
  scale_x_continuous(name = "Zaporedna številka grafa",expand = c(0, 0),limits = c(0,550,50))+
  theme_classic()+
  ggtitle(TeX("Primerjava moči maksimalnih neodvisnih množic za grafe $G(50, 0.3)$ \n pri več ponovitvah naključnega algoritma"))+
  scale_color_manual(name="Tip algoritma",
                       labels=c("CLP"="CLP",
                                "najboljsinakljucno"="Naključni najboljša",
                                "najboljsilokalnoiskanje"="Lokalno najboljša",
                                "nakljucnilokalnoiskanje"="Lokalno različne neodvisne množice"),
                       values=c('darkseagreen','firebrick3', "royalblue", "darkmagenta"))+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.2)) 

ggsave("pon-moc-maximalno.png", plot = graf_pon_moc_maxi)


#primerjava časov za maxi

graf_pon_casi_maxi <- podatki.pon.maxi %>% ggplot(aes(x=ponovitev,y=Čas,col=Algoritem))+
  geom_line(size=.5)+
  scale_y_continuous(name = "Čas izvajanja [s]",expand = c(0, 0)) +
  scale_x_continuous(name = "Zaporedna številka grafa",expand = c(0, 0),limits = c(0,550,50))+
  theme_classic()+
  ggtitle(TeX("Primerjava časov izvajanja algoritmov za grafe $G(50, 0.3)$ \n pri več ponovitvah naključnega algoritma"))+
  scale_color_manual(name="Tip algoritma",
                       labels=c("CLP"="CLP",
                                "najboljsinakljucno"="Naključni najboljša",
                                "najboljsilokalnoiskanje"="Lokalno najboljša",
                                "nakljucnilokalnoiskanje"="Lokalno različne neodvisne množice"),
                     values=c('darkseagreen','firebrick3', "royalblue", "darkmagenta"))+
  theme(legend.title = element_text(color = "Black", size = 10),
        axis.line = element_line(colour = "black", 
                                 size = .5, linetype = "solid"),
        legend.background = element_rect(fill = "white", linetype="solid", 
                                         colour ="black"),
        legend.position = c(0.8, 0.8)) 
ggsave("pon-casi-maxi.png", plot = graf_pon_casi_maxi)

#povprečna moč maksimalne neodvisne množice po algoritmih maxi

podatki.ponovitve.maxi1 <- read_csv("grafi1000_maxi.csv") %>% as.data.frame() %>% select(-1) %>%
  mutate(ponovitev=seq(500))

podatki.ponovitve.maxi1 <- podatki.ponovitve.maxi1[, c(9,1,2,3,4,5,6,7,8)] 

#preimenujemo stolpce
imena.stolpcev.ponovitve.maxi1 <- c("ponovitev", "najboljsinakljucno", "casinajboljsinakljucno",
                                   "CLP", "casiCLP", "najboljsilokalnoiskanje","casinajboljsilokalno",
                                   "nakljucnilokalnoiskanje","casinakljucnilokalnoiskanje")
colnames(podatki.ponovitve.maxi1) <- imena.stolpcev.ponovitve.maxi1

#tabela moč množice

tabela.moc.ponovitve.maxi1 <- podatki.ponovitve.maxi1 %>% select(c(1,2,4,6,8)) %>%
  gather(Algoritem, MočMnožice, najboljsinakljucno,CLP,najboljsilokalnoiskanje,nakljucnilokalnoiskanje)


#zracunamo povprecje
podatki.pon.povprecje.maxi <- tabela.moc.ponovitve.maxi1 %>%group_by(Algoritem) %>%
  summarise(povprecje = mean(MočMnožice)) %>% arrange(desc(povprecje))

#narisemo graf
graf_pon_povp_maxi <- podatki.pon.povprecje.maxi %>% ggplot(aes(x=reorder(Algoritem, -povprecje), y=povprecje, fill=Algoritem))+
  ylab("Povprečna moč množice")+
  ggtitle("Primerjava povprečnih moči maksimalne neodvisne množice po algoritmih, ko večkrat poganjamo naključni algoritem")+
  geom_bar(stat="identity", alpha=0.9,width = 0.6)+
  scale_fill_grey(guide="none")+
  theme_classic()

ggsave("pon-povpmoc-maxi.png", plot = graf_pon_povp_maxi)

