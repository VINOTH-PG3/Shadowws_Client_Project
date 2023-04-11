class Client {
  String? id;
  String? category;
  String? fName;
  String? dName;
  String? uName;
  String? email;
  String? password;
  String? mobile;
  String? countryId;
  String? countryMobileCode;
  String? alterMobile;
  String? clientId;
  String? gender;
  String? companyName;
  String? gstNo;
  String? location;
  String? taxReg;
  String? panNo;
  String? primaryAddr;
  String? sameAdd;
  String? secondatyAddr;
  String? image;
  String? quoId;
  String? status;
  String? sms;
  String? mail;
  String? createdBy;
  String? chatOnlineStatus;
  String? createdAt;
  Null notifyId;

 Client(
      { this.id,
         this.category,
         this.fName,
         this.dName,
         this.uName,
         this.email,
         this.password,
         this.mobile,
         this.countryId,
         this.countryMobileCode,
         this.alterMobile,
         this.clientId,
         this.gender,
         this.companyName,
         this.gstNo,
         this.location,
         this.taxReg,
         this.panNo,
         this.primaryAddr,
         this.sameAdd,
         this.secondatyAddr,
         this.image,
         this.quoId,
         this.status,
         this.sms,
         this.mail,
         this.createdBy,
         this.chatOnlineStatus,
         this.createdAt,
        this.notifyId});

 Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    fName = json['f_name'];
    dName = json['d_name'];
    uName = json['u_name'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    countryId = json['country_id'];
    countryMobileCode = json['country_mobile_code'];
    alterMobile = json['alter_mobile'];
    clientId = json['client_id'];
    gender = json['gender'];
    companyName = json['company_name'];
    gstNo = json['gst_no'];
    location = json['location'];
    taxReg = json['tax_reg'];
    panNo = json['pan_no'];
    primaryAddr = json['primary_addr'];
    sameAdd = json['same_add'];
    secondatyAddr = json['secondaty_addr'];
    image = json['image'];
    quoId = json['quo_id'];
    status = json['status'];
    sms = json['sms'];
    mail = json['mail'];
    createdBy = json['created_by'];
    chatOnlineStatus = json['chat_online_status'];
    createdAt = json['created_at'];
    notifyId = json['notify_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['f_name'] = this.fName;
    data['d_name'] = this.dName;
    data['u_name'] = this.uName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['country_id'] = this.countryId;
    data['country_mobile_code'] = this.countryMobileCode;
    data['alter_mobile'] = this.alterMobile;
    data['client_id'] = this.clientId;
    data['gender'] = this.gender;
    data['company_name'] = this.companyName;
    data['gst_no'] = this.gstNo;
    data['location'] = this.location;
    data['tax_reg'] = this.taxReg;
    data['pan_no'] = this.panNo;
    data['primary_addr'] = this.primaryAddr;
    data['same_add'] = this.sameAdd;
    data['secondaty_addr'] = this.secondatyAddr;
    data['image'] = this.image;
    data['quo_id'] = this.quoId;
    data['status'] = this.status;
    data['sms'] = this.sms;
    data['mail'] = this.mail;
    data['created_by'] = this.createdBy;
    data['chat_online_status'] = this.chatOnlineStatus;
    data['created_at'] = this.createdAt;
    data['notify_id'] = this.notifyId;
    return data;
  }
}
class Project {
  String? id;
  String? name;
  String? priority;
  String? hours;
  String? sDate;
  String? eDate;
  String? type;
  String? client;
  String? location;
  String? projectId;
  String? desp;
  String? doc;
  String? shareDocTl;
  String? adminStatus;
  String? tlId;
  String? empId;
  String? pmStatus;
  String? isInv;
  String? quotation;
  String? projectId2;
  String? accLocation;
  String? createdBy;
  String? createdAt;
  String? quoId;
  String? newClientId;
  String? execClientId;

  Project(
      {this.id,
        this.name,
        this.priority,
        this.hours,
        this.sDate,
        this.eDate,
        this.type,
        this.client,
        this.location,
        this.projectId,
        this.desp,
        this.doc,
        this.shareDocTl,
        this.adminStatus,
        this.tlId,
        this.empId,
        this.pmStatus,
        this.isInv,
        this.quotation,
        this.projectId2,
        this.accLocation,
        this.createdBy,
        this.createdAt,
        this.quoId,
        this.newClientId,
        this.execClientId});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    priority = json['priority'];
    hours = json['hours'];
    sDate = json['s_date'];
    eDate = json['e_date'];
    type = json['type'];
    client = json['client'];
    location = json['location'];
    projectId = json['project_id'];
    desp = json['desp'];
    doc = json['doc'];
    shareDocTl = json['share_doc_tl'];
    adminStatus = json['admin_status'];
    tlId = json['tl_id'];
    empId = json['emp_id'];
    pmStatus = json['pm_status'];
    isInv = json['is_inv'];
    quotation = json['quotation'];
    projectId2 = json['project_id2'];
    accLocation = json['acc_location'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    quoId = json['quo_id'];
    newClientId = json['new_client_id'];
    execClientId = json['exec_client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['priority'] = this.priority;
    data['hours'] = this.hours;
    data['s_date'] = this.sDate;
    data['e_date'] = this.eDate;
    data['type'] = this.type;
    data['client'] = this.client;
    data['location'] = this.location;
    data['project_id'] = this.projectId;
    data['desp'] = this.desp;
    data['doc'] = this.doc;
    data['share_doc_tl'] = this.shareDocTl;
    data['admin_status'] = this.adminStatus;
    data['tl_id'] = this.tlId;
    data['emp_id'] = this.empId;
    data['pm_status'] = this.pmStatus;
    data['is_inv'] = this.isInv;
    data['quotation'] = this.quotation;
    data['project_id2'] = this.projectId2;
    data['acc_location'] = this.accLocation;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['quo_id'] = this.quoId;
    data['new_client_id'] = this.newClientId;
    data['exec_client_id'] = this.execClientId;
    return data;
  }
}

class ProjectErrorData {
  String project;
  DateTime errorDate;
  String errorUpdaterName;
  String errorTitle;
  String description;

  ProjectErrorData({
    required this.project,
    required this.errorDate,
    required this.errorUpdaterName,
    required this.errorTitle,
    required this.description,
  });
}

class Event {
  String title;
  String type;
  DateTime date;

  Event({
    required this.title,
    required this.type,
    required this.date,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      type: json['type'],
      date: DateTime.parse(json['date']),
    );
  }
}