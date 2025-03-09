Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A2288DB
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488212; cv=none; b=OuASbtQ9LCQIMHRbEyNT6icsGfrVfRHXX8W7ybrDl/1NBjHlncaeRRbkx3kDWZUD+zx0qDqIS7zTJt2DJUSYn2glDrmffOYffmuShTPx5b5KDB8vD2O888/VWsWzI5jo6/5ZMjIyWYyvKyz9ACoa8Jg81xndHfgmafq24478t9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488212; c=relaxed/simple;
	bh=btIx6TT8JGqM47FtssaJVTXJ96Mw2Tt1+N12V0HTACM=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=shYO88U2M9OYncIGET7vJtQbSqmgc993hzEAaFq+Q8UkOuwSd2sH2UHKyYnDb5qZxLUIe1RgUQDP3VynFwLHe8kr8+v8gcL860LW2GLzztZ3upyfCD5ESw/vLKJ04MiN2SzCPvz5KbWUCIvYRTqA1UbGBDmNaafdmZNy0KaiVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dYJDUTys; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dYJDUTys"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PRT2MmxdXXQUrELLEq9LBIynxyrU+ZI+MEhSUMDU220=; b=dYJDUTysIZQxJAMb2dWfJjrSc/
	icdEI0rAZd02VELEtYmMi1+bwZP42k5An+bqXoWivYURUfKy5VfnAq64O4LHBPgP5Tylg/MNqAfkE
	F6h/U41L8IMM1tJ6iNl1seJGOmIE9j5Ap/NmRcaidWnF1ftO43XIHAx5PdgGif5g08YIYbNsl6ZPE
	6k1JcCSCWm2EdFU/jICC1b58snYIrHRIzhU3y+KDnOdKZa5NaUTme32HOcHHCdpx4nY6UYz01+jFP
	+ahpFuiWSM+1k7+MguxTfIuDhZXWAasdXVS3Y6Kh0I2J5dyLIuw0EOFSS9Y3wNhIuvkwsiXrAGTbl
	r/9gfWIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dS-004zHx-16;
	Sun, 09 Mar 2025 10:43:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:26 +0800
Date: Sun, 09 Mar 2025 10:43:26 +0800
Message-Id: <205f05023b5ff0d8cf7deb6e0a5fbb4643f02e00.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 7/8] crypto: scomp - Remove support for most non-trivial
 destination SG lists
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As the only user of acomp/scomp uses a trivial single-page SG
list, remove support for everything else in preprataion for the
addition of virtual address support.

However, keep support for non-trivial source SG lists as that
user is currently jumping through hoops in order to linearise
the source data.

Limit the source SG linearisation buffer to a single page as
that user never goes over that.  The only other potential user
is also unlikely to exceed that (IPComp) and it can easily do
its own linearisation if necessary.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  |  1 -
 crypto/scompress.c                  | 95 ++++++++++++-----------------
 include/crypto/acompress.h          | 17 +-----
 include/crypto/internal/scompress.h |  2 -
 4 files changed, 41 insertions(+), 74 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 45444e99a9db..194a4b36f97f 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -73,7 +73,6 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
-	acomp->dst_free = alg->dst_free;
 	acomp->reqsize = alg->reqsize;
 
 	if (alg->exit)
diff --git a/crypto/scompress.c b/crypto/scompress.c
index a2ce481a10bb..1f7426c6d85a 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -18,15 +18,18 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/vmalloc.h>
 #include <net/netlink.h>
 
 #include "compress.h"
 
+#define SCOMP_SCRATCH_SIZE	PAGE_SIZE
+
 struct scomp_scratch {
 	spinlock_t	lock;
-	void		*src;
-	void		*dst;
+	union {
+		void *src;
+		unsigned long saddr;
+	};
 };
 
 static DEFINE_PER_CPU(struct scomp_scratch, scomp_scratch) = {
@@ -66,10 +69,8 @@ static void crypto_scomp_free_scratches(void)
 	for_each_possible_cpu(i) {
 		scratch = per_cpu_ptr(&scomp_scratch, i);
 
-		vfree(scratch->src);
-		vfree(scratch->dst);
+		free_page(scratch->saddr);
 		scratch->src = NULL;
-		scratch->dst = NULL;
 	}
 }
 
@@ -79,18 +80,14 @@ static int crypto_scomp_alloc_scratches(void)
 	int i;
 
 	for_each_possible_cpu(i) {
-		void *mem;
+		unsigned long mem;
 
 		scratch = per_cpu_ptr(&scomp_scratch, i);
 
-		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
+		mem = __get_free_page(GFP_KERNEL);
 		if (!mem)
 			goto error;
-		scratch->src = mem;
-		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
-		if (!mem)
-			goto error;
-		scratch->dst = mem;
+		scratch->saddr = mem;
 	}
 	return 0;
 error:
