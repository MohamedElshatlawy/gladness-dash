class ReservationModel{
  String firebaseID;
  String clientID;
  Map<String,dynamic> selectedItems;
  String selectedDate;
  String selectedTime;
  String totalPrice;
  String paymentMethod;
  String notes;
  String status;
  int timeStamp;
ReservationModel.fromJson({String id, Map<String, dynamic> json}){
this.firebaseID=id;

this.clientID=json['client_id'];
this.selectedItems=json['selected_items'];
this.selectedDate=json['selected_date'];
this.selectedTime=json['selected_time'];
this.totalPrice=json['total'];
this.paymentMethod=json['payment'];
this.notes=json['notes'];
this.timeStamp=json['time_stamp'];
this.status=json['status'];
}
ReservationModel({this.notes,this.paymentMethod,this.totalPrice,this.selectedDate,this.selectedItems,this.clientID,this.firebaseID});
  toMap()=>{
    
    "client_id":this.clientID,
    "selected_items":this.selectedItems,
    "selected_date":this.selectedDate,
    "total":this.totalPrice,
    "payment":this.paymentMethod,
    "notes":this.notes,
    "time_stamp":DateTime.now().millisecondsSinceEpoch,
    "status":"confirm"
  };

}