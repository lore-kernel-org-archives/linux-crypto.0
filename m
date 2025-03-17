Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760E21C179
	for <linux-crypto@vger.kernel.org>; Mon, 17 Mar 2025 08:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200446; cv=none; b=LqOopZNW1WKMIa0DYZH4PeB/FnwkGaAeuZ4mIknGABUVRWIkhAOYw4SJT9e/6sP/wRW+YnnA93PrKKfiSCB/QRS5lKEHlDFigOrK044YSoP6iwKhwUWYL5M8kWIg4CyMyeSR+N2MmXPIwrtdUoRl1xYxEmiXDZZZxVv9SxXjGss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200446; c=relaxed/simple;
	bh=lK1oN+WQ4krcqXCyAq+zm1tdt4eKPD4VHKMNYAEh9wU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=LEsCunXYzCw8dpW2SqlwviMWAhSgLAtiICrujq9ZI6zV4NpW20dekqyPsNfTn/EA3A7lWDfmmCxXwFFQrarERY/37CwCVB1Lr93zkEDzwupIPhX5OsMOXH/KYFgASpWXSovijqcrHSCeWw2MeGNMUmvwNQYJj8iqgp+lkEUcGu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OEIdYt38; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OEIdYt38"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pb63uL3ImA8ktpa3ZrYDAlCsJjUYBL2v+zucO1WwDPA=; b=OEIdYt38hnhIEusndJXDLSZ2MZ
	HhgJLNVNYfuPX60OjLvRNQ/26kJl3FyyvgqLSQM5RwQ8zGnv0sgKYa3D71xsFZ9Q2LRlMYdXOnxwh
	gjEdiDCIW31xEkfMv8zlfR4d6Fbl+yxuUgG//rS3R5kMgTyQHNIubJ0zKYtAbOoKX+yaWWX7CkzPo
	XKIxbQ40RNsbcNi7MtrjCOC2ETBerwVjmACqJ6Z4nIXjFHU2W8zHyHrdH7Vd/y7SlfBduaYb5hGZg
	5c2frXvqsseIaG1Wba27pn+PAohpmCuNelXUZ64hg6v2tPGMPWZ/ZEBp/9X+vNETnThF+5mxYfie4
	3ppxNbfg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tu5v5-007UWd-1P;
	Mon, 17 Mar 2025 16:34:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Mar 2025 16:33:59 +0800
Date: Mon, 17 Mar 2025 16:33:59 +0800
Message-Id: <05378e42b44cb8918def5ff8ac397ce5111ea22e.1742200161.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742200161.git.herbert@gondor.apana.org.au>
References: <cover.1742200161.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: scomp - Allocate per-cpu buffer on first use of
 each CPU
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Per-cpu buffers can be wasteful when the number of CPUs is large,
especially if the buffer itself is likely to never be used.  Reduce
such wastage by only allocating them on first use of a particular
CPU.

On start-up allocate a single buffer on the first possible CPU.
For every other CPU a work struct will be scheduled on first use
to allocate the buffer for that CPU.  Until the allocation succeeds
simply use the first CPU's buffer which is protected under a spin
lock.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c                  | 203 ++++++++++++++++++++++------
 include/crypto/acompress.h          |   6 -
 include/crypto/internal/acompress.h |   1 -
 include/crypto/internal/scompress.h |  13 ++
 4 files changed, 173 insertions(+), 50 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index d4be977b9729..52b157423ae9 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/acompress.h>
 #include <crypto/internal/scompress.h>
 #include <crypto/scatterwalk.h>
+#include <linux/cpumask.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/highmem.h>
@@ -20,7 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <net/netlink.h>
 
 #include "compress.h"
@@ -44,6 +45,10 @@ static const struct crypto_type crypto_scomp_type;
 static int scomp_scratch_users;
 static DEFINE_MUTEX(scomp_lock);
 
+static cpumask_t scomp_scratch_want;
+static void scomp_scratch_workfn(struct work_struct *work);
+static DECLARE_WORK(scomp_scratch_work, scomp_scratch_workfn);
+
 static int __maybe_unused crypto_scomp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -74,36 +79,57 @@ static void crypto_scomp_free_scratches(void)
 		scratch = per_cpu_ptr(&scomp_scratch, i);
 
 		free_page(scratch->saddr);