@@ -162,40 +159,43 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	void **tfm_ctx = acomp_tfm_ctx(tfm);
+	struct crypto_scomp **tfm_ctx = acomp_tfm_ctx(tfm);
 	struct crypto_scomp *scomp = *tfm_ctx;
 	struct crypto_acomp_stream *stream;
 	struct scomp_scratch *scratch;
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
+	if (sg_nents(req->dst) > 1)
+		return -ENOSYS;
 
-	dlen = req->dlen;
+	if (req->dst->offset >= PAGE_SIZE)
+		return -ENOSYS;
+
+	if (req->dst->offset + dlen > PAGE_SIZE)
+		dlen = PAGE_SIZE - req->dst->offset;
+
+	if (sg_nents(req->src) == 1 && (!PageHighMem(sg_page(req->src)) ||
+					req->src->offset + slen <= PAGE_SIZE))
+		src = kmap_local_page(sg_page(req->src)) + req->src->offset;
+	else
+		src = scratch->src;
+
+	dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
 
 	scratch = raw_cpu_ptr(&scomp_scratch);
 	spin_lock_bh(&scratch->lock);
 
-	if (sg_nents(req->src) == 1 && !PageHighMem(sg_page(req->src))) {
-		src = page_to_virt(sg_page(req->src)) + req->src->offset;
-	} else {
-		scatterwalk_map_and_copy(scratch->src, req->src, 0,
-					 req->slen, 0);
-		src = scratch->src;
-	}
-
-	if (req->dst && sg_nents(req->dst) == 1 && !PageHighMem(sg_page(req->dst)))
-		dst = page_to_virt(sg_page(req->dst)) + req->dst->offset;
-	else
-		dst = scratch->dst;
+	if (src == scratch->src)
+		memcpy_from_sglist(src, req->src, 0, req->slen);
 
 	stream = raw_cpu_ptr(crypto_scomp_alg(scomp)->stream);
 	spin_lock(&stream->lock);
@@ -206,31 +206,13 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		ret = crypto_scomp_decompress(scomp, src, req->slen,
 					      dst, &req->dlen, stream->ctx);
 	spin_unlock(&stream->lock);
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
-
-			for (i = 0; i < nr_pages; i++)
-				flush_dcache_page(dst_page + i);
-		}
-	}
-out:
 	spin_unlock_bh(&scratch->lock);
+
+	if (src != scratch->src)
+		kunmap_local(src);
+	kunmap_local(dst);
+	flush_dcache_page(sg_page(req->dst));
+
 	return ret;
 }
 
@@ -277,7 +259,6 @@ int crypto_init_scomp_ops_async(struct crypto_tfm *tfm)
 
 	crt->compress = scomp_acomp_compress;
 	crt->decompress = scomp_acomp_decompress;
-	crt->dst_free = sgl_free;
 
 	return 0;
 }
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index c4d8a29274c6..53c9e632862b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -18,8 +18,6 @@
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
 
-#define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
-
 /* Set this bit if source is virtual address instead of SG list. */
 #define CRYPTO_ACOMP_REQ_SRC_VIRT	0x00000002
 
@@ -84,15 +82,12 @@ struct acomp_req {
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
@@ -261,9 +256,8 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 					      crypto_completion_t cmpl,
 					      void *data)
 {
-	u32 keep = CRYPTO_ACOMP_ALLOC_OUTPUT | CRYPTO_ACOMP_REQ_SRC_VIRT |
-		   CRYPTO_ACOMP_REQ_SRC_NONDMA | CRYPTO_ACOMP_REQ_DST_VIRT |
-		   CRYPTO_ACOMP_REQ_DST_NONDMA;
+	u32 keep = CRYPTO_ACOMP_REQ_SRC_VIRT | CRYPTO_ACOMP_REQ_SRC_NONDMA |
+		   CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA;
 
 	req->base.complete = cmpl;
 	req->base.data = data;
@@ -297,13 +291,10 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
-	req->base.flags &= ~(CRYPTO_ACOMP_ALLOC_OUTPUT |
-			     CRYPTO_ACOMP_REQ_SRC_VIRT |
+	req->base.flags &= ~(CRYPTO_ACOMP_REQ_SRC_VIRT |
 			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
 			     CRYPTO_ACOMP_REQ_DST_VIRT |
 			     CRYPTO_ACOMP_REQ_DST_NONDMA);
-	if (!req->dst)
-		req->base.flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
 /**
@@ -403,7 +394,6 @@ static inline void acomp_request_set_dst_dma(struct acomp_req *req,
 	req->dvirt = dst;
 	req->dlen = dlen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_NONDMA;
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_VIRT;
 }
@@ -424,7 +414,6 @@ static inline void acomp_request_set_dst_nondma(struct acomp_req *req,
 	req->dvirt = dst;
 	req->dlen = dlen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_NONDMA;
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_VIRT;
 }
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 88986ab8ce15..f25aa2ea3b48 100644
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

