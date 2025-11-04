Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72671318141;
	Tue,  4 Nov 2025 09:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247571; cv=none; b=Q3xlYkAinT0a/TF4k8lIoiGW1SbOr9CMegvlMNqpow5Oh0zmN622yDooVky57f86pTQ+zNPTV0IyfBCr5fzlNezpVGs3bpAhesiNwvXemoxPmfqAyAqf/jSYj683IPAX9RML0/y4sWP0zaxw2X/d51g7vcfgr1qVZBSV0sxKh1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247571; c=relaxed/simple;
	bh=1IH/u0z2lEAANJnIItHftCiWrnwwoKC3dUTlINqv6Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N0LPeUZwRHbS0m/sjOwHZVhO+aOWsOBHL/cu7hfLMYqoZSvFFBDIndwmXLeNTaiN88R/h4WNYh68j5F1ujLtd+pXjdc1GY7OJ4fS+ZSxxgtVVI214D5jOvsI+L5LNoPAb5cdPhn2Gf6ZAm4jzYlnXJjGvX7kwI6MDiKp1mpR/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FdRfrT2+; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FdRfrT2+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247569; x=1793783569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IH/u0z2lEAANJnIItHftCiWrnwwoKC3dUTlINqv6Go=;
  b=FdRfrT2+TNy537CBUZRAyNeBQuELMmwW8BSy1JO//wLK6rPKzv9HnhDU
   7L+L72RieYdV0bq6HgwkqY22Qw2zxQi37n3iHcdXmSLngfX2K6j/frs14
   fKcJpojkry9oLprL7/0GX/7UxkStN4tCSKjau9y5OAO8eqlZb+In6/zTz
   GoTOpXNLT7gE3mRYoZCxe5zO/hnkrJLdY/SBUjkEjoO3m/hY6Mfz1M9c0
   I2yNuK0t7g07LW4UV+WarGm7tU7cS+EzpXfDLtYYwRX9etn4mRY390Gmb
   XmhYSsXvhr04uVyX+LWXujoRS1CorrUMNdG3E0q0Ktgw3SWkDwZKpt07A
   w==;
X-CSE-ConnectionGUID: 3YQSVWOMTEajrz2YBOj4rw==
X-CSE-MsgGUID: P0KAi0FxQ/GGHNWto+ykLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798686"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798686"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: A1gZJX8ySVC5vBc37FP5yw==
X-CSE-MsgGUID: QnTC03PvSNGQq81wbKKUkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795817"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 14/22] crypto: iaa - Enable async mode and make it the default.
Date: Tue,  4 Nov 2025 01:12:27 -0800
Message-Id: <20251104091235.8793-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
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
index 0ff4ec603b43..d5e610ef4612 100644
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
index 910598405c5c..8f477577dbd1 100644
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

