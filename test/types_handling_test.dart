// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.types_handling_test;

import 'package:js/js.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'types_handling_test.g.dart';

@JsEnum()
enum Color { RED, GREEN, BLUE }

abstract class _A implements JsInterface {
  external factory _A();

  B b;
  List<B> bs;
  List<int> li;

  String toColorString(Color c);
  Color toColor(String s);
}

abstract class _B implements JsInterface {
  external factory _B(String v);

  String toString();
}

main() {
  useHtmlConfiguration();

  test('enum annotated with @JsEnum should be supported', () {
    final o = new A();
    expect(o.toColor('green'), Color.GREEN);
    expect(o.toColorString(Color.BLUE), 'blue');
  });

  test('JsInterface should be wrap/unwrap', () {
    final o = new A();
    expect(o.b, new isInstanceOf<B>());
    expect(o.b.toString(), 'init');

    o.b = new B('update');
    expect(asJsObject(o)['b']['v'], 'update');
  });

  test('List of JsInterface should be wrap/unwrap', () {
    final o = new A();
    expect(o.bs, new isInstanceOf<List<B>>());
    expect(o.bs.length, 2);
    expect(o.bs[0].toString(), 'b1');
    expect(o.bs[1].toString(), 'b2');

    o.bs = [new B('u1')];
    expect(asJsObject(o)['bs'], new isInstanceOf<JsArray>());
    expect(asJsObject(o)['bs'].length, 1);
    expect(asJsObject(o)['bs'][0].callMethod('toString'), 'u1');
  });

  test('List of int should be wrap/unwrap', () {
    final o = new A();
    expect(o.li, new isInstanceOf<List>());
    expect(o.li.length, 3);
    expect(o.li, [3, 4, 6]);

    o.li = [1];
    expect(asJsObject(o)['li'], new isInstanceOf<JsArray>());
    expect(asJsObject(o)['li'].length, 1);
    expect(asJsObject(o)['li'], [1]);
  });
}
