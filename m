From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH 1/1] Crypto: [xp ]cbc: use 64bit regs on 64bit machines (rev. 2)
Date: Thu, 14 Jun 2007 14:29:00 +0200
Message-ID: <20070614122900.GA7286@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40893 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbXFNM3D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jun 2007 08:29:03 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1HyoRg-0001uJ-A4
	for linux-crypto@vger.kernel.org; Thu, 14 Jun 2007 14:29:00 +0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I removed the "#if BITS_PER_LONG == 64" because the compiler can handle
u64 on 32bit machines. The asm output is the same.

Currently on 64bit machines, the xor operation takes two 32bit registers
for a 8byte xor instead one single 64bit register. This patch fixes it for
the cbc, pcbc and xcbc template.

A quick speed test with with the tcrypt module showed for aes+cbc+dec:
old:
test 14 (256 bit key, 8192 byte blocks): 1 operation in 183138 cycles
(8192 bytes)
new:
test 14 (256 bit key, 8192 byte blocks): 1 operation in 181419 cycles
(8192 bytes)

Maybe my computer is just as tired as I am. In general I thing 64bit
registers should be prefered.

Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Index: b/crypto/cbc.c
===================================================================
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/types.h>
 
 struct crypto_cbc_ctx {
 	struct crypto_cipher *child;
@@ -226,16 +227,13 @@ static void xor_quad(u8 *dst, const u8 *
 
 static void xor_64(u8 *a, const u8 *b, unsigned int bs)
 {
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
+	((u64 *)a)[0] ^= ((u64 *)b)[0];
 }
 
 static void xor_128(u8 *a, const u8 *b, unsigned int bs)
 {
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-	((u32 *)a)[2] ^= ((u32 *)b)[2];
-	((u32 *)a)[3] ^= ((u32 *)b)[3];
+	xor_64(&a[0], &b[0], bs);
+	xor_64(&a[8], &b[8], bs);
 }
 
 static int crypto_cbc_init_tfm(struct crypto_tfm *tfm)
Index: b/crypto/pcbc.c
===================================================================
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/types.h>
 
 struct crypto_pcbc_ctx {
 	struct crypto_cipher *child;
@@ -230,16 +231,13 @@ static void xor_quad(u8 *dst, const u8 *
 
 static void xor_64(u8 *a, const u8 *b, unsigned int bs)
 {
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
+	((u64 *)a)[0] ^= ((u64 *)b)[0];
 }
 
 static void xor_128(u8 *a, const u8 *b, unsigned int bs)
 {
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-	((u32 *)a)[2] ^= ((u32 *)b)[2];
-	((u32 *)a)[3] ^= ((u32 *)b)[3];
+	xor_64(&a[0], &b[0], bs);
+	xor_64(&a[8], &b[8], bs);
 }
 
 static int crypto_pcbc_init_tfm(struct crypto_tfm *tfm)
Index: b/crypto/xcbc.c
===================================================================
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -27,6 +27,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/scatterlist.h>
+#include <linux/types.h>
 #include "internal.h"
 
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
@@ -60,10 +61,8 @@ struct crypto_xcbc_ctx {
 
 static void xor_128(u8 *a, const u8 *b, unsigned int bs)
 {
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-	((u32 *)a)[2] ^= ((u32 *)b)[2];
-	((u32 *)a)[3] ^= ((u32 *)b)[3];
+	((u64 *)a)[0] ^= ((u64 *)b)[0];
+	((u64 *)a)[1] ^= ((u64 *)b)[1];
 }
 
 static int _crypto_xcbc_digest_setkey(struct crypto_hash *parent,
