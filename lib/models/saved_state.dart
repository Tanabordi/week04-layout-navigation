import 'package:flutter/foundation.dart';

class SavedState {
  // ใช้ ValueNotifier เป็นตัวแปร Global เพื่อให้ UI อัปเดตเองตอนกดใจโดยไม่ต้องใช้ Provider
  static final ValueNotifier<Set<String>> savedIds = ValueNotifier({});

  static void toggleSave(String id) {
    // ต้องก๊อปปี้ Set ออกมาก่อน ค่อยอัปเดตกลับเข้าไป ไม่งั้น ValueNotifier มันจะไม่รู้ว่าค่าเปลี่ยน
    final newSet = Set<String>.from(savedIds.value);
    if (newSet.contains(id)) {
      newSet.remove(id);
    } else {
      newSet.add(id);
    }
    savedIds.value = newSet;
  }
}
