Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42915B13C;
	Sun,  3 Nov 2024 03:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604086; cv=none; b=Hx7wICXcUFDuhAZEMKgChigFKdfPq0GzcOooEDSIfpY4OnGcGPc743CfwVNdgm/1sAP2q1PzxXRyBHNiG9fhZjHrOgoKDq8FcnX9LZ81vyBsgZmlbpikU8BHR49XI+pdHg9Olelhb7evvz1EXJVgZIn+8a9krRF/Y9MdZ0tAGwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604086; c=relaxed/simple;
	bh=Mv1j1WkxVMtwiYbBTrEKO+5plJ/chufvUAiSaGvBrMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1zi0oOcTqoSeJJGjKjpSvW8vl1B7jaXJOuFbWhjw7SOE3rgqbtcIwlZRfCaa8Qdc+9mrodtUQRLjepvw34XxAEF3+BNpudU4GQhBtuz8PFk9bf6rnBlOOJ9ju7l8ysqdQbTTpBjDUYhsyA0+LYLM73YgMSDRAXz8LWmNEs3J5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dU+TupFE; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dU+TupFE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604084; x=1762140084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mv1j1WkxVMtwiYbBTrEKO+5plJ/chufvUAiSaGvBrMw=;
  b=dU+TupFE555MwdH6IWg7DaD4Zz1wJsivfuPEGOWfw+uDbqLFMyHaht0l
   /1IB7XrZBiP5A3Jt6iDB9ogRQ5mgPbQK2y5Z2yHxktrFPRo2G6SCEU/ob
   hWC5IEV2AK2bS+39arNcDOKqP4ckvMd3wPteByJ0YEmbkVdFv7me7PTjC
   WoW42LhqPkAhZNX1f/+OLJT6kU/ldll0tAoqKcV4OJZDHtjzF5D2KYxex
   64ly105FurIS5Bhr2TdjZ7O0NnzOefPKhwEkrlEDdjHz4mPkI+ryR9w6y
   Sdw3qki16erOrHDJKacVgNyHIfAbmsaEKCLMYAf9YbggdNv0jnnWTepjh
   w==;
X-CSE-ConnectionGUID: cYzB/UxLR5ey1IE7zNvIug==
X-CSE-MsgGUID: dg89EH/VS9yBNOjB0Dhxqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548334"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548334"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:14 -0700
X-CSE-ConnectionGUID: /wV0MMjJTpOp2HLAinTXkg==
X-CSE-MsgGUID: 5gu66x9ZSmOJhWTIjpLa9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451903"
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
Subject: [PATCH v2 11/13] mm: zswap: Allocate acomp_batch_ctx resources for a given zswap_pool.
Date: Sat,  2 Nov 2024 20:21:09 -0700
Message-Id: <20241103032111.333282-12-kanchana.p.sridhar@intel.com>
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

If the zswap_pool is associated with an acomp_alg/crypto_acomp that has
registered batch_compress() and batch_decompress() API, we can allocate the
necessary batching resources for the pool's acomp_batch_ctx.

This patch makes the above determination on incurring the per-cpu memory
footprint cost for batching, and if so, goes ahead and allocates
SWAP_CRYPTO_BATCH_SIZE (i.e. 8) acomp_reqs/buffers for the
pool->acomp_batch_ctx on that specific cpu.

It also "remembers" the pool's batching readiness as a result of the above,
through a new

   	enum batch_comp_status can_batch_comp;

member added to struct zswap_pool, for fast retrieval during
zswap_store().

This allows us a way to only incur the memory footprint cost of the
pool->acomp_batch_ctx resources for a given cpu on which zswap_store()
needs to process a large folio.

Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Ying Huang <ying.huang@intel.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 include/linux/zswap.h |  7 +++++++
 mm/zswap.c            | 49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index d961ead91bf1..9ad27ab3d222 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -7,6 +7,13 @@
 
 struct lruvec;
 
