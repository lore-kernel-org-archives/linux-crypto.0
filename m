Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA004F055D
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563524; cv=none; b=LYp7q3Jf+KcMkBDRlBh2wkJT5gmokVMCu3xMCFmu6MzEgCCXZ1veC+WyOzwIyAb0r0xTuWiTd4HC6LHqMMAnKr66hy4chFXNaX7LV9qo/bdIcwBHFFCs5t2D7GiP3WwdTsDnMEgByiCumOGaYTYRLKY/92KGB5LbbTftelVxiH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563524; c=relaxed/simple;
	bh=Tp5I2SvhZmWxOMIJktdBv2gzK+6jAyJAW9ZaQxpaWes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPZWUmuPcJAK9P6I2+UGpe00VDAmlTQiAwUyYkzlnCrx3s7pEBo6e3FScR9sA8647loFw7Sh0hw5OkCXH2pGa9Hxaue5YkhMdY8nm4NAM/h+6RPrIUlNvtzX1kuseqMG97ubQPycEluR97JEzx6vAur7510k7R4CTK7vW4pjDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ViJ+tb4a; arc=none smtp.client-ip=91.218.175.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ViJ+tb4a"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Tp5I2SvhZmWxOMIJktdBv2gzK+6jAyJAW9ZaQxpaWes=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563519; v=1; x=1792168319;
 b=ViJ+tb4apXiT4p0PYRXHROj9EeN7fUMKhohpUAPVZlcpHslZkwo8HqdmtVXv5mw2kU8aPgWl
 9i1QrqgdzNi8AmcRNIThNZCmAAT5iRbhKxxFDPA/TSuHcSniikgIQ3IloxyUlLblP0hJ3Ux9cKZ
 86xM2pqXkUeE1/igkjZEc/Fk=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 7de3defa0feb581d;
	Fri, 09 Oct 2026 16:31:59 +0000
X-Mizu-Trace-ID: 7de3defa0feb581d
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
Subject: [PATCH v2 2/2] mm: zswap: use stack requests for synchronous decompression
Date: Fri,  9 Oct 2026 09:30:31 -0700
Message-ID: <20261009163146.83112-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009163146.83112-1-usama.arif@linux.dev>
References: <20261009163146.83112-1-usama.arif@linux.dev>
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

Synchronous algorithms whose requests need no extra context can use an
on-stack request, so decompress with one and take no zswap lock. All
in-tree software compressors qualify. Add acomp_can_use_stack_req() to
keep the synchronous and request-size checks in the Crypto API.
Asynchronous algorithms, and synchronous ones with request context,
keep the per-CPU request and mutex, which is still taken before the
zsmalloc read lock.

Reading the per-CPU context without the mutex is safe. Since
commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
pool"), it is set up before its CPU comes online and is not torn down
until the pool is destroyed. The codecs keep their own stream locks, and
crypto_acomp_decompress() rejects on-stack requests only for
asynchronous transforms, which never take this path.

For software compressors this drops the heap request added by the
previous patch. The on-stack request and wait take 216 bytes, which
makes the load path about 270 bytes deeper on x86-64. Asynchronous
algorithms pay this too.

Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/crypto/acompress.h | 13 ++++++
 mm/zswap.c                 | 87 ++++++++++++++++++++++++++------------
 2 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 5d5358dfab734..12c1ce1f6243b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -203,6 +203,19 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
 	       CRYPTO_ALG_ASYNC;
 }
 
+/**
+ * acomp_can_use_stack_req() - check whether a transform can use stack requests
+ * @tfm: ACOMPRESS transform
+ *
+ * Return: true if @tfm completes synchronously and its request context fits
+ * in the storage reserved by ACOMP_REQUEST_ON_STACK(), false otherwise.
+ */
+static inline bool acomp_can_use_stack_req(struct crypto_acomp *tfm)
+{
+	return !acomp_is_async(tfm) &&
+	       crypto_acomp_reqsize(tfm) <= MAX_SYNC_COMP_REQSIZE;
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
diff --git a/mm/zswap.c b/mm/zswap.c
index 23c4298765795..572075bb1c1c1 100644
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
@@ -856,15 +861,19 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
-	    zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		goto fail;
+	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp))
+		goto req_fail;
+
+	/* Skip the per-CPU request when decompression can use the stack. */
+	if (!acomp_can_use_stack_req(acomp_ctx->acomp)) {
+		if (zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp))
+			goto req_fail;
 	}
 
 	return 0;
 
+req_fail:
+	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
@@ -956,19 +965,14 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -985,15 +989,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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
@@ -1007,6 +1009,35 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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

