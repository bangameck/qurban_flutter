// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kupon_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKuponModelCollection on Isar {
  IsarCollection<KuponModel> get kuponModels => this.collection();
}

const KuponModelSchema = CollectionSchema(
  name: r'KuponModel',
  id: -469353309383532714,
  properties: {
    r'isScanned': PropertySchema(
      id: 0,
      name: r'isScanned',
      type: IsarType.bool,
    ),
    r'keterangan': PropertySchema(
      id: 1,
      name: r'keterangan',
      type: IsarType.string,
    ),
    r'kodeUnik': PropertySchema(
      id: 2,
      name: r'kodeUnik',
      type: IsarType.string,
    ),
    r'nama': PropertySchema(
      id: 3,
      name: r'nama',
      type: IsarType.string,
    ),
    r'needSync': PropertySchema(
      id: 4,
      name: r'needSync',
      type: IsarType.bool,
    ),
    r'tipe': PropertySchema(
      id: 5,
      name: r'tipe',
      type: IsarType.string,
    )
  },
  estimateSize: _kuponModelEstimateSize,
  serialize: _kuponModelSerialize,
  deserialize: _kuponModelDeserialize,
  deserializeProp: _kuponModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'kodeUnik': IndexSchema(
      id: -9156412923431130314,
      name: r'kodeUnik',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'kodeUnik',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _kuponModelGetId,
  getLinks: _kuponModelGetLinks,
  attach: _kuponModelAttach,
  version: '3.1.0+1',
);

int _kuponModelEstimateSize(
  KuponModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.keterangan;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.kodeUnik;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nama;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tipe;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _kuponModelSerialize(
  KuponModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isScanned);
  writer.writeString(offsets[1], object.keterangan);
  writer.writeString(offsets[2], object.kodeUnik);
  writer.writeString(offsets[3], object.nama);
  writer.writeBool(offsets[4], object.needSync);
  writer.writeString(offsets[5], object.tipe);
}

KuponModel _kuponModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KuponModel();
  object.id = id;
  object.isScanned = reader.readBool(offsets[0]);
  object.keterangan = reader.readStringOrNull(offsets[1]);
  object.kodeUnik = reader.readStringOrNull(offsets[2]);
  object.nama = reader.readStringOrNull(offsets[3]);
  object.needSync = reader.readBool(offsets[4]);
  object.tipe = reader.readStringOrNull(offsets[5]);
  return object;
}

P _kuponModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _kuponModelGetId(KuponModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _kuponModelGetLinks(KuponModel object) {
  return [];
}

void _kuponModelAttach(IsarCollection<dynamic> col, Id id, KuponModel object) {
  object.id = id;
}

extension KuponModelByIndex on IsarCollection<KuponModel> {
  Future<KuponModel?> getByKodeUnik(String? kodeUnik) {
    return getByIndex(r'kodeUnik', [kodeUnik]);
  }

  KuponModel? getByKodeUnikSync(String? kodeUnik) {
    return getByIndexSync(r'kodeUnik', [kodeUnik]);
  }

  Future<bool> deleteByKodeUnik(String? kodeUnik) {
    return deleteByIndex(r'kodeUnik', [kodeUnik]);
  }

  bool deleteByKodeUnikSync(String? kodeUnik) {
    return deleteByIndexSync(r'kodeUnik', [kodeUnik]);
  }

  Future<List<KuponModel?>> getAllByKodeUnik(List<String?> kodeUnikValues) {
    final values = kodeUnikValues.map((e) => [e]).toList();
    return getAllByIndex(r'kodeUnik', values);
  }

  List<KuponModel?> getAllByKodeUnikSync(List<String?> kodeUnikValues) {
    final values = kodeUnikValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'kodeUnik', values);
  }

  Future<int> deleteAllByKodeUnik(List<String?> kodeUnikValues) {
    final values = kodeUnikValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'kodeUnik', values);
  }

  int deleteAllByKodeUnikSync(List<String?> kodeUnikValues) {
    final values = kodeUnikValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'kodeUnik', values);
  }

  Future<Id> putByKodeUnik(KuponModel object) {
    return putByIndex(r'kodeUnik', object);
  }

  Id putByKodeUnikSync(KuponModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'kodeUnik', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKodeUnik(List<KuponModel> objects) {
    return putAllByIndex(r'kodeUnik', objects);
  }

  List<Id> putAllByKodeUnikSync(List<KuponModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'kodeUnik', objects, saveLinks: saveLinks);
  }
}

