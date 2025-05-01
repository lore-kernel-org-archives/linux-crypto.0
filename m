Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34E22253FD
	for <linux-crypto@vger.kernel.org>; Thu,  1 May 2025 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746103062; cv=none; b=pLC+r8a6k40ZRBqk7F+TaPkB2Xi/2yqWYN5XSnu9Dpqd28dJwOaqfcHRsJsj+5R1qafPYZ2bBmiYRaWHoICNUhMvSLZmuyNvHjOER1B6SrKwYalz5/b8cV1+5N5IJGmSuZSPP4eL9v+hWy/IU/+09AIr3ITsL9Q1IaR8vwcZLLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746103062; c=relaxed/simple;
	bh=GKShZ+4esPP6JFokUTLEw9AsB2RDr6rnJ6/MoqGwT3E=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=kRhANdtgamwUZA07/2hbgl0dj6HQIIJN85X3jpsOu3l9CmB+oHIXDIV7HJAE+q8qjHwM0j7pZHfdDZsLdxmRgihKaDlMQBlSLMovF8IvATbr8yeOV4g+s1W4hWxvIr8BEiehB2TqOE/94beL5fA3G2wjL6E90ZSH5ezT5Sn/3A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sf7ocQFb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sf7ocQFb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IG1NXODoAPSeiMfeVbkg8+4OeRbyOHOxiq38CzJfrsU=; b=sf7ocQFbeKhYTLQm48Awslu6mL
	XNqrtThJ2Vae/IB0F5AJl/vdzRaSpqU7Lh18Fd8r1Kov86YJLyFWYkIame9CyJiiqgH1c2f43vWsJ
	Vrad26jZQ4LOiq3hKWmsG2YxSexZYXggEPCVyItvXl3B1UzAbCmtE4YaeaI9ZZJT5uvevqO9/iaHx
	QuSG1317yarhV+CEZDvOdxAHOQGHgJSD9L3ZtGYG5ZsE15gMKqzKjoG7KlK6irIQDyp7jR4xHMdDC
	OZHd0LmYRsbYW2w5YryVYCTSYWF+YjAvnmSmn64ot6t2ApkS62c/y9qy7wnfWl0ehViFSfhGVHirI
	a/xRes8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uATAV-002bFI-0U;
	Thu, 01 May 2025 20:37:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 May 2025 20:37:35 +0800
Date: Thu, 01 May 2025 20:37:35 +0800
Message-Id: <c48990bee119c8a7b0a04edc7de4065723025a16.1746102673.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746102673.git.herbert@gondor.apana.org.au>
References: <cover.1746102673.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto: acomp - Add compression segmentation support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add support for compression after segmentation.  The caller shall
specify a unit size, and the API will divide the source SG list
into the units of that size, before compression.

That caller shall supply a single page in a 2-entry SG list for
output to seed the operation.  The API will allocate more pages
if necessary and extend the SG list by chaining.

If there is an allocation failure the operation will stop and
partial results can be processed with the rest continued in a
new operation with an updated offset in the source SG list.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 152 ++++++++++++++++++++++++++--
 crypto/algapi.c                     |   3 +
 include/crypto/acompress.h          | 103 +++++++++++++++++--
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |  10 ++
 include/linux/crypto.h              |   3 +
 6 files changed, 263 insertions(+), 13 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..821de2010089 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -18,6 +18,7 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
@@ -234,7 +235,7 @@ static int acomp_do_nondma(struct acomp_req *req, bool comp)
 	return err;
 }
 
-static int acomp_do_one_req(struct acomp_req *req, bool comp)
+static int acomp_do_linear(struct acomp_req *req, bool comp)
 {
 	if (acomp_request_isnondma(req))
 		return acomp_do_nondma(req, comp);
@@ -244,9 +245,100 @@ static int acomp_do_one_req(struct acomp_req *req, bool comp)
 		      crypto_acomp_reqtfm(req)->decompress(req);
 }
 
+static void acomp_restore_cur(struct acomp_req *req)
+{
+	req->src->length += req->src->offset - req->chain.osoff;
+	req->src->offset = req->chain.osoff;
+}
+
+static void acomp_restore_unit(struct acomp_req *req)
+{
+	acomp_restore_cur(req);
+	req->src = req->chain.ossg;
+	req->dst = req->chain.odsg;
+	req->slen = req->chain.oslen;
+	req->dlen = req->chain.unit;
+	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_SEG;
+}
+
 static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
