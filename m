Received: from mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3476518125
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904256; cv=none; b=c2V1gSbQg+l/NIFbB4/El1s48s6LUh+0K/vwYmsDsKHmzu27hWAy7EcnhgTjlBoHqY/nzdY0rpmGvDr21eRJxloX2Yntmsah7nDhNnt98N6z1dB5DRrBKOuNtzXULYlvpqpLSulBaeafeP4z7Sx9NGKSpD2by5mmG1riqftK8J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904256; c=relaxed/simple;
	bh=Llw0nThjK60jUx/vxsW20gdWbzulx+k6ywgPWEsNcNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR56txPq3gpLAe1KIWM+Owob3GaEb94KlmNLypYINKRtXIrp+ncScImUWRS80YnmFFUtqrw2s7DWHaiu7MXLFDSBl8rfMKQTLfX63USOHlxCe78Xms38pC8PwONERRVxQX4BnQsCKleeez/eoxa2zW4DZvQXM696Tk8zmi1Zkxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G8cZm7L2; arc=none smtp.client-ip=95.215.58.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G8cZm7L2"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Llw0nThjK60jUx/vxsW20gdWbzulx+k6ywgPWEsNcNQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904251; v=1; x=1792509051;
 b=G8cZm7L2EOFnvapoCZjVUKxaK7yD+wR/ABlLbZ85P1oSn/kanfQj+IaRYb68C8hwv9RPLFeQ
 t1fFbNd7j9Tb08XnXKRaQ8KnuC4Z7A3aYwlbhhfUtRWjGJfgVBBs3JnQKuw6TVofHSuU29Wbo5F
 nTpvLejvtntVhtzCekpmbQTY=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 4d6ae776659dd83d;
	Tue, 13 Oct 2026 15:10:50 +0000
X-Mizu-Trace-ID: 4d6ae776659dd83d
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
Subject: [PATCH v3 1/3] mm: zswap: use separate compression and decompression requests
Date: Tue, 13 Oct 2026 08:09:35 -0700
Message-ID: <20261013151007.2093943-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013151007.2093943-1-usama.arif@linux.dev>
References: <20261013151007.2093943-1-usama.arif@linux.dev>
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

acomp_request_free() ignores NULL requests, so drop the check in
acomp_ctx_free().

This follows the proposal from Sergey Senozhatsky for the same split
for zram [1].

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced7..23c4298765795 100644
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
@@ -827,25 +856,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	/* acomp_request_alloc() returns NULL in case of an error. */
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
+	    zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
-
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &acomp_ctx->wait);
-
-	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
 fail:
@@ -856,7 +873,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 static bool zswap_compress(struct folio *folio, long index,
 			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
+	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
@@ -865,15 +882,16 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -885,10 +903,12 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -932,7 +952,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&comp_ctx->areq.mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -948,7 +968,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		return false;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -965,15 +985,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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

