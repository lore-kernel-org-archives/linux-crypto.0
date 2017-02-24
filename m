From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] crypto: vmx - Use skcipher for xts fallback
Date: Fri, 24 Feb 2017 11:27:34 -0300
Message-ID: <20170224142734.16188-1-pfsmorigo@linux.vnet.ibm.com>
References: <20170222192004.GC20626@gallifrey>
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751298AbdBXO2X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 09:28:23 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1OEOiRa098959
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 09:28:22 -0500
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28teq1ube1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 09:28:22 -0500
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Fri, 24 Feb 2017 11:28:20 -0300
In-Reply-To: <20170222192004.GC20626@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_xts.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index 24353ec3..a1e653a 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -28,11 +28,12 @@
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
+#include <crypto/skcipher.h>
 
 #include "aesp8-ppc.h"
 
 struct p8_aes_xts_ctx {
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 	struct aes_key enc_key;
 	struct aes_key dec_key;
 	struct aes_key tweak_key;
@@ -41,7 +42,7 @@ struct p8_aes_xts_ctx {
 static int p8_aes_xts_init(struct crypto_tfm *tfm)
 {
 	const char *alg;
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 	struct p8_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!(alg = crypto_tfm_alg_name(tfm))) {
@@ -49,8 +50,8 @@ static int p8_aes_xts_init(struct crypto_tfm *tfm)
 		return -ENOENT;
 	}
 
-	fallback =
-		crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	fallback = crypto_alloc_skcipher(alg, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
 			"Failed to allocate transformation for '%s': %ld\n",
@@ -60,9 +61,9 @@ static int p8_aes_xts_init(struct crypto_tfm *tfm)
 	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
 		crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
 
-	crypto_blkcipher_set_flags(
+	crypto_skcipher_set_flags(
 		fallback,
-		crypto_blkcipher_get_flags((struct crypto_blkcipher *)tfm));
+		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
 	ctx->fallback = fallback;
 
 	return 0;
@@ -73,7 +74,7 @@ static void p8_aes_xts_exit(struct crypto_tfm *tfm)
 	struct p8_aes_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback) {
-		crypto_free_blkcipher(ctx->fallback);
+		crypto_free_skcipher(ctx->fallback);
 		ctx->fallback = NULL;
 	}
 }
@@ -98,7 +99,7 @@ static int p8_aes_xts_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_blkcipher_setkey(ctx->fallback, key, keylen);
+	ret += crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
 }
 
@@ -113,15 +114,14 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	struct p8_aes_xts_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
-	struct blkcipher_desc fallback_desc = {
-		.tfm = ctx->fallback,
-		.info = desc->info,
-		.flags = desc->flags
-	};
 
 	if (in_interrupt()) {
-		ret = enc ? crypto_blkcipher_encrypt(&fallback_desc, dst, src, nbytes) :
-                            crypto_blkcipher_decrypt(&fallback_desc, dst, src, nbytes);
+		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_tfm(req, ctx->fallback);
+		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
+		ret = enc? crypto_skcipher_encrypt(req) : crypto_skcipher_decrypt(req);
+		skcipher_request_zero(req);
 	} else {
 		preempt_disable();
 		pagefault_disable();
-- 
2.7.4
