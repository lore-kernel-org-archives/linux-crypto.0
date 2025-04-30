Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58382D29B0;
	Wed, 30 Apr 2025 20:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046403; cv=none; b=kO8FRKSFYH2k4d0W/PMurjS47JBLDgMp4MXVHiuZLUh0PXtS6UFIq7PCI+qtBLDyDKS6cUeQWCOch1/uykdl27YpWatFYFU3HzpJ5IoGTnLTbzFfE8FIhvm9JV4we/Dpsbgr0P3Y5J1QMO3pHesERrfg/hEqrexQr7wdody/Xk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046403; c=relaxed/simple;
	bh=0i1XAzaurCUawIwqEktmrNT/73IFm7t499dJ0rxYn9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bt8+lq8Q6v8NfFqnZuXkynh5mW12JZ7krO2k/+bNOYKIqglf08j9D++gDLSPC/yi8bWrUXg3ohbDOPUe8IWUwiYkaaU4QQ43wSQPCxuSJuRIk3pXOuY2D1tCxE1OxncKmW3HQsfc0KXU5bfgCxuw4EiqhnOuBio8yC1MILUFp6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTs9XgsM; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTs9XgsM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046402; x=1777582402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0i1XAzaurCUawIwqEktmrNT/73IFm7t499dJ0rxYn9I=;
  b=DTs9XgsMnz/uI03y8l1+4ySXOpn+6pHsx01Z6yLu+RZeimpL3kAtiibP
   BXFeVTqT7wcPpx3N0It0pGQVRPknDIGOVo9D35BxCJjdlwlyCO/ni09B5
   i+UFMnm5WsSg4Ox4/j62qTFnZ/tL6p3eVkpaj5KU1BqQd+cmf4N0LMXBp
   Y3XfP2CPZv8ks66N35v71G0p6fmUH95TRVPLD9cLhWWETuvaOnoKQAS0h
   ILlgo/Y6d8K4PAKb/43xAvo/ksa6XSk3yvvV3XLs88FaD1jiC/sIJiukm
   bYjMqdiPWqNocuw+zDV6xpyqK9K/9Dnb3fx9y7gz2vgL0mK7xI0m7dBIz
   A==;
X-CSE-ConnectionGUID: 8bMDg+ByRDi0eCifs5RGIw==
X-CSE-MsgGUID: beG8S2BHTZKWFvtribKHog==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388701"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388701"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:21 -0700
X-CSE-ConnectionGUID: IRXs5gDkQQebuVPA0AIg0Q==
X-CSE-MsgGUID: WDtUBR3bRoqtGWmSDUecWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248939"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:19 -0700
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
Subject: [PATCH v9 16/19] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Wed, 30 Apr 2025 13:53:02 -0700
Message-Id: <20250430205305.22844-17-kanchana.p.sridhar@intel.com>
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

This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
for valid acomp/req, thereby making it consistent with acomp_ctx_dealloc().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 238f92e63a22..717835f214b2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -292,7 +292,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -301,7 +301,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0

