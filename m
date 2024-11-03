Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D4915443B;
	Sun,  3 Nov 2024 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604084; cv=none; b=HaIIFla66JQrf5BaoN4zLuBCbjT1Lg6EFtlhzJuw2UJCSXzooq7ZfpSzvX1IlUyHHAiTi14UIdOXwGmTyxsao6j5kbh6LZZOCbJvdqiEZxIPKb8wRJS7C1GcH8CDDStyzqUV7+TG07SqDD5E5EGF7tbZAZhfWDjUwdImamg+G8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604084; c=relaxed/simple;
	bh=TyxYuGZ5om7/o45C+jhhBFW2E7GGaioFiNoenmMyD78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k0wANlBwbHNvl6cnyLEjltcet61AwgqmjGzkZ4XAkhyrS94yK2++/e2kJb6CoOzWoOgSbHOCXpHhFrMi6sO+Z8Llm2WJhMPhBVBQJBN/lqFqmtWGUmgIkIg9V3zolR2yZLd2Hi3lXxJd8YQNwmE+xm96xAq4AVlMVTJlFQ8NKRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QBFkAH0L; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QBFkAH0L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604082; x=1762140082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TyxYuGZ5om7/o45C+jhhBFW2E7GGaioFiNoenmMyD78=;
  b=QBFkAH0LNZHMIhr+sw5P1dBXY2R2FKwww/K+gpcIBYQ/gkAzSW3r50Ix
   Crj2qK7d2iiE2wet4FDJIqoQRwAqKWsvq6FsVLG+FYhyFdZDb1wGcwpEE
   yMVyMzPqG3gnjW5uZPcNTne+8uPdUjsadceFxVx20iOxM+uL+XEk0eU4M
   El0ihzfzANSlVeiy4JbMVKeoKtBNgCY3r3370OfCLJ+YN7NZ8ZvmTO/rg
   Sd8TuTSxlLt2p5V+wXHQKMkRlbbt205oI+Hv4lUuwzv0t4Q6M8euyLz9C
   RpPWl/+Fjf7BqcgDYl+lXPN/IHltCo/cuxywYa4lXmr/Qfja5cASUHwWG
   w==;
X-CSE-ConnectionGUID: ZcyfXppaR0esBZsXTkdYfQ==
X-CSE-MsgGUID: HcBfCdi/SSS1JsCa/WTRjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548317"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548317"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:13 -0700
X-CSE-ConnectionGUID: UNQfB8L7Tt2fD3TR9VFxkw==
X-CSE-MsgGUID: MNRAQAguTgm9nxQ6pxS+7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451894"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 02 Nov 2024 20:21:14 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v2 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be configurable in nr of acomp_reqs.
Date: Sat,  2 Nov 2024 20:21:07 -0700
Message-Id: <20241103032111.333282-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modified the definition of "struct crypto_acomp_ctx" to represent a
configurable number of acomp_reqs and the required number of buffers.

Accordingly, refactored the code that allocates/deallocates the acomp_ctx
resources, so that it can be called to create a regular acomp_ctx with
exactly one acomp_req/buffer, for use in the the existing non-batching
zswap_store(), as well as to create a separate "batching acomp_ctx" with
multiple acomp_reqs/buffers for IAA compress batching.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 145 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 102 insertions(+), 43 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 3e899fa61445..f062c6dfcad4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -143,9 +143,10 @@ bool zswap_never_enabled(void)
 
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
-	struct acomp_req *req;
+	struct acomp_req **reqs;
+	u8 **buffers;
+	unsigned int nr_reqs;
 	struct crypto_wait wait;
-	u8 *buffer;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -241,6 +242,11 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
 		 zpool_get_type((p)->zpool))
 
+static int zswap_create_acomp_ctx(unsigned int cpu,
+				  struct crypto_acomp_ctx *acomp_ctx,
+				  char *tfm_name,
+				  unsigned int nr_reqs);
+
 /*********************************
 * pool functions
 **********************************/
@@ -813,69 +819,122 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
-static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
+static int zswap_create_acomp_ctx(unsigned int cpu,
+				  struct crypto_acomp_ctx *acomp_ctx,
+				  char *tfm_name,
+				  unsigned int nr_reqs)
 {
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	struct crypto_acomp *acomp;
-	struct acomp_req *req;
-	int ret;
+	int ret = -ENOMEM;
+	int i, j;
 
+	acomp_ctx->nr_reqs = 0;
 	mutex_init(&acomp_ctx->mutex);
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return -ENOMEM;
-
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	acomp = crypto_alloc_acomp_node(tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
-		ret = PTR_ERR(acomp);
-		goto acomp_fail;
+				tfm_name, PTR_ERR(acomp));
+		return PTR_ERR(acomp);
 	}
+
 	acomp_ctx->acomp = acomp;
 	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 