+/*
+ * For IAA compression batching:
+ * Maximum number of IAA acomp compress requests that will be processed
+ * in a batch: in parallel, if iaa_crypto async/no irq mode is enabled
+ * (the default); else sequentially, if iaa_crypto sync mode is in effect.
+ */
+#define SWAP_CRYPTO_BATCH_SIZE 8UL
 extern atomic_long_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
diff --git a/mm/zswap.c b/mm/zswap.c
index 3ad81ec0f262..edd5910168c2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -151,6 +151,12 @@ struct crypto_acomp_ctx {
 	bool is_sleepable;
 };
 
+enum batch_comp_status {
+	UNINIT_BATCH_COMP = -1,
+	CANNOT_BATCH_COMP = 0,
+	BATCH_COMP_ENABLED = 1,
+};
+
 /*
  * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
  * The only case where lru_lock is not acquired while holding tree.lock is
@@ -159,6 +165,7 @@ struct crypto_acomp_ctx {
  */
 struct zswap_pool {
 	struct zpool *zpool;
+	enum batch_comp_status can_batch_comp;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct crypto_acomp_ctx __percpu *acomp_batch_ctx;
 	struct percpu_ref ref;
@@ -310,6 +317,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 		goto ref_fail;
 	INIT_LIST_HEAD(&pool->list);
 
+	pool->can_batch_comp = UNINIT_BATCH_COMP;
 	zswap_pool_debug("created", pool);
 
 	return pool;
@@ -695,6 +703,36 @@ static int zswap_enabled_param_set(const char *val,
 	return ret;
 }
 
+/* Called only if sysctl vm.compress-batching is set to "1". */
+static __always_inline bool zswap_pool_can_batch(struct zswap_pool *pool)
+{
+	if (pool->can_batch_comp == BATCH_COMP_ENABLED)
+		return true;
+
+	if (pool->can_batch_comp == CANNOT_BATCH_COMP)
+		return false;
+
+	if ((pool->can_batch_comp == UNINIT_BATCH_COMP) && pool->acomp_batch_ctx) {
+		struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(
+							pool->acomp_batch_ctx,
+							raw_smp_processor_id());
+		if (!IS_ERR_OR_NULL(acomp_ctx)) {
+			if ((acomp_ctx->nr_reqs == SWAP_CRYPTO_BATCH_SIZE) ||
+			    (!acomp_ctx->nr_reqs &&
+			     !zswap_create_acomp_ctx(raw_smp_processor_id(),
+						     acomp_ctx,
+						     pool->tfm_name,
+						     SWAP_CRYPTO_BATCH_SIZE))) {
+				pool->can_batch_comp = BATCH_COMP_ENABLED;
+				return true;
+			}
+		}
+	}
+
+	pool->can_batch_comp = CANNOT_BATCH_COMP;
+	return false;
+}
+
 /*********************************
 * lru functions
 **********************************/
@@ -850,6 +888,17 @@ static int zswap_create_acomp_ctx(unsigned int cpu,
 	acomp_ctx->acomp = acomp;
 	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 
+	/*
+	 * Cannot create a batching ctx without the crypto acomp alg supporting
+	 * batch_compress and batch_decompress API.
+	 */
+	if ((nr_reqs > 1) && (!acomp->batch_compress || !acomp->batch_decompress)) {
+		WARN_ONCE(1, "Cannot alloc acomp_ctx with %d reqs since crypto acomp %s\nhas not registered batch_compress() and/or batch_decompress()\n",
+			  nr_reqs, tfm_name);
+		ret = -ENODEV;
+		goto buf_fail;
+	}
+
 	acomp_ctx->buffers = kmalloc_node(nr_reqs * sizeof(u8 *),
 					  GFP_KERNEL, cpu_to_node(cpu));
 	for (i = 0; i < nr_reqs; ++i) {
-- 
2.27.0

