From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH] crypto: vmx - Use skcipher for ctr fallback
Date: Mon, 16 Oct 2017 20:54:19 -0200
Message-ID: <20171016225420.31081-1-pfsmorigo@linux.vnet.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756179AbdJPWzM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2017 18:55:12 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9GMsIHI069471
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2017 18:55:11 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dn430v0qy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2017 18:55:11 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Mon, 16 Oct 2017 16:55:11 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_ctr.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

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
2.9.4