-		vfree(scratch->dst);
+		kvfree(scratch->dst);
 		scratch->src = NULL;
 		scratch->dst = NULL;
 	}
 }
 
+static int scomp_alloc_scratch(struct scomp_scratch *scratch, int cpu)
+{
+	int node = cpu_to_node(cpu);
+	struct page *page;
+	void *mem;
+
+	mem = kvmalloc_node(SCOMP_SCRATCH_SIZE, GFP_KERNEL, node);
+	if (!mem)
+		return -ENOMEM;
+	page = alloc_pages_node(node, GFP_KERNEL, 0);
+	if (!page) {
+		kvfree(mem);
+		return -ENOMEM;
+	}
+	spin_lock_bh(&scratch->lock);
+	scratch->src = page_address(page);
+	scratch->dst = mem;
+	spin_unlock_bh(&scratch->lock);
+	return 0;
+}
+
+static void scomp_scratch_workfn(struct work_struct *work)
+{
+	int cpu;
+
+	for_each_cpu(cpu, &scomp_scratch_want) {
+		struct scomp_scratch *scratch;
+
+		scratch = per_cpu_ptr(&scomp_scratch, cpu);
+		if (scratch->src)
+			continue;
+		if (scomp_alloc_scratch(scratch, cpu))
+			break;
+
+		cpumask_clear_cpu(cpu, &scomp_scratch_want);
+	}
+}
+
 static int crypto_scomp_alloc_scratches(void)
 {
+	unsigned int i = cpumask_first(cpu_possible_mask);
 	struct scomp_scratch *scratch;
-	int i;
 
-	for_each_possible_cpu(i) {
-		struct page *page;
-		void *mem;
-
-		scratch = per_cpu_ptr(&scomp_scratch, i);
-
-		page = alloc_pages_node(cpu_to_node(i), GFP_KERNEL, 0);
-		if (!page)
-			goto error;
-		scratch->src = page_address(page);
-		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
-		if (!mem)
-			goto error;
-		scratch->dst = mem;
-	}
-	return 0;
-error:
-	crypto_scomp_free_scratches();
-	return -ENOMEM;
+	scratch = per_cpu_ptr(&scomp_scratch, i);
+	return scomp_alloc_scratch(scratch, i);
 }
 
 static void scomp_free_streams(struct scomp_alg *alg)
@@ -115,7 +141,7 @@ static void scomp_free_streams(struct scomp_alg *alg)
 		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
 
 		if (!ps->ctx)
-			break;
+			continue;
 
 		alg->free_ctx(ps->ctx);
 	}
@@ -126,21 +152,26 @@ static void scomp_free_streams(struct scomp_alg *alg)
 static int scomp_alloc_streams(struct scomp_alg *alg)
 {
 	struct crypto_acomp_stream __percpu *stream;
-	int i;
+	struct crypto_acomp_stream *ps;
+	unsigned int i;
+	void *ctx;
 
 	stream = alloc_percpu(struct crypto_acomp_stream);
 	if (!stream)
 		return -ENOMEM;
 
+	ctx = alg->alloc_ctx();
+	if (IS_ERR(ctx)) {
+		free_percpu(stream);
+		return PTR_ERR(ctx);
+	}
+
+	i = cpumask_first(cpu_possible_mask);
+	ps = per_cpu_ptr(stream, i);
+	ps->ctx = ctx;
+
 	for_each_possible_cpu(i) {
-		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
-
-		ps->ctx = alg->alloc_ctx();
-		if (IS_ERR(ps->ctx)) {
-			scomp_free_streams(alg);
-			return PTR_ERR(ps->ctx);
-		}
-
+		ps = per_cpu_ptr(stream, i);
 		spin_lock_init(&ps->lock);
 	}
 
@@ -148,6 +179,33 @@ static int scomp_alloc_streams(struct scomp_alg *alg)
 	return 0;
 }
 
