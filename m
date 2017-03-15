From: Daniel Axtens <dja@axtens.net>
Subject: [PATCH 2/4] crypto: powerpc - Re-enable non-REFLECTed CRCs
Date: Wed, 15 Mar 2017 23:37:35 +1100
Message-ID: <20170315123737.20234-2-dja@axtens.net>
References: <20170315123737.20234-1-dja@axtens.net>
Cc: anton@samba.org, Daniel Axtens <dja@axtens.net>
To: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32866 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdCOMiL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2017 08:38:11 -0400
Received: by mail-it0-f67.google.com with SMTP id g138so2923706itb.0
        for <linux-crypto@vger.kernel.org>; Wed, 15 Mar 2017 05:38:10 -0700 (PDT)
In-Reply-To: <20170315123737.20234-1-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When CRC32c was included in the kernel, Anton ripped out
the #ifdefs around reflected polynomials, because CRC32c
is always reflected. However, not all CRCs use reflection
so we'd like to make it optional.

Restore the REFLECT parts from Anton's original CRC32
implementation (https://github.com/antonblanchard/crc32-vpmsum)

That implementation is available under GPLv2+, so we're OK
from a licensing point of view:
https://github.com/antonblanchard/crc32-vpmsum/blob/master/LICENSE.TXT

As CRC32c requires REFLECT, add that #define.

Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Daniel Axtens <dja@axtens.net>

---

I compared the disassembly of the CRC32c module on LE before and
after the change, and verified that they were the same.

I verified that the crypto self-tests still pass on LE and BE, and
my tests in patch 4 still pass as well.
---
 arch/powerpc/crypto/crc32-vpmsum_core.S | 31 ++++++++++++++++++++++++++++++-
 arch/powerpc/crypto/crc32c-vpmsum_asm.S |  1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/crc32-vpmsum_core.S b/arch/powerpc/crypto/crc32-vpmsum_core.S
index 629244ef170e..87fabf4d391a 100644
--- a/arch/powerpc/crypto/crc32-vpmsum_core.S
+++ b/arch/powerpc/crypto/crc32-vpmsum_core.S
@@ -35,7 +35,9 @@
 
 	.text
 
-#if defined(__BIG_ENDIAN__)
+#if defined(__BIG_ENDIAN__) && defined(REFLECT)
+#define BYTESWAP_DATA
+#elif defined(__LITTLE_ENDIAN__) && !defined(REFLECT)
 #define BYTESWAP_DATA
 #else
 #undef BYTESWAP_DATA
@@ -108,7 +110,11 @@ FUNC_START(CRC_FUNCTION_NAME)
 	/* Get the initial value into v8 */
 	vxor	v8,v8,v8
 	MTVRD(v8, R3)
+#ifdef REFLECT
 	vsldoi	v8,zeroes,v8,8	/* shift into bottom 32 bits */
+#else
+	vsldoi	v8,v8,zeroes,4	/* shift into top 32 bits */
+#endif
 
 #ifdef BYTESWAP_DATA
 	addis	r3,r2,.byteswap_constant@toc@ha
@@ -354,6 +360,7 @@ FUNC_START(CRC_FUNCTION_NAME)
 	vxor	v6,v6,v14
 	vxor	v7,v7,v15
 
+#ifdef REFLECT
 	/*
 	 * vpmsumd produces a 96 bit result in the least significant bits
 	 * of the register. Since we are bit reflected we have to shift it
@@ -368,6 +375,7 @@ FUNC_START(CRC_FUNCTION_NAME)
 	vsldoi	v5,v5,zeroes,4
 	vsldoi	v6,v6,zeroes,4
 	vsldoi	v7,v7,zeroes,4
+#endif
 
 	/* xor with last 1024 bits */
 	lvx	v8,0,r4
@@ -511,13 +519,33 @@ FUNC_START(CRC_FUNCTION_NAME)
 	vsldoi	v1,v0,v0,8
 	vxor	v0,v0,v1		/* xor two 64 bit results together */
 
+#ifdef REFLECT
 	/* shift left one bit */
 	vspltisb v1,1
 	vsl	v0,v0,v1
+#endif
 
 	vand	v0,v0,mask_64bit
+#ifndef REFLECT
+	/*
+	 * Now for the Barrett reduction algorithm. The idea is to calculate q,
+	 * the multiple of our polynomial that we need to subtract. By
+	 * doing the computation 2x bits higher (ie 64 bits) and shifting the
+	 * result back down 2x bits, we round down to the nearest multiple.
+	 */
+	VPMSUMD(v1,v0,const1)	/* ma */
+	vsldoi	v1,zeroes,v1,8	/* q = floor(ma/(2^64)) */
+	VPMSUMD(v1,v1,const2)	/* qn */
+	vxor	v0,v0,v1	/* a - qn, subtraction is xor in GF(2) */
 
 	/*
+	 * Get the result into r3. We need to shift it left 8 bytes:
+	 * V0 [ 0 1 2 X ]
+	 * V0 [ 0 X 2 3 ]
+	 */
+	vsldoi	v0,v0,zeroes,8	/* shift result into top 64 bits */
+#else
+	/*
 	 * The reflected version of Barrett reduction. Instead of bit
 	 * reflecting our data (which is expensive to do), we bit reflect our
 	 * constants and our algorithm, which means the intermediate data in
@@ -537,6 +565,7 @@ FUNC_START(CRC_FUNCTION_NAME)
 	 * V0 [ 0 X 2 3 ]
 	 */
 	vsldoi	v0,v0,zeroes,4		/* shift result into top 64 bits of */
+#endif
 
 	/* Get it into r3 */
 	MFVRD(R3, v0)
diff --git a/arch/powerpc/crypto/crc32c-vpmsum_asm.S b/arch/powerpc/crypto/crc32c-vpmsum_asm.S
index c0d080caefc1..d2bea48051a0 100644
--- a/arch/powerpc/crypto/crc32c-vpmsum_asm.S
+++ b/arch/powerpc/crypto/crc32c-vpmsum_asm.S
@@ -842,4 +842,5 @@
 	.octa 0x00000000000000000000000105ec76f1
 
 #define CRC_FUNCTION_NAME __crc32c_vpmsum
+#define REFLECT
 #include "crc32-vpmsum_core.S"
-- 
2.9.3
