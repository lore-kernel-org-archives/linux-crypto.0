Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2049520C004;
	Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023019; cv=none; b=MB0MnfhemFw3K/kE/elRL6gyhz/VqDZV+fGNHAMVJaKV63C17RjY9ifcInUA+KZG2EWJn5M8W0gnaErNEI0gfrLo3P/8eFgl4FgtABjXiiA+vNOpq79xjVQAhMMUddB1zA9GILcBiCBLOmTJGR5wvy+C/4RkVsn8g/6ed2Reu8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023019; c=relaxed/simple;
	bh=Gx3K9nc7SbqS7yUYzPYGDFgIwtQFFxvIkExs4HbX0c8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=psinCIA4C0CECSlaJmIk3xdB4067LB6YEHlkDOzYMk6t2P2OTurui1Gv36ipvR22Hxz92pvJJtENUTXx5i1O1MVUpBktJc6HoN3tKXDGru1zKfwxcQDV4ndRKGZu6oX4Lkreijo93JNTWXPCDk0FpPrwtecRSUoWIXP5N/67MgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3HzmmkU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3HzmmkU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023017; x=1785559017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gx3K9nc7SbqS7yUYzPYGDFgIwtQFFxvIkExs4HbX0c8=;
  b=c3HzmmkU/Uy5QRe7kCTD6Mjjz473Tp5pL4Khwok+Vuw5XKPLGjJxVUX7
   ptLhnCtdfijFT9DbewyTRtavi9WNbCxqYP4Y/HRcozb1hFQ58QWtlHslc
   FFRxaSGh+8zRu0RIz6IP20G/3NlVFQ4sLLzGPNKvvwAIQCUejdfClrSNZ
   fVBKgMkRX3b7yhHw+nwlGQiLrs7r7WMr3QLAG5JGUewl0KxWp7V/ndUd8
   csqkh2ledytQ15/Ehyy7ksYCZs/GxMj6bUyWppOE9odLaxxVpWQVCJ/JK
   udfypegLjkvm/h051G/W/3fu0bT3KAYSbTUlYAXcikFd9WHmqIJl0Rg7C
   g==;
X-CSE-ConnectionGUID: WInnkyTSQGqx/GzvFunTow==
X-CSE-MsgGUID: omCITIyqS5On8sOCw8pzaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820318"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820318"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: XWPtbTfHQgu+DgyqPU6tlg==
X-CSE-MsgGUID: 11JsMHtRTsenZH6/gt4+cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796277"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:45 -0700
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
Subject: [PATCH v11 14/24] crypto: iaa - Enable async mode and make it the default.
Date: Thu, 31 Jul 2025 21:36:32 -0700
Message-Id: <20250801043642.8103-15-kanchana.p.sridhar@intel.com>
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
index 1c4c25f0dc5e4..4c235bf769824 100644
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
index 19f87923e2466..7b5b202a8021a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -152,7 +152,7 @@ static bool iaa_verify_compress = true;
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
@@ -206,7 +206,7 @@ static int set_iaa_sync_mode(const char *name)
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

