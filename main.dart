import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'dart:async';

int turn=0;
int mode=0;
int horN=5;
int winS=4;

List<int> tableV=List<int>();
_MyGameState myStat;

restartList(){
  for (var i=0; i<tableV.length; i++){
    tableV[i]=0;
  }
}

bool checkIfDraw(){
  bool draw=true;
  for(var i=0; i<tableV.length; i++){
    if(tableV[i]==3 || tableV[i]==0){
    draw=false;
    break;
    }
  }
  return draw;
}

bool firstCheck(int xx){
  int hh=xx%horN;
  int vv=xx~/horN;
  int val=tableV[xx];
  int checkVal=0;
  List<int> nums=List<int>();

  for(var i=0; i<horN; i++){
    if(tableV[vv*horN+i]==val){
    checkVal+=1;
    nums.add(vv*horN+i);
    }
    else
    if(checkVal<winS){
    checkVal=0;
    nums.clear();
    }
  }

  if(secondCheck(checkVal, nums)) return true;
  nums.clear();
  checkVal=0;

  for(var i=0; i<horN; i++){
    if(tableV[i*horN+hh]==val){
    checkVal+=1;
    nums.add(i*horN+hh);
    }
    else
    if(checkVal<winS){
    checkVal=0;
    nums.clear();
    }
  }

  if(secondCheck(checkVal, nums)) return true;
  nums.clear();
  checkVal=0;
  
  for(var i=-horN; i<horN; i++){
    if(hh-i>-1 && hh-i<horN && vv+i>-1 && vv+i<horN){
    if(tableV[(vv+i)*horN+hh-i]==val){
    checkVal+=1;
    nums.add((vv+i)*horN+hh-i);
    }
    else
    if(checkVal<winS){
    checkVal=0;
    nums.clear();
    }
    }
  }

  if(secondCheck(checkVal, nums)) return true;
  nums.clear();
  checkVal=0;
  
  for(var i=-horN; i<horN; i++){
    if(hh+i>-1 && vv+i>-1 && hh+i<horN && vv+i<horN){
    if(tableV[(vv+i)*horN+hh+i]==val){
    checkVal+=1;
    nums.add((vv+i)*horN+hh+i);
    }
    else
    if(checkVal<winS){
    checkVal=0;
    nums.clear();
    }
    }
  }

  if(secondCheck(checkVal, nums)) return true;
  nums.clear();
  checkVal=0;
  
  return false;
}

bool secondCheck(int checkVal, List<int> nums){
  if(checkVal>=winS){
    for(var i=0; i<nums.length; i++){
      tableV[nums[i]]=7+turn;
    }
    return true;
  }
  return false;
}

void main(){
  for(var i=0; i<horN*horN; i++){
    tableV.add(0);
  }
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context){
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (info)=> ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: info
      ),
      themedWidgetBuilder: (context, theme){
         return MaterialApp(
          title: "Blind Tic-Tac-Toe",
          theme: theme,
          home:MyGame()
        );
      },
    );
  }
}

class MyGame extends StatefulWidget {
  MyGame({Key key}):super(key:key);

  _MyGameState createState(){
    myStat=new _MyGameState();
    return myStat;
  }
}

class _MyGameState extends State<MyGame> {
  OverlayEntry oEntry;

  restarting(){
    this.setState((){

    });
  }

  @override
  void initState(){
    super.initState();

    _startTimer(1000);
  }

  _checkOverlay(){
    if(mode==0){
      this.oEntry=_createOEntry(context);
      Overlay.of(context).insert(this.oEntry);
    }
  }
  
  _startTimer(int milliseconds){
    Duration duration=Duration(milliseconds: milliseconds);

    return new Timer(duration, _checkOverlay);
  }

  OverlayEntry _createOEntry(BuildContext context){
    return OverlayEntry(
      builder: (context){
        return new Center(
          child: FlatButton(
            child: new Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
                border: Border.all(style: BorderStyle.none)
              ),
              child: Icon(Icons.play_arrow, size: 90, color: Theme.of(context).backgroundColor)
            ),
            onPressed: (){
              this.oEntry.remove();
              mode=1;
              DynamicTheme.of(context).setThemeData(
                new ThemeData (
                  primarySwatch: Colors.blue
                )
              );
              setState(() {
                
              });
            },
          )
        );
      }
    );
  }

  Widget build(BuildContext context){
    return new Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(10.0),
        margin:EdgeInsets.all(0.0),
        child: Column(
        children: allRows(context)
        )
      )
    );
  }
}

