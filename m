Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156727;
	b=cS3GqZqFuKYadK05rfQJOf8vTfxdmCE4thqD7jGeL/ZcSuVbk5+o85QJFmPjUN2Ld0Z0
	 3CgnkY4dxV7bMdm/TcswwQyJCUqZ6qE9ucfxzGMY+iInAvhm6/QhsSgLx854T7YQryzcI
	 Mq+iRBR4XNNrunIa7vQJ1/Wi52F+j5sdSM2RYqDSsAbPArchiWBg/MjbjHNv8R+U8wt/q
	 uoogV0K0Fby3L1IDQAoZ9c4R7lacIUPvkKH2elhwRlXFKDx6HfmvISyjvu4TkuWquIUoH
	 t66uvyf4jH7oYq4hIypHnaxUJOFuH7Q49KWXPtXUDEis5pwUqFXKIkOlva2fOWRhMxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156727;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AvcrC01525OQBRfQntsOStl5llkVzHtEkp+xwSz9Rzo=;
	b=0EXms+EKUsa4I4m314xldt40x2afHe1JzBYUqVA3rJbDovfzfLO1ESNBtFUEizvsUxLy
	 xi+G6nSJbtdgcCsBfslDd4n84696axeYTgz9GWaVIBZM8nKlFsWqCQ4FhS0waxySv8UOX
	 ane8k76Mkawid/A3wB6sQCJxA6DOtZcue7UCHOZZ8Et9JBdF6CVhtkz19grLQRpKTLyX1
	 JxEto2Kt5lxjzHkHo5kedFXjunkDzsOCI19SxhulKzUmr6J+vdxjEcnBkjnfGFNNL7oio
	 pDXpTHE/H/mDyD71h9hlWbCZIrqYznj8XeEaKkVfl8bx0lCWuma+oDbi3LupbABG+dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vp8nGbG1;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D041560A2601
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D041560A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vp8nGbG1
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-156cbe59622so570346c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156721; x=1793761521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AvcrC01525OQBRfQntsOStl5llkVzHtEkp+xwSz9Rzo=;
        b=vp8nGbG1lEZz7Glf0FJklJYcSKMR3wstOAehcbMrl0UsBxLCS1r5JCvwR2AzdPzckN
         EP7hI+z0eib1vI4ToijN6BtTXUR471jNidRilEPTWQf/SAbXKvfnNqreldX2daQFprIR
         WyYc1/kJjP/xT49YiKXYlhpKHWWKXcmyotxs39mMU/TYRcR08JmY6ozacZzwQnHt+IJu
         ykXHd1rV3565v3mDvfQwSkdgMNyPMozgjkMHijM2QdpvobFr4w1eqK60HUbez+hmPyUi
         OYfYGQmCIQpziJ2lL2wWdHK6we8uY1urC49Vs+Rp4Ixm2VEmeWMuQtcmB0dtAMFU4TnT
         rz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156721; x=1793761521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AvcrC01525OQBRfQntsOStl5llkVzHtEkp+xwSz9Rzo=;
        b=2JhsiCW1N+lWsmzEB9lmNEv6LENlot+Czwu+se/1FpK+48aHRF9c0VaATOJptDHVE3
         MFxhDDS0nh6cvcHWvc+tBKmRB5/j0XIfFkUzIykEprXULMP4Z2OAVxCH8NDIkUYoqOed
         5RFtRxeDrKMm1n7UzRgbXFsQ9PSUlxhU/3P35PGzGUaPUN1EMinr8C0qG7l2+2nNLCmo
         12BWuCbQq1773PA2nQ3Cc28ZOSLnbKhgspWK7gjqkEwv7ydS8uvnH7fp1Ek5OudzZ22d
         hAQjdGehMjmJ8nFy1PB+yb34spIFaRteBMiBDprrDuz6t4Co/CgtIzT0tH9m38Uyqipj
         9FJA==
X-Forwarded-Encrypted: i=1; AKwUvBwod7Kj9G3lT2dM04l4leAN7lBKUygeqwU9wijX7lIwnjdrmcaiZziC+Ed/KssM11IGsgJOczBt9oujbdo=@vger.kernel.org
X-Gm-Message-State: AFq9FYI/4O3oBMhLCnPzrZrHS0dC/Z/G0u/6sDnZH3tiU/eYyvL46Lye
	NkoIHkJi+qfbeFTDzzj0e9tb+FHfENcaZfvU5avxQq3PQK/yNjEQmnP+
