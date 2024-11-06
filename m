Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A671220C30E;
	Wed,  6 Nov 2024 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920877; cv=none; b=bVChhevyk1wraDg9E55ff36jVswGZNgRt/xtbFpyFQXpdaUC2gNhRHghoDf7YXI05H8UhlIBqpLHHfawXSpB+oLeZWyHkjGdJEM6FjfD+9CXNB2R8MjHvisiuT2fw4by8/kg/kMMR3DjH/yHozPcGvv1axVPGfYY/LOPWkjhFT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920877; c=relaxed/simple;
	bh=FAnZNiRqeUl7Ne2U4+z2H8Xn+OqrQ2UYadwz7Qe0Ap8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZtBAP09zc/Hixu0ZH1sbRV8AxbpGe5AL47+BAam+8LW7BrhUMydkJvT6W7Ubbmw7kMDXEgR+z/FkipGOhjwpktZzD1xiF7K5bKQSQM8m1E4KDeaumHwXUgOga5oTCOA3X26QEoJoTZapWrdBuaUQuK256rVXe5XcwpARoJi6P20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IY18pwlR; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IY18pwlR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920876; x=1762456876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FAnZNiRqeUl7Ne2U4+z2H8Xn+OqrQ2UYadwz7Qe0Ap8=;
  b=IY18pwlRTG9CoPeNp7yj0ASvzSpZT3ckrmLl7uHNTVutGeGeNYEYwKb5
   f65dZ3Wn9aBsmVgevGc1uq2BAG3KQa1FSbpppdewvgzdk8gioVj55UWed
   fGbVDyajuEIuxbEuYOGCpCIVhVO5XKFudCSFPwP+1eZyHD2WgHaH8cQm3
   dHX8IKX+oUaYwCUi92zudSipvO4K5JYQ0Q4OJ6OWIYxIJBrr70mPAthUD
   +UYjbGlLmZ+ENXIu7PdkNCG88W5A1DXrKqhAdv1YE8vgMSifxMWiXWWJ+
   09vLrGOxbncPGmF5OldqaGLkJDJkYqw4OupGFqKiUW8pzoOUntf15I450
   Q==;
X-CSE-ConnectionGUID: qDPz2mRBSHuMtlBNC/xQ8w==
X-CSE-MsgGUID: UAsUAwO5Qq6jKMWO6q2QHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41292047"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41292047"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:13 -0800
X-CSE-ConnectionGUID: 6oXbOKZDRWiqdJfoYia+Yg==
X-CSE-MsgGUID: 7yNp1XuCTqGZv0eIhDj5ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695410"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:12 -0800
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
Subject: [PATCH v3 10/13] mm: zswap: Add a per-cpu "acomp_batch_ctx" to struct zswap_pool.
Date: Wed,  6 Nov 2024 11:21:02 -0800
Message-Id: <20241106192105.6731-11-kanchana.p.sridhar@intel.com>
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
index 02e031122fdf..80a928cf0f7e 100644
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
@@ -930,6 +939,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
@@ -939,6 +953,12 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
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