-	acomp_reqchain_virt(req);
+	if (!req->chain.unit) {
+		acomp_reqchain_virt(req);
+		goto out;
+	}
+
+	for (;;) {
+		unsigned int dlen = err ? 0 : req->dlen;
+		unsigned int todo = req->slen;
+		struct page *page = NULL;
+		struct scatterlist *sg;
+		unsigned int remain;
+
+		req->dst->dma_address = 0;
+		if (req->dst->length < dlen) {
+			dlen -= req->dst->length;
+			req->dst->dma_address = 1;
+			req->dst = sg_next(req->dst);
+		}
+		req->dst->length = dlen;
+
+		if (!(req->chain.slen -= todo))
+			break;
+
+		if (req->src->length > todo) {
+			req->src->length -= todo;
+			req->src->offset += todo;
+		}
+
+		remain = todo - req->src->length;
+		acomp_restore_cur(req);
+		req->src = sg_next(req->src);
+		req->chain.osoff = req->src->offset;
+		req->src->length -= remain;
+		req->src->offset += remain;
+
+		todo = min(req->chain.unit, req->chain.slen);
+		req->slen = todo;
+
+		remain = PAGE_SIZE - req->dst->offset - req->dst->length;
+		if (!sg_is_last(req->dst))
+			page = sg_page(req->dst + 1);
+		else if (remain < todo) {
+			page = alloc_page(GFP_ATOMIC);
+			if (!page)
+				break;
+		}
+
+		sg = kmalloc_array(2 - !remain + !!page,
+				   sizeof(*sg), GFP_ATOMIC);
+		if (!sg) {
+			__free_page(page);
+			break;
+		}
+
+		sg_unmark_end(req->dst);
+		sg_chain(req->dst, 2, sg);
+
+		sg_init_table(sg, !!remain + !!page);
+		if (remain)
+			sg_set_page(sg, sg_page(req->dst),
+				    remain, PAGE_SIZE - remain);
+		if (page)
+			sg_set_page(sg + !!remain, page, PAGE_SIZE, 0);
+
+		req->dst = sg;
+		req->dlen = todo;
+
+		err = crypto_acomp_reqtfm(req)->compress(req);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return err;
+	}
+
+	acomp_restore_unit(req);
+	err = 0;
+
+out:
 	acomp_restore_req(req);
 	return err;
 }
@@ -268,16 +360,61 @@ static void acomp_reqchain_done(void *data, int err)
 	compl(data, err);
 }
 
+void acomp_free_sgl(struct scatterlist *sg)
+{
+	struct page *page0;
+
+	page0 = sg_page(sg);
+	sg = sg_next(sg);
+	while (sg) {
+		struct scatterlist *nsg = sg_next(sg);
+		struct page *page = sg_page(sg);
+
+		if (page != page0)
+			__free_page(page);
+
+		kfree(sg);
+		sg = nsg;
+	}
+}
+EXPORT_SYMBOL_GPL(acomp_free_sgl);
+
 static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
+	unsigned int todo;
 	int err;
 
 	acomp_save_req(req, acomp_reqchain_done);
+	if (!acomp_request_isunit(req)) {
+		req->chain.unit = 0;
+		err = acomp_do_linear(req, comp);
+		goto out;
+	}
 
-	err = acomp_do_one_req(req, comp);
-	if (err == -EBUSY || err == -EINPROGRESS)
+	if (req->dst->offset || req->dst->length != PAGE_SIZE)
+		return -EINVAL;
+	if (!req->dlen)
+		return -EINVAL;
+
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_SEG;
+
+	req->chain.ossg = req->src;
+	req->chain.odsg = req->dst;
+	req->chain.oslen = req->slen;
+	req->chain.unit = req->dlen;
+
+	req->chain.osoff = req->src->offset;
+	req->chain.slen = req->slen;
+
+	todo = min(req->chain.unit, req->chain.slen);
+	req->slen = todo;
+	req->dlen = todo;
+
+	err = crypto_acomp_reqtfm(req)->compress(req);
+
+out:
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
-
 	return acomp_reqchain_finish(req, err);
 }
 
