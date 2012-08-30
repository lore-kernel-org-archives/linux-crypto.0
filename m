From: David Miller <davem@davemloft.net>
Subject: [PATCH 4/5] sparc64: Unroll ECB decryption loops in AES driver.
Date: Thu, 30 Aug 2012 11:46:38 -0400 (EDT)
Message-ID: <20120830.114638.173376130164118936.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36790 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2H3Pqj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2012 11:46:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Before:

testing speed of ecb(aes) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 223 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 230 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 325 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 719 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 4266 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 211 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 234 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 353 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 808 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 5344 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 214 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 243 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 393 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 939 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 6039 cycles (8192 bytes)

After:

testing speed of ecb(aes) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 226 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 231 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 313 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 681 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 3964 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 205 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 240 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 341 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 770 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 5050 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 216 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 250 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 371 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 869 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 5494 cycles (8192 bytes)

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/crypto/aes_asm.S |  161 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 143 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/crypto/aes_asm.S b/arch/sparc/crypto/aes_asm.S
index 33d59c6..0bd3e04 100644
--- a/arch/sparc/crypto/aes_asm.S
+++ b/arch/sparc/crypto/aes_asm.S
@@ -161,12 +161,32 @@
 	AES_DROUND23(KEY_BASE +  4, T0, T1, I1) \
 	AES_DROUND01(KEY_BASE +  6, T0, T1, I0)
 
+#define DECRYPT_TWO_ROUNDS_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	AES_DROUND23(KEY_BASE +  0, I0, I1, T1) \
+	AES_DROUND01(KEY_BASE +  2, I0, I1, T0) \
+	AES_DROUND23(KEY_BASE +  0, I2, I3, T3) \
+	AES_DROUND01(KEY_BASE +  2, I2, I3, T2) \
+	AES_DROUND23(KEY_BASE +  4, T0, T1, I1) \
+	AES_DROUND01(KEY_BASE +  6, T0, T1, I0) \
+	AES_DROUND23(KEY_BASE +  4, T2, T3, I3) \
+	AES_DROUND01(KEY_BASE +  6, T2, T3, I2)
+
 #define DECRYPT_TWO_ROUNDS_LAST(KEY_BASE, I0, I1, T0, T1) \
 	AES_DROUND23(KEY_BASE +  0, I0, I1, T1) \
 	AES_DROUND01(KEY_BASE +  2, I0, I1, T0) \
 	AES_DROUND23_L(KEY_BASE +  4, T0, T1, I1) \
 	AES_DROUND01_L(KEY_BASE +  6, T0, T1, I0)
 
+#define DECRYPT_TWO_ROUNDS_LAST_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	AES_DROUND23(KEY_BASE +  0, I0, I1, T1) \
+	AES_DROUND01(KEY_BASE +  2, I0, I1, T0) \
+	AES_DROUND23(KEY_BASE +  0, I2, I3, T3) \
+	AES_DROUND01(KEY_BASE +  2, I2, I3, T2) \
+	AES_DROUND23_L(KEY_BASE +  4, T0, T1, I1) \
+	AES_DROUND01_L(KEY_BASE +  6, T0, T1, I0) \
+	AES_DROUND23_L(KEY_BASE +  4, T2, T3, I3) \
+	AES_DROUND01_L(KEY_BASE +  6, T2, T3, I2)
+
 	/* 10 rounds */
 #define DECRYPT_128(KEY_BASE, I0, I1, T0, T1) \
 	DECRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
@@ -175,6 +195,13 @@
 	DECRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
 	DECRYPT_TWO_ROUNDS_LAST(KEY_BASE + 32, I0, I1, T0, T1)
 
+#define DECRYPT_128_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE +  0, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE +  8, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE + 16, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE + 24, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_LAST_2(KEY_BASE + 32, I0, I1, I2, I3, T0, T1, T2, T3)
+
 	/* 12 rounds */
 #define DECRYPT_192(KEY_BASE, I0, I1, T0, T1) \
 	DECRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
@@ -184,6 +211,14 @@
 	DECRYPT_TWO_ROUNDS(KEY_BASE + 32, I0, I1, T0, T1) \
 	DECRYPT_TWO_ROUNDS_LAST(KEY_BASE + 40, I0, I1, T0, T1)
 
+#define DECRYPT_192_2(KEY_BASE, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE +  0, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE +  8, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE + 16, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE + 24, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE + 32, I0, I1, I2, I3, T0, T1, T2, T3) \
+	DECRYPT_TWO_ROUNDS_LAST_2(KEY_BASE + 40, I0, I1, I2, I3, T0, T1, T2, T3)
+
 	/* 14 rounds */
 #define DECRYPT_256(KEY_BASE, I0, I1, T0, T1) \
 	DECRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
@@ -194,6 +229,32 @@
 	DECRYPT_TWO_ROUNDS(KEY_BASE + 40, I0, I1, T0, T1) \
 	DECRYPT_TWO_ROUNDS_LAST(KEY_BASE + 48, I0, I1, T0, T1)
 
