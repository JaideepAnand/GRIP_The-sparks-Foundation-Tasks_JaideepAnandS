library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(shiny)
#library(plyr)
library(dplyr)
library(gridExtra)
library(treemap)
library(RColorBrewer)
library(tidyr)
library(radarchart)

system("ls ../input")
deliveries<-read.csv("C:/Users/JAITARANATH/Desktop/Intern/Task3/deliveries.csv")
matches<-read.csv("C:/Users/JAITARANATH/Desktop/Intern/Task3/matches.csv")
matches<-matches[matches$result=="normal",]
matches[which(as.character(matches$team2)==as.character(matches$winner)),"loser"]<- matches[which(as.character(matches$team2)==as.character(matches$winner)),"team1"]
matches[which(as.character(matches$team1)==as.character(matches$winner)),"loser"]<- matches[which(as.character(matches$team1)==as.character(matches$winner)),"team2"]


matches1<-matches[matches$win_by_runs!=0,]
closeness<-function(x,y = "gold" ){
  data1<-matches1[matches1$winner==x|matches1$loser==x,]
  data1[data1$loser==x,"win_by_runs"]<- -data1[data1$loser==x,"win_by_runs"]
  ggplot(data1,aes(1:nrow(data1),win_by_runs))+ geom_area(fill=y)+ggtitle(x)+
    ylab("Runs")+ xlab("Matches")+ geom_ribbon(aes(ymin=-5, ymax=5),fill="red",alpha=0.4) +geom_ribbon(aes(ymin=-15, ymax=15),fill="red",alpha=0.1) +
    guides(fill=FALSE)+scale_alpha(guide = 'none')+coord_cartesian(ylim = c(-100, 100)) 
}
a<-closeness("Chennai Super Kings")
b<-closeness("Kolkata Knight Riders","purple")
c<-closeness("Sunrisers Hyderabad","orange")
d<-closeness("Mumbai Indians","blue2")
e<-closeness("Royal Challengers Bangalore","red3")
f<-closeness("Delhi Daredevils","firebrick3")
g<-closeness("Rajasthan Royals","blueviolet")
h<-closeness("Kings XI Punjab","salmon")
grid.arrange(a,b,c,e,d,f,g,h,ncol=2)


#matches played in different cities
ggplot(matches[which(!is.na(matches$city)),],aes(city,fill= city,rm.na=T)) +geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ 
  ylab("Number of Matches Played") +
  guides(fill=FALSE)
#matches played in different stadiums
ggplot(matches,aes(venue, rm.na=T)) +geom_bar(fill="#0072B2") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ 
  ylab("Number of Matches Played")

#toss winner advantage
matches$toss_match<-ifelse(as.character(matches$toss_winner)==as.character(matches$winner),"Won","Lost")
ggplot(matches[which(!is.na(matches$toss_match)),],aes(toss_match, fill = toss_match))+ 
  geom_bar()+ xlab("Toss") +ylab("Number of matches won")+ ggtitle("How much of a advantage is winning the toss")

