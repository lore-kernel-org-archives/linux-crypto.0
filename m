From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto/generic - sha3: deal with oversize stack frames
Date: Sat, 27 Jan 2018 09:18:32 +0000
Message-ID: <20180127091832.24435-1-ard.biesheuvel@linaro.org>
Cc: arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36936 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbeA0JSn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Jan 2018 04:18:43 -0500
Received: by mail-wm0-f66.google.com with SMTP id v71so25255765wmv.2
        for <linux-crypto@vger.kernel.org>; Sat, 27 Jan 2018 01:18:42 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As reported by kbuild test robot, the optimized SHA3 C implementation
compiles to mn10300 code that uses a disproportionate amount of stack
space, i.e.,

  crypto/sha3_generic.c: In function 'keccakf':
  crypto/sha3_generic.c:147:1: warning: the frame size of 1232 bytes is larger than 1024 bytes [-Wframe-larger-than=]

As kindly diagnosed by Arnd, this does not only occur when building for
the mn10300 architecture (which is what the report was about) but also
for h8300, and builds for other 32-bit architectures show an increase in
stack space utilization as well.

Given that SHA3 operates on 64-bit quantities, and keeps a state matrix
of 25 64-bit words, it is not surprising that 32-bit architectures with
few general purpose registers are impacted the most by this, and it is
therefore reasonable to implement a workaround that distinguishes between
32-bit and 64-bit architectures.

Arnd figured out that taking the round calculation out of the loop, and
inlining it explicitly but only on 64-bit architectures preserves most
of the performance gain achieved by the rewrite, and also gets rid of
the excessive use of stack space.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/sha3_generic.c | 218 +++++++++++---------
 1 file changed, 118 insertions(+), 100 deletions(-)

diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index a965b9d80559..951c4eb70262 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -20,6 +20,20 @@
 #include <crypto/sha3.h>
 #include <asm/unaligned.h>
 
