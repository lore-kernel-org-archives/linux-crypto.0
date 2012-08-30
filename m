From: David Miller <davem@davemloft.net>
Subject: [PATCH 5/5] sparc64: Unroll CTR crypt loops in AES driver.
Date: Thu, 30 Aug 2012 11:46:44 -0400 (EDT)
Message-ID: <20120830.114644.1460036275187406714.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2H3Pqq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2012 11:46:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Before:

testing speed of ctr(aes) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 206 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 244 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 360 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 814 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 5021 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 206 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 240 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 378 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 939 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 6395 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 209 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 249 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 414 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1073 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 7110 cycles (8192 bytes)

testing speed of ctr(aes) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 225 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 233 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 344 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 810 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 5021 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 206 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 240 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 376 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 938 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 6380 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 214 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 251 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 411 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1070 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 7114 cycles (8192 bytes)

After:

testing speed of ctr(aes) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 211 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 246 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 344 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 799 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 4975 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 210 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 236 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 365 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 888 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 6055 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 209 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 255 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 404 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1010 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 6669 cycles (8192 bytes)

testing speed of ctr(aes) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 210 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 233 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 340 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 818 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 4956 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 206 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 239 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 361 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 888 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 5996 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 214 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 248 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 395 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1010 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 6664 cycles (8192 bytes)

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/crypto/aes_asm.S |  142 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 118 insertions(+), 24 deletions(-)

diff --git a/arch/sparc/crypto/aes_asm.S b/arch/sparc/crypto/aes_asm.S
index 0bd3e04..0fadad0 100644
--- a/arch/sparc/crypto/aes_asm.S
+++ b/arch/sparc/crypto/aes_asm.S
@@ -48,6 +48,10 @@
 	.word	0x81b0230d;
 #define MOVXTOD_O5_F2		\
 	.word	0x85b0230d;
+#define MOVXTOD_O5_F4		\
+	.word	0x89b0230d;
+#define MOVXTOD_O5_F6		\
+	.word	0x8db0230d;
 #define MOVXTOD_G3_F60		\
 	.word	0xbbb02303;
 #define MOVXTOD_G7_F62		\
@@ -1400,8 +1404,10 @@ ENTRY(aes_sparc64_ctr_crypt_128)
 	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
 	ldx		[%o4 + 0x00], %g3
 	ldx		[%o4 + 0x08], %g7
+	subcc		%o3, 0x10, %o3
 	ldx		[%o0 + 0x00], %g1
-	ldx		[%o0 + 0x08], %g2
+	be		10f
+	 ldx		[%o0 + 0x08], %g2
 1:	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
 	xor		%g2, %g7, %o5
@@ -1409,6 +1415,39 @@ ENTRY(aes_sparc64_ctr_crypt_128)
 	add		%g7, 1, %g7
 	add		%g3, 1, %o5
 	movrz		%g7, %o5, %g3
+	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F4
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F6
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
+	ENCRYPT_128_2(8, 0, 2, 4, 6, 56, 58, 60, 62)
+	ldd		[%o1 + 0x00], %f56
+	ldd		[%o1 + 0x08], %f58
+	ldd		[%o1 + 0x10], %f60
+	ldd		[%o1 + 0x18], %f62
+	fxor		%f56, %f0, %f56
+	fxor		%f58, %f2, %f58
+	fxor		%f60, %f4, %f60
+	fxor		%f62, %f6, %f62
+	std		%f56, [%o2 + 0x00]
+	std		%f58, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	subcc		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F0
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F2
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
 	ENCRYPT_128(8, 0, 2, 4, 6)
 	ldd		[%o1 + 0x00], %f4
 	ldd		[%o1 + 0x08], %f6
@@ -1416,14 +1455,9 @@ ENTRY(aes_sparc64_ctr_crypt_128)
 	fxor		%f6, %f2, %f6
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	add		%o1, 0x10, %o1
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	stx		%g3, [%o4 + 0x00]
-	stx		%g7, [%o4 + 0x08]
+11:	stx		%g3, [%o4 + 0x00]
 	retl
-	 nop
+	 stx		%g7, [%o4 + 0x08]
 ENDPROC(aes_sparc64_ctr_crypt_128)
 
 	.align		32
@@ -1431,8 +1465,10 @@ ENTRY(aes_sparc64_ctr_crypt_192)
 	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
 	ldx		[%o4 + 0x00], %g3
 	ldx		[%o4 + 0x08], %g7