@@ -287,7 +424,8 @@ int crypto_acomp_compress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
-	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
+	if ((crypto_acomp_req_virt(tfm) || acomp_request_issg(req)) &&
+	    (crypto_acomp_req_seg(tfm) || !acomp_request_isunit(req)))
 		return crypto_acomp_reqtfm(req)->compress(req);
 	return acomp_do_req_chain(req, true);
 }
@@ -299,6 +437,8 @@ int crypto_acomp_decompress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+	if (acomp_request_isunit(req))
+		return -ENOSYS;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
 		return crypto_acomp_reqtfm(req)->decompress(req);
 	return acomp_do_req_chain(req, false);
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 532d3efc3c7d..88f63aac5b74 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -59,6 +59,9 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_priority < 0)
 		return -EINVAL;
 
+	if (alg->cra_flags & CRYPTO_ALG_REQ_SEG)
+		alg->cra_flags |= CRYPTO_ALG_REQ_VIRT;
+
 	refcount_set(&alg->cra_refcnt, 1);
 
 	return 0;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 9eacb9fa375d..0b503396fe5f 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -32,9 +32,13 @@
 /* Set this bit for if virtual address destination cannot be used for DMA. */
 #define CRYPTO_ACOMP_REQ_DST_NONDMA	0x00000010
 
+/* Set this bit if request source needs segmentation. */
+#define CRYPTO_ACOMP_REQ_SRC_SEG	0x00000020
+
 /* Private flags that should not be touched by the user. */
 #define CRYPTO_ACOMP_REQ_PRIVATE \
 	(CRYPTO_ACOMP_REQ_SRC_VIRT | CRYPTO_ACOMP_REQ_SRC_NONDMA | \
+	 CRYPTO_ACOMP_REQ_SRC_SEG | \
 	 CRYPTO_ACOMP_REQ_DST_VIRT | CRYPTO_ACOMP_REQ_DST_NONDMA)
 
 #define CRYPTO_ACOMP_DST_MAX		131072
