Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A8B4F4733
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484132; cv=none; b=sg9N1pphz7Ru4DjOSFyi4UUiXRxRYtkuAt54uR9eysFerCR+2Sxz5Jt+nuQF0J4xwtXtRiN+S5ucSjIrL/IGwGeVONwk5xAecV+gTTaPPMx6DQ6M+ap4XXHMz3WKLwKPSGnlCyfvoFKRxZX7cYMP61+/iel3+gAJzQoxFUhmB9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484132; c=relaxed/simple;
	bh=I/KMlFcBpDQ6cvFW26sdNmoLCDtfPbZTnFoRaZbboGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GNnuu+6Q3b11s2oXrVwzR2oseYnwnrZWDKx1eT5q8SVniRPKcxBOsNG1CU+Pb05G5tZNmGYnp5PRHpck/LM8r/MOOX+KVU9qaN2WAzuQOPEjj3KxAkM1M9DJgLfydQcyRFj0zE73MxH7ynyvC9k0fzRG8Eq/h0BD4SgyZe4v8w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xrk4vvW8; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xrk4vvW8"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-15dd124bbe7so4562642c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484119; x=1792088919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u2OI/ckXOKrTLzy1Cin641QZA3UIenqp9jT2sv5HRIg=;
        b=Xrk4vvW8LfghTKs2o81jr+WJhFgDCFjDipxpWvAYPWcDB4cQEKzPG162e9Ha97iwML
         vhyEeAVnxlta1y57sIH0oPHplvEDOY5ZRnywWx9OPQYJTbHRouLQMxhmlHYghvYhk+ZQ
         0vLzh6ClLnZ2oqvyKRvRNvN5A6vk83GiH7K7pdniUtYe/DMByT7OOgQrTuMGIwKV2HbX
         EMYSzVYilz0VBCsiHj0Gw820rtl96MOpanPJQyIGRD5XElCWs14tzQdsTxgLW9rpWO5Z
         9Qts6bL7EnkoCMOSTaDeFQnmJhtbE9QBovqdT9Tyve2CVvU92YV4dboSS5JEqBoEdU6q
         7GYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484119; x=1792088919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u2OI/ckXOKrTLzy1Cin641QZA3UIenqp9jT2sv5HRIg=;
        b=05AGOsK60jtrZptMU1JAESYX392mjjMqUoC7GgMztv+S5lRHm+08VhBeD+uZEEEEsj
         /hscZbet4azd7HkixUeUFFqichL1blKNYO1WxODAIVbUrQp6N+HprhsIU8HxPa2islzP
         Oiuc/ig0qQFSAjNoRQ8T0SWxYH7Py1efycr1vGgCTrRNYH5n6DTq5cg4pXcGNk9iWad4
         IeWjsfXizFac8D88CIwUTv4RoIw6xjJA/6PEH+p47wTjBTeyp+/VH6e/LTHGhtqM9tnP
         d1+kWKL7R1xMs95PLgkPcJ7XfCcshUdSE1V1edXo9gOhtQSU+dHbvjiR+Se4Il675TwH
         jFrg==
X-Forwarded-Encrypted: i=1; AKwUvByxWpNFbTq659lO49CQpv4f3kBQ6sKkN2BffYHRLjRvOLmue1KSG2RMy+UmGy+QOx2F3dl5fXMvhxkYL8I=@vger.kernel.org
X-Gm-Message-State: AFuF++ldWQteWL/iRTjuyPNJOCHTDGShEQ9I07tP6a2JftW3oLUwFHfa
	bN+FT1PIynaHgGx+BoHgtLhmdiJ3w6DhXeUgwP92phMhszh6gaUI2hfB
X-Gm-Gg: AYBFou2UvQzq4LI77vEFxDUxJjuNISPq+ocgSimcaTeqdycSTZsmPGhh6WlXpHB3fdi
	JUSxpcNHfJR9YHtQQ7URw50YTtB6kFdz0xHsP3+76MoFlnco3GnsR5w8hfLNn22rGbXVgRxQbrr
	/TCvILeSGgjeNEn+nQ9GPM6pF8X5PkDpEBMCSI7Wzmp1wsAWPz/JmAb5ImXkwqKwwvXRuZlkjl5
	iWu9PQd6HUaIFFjfmMtONtSe2/bAXH3B6z5EHHRGH2O8kxBrFaBH774fe96dEFxyopLwW8SfuH8
	5qkZNeakFRO8DY8QHb9jzWWRLr/kOlOo0pnDl63dD7eSIRGDT8akpFsTf2apYrD/1F/5bg7uiRt
	Q2vhNHzDdOJ6k1VlKoUE8uRQQthCvl9jiliJ7ofGlJeSF0RKrCEIQSUsAuH3m3CwmZiivH8kv71
	iVWV9Yz76yue3c+e2Orscfry4SN6KAh/WT5WLj8Xuqfe5fxtKzAaCXGF0k7NKsZ7c4plUnm7+cS
	QmaRSj4DCY=