#home advantage
Data<-matches[matches$season!="2009",]
Data$date<- as.Date(Data$date)
Data1<-Data[Data$date < as.Date("2014-04-16") | Data$date > as.Date("2014-04-30"),]
Data1$home_team[Data1$city=="Bangalore"]<- "Royal Challengers Bangalore"
Data1$home_team[Data1$city=="Chennai"]<- "Chennai Super Kings"
Data1$home_team[Data1$city=="Delhi"]<- "Delhi Daredevils"
Data1$home_team[Data1$city=="Chandigarh"]<- "Kings XI Punjab"
Data1$home_team[Data1$city=="Jaipur"]<- "Rajasthan Royals"
Data1$home_team[Data1$city=="Mumbai"]<- "Mumbai Indians"
Data1$home_team[Data1$city=="Kolkata"]<- "Kolkata Knight Riders"
Data1$home_team[Data1$city=="Kochi"]<- "Kochi Tuskers Kerala"
Data1$home_team[Data1$city=="Hyderabad" & Data1$season <=2012]<- "Deccan Chargers"
Data1$home_team[Data1$city=="Hyderabad" & Data1$season >2012]<- "Sunrisers Hyderabad"
Data1$home_team[Data1$city=="Ahmedabad"]<- "Rajasthan Royals"
Data1$home_team[Data1$city=="Dharamsala"]<- "Kings XI Punjab"
Data1$home_team[Data1$city=="Visakhapatnam" & Data1$season== 2015]<- "Sunrisers Hyderabad"
Data1$home_team[Data1$city=="Ranchi" & Data1$season== 2013]<- "Kolkata Knight Riders"
Data1$home_team[Data1$city=="Ranchi" & Data1$season > 2013]<- "Chennai Super Kings"
Data1$home_team[Data1$city=="Rajkot" ]<- "Gujarat Lions"
Data1$home_team[Data1$city=="Kanpur" ]<- "Gujarat Lions"
Data1$home_team[Data1$city=="Raipur" ]<- "Delhi Daredevils"
Data1$home_team[Data1$city=="Nagpur" ]<- "Deccan Chargers"
Data1$home_team[Data1$city=="Indore" ]<- "Kochi Tuskers Kerala"
Data1$home_team[Data1$city=="Pune" & Data1$season!= 2016]<- "Pune Warriors"
Data1$home_team[Data1$city=="Pune" & Data1$season== 2016]<- "Rising Pune Supergiants"
Data1<-Data1[ which(!is.na(Data1$home_team)),]
Data1$win_host <- ifelse(as.character(Data1$winner)==as.character(Data1$home_team),"Home","Away")

ggplot(Data1[which(!is.na(Data1$win_host)),],aes(win_host,fill= win_host))+geom_bar()+
  ggtitle("Is home advantage a real thing in IPL?")+
  xlab("Team")+
  ylab("Number of Matches won")+labs(aesthetic="Winner")

#matches played by each team
ggplot(as.data.frame(table(matches$team2) + table(matches$team1)),aes(reorder(Var1,-Freq),Freq,fill = Var1)) +geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ xlab("Player")+
  ylab("Number of Matches") +guides(fill=FALSE)

#matches won by each team
ggplot(as.data.frame(table(matches$team2) + table(matches$team1)),aes(reorder(Var1,-Freq),Freq,fill = Var1)) +geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ xlab("Player")+
  ylab("Number of Matches") +guides(fill=FALSE)

#winpercentage of each team
matches_won<-as.data.frame(table(matches$winner))
colnames(matches_won)[2]<-"Won"
matches_played<-as.data.frame(table(matches$team2) + table(matches$team1))
colnames(matches_played)[2]<-"Played"

ggplot(left_join(matches_played,matches_won ),aes(reorder(Var1,-Won/Played),Won*100/Played,fill = Var1)) +geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ xlab("Team")+
  ylab("Win Percentage") +  guides(fill=FALSE)+coord_cartesian(ylim = c(0, 100))

#margin
#   ggplot(matches[matches$win_by_runs!=0,],aes(id,win_by_runs,col= winner )) + geom_point() +
#   ylab("Runs won by ") + xlab("Matches won by team batting first")+
#   ggtitle("Margin of Victories(Won by team batting first)")+ 
#   scale_y_continuous(breaks=c(0,25,50,75,100))  
# ggplot(matches[matches$win_by_wickets!=0,],aes(id,win_by_wickets,col= winner )) + geom_point() +
#   ylab("Wickets won by ") + xlab("Matches won by team bowling first")+
#   ggtitle("Margin of Victories(Won by team bowling first)")+
#   scale_y_continuous(breaks=c(2,4,6,8,10))

#top batsmen
df<- deliveries %>% group_by(batsman)%>% summarise(runs=sum(batsman_runs)) %>% arrange(desc(runs)) %>%
  filter(runs > 3000) 
df %>% ggplot(aes(reorder(batsman,-runs),runs,fill=batsman)) +geom_bar(stat = "identity") +xlab("Batsman")+ ylab("Runs")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ xlab("Player")+ ggtitle("Top Batsmen")+ guides(fill=F)

