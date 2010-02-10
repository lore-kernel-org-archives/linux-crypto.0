From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in cast5.c
Date: Wed, 10 Feb 2010 02:29:14 +0100
Message-ID: <1265765355-24346-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50347 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab0BJB3w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:29:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/cast5.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/cast5.c b/crypto/cast5.c
index 8cbe28f..a1d2294 100644
--- a/crypto/cast5.c
+++ b/crypto/cast5.c
@@ -569,12 +569,12 @@ static const u32 sb8[256] = {
 	0xeaee6801, 0x8db2a283, 0xea8bf59e
 };
 
-#define F1(D,m,r)  (  (I = ((m) + (D))), (I=rol32(I,(r))),   \
-    (((s1[I >> 24] ^ s2[(I>>16)&0xff]) - s3[(I>>8)&0xff]) + s4[I&0xff]) )
-#define F2(D,m,r)  (  (I = ((m) ^ (D))), (I=rol32(I,(r))),   \
-    (((s1[I >> 24] - s2[(I>>16)&0xff]) + s3[(I>>8)&0xff]) ^ s4[I&0xff]) )
-#define F3(D,m,r)  (  (I = ((m) - (D))), (I=rol32(I,(r))),   \
-    (((s1[I >> 24] + s2[(I>>16)&0xff]) ^ s3[(I>>8)&0xff]) - s4[I&0xff]) )
+#define F1(D, m, r)  ((I = ((m) + (D))), (I = rol32(I, (r))),   \
+    (((s1[I >> 24] ^ s2[(I>>16)&0xff]) - s3[(I>>8)&0xff]) + s4[I&0xff]))
+#define F2(D, m, r)  ((I = ((m) ^ (D))), (I = rol32(I, (r))),   \
+    (((s1[I >> 24] - s2[(I>>16)&0xff]) + s3[(I>>8)&0xff]) ^ s4[I&0xff]))
+#define F3(D, m, r)  ((I = ((m) - (D))), (I = rol32(I, (r))),   \
+    (((s1[I >> 24] + s2[(I>>16)&0xff]) ^ s3[(I>>8)&0xff]) - s4[I&0xff]))
 
 
 static void cast5_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
@@ -694,7 +694,7 @@ static void cast5_decrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	dst[1] = cpu_to_be32(l);
 }
 
-static void key_schedule(u32 * x, u32 * z, u32 * k)
+static void key_schedule(u32 *x, u32 *z, u32 *k)
 {
 
 #define xi(i)   ((x[(i)/4] >> (8*(3-((i)%4)))) & 0xff)
-- 
1.6.6.1

