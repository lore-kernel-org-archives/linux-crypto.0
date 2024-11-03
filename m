Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05722155392;
	Sun,  3 Nov 2024 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604084; cv=none; b=Gb9n+VuBsrCCfrVp+Uy/sN0a7ig1qcR/cDlr7/IxWEiFX9BzoqEzJjvUlReL/nRR0iFAMfbdlUCTYTqmlwJ2yWWDihPwaZZ05EZbOiBZGHdsdfAB6sMaVOqujslfsz0PpeE4zxMKlTYbepAgo4y6E7rg0/GqMfb9P+mM91dVD+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604084; c=relaxed/simple;
	bh=kNwqiK541Yzu6mxMdWRHQdBvyKOFfv8Kurpx7eomG3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ad7jn944A3HpAVwhOHvcMhk0RwWFFrdX1FWgfrsKFkUFX4O7JvFDmvf/nmj6WrepgojNRT0RwnebS6Z4jognxuKDzsDYOooD6Og6PQWRCJpYo6kZl/lqmc2HZUJE7B5Na9iPkL9r/Abfu1bfXYQorddIMMCen73HcOmEmTPjpws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QmOm2ZFk; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QmOm2ZFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604083; x=1762140083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kNwqiK541Yzu6mxMdWRHQdBvyKOFfv8Kurpx7eomG3Q=;
  b=QmOm2ZFkOHgBctSV2XaXNywDQF+sbR7RUYGTAYfReanGt7mZJUFDWm/G
   sssWRKJmdnDf95zSAl0y+UBmvEnH2/l7XyNJDf57otml+rF9kf1ynwvFB
   Cn9MQAPTvYO37CLm6V/k0AUbT76xlmyKGCGqP2N9x0zY7mZSIFDxTkYi8
   nkhPs8ILlSha/I66CTQfQXHjeduC1KfHfWE1pmnQvftB4J7cxUPs0H/hP
   0NrcQSyAmbQAPMHF9ptQxvfJU+/7+iNvb7Pa/8gMGBXQt3U1a1T4K+cut
   dKSRyOqGUAF1x4E4xZ35TDfURGCI2Rl6jsYNgNzFph0gKK/Rs00Kj7kPh
   Q==;
X-CSE-ConnectionGUID: OCzQ1cqnQnCe2IDg5r//zw==
X-CSE-MsgGUID: SgcxhucgQ/yr5yds6IcqzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548325"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548325"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:14 -0700
X-CSE-ConnectionGUID: 9xQQE4tEQ9OqArTginJneA==
X-CSE-MsgGUID: AHlf4kvqRIWS++X0cLkzHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451899"
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
Subject: [PATCH v2 10/13] mm: zswap: Add a per-cpu "acomp_batch_ctx" to struct zswap_pool.
Date: Sat,  2 Nov 2024 20:21:08 -0700
Message-Id: <20241103032111.333282-11-kanchana.p.sridhar@intel.com>
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

This patch adds a separate per-cpu batching acomp context "acomp_batch_ctx"
to the zswap_pool. The per-cpu acomp_batch_ctx pointer is allocated at pool
creation time, but no per-cpu resources are allocated for it.

The idea is to not incur the memory footprint cost of multiple acomp_reqs
and buffers in the existing "acomp_ctx" for cases where compress batching
is not possible; for instance, with software compressor algorithms, on
systems without IAA, on systems with IAA that want to run the existing
non-batching implementation of zswap_store() of large folios.

By creating a separate acomp_batch_ctx, we have the ability to allocate
additional memory per-cpu only if the zswap compressor supports batching,
and if the user wants to enable the use of compress batching in
zswap_store() to improve swapout performance of large folios.

Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f062c6dfcad4..3ad81ec0f262 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,6 +160,7 @@ struct crypto_acomp_ctx {
 struct zswap_pool {
 	struct zpool *zpool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
+	struct crypto_acomp_ctx __percpu *acomp_batch_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
 	struct work_struct release_work;
@@ -287,10 +288,14 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 
 	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
 	if (!pool->acomp_ctx) {
-		pr_err("percpu alloc failed\n");
+		pr_err("percpu acomp_ctx alloc failed\n");
 		goto error;
 	}
 
+	pool->acomp_batch_ctx = alloc_percpu(*pool->acomp_batch_ctx);
+	if (!pool->acomp_batch_ctx)
+		pr_err("percpu acomp_batch_ctx alloc failed\n");
+
 	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
 				       &pool->node);
 	if (ret)
@@ -312,6 +317,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 error:
+	if (pool->acomp_batch_ctx)
+		free_percpu(pool->acomp_batch_ctx);
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
 	if (pool->zpool)
@@ -368,6 +375,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 	free_percpu(pool->acomp_ctx);
+	if (pool->acomp_batch_ctx)
+		free_percpu(pool->acomp_batch_ctx);
 
 	zpool_destroy_pool(pool->zpool);
 	kfree(pool);
@@ -924,6 +933,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx;
 
+	if (pool->acomp_batch_ctx) {
+		acomp_ctx = per_cpu_ptr(pool->acomp_batch_ctx, cpu);
+		acomp_ctx->nr_reqs = 0;
+	}
+
 	acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	return zswap_create_acomp_ctx(cpu, acomp_ctx, pool->tfm_name, 1);
 }
@@ -933,6 +947,12 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx;
 
+	if (pool->acomp_batch_ctx) {
+		acomp_ctx = per_cpu_ptr(pool->acomp_batch_ctx, cpu);
+		if (!IS_ERR_OR_NULL(acomp_ctx) && (acomp_ctx->nr_reqs > 0))
+			zswap_delete_acomp_ctx(acomp_ctx);
+	}
+
 	acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	zswap_delete_acomp_ctx(acomp_ctx);
 
-- 
2.27.0

