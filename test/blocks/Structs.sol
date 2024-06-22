// SPDX-License-Identifier: MIT

struct PallasAffinePoint {
    uint256 x;
    uint256 y;
}

struct PallasProjectivePoint {
    uint256 x;
    uint256 y;
    uint256 z;
}

struct VestaAffinePoint {
    uint256 x;
    uint256 y;
}

struct VestaProjectivePoint {
    uint256 x;
    uint256 y;
    uint256 z;
}

struct Bn256AffinePoint {
    uint256 x;
    uint256 y;
}

struct GrumpkinAffinePoint {
    uint256 x;
    uint256 y;
}

// Represents a point on G1 (first group of BN256 curve).
struct G1Point {
    Bn256AffinePoint inner;
}

// Represents a point on G2 (second group of BN256 curve).
struct G2Point {
    uint256[2] X;
    uint256[2] Y;
}