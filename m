From: David Miller <davem@davemloft.net>
Subject: [PATCH 3/5] sparc64: Unroll ECB encryption loops in AES driver.
Date: Thu, 30 Aug 2012 11:46:32 -0400 (EDT)
Message-ID: <20120830.114632.1559527747457990687.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2H3Pqf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2012 11:46:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The AES opcodes have a 3 cycle latency, so by doing 32-bytes at a
time we avoid a pipeline bubble in between every round.

For the 256-bit key case, it looks like we're doing more work in
order to reload the KEY registers during the loop to make space
for scarce temporaries.  But the load dual issues with the AES
operations so we get the KEY reloads essentially for free.

Before:

testing speed of ecb(aes) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 264 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 231 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 329 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 715 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 4248 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 221 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 234 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 359 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 803 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 5366 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 209 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 255 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 379 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 938 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 6041 cycles (8192 bytes)

After:

testing speed of ecb(aes) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 266 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 256 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 305 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 676 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 3981 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 210 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 233 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 340 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 766 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 5136 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 206 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 268 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 368 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 890 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 5718 cycles (8192 bytes)

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/crypto/aes_asm.S |  166 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 148 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/crypto/aes_asm.S b/arch/sparc/crypto/aes_asm.S
index 7a975d6..33d59c6 100644
--- a/arch/sparc/crypto/aes_asm.S
+++ b/arch/sparc/crypto/aes_asm.S
@@ -48,6 +48,10 @@
 	.word	0x81b0230d;
 #define MOVXTOD_O5_F2		\
 	.word	0x85b0230d;
+#define MOVXTOD_G3_F60		\
+	.word	0xbbb02303;
+#define MOVXTOD_G7_F62		\
+	.word	0xbfb02307;
 
 #define ENCRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
 	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
@@ -55,12 +59,32 @@
 	AES_EROUND01(KEY_BASE +  4, T0, T1, I0) \
 	AES_EROUND23(KEY_BASE +  6, T0, T1, I1)
 
+#define ENCRYPT_TWO_ROUNDS_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
+	AES_EROUND23(KEY_BASE +  2, I0, I1, T1) \
+	AES_EROUND01(KEY_BASE +  0, I2, I3, T2) \
+	AES_EROUND23(KEY_BASE +  2, I2, I3, T3) \
+	AES_EROUND01(KEY_BASE +  4, T0, T1, I0) \
+	AES_EROUND23(KEY_BASE +  6, T0, T1, I1) \
+	AES_EROUND01(KEY_BASE +  4, T2, T3, I2) \
+	AES_EROUND23(KEY_BASE +  6, T2, T3, I3)
+
 #define ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE, I0, I1, T0, T1) \
 	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
 	AES_EROUND23(KEY_BASE +  2, I0, I1, T1) \
 	AES_EROUND01_L(KEY_BASE +  4, T0, T1, I0) \
 	AES_EROUND23_L(KEY_BASE +  6, T0, T1, I1)
 
+#define ENCRYPT_TWO_ROUNDS_LAST_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
+	AES_EROUND23(KEY_BASE +  2, I0, I1, T1) \
+	AES_EROUND01(KEY_BASE +  0, I2, I3, T2) \
+	AES_EROUND23(KEY_BASE +  2, I2, I3, T3) \
+	AES_EROUND01_L(KEY_BASE +  4, T0, T1, I0) \
+	AES_EROUND23_L(KEY_BASE +  6, T0, T1, I1) \
+	AES_EROUND01_L(KEY_BASE +  4, T2, T3, I2) \
+	AES_EROUND23_L(KEY_BASE +  6, T2, T3, I3)
+
 	/* 10 rounds */
 #define ENCRYPT_128(KEY_BASE, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
@@ -69,6 +93,13 @@
 	ENCRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 32, I0, I1, T0, T1)
 
+#define ENCRYPT_128_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE +  0, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE +  8, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE + 16, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE + 24, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_LAST_2(KEY_BASE + 32, I0, I1, I2, I3, T0, T1, T2, T3)
+
 	/* 12 rounds */
 #define ENCRYPT_192(KEY_BASE, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
@@ -78,6 +109,14 @@
 	ENCRYPT_TWO_ROUNDS(KEY_BASE + 32, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 40, I0, I1, T0, T1)
 
+#define ENCRYPT_192_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE +  0, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE +  8, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE + 16, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE + 24, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE + 32, I0, I1, I2, I3, T0, T1, T2, T3) \
+	ENCRYPT_TWO_ROUNDS_LAST_2(KEY_BASE + 40, I0, I1, I2, I3, T0, T1, T2, T3)
+
 	/* 14 rounds */
 #define ENCRYPT_256(KEY_BASE, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
@@ -88,6 +127,34 @@
 	ENCRYPT_TWO_ROUNDS(KEY_BASE + 40, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 48, I0, I1, T0, T1)
 
