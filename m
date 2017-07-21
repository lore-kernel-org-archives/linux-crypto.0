From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 3/3] crypto: scompress - defer allocation of scratch buffer to first use
Date: Fri, 21 Jul 2017 16:42:38 +0100
Message-ID: <20170721154238.21697-4-ard.biesheuvel@linaro.org>
References: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        giovanni.cabiddu@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38698 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdGUPnD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 11:43:03 -0400
Received: by mail-wm0-f52.google.com with SMTP id w191so17404304wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 08:43:02 -0700 (PDT)
In-Reply-To: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The scompress code allocates 2 x 128 KB of scratch buffers for each CPU,
so that clients of the async API can use synchronous implementations
even from atomic context. However, on systems such as Cavium Thunderx
(which has 96 cores), this adds up to a non-negligible 24 MB. Also,
32-bit systems may prefer to use their precious vmalloc space for other
things,especially since there don't appear to be any clients for the
async compression API yet.

So let's defer allocation of the scratch buffers until the first time
we allocate an acompress cipher based on an scompress implementation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/scompress.c | 46 ++++++++------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 2c07648305ad..2075e2c4e7df 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -65,11 +65,6 @@ static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_puts(m, "type         : scomp\n");
 }
 
-static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
 static void crypto_scomp_free_scratches(void * __percpu *scratches)
 {
 	int i;
@@ -134,6 +129,17 @@ static int crypto_scomp_alloc_all_scratches(void)
 	return 0;
 }
 
+static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
+{
+	int ret;
+
+	mutex_lock(&scomp_lock);
+	ret = crypto_scomp_alloc_all_scratches();
+	mutex_unlock(&scomp_lock);
+
+	return ret;
+}
+
 static void crypto_scomp_sg_free(struct scatterlist *sgl)
 {
 	int i, n;
@@ -241,6 +247,10 @@ static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
 	struct crypto_scomp **ctx = crypto_tfm_ctx(tfm);
 
 	crypto_free_scomp(*ctx);
+
+	mutex_lock(&scomp_lock);
+	crypto_scomp_free_all_scratches();
+	mutex_unlock(&scomp_lock);
 }
 
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
@@ -317,40 +327,18 @@ static const struct crypto_type crypto_scomp_type = {
 int crypto_register_scomp(struct scomp_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
-	int ret = -ENOMEM;
-
-	mutex_lock(&scomp_lock);
-	if (crypto_scomp_alloc_all_scratches())
-		goto error;
 
 	base->cra_type = &crypto_scomp_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
 
-	ret = crypto_register_alg(base);
-	if (ret)
-		goto error;
-
-	mutex_unlock(&scomp_lock);
-	return ret;
-
-error:
-	crypto_scomp_free_all_scratches();
-	mutex_unlock(&scomp_lock);
-	return ret;
+	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_scomp);
 
 int crypto_unregister_scomp(struct scomp_alg *alg)
 {
-	int ret;
-
-	mutex_lock(&scomp_lock);
-	ret = crypto_unregister_alg(&alg->base);
-	crypto_scomp_free_all_scratches();
-	mutex_unlock(&scomp_lock);
-
-	return ret;
+	return crypto_unregister_alg(&alg->base);
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
 
-- 
2.11.0
