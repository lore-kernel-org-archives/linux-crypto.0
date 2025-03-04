Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701371FE471
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080324; cv=none; b=fngzTY7iSaiq7wcnov9n80csNaQXUQBCTCcOnCQfXu8Vzl3Bns0VQlFSC48rSg9oMqy7wSYCK2l+0dlcdszXTG8hrxKzHyiedO6iceY0tRPr6mA+wVEWHUioicuv1RFXzdPiQKKwYvjOopBp6LDeo5rL3O2RhSmg/Sh9dBxwt6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080324; c=relaxed/simple;
	bh=fkGAFVBoDgADaz7OXcRqid/RwPFN3E67PoDA/DlaM9Q=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ZyFYqzp+2dqa3oyWb99wT5VSGfolMT/iJnZAAgu20Z8oaPe3l52eRmEHbDa/HEXXuXHWd+Rz3B58hA9mhnRb51oObzWlOOJAo8TLSEVGXkzelOXXXfhXJI3g4srvErd6GnnFILeH3TYhm/Oi/SBVp2q7WYH4Y66l+4ODqMKhRVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=foZ2c8SL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="foZ2c8SL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/zhKnEevUyP3F8wMr+wshCLsYVBzBeztZgwi0df1+YA=; b=foZ2c8SL4/qg6rgogBOLoKALSU
	qk/XnCClLoZBfAbF4GZDuk0KzAkyRIwN6/nUB+rVcVKHSZCP4U6KTlRqyG+TOnECGqjscVS5e5m5e
	be7b8PNE7M6YCpWYpLzpYePLTgebQeqgU50vKWJMl+NwP34ZWmjuddTgPgk+JflOVx/TpuYTFq/Rw
	2dZYgmRK5My4/LG2msfcjVxjwqIdsS8NqRvmumCcZszKwmD+MslP97QdeNrc0tj31cRzaNQHPKohw
	ylbWy1AWRJp6nlae4tDdEQPhFzGzyOkgUKx175D6KkmY+JK03Zg5rBmYlwjMM4E38Hri7zrnty7JE
	Pllk5hEA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpOWb-003a3f-1u;
	Tue, 04 Mar 2025 17:25:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 17:25:17 +0800
Date: Tue, 04 Mar 2025 17:25:17 +0800
Message-Id: <e34b39c8043ff4dfe53fd8dc02c635f16f5e9504.1741080140.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741080140.git.herbert@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 7/7] crypto: acomp - Move stream management into scomp
 layer
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than allocating the stream memory in the request object,
move it into a per-cpu buffer managed by scomp.  This takes the
stress off the user from having to manage large request objects
and setting up their own per-cpu buffers in order to do so.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 25 --------
 crypto/compress.h                   |  2 -
 crypto/scompress.c                  | 90 +++++++++++++++++++----------
 include/crypto/acompress.h          | 25 +++++++-
 include/crypto/internal/acompress.h | 17 +-----
 include/crypto/internal/scompress.h | 12 +---
 6 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 8914d0c4cc75..f8e18f32478e 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -124,31 +124,6 @@ struct crypto_acomp *crypto_alloc_acomp_node(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp_node);
 
-struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp)
-{
-	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
-	struct acomp_req *req;
-
-	req = __acomp_request_alloc(acomp);
-	if (req && (tfm->__crt_alg->cra_type != &crypto_acomp_type))
-		return crypto_acomp_scomp_alloc_ctx(req);
-
-	return req;
-}
-EXPORT_SYMBOL_GPL(acomp_request_alloc);
-
-void acomp_request_free(struct acomp_req *req)
-{
-	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
-
-	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
-		crypto_acomp_scomp_free_ctx(req);
-
-	__acomp_request_free(req);
-}
-EXPORT_SYMBOL_GPL(acomp_request_free);
-
 static bool acomp_request_has_nondma(struct acomp_req *req)
 {
 	struct acomp_req *r2;
diff --git a/crypto/compress.h b/crypto/compress.h
index c3cedfb5e606..f7737a1fcbbd 100644
--- a/crypto/compress.h
+++ b/crypto/compress.h
@@ -15,8 +15,6 @@ struct acomp_req;
 struct comp_alg_common;
 
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
-struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
-void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
 
 void comp_prepare_alg(struct comp_alg_common *alg);
 
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 8ef2d71ad908..d9cf1696bff5 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -95,13 +95,62 @@ static int crypto_scomp_alloc_scratches(void)
 	return -ENOMEM;
 }
 
