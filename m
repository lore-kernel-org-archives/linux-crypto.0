Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57CA22653E;
	Thu,  6 Feb 2025 07:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826480; cv=none; b=ZNxQsK0hJg/oebUEPklWv01Ss/S+lCLrfLwIhF3WjcPlxV75dEKfUFBjUy0Teyie6hGV7Z/oPp3P5A6bBBFZNcUvpRa7j5d6MCnhIL95PbzYYMB+AnnKvyxDsye0yTG39/nVIoYGnIC2tqQSXwZ5hoQ4HdAloolLeVeqrNpov44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826480; c=relaxed/simple;
	bh=iqZv8rJXdWI52EmscIRZweGSd8xTWCD0Rr/EovMHLuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XMXOs87u/SjyOMJRfNTq3GEBV6TgJrPhPq/kX0zYFN6mXjh/J1CeyEExT5ZDrQ2aTt1nZrgEES70Uf15irT9FYSSAc3F7UGhGOgCRKG4IyIopv7DbAgNkPk6n/GtNsPbK7fBHiHpILA0FwpE8fkWIm1zonAd5M4kNMgU5l/3r1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eess9Iex; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eess9Iex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826479; x=1770362479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iqZv8rJXdWI52EmscIRZweGSd8xTWCD0Rr/EovMHLuY=;
  b=eess9IexY9pUhwNnzWs41PRhnBZIipSIrnNB9kG6280M/tvM9YwCGI08
   HrfDJgliSanxtGy6Mr8OnCQm34GFa5Yz4qpfzxqULOlpkMGGxUK7HDD1J
   4tdlAa2ADarkexk/agX4Su9kTtgGP+fROPxScvf4QUKP1Y55PWihMUKyT
   ihyU88YiiPFTwGO+oyKr0FlkCzskD0Z1q9IaBJSwLwZPzZLznehIbAvly
   yw3pVDLti5mA5sS6EzZ5XiYT3LUJ2fpUPv+N9qV2NcT0iA1CnWofgn+Oz
   QzSOvseNzNrJT/LYprTVM9aSIILZHukkW4XXA9mK8E4Va6X105tMilI1a
   w==;
X-CSE-ConnectionGUID: C+mUYK7ZTQyQYKKjjd77dQ==
X-CSE-MsgGUID: swCcEsNBQ96kk12qjLy0pA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962734"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962734"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:06 -0800
X-CSE-ConnectionGUID: ILym3snHR9yvBXAi4N76GQ==
X-CSE-MsgGUID: LTcU3nkoQeadkuMSgJpNTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022646"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:06 -0800
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
Subject: [PATCH v6 14/16] mm: zswap: Introduce zswap_compress_folio() to compress all pages in a folio.
Date: Wed,  5 Feb 2025 23:21:00 -0800
Message-Id: <20250206072102.29045-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch encapsulates away the computes for compressing the pages in a
folio and storing the compressed memory in zpool, into a distinct
zswap_compress_folio() procedure.

For now, zswap_compress_folio() simply calls zswap_compress() for each page
in the folio it is called with.

This facilitates adding compress batching in subsequent patches.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index af682bf0f690..6563d12e907b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1509,6 +1509,22 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
+static bool zswap_compress_folio(struct folio *folio,
+				 struct zswap_entry *entries[],
+				 struct zswap_pool *pool)
+{
+	long index, nr_pages = folio_nr_pages(folio);
+
+	for (index = 0; index < nr_pages; ++index) {
+		struct page *page = folio_page(folio, index);
+
+		if (!zswap_compress(page, entries[index], pool))
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Store all pages in a folio.
  *
@@ -1542,12 +1558,8 @@ static bool zswap_store_folio(struct folio *folio,
 		entries[index]->handle = (unsigned long)ERR_PTR(-EINVAL);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-
-		if (!zswap_compress(page, entries[index], pool))
-			goto store_folio_failed;
-	}
+	if (!zswap_compress_folio(folio, entries, pool))
+		goto store_folio_failed;
 
 	for (index = 0; index < nr_pages; ++index) {
 		swp_entry_t page_swpentry = page_swap_entry(folio_page(folio, index));
-- 
2.27.0

