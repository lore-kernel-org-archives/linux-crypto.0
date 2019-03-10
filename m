Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749E8C4360F
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383E32087F
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244532;
	bh=6kaJyQWw1ILUo6k5YZBkrOOiE95UHplBDyZHbnO52tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XC5Ds2//WG7r+lIjvmO7wnbZ/O3KKKmG23lMDLi4da/buPFFAyTi/8W0Eq+LkQlzB
	 oO9i4hs5p7d2M+NIyNgrO5Vs+lCDd8iSEswU3uqDevsq0J3HJGK3cZAVwmOYKMXPoW
	 MWTHFlr/KCG8fUV0aFrZmoovjj8VudJefjItpvmU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfCJTCL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfCJTCK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:10 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66DBA207E0;
        Sun, 10 Mar 2019 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244529;
        bh=6kaJyQWw1ILUo6k5YZBkrOOiE95UHplBDyZHbnO52tU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjIKMAxeG1n/XVVQUnDO7cm4JqHwSZ8bD+W+TfApu0fkcYMs2cgIucMw5LF0BZCRe
         EsW7hC84xy+QDzgHD5zgoX9STklKiegD8h2RShS6+W0m4pxHCz+qQlBevFBFoGhvYt
         tTgQcYn0/EHebWEITjV2SPlPxFO15ZkuRi0CyeLo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 1/9] crypto: simd - support wrapping AEAD algorithms
Date:   Sun, 10 Mar 2019 12:00:50 -0700
Message-Id: <20190310190058.4912-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
References: <20190310190058.4912-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update the crypto_simd module to support wrapping AEAD algorithms.
Previously it only supported skciphers.  The code for each is similar.

I'll be converting the x86 implementations of AES-GCM, AEGIS, and MORUS
to use this.  Currently they each independently implement the same
functionality.  This will not only simplify the code, but it will also
fix the bug detected by the improved self-tests: the user-provided
aead_request is modified.  This is because these algorithms currently
reuse the original request, whereas the crypto_simd helpers build a new
request in the original request's context.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/simd.c                  | 269 +++++++++++++++++++++++++++++++++
 include/crypto/internal/simd.h |  20 +++
 2 files changed, 289 insertions(+)

diff --git a/crypto/simd.c b/crypto/simd.c
index 78e8d037ae2b..7d62686d3a3f 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  * Copyright (c) 2016 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2019 Google LLC
  *
  * Based on aesni-intel_glue.c by:
  *  Copyright (C) 2008, Intel Corp.
@@ -20,10 +21,26 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+/*
+ * Shared crypto SIMD helpers.  These functions dynamically create and register
+ * an skcipher or AEAD algorithm that wraps another, internal algorithm.  The
+ * wrapper ensures that the internal algorithm is only executed in a context
+ * where SIMD instructions are usable, i.e. where may_use_simd() returns true.
+ * If SIMD is already usable, the wrapper directly calls the internal algorithm.
+ * Otherwise it defers execution to a workqueue via cryptd.
  *
+ * This is an alternative to the internal algorithm implementing a fallback for
+ * the !may_use_simd() case itself.
+ *
+ * Note that the wrapper algorithm is asynchronous, i.e. it has the
+ * CRYPTO_ALG_ASYNC flag set.  Therefore it won't be found by users who
+ * explicitly allocate a synchronous algorithm.
  */
 
 #include <crypto/cryptd.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
@@ -31,6 +48,8 @@
 #include <linux/preempt.h>
 #include <asm/simd.h>
 
+/* skcipher support */
+
 struct simd_skcipher_alg {
 	const char *ialg_name;
 	struct skcipher_alg alg;
@@ -272,4 +291,254 @@ void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
 }
 EXPORT_SYMBOL_GPL(simd_unregister_skciphers);
 
