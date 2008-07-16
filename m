From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] prng: fix a few misc bugs in prng
Date: Wed, 16 Jul 2008 16:29:16 -0400
Message-ID: <20080716202916.GA1648@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4281 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbYGPU3c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 16:29:32 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


 Fixing a few misc bugs in prng.c:
 - Remove prng_key/prng_iv from prng_context (both kept in tfm ptr)
 - Making _get_more_prng_bytes return meaningful err codes (not just -1/0)
    
 Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 crypto/prng.c     |   26 +++++++++-----------------
 firmware/Makefile |    4 ++--
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/crypto/prng.c b/crypto/prng.c
index 7aeb0d0..933b4bc 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -56,8 +56,6 @@
 
 
 struct prng_context {
-	char *prng_key;
-	char *prng_iv;
 	spinlock_t prng_lock;
 	unsigned char rand_data[DEFAULT_BLK_SZ];
 	unsigned char last_rand_data[DEFAULT_BLK_SZ];
@@ -158,7 +156,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 					"ctx %p Failed repetition check!\n",
 					ctx);
 				ctx->flags |= PRNG_NEED_RESET;
-				return -1;
+				return -EFAULT;
 			}
 			memcpy(ctx->last_rand_data, ctx->rand_data,
 				DEFAULT_BLK_SZ);
@@ -186,7 +184,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			dbgprint(KERN_CRIT
 				"Crypt of block failed for context %p\n", ctx);
 			ctx->rand_data_valid = DEFAULT_BLK_SZ;
-			return -1;
+			return -EFAULT;
 		}
 
 	}
@@ -273,7 +271,7 @@ remainder:
 	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= DEFAULT_BLK_SZ) {
 		if (_get_more_prng_bytes(ctx) < 0) {
 			memset(buf, 0, nbytes);
-			err = -1;
+			err = -EFAULT;
 			goto done;
 		}
 		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
@@ -329,19 +327,14 @@ int reset_prng_context(struct prng_context *ctx,
 	int ret;
 	int iv_len;
 	int rc = -EFAULT;
-
+	unsigned char *prng_key;
+	unsigned char *prng_iv;
 	spin_lock(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
 
-	if (key)
-		memcpy(ctx->prng_key, key, strlen(ctx->prng_key));
-	else
-		ctx->prng_key = DEFAULT_PRNG_KEY;
+	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
 
-	if (iv)
-		memcpy(ctx->prng_iv, iv, strlen(ctx->prng_iv));
-	else
-		ctx->prng_iv = DEFAULT_PRNG_IV;
+	prng_iv = iv ? iv : (unsigned char *)DEFAULT_PRNG_IV;
 
 	if (V)
 		memcpy(ctx->V, V, DEFAULT_BLK_SZ);
@@ -369,8 +362,7 @@ int reset_prng_context(struct prng_context *ctx,
 
 	ctx->rand_data_valid = DEFAULT_BLK_SZ;
 
-	ret = crypto_blkcipher_setkey(ctx->tfm, ctx->prng_key,
-					strlen(ctx->prng_key));
+	ret = crypto_blkcipher_setkey(ctx->tfm, prng_key, strlen(prng_key));
 	if (ret) {
 		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
 			crypto_blkcipher_get_flags(ctx->tfm));
@@ -380,7 +372,7 @@ int reset_prng_context(struct prng_context *ctx,
 
 	iv_len = crypto_blkcipher_ivsize(ctx->tfm);
 	if (iv_len)
-		crypto_blkcipher_set_iv(ctx->tfm, ctx->prng_iv, iv_len);
+		crypto_blkcipher_set_iv(ctx->tfm, prng_iv, iv_len);
 
 	rc = 0;
 	ctx->flags &= ~PRNG_NEED_RESET;
diff --git a/firmware/Makefile b/firmware/Makefile
index 809a526..3515814 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -34,8 +34,8 @@ fw-shipped-$(CONFIG_SND_SB16_CSP) += sb16/mulaw_main.csp sb16/alaw_main.csp \
 				     sb16/ima_adpcm_capture.csp
 fw-shipped-$(CONFIG_SND_YMFPCI) += yamaha/ds1_ctrl.fw yamaha/ds1_dsp.fw \
 				   yamaha/ds1e_ctrl.fw
-fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
-			       tigon/tg3_tso5.bin
+#fw-shipped-$(CONFIG_TIGON3) += tigon/tg3.bin tigon/tg3_tso.bin \
+#			       tigon/tg3_tso5.bin
 fw-shipped-$(CONFIG_USB_DABUSB) += dabusb/firmware.fw dabusb/bitstream.bin
 fw-shipped-$(CONFIG_USB_EMI26) += emi26/loader.fw emi26/firmware.fw \
 				  emi26/bitstream.fw
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
