Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559FD212B18
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 06:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364305; cv=none; b=G6qrfItXJS6dor2wQxgvOGOKR4J0QQnoJVFwpOBMM47dAeImQx1CbuE1YJ7/BPDLaGJwg0xULa4rsyZfhfLclir8hXNfYp2aZplz87OK40TNaKGsA/jRMxXachw1/l/zfmsGvwKxZcrwyjrV6musbFQGzmYYwNo0rT75d/JN51M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364305; c=relaxed/simple;
	bh=dPC8B1b/otrOqx3iccX+f24m3Lic2MrvuRDbxsHQypk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=a3/WeWknvRSy9qsiNo18FUTQ0XSaXzWbjJNYzkgUo/63NBbHZcpcz7GyzAPWPRgwmrYBwYIr4t4szjAeVrwS9zl6usgdatyHa+sYVj6vQZ2rYnG5L5oYaQlH2F5pzTqgsWcO4hgqHsuI3361Z0w4IFnRdJxGqPXa1Z+wDbT9koM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=guWRbF5Z; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="guWRbF5Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BdS3Jwtoy0+KWRTl1Vc65YLp6DmD3h6HBPIk2HGlSp4=; b=guWRbF5ZkMLEBVpAe234/jBTxP
	KCtL+E8zgKVyQaybS3hKCmslmjWspDSzWEJzpjVHZwmIiHCWGMjS88ddKbbUdL8GeWwoLbwnfOylT
	Px+f8Q0l9mzJMlWICfRhgvjfjr5FGRrdtdqQ6LzRAfYIEPhYGLvH9znD9PuGWE+xRavpbAjdkzv/z
	MfSZ6IB4eTtNdshh76O3AyHmzQ4yCfeCBWudivrGCHTDxpaOKn6DGHeEXzK+uoA73nXYl1Ih5BkQ/
	H9fSMuSCA2ZGNrgcTvt0NIByaWM2+KUhR4JnugaTwzEJu2xCER8D/zRPPI+5+ZKSujSQJuLK0+H8v
	eKmsBHLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tumXs-008IUb-0r;
	Wed, 19 Mar 2025 14:04:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 14:04:52 +0800
Date: Wed, 19 Mar 2025 14:04:52 +0800
Message-Id: <fcd7afa6d5e9c191d74e9dc4b96464631f254793.1742364215.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742364215.git.herbert@gondor.apana.org.au>
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] crypto: acomp - Move scomp stream allocation code into
 acomp
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Move the dynamic stream allocation code into acomp and make it
available as a helper for acomp algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 112 +++++++++++++++++++++++
 crypto/scompress.c                  | 133 +++-------------------------
 include/crypto/internal/acompress.h |  33 +++++++
 include/crypto/internal/scompress.h |  28 ++----
 4 files changed, 166 insertions(+), 140 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6ef335f5bf27..75fa9be1aa41 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -9,13 +9,18 @@
 
 #include <crypto/internal/acompress.h>
 #include <linux/cryptouser.h>
+#include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/page-flags.h>
+#include <linux/percpu.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
 #include <net/netlink.h>
 
 #include "compress.h"
@@ -445,5 +450,112 @@ void crypto_unregister_acomps(struct acomp_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_acomps);
 
