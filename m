From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 16/19] crypto: tgr192 - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:23:15 +0100
Message-ID: <1266538996-3608-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44202 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0BSAXd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Feb 2010 19:23:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/tgr192.c |   44 ++++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index cbca4f2..67dd5e7 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -12,7 +12,7 @@
  * This version is derived from the GnuPG implementation and the
  * Tiger-Perl interface written by Rafael Sevilla
  *
- * Adapted for Linux Kernel Crypto  by Aaron Grothe 
+ * Adapted for Linux Kernel Crypto  by Aaron Grothe
  * ajgrothe@yahoo.com, February 22, 2005
  *
  * This program is free software; you can redistribute it and/or modify
@@ -398,7 +398,7 @@ static const u64 sbox4[256] = {
 };
 
 
-static void tgr192_round(u64 * ra, u64 * rb, u64 * rc, u64 x, int mul)
+static void tgr192_round(u64 *ra, u64 *rb, u64 *rc, u64 x, int mul)
 {
 	u64 a = *ra;
 	u64 b = *rb;
@@ -417,7 +417,7 @@ static void tgr192_round(u64 * ra, u64 * rb, u64 * rc, u64 x, int mul)
 }
 
 
-static void tgr192_pass(u64 * ra, u64 * rb, u64 * rc, u64 * x, int mul)
+static void tgr192_pass(u64 *ra, u64 *rb, u64 *rc, u64 *x, int mul)
 {
 	u64 a = *ra;
 	u64 b = *rb;
@@ -438,7 +438,7 @@ static void tgr192_pass(u64 * ra, u64 * rb, u64 * rc, u64 * x, int mul)
 }
 
 
-static void tgr192_key_schedule(u64 * x)
+static void tgr192_key_schedule(u64 *x)
 {
 	x[0] -= x[7] ^ 0xa5a5a5a5a5a5a5a5ULL;
 	x[1] ^= x[0];
@@ -512,7 +512,7 @@ static int tgr192_init(struct shash_desc *desc)
 /* Update the message digest with the contents
  * of INBUF with length INLEN. */
 static int tgr192_update(struct shash_desc *desc, const u8 *inbuf,
-			  unsigned int len)
+			 unsigned int len)
 {
 	struct tgr192_ctx *tctx = shash_desc_ctx(desc);
 
@@ -521,18 +521,14 @@ static int tgr192_update(struct shash_desc *desc, const u8 *inbuf,
 		tctx->count = 0;
 		tctx->nblocks++;
 	}
-	if (!inbuf) {
+	if (!inbuf)
 		return 0;
-	}
 	if (tctx->count) {
-		for (; len && tctx->count < 64; len--) {
+		for (; len && tctx->count < 64; len--)
 			tctx->hash[tctx->count++] = *inbuf++;
-		}
 		tgr192_update(desc, NULL, 0);
-		if (!len) {
+		if (!len)
 			return 0;
-		}
-
 	}
 
 	while (len >= 64) {
@@ -542,15 +538,13 @@ static int tgr192_update(struct shash_desc *desc, const u8 *inbuf,
 		len -= 64;
 		inbuf += 64;
 	}
-	for (; len && tctx->count < 64; len--) {
+	for (; len && tctx->count < 64; len--)
 		tctx->hash[tctx->count++] = *inbuf++;
-	}
 
 	return 0;
 }
 
 
-
 /* The routine terminates the computation */
 static int tgr192_final(struct shash_desc *desc, u8 * out)
 {
@@ -564,30 +558,25 @@ static int tgr192_final(struct shash_desc *desc, u8 * out)
 
 	msb = 0;
 	t = tctx->nblocks;
-	if ((lsb = t << 6) < t) { /* multiply by 64 to make a byte count */
+	if ((lsb = t << 6) < t) /* multiply by 64 to make a byte count */
 		msb++;
-	}
 	msb += t >> 26;
 	t = lsb;
-	if ((lsb = t + tctx->count) < t) {	/* add the count */
+	if ((lsb = t + tctx->count) < t) /* add the count */
 		msb++;
-	}
 	t = lsb;
-	if ((lsb = t << 3) < t)	{ /* multiply by 8 to make a bit count */
+	if ((lsb = t << 3) < t) /* multiply by 8 to make a bit count */
 		msb++;
-	}
 	msb += t >> 29;
 
 	if (tctx->count < 56) {	/* enough room */
 		tctx->hash[tctx->count++] = 0x01;	/* pad */
-		while (tctx->count < 56) {
+		while (tctx->count < 56)
 			tctx->hash[tctx->count++] = 0;	/* pad */
-		}
 	} else {		/* need one extra block */
 		tctx->hash[tctx->count++] = 0x01;	/* pad character */
-		while (tctx->count < 64) {
+		while (tctx->count < 64)
 			tctx->hash[tctx->count++] = 0;
-		}
 		tgr192_update(desc, NULL, 0); /* flush */ ;
 		memset(tctx->hash, 0, 56);    /* fill next block with zeroes */
 	}
@@ -676,9 +665,8 @@ static int __init tgr192_mod_init(void)
 
 	ret = crypto_register_shash(&tgr192);
 
-	if (ret < 0) {
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = crypto_register_shash(&tgr160);
 	if (ret < 0) {
@@ -691,7 +679,7 @@ static int __init tgr192_mod_init(void)
 		crypto_unregister_shash(&tgr192);
 		crypto_unregister_shash(&tgr160);
 	}
-      out:
+out:
 	return ret;
 }
 
-- 
1.6.6.1

