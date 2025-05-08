Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A93028CF67;
	Thu,  8 May 2025 19:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733309; cv=none; b=gVq9YNA+fpzKeeajb8MLhI4LlUq6l5rxEFTzot4TqJ9B+lnsiZbBKN1mAGKX1Ef01avdXz+bMaLl9G+q3jRSjTkqtxW/Bc8nkegWtToQXuB7wcQz3mTuAsIBYJRvh6hEHLxfQsjnEm3XXvod0AICp6rTtHExiFyvlrhfU7VniWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733309; c=relaxed/simple;
	bh=zk8J++ATRu4+E5dh9QqEjlY39chTwGmrGHh2DWD3/3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vqz04m2tgDiG5fkYhBpao3VCGg1yt6tHugRHUondTtnB+Vnf81zhtjVJ+08gHnr6ytwKDycBDmNCMob7z9urstVYhoW9W4nSrLd/SyWefFCUjVq4AMGvAjFkT82eCiChKp+kLY9pnDOaKcdU7uKIEShUGTjROBOipiBBh1U+aUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cw8Wr4lF; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cw8Wr4lF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733308; x=1778269308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zk8J++ATRu4+E5dh9QqEjlY39chTwGmrGHh2DWD3/3c=;
  b=cw8Wr4lFtKW9KXWre9AsKM0UdNZvjDgFLVOdlAubbXvUDOzoMFCIy4mH
   uIFbKHn1SRF04XlB6iYD+ib6ld6WD27JQgWSqb+DzD7lRkUdoiCmIJ4GG
   s8etx8cN5Qe4i0VDQEWEjRV4WM/UlX7wA6q5iST1LK/LXD0N/nvcKHac2
   9uSMkAPniHcZHqlb201IhZtVWNy2l3S1+4ReyerMrPRUqKoaThRLMM0cc
   7kFi3zmXtn/OiGZ65+hCgRZ+L4SflVjdMXtGTqWZ28ZZfMxW24rQvCByq
   J4OaiIQzajy+J4i9K7qrTskzXcKZcQpvToGJolryvl4MbMCobbQ/ZUNE2
   g==;
X-CSE-ConnectionGUID: MTQElj6DQU2xplp1O3Z7og==
X-CSE-MsgGUID: 6PEbxrArR5aJ1f8bmqMq/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454729"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454729"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:43 -0700
X-CSE-ConnectionGUID: tI5CF4s/RR2uTvPat/iG5Q==
X-CSE-MsgGUID: wwdVPb4rQnyFdInDQ0eDQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880869"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa010.fm.intel.com with ESMTP; 08 May 2025 12:41:42 -0700
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
Subject: [PATCH v9 12/19] crypto: iaa - Enable async mode and make it the default.
Date: Thu,  8 May 2025 12:41:27 -0700
Message-Id: <20250508194134.28392-13-kanchana.p.sridhar@intel.com>
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

This patch enables the 'async' sync_mode in the driver. Further, it sets
the default sync_mode to 'async', which makes it easier for IAA hardware
acceleration in the iaa_crypto driver to be loaded by default in the most
efficient/recommended 'async' mode for parallel
compressions/decompressions, namely, asynchronous submission of
descriptors, followed by polling for job completions. Earlier, the
"sync" mode used to be the default.

The iaa_crypto driver documentation has been updated with these
changes.

This way, anyone who wants to use IAA for zswap/zram can do so after
building the kernel, and without having to go through these steps to use
async mode:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo async > /sys/bus/dsa/drivers/crypto/sync_mode
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 11 ++---------
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |  4 ++--
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 949bfa1ef624..8e0e98d50972 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -272,7 +272,7 @@ The available attributes are:
       echo async_irq > /sys/bus/dsa/drivers/crypto/sync_mode
 
     Async mode without interrupts (caller must poll) can be enabled by
-    writing 'async' to it (please see Caveat)::
+    writing 'async' to it::
 
       echo async > /sys/bus/dsa/drivers/crypto/sync_mode
 
@@ -281,14 +281,7 @@ The available attributes are:
 
       echo sync > /sys/bus/dsa/drivers/crypto/sync_mode
 
-    The default mode is 'sync'.
-
-    Caveat: since the only mechanism that iaa_crypto currently implements
-    for async polling without interrupts is via the 'sync' mode as
-    described earlier, writing 'async' to
-    '/sys/bus/dsa/drivers/crypto/sync_mode' will internally enable the
-    'sync' mode. This is to ensure correct iaa_crypto behavior until true
-    async polling without interrupts is enabled in iaa_crypto.
+    The default mode is 'async'.
 
   - g_comp_wqs_per_iaa
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index d577f555d6ab..cfd4f5ead67b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -115,7 +115,7 @@ static bool iaa_verify_compress = true;
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
@@ -169,7 +169,7 @@ static int set_iaa_sync_mode(const char *name)
 		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async")) {
-		async_mode = false;
+		async_mode = true;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async_irq")) {
 		async_mode = true;
-- 
2.27.0