+/* AEAD support */
+
+struct simd_aead_alg {
+	const char *ialg_name;
+	struct aead_alg alg;
+};
+
+struct simd_aead_ctx {
+	struct cryptd_aead *cryptd_tfm;
+};
+
+static int simd_aead_setkey(struct crypto_aead *tfm, const u8 *key,
+				unsigned int key_len)
+{
+	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct crypto_aead *child = &ctx->cryptd_tfm->base;
+	int err;
+
+	crypto_aead_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_aead_set_flags(child, crypto_aead_get_flags(tfm) &
+				     CRYPTO_TFM_REQ_MASK);
+	err = crypto_aead_setkey(child, key, key_len);
+	crypto_aead_set_flags(tfm, crypto_aead_get_flags(child) &
+				   CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int simd_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct crypto_aead *child = &ctx->cryptd_tfm->base;
+
+	return crypto_aead_setauthsize(child, authsize);
+}
+
+static int simd_aead_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_request *subreq;
+	struct crypto_aead *child;
+
+	subreq = aead_request_ctx(req);
+	*subreq = *req;
+
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
+		child = &ctx->cryptd_tfm->base;
+	else
+		child = cryptd_aead_child(ctx->cryptd_tfm);
+
+	aead_request_set_tfm(subreq, child);
+
+	return crypto_aead_encrypt(subreq);
+}
+
+static int simd_aead_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct aead_request *subreq;
+	struct crypto_aead *child;
+
+	subreq = aead_request_ctx(req);
+	*subreq = *req;
+
+	if (!may_use_simd() ||
+	    (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
+		child = &ctx->cryptd_tfm->base;
+	else
+		child = cryptd_aead_child(ctx->cryptd_tfm);
+
+	aead_request_set_tfm(subreq, child);
+
+	return crypto_aead_decrypt(subreq);
+}
+
+static void simd_aead_exit(struct crypto_aead *tfm)
+{
+	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	cryptd_free_aead(ctx->cryptd_tfm);
+}
+
+static int simd_aead_init(struct crypto_aead *tfm)
+{
+	struct simd_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cryptd_aead *cryptd_tfm;
+	struct simd_aead_alg *salg;
+	struct aead_alg *alg;
+	unsigned reqsize;
+
+	alg = crypto_aead_alg(tfm);
+	salg = container_of(alg, struct simd_aead_alg, alg);
+
+	cryptd_tfm = cryptd_alloc_aead(salg->ialg_name, CRYPTO_ALG_INTERNAL,
+				       CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+
+	ctx->cryptd_tfm = cryptd_tfm;
+
+	reqsize = crypto_aead_reqsize(cryptd_aead_child(cryptd_tfm));
+	reqsize = max(reqsize, crypto_aead_reqsize(&cryptd_tfm->base));
+	reqsize += sizeof(struct aead_request);
+
+	crypto_aead_set_reqsize(tfm, reqsize);
+
+	return 0;
+}
+
+struct simd_aead_alg *simd_aead_create_compat(const char *algname,
+					      const char *drvname,
+					      const char *basename)
+{
+	struct simd_aead_alg *salg;
+	struct crypto_aead *tfm;
+	struct aead_alg *ialg;
+	struct aead_alg *alg;
+	int err;
+
+	tfm = crypto_alloc_aead(basename, CRYPTO_ALG_INTERNAL,
+				CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+
+	ialg = crypto_aead_alg(tfm);
+
+	salg = kzalloc(sizeof(*salg), GFP_KERNEL);
+	if (!salg) {
+		salg = ERR_PTR(-ENOMEM);
+		goto out_put_tfm;
+	}
+
+	salg->ialg_name = basename;
+	alg = &salg->alg;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", algname) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto out_free_salg;
+
+	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		     drvname) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_salg;
+
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_priority = ialg->base.cra_priority;
+	alg->base.cra_blocksize = ialg->base.cra_blocksize;
+	alg->base.cra_alignmask = ialg->base.cra_alignmask;
+	alg->base.cra_module = ialg->base.cra_module;
+	alg->base.cra_ctxsize = sizeof(struct simd_aead_ctx);
+
+	alg->ivsize = ialg->ivsize;
+	alg->maxauthsize = ialg->maxauthsize;
+	alg->chunksize = ialg->chunksize;
+
+	alg->init = simd_aead_init;
+	alg->exit = simd_aead_exit;
+
+	alg->setkey = simd_aead_setkey;
+	alg->setauthsize = simd_aead_setauthsize;
+	alg->encrypt = simd_aead_encrypt;
+	alg->decrypt = simd_aead_decrypt;
+
+	err = crypto_register_aead(alg);
+	if (err)
+		goto out_free_salg;
+
+out_put_tfm:
+	crypto_free_aead(tfm);
+	return salg;
+
+out_free_salg:
+	kfree(salg);
+	salg = ERR_PTR(err);
+	goto out_put_tfm;
+}
+EXPORT_SYMBOL_GPL(simd_aead_create_compat);
+
+struct simd_aead_alg *simd_aead_create(const char *algname,
+				       const char *basename)
+{
+	char drvname[CRYPTO_MAX_ALG_NAME];
+
+	if (snprintf(drvname, CRYPTO_MAX_ALG_NAME, "simd-%s", basename) >=
+	    CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	return simd_aead_create_compat(algname, drvname, basename);
+}
+EXPORT_SYMBOL_GPL(simd_aead_create);
+
+void simd_aead_free(struct simd_aead_alg *salg)
+{
+	crypto_unregister_aead(&salg->alg);
+	kfree(salg);
+}
+EXPORT_SYMBOL_GPL(simd_aead_free);
+
+int simd_register_aeads_compat(struct aead_alg *algs, int count,
+			       struct simd_aead_alg **simd_algs)
+{
+	int err;
+	int i;
+	const char *algname;
+	const char *drvname;
+	const char *basename;
+	struct simd_aead_alg *simd;
+
+	err = crypto_register_aeads(algs, count);
+	if (err)
+		return err;
+
+	for (i = 0; i < count; i++) {
+		WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
+		WARN_ON(strncmp(algs[i].base.cra_driver_name, "__", 2));
+		algname = algs[i].base.cra_name + 2;
+		drvname = algs[i].base.cra_driver_name + 2;
+		basename = algs[i].base.cra_driver_name;
+		simd = simd_aead_create_compat(algname, drvname, basename);
+		err = PTR_ERR(simd);
+		if (IS_ERR(simd))
+			goto err_unregister;
+		simd_algs[i] = simd;
+	}
+	return 0;
+
+err_unregister:
+	simd_unregister_aeads(algs, count, simd_algs);
+	return err;
+}
+EXPORT_SYMBOL_GPL(simd_register_aeads_compat);
+
+void simd_unregister_aeads(struct aead_alg *algs, int count,
+			   struct simd_aead_alg **simd_algs)
+{
+	int i;
+
+	crypto_unregister_aeads(algs, count);
+
+	for (i = 0; i < count; i++) {
+		if (simd_algs[i]) {
+			simd_aead_free(simd_algs[i]);
+			simd_algs[i] = NULL;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(simd_unregister_aeads);
+
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index f18344518e32..a23b18b6ad61 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -6,6 +6,8 @@
 #ifndef _CRYPTO_INTERNAL_SIMD_H
 #define _CRYPTO_INTERNAL_SIMD_H
 
+/* skcipher support */
+
 struct simd_skcipher_alg;
 struct skcipher_alg;
 
@@ -22,4 +24,22 @@ int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
 void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
 			       struct simd_skcipher_alg **simd_algs);
 
+/* AEAD support */
+
+struct simd_aead_alg;
+struct aead_alg;
+
+struct simd_aead_alg *simd_aead_create_compat(const char *algname,
+					      const char *drvname,
+					      const char *basename);
+struct simd_aead_alg *simd_aead_create(const char *algname,
+				       const char *basename);
+void simd_aead_free(struct simd_aead_alg *alg);
+
+int simd_register_aeads_compat(struct aead_alg *algs, int count,
+			       struct simd_aead_alg **simd_algs);
+
+void simd_unregister_aeads(struct aead_alg *algs, int count,
+			   struct simd_aead_alg **simd_algs);
+
 #endif /* _CRYPTO_INTERNAL_SIMD_H */
-- 
2.21.0