+#define ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE, I0, I1, I2, I3, TMP_BASE) \
+	ENCRYPT_TWO_ROUNDS_2(KEY_BASE, I0, I1, I2, I3, \
+			     TMP_BASE + 0, TMP_BASE + 2, TMP_BASE + 4, TMP_BASE + 6)
+
+#define ENCRYPT_256_2(KEY_BASE, I0, I1, I2, I3) \
+	ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE +  0, I0, I1, I2, I3, KEY_BASE + 48) \
+	ldd	[%o0 + 0xd0], %f56; \
+	ldd	[%o0 + 0xd8], %f58; \
+	ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE +  8, I0, I1, I2, I3, KEY_BASE +  0) \
+	ldd	[%o0 + 0xe0], %f60; \
+	ldd	[%o0 + 0xe8], %f62; \
+	ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE + 16, I0, I1, I2, I3, KEY_BASE +  0) \
+	ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE + 24, I0, I1, I2, I3, KEY_BASE +  0) \
+	ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE + 32, I0, I1, I2, I3, KEY_BASE +  0) \
+	ENCRYPT_256_TWO_ROUNDS_2(KEY_BASE + 40, I0, I1, I2, I3, KEY_BASE +  0) \
+	AES_EROUND01(KEY_BASE +  48, I0, I1, KEY_BASE + 0) \
+	AES_EROUND23(KEY_BASE +  50, I0, I1, KEY_BASE + 2) \
+	AES_EROUND01(KEY_BASE +  48, I2, I3, KEY_BASE + 4) \
+	AES_EROUND23(KEY_BASE +  50, I2, I3, KEY_BASE + 6) \
+	AES_EROUND01_L(KEY_BASE +  52, KEY_BASE + 0, KEY_BASE + 2, I0) \
+	AES_EROUND23_L(KEY_BASE +  54, KEY_BASE + 0, KEY_BASE + 2, I1) \
+	ldd	[%o0 + 0x10], %f8; \
+	ldd	[%o0 + 0x18], %f10; \
+	AES_EROUND01_L(KEY_BASE +  52, KEY_BASE + 4, KEY_BASE + 6, I2) \
+	AES_EROUND23_L(KEY_BASE +  54, KEY_BASE + 4, KEY_BASE + 6, I3) \
+	ldd	[%o0 + 0x20], %f12; \
+	ldd	[%o0 + 0x28], %f14;
+
 #define DECRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
 	AES_DROUND23(KEY_BASE +  0, I0, I1, T1) \
 	AES_DROUND01(KEY_BASE +  2, I0, I1, T0) \
@@ -832,10 +899,34 @@ ENDPROC(aes_sparc64_load_decrypt_keys_256)
 ENTRY(aes_sparc64_ecb_encrypt_128)
 	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
-	ldx		[%o0 + 0x08], %g2
+	subcc		%o3, 0x10, %o3
+	be		10f
+	 ldx		[%o0 + 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
-	add		%o1, 0x10, %o1
+	ldx		[%o1 + 0x10], %o4
+	ldx		[%o1 + 0x18], %o5
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+	xor		%g1, %o4, %g3
+	xor		%g2, %o5, %g7
+	MOVXTOD_G3_F60
+	MOVXTOD_G7_F62
+	ENCRYPT_128_2(8, 4, 6, 60, 62, 0, 2, 56, 58)
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	sub		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
@@ -843,10 +934,7 @@ ENTRY(aes_sparc64_ecb_encrypt_128)
 	ENCRYPT_128(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	retl
+11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_encrypt_128)
 
@@ -854,10 +942,34 @@ ENDPROC(aes_sparc64_ecb_encrypt_128)
 ENTRY(aes_sparc64_ecb_encrypt_192)
 	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
-	ldx		[%o0 + 0x08], %g2
+	subcc		%o3, 0x10, %o3
+	be		10f
+	 ldx		[%o0 + 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
-	add		%o1, 0x10, %o1
+	ldx		[%o1 + 0x10], %o4
+	ldx		[%o1 + 0x18], %o5
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+	xor		%g1, %o4, %g3
+	xor		%g2, %o5, %g7
+	MOVXTOD_G3_F60
+	MOVXTOD_G7_F62
+	ENCRYPT_192_2(8, 4, 6, 60, 62, 0, 2, 56, 58)
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	sub		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
@@ -865,10 +977,7 @@ ENTRY(aes_sparc64_ecb_encrypt_192)
 	ENCRYPT_192(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	retl
+11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_encrypt_192)
 
@@ -876,10 +985,34 @@ ENDPROC(aes_sparc64_ecb_encrypt_192)
 ENTRY(aes_sparc64_ecb_encrypt_256)
 	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
-	ldx		[%o0 + 0x08], %g2
+	subcc		%o3, 0x10, %o3
+	be		10f
+	 ldx		[%o0 + 0x08], %g2
 1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
-	add		%o1, 0x10, %o1
+	ldx		[%o1 + 0x10], %o4
+	ldx		[%o1 + 0x18], %o5
+	xor		%g1, %g3, %g3
+	xor		%g2, %g7, %g7
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+	xor		%g1, %o4, %g3
+	xor		%g2, %o5, %g7
+	MOVXTOD_G3_F0
+	MOVXTOD_G7_F2
+	ENCRYPT_256_2(8, 4, 6, 0, 2)
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	std		%f0, [%o2 + 0x10]
+	std		%f2, [%o2 + 0x18]
+	sub		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
@@ -887,10 +1020,7 @@ ENTRY(aes_sparc64_ecb_encrypt_256)
 	ENCRYPT_256(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	retl
+11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_encrypt_256)
 
-- 
1.7.10.4
