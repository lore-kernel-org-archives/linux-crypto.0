Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEC850A8F
	for <linux-crypto@vger.kernel.org>; Mon, 20 May 2024 11:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716203094; cv=none; b=h0yjBGgwqen59pwqeqqp+fykJa+JO4FGGXhEgBHirGBlhxd1fKVF3DFcOPmSLrvNE1pKo13u+n5JgjtFKhPiPPsWQw6y64Bkb9Q8N1l/9fI/C1uEbDWzjqpiJLlu/4YqF7iYeGpwxwizwSEZ/FKnMtq8RtMw/dSfv8DOjGDDGLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716203094; c=relaxed/simple;
	bh=PTdhYdlvhRxluslxSWa6oRHsI2RkmrKqkg/0lxKXVOE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=B/CIP+Q+ey8zPm0WajZlreAiSGqgogiEEfLo3IrDxqZqVerkF+lmvIf3UCzSM9DNH66QZUwBzgP9UMyGB5T6epsIIl7nqiuwq1pO5lVz3iOJe2qK9Ry974FJj/wAXWTVcEUf7YYKOAkrZzQA6i/OAG6dI35to+5qM3En6BQygQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s90ox-0000vo-03;
	Mon, 20 May 2024 19:04:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 May 2024 19:04:48 +0800
Date: Mon, 20 May 2024 19:04:48 +0800
Message-Id: <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1716202860.git.herbert@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: acomp - Add setparam interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add the acompress plubming for setparam.  This is modelled after
setkey for ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 70 ++++++++++++++++++++++++++---
 crypto/compress.h                   |  9 +++-
 crypto/scompress.c                  |  9 +---
 include/crypto/acompress.h          | 32 ++++++++++++-
 include/crypto/internal/acompress.h |  3 ++
 5 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6fdf0ff9f3c0..cf37243a2a3c 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -33,6 +33,55 @@ static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
 	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
 }
 
+static int acomp_no_setparam(struct crypto_acomp *tfm, const u8 *param,
+			    unsigned int len)
+{
+	return -ENOSYS;
+}
+
+static int acomp_set_need_param(struct crypto_acomp *tfm,
+				 struct acomp_alg *alg)
+{
+	if (alg->calg.base.cra_type != &crypto_acomp_type) {
+		struct crypto_scomp **ctx = acomp_tfm_ctx(tfm);
+		struct crypto_scomp *scomp = *ctx;
+
+		if (!crypto_scomp_alg_has_setparam(crypto_scomp_alg(scomp)))
+			return 0;
+	} else if (alg->setparam == acomp_no_setparam)
+		return 0;
+
+	if ((alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+		crypto_acomp_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+
+	return 0;
+}
+
+int crypto_acomp_setparam(struct crypto_acomp *tfm, const u8 *param,
+			  unsigned int len)
+{
+	struct acomp_alg *alg = crypto_acomp_alg(tfm);
+	int err;
+
+	if (alg->calg.base.cra_type == &crypto_acomp_type)
+		err = alg->setparam(tfm, param, len);
+	else {
+		struct crypto_scomp **ctx = acomp_tfm_ctx(tfm);
+		struct crypto_scomp *scomp = *ctx;
+
+		err = crypto_scomp_setparam(scomp, param, len);
+	}
+
+	if (unlikely(err)) {
+		acomp_set_need_param(tfm, alg);
+		return err;
+	}
+
+	crypto_acomp_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_setparam);
+
 static int __maybe_unused crypto_acomp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -66,8 +115,9 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_acomp *acomp = __crypto_acomp_tfm(tfm);
 	struct acomp_alg *alg = crypto_acomp_alg(acomp);
 
-	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
-		return crypto_init_scomp_ops_async(tfm);
+	if (alg->calg.base.cra_type != &crypto_acomp_type)
+		return crypto_init_scomp_ops_async(tfm) ?:
+		       acomp_set_need_param(acomp, alg);
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
@@ -77,10 +127,8 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	if (alg->exit)
 		acomp->base.exit = crypto_acomp_exit_tfm;
 
-	if (alg->init)
-		return alg->init(acomp);
-
-	return 0;
+	return (alg->init ? alg->init(acomp) : 0) ?:
+	       acomp_set_need_param(acomp, alg);
 }
 
 static unsigned int crypto_acomp_extsize(struct crypto_alg *alg)
@@ -160,11 +208,19 @@ void comp_prepare_alg(struct comp_alg_common *alg)
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 }
 
