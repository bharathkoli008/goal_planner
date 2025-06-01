import 'package:chopper/chopper.dart';

import 'interceptor.dart';
import 'logger.dart';

part 'mfAPIs.chopper.dart';

@ChopperApi()
abstract class MfStockService extends ChopperService {
  // Mutual Fund APIs
  @Get(path: '/{schemeCode}')
  Future<Response> getMutualFundData(@Path() String schemeCode);

  @Get(path: '/')
  Future<Response> getAllMutualFunds();

  // Indian Stock Market APIs
  @Get(path: 'https://stock.indianapi.in/mutual_fund_search')
  Future<Response> searchMutualFund(@QueryMap() Map<String, dynamic> queries);

  @Get(path: 'https://stock.indianapi.in/mutual_funds_details')
  Future<Response> mutualFundDetails(@QueryMap() Map<String, dynamic> queries);

  @Get(path: 'https://stock.indianapi.in/industry_search')
  Future<Response> searchStock(@QueryMap() Map<String, dynamic> queries);

  @GET(path: 'https://stock.indianapi.in/stock')
  Future<Response> stockDetails(@QueryMap() Map<String, dynamic> queries);


  // Factory method for creation
  static MfStockService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://api.mfapi.in'),
      services: [
        _$MfStockService(),
      ],
      converter: JsonConverter(),
    );

    return _$MfStockService(client);
  }

  static MfStockService createIndianStockClient() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://stock.indianapi.in'),
      services: [
        _$MfStockService(),
      ],
      converter: JsonConverter(),
      interceptors: [
        MyRequestInterceptor('sk-live-HazhTrZ5b4ayDSJOIXFBnHEhD57uBoZHdJnlI0jC'),
        LoggingInterceptor()

      ],
    );



    return _$MfStockService(client);
  }
}
