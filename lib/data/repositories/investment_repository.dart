
import '../services/network/apis/mfAPIs.dart';

class InvestmentRepository {
  final MfStockService _mutualFundService;
  final MfStockService _stockService;

  InvestmentRepository({
    MfStockService? mutualFundService,
    MfStockService? stockService,

  })  : _mutualFundService = mutualFundService ?? MfStockService.create()
  , _stockService = mutualFundService ?? MfStockService.createIndianStockClient();

  Future<Map<String, dynamic>?> fetchMutualFundData(String code) async {
    final response = await _mutualFundService.getAllMutualFunds();
    if (response.isSuccessful) {
      return response.body;
    } else {
      print('Mutual Fund API Error: ${response.error}');
      return null;
    }
  }

  Future<List<dynamic>> fetchStockData(String symbol) async {
    final response = await _stockService.searchStock({'query':symbol});
    if (response.isSuccessful) {
      return response.body;
    } else {
      print('Stock API Error: ${response.error}');
      return [];
    }
  }

  Future<Map<String,dynamic>> fetchStockDetails(String symbol) async {
    final response = await _stockService.stockDetails({'name':symbol});
    if (response.isSuccessful) {
      return response.body;
    } else {
      print('Stock API Error: ${response.error}');
      return {};
    }
  }

  Future<List<dynamic>>  fetchMfs(String symbol) async {
    final response = await _stockService.searchMutualFund({'query':symbol});
    if (response.isSuccessful) {
      return response.body;
    } else {
      print('Stock API Error: ${response.error}');
      return [];
    }
  }

  Future<Map<String,dynamic>> fetchMfDetails(String symbol) async {
    final response = await _stockService.mutualFundDetails({'stock_name':symbol});
    if (response.isSuccessful) {
      return response.body;
    } else {
      print('Stock API Error: ${response.error}');
      return {};
    }
  }
}
