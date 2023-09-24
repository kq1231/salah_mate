import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_mate/controllers/prayer_structure.dart';
import 'supabase_client.dart';

class DatesNotifier extends ChangeNotifier {
  List dates = [];
  Future<void> fetchDates() async {
    dates.isNotEmpty ? dates = [] : null;
    var data = (await client.from("faraidh").select("date"));
    for (Map _ in data) {
      dates.contains(_["date"]) ? 0 : dates.add(_["date"]);
    }
  }

  Future<void> initDateToSupabase(String date) async {
    // Init faraidh, sunnahs and witr
    prayerStructure["faraidh"]!.forEach((prayerName, prayerDetails) async {
      await client.from("faraidh").insert({"date": date, "name": prayerName});

      List<int> sunnahUnits = prayerDetails["sunnahs"] as List<int>;
      for (int units in sunnahUnits) {
        await client.from("sunnahs").insert({
          "date": date,
          "units": units,
          "name": prayerName,
        });
      }
    });
    await client.from("witr").insert({"date": date, "name": "isha"});
    await fetchDates();
    notifyListeners();
  }

  Future<void> addDate(String date) async {
    await initDateToSupabase(date);
  }

  Future<void> deleteDate(String date) async {
    dates.removeWhere((element) => element == date);
    notifyListeners();

    await client.from("faraidh").delete().eq("date", date);
    await client.from("sunnahs").delete().eq("date", date);
    await client.from("witr").delete().eq("date", date);
  }
}

final datesProvider = ChangeNotifierProvider<DatesNotifier>((ref) {
  return DatesNotifier();
});