+static void scomp_stream_workfn(struct work_struct *work)
+{
+	struct scomp_alg *alg = container_of(work, struct scomp_alg,
+					     stream_work);
+	struct crypto_acomp_stream __percpu *stream = alg->stream;
+	int cpu;
+
+	for_each_cpu(cpu, &alg->stream_want) {
+		struct crypto_acomp_stream *ps;
+		void *ctx;
+
+		ps = per_cpu_ptr(stream, cpu);
+		if (ps->ctx)
+			continue;
+
+		ctx = alg->alloc_ctx();
+		if (IS_ERR(ctx))
+			break;
+
+		spin_lock_bh(&ps->lock);
+		ps->ctx = ctx;
+		spin_unlock_bh(&ps->lock);
+
+		cpumask_clear_cpu(cpu, &alg->stream_want);
+	}
+}
+
 static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 {
 	struct scomp_alg *alg = crypto_scomp_alg(__crypto_scomp_tfm(tfm));
@@ -171,13 +229,67 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 	return ret;
 }
 
+static struct scomp_scratch *scomp_lock_scratch_bh(void) __acquires(scratch)
+{
+	int cpu = raw_smp_processor_id();
+	struct scomp_scratch *scratch;
+
+	scratch = per_cpu_ptr(&scomp_scratch, cpu);
+	spin_lock_bh(&scratch->lock);
+	if (likely(scratch->src))
+		return scratch;
+	spin_unlock(&scratch->lock);
+
+	cpumask_set_cpu(cpu, &scomp_scratch_want);
+	schedule_work(&scomp_scratch_work);
+
+	scratch = per_cpu_ptr(&scomp_scratch, cpumask_first(cpu_possible_mask));
+	spin_lock(&scratch->lock);
+	return scratch;
+}
+
+static inline void scomp_unlock_scratch_bh(struct scomp_scratch *scratch)
+	__releases(scratch)
+{
+	spin_unlock_bh(&scratch->lock);
+}
+
+static struct crypto_acomp_stream *scomp_lock_stream(struct crypto_scomp *tfm)
+	__acquires(stream)
+{
+	struct scomp_alg *alg = crypto_scomp_alg(tfm);
+	struct crypto_acomp_stream __percpu *stream;
+	int cpu = raw_smp_processor_id();
+	struct crypto_acomp_stream *ps;
+
+	stream = alg->stream;
+	ps = per_cpu_ptr(stream, cpu);
+	spin_lock(&ps->lock);
+	if (likely(ps->ctx))
+		return ps;
+	spin_unlock(&ps->lock);
+
+	cpumask_set_cpu(cpu, &alg->stream_want);
+	schedule_work(&alg->stream_work);
+
+	ps = per_cpu_ptr(stream, cpumask_first(cpu_possible_mask));
+	spin_lock(&ps->lock);
+	return ps;
+}
+
+static inline void scomp_unlock_stream(struct crypto_acomp_stream *stream)
+	__releases(stream)
+{
+	spin_unlock(&stream->lock);
+}
+
 static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 {
-	struct scomp_scratch *scratch = raw_cpu_ptr(&scomp_scratch);
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 	struct crypto_scomp **tfm_ctx = acomp_tfm_ctx(tfm);
 	struct crypto_scomp *scomp = *tfm_ctx;
 	struct crypto_acomp_stream *stream;
+	struct scomp_scratch *scratch;
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
 	struct page *spage, *dpage;
@@ -194,6 +306,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!req->dst || !dlen)
 		return -EINVAL;
 
+	scratch = scomp_lock_scratch_bh();
+
 	if (acomp_request_src_isvirt(req))
 		src = req->svirt;
 	else {
@@ -218,6 +332,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 				break;
 			src = kmap_local_page(spage) + soff;
 		} while (0);
+
+		if (src == scratch->src)
+			memcpy_from_sglist(scratch->src, req->src, 0, slen);
 	}
 
 	if (acomp_request_dst_isvirt(req))
@@ -250,13 +367,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		dlen = min(dlen, max);
 	}
 
