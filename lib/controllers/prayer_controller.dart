import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_mate/controllers/supabase_client.dart';
import 'package:salah_mate/models/faraidh_units.dart';
import '../models/prayer_types.dart';

class PrayersNotifier extends ChangeNotifier {
  Map prayers = {
    "fajr": {
      "fardh": Fardh,
      "sunnahs": <Sunnah>[],
    },
    "dhuhr": {
      "fardh": Fardh,
      "sunnahs": <Sunnah>[],
    },
    "asr": {
      "fardh": Fardh,
      "sunnahs": <Sunnah>[],
    },
    "maghrib": {
      "fardh": Fardh,
      "sunnahs": <Sunnah>[],
    },
    "isha": {
      "fardh": Fardh,
      "sunnahs": <Sunnah>[],
      "witr": Witr,
    },
  };

  Future<void> fetchPrayers(String date) async {
    List faraidh = (await client.from("faraidh").select("*").eq("date", date));
    List sunnahs = (await client.from("sunnahs").select("*").eq("date", date));
    Map witrData = (await client.from("witr").select("*").eq("date", date))[0];

    // Add faraidh
    for (Map fardhData in faraidh) {
      Fardh fardh = Fardh(
          fardhData["id"],
          fardhData["name"],
          fardhData["date"],
          FaraidhUnits.units[fardhData["name"]],
          fardhData["time"],
          fardhData["has_prayed"]);
      prayers[fardh.name]["fardh"] = fardh;
    }

    // Add sunnahs for each prayer
    for (Map sunnahData in sunnahs) {
      Sunnah sunnah = Sunnah(
          sunnahData["id"],
          sunnahData["name"],
          sunnahData["date"],
          sunnahData["units"],
          sunnahData["time"],
          sunnahData["has_prayed"]);
      prayers[sunnah.name]["sunnahs"].add(sunnah);
    }

    // Add witrData for Isha
    prayers["isha"]["witr"] = Witr(witrData["id"], witrData["name"],
        witrData["date"], 3, witrData["time"], witrData["has_prayed"]);
    debugPrint(prayers.toString());
  }

  Future<void> syncStatus(Prayer prayer, String table) async {
    await client
        .from(table)
        .update({"has_prayed": prayer.status}).eq("id", prayer.id);
  }

  void clear() {
    prayers = {
      "fajr": {
        "fardh": Fardh,
        "sunnahs": <Sunnah>[],
      },
      "dhuhr": {
        "fardh": Fardh,
        "sunnahs": <Sunnah>[],
      },
      "asr": {
        "fardh": Fardh,
        "sunnahs": <Sunnah>[],
      },
      "maghrib": {
        "fardh": Fardh,
        "sunnahs": <Sunnah>[],
      },
      "isha": {
        "fardh": Fardh,
        "sunnahs": <Sunnah>[],
      },
    };
  }
}

final prayersProvider = ChangeNotifierProvider<PrayersNotifier>((ref) {
  return PrayersNotifier();
});
