class Prayer {
  final String id;
  final String time;
  final String name;
  final String date;
  bool status;
  final int units;

  Prayer(
    this.id,
    this.name,
    this.date,
    this.units,
    this.time,
    this.status,
  );
}

class Fardh extends Prayer {
  bool withJamaah = false;
  Fardh(id, name, date, units, time, status, this.withJamaah)
      : super(id, name, date, units, time, status);
}

class Sunnah extends Prayer {
  Sunnah(id, name, date, units, time, status)
      : super(id, name, date, units, time, status);
}

class Witr extends Prayer {
  Witr(id, name, date, units, time, status)
      : super(id, name, date, units, time, status);
}

class Nafl extends Prayer {
  Nafl(id, name, date, units, time, status)
      : super(id, name, date, units, time, status);
}
