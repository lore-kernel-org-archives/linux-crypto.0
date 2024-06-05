Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E08139D10;
	Wed,  5 Jun 2024 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717613501; cv=none; b=eYuJqXp4APuie0zOB3qNyrF+1vulUyjT6ElUmzcYo76wCHF+r8cXG3o3uRjnfTl/GlPkNpA2saZylJpio1YdJPvJ04Ly9hur8330c/p3gnW7azCd67J6TpSda7MSgZDD6SUhwESPoCpkJT8ESsHCy01PWw39AZBSJRWQpl3Behw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717613501; c=relaxed/simple;
	bh=6QVa32CvRhezMvRl7Gvfl2NwvxXkN30JpnVwBKt0WRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qa1yPaAQH1cNk7gWf9b61Owdmv7+m/wGzwgp13eMH4acms9JxklWLXGeePqJS4Fu+UapgP4BKgEWNDDAay1ZoI7uXitpZnwAt4UjW0CMRWHZq3U+4bBFos4vIE4OnzTPXjGy6u5ni1aicA2IGZQqoAkbOo+o3IO+aAlSx1vOHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHMJzN6x; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHMJzN6x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717613500; x=1749149500;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6QVa32CvRhezMvRl7Gvfl2NwvxXkN30JpnVwBKt0WRU=;
  b=FHMJzN6xvhZPjzPNdjoQD8Db74XUTJZeRWfSRmJdhCWMfbMVNKOzpEFV
   3UFbXuCE0Arc+j5cmWkSUXSpjwDF9mh/nA6NFf1Af0xG+aBJoSAiefT5B
   glwkLGQ+QJORtV1mM7Ryj25F1Rv9BQKBLoNuSx5FVtU7EldNejz8o9XBi
   BMHTws3akBvGcc7Tf/rbi0G97rp0zYWzGue1VhxoRjJ9mLEorPhaLsqdN
   zEb5MYxPQDKmv5CkvFIv3gZRtvoyEd8iA6TCba0+bDd8HJZ4KCSaTpdOY
   DzPvqdOA3IR/LMgrzWTOtjbDj0ipoFtUWbWKAC2KJghtgaKAGC3HjWZ8E
   Q==;
X-CSE-ConnectionGUID: R5AYrdKnTbW64XT92xKRnA==
X-CSE-MsgGUID: WxaFy9rjQPS5bevlu1QEDg==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="18093844"
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="18093844"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 11:51:39 -0700
X-CSE-ConnectionGUID: f+M3l6eUS5ef81bZmi8u4g==
X-CSE-MsgGUID: CJ3QLZUxTpy0CFBWvYZ9GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,217,1712646000"; 
   d="scan'208";a="37574813"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 05 Jun 2024 11:51:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id D0AE01B6; Wed, 05 Jun 2024 21:51:36 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v1 1/1] hw_random: Remove list.h from the hw_random.h
Date: Wed,  5 Jun 2024 21:51:33 +0300
Message-ID: <20240605185133.2535780-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.43.0.rc1.1336.g36b5255a03ac
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'struct list' type is defined in types.h, no need to include list.h
for that.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/hw_random.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 136e9842120e..b424555753b1 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -13,9 +13,8 @@
 #define LINUX_HWRANDOM_H_
 
 #include <linux/completion.h>
-#include <linux/types.h>
-#include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/types.h>
 
 /**
  * struct hwrng - Hardware Random Number Generator driver
-- 
2.43.0.rc1.1336.g36b5255a03ac

