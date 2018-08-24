From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Backport e666d4e9ceec crypto: vmx - Use skcipher for ctr fallback
Date: Fri, 24 Aug 2018 10:06:16 +0800
Message-ID: <20180824020616.xfmfudk5aaejwm4j@gondor.apana.org.au>
References: <20180823153101.GA27143@dell5510>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Petr Vorel <pvorel@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180823153101.GA27143@dell5510>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 23, 2018 at 05:31:01PM +0200, Petr Vorel wrote:
> Hi,
> 
> I wonder, it it makes sense to backport commit
> e666d4e9ceec crypto: vmx - Use skcipher for ctr fallback
> to v 4.14 stable kernel.
> I'm using it in 4.12+.
> 
> These commits (somehow similar) has been backported to 4.10.2:
> 5839f555fa57 crypto: vmx - Use skcipher for xts fallback
> c96d0a1c47ab crypto: vmx - Use skcipher for cbc fallback

I think so.  Here is the patch which should be applied for all
kernels since 4.10 up to and including 4.14:

commit e666d4e9ceec94c0a88c94b7db31d56474da43b3
Author: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Date:   Mon Oct 16 20:54:19 2017 -0200

    crypto: vmx - Use skcipher for ctr fallback
    
    Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 17d8421..fc60d00 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -27,21 +27,23 @@
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
+
 #include "aesp8-ppc.h"
 
 struct p8_aes_ctr_ctx {
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 	struct aes_key enc_key;
 };
 
 static int p8_aes_ctr_init(struct crypto_tfm *tfm)
 {
 	const char *alg = crypto_tfm_alg_name(tfm);
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 	struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	fallback =
-	    crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	fallback = crypto_alloc_skcipher(alg, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
 		       "Failed to allocate transformation for '%s': %ld\n",
@@ -49,11 +51,11 @@ static int p8_aes_ctr_init(struct crypto_tfm *tfm)
 		return PTR_ERR(fallback);
 	}
 	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
-	       crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
+		crypto_skcipher_driver_name(fallback));
 
-	crypto_blkcipher_set_flags(
+	crypto_skcipher_set_flags(
 		fallback,
-		crypto_blkcipher_get_flags((struct crypto_blkcipher *)tfm));
+		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
 	ctx->fallback = fallback;
 
 	return 0;
@@ -64,7 +66,7 @@ static void p8_aes_ctr_exit(struct crypto_tfm *tfm)
 	struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback) {
-		crypto_free_blkcipher(ctx->fallback);
+		crypto_free_skcipher(ctx->fallback);
 		ctx->fallback = NULL;
 	}
 }
@@ -83,7 +85,7 @@ static int p8_aes_ctr_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_blkcipher_setkey(ctx->fallback, key, keylen);
+	ret += crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
 }
 
@@ -117,15 +119,14 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	struct p8_aes_ctr_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
-	struct blkcipher_desc fallback_desc = {
-		.tfm = ctx->fallback,
-		.info = desc->info,
-		.flags = desc->flags
-	};
 
 	if (in_interrupt()) {
-		ret = crypto_blkcipher_encrypt(&fallback_desc, dst, src,
-					       nbytes);
+		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_tfm(req, ctx->fallback);
+		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
+		ret = crypto_skcipher_encrypt(req);
+		skcipher_request_zero(req);
 	} else {
 		blkcipher_walk_init(&walk, dst, src, nbytes);
 		ret = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
