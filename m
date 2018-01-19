From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/8] crypto/generic: sha3: rewrite KECCAK transform to help the compiler optimize
Date: Fri, 19 Jan 2018 12:04:34 +0000
Message-ID: <20180119120440.31556-3-ard.biesheuvel@linaro.org>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37268 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754232AbeASMFS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:18 -0500
Received: by mail-wm0-f67.google.com with SMTP id v71so3079542wmv.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2018 04:05:17 -0800 (PST)
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The way the KECCAK transform is currently coded involves many references
into the state array using indexes that are calculated at runtime using
simple but non-trivial arithmetic. This forces the compiler to treat the
state matrix as an array in memory rather than keep it in registers,
which results in poor performance.

So instead, let's rephrase the algorithm using fixed array indexes only.
This helps the compiler keep the state matrix in registers, resulting
in the following speedup (SHA3-256 performance in cycles per byte):

                                            before   after   speedup
  Intel Core i7 @ 2.0 GHz (2.9 turbo)        100.6    35.7     2.8x
  Cortex-A57 @ 2.0 GHz (64-bit mode)         101.6    12.7     8.0x
  Cortex-A53 @ 1.0 GHz                       224.4    15.8    14.2x
  Cortex-A57 @ 2.0 GHz (32-bit mode)         201.8    63.0     3.2x

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha3_generic.c | 134 ++++++++++++++------
 1 file changed, 96 insertions(+), 38 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index a68be626017c..5fecb609e3be 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -5,6 +5,7 @@
  * http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
  *
  * SHA-3 code by Jeff Garzik <jeff@garzik.org>
+ *               Ard Biesheuvel <ard.biesheuvel@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -22,8 +23,6 @@
 
 #define KECCAK_ROUNDS 24
 