+static void scomp_free_streams(struct scomp_alg *alg)
+{
+	struct crypto_acomp_stream __percpu *stream = alg->stream;
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
+
+		if (!ps->ctx)
+			break;
+
+		alg->free_ctx(ps);
+	}
+
+	free_percpu(stream);
+}
+
+static int scomp_alloc_streams(struct scomp_alg *alg)
+{
+	struct crypto_acomp_stream __percpu *stream;
+	int i;
+
+	stream = alloc_percpu(struct crypto_acomp_stream);
+	if (!stream)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
+
+		ps->ctx = alg->alloc_ctx();
+		if (IS_ERR(ps->ctx)) {
+			scomp_free_streams(alg);
+			return PTR_ERR(ps->ctx);
+		}
+
+		spin_lock_init(&ps->lock);
+	}
+
+	alg->stream = stream;
+	return 0;
+}
+
 static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 {
+	struct scomp_alg *alg = crypto_scomp_alg(__crypto_scomp_tfm(tfm));
 	int ret = 0;
 
 	mutex_lock(&scomp_lock);
+	if (!alg->stream) {
+		ret = scomp_alloc_streams(alg);
+		if (ret)
+			goto unlock;
+	}
 	if (!scomp_scratch_users++)
 		ret = crypto_scomp_alloc_scratches();
+unlock:
 	mutex_unlock(&scomp_lock);
 
 	return ret;
@@ -112,7 +161,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 	struct crypto_scomp **tfm_ctx = acomp_tfm_ctx(tfm);
 	struct crypto_scomp *scomp = *tfm_ctx;
-	void **ctx = acomp_request_ctx(req);
+	struct crypto_acomp_stream *stream;
 	struct scomp_scratch *scratch;
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
@@ -148,18 +197,22 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
 	}
 
+	stream = raw_cpu_ptr(crypto_scomp_alg(scomp)->stream);
+
 	spin_lock(&scratch->lock);
+	spin_lock(&stream->lock);
 
 	if (src == scratch->src)
 		memcpy_from_sglist(scratch->src, req->src, 0, req->slen);
 
 	if (dir)
 		ret = crypto_scomp_compress(scomp, src, slen,
-					    dst, &req->dlen, *ctx);
+					    dst, &req->dlen, stream->ctx);
 	else
 		ret = crypto_scomp_decompress(scomp, src, slen,
-					      dst, &req->dlen, *ctx);
+					      dst, &req->dlen, stream->ctx);
 
+	spin_unlock(&stream->lock);
 	spin_unlock(&scratch->lock);
 
 	if (!acomp_request_isvirt(req)) {
@@ -234,40 +287,15 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 	return 0;
 }
 
-struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req)
+static void crypto_scomp_destroy(struct crypto_alg *alg)
 {
-	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
-	struct crypto_scomp **tfm_ctx = crypto_tfm_ctx(tfm);
-	struct crypto_scomp *scomp = *tfm_ctx;
-	void *ctx;
-
-	ctx = crypto_scomp_alloc_ctx(scomp);
-	if (IS_ERR(ctx)) {
-		kfree(req);
-		return NULL;
-	}
-
-	*req->__ctx = ctx;
-
-	return req;
-}
-
-void crypto_acomp_scomp_free_ctx(struct acomp_req *req)
-{
-	struct crypto_acomp *acomp = crypto_acomp_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
-	struct crypto_scomp **tfm_ctx = crypto_tfm_ctx(tfm);
-	struct crypto_scomp *scomp = *tfm_ctx;
-	void *ctx = *req->__ctx;
-
-	if (ctx)
-		crypto_scomp_free_ctx(scomp, ctx);
+	scomp_free_streams(__crypto_scomp_alg(alg));
 }
 
 static const struct crypto_type crypto_scomp_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_scomp_init_tfm,
