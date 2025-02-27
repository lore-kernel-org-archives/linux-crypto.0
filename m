Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3C6229B0D
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651311; cv=none; b=QthGKbjIxIcaNCVikwsg9ObvFVk4QuXO/1QNjZVISWRJxCBjDKH3yYaILLMOrR4f5SrcxZyIbQwwvR25suyqLvdoOJ5/0QG1TpAhLUqWHvYzl/p6D2CaPgYPPQjfd8IXOAEm8572EeNwEyQvVW9XhG35M8MCYWyPnBlgeYKxZCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651311; c=relaxed/simple;
	bh=LvQVjH0+P2+mWaNaLQeuHJHr7Ix5DGyTIaSVmO37Ufg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=L7+qQ4fHLmUkIaEqmlNciLJXcrcBLuNOzc+lCgBPadCO1ooHA0uyKs4fB2gsOyb8qKI5UpYCp4LKG1zv3j8BM1vthkNJdQsZilOWXANaBN9H6XyfJS5XonHYyQOy4dB/pI2DI8mm/3ICvppv7fOqgGpXpRnHePGhmkp4NKGkUOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c95stfs5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c95stfs5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=eSOj7vOfSpGgQ5Kj0GYCHDDmdqiWsm4T+x7O3x8fxBs=; b=c95stfs5HmYKPE0pSQB1u/9+9m
	eNW8XoG3ZufiFA7486HXkW4q8y/NUBHBIHlLfx7JgpoMia3q17JBW0B8zduZl6+gqJwBSrbjk1JXr
	gtSlDfbKeWvMGaBR8n7C4AXW/vWGALoo1blWXp3//n25MgO4sO8gFqzdYrCH+Iet1+5hXEUX1jM3V
	v8yaRWJkBCuQXqAtY6D8w24/K758HJt5Lg14VaVLcQUNFFne2OuUcU3GMw3zd9Eiaem2pYtz1f79Z
	kpWVvYJv739ZaF/rvfdg98nhdMNB+N9kPZGpqOU5z4TPgFjm95b0m1jEAEkqPhz4+148LySIH+4s3
	NYkRMvFw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnav2-002DrQ-2q;
	Thu, 27 Feb 2025 18:15:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:15:04 +0800
Date: Thu, 27 Feb 2025 18:15:04 +0800
Message-Id: <30f87ea9a3738c57287f9099a9e638781fa212c5.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/7] crypto: scomp - Remove support for non-trivial SG lists
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As the only user of scomp uses a trivial single-page SG list,
remove support for everything else in preprataion for a shift
to virtual addresses.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  |   6 --
 crypto/scompress.c                  | 139 +++++-----------------------
 include/crypto/acompress.h          |  12 +--
 include/crypto/internal/scompress.h |   2 -
 4 files changed, 27 insertions(+), 132 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index d2103d4e42cc..8914d0c4cc75 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -73,7 +73,6 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
-	acomp->dst_free = alg->dst_free;
 	acomp->reqsize = alg->reqsize;
 
 	if (alg->exit)
@@ -146,11 +145,6 @@ void acomp_request_free(struct acomp_req *req)
 	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
 		crypto_acomp_scomp_free_ctx(req);
 
-	if (req->base.flags & CRYPTO_ACOMP_ALLOC_OUTPUT) {
-		acomp->dst_free(req->dst);
-		req->dst = NULL;
-	}
-
 	__acomp_request_free(req);
 }
 EXPORT_SYMBOL_GPL(acomp_request_free);
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1cef6bb06a81..ffc8e7f4862c 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -18,24 +18,11 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/vmalloc.h>
 #include <net/netlink.h>
 
 #include "compress.h"
 
-struct scomp_scratch {
-	spinlock_t	lock;
-	void		*src;
-	void		*dst;
-};
-
-static DEFINE_PER_CPU(struct scomp_scratch, scomp_scratch) = {
-	.lock = __SPIN_LOCK_UNLOCKED(scomp_scratch.lock),
-};
-
 static const struct crypto_type crypto_scomp_type;
-static int scomp_scratch_users;
-static DEFINE_MUTEX(scomp_lock);
 
 static int __maybe_unused crypto_scomp_report(
 	struct sk_buff *skb, struct crypto_alg *alg)
@@ -58,127 +45,57 @@ static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_puts(m, "type         : scomp\n");
 }
 
-static void crypto_scomp_free_scratches(void)
-{
-	struct scomp_scratch *scratch;
-	int i;
-
-	for_each_possible_cpu(i) {
-		scratch = per_cpu_ptr(&scomp_scratch, i);
-
-		vfree(scratch->src);
-		vfree(scratch->dst);
-		scratch->src = NULL;
-		scratch->dst = NULL;
-	}
-}
-
-static int crypto_scomp_alloc_scratches(void)
-{
-	struct scomp_scratch *scratch;
-	int i;
-
-	for_each_possible_cpu(i) {
-		void *mem;
-
-		scratch = per_cpu_ptr(&scomp_scratch, i);
-
-		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
-		if (!mem)
-			goto error;
-		scratch->src = mem;
-		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
-		if (!mem)
-			goto error;
-		scratch->dst = mem;
-	}
-	return 0;
-error:
-	crypto_scomp_free_scratches();
-	return -ENOMEM;
-}
-
 static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 {
-	int ret = 0;
-
-	mutex_lock(&scomp_lock);
-	if (!scomp_scratch_users++)
-		ret = crypto_scomp_alloc_scratches();
-	mutex_unlock(&scomp_lock);
-
-	return ret;
+	return 0;
 }
 
 static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	void **tfm_ctx = acomp_tfm_ctx(tfm);
