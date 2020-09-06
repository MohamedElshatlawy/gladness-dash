class MsgModel{
  String id;
  String name;
  String phone;
  String mail;
  String msg;
  MsgModel({this.id,this.mail,this.msg,this.name,this.phone});
MsgModel.fromJson(String id,Map<String,dynamic> json){
  this.id=id;
  this.name=json['name'];
  this.phone=json['phone'];
  this.mail=json['mail'];
  this.msg=json['msg'];
}
  toMap()=>{
    "name":this.name,
    "phone":this.phone,
    "mail":this.mail,
    "msg":this.msg
  };
}