X-Received: by 2002:a05:701b:2910:b0:14a:fe37:cdf0 with SMTP id a92af1059eb24-16209f0e977mr6962414c88.45.1791484118889;
        Thu, 08 Oct 2026 11:28:38 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:38 -0700 (PDT)
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
Subject: [PATCH v1 8/8] mm: zswap: Batched zswap_compress() for storing large folios in batches.
Date: Thu,  8 Oct 2026 11:28:14 -0700
Message-Id: <20261008182814.27450-9-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
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

Performance data: usemem with 60% over-commit:
==============================================
This patch series was tested on a Chromebook with a QEMU "vng" VM
running in Crostini.

Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 4 (E-Cores: 4,5,6,7)

zswap compressor:
  ZSTD

mTHP enabled:
  64kB

vm-scalability/usemem setup:
  cgroup memory.high: 3G
  4 usemem processes, each allocates 1200M anonymous memory, reads the
  Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
  writes to each unsigned long in the 1200M, sleeps for 10 sec, then
  exits.

 usemem metrics averaged across 10 iterations*:
 ================================================

 --------------------------------------------------------------------------
                                          Baseline       Patch     Change
                                       mm-unstable      series       with
                                         10-3-2026          v1         v1
 --------------------------------------------------------------------------
 Average Throughput (KB/s)                  11,794      17,810    +51.00%
 Total Throughput (KB/s)                    47,179      71,242    +51.00%
 Average Time to Free Memory (usecs)       490,973     294,920    -39.93%
 Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.93%
 --------------------------------------------------------------------------
 * vmstats are as reported at the end of the 10th iteration:
 64kB-alloc                                834,567     828,199     -0.76%
 64kB-zswpout                              700,138     743,697      6.22%
 64kB-swpout-fallback                       35,342      17,978    -49.13%
 64kB-swpout                                     0           0
 --------------------------------------------------------------------------

 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim, more mTHP zswpouts and the cycle
 continues. As the data demonstrates, this directly contributes to more memory
 over-commit opportunity.

Architectural considerations for the zswap batching framework:
==============================================================
The zswap batching framework is designed to be hardware-agnostic.
It can be leveraged by any hardware accelerator or software-based
compressor.

Potential future clients of the batching framework:
===================================================
This patch-series demonstrates the performance benefits of compression
batching when used in zswap_store() of large folios. Compression
batching can be used for other use cases such as batching compression in
zram, batch compression of different folios during reclaim, kcompressd,
file systems, etc. Decompression batching can be used to improve
efficiency of zswap writeback (Thanks Nhat for this idea), batching
decompressions in zram, etc.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798
[2]: https://wanos.co/assets/silesia.tar

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 250 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 187 insertions(+), 63 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ade84ac4076e..68748349c3ae 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -145,6 +145,7 @@ struct crypto_acomp_ctx {
 	struct acomp_req *req;
 	struct crypto_wait wait;
 	u8 **buffers;
+	struct sg_table *sg_table;
 	struct mutex mutex;
 };
 
@@ -308,6 +309,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 		kfree(acomp_ctx->buffers);
 	}
 	acomp_ctx->buffers = NULL;
+
+	if (acomp_ctx->sg_table) {
+		sg_free_table(acomp_ctx->sg_table);
+		kfree(acomp_ctx->sg_table);
+	}
+	acomp_ctx->sg_table = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -849,6 +856,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -899,6 +907,21 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 			goto fail;
 	}
 
+	acomp_ctx->sg_table = kmalloc(sizeof(*acomp_ctx->sg_table), GFP_KERNEL);
+	if (!acomp_ctx->sg_table)
+		goto fail;
+
+	if (sg_alloc_table(acomp_ctx->sg_table, pool->compr_batch_size,
+			   GFP_KERNEL))
+		goto fail;
+
+	/*
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists; crucial for performance.
+	 */
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
+
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -923,85 +946,184 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool,
-			   bool wb_enabled)
+/*
+ * The inner compress batching and pool storage function.
+ */
+static bool __zswap_compress(struct folio *folio,
+			     long folio_start,
+			     u8 batch_start,
+			     u8 nr_batch_pages,
+			     struct crypto_acomp_ctx *acomp_ctx,
+			     struct zswap_entry *entries[],
+			     struct zswap_pool *pool,
+			     int nid,
+			     bool wb_enabled)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	unsigned int slen = nr_batch_pages * PAGE_SIZE;
+	u8 batch_iter, comp_batch_iter;
+	struct scatterlist *sg;
 	unsigned long handle;
-	gfp_t gfp;
+	int err, dlen;
 	u8 *dst;
-	bool mapped = false;
 
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	/*
+	 * @slen indicates the total source length bytes for
+	 * @nr_batch_pages.
+	 *
+	 * The source folio pages in the batch are directly submitted to
+	 * crypto_acomp via acomp_request_set_src_folio().
+	 *
+	 * The pool's compressor batch size is at least @nr_batch_pages,
+	 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
+	 */
+	acomp_request_set_src_folio(acomp_ctx->req, folio,
+				    (folio_start + batch_start) * PAGE_SIZE,
+				    slen);
+
+	acomp_ctx->sg_table->sgl->length = slen;
 