+static void acomp_stream_workfn(struct work_struct *work)
+{
+	struct crypto_acomp_streams *s =
+		container_of(work, struct crypto_acomp_streams, stream_work);
+	struct crypto_acomp_stream __percpu *streams = s->streams;
+	int cpu;
+
+	for_each_cpu(cpu, &s->stream_want) {
+		struct crypto_acomp_stream *ps;
+		void *ctx;
+
+		ps = per_cpu_ptr(streams, cpu);
+		if (ps->ctx)
+			continue;
+
+		ctx = s->alloc_ctx();
+		if (IS_ERR(ctx))
+			break;
+
+		spin_lock_bh(&ps->lock);
+		ps->ctx = ctx;
+		spin_unlock_bh(&ps->lock);
+
+		cpumask_clear_cpu(cpu, &s->stream_want);
+	}
+}
+
+void crypto_acomp_free_streams(struct crypto_acomp_streams *s)
+{
+	struct crypto_acomp_stream __percpu *streams = s->streams;
+	void (*free_ctx)(void *);
+	int i;
+
+	cancel_work_sync(&s->stream_work);
+	free_ctx = s->free_ctx;
+
+	for_each_possible_cpu(i) {
+		struct crypto_acomp_stream *ps = per_cpu_ptr(streams, i);
+
+		if (!ps->ctx)
+			continue;
+
+		free_ctx(ps->ctx);
+	}
+
+	free_percpu(streams);
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_free_streams);
+
+int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s)
+{
+	struct crypto_acomp_stream __percpu *streams;
+	struct crypto_acomp_stream *ps;
+	unsigned int i;
+	void *ctx;
+
+	if (s->streams)
+		return 0;
+
+	streams = alloc_percpu(struct crypto_acomp_stream);
+	if (!streams)
+		return -ENOMEM;
+
+	ctx = s->alloc_ctx();
+	if (IS_ERR(ctx)) {
+		free_percpu(streams);
+		return PTR_ERR(ctx);
+	}
+
+	i = cpumask_first(cpu_possible_mask);
+	ps = per_cpu_ptr(streams, i);
+	ps->ctx = ctx;
+
+	for_each_possible_cpu(i) {
+		ps = per_cpu_ptr(streams, i);
+		spin_lock_init(&ps->lock);
+	}
+
+	s->streams = streams;
+
+	INIT_WORK(&s->stream_work, acomp_stream_workfn);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_alloc_streams);
+
+struct crypto_acomp_stream *crypto_acomp_lock_stream_bh(
+	struct crypto_acomp_streams *s) __acquires(stream)
+{
+	struct crypto_acomp_stream __percpu *streams = s->streams;
+	int cpu = raw_smp_processor_id();
+	struct crypto_acomp_stream *ps;
+
+	ps = per_cpu_ptr(streams, cpu);
+	spin_lock_bh(&ps->lock);
+	if (likely(ps->ctx))
+		return ps;
+	spin_unlock(&ps->lock);
+
+	cpumask_set_cpu(cpu, &s->stream_want);
+	schedule_work(&s->stream_work);
+
+	ps = per_cpu_ptr(streams, cpumask_first(cpu_possible_mask));
+	spin_lock(&ps->lock);
+	return ps;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_lock_stream_bh);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 52b157423ae9..ebcc15be4f41 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -7,7 +7,6 @@
  * Author: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
  */
 
-#include <crypto/internal/acompress.h>
 #include <crypto/internal/scompress.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpumask.h>
@@ -132,91 +131,15 @@ static int crypto_scomp_alloc_scratches(void)
 	return scomp_alloc_scratch(scratch, i);
 }
 
