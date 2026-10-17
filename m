Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE0A33F8B2
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 16:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253383; cv=none; b=GqA5+QuAxo3tbyaTdenEPvdcuo9Gg0mEAA/inXsssKM4Wi898aLMynDCezCSUGu61iH89PB6yzYVQFBQ+rPE6dBs8sZBFOUeiEC5Pe5KkiuYx2m5JAa4oBcuU2vVadth62Z25oXPhezvqCb0CqzV8ieJ4NrEty7teNXZEF+JObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253383; c=relaxed/simple;
	bh=ltpTa2mf6PRtR23DlzBjVmfp/75+5bWbp6ul/TgSi34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFKDVYzYTd/yiY/h6PUSuFJrIKGJ5o6CZF2Qxiw9kd70Jilylou/U3Svz860C5wd8lenU8WNp/R2wBlqfJTFTftZO6URhzfHBn9sxC+IMF3g1J3EyRV96bpc1Olf6yFwSSMHGh5o1qcH9F/BW+GesoCU7F2HVcGWcVzK4PDiHXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SxL0rFuV; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SxL0rFuV"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ltpTa2mf6PRtR23DlzBjVmfp/75+5bWbp6ul/TgSi34=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792253379; v=1; x=1792858179;
 b=SxL0rFuVMQP0EO3GmOhcrCVGwUvWzRETtpG1bLyETPxcqtdIzxts4y7qpe8aVY2MD05p7VAa
 Za+gdHsqvmay0WKWlvgnJj77dkPD3Jl388+TfKFv67YEPJb2hr1ezkfJ39HiPQDEHwJaoSNM7/e
 Mnh1rr/5Byu4MK220H4JBvnw=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 160a6d75655b9c7b;
	Sat, 17 Oct 2026 16:09:39 +0000
X-Mizu-Trace-ID: 160a6d75655b9c7b
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
Subject: [PATCH v4 3/3] mm: zswap: use stack requests for synchronous decompression
Date: Sat, 17 Oct 2026 09:08:55 -0700
Message-ID: <20261017160918.2738626-4-usama.arif@linux.dev>
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

With separate requests for compression and decompression, loads still
serialize on the per-CPU decompression mutex. A low-priority load that
is preempted after the codec drops its stream lock keeps holding the mutex
and stalls every other load on that CPU, including higher-priority ones.

Synchronous algorithms can use an on-stack request, so decompress with
one and take no zswap lock. All in-tree software compressors qualify.
The Crypto API enforces MAX_SYNC_COMP_REQSIZE during initialization,
so checking acomp_is_async() is sufficient. Asynchronous algorithms
keep the per-CPU request and mutex, which is still taken before the
zsmalloc read lock.

Reading the per-CPU context without the mutex is safe. Since
commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
pool"), it is set up before its CPU comes online and is not torn down
until the pool is destroyed. The codecs keep their own stream locks, and
crypto_acomp_decompress() rejects on-stack requests only for
asynchronous transforms, which never take this path.

For software compressors this drops the heap request added for
decompression. The on-stack request and wait take 216 bytes, which
makes the load path about 270 bytes deeper on x86-64. Asynchronous
algorithms pay this too.

Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 82 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 26 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b23ef5f3bd529..9cb75215b2703 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -153,7 +153,7 @@ struct zswap_comp_ctx {
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct zswap_comp_ctx comp;
-	struct zswap_acomp_req decomp;
+	struct zswap_acomp_req decomp;	/* unused with on-stack requests */
 };
 
 /*
@@ -803,6 +803,18 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
+static void zswap_set_acomp_req_callback(struct acomp_req *req,
+					 struct crypto_wait *wait)
+{
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, wait);
+}
+
 static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 				struct crypto_acomp *acomp)
 {
@@ -812,14 +824,7 @@ static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 		return -ENOMEM;
 
 	crypto_init_wait(&areq->wait);
-
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &areq->wait);
+	zswap_set_acomp_req_callback(areq->req, &areq->wait);
 
 	mutex_init(&areq->mutex);
 	return 0;
@@ -860,9 +865,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (ret)
 		goto req_fail;
 
-	ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
-	if (ret)
-		goto req_fail;
+	/* Skip the per-CPU request when decompression can use the stack. */
+	if (acomp_is_async(acomp_ctx->acomp)) {
+		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
+		if (ret)
+			goto req_fail;
+	}
 
 	return 0;
 
@@ -959,19 +967,14 @@ static bool zswap_compress(struct folio *folio, long index,
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
-static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+static bool __zswap_decompress(struct zswap_entry *entry,
+			       struct zswap_pool *pool, struct acomp_req *req,
+			       struct crypto_wait *wait, struct folio *folio)
 {
-	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
-	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
-	if (WARN_ON_ONCE(!pool))
-		return false;
-
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -988,15 +991,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
-					 entry->length, PAGE_SIZE);
-		ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
-		ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
-		dlen = acomp_ctx->decomp.req->dlen;
+		acomp_request_set_params(req, input, &output, entry->length, PAGE_SIZE);
+		ret = crypto_acomp_decompress(req);
+		ret = crypto_wait_req(ret, wait);
+		dlen = req->dlen;
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	mutex_unlock(&acomp_ctx->decomp.mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1010,6 +1011,35 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	return false;
 }
 
+static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+{
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+	struct crypto_acomp_ctx *acomp_ctx;
+	bool ret;
+
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	/*
+	 * Use a private on-stack request when the transform supports it.
+	 * Otherwise serialize decompression on the shared per-CPU request.
+	 */
+	if (!acomp_ctx->decomp.req) {
+		ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
+		DECLARE_CRYPTO_WAIT(wait);
+
+		zswap_set_acomp_req_callback(req, &wait);
+		return __zswap_decompress(entry, pool, req, &wait, folio);
+	}
+
+	mutex_lock(&acomp_ctx->decomp.mutex);
+	ret = __zswap_decompress(entry, pool, acomp_ctx->decomp.req,
+				 &acomp_ctx->decomp.wait, folio);
+	mutex_unlock(&acomp_ctx->decomp.mutex);
+	return ret;
+}
+
 /*********************************
 * writeback code
 **********************************/
-- 
2.53.0-Meta