-	dst = acomp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
+	/*
+	 * The per-CPU @acomp_ctx->sg_table scatterlists are statically
+	 * mapped to the per-CPU dst @buffers at pool creation time.
+	 */
+	acomp_request_set_dst_sg(acomp_ctx->req,
+				 acomp_ctx->sg_table->sgl,
+				 slen);
 
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+			      &acomp_ctx->wait);
 
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
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * If a page cannot be compressed into a size smaller than
+	 * PAGE_SIZE, save the content as is without a compression, to
+	 * keep the LRU order of writebacks.  If writeback is disabled,
+	 * reject the page since it only adds metadata overhead.
+	 * swap_writeout() will put the page back to the active LRU list
+	 * in the case.
+	 *
+	 * It is assumed that any compressor that sets the output length
+	 * to 0 or a value >= PAGE_SIZE will also return a negative
+	 * error status in @err; i.e, will not return a successful
+	 * compression status in @err in this case.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	if (unlikely(err && !wb_enabled))
+		goto compress_error;
 
 	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
+	 * the @sg->length should be set to either the page's compressed
+	 * length (success), or it's negative value compression error.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		if (!wb_enabled) {
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
-			goto unlock;
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
+		    comp_batch_iter) {
+		batch_iter = batch_start + comp_batch_iter;
+		dst = acomp_ctx->buffers[comp_batch_iter];
+		dlen = sg->length;
+
+		if (unlikely(dlen <= 0 || dlen >= PAGE_SIZE)) {
+			dlen = PAGE_SIZE;
+			dst = kmap_local_folio(folio,
+					(folio_start + batch_iter) * PAGE_SIZE);
 		}
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_folio(folio, index * PAGE_SIZE);
-		mapped = true;
+
+		handle = zs_malloc(pool->zs_pool, dlen, gfp, nid);
+
+		if (unlikely(IS_ERR_VALUE(handle))) {
+			if (PTR_ERR((void *)handle) == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_alloc_fail++;
+
+			if (dst != acomp_ctx->buffers[comp_batch_iter])
+				kunmap_local(dst);
+
+			return false;
+		}
+
+		zs_obj_write(pool->zs_pool, handle, dst, dlen);
+		entries[batch_iter]->handle = handle;
+		entries[batch_iter]->length = dlen;
+		if (dst != acomp_ctx->buffers[comp_batch_iter])
+			kunmap_local(dst);
 	}
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
+	return true;
+
+compress_error:
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
+		    comp_batch_iter) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+	return false;
+}
 
-unlock:
-	if (mapped)
-		kunmap_local(dst);
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
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
+static bool zswap_compress(struct folio *folio,
+			   long folio_start,
+			   u8 nr_pages,
+			   u8 nr_batch_pages,
+			   struct zswap_entry *entries[],
+			   struct zswap_pool *pool,
+			   int nid,
+			   bool wb_enabled)
+{
+	struct crypto_acomp_ctx *acomp_ctx;
+	bool ret = true;
+	u8 batch_start;
+
+	/*
+	 * Locking the acomp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
+	/*
+	 * Compress the @nr_pages in @folio starting at index @folio_start
+	 * in batches of @nr_batch_pages.
+	 */
+	for (batch_start = 0; batch_start < nr_pages;
+	     batch_start += nr_batch_pages) {
+		/*
+		 * Send @nr_batch_pages to crypto_acomp for compression:
+		 *
+		 * These pages are in @folio's range of indices in the interval
+		 *     [@folio_start + @batch_start,
+		 *      @folio_start + @batch_start + @nr_batch_pages).
+		 */
+		ret = __zswap_compress(folio, folio_start, batch_start,
+				       nr_batch_pages, acomp_ctx, entries,
+				       pool, nid, wb_enabled);
+		if (unlikely(!ret))
+			break;
+	}
 
 	mutex_unlock(&acomp_ctx->mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+	return ret;
 }
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
@@ -1519,6 +1641,7 @@ static bool zswap_store_pages(struct folio *folio,
 {
 	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
 	u8 i, store_fail_idx = 0, nr_pages = end - start;
+	bool ret;
 
 	VM_WARN_ON_ONCE(nr_pages <= 0 || nr_pages > ZSWAP_MAX_BATCH_SIZE);
 
@@ -1545,10 +1668,11 @@ static bool zswap_store_pages(struct folio *folio,
 		INIT_LIST_HEAD(&entries[i]->lru);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		if (!zswap_compress(folio, start + i, entries[i], pool, wb_enabled))
-			goto store_pages_failed;
-	}
+	ret = zswap_compress(folio, start, nr_pages,
+			     min(nr_pages, pool->compr_batch_size),
+			     entries, pool, nid, wb_enabled);
+	if (unlikely(!ret))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		struct zswap_entry *old, *entry = entries[i];
-- 
2.39.5

