Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BE52D2680;
	Wed, 30 Apr 2025 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046401; cv=none; b=C93OoX6f6fjGtZpYIwhW0KYBXRpRNZgAhCV9EOK2vU/OD3vVxJFyV+Lx1y828UKwvtnEb2KT20WcPEhbDLRNd1jRzO90I96A/HssKip39klD9o7t+qcH9vdIOl/etIkMFF6HYDcR+2EirXmRMBYTXPifWOgrsKYDrqJ0NpIexRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046401; c=relaxed/simple;
	bh=l0g+LAnddWvzoTX2shNX+O/DFhTRbmW793v8KGvd668=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SBMLRRoVbSonJFo6NXTYJctTkxgX9+yNHpZo5+ZaZyZQO6obNwRbR55rKDmC0K0uMIYPWO8tGSAM6B28XzgUu3Z4ELW/AqzzitmLIQuKW4NroZUbm+enezVZMD35JnfAkJVerWEpdlFArbiUwH2pXFzcSgmeBFurBkeeGeuDA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YU9K/3si; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YU9K/3si"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046400; x=1777582400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l0g+LAnddWvzoTX2shNX+O/DFhTRbmW793v8KGvd668=;
  b=YU9K/3siN6a2dT9QNRQuZcNPJEZGk88NenYWPH+5CQAh+CUX1F2/vPsN
   0jQToC4M66LBp/PiW7fHXbhiCq0qsXZQzzdrkcEC+PijdcKB1yoWzwI3P
   CjgQ2yVlMxtU6ZM7VKx4miieZPXWr5tg594OCZgCuKh4O3eCW3I5XLlQX
   kUfDMAdg4vNaO4Y7vGaw/gZcO/1XCY0g7u3ktGIFkHwPObzIap1xcnMtD
   pNQz+WJxO6OjZCljeGAGHB3iW6CesjsOMqIeLSaZ8ydfLgyVWSa9WQChK
   jiQaauoxA7bTOqVehJhgUPuBT1a2hQryQqh8I0wr0OcG7jIkIg+H4o3mr
   Q==;
X-CSE-ConnectionGUID: zAXK+rcuRhqGTRbs+5wCag==
X-CSE-MsgGUID: tF6VLOHPQiC9Iy9KScurOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388673"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388673"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:19 -0700
X-CSE-ConnectionGUID: rpgM/CbWRUyB15lJ5VFjDA==
X-CSE-MsgGUID: GlJk7a+pSh6n3g5WrzPoNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248932"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:18 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v9 14/19] mm: zswap: Move the CPU hotplug procedures under "pool functions".
Date: Wed, 30 Apr 2025 13:53:00 -0700
Message-Id: <20250430205305.22844-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch merely moves zswap_cpu_comp_prepare() and
zswap_cpu_comp_dead() to be in the "pool functions" section because
these functions are invoked upon pool creation/deletion.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 188 ++++++++++++++++++++++++++---------------------------
 1 file changed, 94 insertions(+), 94 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 455e9425c5f5..358dad3e612a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -248,6 +248,100 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
+static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
+{
+	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
+	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct crypto_acomp *acomp = NULL;
+	struct acomp_req *req = NULL;
+	u8 *buffer = NULL;
+	int ret;
+
+	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	if (!buffer) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp)) {
+		pr_err("could not alloc crypto acomp %s : %ld\n",
+				pool->tfm_name, PTR_ERR(acomp));
+		ret = PTR_ERR(acomp);
+		goto fail;
+	}
+
+	req = acomp_request_alloc(acomp);
+	if (!req) {
+		pr_err("could not alloc crypto acomp_request %s\n",
+		       pool->tfm_name);
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	/*
+	 * Only hold the mutex after completing allocations, otherwise we may
+	 * recurse into zswap through reclaim and attempt to hold the mutex
+	 * again resulting in a deadlock.
+	 */
+	mutex_lock(&acomp_ctx->mutex);
+	crypto_init_wait(&acomp_ctx->wait);
+
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &acomp_ctx->wait);
+
+	acomp_ctx->buffer = buffer;
+	acomp_ctx->acomp = acomp;
+	acomp_ctx->is_sleepable = acomp_is_async(acomp);
+	acomp_ctx->req = req;
+	mutex_unlock(&acomp_ctx->mutex);
+	return 0;
+
+fail:
+	if (acomp)
+		crypto_free_acomp(acomp);
+	kfree(buffer);
+	return ret;
+}
+
+static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
+	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct acomp_req *req;
+	struct crypto_acomp *acomp;
+	u8 *buffer;
+
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return 0;
+
+	mutex_lock(&acomp_ctx->mutex);
+	req = acomp_ctx->req;
+	acomp = acomp_ctx->acomp;
+	buffer = acomp_ctx->buffer;
+	acomp_ctx->req = NULL;
+	acomp_ctx->acomp = NULL;
+	acomp_ctx->buffer = NULL;
+	mutex_unlock(&acomp_ctx->mutex);
+
+	/*
+	 * Do the actual freeing after releasing the mutex to avoid subtle
+	 * locking dependencies causing deadlocks.
+	 */
+	if (!IS_ERR_OR_NULL(req))
+		acomp_request_free(req);
+	if (!IS_ERR_OR_NULL(acomp))
+		crypto_free_acomp(acomp);
+	kfree(buffer);
+
+	return 0;
+}
+
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 {
 	struct zswap_pool *pool;
@@ -818,100 +912,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
-static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp = NULL;
-	struct acomp_req *req = NULL;
-	u8 *buffer = NULL;
-	int ret;
-
-	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
-		ret = PTR_ERR(acomp);
-		goto fail;
-	}
-
-	req = acomp_request_alloc(acomp);
-	if (!req) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		ret = -ENOMEM;
-		goto fail;
-	}
-
-	/*
-	 * Only hold the mutex after completing allocations, otherwise we may
-	 * recurse into zswap through reclaim and attempt to hold the mutex
-	 * again resulting in a deadlock.
-	 */
-	mutex_lock(&acomp_ctx->mutex);
-	crypto_init_wait(&acomp_ctx->wait);
-
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &acomp_ctx->wait);
-
-	acomp_ctx->buffer = buffer;
-	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
-	acomp_ctx->req = req;
-	mutex_unlock(&acomp_ctx->mutex);
-	return 0;
-
-fail:
-	if (acomp)
-		crypto_free_acomp(acomp);
-	kfree(buffer);
-	return ret;
-}
-
-static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct acomp_req *req;
-	struct crypto_acomp *acomp;
-	u8 *buffer;
-
-	if (IS_ERR_OR_NULL(acomp_ctx))
-		return 0;
-
-	mutex_lock(&acomp_ctx->mutex);
-	req = acomp_ctx->req;
-	acomp = acomp_ctx->acomp;
-	buffer = acomp_ctx->buffer;
-	acomp_ctx->req = NULL;
-	acomp_ctx->acomp = NULL;
-	acomp_ctx->buffer = NULL;
-	mutex_unlock(&acomp_ctx->mutex);
-
-	/*
-	 * Do the actual freeing after releasing the mutex to avoid subtle
-	 * locking dependencies causing deadlocks.
-	 */
-	if (!IS_ERR_OR_NULL(req))
-		acomp_request_free(req);
-	if (!IS_ERR_OR_NULL(acomp))
-		crypto_free_acomp(acomp);
-	kfree(buffer);
-
-	return 0;
-}
-
 static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
-- 
2.27.0

