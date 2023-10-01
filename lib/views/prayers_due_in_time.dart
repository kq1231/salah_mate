import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salah_mate/controllers/prayer_controller.dart';
import '../models/prayer_types.dart';
import 'package:salah_mate/design.dart';

class PrayersDueInTimePage extends ConsumerStatefulWidget {
  final String date;
  const PrayersDueInTimePage({super.key, required this.date});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrayersDueInTimePageState();
}

class _PrayersDueInTimePageState extends ConsumerState<PrayersDueInTimePage> {
  @override
  void deactivate() {
    ref.read(prayersProvider.notifier).clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var prayers = ref.watch(prayersProvider).prayers;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemBuilder: (context, fardhIndex) {
                  Fardh fardh = prayers.values.elementAt(fardhIndex)["fardh"];
                  List<Sunnah> sunnahs =
                      prayers.values.elementAt(fardhIndex)["sunnahs"];
                  Witr witr = prayers.values.last["witr"];

                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        fardh.name.toUpperCase(),
                        style: dTextTitleStyle100,
                      ),
                      leading: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setFardhState) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: "At Home",
                                child: Checkbox(
                                  onChanged: (value) {
                                    fardh.status = !fardh.status;
                                    ref
                                        .read(prayersProvider.notifier)
                                        .syncStatus(fardh, "faraidh");
                                    setFardhState(() {});
                                  },
                                  value: fardh.status,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Transform.scale(
                                scale: 1.5,
                                child: Tooltip(
                                  message: "At the Masjid",
                                  child: Checkbox(
                                    activeColor: Colors.green[300],
                                    onChanged: (value) {
                                      fardh.withJamaah = !fardh.withJamaah;
                                      ref
                                          .read(prayersProvider.notifier)
                                          .syncStatus(fardh, "faraidh");
                                      setFardhState(() {});
                                    },
                                    value: fardh.withJamaah,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      children: [
                        ListView.builder(
                          itemBuilder: (context, sunnahIndex) {
                            Sunnah sunnah = sunnahs[sunnahIndex];
                            return SubPrayerListTile(
                                prayer: sunnah, table: "sunnahs", ref: ref);
                          },
                          shrinkWrap: true,
                          itemCount: sunnahs.length,
                        ),
                        fardh.name == "isha"
                            ? SubPrayerListTile(
                                prayer: witr, table: "witr", ref: ref)
                            : Container()
                      ],
                    ),
                  );
                },
                itemCount: 5,
              );
            } else {
              return Center(
                  child: Transform.scale(
                scale: 3,
                child: const CircularProgressIndicator(
                  strokeWidth: 7,
                  backgroundColor: Colors.red,
                  color: Colors.amberAccent,
                ),
              ));
            }
          },
          future: ref.read(prayersProvider.notifier).fetchPrayers(widget.date),
        ),
      ),
    );
  }
}

class SubPrayerListTile extends StatelessWidget {
  final Prayer prayer;
  final String table;
  final WidgetRef ref;
  const SubPrayerListTile(
      {super.key,
      required this.prayer,
      required this.table,
      required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        prayer.runtimeType.toString(),
        style: dTextTitleStyle50,
      ),
      leading: Text(
        prayer.units.toString(),
        style: dTextTitleStyle50,
      ),
      trailing: StatefulBuilder(
        builder: (BuildContext context,
            void Function(void Function()) setprayerState) {
          return Checkbox(
            onChanged: (value) {
              prayer.status = !prayer.status;
              ref.read(prayersProvider.notifier).syncStatus(prayer, table);
              setprayerState(() {});
            },
            value: prayer.status,
          );
        },
      ),
    );
  }
}
