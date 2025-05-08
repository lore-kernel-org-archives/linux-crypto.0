Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4123628A729;
	Thu,  8 May 2025 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733301; cv=none; b=o/Jm7/V8l4xvf3Fb+c7i2X/U0dR9xHnfPUxqweHuzYn5ihHv7uJBS3pg0K7cRcEeAQcvHkVDIOL+/pUB/4sA8xXhvOYeqsU7Y6ribuFyT/xfeSazYMFsw9siOFb7ygGVtL9/Uxdrbvb4iWBNp0/ICcEf2cNKdUk/4HuhOyhJT9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733301; c=relaxed/simple;
	bh=sJFxWyA6AJF6CcAZ5xFoncDGNwqA2S5ppE8eb6ZDAWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dbKVDSLGbVtTZw29covT5i/MBkvjsKOtOGgXnZ/i339LbC38AkuhP33JEF89jnBzzXZ7V+GeCDqPerzuU5IqKRvtm0b/VZC6ee1USh1NVvA6KpbaNKjb/nREWX2jnkTFZR+yV807amRoPKfH6YBqqIYHkvgHZ2SuywVIfrHSA4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/3txU3q; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/3txU3q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733300; x=1778269300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sJFxWyA6AJF6CcAZ5xFoncDGNwqA2S5ppE8eb6ZDAWI=;
  b=i/3txU3q9C6LrLGFntYsu+aEUrCaRWkLOxbNkfESAmvV9WQ0EWRQyEcI
   XPpdES2NAaseHgbJvE7T+5RdDseXJkSavk0OvgfU42QY54QhIY+TgLs3S
   Bp6pFwuTvTwKcQUokx6dQXkMdMxemVEqyUhz+P3XFoOCKQnjshdf/VzVJ
   crxz+RfLP/tdN03LCxG2vXpa3NHN24MAlyz1Bzasvw0Hzcrvjm2gr3PdW
   kD9XFH/owemMroZVn22yg9kT41EytV7a22uGg9HTINY7gUKNjKj9dXeoW
   D5vKj2l2oAZOoZ+BNhQZTnGFp7Dn7LijsA0J/Z0L6QlhEF8EOsZyb9yuW
   g==;
X-CSE-ConnectionGUID: 50Z/c8HGQvGlk5nEEYEaDA==
X-CSE-MsgGUID: jYKLDgceRv2X1L09zlHGUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454603"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454603"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:38 -0700
X-CSE-ConnectionGUID: LAb/b0l+REKDfRVJBNReeQ==
X-CSE-MsgGUID: CFUP26gyRf6tnxsLmGwIbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880829"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:37 -0700
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
Subject: [PATCH v9 04/19] crypto: scomp - Fix off-by-one bug when calculating last page
Date: Thu,  8 May 2025 12:41:19 -0700
Message-Id: <20250508194134.28392-5-kanchana.p.sridhar@intel.com>
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

