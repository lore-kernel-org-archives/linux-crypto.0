Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6492F2343BE;
	Sun, 25 Jan 2026 03:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312178; cv=none; b=bUX0DD2fVSherwQ0/MUe4R6MU1wXPijjQvBg3zjeDqPpW1+wszU368phR3rOwwL9Z2yVmV1xK0CJLNkq/e1f25xB2fUqBLxDZ0FdhDhRqjQM13dpgXCvp5qAS/o/aE8rU9KaAnB1uIWz6/PSVVwtNze6f/KWjR6LBx4wTOoF03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312178; c=relaxed/simple;
	bh=vi7CJVPg5ib5wpU/YN0OFZ5h4huVEalzAff2p9W8l+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LK2Px6daMGmew0wC3irrXb7FBTixEo+LyeGzbpPB93wxKY3juPe/ugK84etPxMZ+9xcaT/8b0PlgwLQIa0FZ2pbbfTl3q6paa3Q6TUnZX6t1vP9HgpQtf3MigsOV5p+l2wp8Z5LubEX1u3v755Ob8uO5ZSqDfgnSxlwhh27o6jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J6phYPOc; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J6phYPOc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312176; x=1800848176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vi7CJVPg5ib5wpU/YN0OFZ5h4huVEalzAff2p9W8l+Q=;
  b=J6phYPOcl+6P/WeEsVFMxNouYk+47cxGoYU1ILz9+AN9nlN3LwqZO/Wv
   cGH7dw6nq3BNQkErBaglgXY/H2YVDzDHAgOE4HWwpM/pR1YQ3ONGTm0JC
   czLbOGRwLvZw8kytr1ZKuFvq34QwHX8C4zaWJDx3jIt6vmozm+pybrWnc
   xz1ruFwwMQcQhExAGusg9tORxRHuItEne6P9V3hvdkmNEeJ1VcoaNpXu0
   5uXcX01mJpCp+sNMgOqlPA6v79dqLy/O9ZKLRW0t4JFBU8ExJ5LyPIGMC
   8xbYfIx3Pyx9ErmfpiJWy5z6ogJ9DO9FJg5VSozpaEDAFeDt6LhpG8HJ5
   Q==;
X-CSE-ConnectionGUID: AYdNB67lShGwPtBCJBqZAw==
X-CSE-MsgGUID: vcqyjDLdRKWu+b1LUAky+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887664"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887664"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:13 -0800
X-CSE-ConnectionGUID: 8Rp86VFiTkeopzt3pAIreg==
X-CSE-MsgGUID: aj7MA65OQcOUK2WmnkvQ4A==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:12 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 24/26] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Sat, 24 Jan 2026 19:35:35 -0800
Message-Id: <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
acomp/req, making it consistent with acomp_ctx_dealloc().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 9480d54264e4..0d56390342b7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -783,7 +783,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -791,7 +791,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	}
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0

