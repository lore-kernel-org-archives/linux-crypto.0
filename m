From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [PATCH] [crypto] LRW: use proper alignment.
Date: Sun, 2 Mar 2008 13:35:17 +0000
Message-ID: <1b5471b654eea02f82ccf0aad032fbbb951cbbc5.1204465942.git.sebastian@breakpoint.cc>
References: <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46451 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbYCBNzm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 08:55:42 -0500
In-Reply-To: <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The LRW blockmode uses a copy of the IV which is saved on the stack
and may or may not be properly aligned. If it is not, it will break
hardware cipher like the geode or padlock.
This patch moves the copy of IV to the private structre which has the
same aligment as the underlying cipher.
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/lrw.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 9d52e58..0c3ce3e 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -27,7 +27,17 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
+struct sinfo {
+	be128 t;
+	struct crypto_tfm *tfm;
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+};
+
 struct priv {
+	/* s.t being the first member in this struct enforces proper alignment
+	 * required by the underlying cipher without explicit knowing the it.
+	 */
+	struct sinfo s;
 	struct crypto_cipher *child;
 	/* optimizes multiplying a random (non incrementing, as at the
 	 * start of a new sector) value with key2, we could also have
@@ -83,12 +93,6 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
 	return 0;
 }
 
-struct sinfo {
-	be128 t;
-	struct crypto_tfm *tfm;
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-};
-
 static inline void inc(be128 *iv)
 {
 	if (!(iv->b = cpu_to_be64(be64_to_cpu(iv->b) + 1)))
@@ -128,14 +132,14 @@ static int crypt(struct blkcipher_desc *d,
 	int err;
 	unsigned int avail;
 	const int bs = crypto_cipher_blocksize(ctx->child);
-	struct sinfo s = {
-		.tfm = crypto_cipher_tfm(ctx->child),
-		.fn = fn
-	};
+	struct sinfo *s = &ctx->s;
 	be128 *iv;
 	u8 *wsrc;
 	u8 *wdst;
 
+	s->tfm = crypto_cipher_tfm(ctx->child);
+	s->fn = fn;
+
 	err = blkcipher_walk_virt(d, w);
 	if (!(avail = w->nbytes))
 		return err;
@@ -145,10 +149,10 @@ static int crypt(struct blkcipher_desc *d,
 
 	/* calculate first value of T */
 	iv = (be128 *)w->iv;
-	s.t = *iv;
+	s->t = *iv;
 
 	/* T <- I*Key2 */
-	gf128mul_64k_bbe(&s.t, ctx->table);
+	gf128mul_64k_bbe(&s->t, ctx->table);
 
 	goto first;
 
@@ -156,11 +160,11 @@ static int crypt(struct blkcipher_desc *d,
 		do {
 			/* T <- I*Key2, using the optimization
 			 * discussed in the specification */
-			be128_xor(&s.t, &s.t, &ctx->mulinc[get_index128(iv)]);
+			be128_xor(&s->t, &s->t, &ctx->mulinc[get_index128(iv)]);
 			inc(iv);
 
 first:
-			lrw_round(&s, wdst, wsrc);
+			lrw_round(s, wdst, wsrc);
 
 			wsrc += bs;
 			wdst += bs;
-- 
1.5.3.4

