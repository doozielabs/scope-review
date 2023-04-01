enum PaymentType {
  check,
  cash,
  electronicPayment,
  electronicPaymentviaScope,
}

enum InspectionType {
  ongoing,
  scheduled,
  unpublished,
  completed,
  trashed,
  none,
}

enum TemplateItemType {
  text,
  email,
  phone,
  photo,
  choice,
  website,
  currency,
  signature,
  timestamp,
  organization,
}

enum CommentType {
  // safety,
  deficiency,
  // acceptable,
  information,
  notInspected,
}

enum CommentLevel {
  homeBuyer,
  contractor,
}

enum PlanType {
  free,
  monthly,
  yearly,
  custom,
}

enum UserType {
  inspector,
  admin,
}

enum PersonType {
  seller,
  buyer,
  client,
}

enum SheepType {
  sync,
  delete,
  add,
  none,
}

enum SheepMember {
  inspection,
}

enum MediaCorbaMediaType {
  user,
  section,
  comment,
  itemPhoto,
  inspectionThumbnail,
  profile,
  expense
}
