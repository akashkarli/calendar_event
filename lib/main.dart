import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_event/util/database_helper.dart';
import 'package:calendar_event/modal/event_vo.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final dbHelper = Database_helper.instance;
  DateTime selectedDate = DateTime.now();

  CalendarController _controller;
  TextEditingController _eventinsertcontroller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedevents;

  List<Map<String, dynamic>> queryData = [];

  EventCalendarVo calendarVo;
  String textShow = "";
  List<dynamic> eventsname;

  List _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
    _eventinsertcontroller = TextEditingController();
    _events = {};
    _selectedevents = [];
   }

  void insertdata(EventCalendarVo vo) async {
    int result = await dbHelper.insert(vo);
    print('inserted id $result');
  }

  void getdata({String dateChoice}) {
    var po = dbHelper.readDateByEntry(date: dateChoice).then((o) {
      queryData = o;
      textShow = "";
      if (queryData.isNotEmpty) {
        for (var q in queryData) {
          textShow += q["eventName"] + "\n";
        }
      } else {
        textShow = "No Data";
      }
    });
    print(po);
  }


  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventinsertcontroller,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventinsertcontroller.text.isEmpty) return;
                    setState(() {
                      if (_events[_controller.selectedDay] != null) {
                        _events[_controller.selectedDay]
                            .add(_eventinsertcontroller.text);
                        print('insert or save value');
                      } else {
                        _events[_controller.selectedDay] = [
                          _eventinsertcontroller.text
                        ];
                        print('already value save');
                      }

                      var ms = (new DateTime(
                              _controller.selectedDay.year,
                              _controller.selectedDay.month,
                              _controller.selectedDay.day)
                          .millisecondsSinceEpoch);
                      var a = (ms / 1000).round();

                      eventsname = _events.values.toList();

                      calendarVo = EventCalendarVo(
                          _eventinsertcontroller.text, a.toString());
                      _eventinsertcontroller.clear();
                      Navigator.pop(context);
                      getdata(dateChoice: a.toString());
                    });
                    insertdata(calendarVo);
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TECH EVENT DATE'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TableCalendar(
                events: _events,
                initialCalendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayColor: Colors.indigo,
                  selectedColor: Colors.blue,
                  outsideStyle: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Colors.black38),
                  weekdayStyle: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.black),
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white),
                  holidayStyle: TextStyle(fontSize: 17.0),
                ),
                calendarController: _controller,
                headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(fontSize: 20),
                    centerHeaderTitle: true,
                    formatButtonVisible: false),
                onDaySelected: (date, event) {
                  String selecteddate = DateFormat.yMMMd().format(date);
                  print(selecteddate);

                  setState(() {
                    _selectedevents = event;
                    if (_selectedevents.isEmpty == true) {
                      print('no value $_selectedevents');
                    } else {
                      print('selected events $_selectedevents');
                    }

                    var ms = DateTime(date.year, date.month, date.day)
                        .millisecondsSinceEpoch;
                    var st = (ms / 1000).round();
                    print(st);
                    getdata(dateChoice: st.toString());
                    dbHelper.read().then((o) {
                      print(o);
                    });
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
               Card(
                 elevation: 20.0,
                 child: Container(
                   width: double.infinity,
                  child: Text(
                    textShow,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
              ),
               ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _showAddDialog,
        ));
  }
}