-static void scomp_free_streams(struct scomp_alg *alg)
-{
-	struct crypto_acomp_stream __percpu *stream = alg->stream;
-	int i;
-
-	for_each_possible_cpu(i) {
-		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
-
-		if (!ps->ctx)
-			continue;
-
-		alg->free_ctx(ps->ctx);
-	}
-
-	free_percpu(stream);
-}
-
-static int scomp_alloc_streams(struct scomp_alg *alg)
-{
-	struct crypto_acomp_stream __percpu *stream;
-	struct crypto_acomp_stream *ps;
-	unsigned int i;
-	void *ctx;
-
-	stream = alloc_percpu(struct crypto_acomp_stream);
-	if (!stream)
-		return -ENOMEM;
-
-	ctx = alg->alloc_ctx();
-	if (IS_ERR(ctx)) {
-		free_percpu(stream);
-		return PTR_ERR(ctx);
-	}
-
-	i = cpumask_first(cpu_possible_mask);
-	ps = per_cpu_ptr(stream, i);
-	ps->ctx = ctx;
-
-	for_each_possible_cpu(i) {
-		ps = per_cpu_ptr(stream, i);
-		spin_lock_init(&ps->lock);
-	}
-
-	alg->stream = stream;
-	return 0;
-}
-
-static void scomp_stream_workfn(struct work_struct *work)
-{
-	struct scomp_alg *alg = container_of(work, struct scomp_alg,
-					     stream_work);
-	struct crypto_acomp_stream __percpu *stream = alg->stream;
-	int cpu;
-
-	for_each_cpu(cpu, &alg->stream_want) {
-		struct crypto_acomp_stream *ps;
-		void *ctx;
-
-		ps = per_cpu_ptr(stream, cpu);
-		if (ps->ctx)
-			continue;
-
-		ctx = alg->alloc_ctx();
-		if (IS_ERR(ctx))
-			break;
-
-		spin_lock_bh(&ps->lock);
-		ps->ctx = ctx;
-		spin_unlock_bh(&ps->lock);
-
-		cpumask_clear_cpu(cpu, &alg->stream_want);
-	}
-}
-
 static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 {
 	struct scomp_alg *alg = crypto_scomp_alg(__crypto_scomp_tfm(tfm));
 	int ret = 0;
 
 	mutex_lock(&scomp_lock);
-	if (!alg->stream) {
-		ret = scomp_alloc_streams(alg);
-		if (ret)
-			goto unlock;
-	}
+	ret = crypto_acomp_alloc_streams(&alg->streams);
+	if (ret)
+		goto unlock;
 	if (!scomp_scratch_users) {
 		ret = crypto_scomp_alloc_scratches();
 		if (ret)
@@ -229,13 +152,13 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 	return ret;
 }
 
-static struct scomp_scratch *scomp_lock_scratch_bh(void) __acquires(scratch)
+static struct scomp_scratch *scomp_lock_scratch(void) __acquires(scratch)
 {
 	int cpu = raw_smp_processor_id();
 	struct scomp_scratch *scratch;
 
 	scratch = per_cpu_ptr(&scomp_scratch, cpu);
-	spin_lock_bh(&scratch->lock);
+	spin_lock(&scratch->lock);
 	if (likely(scratch->src))
 		return scratch;
 	spin_unlock(&scratch->lock);
@@ -248,39 +171,10 @@ static struct scomp_scratch *scomp_lock_scratch_bh(void) __acquires(scratch)
 	return scratch;
 }
 
-static inline void scomp_unlock_scratch_bh(struct scomp_scratch *scratch)
+static inline void scomp_unlock_scratch(struct scomp_scratch *scratch)
 	__releases(scratch)
 {
-	spin_unlock_bh(&scratch->lock);
-}
-
-static struct crypto_acomp_stream *scomp_lock_stream(struct crypto_scomp *tfm)
-	__acquires(stream)
-{
-	struct scomp_alg *alg = crypto_scomp_alg(tfm);
-	struct crypto_acomp_stream __percpu *stream;
-	int cpu = raw_smp_processor_id();
-	struct crypto_acomp_stream *ps;
-
-	stream = alg->stream;
-	ps = per_cpu_ptr(stream, cpu);
-	spin_lock(&ps->lock);
-	if (likely(ps->ctx))
-		return ps;
-	spin_unlock(&ps->lock);
-
-	cpumask_set_cpu(cpu, &alg->stream_want);
-	schedule_work(&alg->stream_work);
-
-	ps = per_cpu_ptr(stream, cpumask_first(cpu_possible_mask));
-	spin_lock(&ps->lock);
-	return ps;
-}
-
-static inline void scomp_unlock_stream(struct crypto_acomp_stream *stream)
-	__releases(stream)
-{
-	spin_unlock(&stream->lock);
+	spin_unlock(&scratch->lock);
 }
 
 static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
@@ -306,7 +200,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dst || !dlen)
 		return -EINVAL;
 
-	scratch = scomp_lock_scratch_bh();
+	stream = crypto_acomp_lock_stream_bh(&crypto_scomp_alg(scomp)->streams);
+	scratch = scomp_lock_scratch();
 
 	if (acomp_request_src_isvirt(req))
 		src = req->svirt;
@@ -367,7 +262,6 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		dlen = min(dlen, max);
 	}
 
-	stream = scomp_lock_stream(scomp);
 	if (dir)
 		ret = crypto_scomp_compress(scomp, src, slen,
 					    dst, &dlen, stream->ctx);
@@ -378,8 +272,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (dst == scratch->dst)
 		memcpy_to_sglist(req->dst, 0, dst, dlen);
 
-	scomp_unlock_stream(stream);
-	scomp_unlock_scratch_bh(scratch);
+	scomp_unlock_scratch(scratch);
+	crypto_acomp_unlock_stream_bh(stream);
 
 	req->dlen = dlen;
 
