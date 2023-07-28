import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';


abstract class BaseUseCase<In,Out>{
  // UseCase it is like a bridge from domain layer to data layer
  // So we will create UseCase.dart in domain layer and it will take data from presentation then send it to data layer and vice versa
  Future<Either<Failure,Out>> execute(In input);
}

abstract class BaseUseCaseTwoParams<A,B,Out>{

  Future<Either<Failure,Out>> execute(A inputA,B inputB);
}