#top bowlers
df<-deliveries %>% group_by(bowler) %>% filter(player_dismissed!="") %>% summarise(wickets= length(player_dismissed)) %>% top_n(n=10,wt=wickets) 
df %>% ggplot(aes(reorder(bowler,-wickets),wickets,fill=bowler))+geom_bar(stat = "identity") + ylab("Wickets")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+ xlab("Player")+ ggtitle("Top Bowlers")+ guides(fill=F)

#top strike rate batsmen
deliveries %>% group_by(batsman) %>% filter(length(total_runs)>500) %>% summarise(strike_rate= mean(batsman_runs)*100) %>% top_n(n=10,wt=strike_rate) %>%
  ggplot(aes(reorder(batsman,-strike_rate),strike_rate,fill=batsman))+ geom_bar(stat="identity")+ xlab("Batsman") + ylab("Strike Rate") +
  ggtitle("Batsmen with top strike rate",subtitle = "Minimum 500 balls faced")+
  theme(axis.text.x = element_text(angle = 75, hjust = 1)) + guides(fill=F)

#all tym top run getters
Kohli<- deliveries %>% group_by(batsman,bowler) %>% filter(batsman=="V Kohli") %>% summarise(runs=sum(batsman_runs)) %>% top_n(n=50,wt=runs)
Rohit<- deliveries %>% group_by(batsman,bowler) %>% filter(batsman=="RG Sharma") %>% summarise(runs=sum(batsman_runs)) %>% top_n(n=50,wt=runs)
Gambhir<- deliveries %>% group_by(batsman,bowler) %>% filter(batsman=="G Gambhir") %>% summarise(runs=sum(batsman_runs)) %>% top_n(n=50,wt=runs)
Raina<- deliveries %>% group_by(batsman,bowler) %>% filter(batsman=="SK Raina") %>% summarise(runs=sum(batsman_runs)) %>% top_n(n=50,wt=runs)
treemap(Kohli, #Your data frame object
        index=c("batsman","bowler"),  #A list of your categorical variables
        vSize = "runs",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = brewer.pal(7,"Reds"),  #Select your color palette from the RColorBrewer presets or make your own.
        fontsize.title = 12,
        fontfamily.title = "serif",
        fontfamily.labels = "symbol",
        title = "Runs by Virat Kohli against different bowlers",
        fontface.labels = "bold",
        border.col="#FFFFFF",
        fontsize.legend = 0,bg.labels = "black",fontcolor.labels= "#FFFFFF",
        aspRatio= 1.1
)
treemap(Rohit, #Your data frame object
        index=c("batsman","bowler"),  #A list of your categorical variables
        vSize = "runs",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = brewer.pal(7,"Blues"),  #Select your color palette from the RColorBrewer presets or make your own.
        fontsize.title = 12,
        fontfamily.title = "serif",
        fontfamily.labels = "symbol",
        title = "Runs by RG Sharma against different bowlers",
        fontface.labels = "bold",
        border.col="#FFFFFF",
        fontsize.legend = 0,bg.labels = "black",fontcolor.labels= "#FFFFFF",
        aspRatio= 1.1
)
treemap(Gambhir, #Your data frame object
        index=c("batsman","bowler"),  #A list of your categorical variables
        vSize = "runs",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = brewer.pal(4,"Purples"),  #Select your color palette from the RColorBrewer presets or make your own.
        fontsize.title = 12,
        fontfamily.title = "serif",
        fontfamily.labels = "symbol",
        title = "Runs by G Gambhir against different bowlers",
        fontface.labels = "bold",
        border.col="#FFFFFF",
        fontsize.legend = 0,bg.labels = "black",fontcolor.labels= "#FFFFFF",
        aspRatio= 1.1
)
treemap(Raina, #Your data frame object
        index=c("batsman","bowler"),  #A list of your categorical variables
        vSize = "runs",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = brewer.pal(3,"YlOrBr"),  #Select your color palette from the RColorBrewer presets or make your own.
        fontsize.title = 12,
        fontfamily.title = "serif",
        fontfamily.labels = "symbol",
        title = "Runs by SK Raina against different bowlers",
        fontface.labels = "bold",
        border.col="#FFFFFF",
        fontsize.legend = 0,
        bg.labels = "black",fontcolor.labels= "#FFFFFF",
        aspRatio= 1.1
)

#the end
