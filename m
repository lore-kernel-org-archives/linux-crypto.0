From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto/generic: sha3: rewrite KECCAK transform to help the GCC optimizer
Date: Mon, 15 Jan 2018 11:29:04 +0000
Message-ID: <20180115112904.21041-1-ard.biesheuvel@linaro.org>
Cc: jeff@garzik.org, arnd@arndb.de,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42391 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754518AbeAOL3P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 06:29:15 -0500
Received: by mail-wm0-f68.google.com with SMTP id b141so1226087wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jan 2018 03:29:14 -0800 (PST)
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
Raw tcrypt performance numbers after the patch.

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

x86_64: Intel Core i7 @ 2.0 GHz (2.9 GHz turbo speed)

Before:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 212552 opers/sec,   3400832 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 199875 opers/sec,  12792000 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 210336 opers/sec,  13461504 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  99741 opers/sec,  25533696 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 103238 opers/sec,  26428928 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 102563 opers/sec,  26256128 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  24673 opers/sec,  25265152 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  26060 opers/sec,  26685440 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  26006 opers/sec,  26630144 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  12346 opers/sec,  25284608 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  13463 opers/sec,  27572224 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  12921 opers/sec,  26462208 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  13493 opers/sec,  27633664 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   6618 opers/sec,  27107328 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   6806 opers/sec,  27877376 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   6884 opers/sec,  28196864 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   6737 opers/sec,  27594752 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   3360 opers/sec,  27525120 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   3530 opers/sec,  28917760 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3550 opers/sec,  29081600 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   3550 opers/sec,  29081600 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   3519 opers/sec,  28827648 bytes/sec

After:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 573076 opers/sec,   9169216 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 531555 opers/sec,  34019520 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 557783 opers/sec,  35698112 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates): 247385 opers/sec,  63330560 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 277352 opers/sec,  71002112 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 281026 opers/sec,  71942656 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  59950 opers/sec,  61388800 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  73643 opers/sec,  75410432 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  76192 opers/sec,  78020608 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  32242 opers/sec,  66031616 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  34339 opers/sec,  70326272 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  36767 opers/sec,  75298816 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  36617 opers/sec,  74991616 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  15908 opers/sec,  65159168 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  18932 opers/sec,  77545472 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  18032 opers/sec,  73859072 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  19103 opers/sec,  78245888 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   7843 opers/sec,  64249856 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   9161 opers/sec,  75046912 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   9679 opers/sec,  79290368 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   9878 opers/sec,  80920576 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   9907 opers/sec,  81158144 bytes/sec

arm64: Cortex-A57 @ 2 GHz

Before:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 143072 opers/sec,   2289152 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 138358 opers/sec,   8854912 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 143392 opers/sec,   9177088 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  67063 opers/sec,  17168128 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):  71026 opers/sec,  18182656 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):  72294 opers/sec,  18507264 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  16847 opers/sec,  17251328 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  18163 opers/sec,  18598912 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  18290 opers/sec,  18728960 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   8429 opers/sec,  17262592 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   9090 opers/sec,  18616320 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   9144 opers/sec,  18726912 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   9160 opers/sec,  18759680 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   4343 opers/sec,  17788928 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   4684 opers/sec,  19185664 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   4721 opers/sec,  19337216 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   4719 opers/sec,  19329024 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   2204 opers/sec,  18055168 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   2382 opers/sec,  19513344 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   2398 opers/sec,  19644416 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   2402 opers/sec,  19677184 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   2403 opers/sec,  19685376 bytes/sec

After:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 995408 opers/sec,  15926528 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 836897 opers/sec,  53561408 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 998895 opers/sec,  63929280 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates): 358970 opers/sec,  91896320 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 478617 opers/sec, 122525952 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 535961 opers/sec, 137206016 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  92055 opers/sec,  94264320 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates): 137677 opers/sec, 140981248 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates): 143914 opers/sec, 147367936 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  46197 opers/sec,  94611456 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  69153 opers/sec, 141625344 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  72247 opers/sec, 147961856 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  72836 opers/sec, 149168128 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  23606 opers/sec,  96690176 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  35578 opers/sec, 145727488 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  37365 opers/sec, 153047040 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  37776 opers/sec, 154730496 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  11947 opers/sec,  97869824 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  18095 opers/sec, 148234240 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  18981 opers/sec, 155492352 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  19243 opers/sec, 157638656 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  19231 opers/sec, 157540352 bytes/sec

ARM (32-bit): Cortex-A57 @ 2 GHz

