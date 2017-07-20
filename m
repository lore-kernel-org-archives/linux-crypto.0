From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: scompress - eliminate percpu scratch buffers
Date: Thu, 20 Jul 2017 12:40:00 +0100
Message-ID: <20170720114000.13840-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, giovanni.cabiddu@intel.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38366 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934828AbdGTLkK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 07:40:10 -0400
Received: by mail-wm0-f48.google.com with SMTP id w191so24292505wmw.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jul 2017 04:40:09 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The scompress code unconditionally allocates 2 per-CPU scratch buffers
of 128 KB each, in order to avoid allocation overhead in the async
wrapper that encapsulates the synchronous compression algorithm, since
it may execute in atomic context.

There are a couple of issues with this:
- The code may be invoked in process context with CRYPTO_TFM_REQ_MAY_SLEEP
  set in the request flags. If the CRYPTO_ACOMP_ALLOC_OUTPUT flag is also
  set, we end up calling kmalloc_array() and alloc_page() with the GFP
  flags set to GFP_KERNEL, and so we may attempt to sleep even though we
  are running with preemption disabled (due to the use of get_cpu())

- On a system such as Cavium ThunderX, which has 96 cores, the per-CPU
  buffers waste 24 MB of memory.

- On 32-bit systems, claiming vmalloc space of this order (e.g., 1 MB on
  a 4-core system) is undesirable as well, given how small the vmalloc
  space typically is on such systems.

- Lengthy CPU bound tasks such as compression should not be run with
  preemption disabled if we can avoid it.

So replace the per-PCU buffers with on-demand page allocations in the
handler. This reduces the memory and vmalloc space footprint of this
driver to ~0 unless you actually use it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

The req->dst case could be further optimized, and reuse the allocated
scratch_dst buffer as the buffer that is returned to the caller. Given
that there are no occurrences of crypto_alloc_acomp() anywhere in the
kernel, I will leave that to the next person.

 crypto/scompress.c | 126 ++++----------------
 1 file changed, 22 insertions(+), 104 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index ae1d3cf209e4..3d4c35a4c5a8 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -30,10 +30,6 @@
 #include "internal.h"
 
 static const struct crypto_type crypto_scomp_type;
-static void * __percpu *scomp_src_scratches;
-static void * __percpu *scomp_dst_scratches;
-static int scomp_scratch_users;
-static DEFINE_MUTEX(scomp_lock);
 
 #ifdef CONFIG_NET
 static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
@@ -70,67 +66,6 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void crypto_scomp_free_scratches(void * __percpu *scratches)
-{
-	int i;
-
-	if (!scratches)
-		return;
-
-	for_each_possible_cpu(i)
-		vfree(*per_cpu_ptr(scratches, i));
-
-	free_percpu(scratches);
-}
-
-static void * __percpu *crypto_scomp_alloc_scratches(void)
-{
-	void * __percpu *scratches;
-	int i;
-
-	scratches = alloc_percpu(void *);
-	if (!scratches)
-		return NULL;
-
-	for_each_possible_cpu(i) {
-		void *scratch;
-
-		scratch = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
-		if (!scratch)
-			goto error;
-		*per_cpu_ptr(scratches, i) = scratch;
-	}
-
-	return scratches;
-
-error:
-	crypto_scomp_free_scratches(scratches);
-	return NULL;
-}
-
-static void crypto_scomp_free_all_scratches(void)
-{
-	if (!--scomp_scratch_users) {
-		crypto_scomp_free_scratches(scomp_src_scratches);
-		crypto_scomp_free_scratches(scomp_dst_scratches);
-		scomp_src_scratches = NULL;
-		scomp_dst_scratches = NULL;
-	}
-}
-
-static int crypto_scomp_alloc_all_scratches(void)
-{
-	if (!scomp_scratch_users++) {
-		scomp_src_scratches = crypto_scomp_alloc_scratches();
-		if (!scomp_src_scratches)
-			return -ENOMEM;
-		scomp_dst_scratches = crypto_scomp_alloc_scratches();
-		if (!scomp_dst_scratches)
-			return -ENOMEM;
-	}
-	return 0;
-}
-
 static void crypto_scomp_sg_free(struct scatterlist *sgl)
 {
 	int i, n;
@@ -184,24 +119,31 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	void **tfm_ctx = acomp_tfm_ctx(tfm);
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
-	const int cpu = get_cpu();
-	u8 *scratch_src = *per_cpu_ptr(scomp_src_scratches, cpu);
-	u8 *scratch_dst = *per_cpu_ptr(scomp_dst_scratches, cpu);
+	u8 *scratch_src;
+	u8 *scratch_dst;
+	int alloc_order;
+	gfp_t gfp;
 	int ret;
 
-	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
+		return -EINVAL;
 
-	if (req->dst && !req->dlen) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (req->dst && !req->dlen)
+		return -EINVAL;
 
 	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
 		req->dlen = SCOMP_SCRATCH_SIZE;
 
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL
+							 : GFP_ATOMIC;
+
+	alloc_order = get_order(PAGE_ALIGN(req->slen) + req->dlen);
+	scratch_src = (u8 *)__get_free_pages(gfp, alloc_order);
+	if (!scratch_src)
+		return -ENOMEM;
+
+	scratch_dst = scratch_src + PAGE_ALIGN(req->slen);
+
 	scatterwalk_map_and_copy(scratch_src, req->src, 0, req->slen, 0);
 	if (dir)
 		ret = crypto_scomp_compress(scomp, scratch_src, req->slen,
@@ -211,9 +153,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 					      scratch_dst, &req->dlen, *ctx);
 	if (!ret) {
 		if (!req->dst) {
-			req->dst = crypto_scomp_sg_alloc(req->dlen,
-				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-				   GFP_KERNEL : GFP_ATOMIC);
+			req->dst = crypto_scomp_sg_alloc(req->dlen, gfp);
 			if (!req->dst)
 				goto out;
 		}
@@ -221,7 +161,7 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 					 1);
 	}
 out:
-	put_cpu();
+	free_pages((unsigned long)scratch_src, alloc_order);
 	return ret;
 }
 
@@ -316,40 +256,18 @@ static const struct crypto_type crypto_scomp_type = {
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
2.9.3