X-Gm-Gg: AYBFou2Qe3qV0HR0F/GfuLEX3+jtbvVl3TAu7Omd4NBnpwOC7ymYQUV6JM2to33CDHS
	9ekXbUEOSSX1GQYBwDg2a0KI2nWz+P3l4qx6D8WFparxORK9MvnhoiFSIrWi7xqsfXd2JvVVO5f
	2T5AAPgRCz+nI/7oKU6oX9ToGT/eoZ9Hz0reVlsUFsq1O3Di1B9U2PK/+kQMawB88YzW8DBBJYq
	pQ0WdJTChyRBtBRpvPgBOZHFJTp0tLOrbWL+yTVm7h8BCdlA2rRwOIOHZqWmrS7Rarb5Wv3VAh0
	+6hMYEkaTjFndPRxUyHxPcvHsMt7/T+rAHOj0VFcu9p1OvVnwfAdnjvtEfr5cxLJ2+w7Fb/KsUC
	5Ls5Mzi7xLgvCVKPrKwo+0dG90E+oW0u43TfTAc4HmSZNxbWnzzQf5H3abwqoG+WmnggpWG+rlU
	2PrfLF3u7e3MKevdFm646VDKtvuO29wqHHgr2oA3xvyftMWVrx8ACdlT+CB88Ba3hJ2lNV0+7+8
	prsct2/7gEpo1Cm6op2OHIm34Q45hjoSBPs5U0/ADqqvPZdKmPI+5vnGCL68epwgXa4AdbAgjey
	eXT88oWsPrcfIWaO6Fj2GRVcAT5/yHrN6anGfoyvPQ==
X-Received: by 2002:a05:701b:2707:b0:1a0:e3e2:22a3 with SMTP id a92af1059eb24-1a6d0d531a3mr1378775c88.31.1793156720784;
        Tue, 27 Oct 2026 20:05:20 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:20 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v2 7/8] mm: zswap: Batched zswap_compress() for storing large folios in batches.
Date: Tue, 27 Oct 2026 20:05:02 -0700
Message-Id: <20261028030503.17923-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new batching implementation of zswap_compress() is provided for
compressors that do and do not support batching. This eliminates code
duplication and facilitates code maintainability with the introduction
of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

If the compressor does not support batching, each page in the batch is
compressed and stored sequentially.

If the batch is compressed without errors, the compressed buffers for
the batch are stored in zsmalloc. In case of compression errors, the
current behavior based on whether the folio is enabled for zswap
writeback, is preserved.

The batched zswap_compress() incorporates Herbert's suggestion for
SG lists to represent the batch's inputs/outputs to interface with the
crypto API [1].

The struct zswap_store_context is extended to facilitate passing
batching related constraints and data to zswap_compress(). The code that
allocates zsmalloc memory to store compression results is refactored
into a new routine, zswap_update_entries(). Subsequent patches will be
submitted to further optimize this phase by replacing zsmalloc with
the SLUB allocator to improve zswap_store()/zswap_load() latencies.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 271 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 189 insertions(+), 82 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c8890e8a9b83..4476fb4aeb5f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -150,6 +150,7 @@ struct zswap_acomp_req {
 struct zswap_comp_ctx {
 	struct zswap_acomp_req areq;
 	u8 **buffers;
+	struct sg_table *sg_table;
 };
 
 /* Separate requests, so that decompression does not wait for compression. */
@@ -235,9 +236,13 @@ struct zswap_entry {
 struct zswap_store_context {
 	struct folio *folio;
 	long folio_start;
+	unsigned int slen;
+	u8 nr_batch_pages;
 	bool wb_enabled;
 	int nid;
 	u8 nr_pages;
+	struct zs_pool *zs_pool;
+	struct zswap_comp_ctx *comp_ctx;
 	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
 };
 
@@ -325,6 +330,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 		kfree(acomp_ctx->comp.buffers);
 	}
 	acomp_ctx->comp.buffers = NULL;
+
+	if (acomp_ctx->comp.sg_table) {
+		sg_free_table(acomp_ctx->comp.sg_table);
+		kfree(acomp_ctx->comp.sg_table);
+	}
+	acomp_ctx->comp.sg_table = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -898,6 +909,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -944,6 +956,21 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 			goto req_fail;
 	}
 