@@ -466,8 +360,7 @@ static void crypto_scomp_destroy(struct crypto_alg *alg)
 {
 	struct scomp_alg *scomp = __crypto_scomp_alg(alg);
 
-	cancel_work_sync(&scomp->stream_work);
-	scomp_free_streams(scomp);
+	crypto_acomp_free_streams(&scomp->streams);
 }
 
 static const struct crypto_type crypto_scomp_type = {
@@ -493,8 +386,6 @@ static void scomp_prepare_alg(struct scomp_alg *alg)
 	comp_prepare_alg(&alg->calg);
 
 	base->cra_flags |= CRYPTO_ALG_REQ_CHAIN;
-
-	INIT_WORK(&alg->stream_work, scomp_stream_workfn);
 }
 
 int crypto_register_scomp(struct scomp_alg *alg)
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2af690819a83..ee5eff19eaf4 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -11,6 +11,10 @@
 
 #include <crypto/acompress.h>
 #include <crypto/algapi.h>
+#include <linux/compiler_types.h>
+#include <linux/cpumask_types.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue_types.h>
 
 #define ACOMP_REQUEST_ON_STACK(name, tfm) \
         char __##name##_req[sizeof(struct acomp_req) + \
@@ -53,6 +57,24 @@ struct acomp_alg {
 	};
 };
 
+struct crypto_acomp_stream {
+	spinlock_t lock;
+	void *ctx;
+};
+
+struct crypto_acomp_streams {
+	/* These must come first because of struct scomp_alg. */
+	void *(*alloc_ctx)(void);
+	union {
+		void (*free_ctx)(void *);
+		void (*cfree_ctx)(const void *);
+	};
+
+	struct crypto_acomp_stream __percpu *streams;
+	struct work_struct stream_work;
+	cpumask_t stream_want;
+};
+
 /*
  * Transform internal helpers.
  */
@@ -157,4 +179,15 @@ static inline bool crypto_acomp_req_chain(struct crypto_acomp *tfm)
 	return crypto_tfm_req_chain(&tfm->base);
 }
 
+void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
+int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
+
+struct crypto_acomp_stream *crypto_acomp_lock_stream_bh(
+	struct crypto_acomp_streams *s) __acquires(stream);
+
+static inline void crypto_acomp_unlock_stream_bh(
+	struct crypto_acomp_stream *stream) __releases(stream)
+{
+	spin_unlock_bh(&stream->lock);
+}
 #endif
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index fd74e656ffd2..533d6c16a491 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -9,22 +9,12 @@
 #ifndef _CRYPTO_SCOMP_INT_H
 #define _CRYPTO_SCOMP_INT_H
 
-#include <crypto/acompress.h>
-#include <crypto/algapi.h>
-#include <linux/cpumask_types.h>
-#include <linux/workqueue_types.h>
-
-struct acomp_req;
+#include <crypto/internal/acompress.h>
 
 struct crypto_scomp {
 	struct crypto_tfm base;
 };
 
-struct crypto_acomp_stream {
-	spinlock_t lock;
-	void *ctx;
-};
-
 /**
  * struct scomp_alg - synchronous compression algorithm
  *
@@ -33,14 +23,10 @@ struct crypto_acomp_stream {
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
  * @base:	Common crypto API algorithm data structure
- * @stream:	Per-cpu memory for algorithm
- * @stream_work:	Work struct to allocate stream memmory
- * @stream_want:	CPU mask for allocating stream memory
+ * @streams:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
 struct scomp_alg {
-	void *(*alloc_ctx)(void);
-	void (*free_ctx)(void *ctx);
 	int (*compress)(struct crypto_scomp *tfm, const u8 *src,
 			unsigned int slen, u8 *dst, unsigned int *dlen,
 			void *ctx);
@@ -48,9 +34,13 @@ struct scomp_alg {
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
 
-	struct crypto_acomp_stream __percpu *stream;
-	struct work_struct stream_work;
-	cpumask_t stream_want;
+	union {
+		struct {
+			void *(*alloc_ctx)(void);
+			void (*free_ctx)(void *ctx);
+		};
+		struct crypto_acomp_streams streams;
+	};
 
 	union {
 		struct COMP_ALG_COMMON;
-- 
2.39.5

