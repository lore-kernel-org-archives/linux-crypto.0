From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] XTS: use proper alignment.
Date: Sun, 2 Mar 2008 11:09:10 +0000
Message-ID: <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Stefan Hellermann <stefan@the2masters.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46449 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbYCBNze (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 08:55:34 -0500
In-Reply-To: <20080302135135.GC16659@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The XTS blockmode uses a copy of the IV which is saved on the stack
and may or may not be properly aligned. If it is not, it will break
hardware cipher like the geode or padlock.
This patch moves the copy of IV to the private structre which has the
same aligment as the underlying cipher.

Tested-by: Stefan Hellermann <stefan@the2masters.de>
Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/xts.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 8eb08bf..4457022 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -24,7 +24,17 @@
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
 	struct crypto_cipher *tweak;
 };
@@ -76,12 +86,6 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
 	return 0;
 }
 
-struct sinfo {
-	be128 t;
-	struct crypto_tfm *tfm;
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
-};
-
 static inline void xts_round(struct sinfo *s, void *dst, const void *src)
 {
 	be128_xor(dst, &s->t, src);		/* PP <- T xor P */
@@ -97,13 +101,12 @@ static int crypt(struct blkcipher_desc *d,
 	int err;
 	unsigned int avail;
 	const int bs = crypto_cipher_blocksize(ctx->child);
-	struct sinfo s = {
-		.tfm = crypto_cipher_tfm(ctx->child),
-		.fn = fn
-	};
-	be128 *iv;
 	u8 *wsrc;
 	u8 *wdst;
+	struct sinfo *s = &ctx->s;
+
+	s->tfm = crypto_cipher_tfm(ctx->child);
+	s->fn = fn;
 
 	err = blkcipher_walk_virt(d, w);
 	if (!w->nbytes)
@@ -115,17 +118,16 @@ static int crypt(struct blkcipher_desc *d,
 	wdst = w->dst.virt.addr;
 
 	/* calculate first value of T */
-	iv = (be128 *)w->iv;
-	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s.t, w->iv);
+	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s->t, w->iv);
 
 	goto first;
 
 	for (;;) {
 		do {
-			gf128mul_x_ble(&s.t, &s.t);
+			gf128mul_x_ble(&s->t, &s->t);
 
 first:
-			xts_round(&s, wdst, wsrc);
+			xts_round(s, wdst, wsrc);
 
 			wsrc += bs;
 			wdst += bs;
-- 
1.5.3.4