+	acomp_ctx->comp.sg_table = kmalloc(sizeof(*acomp_ctx->comp.sg_table), GFP_KERNEL);
+	if (!acomp_ctx->comp.sg_table)
+		goto req_fail;
+
+	if (sg_alloc_table(acomp_ctx->comp.sg_table, pool->compr_batch_size,
+			   GFP_KERNEL))
+		goto req_fail;
+
+	/*
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists; crucial for performance.
+	 */
+	for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
+
 	/* Skip the per-CPU request when decompression can use the stack. */
 	if (acomp_is_async(acomp_ctx->acomp)) {
 		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
@@ -960,92 +987,161 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool,
-			   bool wb_enabled)
+static bool zswap_update_entries(struct zswap_store_context *zc,
+				 u8 batch_start)
 {
-	struct zswap_comp_ctx *comp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	u8 i, batch_iter, comp_batch_iter;
 	unsigned long handle;
-	gfp_t gfp;
+	unsigned int dlen;
 	u8 *dst;
-	bool mapped = false;
-
-	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
-	mutex_lock(&comp_ctx->areq.mutex);
-
-	dst = comp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
-
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(comp_ctx->areq.req, &input, &output,
-				 PAGE_SIZE, dlen);
 
 	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zswap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, and compression and decompression use separate
-	 * requests, so multiple threads can do (de)compression in parallel.
+	 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
+	 * the @sg->length should be set to either the page's compressed
+	 * length (success), or it's negative value compression error.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
-				   &comp_ctx->areq.wait);
-	dlen = comp_ctx->areq.req->dlen;
-	if (!comp_ret) {
-		if (dlen == PAGE_SIZE)
-			comp_ret = -ENOSPC;
-		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
-			comp_ret = -EINVAL;
+	for (comp_batch_iter = 0; comp_batch_iter < zc->nr_batch_pages;
+	     ++comp_batch_iter) {
+		batch_iter = batch_start + comp_batch_iter;
+		dlen = zc->entries[batch_iter]->length;
+		handle = zs_malloc(zc->zs_pool, dlen, gfp, zc->nid);
+
+		if (unlikely(IS_ERR_VALUE(handle))) {
+			if (PTR_ERR((void *)handle) == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_alloc_fail++;
+
+			for (i = 0; i < comp_batch_iter; ++i)
+				zs_free(zc->zs_pool, zc->entries[batch_start + i]->handle);
+
+			return false;
+		}
+
+		zc->entries[batch_iter]->handle = handle;
+
+		if (likely(dlen < PAGE_SIZE)) {
+			dst = zc->comp_ctx->buffers[comp_batch_iter];
+			zs_obj_write(zc->zs_pool, handle, dst, dlen);
+		} else {
+			dst = kmap_local_folio(zc->folio,
+					(zc->folio_start + batch_iter) * PAGE_SIZE);
+			zs_obj_write(zc->zs_pool, handle, dst, dlen);
+			kunmap_local(dst);
+		}
 	}
 
+	return true;
+}
+
+/*
+ * zswap_compress() batching implementation for sequential and batching
+ * compressors.
+ *
+ * Description:
+ * ============
+ * Compress multiple @nr_pages in @folio starting from the @folio_start index
+ * in batches of @nr_batch_pages; the latter representing the lesser of the
+ * @nr_pages to be batch compressed and the compressor's batch size.
+ *
+ * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
+ * support batching.
+ *
+ * If @nr_batch_pages is 1, each page is processed sequentially.
+ *
+ * If @nr_batch_pages is > 1, the compressor may use batching to optimize
+ * compression.
+ */
+static bool zswap_compress(struct zswap_store_context *zc)
+{
+	u8 batch_start, comp_batch_iter, batch_iter;
+	struct scatterlist *sg;
+	bool ret;
+	int err;
+
 	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * Compress the @nr_pages in @folio starting at index @folio_start
+	 * in batches of @nr_batch_pages.
 	 */
-	if (comp_ret) {
-		if (!wb_enabled)
-			goto unlock;
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_folio(folio, index * PAGE_SIZE);
-		mapped = true;
-	}
+	for (batch_start = 0; batch_start < zc->nr_pages;
+	     batch_start += zc->nr_batch_pages) {
+		/*
+		 * Send @nr_batch_pages to crypto_acomp for compression:
+		 *
+		 * These pages are in @folio's range of indices in the interval
+		 *     [@folio_start + @batch_start,
+		 *      @folio_start + @batch_start + @nr_batch_pages).
+		 *
+		 * @slen indicates the total source length bytes for
+		 * @nr_batch_pages.
+		 *
+		 * The source folio pages in the batch are directly submitted to
+		 * crypto_acomp via acomp_request_set_src_folio().
+		 *
+		 * The pool's compressor batch size is at least @nr_batch_pages,
+		 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
+		 */
+		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
+				(zc->folio_start + batch_start) * PAGE_SIZE,
+				zc->slen);
+
+		zc->comp_ctx->sg_table->sgl->length = zc->slen;
+
+		/*
+		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
+		 * mapped to the per-CPU dst @buffers at pool creation time.
+		 */
+		acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
+					 zc->comp_ctx->sg_table->sgl, zc->slen);
+
+		err = crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
+				      &zc->comp_ctx->areq.wait);
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
+		/*
+		 * If a page cannot be compressed into a size smaller than
+		 * PAGE_SIZE, save the content as is without a compression, to
+		 * keep the LRU order of writebacks.  If writeback is disabled,
+		 * reject the page since it only adds metadata overhead.
+		 * swap_writeout() will put the page back to the active LRU list
+		 * in the case.
+		 *
+		 * It is assumed that any compressor that sets the output length
+		 * to 0 or a value >= PAGE_SIZE will also return a negative
+		 * error status in @err; i.e, will not return a successful
+		 * compression status in @err in this case.
+		 */
+		if (unlikely(err && !zc->wb_enabled))
+			goto compress_error;
+
+		for_each_sg(zc->comp_ctx->sg_table->sgl, sg,
+			    zc->nr_batch_pages, comp_batch_iter) {
+			batch_iter = batch_start + comp_batch_iter;
+			if (unlikely(sg->length <= 0 || sg->length >= PAGE_SIZE))
+				sg->length = PAGE_SIZE;
+
+			zc->entries[batch_iter]->length = sg->length;
+		}
+
+		ret = zswap_update_entries(zc, batch_start);
+		if (unlikely(!ret))
+			return false;
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+	return true;
 
