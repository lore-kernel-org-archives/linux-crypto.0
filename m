Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D82C0318;
	Wed, 30 Apr 2025 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046393; cv=none; b=urPpGuD4dwAtDO5Ih+jbLjAxiO1ZqE9J3mgtopEfsj5vcfK/rrigS6fvwCpC3/v5OmzqSfWm3uYHvpeJeK1rQR/T92u97+5aXFo5MRv+bupLaKX/Ec0W7YOUVU7/CmurUGfAz7ZV0XUeNOxhVb9YHsXdDrclruKzvGQu2li8q5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046393; c=relaxed/simple;
	bh=sJFxWyA6AJF6CcAZ5xFoncDGNwqA2S5ppE8eb6ZDAWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZLXmgUXhMGfL6mwooeUaB1O8P/lCCffpA/sGF01m5CRq0N3kplSZJPqwqZeoIaCH2RP9MNaDPWPz/SJ6cC+wi1xo6x8g++qUhRjzkr6Djd2UUE60351sE6XzW49JZR0VqkWy9ZsXp8u5+vkWsXZ5h35mPl8WYvTKrisLwfrL3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m07ncGk3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m07ncGk3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046392; x=1777582392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sJFxWyA6AJF6CcAZ5xFoncDGNwqA2S5ppE8eb6ZDAWI=;
  b=m07ncGk3GQpdyH5eT+7TGnscRa+7IRzCrz61DqYjDoPZo0RiLxhjTmT4
   4I0dKxeXAVFJoLBPh0MrdaqM0r9421XwcmowjOqgmvWz+erkKAcFfxgXq
   9ngf6yqfPo5ZO7vsc/AR5nBF6GJ7qnBaJV8yCt/BbtXVvq056DTW05O/b
   Ub0jVreOHvIG4pDl5ahGJ4UFZm8e9CJax+q5VuX1TxGvXUQUgnHP8tIXC
   R5WC9eZ8ofOUoJ+9+F9WZf/ErjjH+4jAI2wlqCuxeOSFHjiiHAKtrnYcj
   6/e6keh/E4nh57oRmvg5WvBv4ATPZcVp37CRw025Dcle6eyspnZPGTIji
   A==;
X-CSE-ConnectionGUID: yiGbkz7xQZqYtSr6ZAgk3A==
X-CSE-MsgGUID: fPD4v95gSEadNRuqxXm5Eg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388521"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388521"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:10 -0700
X-CSE-ConnectionGUID: ZSZ9KhmCRJyz09lh3q5fnw==
X-CSE-MsgGUID: 1GdV5HP6StWduSbWaC2+gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248886"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:09 -0700
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
Subject: [PATCH v9 04/19] crypto: scomp - Fix off-by-one bug when calculating last page
Date: Wed, 30 Apr 2025 13:52:50 -0700
Message-Id: <20250430205305.22844-5-kanchana.p.sridhar@intel.com>
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

Fix off-by-one bug in the last page calculation for src and dst.

Reported-by: Nhat Pham <nphamcs@gmail.com>
Fixes: 2d3553ecb4e3 ("crypto: scomp - Remove support for some non-trivial SG lists")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/scompress.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index c1ce12564299..1ed52b9740c5 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -215,8 +215,8 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			spage = nth_page(spage, soff / PAGE_SIZE);
 			soff = offset_in_page(soff);
 
-			n = slen / PAGE_SIZE;
-			n += (offset_in_page(slen) + soff - 1) / PAGE_SIZE;
+			n = (slen - 1) / PAGE_SIZE;
+			n += (offset_in_page(slen - 1) + soff) / PAGE_SIZE;
 			if (PageHighMem(nth_page(spage, n)) &&
 			    size_add(soff, slen) > PAGE_SIZE)
 				break;
@@ -243,9 +243,9 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 			dpage = nth_page(dpage, doff / PAGE_SIZE);
 			doff = offset_in_page(doff);
 
-			n = dlen / PAGE_SIZE;
-			n += (offset_in_page(dlen) + doff - 1) / PAGE_SIZE;
-			if (PageHighMem(dpage + n) &&
+			n = (dlen - 1) / PAGE_SIZE;
+			n += (offset_in_page(dlen - 1) + doff) / PAGE_SIZE;
+			if (PageHighMem(nth_page(dpage, n)) &&
 			    size_add(doff, dlen) > PAGE_SIZE)
 				break;
 			dst = kmap_local_page(dpage) + doff;
-- 
2.27.0

