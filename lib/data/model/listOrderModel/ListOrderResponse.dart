class ListOrderResponse {
  bool? success;
  Null? message;
  Data? data;

  ListOrderResponse({this.success, this.message, this.data});

  ListOrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Orders>? orders;

  Data({this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  dynamic? id;
  dynamic? userId;
  dynamic? addressId;
  dynamic couponId;
  dynamic? offerId;
  dynamic branchId;
  String? type;
  String? typeLang;
  dynamic total;
  String? status;
  String? deliveryDate;
  String? receivedDate;
  String? payment;
  String? notes;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  dynamic adminNotes;
  String? orderNumber;
  String? number;
  dynamic deliveryCost;
  dynamic discount;
  dynamic isPaid;
  String? keyWeeklyLoop;
  dynamic totalAfterDiscount;
  dynamic bagNumber;
  dynamic orderCode;
  dynamic acceptId;
  dynamic pickupId;
  dynamic dropoffId;
  List<OrderItems>? orderItems;
  Address? address;

  Orders(
      {this.id,
        this.userId,
        this.addressId,
        this.couponId,
        this.offerId,
        this.branchId,
        this.type,
        this.typeLang,
        this.total,
        this.status,
        this.deliveryDate,
        this.receivedDate,
        this.payment,
        this.notes,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.adminNotes,
        this.orderNumber,
        this.number,
        this.deliveryCost,
        this.discount,
        this.isPaid,
        this.keyWeeklyLoop,
        this.totalAfterDiscount,
        this.bagNumber,
        this.orderCode,
        this.acceptId,
        this.pickupId,
        this.dropoffId,
        this.orderItems,
        this.address});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressId = json['address_id'];
    couponId = json['coupon_id'];
    offerId = json['offer_id'];
    branchId = json['branch_id'];
    type = json['type'];
    typeLang = json['type_lang'];
    total = json['total'];
    status = json['status'];
    deliveryDate = json['delivery_date'];
    receivedDate = json['received_date'];
    payment = json['payment'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    adminNotes = json['admin_notes'];
    orderNumber = json['order_number'];
    number=json['number'];
    deliveryCost = json['delivery_cost'];
    discount = json['discount'];
    isPaid = json['is_paid'];
    keyWeeklyLoop = json['key_weekly_loop'];
    totalAfterDiscount = json['total_after_discount'];
    bagNumber = json['bag_number'];
    orderCode = json['order_code'];
    acceptId = json['accept_id'];
    pickupId = json['pickup_id'];
    dropoffId = json['dropoff_id'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['coupon_id'] = this.couponId;
    data['offer_id'] = this.offerId;
    data['branch_id'] = this.branchId;
    data['type'] = this.type;
    data['type_lang'] = this.typeLang;
    data['total'] = this.total;
    data['status'] = this.status;
    data['delivery_date'] = this.deliveryDate;
    data['received_date'] = this.receivedDate;
    data['payment'] = this.payment;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['admin_notes'] = this.adminNotes;
    data['order_number'] = this.orderNumber;
    data['number'] = this.number;
    data['delivery_cost'] = this.deliveryCost;
    data['discount'] = this.discount;
    data['is_paid'] = this.isPaid;
    data['key_weekly_loop'] = this.keyWeeklyLoop;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['bag_number'] = this.bagNumber;
    data['order_code'] = this.orderCode;
    data['accept_id'] = this.acceptId;
    data['pickup_id'] = this.pickupId;
    data['dropoff_id'] = this.dropoffId;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class OrderItems {
  dynamic? id;
  dynamic? orderId;
  dynamic? productId;
  dynamic? price;
  dynamic? quantity;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;

  OrderItems(
      {this.id,
        this.orderId,
        this.productId,
        this.price,
        this.quantity,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Address {
  dynamic? id;
  dynamic? userId;
  String? streetName;
  String? lat;
  String? lng;
  String? type;
  dynamic? isDefault;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
        this.userId,
        this.streetName,
        this.lat,
        this.lng,
        this.type,
        this.isDefault,
        this.createdAt,
        this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    streetName = json['street_name'];
    lat = json['lat'];
    lng = json['lng'];
    type = json['type'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['street_name'] = this.streetName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['type'] = this.type;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}