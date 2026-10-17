Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6892B370ACE
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253375; cv=none; b=saP+Q7kQT6hCiJDedsm5YPpGH8ZeJPxZMPwkO8OxRMX60VdBTI1KVdRbgu+dWFXi4ivc0kj+fUOhrsTcUsDqpnbG/kzatzsP5WocfgORQzkvTCJSjG+FOlxpcQOvlYhdacaVaroo4OYYe1QiNhRb2tRWLCYku8iVUB4v1nKmVl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253375; c=relaxed/simple;
	bh=/8mRaaZ/j2zdk8bq9uqX0iQ1DG1/wNjoQWAEFWh6r0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpAfU4KNcyrPjOw/zhi0vvBeJ5jujf1Qlpf9qT32F+AK3qMX4p32/2eKCQ01ylysgmZskLeP69/0PH4DZV9K5r+Q3Tu4PvlSZOS3UmyyN9Voegyr+TA9kophNGr1DAzGgG3d/HnWfUpDCQDoN1Fduo0/Ph3FFEZnWQRuVJbvpCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pSrAx+Hl; arc=none smtp.client-ip=95.215.58.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pSrAx+Hl"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/8mRaaZ/j2zdk8bq9uqX0iQ1DG1/wNjoQWAEFWh6r0I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792253371; v=1; x=1792858171;
 b=pSrAx+HljFnquieZoqWi8bGQ4FhCuqEWDGDSaYnEDTuijJDpTAnOQVcjeMdfL1Z7MPwp0zcc
 BuGJYzoKeXdp/6me6Vv2HRz8D/BuZCdzxmEEwT4tZS1jstLW1S08AY7e4FVOXtHAz5tmWhUvRB+
 TCYCuegsVeiHsVosmfql/OPI=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 79d4bf89d8171c02;
	Sat, 17 Oct 2026 16:09:31 +0000
X-Mizu-Trace-ID: 79d4bf89d8171c02
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 1/3] mm: zswap: use separate compression and decompression requests
Date: Sat, 17 Oct 2026 09:08:53 -0700
Message-ID: <20261017160918.2738626-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017160918.2738626-1-usama.arif@linux.dev>
References: <20261017160918.2738626-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stores and loads serialize on the same per-CPU acomp request and mutex.
A low-priority store can be preempted as soon as the compressor drops
its stream lock, while it still holds the mutex. A higher-priority load
on that CPU then waits until the store runs again, which can take a
long time when other tasks are runnable.

Give compression and decompression their own request, completion wait
and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
decompression APIs from zsmalloc"), the per-CPU buffer is only used for
compression, so group it with the compression request. Independent
requests can share the per-CPU transform; the codecs and drivers
synchronize their shared state internally. Loads can still wait for
each other on the decompression mutex, and stores still serialize on
the compression mutex.

On x86-64 without PREEMPT_RT or lock debugging, each pool's per-CPU
context grows from 88 to 160 bytes. Each initialized CPU also needs an
extra acomp request: 176 bytes plus the algorithm's request context,
before alignment and allocator rounding.

acomp_request_free() ignores NULL requests, so drop the check in
acomp_ctx_free().

This follows the proposal from Sergey Senozhatsky for the same split
for zram [1].

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 117 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 47 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced7..b23ef5f3bd529 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -137,14 +137,25 @@ bool zswap_never_enabled(void)
 * data structures
 **********************************/
 
-struct crypto_acomp_ctx {
-	struct crypto_acomp *acomp;
+struct zswap_acomp_req {
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
 	struct mutex mutex;
 };
 
+/* The compression mutex also protects the output buffer. */
+struct zswap_comp_ctx {
+	struct zswap_acomp_req areq;
+	u8 *buffer;
+};
+
+/* Separate requests, so that decompression does not wait for compression. */
+struct crypto_acomp_ctx {
+	struct crypto_acomp *acomp;
+	struct zswap_comp_ctx comp;
+	struct zswap_acomp_req decomp;
+};
+
 /*
  * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
  * The only case where lru_lock is not acquired while holding tree.lock is
@@ -270,14 +281,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	if (!acomp_ctx)
 		return;
 
-	/*
-	 * If there was an error in allocating @acomp_ctx->req, it
-	 * would be set to NULL.
-	 */
-	if (acomp_ctx->req)
-		acomp_request_free(acomp_ctx->req);
-
-	acomp_ctx->req = NULL;
+	acomp_request_free(acomp_ctx->comp.areq.req);
+	acomp_ctx->comp.areq.req = NULL;
+	acomp_request_free(acomp_ctx->decomp.req);
+	acomp_ctx->decomp.req = NULL;
 
 	/*
 	 * We have to handle both cases here: an error pointer return from
@@ -289,8 +296,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->buffer);
-	acomp_ctx->buffer = NULL;
+	kfree(acomp_ctx->comp.buffer);
+	acomp_ctx->comp.buffer = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -796,6 +803,28 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
+static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
+				struct crypto_acomp *acomp)
+{
+	/* acomp_request_alloc() returns NULL in case of an error. */
+	areq->req = acomp_request_alloc(acomp);
+	if (!areq->req)
+		return -ENOMEM;
+
+	crypto_init_wait(&areq->wait);
+
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &areq->wait);
+
+	mutex_init(&areq->mutex);
+	return 0;
+}
+
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
@@ -811,8 +840,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return 0;
 	}
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
+	acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->comp.buffer)
 		return ret;
 
 	/*
@@ -827,27 +856,18 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	/* acomp_request_alloc() returns NULL in case of an error. */
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		goto fail;
-	}
-
-	crypto_init_wait(&acomp_ctx->wait);
+	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
+	if (ret)
+		goto req_fail;
 
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &acomp_ctx->wait);
+	ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
+	if (ret)
+		goto req_fail;
 
-	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
+req_fail:
+	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
@@ -856,7 +876,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 static bool zswap_compress(struct folio *folio, long index,
 			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
+	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
@@ -865,15 +885,16 @@ static bool zswap_compress(struct folio *folio, long index,
 	u8 *dst;
 	bool mapped = false;
 
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&comp_ctx->areq.mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = comp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(comp_ctx->areq.req, &input, &output,
+				 PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -885,10 +906,12 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * existing method to send the second page before the first page is done
 	 * in one thread doing zswap.
 	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * acomp instance, and compression and decompression use separate
+	 * requests, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
+				   &comp_ctx->areq.wait);
+	dlen = comp_ctx->areq.req->dlen;
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
@@ -932,7 +955,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&comp_ctx->areq.mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -948,7 +971,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		return false;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -965,15 +988,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->req, input, &output,
+		acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
 					 entry->length, PAGE_SIZE);
-		ret = crypto_acomp_decompress(acomp_ctx->req);
-		ret = crypto_wait_req(ret, &acomp_ctx->wait);
-		dlen = acomp_ctx->req->dlen;
+		ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
+		ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
+		dlen = acomp_ctx->decomp.req->dlen;
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&acomp_ctx->decomp.mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
-- 
2.53.0-Meta

