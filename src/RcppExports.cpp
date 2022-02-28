// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// RasterizePolygon
int RasterizePolygon(int nRasterXSize, int nRasterYSize, const Rcpp::IntegerVector& ivPartSizes, const Rcpp::NumericVector& dvX, const Rcpp::NumericVector& dvY, Rcpp::Function fnRasterIO, double dBurnValue, Rcpp::String sAttrValue);
RcppExport SEXP _FIESTAutils_RasterizePolygon(SEXP nRasterXSizeSEXP, SEXP nRasterYSizeSEXP, SEXP ivPartSizesSEXP, SEXP dvXSEXP, SEXP dvYSEXP, SEXP fnRasterIOSEXP, SEXP dBurnValueSEXP, SEXP sAttrValueSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type nRasterXSize(nRasterXSizeSEXP);
    Rcpp::traits::input_parameter< int >::type nRasterYSize(nRasterYSizeSEXP);
    Rcpp::traits::input_parameter< const Rcpp::IntegerVector& >::type ivPartSizes(ivPartSizesSEXP);
    Rcpp::traits::input_parameter< const Rcpp::NumericVector& >::type dvX(dvXSEXP);
    Rcpp::traits::input_parameter< const Rcpp::NumericVector& >::type dvY(dvYSEXP);
    Rcpp::traits::input_parameter< Rcpp::Function >::type fnRasterIO(fnRasterIOSEXP);
    Rcpp::traits::input_parameter< double >::type dBurnValue(dBurnValueSEXP);
    Rcpp::traits::input_parameter< Rcpp::String >::type sAttrValue(sAttrValueSEXP);
    rcpp_result_gen = Rcpp::wrap(RasterizePolygon(nRasterXSize, nRasterYSize, ivPartSizes, dvX, dvY, fnRasterIO, dBurnValue, sAttrValue));
    return rcpp_result_gen;
END_RCPP
}

RcppExport SEXP _rcpp_module_boot_mod_cmb_table();
RcppExport SEXP _rcpp_module_boot_mod_running_stats();

static const R_CallMethodDef CallEntries[] = {
    {"_FIESTAutils_RasterizePolygon", (DL_FUNC) &_FIESTAutils_RasterizePolygon, 8},
    {"_rcpp_module_boot_mod_cmb_table", (DL_FUNC) &_rcpp_module_boot_mod_cmb_table, 0},
    {"_rcpp_module_boot_mod_running_stats", (DL_FUNC) &_rcpp_module_boot_mod_running_stats, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_FIESTAutils(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