Before:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):  73362 opers/sec,   1173792 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):  71917 opers/sec,   4602688 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):  73214 opers/sec,   4685696 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  35384 opers/sec,   9058304 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):  36474 opers/sec,   9337344 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):  36867 opers/sec,   9437952 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   8862 opers/sec,   9074688 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   9227 opers/sec,   9448448 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   9264 opers/sec,   9486336 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   4434 opers/sec,   9080832 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   4613 opers/sec,   9447424 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   4633 opers/sec,   9488384 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   4636 opers/sec,   9494528 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   2286 opers/sec,   9363456 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   2381 opers/sec,   9752576 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   2391 opers/sec,   9793536 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   2394 opers/sec,   9805824 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   1161 opers/sec,   9510912 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   1210 opers/sec,   9912320 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   1216 opers/sec,   9961472 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   1210 opers/sec,   9912320 bytes/sec

After:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 227843 opers/sec,   3645488 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 215525 opers/sec,  13793600 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 227163 opers/sec,  14538432 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates): 102748 opers/sec,  26303488 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 112404 opers/sec,  28775424 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 115819 opers/sec,  29649664 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  25852 opers/sec,  26472448 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  29066 opers/sec,  29763584 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  29421 opers/sec,  30127104 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  12941 opers/sec,  26503168 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  14534 opers/sec,  29765632 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  14718 opers/sec,  30142464 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  14735 opers/sec,  30177280 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   6651 opers/sec,  27242496 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   7495 opers/sec,  30699520 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   7595 opers/sec,  31109120 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   7623 opers/sec,  31223808 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   3375 opers/sec,  27648000 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   3810 opers/sec,  31211520 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   3860 opers/sec,  31621120 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   3125 opers/sec,  25600000 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   3875 opers/sec,  31744000 bytes/sec

arm64: Cortex-A53 @ 1 GHz

Before:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates):  32491 opers/sec,    519856 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates):  31554 opers/sec,   2019456 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates):  32510 opers/sec,   2080640 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  15363 opers/sec,   3932928 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates):  16164 opers/sec,   4137984 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates):  16440 opers/sec,   4208640 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   3859 opers/sec,   3951616 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   4124 opers/sec,   4222976 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   4144 opers/sec,   4243456 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   1931 opers/sec,   3954688 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   2064 opers/sec,   4227072 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   2072 opers/sec,   4243456 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2073 opers/sec,   4245504 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):    995 opers/sec,   4075520 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   1066 opers/sec,   4366336 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   1068 opers/sec,   4374528 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   1071 opers/sec,   4386816 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):    505 opers/sec,   4136960 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):    541 opers/sec,   4431872 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):    544 opers/sec,   4456448 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):    545 opers/sec,   4464640 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):    544 opers/sec,   4456448 bytes/sec

After:

testing speed of async sha3-256 (sha3-256-generic)
tcrypt: test  0 (   16 byte blocks,   16 bytes per update,   1 updates): 361457 opers/sec,   5783312 bytes/sec
tcrypt: test  1 (   64 byte blocks,   16 bytes per update,   4 updates): 276617 opers/sec,  17703488 bytes/sec
tcrypt: test  2 (   64 byte blocks,   64 bytes per update,   1 updates): 362401 opers/sec,  23193664 bytes/sec
tcrypt: test  3 (  256 byte blocks,   16 bytes per update,  16 updates): 110172 opers/sec,  28204032 bytes/sec
tcrypt: test  4 (  256 byte blocks,   64 bytes per update,   4 updates): 173328 opers/sec,  44371968 bytes/sec
tcrypt: test  5 (  256 byte blocks,  256 bytes per update,   1 updates): 205239 opers/sec,  52541184 bytes/sec
tcrypt: test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  28316 opers/sec,  28995584 bytes/sec
tcrypt: test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  53766 opers/sec,  55056384 bytes/sec
tcrypt: test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  57094 opers/sec,  58464256 bytes/sec
tcrypt: test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  14220 opers/sec,  29122560 bytes/sec
tcrypt: test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  27074 opers/sec,  55447552 bytes/sec
tcrypt: test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  28814 opers/sec,  59011072 bytes/sec
tcrypt: test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  29113 opers/sec,  59623424 bytes/sec
tcrypt: test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   7244 opers/sec,  29671424 bytes/sec
tcrypt: test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  13987 opers/sec,  57290752 bytes/sec
tcrypt: test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  14925 opers/sec,  61132800 bytes/sec
tcrypt: test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  15140 opers/sec,  62013440 bytes/sec
tcrypt: test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):   3655 opers/sec,  29941760 bytes/sec
tcrypt: test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   7116 opers/sec,  58294272 bytes/sec
tcrypt: test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   7590 opers/sec,  62177280 bytes/sec
tcrypt: test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   7720 opers/sec,  63242240 bytes/sec
tcrypt: test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   7718 opers/sec,  63225856 bytes/sec