List<Widget> allRows(BuildContext context){
  List<Widget> rows=List<Widget>();
  rows.add(headerRow(context));
  for(var i=0; i<horN; i++){
    if(i<horN-1){
      rows.add(gameRow(i, context));
      rows.add(divisionRow(context));
    }
    else {
      rows.add(gameRow(i, context));
    }
  }
  rows.add(footerRow(context));

  return rows;
}

Widget headerRow(context){
  return new Expanded(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Container(
          alignment: Alignment.center,
          child: Text("Blind Tic-Tac-Toe", maxLines: 1, style: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 32.0, fontWeight: FontWeight.bold),)
        ),
        IconButton(
          padding: EdgeInsets.only(right:8.0),
          icon: mode==0?Icon(Icons.help_outline, size:32.0, color: Theme.of(context).backgroundColor): Icon(Icons.arrow_back, size:32.0, color: Theme.of(context).backgroundColor),
          onPressed: (){
            if(mode==0){
              myStat.oEntry.remove();
              showDialog(
                context: context,
                builder: (c){
                  return new AlertDialog(
                    title: Text("Help", style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Column(
                      children: <Widget>[
                        Text("A traditional Tic-Tac-Toe except for the fact that you cannot see where you have put Xs and Os until someone wins or the game ends in a draw! Blind Tic-Tac-Toe."),
                        Text("You can choose the Grid Size and the Number of straight Xs or Os it takes to win.")
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: (){
                          myStat._startTimer(1000);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
            }
            else {
              showDialog(
                context: context,
                builder: (c){
                  return new AlertDialog(
                    title: Text("Return to Menu?", style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Container(
                      width: 1,
                      height: 1
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: (){
                          mode=0;
                          turn=0;
                          myStat._startTimer(1000);
                          tableV.clear();
                          for(var i=0; i<horN*horN; i++){
                            tableV.add(0);
                          }
                          DynamicTheme.of(context).setThemeData(
                            new ThemeData (
                              primarySwatch: Colors.blueGrey
                            )
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
            }
          },
        )
      ],
    ) 
  );
}

Widget footerRow(context){
  return new Expanded(
    child: mode>0?new Container(
    color: Theme.of(context).primaryColor,
    alignment: Alignment.center,
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
      new Container(
        child: turn<2? Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text("Turn: Player ", maxLines: 1, style: TextStyle(color:Theme.of(context).backgroundColor, fontSize: 28.0)),
            Text(turn==0?"X":"O", maxLines: 1, style: TextStyle(color:Colors.black, fontSize: 32.0, fontWeight: FontWeight.bold))
          ]
        ):
        turn<4? Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text("Player ", maxLines: 1, style: TextStyle(color:Theme.of(context).backgroundColor, fontSize: 28.0)),
            Text(turn==2?"X":"O", maxLines: 1, style: TextStyle(color:Colors.black, fontSize: 32.0, fontWeight: FontWeight.bold)),
            Text(" Wins!", maxLines: 1, style: TextStyle(color:Theme.of(context).backgroundColor, fontSize: 28.0))
          ]
        ):
        Text("Draw!", maxLines: 1, style: TextStyle(color:Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold)),
      ),
      new IconButton(
        icon: new Icon(Icons.refresh, size: 32.0, color: Theme.of(context).backgroundColor),
        onPressed: (){
          turn=0;
          mode=1;
          DynamicTheme.of(context).setThemeData(
            new ThemeData (
              primarySwatch: Colors.blue
            )
          );
          restartList();
          
          myStat.restarting();
        },
      )
    ],)
  ):
  new Container(
    color: Theme.of(context).primaryColor,
    alignment: Alignment.center,
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new IconButton(icon: Icon(Icons.remove_circle_outline, size:32.0 , color: Theme.of(context).backgroundColor), padding: EdgeInsets.only(right: 5.0), onPressed: (){
              if(horN>3 && horN>winS){
              horN-=1;
              tableV.clear();
              for(var i=0; i<horN*horN; i++){
                tableV.add(0);
              }
              myStat.restarting();
              }
            },),
            new Text("Grid: ", maxLines: 1, style: TextStyle(color:Theme.of(context).backgroundColor, fontSize: 20.0)),
            new Text(horN.toString(), maxLines: 1, style: TextStyle(color:Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold)),
            new IconButton(icon: Icon(Icons.add_circle_outline, size:32.0 , color: Theme.of(context).backgroundColor), padding: EdgeInsets.only(left: 5.0), onPressed: (){
              if(horN<8){
              horN+=1;
              tableV.clear();
              for(var i=0; i<horN*horN; i++){
                tableV.add(0);
              }
              myStat.restarting();
              }
            },),
          ],
        ),
        Row(
          children: <Widget>[
            new IconButton(icon: Icon(Icons.remove_circle_outline, size:32.0 , color: Theme.of(context).backgroundColor), padding: EdgeInsets.only(right: 5.0), onPressed: (){
              if(winS>3){
              winS-=1;
              myStat.restarting();
              }
            },),
            new Text("To Win: ", maxLines: 1, style: TextStyle(color:Theme.of(context).backgroundColor, fontSize: 20.0)),
            new Text(winS.toString(), maxLines: 1, style: TextStyle(color:Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold)),
            new IconButton(icon: Icon(Icons.add_circle_outline, size:32.0 , color: Theme.of(context).backgroundColor), padding: EdgeInsets.only(right: 5.0), onPressed: (){
              if(winS<horN){
              winS+=1;
              myStat.restarting();
              }
            },),
          ],
        )
      ]
    )
  ));
}

Widget divisionRow(context){
  return new Container(
    padding: EdgeInsets.all(0.0),
    margin:EdgeInsets.all(0.0),
    height: 5.0,
    color: Theme.of(context).primaryColor,
  );
}

Widget gameRow(int row, BuildContext context){
  List<Widget> rows=List<Widget>();
  
  for(var i=0; i<horN; i++){
    if(i>0)
    rows.add(tableDiv(context));
    rows.add(tableCell(row*horN+i, context));
  }

  return new Expanded(
    child: new Container(
    padding: EdgeInsets.all(0.0),
    margin:EdgeInsets.all(0.0),
    child: new Row(
    children: rows
    )
    )
  );
}

Widget tableCell(int v, BuildContext context){
  var realV=tableV[v];
  
  return new Expanded(
    child: new Container(
      padding: EdgeInsets.all(0.0),
      margin:EdgeInsets.all(0.0),
      child: FlatButton(
      onPressed: (){
        if(realV==0 && turn==0 && mode==1){
          tableV[v]=4;
          mode=2;
          DynamicTheme.of(context).setThemeData(new ThemeData(
            primarySwatch: Colors.lightBlue
          ));
          turn=1;
          for(var i=0; i<tableV.length; i++){
            if(tableV[i]==0)
            tableV[i]=3;
          }
          myStat.restarting();
        }
        else
        if(turn<2 && mode==2){
          if(realV==3 && turn==0)
          tableV[v]=4;
          else
          if(realV==3 && turn==1)
          tableV[v]=5;
          bool winning=firstCheck(v);
          if(winning==true){
            for(var i=0; i<tableV.length; i++){
              tableV[i]-=3;
            }
            if(turn==0)
            turn=2;
            else
            if(turn==1)
            turn=3;
          }
          else if(checkIfDraw()){
            for(var i=0; i<tableV.length; i++){
              tableV[i]-=3;
            }
            DynamicTheme.of(context).setThemeData(new ThemeData(
              primarySwatch: Colors.blueGrey
            ));
            turn=4;
          }
          else
          if(turn==0){
          turn=1;
          DynamicTheme.of(context).setThemeData(new ThemeData(
            primarySwatch: Colors.lightBlue
          ));
          }
          else
          if(turn==1){
          turn=0;
          DynamicTheme.of(context).setThemeData(new ThemeData(
            primarySwatch: Colors.blue
          ));
          }
          myStat.restarting();
        }
      },
      child: new Container(
      padding: EdgeInsets.all(0.0),
      margin:EdgeInsets.all(0.0),
      child: new Center(
        child: new Container(
          child: realV%3>0?Image.asset("images/cell"+(realV%3).toString()+".png"):Text("")
        )
      ),
    ),
      color: turn>1 && realV<3 && realV>0?Theme.of(context).primaryColor:realV<3?Theme.of(context).backgroundColor:turn<2?Colors.black:Theme.of(context).primaryColorDark,
    )
    )
  );
}

Widget tableDiv(context){
  return new Container(
    padding: EdgeInsets.all(0.0),
    margin:EdgeInsets.all(0.0),
    width: 5.0,
    color: Theme.of(context).primaryColor,
  );
}