-#define ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
-
 static const u64 keccakf_rndc[24] = {
 	0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL,
 	0x8000000080008000ULL, 0x000000000000808bULL, 0x0000000080000001ULL,
@@ -35,53 +34,112 @@ static const u64 keccakf_rndc[24] = {
 	0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
 };
 
-static const int keccakf_rotc[24] = {
-	1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14,
-	27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
-};
-
-static const int keccakf_piln[24] = {
-	10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4,
-	15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1
-};
-
 /* update the state with given number of rounds */
 
-static void keccakf(u64 st[25])
+static void __attribute__((__optimize__("O3"))) keccakf(u64 st[25])
 {
-	int i, j, round;
-	u64 t, bc[5];
+	u64 t[5], tt, bc[5];
+	int round;
 
 	for (round = 0; round < KECCAK_ROUNDS; round++) {
 
 		/* Theta */
-		for (i = 0; i < 5; i++)
-			bc[i] = st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15]
-				^ st[i + 20];
-
-		for (i = 0; i < 5; i++) {
-			t = bc[(i + 4) % 5] ^ ROTL64(bc[(i + 1) % 5], 1);
-			for (j = 0; j < 25; j += 5)
-				st[j + i] ^= t;
-		}
+		bc[0] = st[0] ^ st[5] ^ st[10] ^ st[15] ^ st[20];
+		bc[1] = st[1] ^ st[6] ^ st[11] ^ st[16] ^ st[21];
+		bc[2] = st[2] ^ st[7] ^ st[12] ^ st[17] ^ st[22];
+		bc[3] = st[3] ^ st[8] ^ st[13] ^ st[18] ^ st[23];
+		bc[4] = st[4] ^ st[9] ^ st[14] ^ st[19] ^ st[24];
+
+		t[0] = bc[4] ^ rol64(bc[1], 1);
+		t[1] = bc[0] ^ rol64(bc[2], 1);
+		t[2] = bc[1] ^ rol64(bc[3], 1);
+		t[3] = bc[2] ^ rol64(bc[4], 1);
+		t[4] = bc[3] ^ rol64(bc[0], 1);
+
+		st[0] ^= t[0];
 
 		/* Rho Pi */
-		t = st[1];
-		for (i = 0; i < 24; i++) {
-			j = keccakf_piln[i];
-			bc[0] = st[j];
-			st[j] = ROTL64(t, keccakf_rotc[i]);
-			t = bc[0];
-		}
+		tt = st[1];
+		st[ 1] = rol64(st[ 6] ^ t[1], 44);
+		st[ 6] = rol64(st[ 9] ^ t[4], 20);
+		st[ 9] = rol64(st[22] ^ t[2], 61);
+		st[22] = rol64(st[14] ^ t[4], 39);
+		st[14] = rol64(st[20] ^ t[0], 18);
+		st[20] = rol64(st[ 2] ^ t[2], 62);
+		st[ 2] = rol64(st[12] ^ t[2], 43);
+		st[12] = rol64(st[13] ^ t[3], 25);
+		st[13] = rol64(st[19] ^ t[4],  8);
+		st[19] = rol64(st[23] ^ t[3], 56);
+		st[23] = rol64(st[15] ^ t[0], 41);
+		st[15] = rol64(st[ 4] ^ t[4], 27);
+		st[ 4] = rol64(st[24] ^ t[4], 14);
+		st[24] = rol64(st[21] ^ t[1],  2);
+		st[21] = rol64(st[ 8] ^ t[3], 55);
+		st[ 8] = rol64(st[16] ^ t[1], 45);
+		st[16] = rol64(st[ 5] ^ t[0], 36);
+		st[ 5] = rol64(st[ 3] ^ t[3], 28);
+		st[ 3] = rol64(st[18] ^ t[3], 21);
+		st[18] = rol64(st[17] ^ t[2], 15);
+		st[17] = rol64(st[11] ^ t[1], 10);
+		st[11] = rol64(st[ 7] ^ t[2],  6);
+		st[ 7] = rol64(st[10] ^ t[0],  3);
+		st[10] = rol64(    tt ^ t[1],  1);
 
 		/* Chi */
-		for (j = 0; j < 25; j += 5) {
-			for (i = 0; i < 5; i++)
-				bc[i] = st[j + i];
-			for (i = 0; i < 5; i++)
-				st[j + i] ^= (~bc[(i + 1) % 5]) &
-					     bc[(i + 2) % 5];
-		}
+		bc[ 0] = ~st[ 1] & st[ 2];
+		bc[ 1] = ~st[ 2] & st[ 3];
+		bc[ 2] = ~st[ 3] & st[ 4];
+		bc[ 3] = ~st[ 4] & st[ 0];
+		bc[ 4] = ~st[ 0] & st[ 1];
+		st[ 0] ^= bc[ 0];
+		st[ 1] ^= bc[ 1];
+		st[ 2] ^= bc[ 2];
+		st[ 3] ^= bc[ 3];
+		st[ 4] ^= bc[ 4];
+
+		bc[ 0] = ~st[ 6] & st[ 7];
+		bc[ 1] = ~st[ 7] & st[ 8];
+		bc[ 2] = ~st[ 8] & st[ 9];
+		bc[ 3] = ~st[ 9] & st[ 5];
+		bc[ 4] = ~st[ 5] & st[ 6];
+		st[ 5] ^= bc[ 0];
+		st[ 6] ^= bc[ 1];
+		st[ 7] ^= bc[ 2];
+		st[ 8] ^= bc[ 3];
+		st[ 9] ^= bc[ 4];
+
+		bc[ 0] = ~st[11] & st[12];
+		bc[ 1] = ~st[12] & st[13];
+		bc[ 2] = ~st[13] & st[14];
+		bc[ 3] = ~st[14] & st[10];
+		bc[ 4] = ~st[10] & st[11];
+		st[10] ^= bc[ 0];
+		st[11] ^= bc[ 1];
+		st[12] ^= bc[ 2];
+		st[13] ^= bc[ 3];
+		st[14] ^= bc[ 4];
+
+		bc[ 0] = ~st[16] & st[17];
+		bc[ 1] = ~st[17] & st[18];
+		bc[ 2] = ~st[18] & st[19];
+		bc[ 3] = ~st[19] & st[15];
+		bc[ 4] = ~st[15] & st[16];
+		st[15] ^= bc[ 0];
+		st[16] ^= bc[ 1];
+		st[17] ^= bc[ 2];
+		st[18] ^= bc[ 3];
+		st[19] ^= bc[ 4];
+
+		bc[ 0] = ~st[21] & st[22];
+		bc[ 1] = ~st[22] & st[23];
+		bc[ 2] = ~st[23] & st[24];
+		bc[ 3] = ~st[24] & st[20];
+		bc[ 4] = ~st[20] & st[21];
+		st[20] ^= bc[ 0];
+		st[21] ^= bc[ 1];
+		st[22] ^= bc[ 2];
+		st[23] ^= bc[ 3];
+		st[24] ^= bc[ 4];
 
 		/* Iota */
 		st[0] ^= keccakf_rndc[round];
-- 
2.11.0
