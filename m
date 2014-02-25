From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH v2 1/3] crypto: update generic ECB's driver_name to 'ecb_generic'
Date: Tue, 25 Feb 2014 08:34:18 +0100
Message-ID: <1393313660-5258-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:62799 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBYHe1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:34:27 -0500
Received: by mail-we0-f175.google.com with SMTP id q59so16612wes.6
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2014 23:34:26 -0800 (PST)
In-Reply-To: <1393313660-5258-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As ECB could potentially be wrapped by other chaining modes to operate on
larger chunks of data in parallel, we would like to distinguish between the
generic ECB and accelerated implementations of ECB, as using the former will
not result in any speedup.

Therefore, update the driver name of generic ECB to 'ecb_generic(%s)'.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ecb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index 935cfef4aa84..46a6a61fbcb9 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -134,6 +134,12 @@ static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "ecb_generic(%s)", alg->cra_driver_name)
+	    >= CRYPTO_MAX_ALG_NAME)
+		goto out_err;
+
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = alg->cra_blocksize;
@@ -155,6 +161,12 @@ static struct crypto_instance *crypto_ecb_alloc(struct rtattr **tb)
 out_put_alg:
 	crypto_mod_put(alg);
 	return inst;
+
+out_err:
+	crypto_drop_spawn(crypto_instance_ctx(inst));
+	kfree(inst);
+	crypto_mod_put(alg);
+	return ERR_PTR(err);
 }
 
 static void crypto_ecb_free(struct crypto_instance *inst)
-- 
1.8.3.2