+	struct crypto_scomp **tfm_ctx = acomp_tfm_ctx(tfm);
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
-	struct scomp_scratch *scratch;
+	unsigned int slen = req->slen;
+	unsigned int dlen = req->dlen;
 	void *src, *dst;
-	unsigned int dlen;
 	int ret;
 
-	if (!req->src || !req->slen || req->slen > SCOMP_SCRATCH_SIZE)
+	if (!req->src || !slen)
 		return -EINVAL;
 
-	if (req->dst && !req->dlen)
+	if (req->dst && !dlen)
 		return -EINVAL;
 
-	if (!req->dlen || req->dlen > SCOMP_SCRATCH_SIZE)
-		req->dlen = SCOMP_SCRATCH_SIZE;
+	if (!req->dst || !dlen)
+		return -ENOSYS;
 
-	dlen = req->dlen;
+	if (sg_nents(req->src) > 1 || req->src->offset + slen > PAGE_SIZE)
+		return -ENOSYS;
 
-	scratch = raw_cpu_ptr(&scomp_scratch);
-	spin_lock(&scratch->lock);
+	if (sg_nents(req->dst) > 1)
+		return -ENOSYS;
 
-	if (sg_nents(req->src) == 1 && !PageHighMem(sg_page(req->src))) {
-		src = page_to_virt(sg_page(req->src)) + req->src->offset;
-	} else {
-		scatterwalk_map_and_copy(scratch->src, req->src, 0,
-					 req->slen, 0);
-		src = scratch->src;
-	}
+	if (req->dst->offset >= PAGE_SIZE)
+		return -ENOSYS;
 
-	if (req->dst && sg_nents(req->dst) == 1 && !PageHighMem(sg_page(req->dst)))
-		dst = page_to_virt(sg_page(req->dst)) + req->dst->offset;
-	else
-		dst = scratch->dst;
+	if (req->dst->offset + dlen > PAGE_SIZE)
+		dlen = PAGE_SIZE - req->dst->offset;
+
+	src = kmap_local_page(sg_page(req->src)) + req->src->offset;
+	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
 
 	if (dir)
-		ret = crypto_scomp_compress(scomp, src, req->slen,
+		ret = crypto_scomp_compress(scomp, src, slen,
 					    dst, &req->dlen, *ctx);
 	else
-		ret = crypto_scomp_decompress(scomp, src, req->slen,
+		ret = crypto_scomp_decompress(scomp, src, slen,
 					      dst, &req->dlen, *ctx);
-	if (!ret) {
-		if (!req->dst) {
-			req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
-			if (!req->dst) {
-				ret = -ENOMEM;
-				goto out;
-			}
-		} else if (req->dlen > dlen) {
-			ret = -ENOSPC;
-			goto out;
-		}
-		if (dst == scratch->dst) {
-			scatterwalk_map_and_copy(scratch->dst, req->dst, 0,
-						 req->dlen, 1);
-		} else {
-			int nr_pages = DIV_ROUND_UP(req->dst->offset + req->dlen, PAGE_SIZE);
-			int i;
-			struct page *dst_page = sg_page(req->dst);
 
-			for (i = 0; i < nr_pages; i++)
-				flush_dcache_page(dst_page + i);
-		}
-	}
-out:
-	spin_unlock(&scratch->lock);
+	kunmap_local(src);
+	kunmap_local(dst);
+	flush_dcache_page(sg_page(req->dst));
+
 	return ret;
 }
 
@@ -197,11 +114,6 @@ static void crypto_exit_scomp_ops_async(struct crypto_tfm *tfm)
 	struct crypto_scomp **ctx = crypto_tfm_ctx(tfm);
 
 	crypto_free_scomp(*ctx);
-
-	mutex_lock(&scomp_lock);
-	if (!--scomp_scratch_users)
-		crypto_scomp_free_scratches();
-	mutex_unlock(&scomp_lock);
 }
 
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
@@ -225,7 +137,6 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 
 	crt->compress = scomp_acomp_compress;
 	crt->decompress = scomp_acomp_decompress;
-	crt->dst_free = sgl_free;
 	crt->reqsize = sizeof(void *);
 
 	return 0;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 15bb13e47f8b..25e193b0b8b4 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -15,8 +15,6 @@
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 
-#define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
-
 /* Set this bit for virtual address instead of SG list. */
 #define CRYPTO_ACOMP_REQ_VIRT		0x00000002
 
@@ -75,15 +73,12 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
- * @dst_free:		Frees destination buffer if allocated inside the
- *			algorithm
  * @reqsize:		Context size for (de)compression requests
  * @base:		Common crypto API algorithm data structure
  */
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
-	void (*dst_free)(struct scatterlist *dst);
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
@@ -234,7 +229,7 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 					      crypto_completion_t cmpl,
 					      void *data)
 {
-	u32 keep = CRYPTO_ACOMP_ALLOC_OUTPUT | CRYPTO_ACOMP_REQ_VIRT;
+	u32 keep = CRYPTO_ACOMP_REQ_VIRT;
 
 	req->base.complete = cmpl;
 	req->base.data = data;
@@ -268,9 +263,7 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
-	req->base.flags &= ~(CRYPTO_ACOMP_ALLOC_OUTPUT | CRYPTO_ACOMP_REQ_VIRT);
-	if (!req->dst)
-		req->base.flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_VIRT;
 }
 
 /**
@@ -294,7 +287,6 @@ static inline void acomp_request_set_virt(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
 	req->base.flags |= CRYPTO_ACOMP_REQ_VIRT;
 }
 
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 07a10fd2d321..25c5f8126618 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -12,8 +12,6 @@
 #include <crypto/acompress.h>
 #include <crypto/algapi.h>
 
-#define SCOMP_SCRATCH_SIZE	131072
-
 struct acomp_req;
 
 struct crypto_scomp {
-- 
2.39.5