+	subcc		%o3, 0x10, %o3
 	ldx		[%o0 + 0x00], %g1
-	ldx		[%o0 + 0x08], %g2
+	be		10f
+	 ldx		[%o0 + 0x08], %g2
 1:	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
 	xor		%g2, %g7, %o5
@@ -1440,6 +1476,39 @@ ENTRY(aes_sparc64_ctr_crypt_192)
 	add		%g7, 1, %g7
 	add		%g3, 1, %o5
 	movrz		%g7, %o5, %g3
+	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F4
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F6
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
+	ENCRYPT_192_2(8, 0, 2, 4, 6, 56, 58, 60, 62)
+	ldd		[%o1 + 0x00], %f56
+	ldd		[%o1 + 0x08], %f58
+	ldd		[%o1 + 0x10], %f60
+	ldd		[%o1 + 0x18], %f62
+	fxor		%f56, %f0, %f56
+	fxor		%f58, %f2, %f58
+	fxor		%f60, %f4, %f60
+	fxor		%f62, %f6, %f62
+	std		%f56, [%o2 + 0x00]
+	std		%f58, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	subcc		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F0
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F2
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
 	ENCRYPT_192(8, 0, 2, 4, 6)
 	ldd		[%o1 + 0x00], %f4
 	ldd		[%o1 + 0x08], %f6
@@ -1447,14 +1516,9 @@ ENTRY(aes_sparc64_ctr_crypt_192)
 	fxor		%f6, %f2, %f6
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	add		%o1, 0x10, %o1
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	stx		%g3, [%o4 + 0x00]
-	stx		%g7, [%o4 + 0x08]
+11:	stx		%g3, [%o4 + 0x00]
 	retl
-	 nop
+	 stx		%g7, [%o4 + 0x08]
 ENDPROC(aes_sparc64_ctr_crypt_192)
 
 	.align		32
@@ -1462,8 +1526,10 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
 	ldx		[%o4 + 0x00], %g3
 	ldx		[%o4 + 0x08], %g7
+	subcc		%o3, 0x10, %o3
 	ldx		[%o0 + 0x00], %g1
-	ldx		[%o0 + 0x08], %g2
+	be		10f
+	 ldx		[%o0 + 0x08], %g2
 1:	xor		%g1, %g3, %o5
 	MOVXTOD_O5_F0
 	xor		%g2, %g7, %o5
@@ -1471,6 +1537,39 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	add		%g7, 1, %g7
 	add		%g3, 1, %o5
 	movrz		%g7, %o5, %g3
+	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F4
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F6
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
+	ENCRYPT_256_2(8, 0, 2, 4, 6)
+	ldd		[%o1 + 0x00], %f56
+	ldd		[%o1 + 0x08], %f58
+	ldd		[%o1 + 0x10], %f60
+	ldd		[%o1 + 0x18], %f62
+	fxor		%f56, %f0, %f56
+	fxor		%f58, %f2, %f58
+	fxor		%f60, %f4, %f60
+	fxor		%f62, %f6, %f62
+	std		%f56, [%o2 + 0x00]
+	std		%f58, [%o2 + 0x08]
+	std		%f60, [%o2 + 0x10]
+	std		%f62, [%o2 + 0x18]
+	subcc		%o3, 0x20, %o3
+	add		%o1, 0x20, %o1
+	brgz		%o3, 1b
+	 add		%o2, 0x20, %o2
+	brlz,pt		%o3, 11f
+	 nop
+10:	xor		%g1, %g3, %o5
+	MOVXTOD_O5_F0
+	xor		%g2, %g7, %o5
+	MOVXTOD_O5_F2
+	add		%g7, 1, %g7
+	add		%g3, 1, %o5
+	movrz		%g7, %o5, %g3
 	ENCRYPT_256(8, 0, 2, 4, 6)
 	ldd		[%o1 + 0x00], %f4
 	ldd		[%o1 + 0x08], %f6
@@ -1478,12 +1577,7 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	fxor		%f6, %f2, %f6
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o3, 0x10, %o3
-	add		%o1, 0x10, %o1
-	bne,pt		%xcc, 1b
-	 add		%o2, 0x10, %o2
-	stx		%g3, [%o4 + 0x00]
-	stx		%g7, [%o4 + 0x08]
+11:	stx		%g3, [%o4 + 0x00]
 	retl
-	 nop
+	 stx		%g7, [%o4 + 0x08]
 ENDPROC(aes_sparc64_ctr_crypt_256)
-- 
1.7.10.4