+/*
+ * On some 32-bit architectures (mn10300 and h8300), GCC ends up using
+ * over 1 KB of stack if we inline the round calculation into the loop
+ * in keccakf(). On the other hand, on 64-bit architectures with plenty
+ * of [64-bit wide] general purpose registers, not inlining it severely
+ * hurts performance. So let's use 64-bitness as a heuristic to decide
+ * whether to inline or not.
+ */
+#ifdef CONFIG_64BIT
+#define SHA3_INLINE	inline
+#else
+#define SHA3_INLINE	noinline
+#endif
+
 #define KECCAK_ROUNDS 24
 
 static const u64 keccakf_rndc[24] = {
@@ -35,111 +49,115 @@ static const u64 keccakf_rndc[24] = {
 
 /* update the state with given number of rounds */
 
-static void __attribute__((__optimize__("O3"))) keccakf(u64 st[25])
+static SHA3_INLINE void keccakf_round(u64 st[25])
 {
 	u64 t[5], tt, bc[5];
-	int round;
 
-	for (round = 0; round < KECCAK_ROUNDS; round++) {
+	/* Theta */
+	bc[0] = st[0] ^ st[5] ^ st[10] ^ st[15] ^ st[20];
+	bc[1] = st[1] ^ st[6] ^ st[11] ^ st[16] ^ st[21];
+	bc[2] = st[2] ^ st[7] ^ st[12] ^ st[17] ^ st[22];
+	bc[3] = st[3] ^ st[8] ^ st[13] ^ st[18] ^ st[23];
+	bc[4] = st[4] ^ st[9] ^ st[14] ^ st[19] ^ st[24];
+
+	t[0] = bc[4] ^ rol64(bc[1], 1);
+	t[1] = bc[0] ^ rol64(bc[2], 1);
+	t[2] = bc[1] ^ rol64(bc[3], 1);
+	t[3] = bc[2] ^ rol64(bc[4], 1);
+	t[4] = bc[3] ^ rol64(bc[0], 1);
+
+	st[0] ^= t[0];
+
+	/* Rho Pi */
+	tt = st[1];
+	st[ 1] = rol64(st[ 6] ^ t[1], 44);
+	st[ 6] = rol64(st[ 9] ^ t[4], 20);
+	st[ 9] = rol64(st[22] ^ t[2], 61);
+	st[22] = rol64(st[14] ^ t[4], 39);
+	st[14] = rol64(st[20] ^ t[0], 18);
+	st[20] = rol64(st[ 2] ^ t[2], 62);
+	st[ 2] = rol64(st[12] ^ t[2], 43);
+	st[12] = rol64(st[13] ^ t[3], 25);
+	st[13] = rol64(st[19] ^ t[4],  8);
+	st[19] = rol64(st[23] ^ t[3], 56);
+	st[23] = rol64(st[15] ^ t[0], 41);
+	st[15] = rol64(st[ 4] ^ t[4], 27);
+	st[ 4] = rol64(st[24] ^ t[4], 14);
+	st[24] = rol64(st[21] ^ t[1],  2);
+	st[21] = rol64(st[ 8] ^ t[3], 55);
+	st[ 8] = rol64(st[16] ^ t[1], 45);
+	st[16] = rol64(st[ 5] ^ t[0], 36);
+	st[ 5] = rol64(st[ 3] ^ t[3], 28);
+	st[ 3] = rol64(st[18] ^ t[3], 21);
+	st[18] = rol64(st[17] ^ t[2], 15);
+	st[17] = rol64(st[11] ^ t[1], 10);
+	st[11] = rol64(st[ 7] ^ t[2],  6);
+	st[ 7] = rol64(st[10] ^ t[0],  3);
+	st[10] = rol64(    tt ^ t[1],  1);
+
+	/* Chi */
+	bc[ 0] = ~st[ 1] & st[ 2];
+	bc[ 1] = ~st[ 2] & st[ 3];
+	bc[ 2] = ~st[ 3] & st[ 4];
+	bc[ 3] = ~st[ 4] & st[ 0];
+	bc[ 4] = ~st[ 0] & st[ 1];
+	st[ 0] ^= bc[ 0];
+	st[ 1] ^= bc[ 1];
+	st[ 2] ^= bc[ 2];
+	st[ 3] ^= bc[ 3];
+	st[ 4] ^= bc[ 4];
+
+	bc[ 0] = ~st[ 6] & st[ 7];
+	bc[ 1] = ~st[ 7] & st[ 8];
+	bc[ 2] = ~st[ 8] & st[ 9];
+	bc[ 3] = ~st[ 9] & st[ 5];
+	bc[ 4] = ~st[ 5] & st[ 6];
+	st[ 5] ^= bc[ 0];
+	st[ 6] ^= bc[ 1];
+	st[ 7] ^= bc[ 2];
+	st[ 8] ^= bc[ 3];
+	st[ 9] ^= bc[ 4];
+
+	bc[ 0] = ~st[11] & st[12];
+	bc[ 1] = ~st[12] & st[13];
+	bc[ 2] = ~st[13] & st[14];
+	bc[ 3] = ~st[14] & st[10];
+	bc[ 4] = ~st[10] & st[11];
+	st[10] ^= bc[ 0];
+	st[11] ^= bc[ 1];
+	st[12] ^= bc[ 2];
+	st[13] ^= bc[ 3];
+	st[14] ^= bc[ 4];
+
+	bc[ 0] = ~st[16] & st[17];
+	bc[ 1] = ~st[17] & st[18];
+	bc[ 2] = ~st[18] & st[19];
+	bc[ 3] = ~st[19] & st[15];
+	bc[ 4] = ~st[15] & st[16];
+	st[15] ^= bc[ 0];
+	st[16] ^= bc[ 1];
+	st[17] ^= bc[ 2];
+	st[18] ^= bc[ 3];
+	st[19] ^= bc[ 4];
+
+	bc[ 0] = ~st[21] & st[22];
+	bc[ 1] = ~st[22] & st[23];
+	bc[ 2] = ~st[23] & st[24];
+	bc[ 3] = ~st[24] & st[20];
+	bc[ 4] = ~st[20] & st[21];
+	st[20] ^= bc[ 0];
+	st[21] ^= bc[ 1];
+	st[22] ^= bc[ 2];
+	st[23] ^= bc[ 3];
+	st[24] ^= bc[ 4];
+}
 
-		/* Theta */
-		bc[0] = st[0] ^ st[5] ^ st[10] ^ st[15] ^ st[20];
-		bc[1] = st[1] ^ st[6] ^ st[11] ^ st[16] ^ st[21];
-		bc[2] = st[2] ^ st[7] ^ st[12] ^ st[17] ^ st[22];
-		bc[3] = st[3] ^ st[8] ^ st[13] ^ st[18] ^ st[23];
-		bc[4] = st[4] ^ st[9] ^ st[14] ^ st[19] ^ st[24];
-
-		t[0] = bc[4] ^ rol64(bc[1], 1);
-		t[1] = bc[0] ^ rol64(bc[2], 1);
-		t[2] = bc[1] ^ rol64(bc[3], 1);
-		t[3] = bc[2] ^ rol64(bc[4], 1);
-		t[4] = bc[3] ^ rol64(bc[0], 1);
-
-		st[0] ^= t[0];
-
-		/* Rho Pi */
-		tt = st[1];
-		st[ 1] = rol64(st[ 6] ^ t[1], 44);
-		st[ 6] = rol64(st[ 9] ^ t[4], 20);
-		st[ 9] = rol64(st[22] ^ t[2], 61);
-		st[22] = rol64(st[14] ^ t[4], 39);
-		st[14] = rol64(st[20] ^ t[0], 18);
-		st[20] = rol64(st[ 2] ^ t[2], 62);
-		st[ 2] = rol64(st[12] ^ t[2], 43);
-		st[12] = rol64(st[13] ^ t[3], 25);
-		st[13] = rol64(st[19] ^ t[4],  8);
-		st[19] = rol64(st[23] ^ t[3], 56);
-		st[23] = rol64(st[15] ^ t[0], 41);
-		st[15] = rol64(st[ 4] ^ t[4], 27);
-		st[ 4] = rol64(st[24] ^ t[4], 14);
-		st[24] = rol64(st[21] ^ t[1],  2);
-		st[21] = rol64(st[ 8] ^ t[3], 55);
-		st[ 8] = rol64(st[16] ^ t[1], 45);
-		st[16] = rol64(st[ 5] ^ t[0], 36);
-		st[ 5] = rol64(st[ 3] ^ t[3], 28);
-		st[ 3] = rol64(st[18] ^ t[3], 21);
-		st[18] = rol64(st[17] ^ t[2], 15);
-		st[17] = rol64(st[11] ^ t[1], 10);
-		st[11] = rol64(st[ 7] ^ t[2],  6);
-		st[ 7] = rol64(st[10] ^ t[0],  3);
-		st[10] = rol64(    tt ^ t[1],  1);
-
-		/* Chi */
-		bc[ 0] = ~st[ 1] & st[ 2];
-		bc[ 1] = ~st[ 2] & st[ 3];
-		bc[ 2] = ~st[ 3] & st[ 4];
-		bc[ 3] = ~st[ 4] & st[ 0];
-		bc[ 4] = ~st[ 0] & st[ 1];
-		st[ 0] ^= bc[ 0];
-		st[ 1] ^= bc[ 1];
-		st[ 2] ^= bc[ 2];
-		st[ 3] ^= bc[ 3];
-		st[ 4] ^= bc[ 4];
-
-		bc[ 0] = ~st[ 6] & st[ 7];
-		bc[ 1] = ~st[ 7] & st[ 8];
-		bc[ 2] = ~st[ 8] & st[ 9];
-		bc[ 3] = ~st[ 9] & st[ 5];
-		bc[ 4] = ~st[ 5] & st[ 6];
-		st[ 5] ^= bc[ 0];
-		st[ 6] ^= bc[ 1];
-		st[ 7] ^= bc[ 2];
-		st[ 8] ^= bc[ 3];
-		st[ 9] ^= bc[ 4];
-
-		bc[ 0] = ~st[11] & st[12];
-		bc[ 1] = ~st[12] & st[13];
-		bc[ 2] = ~st[13] & st[14];
-		bc[ 3] = ~st[14] & st[10];
-		bc[ 4] = ~st[10] & st[11];
-		st[10] ^= bc[ 0];
-		st[11] ^= bc[ 1];
-		st[12] ^= bc[ 2];
-		st[13] ^= bc[ 3];
-		st[14] ^= bc[ 4];
-
-		bc[ 0] = ~st[16] & st[17];
-		bc[ 1] = ~st[17] & st[18];
-		bc[ 2] = ~st[18] & st[19];
-		bc[ 3] = ~st[19] & st[15];
-		bc[ 4] = ~st[15] & st[16];
-		st[15] ^= bc[ 0];
-		st[16] ^= bc[ 1];
-		st[17] ^= bc[ 2];
-		st[18] ^= bc[ 3];
-		st[19] ^= bc[ 4];
-
-		bc[ 0] = ~st[21] & st[22];
-		bc[ 1] = ~st[22] & st[23];
-		bc[ 2] = ~st[23] & st[24];
-		bc[ 3] = ~st[24] & st[20];
-		bc[ 4] = ~st[20] & st[21];
-		st[20] ^= bc[ 0];
-		st[21] ^= bc[ 1];
-		st[22] ^= bc[ 2];
-		st[23] ^= bc[ 3];
-		st[24] ^= bc[ 4];
+static void __attribute__((__optimize__("O3"))) keccakf(u64 st[25])
+{
+	int round;
 
+	for (round = 0; round < KECCAK_ROUNDS; round++) {
+		keccakf_round(st);
 		/* Iota */
 		st[0] ^= keccakf_rndc[round];
 	}
-- 
2.11.0
