From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] prng; bring prng into better alignment with specification
Date: Wed, 16 Jul 2008 16:32:00 -0400
Message-ID: <20080716203200.GB1648@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4320 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbYGPUcS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 16:32:18 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 Bring prng into better alignment with specificaion:
    
 - Convert to using Generic AES 128 bit cipher
 - Convert DT to be a non-shifted counter, increasing counter period
    
 Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 prng.c |   69 +++++++++++++++++++----------------------------------------------
 1 file changed, 21 insertions(+), 48 deletions(-)

diff --git a/crypto/prng.c b/crypto/prng.c
index 933b4bc..9e2d277 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -1,7 +1,7 @@
 /*
  * PRNG: Pseudo Random Number Generator
  *       Based on NIST Recommended PRNG From ANSI X9.31 Appendix A.2.4 using
- *       AES 128 cipher in RFC3686 ctr mode
+ *       AES 128 cipher
  *
  *  (C) Neil Horman <nhorman@tuxdriver.com>
  *
@@ -32,10 +32,8 @@
 
 #define TEST_PRNG_ON_START 0
 
-#define DEFAULT_PRNG_KEY "0123456789abcdef1011"
-#define DEFAULT_PRNG_KSZ 20
-#define DEFAULT_PRNG_IV "defaultv"
-#define DEFAULT_PRNG_IVSZ 8
+#define DEFAULT_PRNG_KEY "0123456789abcdef"
+#define DEFAULT_PRNG_KSZ 16
 #define DEFAULT_BLK_SZ 16
 #define DEFAULT_V_SEED "zaybxcwdveuftgsh"
 
@@ -63,7 +61,7 @@ struct prng_context {
 	unsigned char I[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
 	u32 rand_data_valid;
-	struct crypto_blkcipher *tfm;
+	struct crypto_cipher *tfm;
 	u32 flags;
 };
 
@@ -100,13 +98,8 @@ static void xor_vectors(unsigned char *in1, unsigned char *in2,
 static int _get_more_prng_bytes(struct prng_context *ctx)
 {
 	int i;
-	struct blkcipher_desc desc;
-	struct scatterlist sg_in, sg_out;
-	int ret;
 	unsigned char tmp[DEFAULT_BLK_SZ];
-
-	desc.tfm = ctx->tfm;
-	desc.flags = 0;
+	unsigned char *output = NULL;
 
 
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
@@ -121,8 +114,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 	 */
 	for (i = 0; i < 3; i++) {
 
-		desc.tfm = ctx->tfm;
-		desc.flags = 0;
 		switch (i) {
 		case 0:
 			/*
@@ -130,7 +121,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 * This gives us an intermediate value I
 			 */
 			memcpy(tmp, ctx->DT, DEFAULT_BLK_SZ);
-			sg_init_one(&sg_out, &ctx->I[0], DEFAULT_BLK_SZ);
+			output = ctx->I;
 			hexdump("tmp stage 0: ", tmp, DEFAULT_BLK_SZ);
 			break;
 		case 1:
@@ -141,9 +132,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 * pseudo random data which we output
 			 */
 			xor_vectors(ctx->I, ctx->V, tmp, DEFAULT_BLK_SZ);
-			sg_init_one(&sg_out, &ctx->rand_data[0],
-					DEFAULT_BLK_SZ);
 			hexdump("tmp stage 1: ", tmp, DEFAULT_BLK_SZ);
+			output = ctx->rand_data;
 			break;
 		case 2:
 			/*
@@ -167,34 +157,25 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 */
 			xor_vectors(ctx->rand_data, ctx->I, tmp,
 				DEFAULT_BLK_SZ);
-			sg_init_one(&sg_out, &ctx->V[0], DEFAULT_BLK_SZ);
+			output = ctx->V;
 			hexdump("tmp stage 2: ", tmp, DEFAULT_BLK_SZ);
 			break;
 		}
 
-		/* Initialize our input buffer */
-		sg_init_one(&sg_in, &tmp[0], DEFAULT_BLK_SZ);
 
 		/* do the encryption */
-		ret = crypto_blkcipher_encrypt(&desc, &sg_out, &sg_in,
-			DEFAULT_BLK_SZ);
-
-		/* And check the result */
-		if (ret) {
-			dbgprint(KERN_CRIT
-				"Crypt of block failed for context %p\n", ctx);
-			ctx->rand_data_valid = DEFAULT_BLK_SZ;
-			return -EFAULT;
-		}
+		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
 
 	}
 
 	/*
 	 * Now update our DT value
 	 */
-	for (i = DEFAULT_BLK_SZ-1; i > 0; i--)
-		ctx->DT[i] = ctx->DT[i-1];
-	ctx->DT[0] += 1;
+	for (i = 0; i < DEFAULT_BLK_SZ; i++) {
+		ctx->DT[i] += 1;
+		if (ctx->DT[i] != 0)
+			break;
+	}
 
 	dbgprint("Returning new block for context %p\n", ctx);
 	ctx->rand_data_valid = 0;
@@ -315,7 +296,7 @@ EXPORT_SYMBOL_GPL(alloc_prng_context);
 
 void free_prng_context(struct prng_context *ctx)
 {
-	crypto_free_blkcipher(ctx->tfm);
+	crypto_free_cipher(ctx->tfm);
 	kfree(ctx);
 }
 EXPORT_SYMBOL_GPL(free_prng_context);
@@ -325,17 +306,13 @@ int reset_prng_context(struct prng_context *ctx,
 		       unsigned char *V, unsigned char *DT)
 {
 	int ret;
-	int iv_len;
 	int rc = -EFAULT;
 	unsigned char *prng_key;
-	unsigned char *prng_iv;
 	spin_lock(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
 
 	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
 
-	prng_iv = iv ? iv : (unsigned char *)DEFAULT_PRNG_IV;
-
 	if (V)
 		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
 	else
@@ -350,9 +327,9 @@ int reset_prng_context(struct prng_context *ctx,
 	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
 
 	if (ctx->tfm)
-		crypto_free_blkcipher(ctx->tfm);
+		crypto_free_cipher(ctx->tfm);
 
-	ctx->tfm = crypto_alloc_blkcipher("rfc3686(ctr(aes))", 0, 0);
+	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(ctx->tfm)) {
 		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
 			ctx);
@@ -362,18 +339,14 @@ int reset_prng_context(struct prng_context *ctx,
 
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
-	ret = crypto_blkcipher_setkey(ctx->tfm, prng_key, strlen(prng_key));
+	ret = crypto_cipher_setkey(ctx->tfm, prng_key, strlen(prng_key));
 	if (ret) {
 		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
-			crypto_blkcipher_get_flags(ctx->tfm));
-		crypto_free_blkcipher(ctx->tfm);
+			crypto_cipher_get_flags(ctx->tfm));
+		crypto_free_cipher(ctx->tfm);
 		goto out;
 	}
 
-	iv_len = crypto_blkcipher_ivsize(ctx->tfm);
-	if (iv_len)
-		crypto_blkcipher_set_iv(ctx->tfm, prng_iv, iv_len);