-	req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!req) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		ret = -ENOMEM;
-		goto req_fail;
+	acomp_ctx->buffers = kmalloc_node(nr_reqs * sizeof(u8 *),
+					  GFP_KERNEL, cpu_to_node(cpu));
+	for (i = 0; i < nr_reqs; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2,
+						     GFP_KERNEL, cpu_to_node(cpu));
+		if (!acomp_ctx->buffers[i]) {
+			for (j = 0; j < i; ++j)
+				kfree(acomp_ctx->buffers[j]);
+			kfree(acomp_ctx->buffers);
+			ret = -ENOMEM;
+			goto buf_fail;
+		}
 	}
-	acomp_ctx->req = req;
 
+	acomp_ctx->reqs = kmalloc_node(nr_reqs * sizeof(struct acomp_req *),
+				       GFP_KERNEL, cpu_to_node(cpu));
+	for (i = 0; i < nr_reqs; ++i) {
+		acomp_ctx->reqs[i] = acomp_request_alloc(acomp_ctx->acomp);
+		if (!acomp_ctx->reqs[i]) {
+			pr_err("could not alloc crypto acomp_request reqs[%d] %s\n",
+			       i, tfm_name);
+			for (j = 0; j < i; ++j)
+				acomp_request_free(acomp_ctx->reqs[j]);
+			kfree(acomp_ctx->reqs);
+			ret = -ENOMEM;
+			goto req_fail;
+		}
+	}
+
+	/*
+	 * The crypto_wait is used only in fully synchronous, i.e., with scomp
+	 * or non-poll mode of acomp, hence there is only one "wait" per
+	 * acomp_ctx, with callback set to reqs[0], under the assumption that
+	 * there is at least 1 request per acomp_ctx.
+	 */
 	crypto_init_wait(&acomp_ctx->wait);
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
+	acomp_ctx->nr_reqs = nr_reqs;
 	return 0;
 
 req_fail:
+	for (i = 0; i < nr_reqs; ++i)
+		kfree(acomp_ctx->buffers[i]);
+	kfree(acomp_ctx->buffers);
+buf_fail:
 	crypto_free_acomp(acomp_ctx->acomp);
-acomp_fail:
-	kfree(acomp_ctx->buffer);
 	return ret;
 }
 
-static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
+static void zswap_delete_acomp_ctx(struct crypto_acomp_ctx *acomp_ctx)
 {
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-
 	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
+		int i;
+
+		for (i = 0; i < acomp_ctx->nr_reqs; ++i)
+			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
+				acomp_request_free(acomp_ctx->reqs[i]);
+		kfree(acomp_ctx->reqs);
+
+		for (i = 0; i < acomp_ctx->nr_reqs; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+
 		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
+
+		acomp_ctx->nr_reqs = 0;
+		acomp_ctx = NULL;
 	}
+}
+
+static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
+{
+	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
+	struct crypto_acomp_ctx *acomp_ctx;
+
+	acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	return zswap_create_acomp_ctx(cpu, acomp_ctx, pool->tfm_name, 1);
+}
+
+static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
+	struct crypto_acomp_ctx *acomp_ctx;
+
+	acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	zswap_delete_acomp_ctx(acomp_ctx);
 
 	return 0;
 }
@@ -898,7 +957,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -908,7 +967,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * giving the dst buffer with enough length to avoid buffer overflow.
 	 */
 	sg_init_one(&output, dst, PAGE_SIZE * 2);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -922,8 +981,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
+	dlen = acomp_ctx->reqs[0]->dlen;
 	if (comp_ret)
 		goto unlock;
 
@@ -975,24 +1034,24 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	 */
 	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
 	    !virt_addr_valid(src)) {
-		memcpy(acomp_ctx->buffer, src, entry->length);
-		src = acomp_ctx->buffer;
+		memcpy(acomp_ctx->buffers[0], src, entry->length);
+		src = acomp_ctx->buffers[0];
 		zpool_unmap_handle(zpool, entry->handle);
 	}
 
 	sg_init_one(&input, src, entry->length);
 	sg_init_table(&output, 1);
 	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
-	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
+	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, entry->length, PAGE_SIZE);
+	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->reqs[0]), &acomp_ctx->wait));
+	BUG_ON(acomp_ctx->reqs[0]->dlen != PAGE_SIZE);
 
-	if (src != acomp_ctx->buffer)
+	if (src != acomp_ctx->buffers[0])
 		zpool_unmap_handle(zpool, entry->handle);
 
 	/*
 	 * It is safer to unlock the mutex after the check for
-	 * "src != acomp_ctx->buffer" so that the value of "src"
+	 * "src != acomp_ctx->buffers[0]" so that the value of "src"
 	 * does not change.
 	 */
 	mutex_unlock(&acomp_ctx->mutex);
-- 
2.27.0

