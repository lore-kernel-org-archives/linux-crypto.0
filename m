Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B248C3203B6;
	Tue,  4 Nov 2025 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247576; cv=none; b=FuSZqz20CHeBioOq+QJIAghkzJ5iuU2dVEVxmVOajb9TTh3RSMmYLJhpVDNhMUTXuNnJ0lHLuaASmsApWrK48nljunT4OGqgfraPSQkAhwRckAI0qXuMRMr6GA91p3YB5a64ECS16BrZTrHNGl8EY6dqvoRm+DVxmDPJpA6t4UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247576; c=relaxed/simple;
	bh=sBdbm5XI7No3D0jVnr6eOfnAzOyIcsZxr/u78wYlkzg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VLKaXja9ZYRwSku75xbRxNir383m9sH5IIn89Ni/kGLA4hu4yvG+nNZK8W2Shtu4oDmE/mUa+9EQk4z3y3ehnir/vOdKofdPi4WJ9r92wiStvdE0gCvySWw6LTkvQFrzDJWWC1rgxSxQk9skZrN+fXnL1gvPEyci+KkuK/qFf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eNyoFLnZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNyoFLnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247574; x=1793783574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sBdbm5XI7No3D0jVnr6eOfnAzOyIcsZxr/u78wYlkzg=;
  b=eNyoFLnZ1BPkxlqqAbE0yRN/+D17TK23ucy6E+6em5x5I67ADyAcmj5X
   Q8eEfrKUV0rRQ3KBGZhg4GwEfETxQDgUkQIZHYr7dBhKYmU2BygDZ/G2Y
   Mx6z+ZJX/lkwg6AbZUCQRoiwxKiyUYJFHM+FM0Rr3rqy6qEjeWzGC5LQo
   fsA/srNNCXKMDNTdB3evddlD4PnOB8EHmvChcsa8EBxGNoltO8sAx3ArZ
   39BfCVMNkDOFirsmnCVS0fMFI0+BJSa7CbyKgvVgsTuhd5Qbg4zPT2z5a
   8kSoC3bHn4u84YnQVV6HutEKMg9g/0YVGnv1pvZ6AJuqwQAbCPU9QNjXU
   Q==;
X-CSE-ConnectionGUID: TdtqsHUPS3CzBfT8iMaoyg==
X-CSE-MsgGUID: gXdqiNvaR1SsViw9eVhfyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798692"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798692"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: bR4lgby4RGKtYGquYVIuuw==
X-CSE-MsgGUID: WJfBIx7yQ2CJ+0ora8KM6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795836"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
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
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Tue,  4 Nov 2025 01:12:33 -0800
Message-Id: <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
for valid acomp/req, thereby making it consistent with
acomp_ctx_dealloc().

This is based on this earlier comment [1] from Yosry, when reviewing v8.

[1] https://patchwork.kernel.org/comment/26282128/

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 87d50786f61f..cb384eb7c815 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -780,7 +780,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -789,7 +789,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0

