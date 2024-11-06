Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D194220C316;
	Wed,  6 Nov 2024 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920877; cv=none; b=FKzZnagi9ibsCumv8+6xYqOs955m7sRGPbrTqgAIDBLNPmcA84Q1zwgJF4N/W+usyUUPIqk/o/7nPO/P8ebCWZvwJUiPvsZ6OTgMX2LOfBBEcShAVSnzest2xE1LnQ7DTcAfj9FZKkN67kjQar1j1qlQyMTG1TjbjEbmK/m0Ud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920877; c=relaxed/simple;
	bh=SK7AuRma8nAYQQn2EcAOmsROSQ044juQI+TJ7g6xS7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G/uXTWVxLEnwmGtSTC64mfafXosJh59LM2Ll7ONoeEQXxrpT7OzkVZLQxdAWhrxdO0i0kHzz0b44ZBc5P/3NKAnBFUltRRDUXm778XAdYqTVSRp5K/OKJXRsj8WhFXk3GSSKeTSx/srx8AmTGgCVwi5nwm209MsGEWywedkhpmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDzYePar; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDzYePar"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920876; x=1762456876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SK7AuRma8nAYQQn2EcAOmsROSQ044juQI+TJ7g6xS7U=;
  b=mDzYeParX/8A1Y6C9VZcQVcQ2gfcUHUWkchnlEnNEdGcRlbFd4ujgcSW
   GzoBBpaAH5yJ4gSe5IJGImAp0RfraM2jiQs2z8FrBtR7FBJKl76N2xOmE
   vasx48xImFB/NV0rQlibZwjQnoyyBa0LNCptcWXz1jq9ZxWieARX2GE7Q
   79uuYuV4ASK0lSvnVPOan4bMnv5/oPnkIDoo0SRJCmqvMEMnruN8ffACy
   vpJwXSz3QJsUj7ApZUvSo/beG7MtXP4VpLiqEd99y0NrMm5CR3ZWts0uG
   xmw8oNdkXEEDXT9SVMp30qi8xMyyzK5rAfjcSWvvzUHvYzl6IUCvgGpxb
   w==;
X-CSE-ConnectionGUID: zisd1V5XSce84F1beUGXSg==
X-CSE-MsgGUID: uwN0zEGeSPS7eEsS36ffOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41292059"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41292059"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:14 -0800
X-CSE-ConnectionGUID: ClMLUI8HQiKSghkT7rDUWg==
X-CSE-MsgGUID: EuVmJ52UQjmumLK5h0SBhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695416"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:13 -0800
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
Subject: [PATCH v3 11/13] mm: zswap: Allocate acomp_batch_ctx resources for a given zswap_pool.
Date: Wed,  6 Nov 2024 11:21:03 -0800
Message-Id: <20241106192105.6731-12-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
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
 include/linux/zswap.h |  7 ++++++
 mm/zswap.c            | 52 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

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
index 80a928cf0f7e..2af736e38213 100644
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
@@ -695,6 +703,39 @@ static int zswap_enabled_param_set(const char *val,
 	return ret;
 }
 
+/* Called only if sysctl vm.compress-batching is set to "1". */
+static __always_inline bool zswap_pool_can_batch(struct zswap_pool *pool)
+{
+	struct crypto_acomp_ctx *acomp_ctx;
+
+	if ((pool->can_batch_comp == BATCH_COMP_ENABLED) &&
+		!IS_ERR_OR_NULL((acomp_ctx = raw_cpu_ptr(pool->acomp_batch_ctx))) &&
+		(acomp_ctx->nr_reqs == SWAP_CRYPTO_BATCH_SIZE))
+		return true;
+
+	if (pool->can_batch_comp == CANNOT_BATCH_COMP)
+		return false;
+
+	if ((pool->can_batch_comp == UNINIT_BATCH_COMP) && pool->acomp_batch_ctx) {
+		acomp_ctx = raw_cpu_ptr(pool->acomp_batch_ctx);
+
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
@@ -850,6 +891,17 @@ static int zswap_create_acomp_ctx(unsigned int cpu,
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
 	if (!acomp_ctx->buffers)
-- 
2.27.0