+#define DECRYPT_256_TWO_ROUNDS_2(KEY_BASE, I0, I1, I2, I3, TMP_BASE) \
+	DECRYPT_TWO_ROUNDS_2(KEY_BASE, I0, I1, I2, I3, \
+			     TMP_BASE + 0, TMP_BASE + 2, TMP_BASE + 4, TMP_BASE + 6)
+
+#define DECRYPT_256_2(KEY_BASE, I0, I1, I2, I3) \
+	DECRYPT_256_TWO_ROUNDS_2(KEY_BASE +  0, I0, I1, I2, I3, KEY_BASE + 48) \
+	ldd	[%o0 + 0x18], %f56; \
+	ldd	[%o0 + 0x10], %f58; \
+	DECRYPT_256_TWO_ROUNDS_2(KEY_BASE +  8, I0, I1, I2, I3, KEY_BASE +  0) \
+	DECRYPT_256_TWO_ROUNDS_2(KEY_BASE + 16, I0, I1, I2, I3, KEY_BASE +  0) \
+	DECRYPT_256_TWO_ROUNDS_2(KEY_BASE + 24, I0, I1, I2, I3, KEY_BASE +  0) \
+	DECRYPT_256_TWO_ROUNDS_2(KEY_BASE + 32, I0, I1, I2, I3, KEY_BASE +  0) \
+	DECRYPT_256_TWO_ROUNDS_2(KEY_BASE + 40, I0, I1, I2, I3, KEY_BASE +  0) \
+	AES_DROUND23(KEY_BASE +  48, I0, I1, KEY_BASE + 2) \
+	AES_DROUND01(KEY_BASE +  50, I0, I1, KEY_BASE + 0) \
+	AES_DROUND23(KEY_BASE +  48, I2, I3, KEY_BASE + 6) \
+	AES_DROUND01(KEY_BASE +  50, I2, I3, KEY_BASE + 4) \
+	AES_DROUND23_L(KEY_BASE +  52, KEY_BASE + 0, KEY_BASE + 2, I1) \
+	AES_DROUND01_L(KEY_BASE +  54, KEY_BASE + 0, KEY_BASE + 2, I0) \
+	ldd	[%o0 + 0xd8], %f8; \
+	ldd	[%o0 + 0xd0], %f10; \
+	AES_DROUND23_L(KEY_BASE +  52, KEY_BASE + 4, KEY_BASE + 6, I3) \
+	AES_DROUND01_L(KEY_BASE +  54, KEY_BASE + 4, KEY_BASE + 6, I2)
+	ldd	[%o0 + 0xc8], %f12; \
+	ldd	[%o0 + 0xc0], %f14;
+
 	.align	32
 ENTRY(aes_sparc64_key_expand)
 	/* %o0=input_key, %o1=output_key, %o2=key_len */
@@ -1028,10 +1089,34 @@ ENDPROC(aes_sparc64_ecb_encrypt_256)
 ENTRY(aes_sparc64_ecb_decrypt_128)
 	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
-	ldx		[%o0 - 0x08], %g2
+	subcc		%o3, 0x10, %o3
+	be		10f
+	 ldx		[%o0 - 0x08], %g2
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
+	DECRYPT_128_2(8, 4, 6, 60, 62, 0, 2, 56, 58)
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	sub		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz,pt		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
@@ -1039,10 +1124,7 @@ ENTRY(aes_sparc64_ecb_decrypt_128)
 	DECRYPT_128(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	retl
+11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_decrypt_128)
 
@@ -1050,10 +1132,34 @@ ENDPROC(aes_sparc64_ecb_decrypt_128)
 ENTRY(aes_sparc64_ecb_decrypt_192)
 	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
-	ldx		[%o0 - 0x08], %g2
+	subcc		%o3, 0x10, %o3
+	be		10f
+	 ldx		[%o0 - 0x08], %g2
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
+	DECRYPT_192_2(8, 4, 6, 60, 62, 0, 2, 56, 58)
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	sub		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz,pt		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
@@ -1061,10 +1167,7 @@ ENTRY(aes_sparc64_ecb_decrypt_192)
 	DECRYPT_192(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	retl
+11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_decrypt_192)
 
@@ -1072,10 +1175,35 @@ ENDPROC(aes_sparc64_ecb_decrypt_192)
 ENTRY(aes_sparc64_ecb_decrypt_256)
 	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
-	ldx		[%o0 - 0x08], %g2
+	subcc		%o3, 0x10, %o3
+	be		10f
+	 ldx		[%o0 - 0x08], %g2
+	sub		%o0, 0xf0, %o0
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
+	DECRYPT_256_2(8, 4, 6, 0, 2)
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	sub		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz,pt		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
@@ -1083,10 +1211,7 @@ ENTRY(aes_sparc64_ecb_decrypt_256)
 	DECRYPT_256(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	retl
+11:	retl
 	 nop
 ENDPROC(aes_sparc64_ecb_decrypt_256)
 
-- 
1.7.10.4