@@ -50,7 +54,6 @@
 #define ACOMP_REQUEST_CLONE(name, gfp) \
 	acomp_request_clone(name, sizeof(__##name##_req), gfp)
 
-struct acomp_req;
 struct folio;
 
 struct acomp_req_chain {
@@ -59,12 +62,18 @@ struct acomp_req_chain {
 	struct scatterlist ssg;
 	struct scatterlist dsg;
 	union {
-		const u8 *src;
-		struct folio *sfolio;
-	};
-	union {
-		u8 *dst;
-		struct folio *dfolio;
+		struct {
+			const u8 *src;
+			u8 *dst;
+		};
+		struct {
+			struct scatterlist *ossg;
+			struct scatterlist *odsg;
+			unsigned int oslen;
+			unsigned int osoff;
+			unsigned int unit;
+			unsigned int slen;
+		};
 	};
 	u32 flags;
 };
@@ -357,10 +366,53 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 
 	req->base.flags &= ~(CRYPTO_ACOMP_REQ_SRC_VIRT |
 			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
+			     CRYPTO_ACOMP_REQ_SRC_SEG |
 			     CRYPTO_ACOMP_REQ_DST_VIRT |
 			     CRYPTO_ACOMP_REQ_DST_NONDMA);
 }
 
+/**
+ * acomp_request_set_src_unit() -- Sets source segmented scatterlist
+ *
+ * Sets source segmented scatterlist required by an acomp operation.
+ *
+ * This is only supported for compression.  The input will be
+ * segmented into units of the specified size, before being sent
+ * for compression.  The output can be retrieved from req->dst.
+ * Each entry in req->dst shall correspond to one input unit, unless
+ * acomp_sgl_split() returns true on that SG entry, in which case
+ * that entry and the next shall correspond to the same input unit.
+ * A zero-length entry in req->dst means that the corresponding input
+ * unit is incompressible.  If the number of entries in req->dst is
+ * less than the number of input units, then the rest were not
+ * processed due to a memory allocation failure.  The caller may
+ * retry the operation with an adjusted src offset.
+ *
+ * @req:	asynchronous compress request
+ * @src:	pointer to input buffer scatterlist
+ * @slen:	size of the input buffer
+ * @dst:	2-element scatterlist, first with a single page and the
+ *		second is reserved for chaining.
+ * @unit:	unit size
+ */
+static inline void acomp_request_set_src_unit(struct acomp_req *req,
+					      struct scatterlist *src,
+					      unsigned int slen,
+					      struct scatterlist dst[2],
+					      int unit)
+{
+	req->src = src;
+	req->slen = slen;
+	req->dst = dst;
+	req->dlen = unit;
+
+	req->base.flags &= ~(CRYPTO_ACOMP_REQ_SRC_VIRT |
+			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
+			     CRYPTO_ACOMP_REQ_DST_VIRT |
+			     CRYPTO_ACOMP_REQ_DST_NONDMA);
+	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_SEG;
+}
+
 /**
  * acomp_request_set_src_sg() -- Sets source scatterlist
  *
@@ -379,6 +431,7 @@ static inline void acomp_request_set_src_sg(struct acomp_req *req,
 
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_VIRT;
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_SEG;
 }
 
 /**
@@ -398,6 +451,7 @@ static inline void acomp_request_set_src_dma(struct acomp_req *req,
 	req->slen = slen;
 
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_SEG;
 	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_VIRT;
 }
 
@@ -418,6 +472,7 @@ static inline void acomp_request_set_src_nondma(struct acomp_req *req,
 	req->svirt = src;
 	req->slen = slen;
 
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_SEG;
 	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_NONDMA;
 	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_VIRT;
 }
@@ -441,6 +496,31 @@ static inline void acomp_request_set_src_folio(struct acomp_req *req,
 	acomp_request_set_src_sg(req, &req->chain.ssg, len);
 }
 
+/**
+ * acomp_request_set_src_folio_unit() -- Sets source segmented folio
+ *
+ * Sets source segmented folio required by an acomp operation.
+ *
+ * @req:	asynchronous compress request
+ * @folio:	pointer to input folio
+ * @off:	input folio offset
+ * @len:	size of the input buffer
+ * @dst:	2-element scatterlist, first with a single page and the
+ *		second is reserved for chaining.
+ * @unit:	unit size
+ */
+static inline void acomp_request_set_src_folio_unit(struct acomp_req *req,
+						    struct folio *folio,
+						    size_t off,
+						    unsigned int len,
+						    struct scatterlist dst[2],
+						    unsigned int unit)
+{
+	sg_init_table(&req->chain.ssg, 1);
+	sg_set_folio(&req->chain.ssg, folio, len, off);
+	acomp_request_set_src_unit(req, &req->chain.ssg, len, dst, unit);
+}
+
 /**
  * acomp_request_set_dst_sg() -- Sets destination scatterlist
  *
@@ -554,4 +634,13 @@ static inline struct acomp_req *acomp_request_on_stack_init(
 struct acomp_req *acomp_request_clone(struct acomp_req *req,
 				      size_t total, gfp_t gfp);
 
+/* True if the result entry spans two SG entries. */
+static inline bool acomp_sgl_split(struct scatterlist *sg)
+{
+	return !!sg->dma_address;
+}
+
+/* Free segmented SGL list returned in req->dst. */
+void acomp_free_sgl(struct scatterlist *sg);
+
 #endif
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 423e57eca351..8f29c636f644 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -260,6 +260,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index ffffd88bbbad..20b505d0a10a 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -154,6 +154,11 @@ static inline bool acomp_request_issg(struct acomp_req *req)
 				    CRYPTO_ACOMP_REQ_DST_VIRT));
 }
 
+static inline bool acomp_request_isunit(struct acomp_req *req)
+{
+	return req->base.flags & CRYPTO_ACOMP_REQ_SRC_SEG;
+}
+
 static inline bool acomp_request_src_isvirt(struct acomp_req *req)
 {
 	return req->base.flags & CRYPTO_ACOMP_REQ_SRC_VIRT;
@@ -191,6 +196,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b50f1954d1bb..ed1595e1eb0f 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -136,6 +136,9 @@
 /* Set if the algorithm supports virtual addresses. */
 #define CRYPTO_ALG_REQ_VIRT		0x00040000
 
+/* Set if the algorithm supports segmentation (implies REQ_VIRT). */
+#define CRYPTO_ALG_REQ_SEG		0x00080000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.5

