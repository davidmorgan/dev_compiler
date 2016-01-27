library dev_compiler.test.transformer.transformer_test;

import 'package:barback/barback.dart' show BarbackMode, BarbackSettings;
import 'package:dev_compiler/transformer.dart';
import 'package:test/test.dart';
import 'package:transformer_test/utils.dart';
import 'package:dev_compiler/src/compiler.dart' show defaultRuntimeFiles;

makePhases([Map config = const {}]) => [
      [
        new DDCTransformer.asPlugin(
            new BarbackSettings(config, BarbackMode.RELEASE))
      ]
    ];

final Map<String, String> runtimeInput = new Map.fromIterable(
    defaultRuntimeFiles,
    key: (f) => 'dev_compiler|lib/runtime/$f',
    value: (_) => '');

Map<String, String> createInput(Map<String, String> input) =>
    {}..addAll(input)..addAll(runtimeInput);

void main(arguments) {
  group('$DDCTransformer', () {
    testPhases(
        r'compiles simple code',
        makePhases(),
        createInput({
          'foo|lib/Foo.dart': r'''
        class Foo {}
      '''
        }),
        {
          'foo|web/foo/Foo.js': r'''
dart_library.library('foo/Foo', null, /* Imports */[
  'dart/_runtime',
  'dart/core'
], /* Lazy imports */[
], function(exports, dart, core) {
  'use strict';
  let dartx = dart.dartx;
  class Foo extends core.Object {}
  // Exports:
  exports.Foo = Foo;
});
//# sourceMappingURL=Foo.js.map
'''
              .trimLeft()
        });

    var args = ['--destructure-named-params', '--modules=es6', '--closure'];
    testPhases(
        r'honours arguments',
        makePhases({'args': args}),
        createInput({
          'foo|lib/Foo.dart': r'''
        int foo({String s : '?'}) {}
      '''
        }),
        {
          'foo|web/foo/Foo.js': r'''
const exports = {};
import dart from "../dart/_runtime";
import core from "../dart/core";
let dartx = dart.dartx;
/**
 * @param {{s: (string|undefined)}=} opts
 * @return {?number}
 */
function foo({s = '?'} = {}) {
}
dart.fn(foo, core.int, [], {s: core.String});
// Exports:
exports.foo = foo;
export default exports;
//# sourceMappingURL=Foo.js.map
'''
              .trimLeft()
        });

    testPhases(
        'forwards errors',
        makePhases(),
        createInput({
          'foo|lib/Foo.dart': r'''
        foo() {
          var x = 1;
          x = '2';
        }
      '''
        }),
        {},
        [
          "warning: A value of type \'String\' cannot be assigned to a variable of type \'int\'",
          "error: Type check failed: '2' (String) is not of type int"
        ]);
  });
}
