Analysis of a survey
=====================

Create a model for the response variable you are assigned to (assignments are 
after survey questions). Please follow the procedure outlined in the analysis 
lecture and provided in the example.ipynb here.
Please do not use the values for other responses when modeling your response variable.

For each question there is a response (or multiple choices or rank for the response variable) and also the time it was completed: subtracting from the previous question time you can get time it took to respond. This is so called paradata that relects the behaviour or respondents while filling the survey. 

For extra credit please provide a recommendation on how to improve the survey, preferably based on the analysis of response data or paradata.


## Questions

![Question1](https://github.com/fdac18/Miniproject3/blob/master/Q1.png)
![Question2](https://github.com/fdac18/Miniproject3/blob/master/Q2.png)
![Question3](https://github.com/fdac18/Miniproject3/blob/master/Q3.png)
![Question4](https://github.com/fdac18/Miniproject3/blob/master/Q4.png)
![Question5](https://github.com/fdac18/Miniproject3/blob/master/Q5.png)
![Question6](https://github.com/fdac18/Miniproject3/blob/master/Q6.png)
![Question7](https://github.com/fdac18/Miniproject3/blob/master/Q7.png)
![Question8](https://github.com/fdac18/Miniproject3/blob/master/Q8.png)
![Question9](https://github.com/fdac18/Miniproject3/blob/master/Q9.png)
![Question10](https://github.com/fdac18/Miniproject3/blob/master/Q10.png)
![Question11](https://github.com/fdac18/Miniproject3/blob/master/Q11.png)
![Question12](https://github.com/fdac18/Miniproject3/blob/master/Q12.png)

## Meaning of fields
|Columns|Meaning|
|:-:|:-:|:-:|---|
PG1PsnUse|	For personal work and/or research use
PG1WdAuth|	For a wider audience, such as developers of other packages or other software
PG1Trn |	For a training / class that I took
PG1Other|	Other purposes
PG4Dtr0_6|	Detractors (0-6)
PG4Psv7_8|	Passives (7-8)
PG4Prm9_10|	Promoters (9-10)
PG4AllResp|	All Response
PG5_1RRPQ|	Resolve Reported Problems Quickly
PG5_2BNUI|	Backlog / # of Unresolved Issues
PG5_3HDS|	Helpful Discussion on StackExchange
PG5_4VGP|	Visible Growth in Popularity
PG5_5PHR|	Package's Historic Reputation
PG5_6SSYOP|	Scale / Size of Your Own Project
PG5_7NDYP|	# Developers of Your Project
PG5_8CP|	Computing Performances
PG5_9FRP|	"Familiarity with Related Packages"
PG5_10RPA|	Reputation of the Package's Authors
PG5_11NSG|	# of Stars on GitHub
PG5_12NWG|	# of Watchers on GitHub
PG5_13NFG|	# of Forks on GitHub
PGXResp|	Response time of question on page X
PGXSubmit|	The submission time of page X
PG5_XOrder|	The order of 13 factors the recipient take to deal with question on Page 5
PG5_XTime|	The completion time of dealing with factor X (e.g. 9 -> PG5_9FRP) on Page 5
PG0Dis|	Participati Display(Hours)
PG0Shown|	Participants Shown


## Model response variable

| Response  | GitHub Username | NetID | Name |
|:-:|:-:|:-:|---|
| Resolves Prooblems quickly | 3PIV | pprovins | Provins IV, Preston |
| Resolves Prooblems quickly | BrettBass13 | bbass11 | Bass, Brett Czech |
| Resolves Prooblems quickly | CipherR9 | gyj992 | Johnson, Rojae Antonio |
| Historic Reputation | Colsarcol | cmawhinn | Mawhinney, Colin Joseph |
| Historic Reputation | EvanEzell | eezell3 | Ezell, Evan Collin |
| Historic Reputation | MikeynJerry | jdunca51 | Duncan, Jerry |
| Performmance | Tasmia | trahman4 | Rahman, Tasmia |
| Perforamnce | awilki13 | awilki13 | Wilkinson, Alex Webb |
| Performance | bryanpacep1 | jpace7 | Pace, Jonathan Bryan |
| StackExchange | caiwjohn | cjohn3 | John, Cai William |
| StackExchange | cflemmon | cflemmon | Flemmons, Cole |
| StackExchange | dbarry9 | dbarry | Barry, Daniel Patrick |
| Growth In Popularity | desai07 | adesai6 | Desai, Avie |
| Growth In Popularity | gjones1911 | gjones2 | Jones, Gerald Leon |
| #Devs in your poproject | herronej | eherron5 | Herron, Emily Joyce |
| #Devs in your poproject | hossain-rayhan | rhossai2 | Hossain, Rayhan |
| #Forks on GitHub | jdong6 | jdong6 | Dong, Jeffrey Jing |
| #Forks on GitHub | jyu25utk | jyu25 | Yu, Jinxiao |
| Familiarity with related packages | mkramer6 | mkramer6 | Kramer, Matthew S |
| Familiarity with related packages | mmahbub | mmahbub | Mahbub, Maria |
| Scale/Size of your project | nmansou4 | nmansou4 | Mansour, Nasib |
| Scale/Size of your project  | nschwerz | nschwerz | Schwerzler, Nicolas Winfield William |
| Reputation of Authors | rdabbs42 | rdabbs1 | Dabbs, Rosemary |
| Reputation of Authors | saramsv | mousavi | Mousavicheshmehkaboodi, Sara |
| Reputation of Authors | spaulsteinberg | ssteinb2 | Steinberg, Samuel Paul |
| Issue backlog | zol0 | akarnauc | Karnauch, Andrey |
| Issue backlog | zrandall | zrandall | Randall, Zachary Adams |
| Issue backlog | lpassarella | lpassare | Passarella, Linsey Sara |
| #stars on github | tgoedecke | pgoedec1 | Goedecke, Trish |
| #stars on github | ray830305 | hchang13 | Chang, Hsun Jui |
| #stars on github | ssravali | ssadhu2 | Sadhu, Sri Ravali |
| #watchers on GitHub | diadoo | jpovlin | Povlin, John P |
| #watchers on GitHub | mander59 | mander59 | Anderson, Matt Mcguffee |
| #watchers on GitHub | iway1 | iway1 | Way, Isaac Caldwell |
