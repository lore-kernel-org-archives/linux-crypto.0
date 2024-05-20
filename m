Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F66537F6
	for <linux-crypto@vger.kernel.org>; Mon, 20 May 2024 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716203092; cv=none; b=gdX1jCOmlSLgjFaVtqaLzq+Pd4ICs8rUuU1wosArfDas+lp8sUnO59elHRD3RwPhy4daY5zp6RDczI1kX9F4CWwHU21bLAOUv+RveI/sxEYH7kIZohjPRGGVBgvrAZ8Sl7cXaIeeI2jYGODQhbVeLRV70S43pg82patDid1Rbf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716203092; c=relaxed/simple;
	bh=T4qrbz9HkFKvgxuBa/98Xc7yFY+z7ws17yNJkw6I/fg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Vdxs7rKgIgm+k0ZYDY3wM4H3bdYYuPZwHcpkiMgARGg0Gvf8KCX78Fz1M9b/PgIrGBFvm0GxDNjKSy1HdBdUtBxZ/QYwntaLFcI8DmqLOHF9EJkWT3p052aH96F7aD+5d7izSwJ4sqQ/idxX2GXxbpxlBfWVaemNNFymyYjm+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s90ou-0000vd-2I;
	Mon, 20 May 2024 19:04:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 May 2024 19:04:46 +0800
Date: Mon, 20 May 2024 19:04:46 +0800
Message-Id: <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1716202860.git.herbert@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: scomp - Add setparam interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add the scompress plumbing for setparam.  This is modelled after
setkey for shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c                  | 59 ++++++++++++++++++++++++++++-
 include/crypto/internal/scompress.h | 27 +++++++++++++
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1cef6bb06a81..283fbea8336e 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -37,6 +37,51 @@ static const struct crypto_type crypto_scomp_type;
 static int scomp_scratch_users;
 static DEFINE_MUTEX(scomp_lock);
 
+static inline struct crypto_scomp *__crypto_scomp_cast(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_scomp, base);
+}
+
+static int scomp_no_setparam(struct crypto_scomp *tfm, const u8 *param,
+			     unsigned int len)
+{
+	return -ENOSYS;
+}
+
+static bool crypto_scomp_alg_has_setparam(struct scomp_alg *alg)
+{
+	return alg->setparam != scomp_no_setparam;
+}
+
+static bool crypto_scomp_alg_needs_param(struct scomp_alg *alg)
+{
+	return crypto_scomp_alg_has_setparam(alg) &&
+	       !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
+}
+
+static void scomp_set_need_param(struct crypto_scomp *tfm,
+				 struct scomp_alg *alg)
+{
+	if (crypto_scomp_alg_needs_param(alg))
+		crypto_scomp_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+}
+
+int crypto_scomp_setparam(struct crypto_scomp *tfm, const u8 *param,
+			  unsigned int len)
+{
+	struct scomp_alg *scomp = crypto_scomp_alg(tfm);
+	int err;
+
+	err = scomp->setparam(tfm, param, len);
+	if (unlikely(err)) {
+		scomp_set_need_param(tfm, scomp);
+		return err;
+	}
+
+	crypto_scomp_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
+	return 0;
+}
+
 static int __maybe_unused crypto_scomp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -100,8 +145,12 @@ static int crypto_scomp_alloc_scratches(void)
 
 static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 {
+	struct crypto_scomp *comp = __crypto_scomp_cast(tfm);
+	struct scomp_alg *alg = crypto_scomp_alg(comp);
 	int ret = 0;
 
+	scomp_set_need_param(comp, alg);
+
 	mutex_lock(&scomp_lock);
 	if (!scomp_scratch_users++)
 		ret = crypto_scomp_alloc_scratches();
@@ -277,11 +326,19 @@ static const struct crypto_type crypto_scomp_type = {
 	.tfmsize = offsetof(struct crypto_scomp, base),
 };
 
+static void scomp_prepare_alg(struct scomp_alg *alg)
+{
+	comp_prepare_alg(&alg->calg);
+
+	if (!alg->setparam)
+		alg->setparam = scomp_no_setparam;
+}
+
 int crypto_register_scomp(struct scomp_alg *alg)
 {
 	struct crypto_alg *base = &alg->calg.base;
 
-	comp_prepare_alg(&alg->calg);
+	scomp_prepare_alg(alg);
 
 	base->cra_type = &crypto_scomp_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SCOMPRESS;
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 07a10fd2d321..4a9cf2174c7a 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -27,6 +27,7 @@ struct crypto_scomp {
  * @free_ctx:	Function frees context allocated with alloc_ctx
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @setparam:	Set parameters of the algorithm (e.g., compression level)
  * @base:	Common crypto API algorithm data structure
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
@@ -39,6 +40,8 @@ struct scomp_alg {
 	int (*decompress)(struct crypto_scomp *tfm, const u8 *src,
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
+	int (*setparam)(struct crypto_scomp *tfm, const u8 *param,
+			unsigned int len);
 
 	union {
 		struct COMP_ALG_COMMON;
@@ -71,6 +74,21 @@ static inline struct scomp_alg *crypto_scomp_alg(struct crypto_scomp *tfm)
 	return __crypto_scomp_alg(crypto_scomp_tfm(tfm)->__crt_alg);
 }
 
+static inline u32 crypto_scomp_get_flags(struct crypto_scomp *tfm)
+{
+	return crypto_tfm_get_flags(crypto_scomp_tfm(tfm));
+}
+
+static inline void crypto_scomp_set_flags(struct crypto_scomp *tfm, u32 flags)
+{
+	crypto_tfm_set_flags(crypto_scomp_tfm(tfm), flags);
+}
+
+static inline void crypto_scomp_clear_flags(struct crypto_scomp *tfm, u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_scomp_tfm(tfm), flags);
+}
+
 static inline void *crypto_scomp_alloc_ctx(struct crypto_scomp *tfm)
 {
 	return crypto_scomp_alg(tfm)->alloc_ctx(tfm);
@@ -82,10 +100,16 @@ static inline void crypto_scomp_free_ctx(struct crypto_scomp *tfm,
 	return crypto_scomp_alg(tfm)->free_ctx(tfm, ctx);
 }
 
+int crypto_scomp_setparam(struct crypto_scomp *tfm, const u8 *param,
+			  unsigned int len);
+
 static inline int crypto_scomp_compress(struct crypto_scomp *tfm,
 					const u8 *src, unsigned int slen,
 					u8 *dst, unsigned int *dlen, void *ctx)
 {
+	if (crypto_scomp_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
 	return crypto_scomp_alg(tfm)->compress(tfm, src, slen, dst, dlen, ctx);
 }
 
@@ -94,6 +118,9 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 					  u8 *dst, unsigned int *dlen,
 					  void *ctx)
 {
+	if (crypto_scomp_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
 	return crypto_scomp_alg(tfm)->decompress(tfm, src, slen, dst, dlen,
 						 ctx);
 }
-- 
2.39.2