+	.destroy = crypto_scomp_destroy,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_scomp_show,
 #endif
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 25e193b0b8b4..5e0602d2c827 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -10,9 +10,12 @@
 #define _CRYPTO_ACOMP_H
 
 #include <linux/atomic.h>
+#include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/spinlock_types.h>
 #include <linux/types.h>
 
 /* Set this bit for virtual address instead of SG list. */
@@ -83,8 +86,14 @@ struct crypto_acomp {
 	struct crypto_tfm base;
 };
 
+struct crypto_acomp_stream {
+	spinlock_t lock;
+	void *ctx;
+};
+
 #define COMP_ALG_COMMON {			\
 	struct crypto_alg base;			\
+	struct crypto_acomp_stream __percpu *stream;	\
 }
 struct comp_alg_common COMP_ALG_COMMON;
 
@@ -202,7 +211,16 @@ static inline int crypto_has_acomp(const char *alg_name, u32 type, u32 mask)
  *
  * Return:	allocated handle in case of success or NULL in case of an error
  */
-struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm);
+static inline struct acomp_req *acomp_request_alloc_noprof(struct crypto_acomp *tfm)
+{
+	struct acomp_req *req;
+
+	req = kzalloc_noprof(sizeof(*req) + crypto_acomp_reqsize(tfm), GFP_KERNEL);
+	if (likely(req))
+		acomp_request_set_tfm(req, tfm);
+	return req;
+}
+#define acomp_request_alloc(...)	alloc_hooks(acomp_request_alloc_noprof(__VA_ARGS__))
 
 /**
  * acomp_request_free() -- zeroize and free asynchronous (de)compression
@@ -211,7 +229,10 @@ struct acomp_req *acomp_request_alloc(struct crypto_acomp *tfm);
  *
  * @req:	request to free
  */
-void acomp_request_free(struct acomp_req *req);
+static inline void acomp_request_free(struct acomp_req *req)
+{
+	kfree_sensitive(req);
+}
 
 /**
  * acomp_request_set_callback() -- Sets an asynchronous callback
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index b3b48dea7f2f..2877053286e3 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -32,6 +32,7 @@
  *
  * @reqsize:	Context size for (de)compression requests
  * @base:	Common crypto API algorithm data structure
+ * @stream:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with scomp
  */
 struct acomp_alg {
@@ -68,22 +69,6 @@ static inline void acomp_request_complete(struct acomp_req *req,
 	crypto_request_complete(&req->base, err);
 }
 
-static inline struct acomp_req *__acomp_request_alloc_noprof(struct crypto_acomp *tfm)
-{
-	struct acomp_req *req;
-
-	req = kzalloc_noprof(sizeof(*req) + crypto_acomp_reqsize(tfm), GFP_KERNEL);
-	if (likely(req))
-		acomp_request_set_tfm(req, tfm);
-	return req;
-}
-#define __acomp_request_alloc(...)	alloc_hooks(__acomp_request_alloc_noprof(__VA_ARGS__))
-
-static inline void __acomp_request_free(struct acomp_req *req)
-{
-	kfree_sensitive(req);
-}
-
 /**
  * crypto_register_acomp() -- Register asynchronous compression algorithm
  *
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 2a6b15c0a32d..f25aa2ea3b48 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -26,6 +26,7 @@ struct crypto_scomp {
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
  * @base:	Common crypto API algorithm data structure
+ * @stream:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
 struct scomp_alg {
@@ -69,17 +70,6 @@ static inline struct scomp_alg *crypto_scomp_alg(struct crypto_scomp *tfm)
 	return __crypto_scomp_alg(crypto_scomp_tfm(tfm)->__crt_alg);
 }
 
-static inline void *crypto_scomp_alloc_ctx(struct crypto_scomp *tfm)
-{
-	return crypto_scomp_alg(tfm)->alloc_ctx();
-}
-
-static inline void crypto_scomp_free_ctx(struct crypto_scomp *tfm,
-					 void *ctx)
-{
-	return crypto_scomp_alg(tfm)->free_ctx(ctx);
-}
-
 static inline int crypto_scomp_compress(struct crypto_scomp *tfm,
 					const u8 *src, unsigned int slen,
 					u8 *dst, unsigned int *dlen, void *ctx)
-- 
2.39.5

