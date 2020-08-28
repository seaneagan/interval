import 'package:injector/injector.dart';
import 'package:xrange/src/num_range/num_range_factory.dart';
import 'package:xrange/src/num_range/num_range_factory_impl.dart';

Injector injector;

Injector getDependencies() =>
    injector ??= Injector()
      ..registerSingleton<NumRangeFactory>(() => const NumRangeFactoryImpl());
