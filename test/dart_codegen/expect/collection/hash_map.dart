part of dart.collection;
 bool _defaultEquals(Object a, Object b) => a == b;
 int _defaultHashCode(Object a) => a.hashCode;
 typedef bool _Equality<K>(K a, K b);
 typedef int _Hasher<K>(K object);
 abstract class HashMap<K, V> implements Map<K, V> {external factory HashMap({
  bool equals(K key1, K key2), int hashCode(K key), bool isValidKey(potentialKey)}
);
 external factory HashMap.identity();
 factory HashMap.from(Map other) {
  HashMap<K, V> result = new HashMap<K, V>();
   other.forEach((k, v) {
    result[DEVC$RT.cast(k, dynamic, K, "CompositeCast", """line 87, column 35 of dart:collection/hash_map.dart: """, k is K, false)] = DEVC$RT.cast(v, dynamic, V, "CompositeCast", """line 87, column 40 of dart:collection/hash_map.dart: """, v is V, false);
    }
  );
   return result;
  }
 factory HashMap.fromIterable(Iterable iterable, {
  K key(element), V value(element)}
) {
  HashMap<K, V> map = new HashMap<K, V>();
   Maps._fillMapWithMappedIterable(map, iterable, key, value);
   return map;
  }
 factory HashMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
  HashMap<K, V> map = new HashMap<K, V>();
   Maps._fillMapWithIterables(map, keys, values);
   return map;
  }
}