extension KuponModelQueryWhereSort
    on QueryBuilder<KuponModel, KuponModel, QWhere> {
  QueryBuilder<KuponModel, KuponModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KuponModelQueryWhere
    on QueryBuilder<KuponModel, KuponModel, QWhereClause> {
  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> kodeUnikIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'kodeUnik',
        value: [null],
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> kodeUnikIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kodeUnik',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> kodeUnikEqualTo(
      String? kodeUnik) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'kodeUnik',
        value: [kodeUnik],
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterWhereClause> kodeUnikNotEqualTo(
      String? kodeUnik) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kodeUnik',
              lower: [],
              upper: [kodeUnik],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kodeUnik',
              lower: [kodeUnik],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kodeUnik',
              lower: [kodeUnik],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kodeUnik',
              lower: [],
              upper: [kodeUnik],
              includeUpper: false,
            ));
      }
    });
  }
}

extension KuponModelQueryFilter
    on QueryBuilder<KuponModel, KuponModel, QFilterCondition> {
  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> isScannedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isScanned',
        value: value,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'keterangan',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'keterangan',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> keteranganEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> keteranganBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keterangan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keterangan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> keteranganMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keterangan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keterangan',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      keteranganIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keterangan',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kodeUnik',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      kodeUnikIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kodeUnik',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kodeUnik',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      kodeUnikGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kodeUnik',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kodeUnik',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kodeUnik',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      kodeUnikStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kodeUnik',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kodeUnik',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kodeUnik',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> kodeUnikMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kodeUnik',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      kodeUnikIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kodeUnik',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition>
      kodeUnikIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kodeUnik',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nama',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nama',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nama',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nama',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nama',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nama',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> namaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nama',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> needSyncEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'needSync',
        value: value,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tipe',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tipe',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipe',
        value: '',
      ));
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterFilterCondition> tipeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipe',
        value: '',
      ));
    });
  }
}

extension KuponModelQueryObject
    on QueryBuilder<KuponModel, KuponModel, QFilterCondition> {}

extension KuponModelQueryLinks
    on QueryBuilder<KuponModel, KuponModel, QFilterCondition> {}

extension KuponModelQuerySortBy
    on QueryBuilder<KuponModel, KuponModel, QSortBy> {
  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByIsScanned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScanned', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByIsScannedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScanned', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByKeterangan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByKeteranganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByKodeUnik() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kodeUnik', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByKodeUnikDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kodeUnik', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByNama() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByNamaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByNeedSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needSync', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByNeedSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needSync', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByTipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> sortByTipeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.desc);
    });
  }
}

extension KuponModelQuerySortThenBy
    on QueryBuilder<KuponModel, KuponModel, QSortThenBy> {
  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByIsScanned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScanned', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByIsScannedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScanned', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByKeterangan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByKeteranganDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keterangan', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByKodeUnik() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kodeUnik', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByKodeUnikDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kodeUnik', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByNama() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByNamaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nama', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByNeedSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needSync', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByNeedSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needSync', Sort.desc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByTipe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.asc);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QAfterSortBy> thenByTipeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipe', Sort.desc);
    });
  }
}

extension KuponModelQueryWhereDistinct
    on QueryBuilder<KuponModel, KuponModel, QDistinct> {
  QueryBuilder<KuponModel, KuponModel, QDistinct> distinctByIsScanned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isScanned');
    });
  }

  QueryBuilder<KuponModel, KuponModel, QDistinct> distinctByKeterangan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keterangan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QDistinct> distinctByKodeUnik(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kodeUnik', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QDistinct> distinctByNama(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nama', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KuponModel, KuponModel, QDistinct> distinctByNeedSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'needSync');
    });
  }

  QueryBuilder<KuponModel, KuponModel, QDistinct> distinctByTipe(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipe', caseSensitive: caseSensitive);
    });
  }
}

extension KuponModelQueryProperty
    on QueryBuilder<KuponModel, KuponModel, QQueryProperty> {
  QueryBuilder<KuponModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KuponModel, bool, QQueryOperations> isScannedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isScanned');
    });
  }

  QueryBuilder<KuponModel, String?, QQueryOperations> keteranganProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keterangan');
    });
  }

  QueryBuilder<KuponModel, String?, QQueryOperations> kodeUnikProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kodeUnik');
    });
  }

  QueryBuilder<KuponModel, String?, QQueryOperations> namaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nama');
    });
  }

  QueryBuilder<KuponModel, bool, QQueryOperations> needSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'needSync');
    });
  }

  QueryBuilder<KuponModel, String?, QQueryOperations> tipeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipe');
    });
  }
}
