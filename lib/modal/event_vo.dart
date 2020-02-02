
class EventCalendarVo {
  int _id;
  String _eventname;
  String _eventdate;


  EventCalendarVo(
      this._eventname,
      this._eventdate
      );

  EventCalendarVo.withID(this._id,this._eventname,this._eventdate);

  EventCalendarVo.Map(dynamic obj){
    this._id=obj['id'];
    this._eventname=obj['eventname'];
    this._eventdate=obj['eventdate'];
  }

  Map<String, dynamic> toMap() {

    var map =Map<String,dynamic>();
    map['id'] = this._id;
    map['eventname'] =  this._eventname;
    map['eventdate'] = this._eventdate;
    return map;
  }


  EventCalendarVo.fromMapObject(Map<String,dynamic> map){
    this._id=map['id'];
    this._eventname=map['eventname'];
    this._eventdate=map['eventdate'];

  }

  String get eventdate => _eventdate;

  set eventdate(String value) {
    _eventdate = value;
  }

  String get eventname => _eventname;

  set eventname(String value) {
    _eventname = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}
