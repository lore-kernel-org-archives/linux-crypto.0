Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FA228D8DF;
	Thu,  8 May 2025 19:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733312; cv=none; b=dciEb49xqakBx6ofygG4G3O8l8QEVjPaRsy54RwMWckontL7IUoWD8HEryOIO89YRA687yDgh7aEGh6G3X53CRyCzpSk5JJmQNlk8bMCDwlDwvCuihGx5WoWOEUYYU8UCkhOVMnfLgnk55UZGOaWOoq2gfjAvZOnVO8KTX1lXAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733312; c=relaxed/simple;
	bh=0i1XAzaurCUawIwqEktmrNT/73IFm7t499dJ0rxYn9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=avfodxHj7P8zWP3LWvJcj1z4/5ML++aFi+NHDwgIiTezobOxM+WSLLVRzaxIwDRWzzK6tCawkmEOeqZ9mfg5oS0WZr8t4mV6Cb9UDlxo3XV9Oalh2MF6Vom7g+bSKk/k/HeiOZrJUGm4PDbmW1wJ5EFPiNTSoSorODfKm/UG51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I9ugl6UA; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I9ugl6UA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733310; x=1778269310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0i1XAzaurCUawIwqEktmrNT/73IFm7t499dJ0rxYn9I=;
  b=I9ugl6UAzOT479a+eatsC015DHgSnh4eGE0SEZoQXo5H3Fb3sfFRnHBN
   AhRuWTzttmTCra/Skd8SE48MPWD9QZPecqv/BXuzDQZWRLESRsCbdct4n
   LNCIs6hpy1fJyfXXXzb6sH9KT+rGmn+1oB3PnHlXFD3TOTjorDXuNgZOp
   6bLJ0yN5rDfNpKHAXiHmSyEctyyzxRSOqqFUjJy0iAtQ7ubrdRuuyHe5I
   0cuMtuJZC4DD1dKsCXC68r2zUXHjDksUrT8KplH3AUGqaQf0SwJQ1EV/+
   E5wulkNxzSaHmqW6Z8hD01dLxKnbrDxEQgpojEhsZwl7RKPYC0/y1aNd0
   Q==;
X-CSE-ConnectionGUID: RNS89/qtR9uOyKlgsRuc7Q==
X-CSE-MsgGUID: 9IKMTjwQSF2BV82Egaq5Vw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454787"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454787"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:45 -0700
X-CSE-ConnectionGUID: RL1DGs4iRlK4lLe0x9IJOQ==
X-CSE-MsgGUID: 2bggYtsDRUq4VE1S/v3iPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880887"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:44 -0700
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
Subject: [PATCH v9 16/19] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Thu,  8 May 2025 12:41:31 -0700
Message-Id: <20250508194134.28392-17-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
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