-	spin_lock_bh(&scratch->lock);
-
-	if (src == scratch->src)
-		memcpy_from_sglist(scratch->src, req->src, 0, slen);
-
-	stream = raw_cpu_ptr(crypto_scomp_alg(scomp)->stream);
-	spin_lock(&stream->lock);
+	stream = scomp_lock_stream(scomp);
 	if (dir)
 		ret = crypto_scomp_compress(scomp, src, slen,
 					    dst, &dlen, stream->ctx);
@@ -267,8 +378,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (dst == scratch->dst)
 		memcpy_to_sglist(req->dst, 0, dst, dlen);
 
-	spin_unlock(&stream->lock);
-	spin_unlock_bh(&scratch->lock);
+	scomp_unlock_stream(stream);
+	scomp_unlock_scratch_bh(scratch);
 
 	req->dlen = dlen;
 
@@ -319,6 +430,7 @@ static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
 
 	crypto_free_scomp(*ctx);
 
+	flush_work(&scomp_scratch_work);
 	mutex_lock(&scomp_lock);
 	if (!--scomp_scratch_users)
 		crypto_scomp_free_scratches();
@@ -352,7 +464,10 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 
 static void crypto_scomp_destroy(struct crypto_alg *alg)
 {
-	scomp_free_streams(__crypto_scomp_alg(alg));
+	struct scomp_alg *scomp = __crypto_scomp_alg(alg);
+
+	cancel_work_sync(&scomp->stream_work);
+	scomp_free_streams(scomp);
 }
 
 static const struct crypto_type crypto_scomp_type = {
@@ -378,6 +493,8 @@ static void scomp_prepare_alg(struct scomp_alg *alg)
 	comp_prepare_alg(&alg->calg);
 
 	base->cra_flags |= CRYPTO_ALG_REQ_CHAIN;
+
+	INIT_WORK(&alg->stream_work, scomp_stream_workfn);
 }
 
 int crypto_register_scomp(struct scomp_alg *alg)
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index c497c73baf13..f0e01ff77d92 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -130,14 +130,8 @@ struct crypto_acomp {
 	struct crypto_tfm base;
 };
 
-struct crypto_acomp_stream {
-	spinlock_t lock;
-	void *ctx;
-};
-
 #define COMP_ALG_COMMON {			\
 	struct crypto_alg base;			\
-	struct crypto_acomp_stream __percpu *stream;	\
 }
 struct comp_alg_common COMP_ALG_COMMON;
 
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index aaf59f3236fa..2af690819a83 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -37,7 +37,6 @@
  *
  * @reqsize:	Context size for (de)compression requests
  * @base:	Common crypto API algorithm data structure
- * @stream:	Per-cpu memory for algorithm
  * @calg:	Cmonn algorithm data structure shared with scomp
  */
 struct acomp_alg {
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index f25aa2ea3b48..fd74e656ffd2 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -11,6 +11,8 @@
 
 #include <crypto/acompress.h>
 #include <crypto/algapi.h>
+#include <linux/cpumask_types.h>
+#include <linux/workqueue_types.h>
 
 struct acomp_req;
 
@@ -18,6 +20,11 @@ struct crypto_scomp {
 	struct crypto_tfm base;
 };
 
+struct crypto_acomp_stream {
+	spinlock_t lock;
+	void *ctx;
+};
+
 /**
  * struct scomp_alg - synchronous compression algorithm
  *
@@ -27,6 +34,8 @@ struct crypto_scomp {
  * @decompress:	Function performs a de-compress operation
  * @base:	Common crypto API algorithm data structure
  * @stream:	Per-cpu memory for algorithm
+ * @stream_work:	Work struct to allocate stream memmory
+ * @stream_want:	CPU mask for allocating stream memory
  * @calg:	Cmonn algorithm data structure shared with acomp
  */
 struct scomp_alg {
@@ -39,6 +48,10 @@ struct scomp_alg {
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
 
+	struct crypto_acomp_stream __percpu *stream;
+	struct work_struct stream_work;
+	cpumask_t stream_want;
+
 	union {
 		struct COMP_ALG_COMMON;
 		struct comp_alg_common calg;
-- 
2.39.5

