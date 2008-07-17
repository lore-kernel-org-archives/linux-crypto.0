From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: Cleaning some more minor nits in prng
Date: Thu, 17 Jul 2008 14:30:12 -0400
Message-ID: <20080717183012.GF17892@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	nhorman@tuxdriver.com
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2296 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683AbYGQSaZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2008 14:30:25 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


 Clean up a few more minor nits in the prng
    
 Now that we use a plain cipher instead of a blkcipher, we don't need an iv
 anymore, so remove that parameter from the reset_prng_context function.  Make
 it instead with a legngth parameter, so that we can treat the key as a blob,
 rather than a string.  Also change the get_prng_bytes function to make nbytes
 a size_t, so we don't have to worry about signed math there
    
 Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

 prng.c |   11 +++++++----
 prng.h |    4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/crypto/prng.c b/crypto/prng.c
index 9e2d277..0b1831e 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -189,7 +189,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 }
 
 /* Our exported functions */
-int get_prng_bytes(char *buf, int nbytes, struct prng_context *ctx)
+int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 {
 	unsigned long flags;
 	unsigned char *ptr = buf;
@@ -284,7 +284,7 @@ struct prng_context *alloc_prng_context(void)
 
 	spin_lock_init(&ctx->prng_lock);
 
-	if (reset_prng_context(ctx, NULL, NULL, NULL, NULL)) {
+	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL)) {
 		kfree(ctx);
 		ctx = NULL;
 	}
@@ -302,7 +302,7 @@ void free_prng_context(struct prng_context *ctx)
 EXPORT_SYMBOL_GPL(free_prng_context);
 
 int reset_prng_context(struct prng_context *ctx,
-		       unsigned char *key, unsigned char *iv,
+		       unsigned char *key, size_t klen,
 		       unsigned char *V, unsigned char *DT)
 {
 	int ret;
@@ -313,6 +313,9 @@ int reset_prng_context(struct prng_context *ctx,
 
 	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
 
+	if (!key)
+		klen = DEFAULT_PRNG_KSZ;
+
 	if (V)
 		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
 	else
@@ -339,7 +342,7 @@ int reset_prng_context(struct prng_context *ctx,
 
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
-	ret = crypto_cipher_setkey(ctx->tfm, prng_key, strlen(prng_key));
+	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
 	if (ret) {
 		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
 			crypto_cipher_get_flags(ctx->tfm));
diff --git a/crypto/prng.h b/crypto/prng.h
index 1ac9be5..a6ad203 100644
--- a/crypto/prng.h
+++ b/crypto/prng.h
@@ -15,10 +15,10 @@
 #define _PRNG_H_
 struct prng_context;
 
-int get_prng_bytes(char *buf, int nbytes, struct prng_context *ctx);
+int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx);
 struct prng_context *alloc_prng_context(void);
 int reset_prng_context(struct prng_context *ctx,
-			unsigned char *key, unsigned char *iv,
+			unsigned char *key, size_t klen,
 			unsigned char *V,
 			unsigned char *DT);
 void free_prng_context(struct prng_context *ctx);
-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