+static void acomp_prepare_alg(struct acomp_alg *alg)
+{
+	comp_prepare_alg(&alg->calg);
+
+	if (!alg->setparam)
+		alg->setparam = acomp_no_setparam;
+}
+
 int crypto_register_acomp(struct acomp_alg *alg)
 {
 	struct crypto_alg *base = &alg->calg.base;
 
-	comp_prepare_alg(&alg->calg);
+	acomp_prepare_alg(alg);
 
 	base->cra_type = &crypto_acomp_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_ACOMPRESS;
diff --git a/crypto/compress.h b/crypto/compress.h
index c3cedfb5e606..aac8c24be688 100644
--- a/crypto/compress.h
+++ b/crypto/compress.h
@@ -9,15 +9,22 @@
 #ifndef _LOCAL_CRYPTO_COMPRESS_H
 #define _LOCAL_CRYPTO_COMPRESS_H
 
+#include <crypto/internal/scompress.h>
 #include "internal.h"
 
 struct acomp_req;
-struct comp_alg_common;
 
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
 struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
 void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
+int scomp_no_setparam(struct crypto_scomp *tfm, const u8 *param,
+		      unsigned int len);
 
 void comp_prepare_alg(struct comp_alg_common *alg);
 
+static inline bool crypto_scomp_alg_has_setparam(struct scomp_alg *alg)
+{
+	return alg->setparam != scomp_no_setparam;
+}
+
 #endif	/* _LOCAL_CRYPTO_COMPRESS_H */
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 283fbea8336e..9117d7c85f31 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -42,17 +42,12 @@ static inline struct crypto_scomp *__crypto_scomp_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_scomp, base);
 }
 
-static int scomp_no_setparam(struct crypto_scomp *tfm, const u8 *param,
-			     unsigned int len)
+int scomp_no_setparam(struct crypto_scomp *tfm, const u8 *param,
+		      unsigned int len)
 {
 	return -ENOSYS;
 }
 
-static bool crypto_scomp_alg_has_setparam(struct scomp_alg *alg)
-{
-	return alg->setparam != scomp_no_setparam;
-}
-
 static bool crypto_scomp_alg_needs_param(struct scomp_alg *alg)
 {
 	return crypto_scomp_alg_has_setparam(alg) &&
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 54937b615239..241d1dc5c883 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -125,6 +125,21 @@ static inline struct comp_alg_common *crypto_comp_alg_common(
 	return __crypto_comp_alg_common(crypto_acomp_tfm(tfm)->__crt_alg);
 }
 
+static inline u32 crypto_acomp_get_flags(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_get_flags(crypto_acomp_tfm(tfm));
+}
+
+static inline void crypto_acomp_set_flags(struct crypto_acomp *tfm, u32 flags)
+{
+	crypto_tfm_set_flags(crypto_acomp_tfm(tfm), flags);
+}
+
+static inline void crypto_acomp_clear_flags(struct crypto_acomp *tfm, u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_acomp_tfm(tfm), flags);
+}
+
 static inline unsigned int crypto_acomp_reqsize(struct crypto_acomp *tfm)
 {
 	return tfm->reqsize;
@@ -248,7 +263,12 @@ static inline void acomp_request_set_params(struct acomp_req *req,
  */
 static inline int crypto_acomp_compress(struct acomp_req *req)
 {
-	return crypto_acomp_reqtfm(req)->compress(req);
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	if (crypto_acomp_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
+	return tfm->compress(req);
 }
 
 /**
@@ -262,7 +282,15 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
  */
 static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
-	return crypto_acomp_reqtfm(req)->decompress(req);
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	if (crypto_acomp_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
+	return tfm->decompress(req);
 }
 
+int crypto_acomp_setparam(struct crypto_acomp *tfm,
+			  const u8 *param, unsigned int len);
+
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index d00392d1988e..91c51526aac0 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -17,6 +17,7 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @setparam:	Set parameters of the algorithm (e.g., compression level)
  * @dst_free:	Frees destination buffer if allocated inside the algorithm
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -37,6 +38,8 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	int (*setparam)(struct crypto_acomp *tfm, const u8 *param,
+			unsigned int len);
 	void (*dst_free)(struct scatterlist *dst);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
-- 
2.39.2

