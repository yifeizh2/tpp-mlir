// RUN: tpp-run %s -n 10 \
// RUN:  -e entry -entry-point-result=void

// BENCH_TOTAL_FLOPS: 1073741824

#map = affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d2)>
#map1 = affine_map<(d0, d1, d2, d3, d4) -> (d2, d3, d4)>
#map2 = affine_map<(d0, d1, d2, d3, d4) -> (d0, d1, d3, d4)>
module {
  func.func @entry(%arg2: tensor<64x32x512xf32>, %out_b: tensor<64x32x8x64xf32>) -> tensor<64x32x8x64xf32> {
    %cst = arith.constant 0.000000e+00 : f32
    %1 = linalg.fill ins(%cst : f32) outs(%out_b : tensor<64x32x8x64xf32>) -> tensor<64x32x8x64xf32>
    %2 = linalg.generic {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction", "parallel", "parallel"]} ins(%arg2, %cst_0 : tensor<64x32x512xf32>, tensor<512x8x64xf32>) outs(%1 : tensor<64x32x8x64xf32>) {
    ^bb0(%in: f32, %in_1: f32, %out: f32):
      %3 = arith.mulf %in, %in_1 : f32
      %4 = arith.addf %out, %3 : f32
      linalg.yield %4 : f32
    } -> tensor<64x32x8x64xf32>
    return %2 : tensor<64x32x8x64xf32>
  }
}
