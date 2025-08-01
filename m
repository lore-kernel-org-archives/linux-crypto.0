Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3788E225417;
	Fri,  1 Aug 2025 04:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023024; cv=none; b=LGOmQnOXCZCMfMdQJ6XqHCKVj14M8TIlCS2K223+/IDkPXhyBWdDRVX/0Lkukb+nuHPeG8p3EaijS2pRMSrJRiDeKS+pGQ/QPyr8XcfdkmVM6Q+GkLcOl0T1r5d+LTmxMPCwk+EHSdxfDR0PE/CUJmiFBqRlug1dMJEcIkbCbBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023024; c=relaxed/simple;
	bh=OnMvGoXOVZ1gus5tJpdLE5smcdMcmumbflpDULaNDSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hwdvmxpqm8nr39sybAotOcpQL20CKRHmoonXtYIm1/WlRxnRgqOA8ctVNWKkOBQBjF7gh0k5YerSdaC26SYEf0CP3qMfu38q9pZLpJwmvLbHuxbpxySTDtqzRvLA/iuA2yACftL+yPTZVlMDwWmTakHKdIUq9ugvX2I50EO+Q+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aafr77vP; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aafr77vP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023022; x=1785559022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OnMvGoXOVZ1gus5tJpdLE5smcdMcmumbflpDULaNDSc=;
  b=aafr77vP4nw6Nb0UJf4CdRlkTnhwfpNMKDB60GUDCHZ/Np58KeAff/bp
   S747H3rRz6rt2yuyBJM0tvosChM4VqZzB+Jz5bCfg/CZvYcYNRZ5gOVFg
   a22Mh+Og7+AD6ha3pMUgUkxzk81ZNnA+4kKj36Xelm3pYjuXykK+X/Lcy
   zFIopxkrz0eUVg1e1ekCsY19YYpl8QkqNKyoaNiGUTs/T3CuJrirfBzOi
   hRVkC4AYH8WKEImOFoHxPu3+YisKgD78qt6FItDkLMCmJH13ppbezamHs
   wkqS02w5P7m4dKSorsA03NmeZ/ILc4ycYDNdj29k4KET3T3dUmqdclAfB
   Q==;
X-CSE-ConnectionGUID: 6r85BmQFTwyFx/PM/Zequg==
X-CSE-MsgGUID: Ndp0wVSeShy5vjMQclIEjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820416"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820416"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: N1y6iMoLSoyLCpUvn21H5Q==
X-CSE-MsgGUID: y/snxBuOTD665WFu5z1tiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796309"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 21/24] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Thu, 31 Jul 2025 21:36:39 -0700
Message-Id: <20250801043642.8103-22-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
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
index 7970bd67f0109..efd501a7fe294 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -893,7 +893,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -902,7 +902,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0

