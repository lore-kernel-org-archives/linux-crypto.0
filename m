Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AB525C71A;
	Fri, 28 Feb 2025 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736834; cv=none; b=q8U86MF41UdVqd6Q4PTKFrNj9yVB6vcOQrscQfDXaFQJXT5vJi5gHGPEj7Zx+5eY9B0a6IWRVSlZ6Ir1UTBEF6Ma3e5w8zv/hbbOYowAMv+xHzKyDvIRdncF6RnIMylLcb8hbf/vOwJqx2R4wKmKmP/d/kR37dK4iueWlB6cHto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736834; c=relaxed/simple;
	bh=VRzCnyQyEfhyAHvAPp33ZwaL6nzqmuQ9xsZtH/mrvjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nbhB96aBpc39biEmyCJAJKDt/36KZjscKPOigc/PhSdH7why70Z9IlsnQXyr9DEspANeiqTebItSJ4v4wAqMuVOqDfy3RKsU7E//GGLLgiDZmI52g4vkOUQliOI30gkdW/1DEqxJmcdMCyFwpudoYl31fRUeFAjezZip5rJF0YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ExQrjg+p; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExQrjg+p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736831; x=1772272831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VRzCnyQyEfhyAHvAPp33ZwaL6nzqmuQ9xsZtH/mrvjQ=;
  b=ExQrjg+p0HaqVNUMiLRnFFR6/ufw7XadOrAPYBRezUJP+cA99iecrkrS
   04TTsjgD3QS+cR4NnO6FQQg8NbgezuDHfhu4VHSVX/xcgNMDDTZ4LQAYV
   ybtopUdZ7yF2jH9FyyGVv0VbBT4O3fJTad2bl32yX1cKuuH9pGMuak/0a
   e5NGupxTG5OW3TsFnGfZ/lPDdDAMuavWeSaFxSZaamUztJyNdevycd3N9
   fGnmgPY8eDIgTSkmuBJDDm8A9+21lXYAHTBkmbsu4zNvgFl1Ll7w/vlZf
   8YQU0Kjb5FEFKgr8ia7Sk3m7Jc1cHDrZDt//2kBNg7TbdEMtV/tpdqE6y
   Q==;
X-CSE-ConnectionGUID: gbgVYwBlRF2kxgzAIGTLSw==
X-CSE-MsgGUID: ulnX63r7Q4+p/YHBT8F7qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902615"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902615"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:26 -0800
X-CSE-ConnectionGUID: X0/nNyTWS0ykGFG2AYIKDA==
X-CSE-MsgGUID: uQLjgsO6REGaSnplKdf3iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325713"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:26 -0800
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
Subject: [PATCH v7 05/15] crypto: iaa - Enable async mode and make it the default.
Date: Fri, 28 Feb 2025 02:00:14 -0800
Message-Id: <20250228100024.332528-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
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
descriptors, followed by polling for job completions with or without
request chaining. Earlier, the "sync" mode used to be the default.

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
index 8e50b900d51c..782da5230fcd 100644
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
 
 .. _iaa_default_config:
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a9800b8f3575..4dac4852c113 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -153,7 +153,7 @@ static DRIVER_ATTR_RW(verify_compress);
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
@@ -173,7 +173,7 @@ static int set_iaa_sync_mode(const char *name)
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