-unlock:
-	if (mapped)
-		kunmap_local(dst);
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
-
-	mutex_unlock(&comp_ctx->areq.mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+compress_error:
+	for_each_sg(zc->comp_ctx->sg_table->sgl, sg,
+		    zc->nr_batch_pages, comp_batch_iter) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
+
+	return false;
 }
 
 static bool __zswap_decompress(struct zswap_entry *entry,
@@ -1582,6 +1678,7 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			      struct obj_cgroup *objcg)
 {
 	u8 i, store_fail_idx = 0;
+	bool ret;
 
 	zc->nr_pages = end - start;
 	zc->folio_start = start;
@@ -1596,7 +1693,6 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 	 * minimize potential cache misses.
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
-		zc->entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
 		/*
 		 * Set pool_idx before the xa_store() below publishes the entry, or a
 		 * concurrent reader could resolve a stale pool_idx left by slab reuse
@@ -1611,11 +1707,19 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		INIT_LIST_HEAD(&zc->entries[i]->lru);
 	}
 
-	for (i = 0; i < zc->nr_pages; ++i) {
-		if (!zswap_compress(zc->folio, zc->folio_start + i,
-				    zc->entries[i], pool, zc->wb_enabled))
-			goto store_pages_failed;
-	}
+	/*
+	 * Locking the comp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&zc->comp_ctx->areq.mutex);
+
+	ret = zswap_compress(zc);
+
+	mutex_unlock(&zc->comp_ctx->areq.mutex);
+
+	if (unlikely(!ret))
+		goto compress_failed;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
 		struct zswap_entry *old, *entry = zc->entries[i];
@@ -1681,11 +1785,10 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
-		if (!IS_ERR_VALUE(zc->entries[i]->handle))
-			zs_free(pool->zs_pool, zc->entries[i]->handle);
-	}
+	for (i = store_fail_idx; i < zc->nr_pages; ++i)
+		zs_free(pool->zs_pool, zc->entries[i]->handle);
 
+compress_failed:
 	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
 				       zc->nr_pages - store_fail_idx);
 
@@ -1757,6 +1860,10 @@ bool zswap_store(struct folio *folio)
 	store_batch_size = (pool->compr_batch_size > 1) ?
 			    pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
 
+	zc.nr_batch_pages = pool->compr_batch_size;
+	zc.slen = zc.nr_batch_pages * PAGE_SIZE;
+	zc.zs_pool = pool->zs_pool;
+
 	for (start = 0; start < nr_pages; start += store_batch_size) {
 		end = min(start + store_batch_size, nr_pages);
 
-- 
2.39.5

