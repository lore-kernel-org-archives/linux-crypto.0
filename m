Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D51E28CF73;
	Thu,  8 May 2025 19:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733310; cv=none; b=nRAPuuRS8RsmqK0Gdu5DX6+TCNZSLzV/JJhNxmprV9N4jToEiiyyOkAtR7uoBPG10z2USxPODf7lI2uSyOUm8SNErLbWmJFW8YMVA77GbITmgRTziATC75Q0WjfyH6KOcCfW77r/waf83p8HpZNZoHyw9kg8nz+Zlg0FhV69ltA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733310; c=relaxed/simple;
	bh=kMvINlBJY0QU3fOT+sYo/6tn6u6i0LjWeSaNDcOydOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pMWRfdzfcgndLzq9QYtfswpJ/EyYpxPcU98w0Gboo7P9RoIdgprMCfH90leO6gI5o+8E0q2oopKI0MO8K+e5FlLEfugjfYy9d44iLpYJpUIULv3DzlsmmhwhYT9HClyoIc/IQ1kikI/vYzazBhFov1h/Kna/2j2WiyVU5RSJbgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erGG6t/I; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erGG6t/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746733308; x=1778269308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMvINlBJY0QU3fOT+sYo/6tn6u6i0LjWeSaNDcOydOE=;
  b=erGG6t/IF96Fgdd7wVGMm10IcoKJF41cL4a5QEOGHAJtmP4T3Lw44Jxg
   K1K0VgnPzZBOMqg/DDczvP9HVTbjfhHPJDtKxm8J1lBp4vBgcXJy8QDO1
   d3ok0Ul0KAz5bFdwi/O7qgUbfiERFicgSoJ11WlZcTHL8Gouu6bGxk2GB
   RgSicY4L7Ik6M6qP/BXRWuWVkLH72FSSye9Ivkppci46rnEp7/eThs4PF
   o0P3qOz/R7T9RXcFIcJL46fTg1or9eDyu8JbZvavI+FobU0wJRXcV92GT
   SFppF1+y7pg7ueFFawa01vkXnBqYRaefho2ivFdyMQYZUxAQVDNxAoyWi
   g==;
X-CSE-ConnectionGUID: b2gmlb7MRlWtvqHSIOJzdg==
X-CSE-MsgGUID: qewhLce5SfCOayyhK3oxog==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48454743"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48454743"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:41:44 -0700
X-CSE-ConnectionGUID: tCpNilXNQoyk8aWA8OjO2Q==
X-CSE-MsgGUID: zH6Deve8QUKZp9tOA2PxkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="136880873"
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
Subject: [PATCH v9 13/19] crypto: iaa - Disable iaa_verify_compress by default.
Date: Thu,  8 May 2025 12:41:28 -0700
Message-Id: <20250508194134.28392-14-kanchana.p.sridhar@intel.com>
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

This patch makes it easier for IAA hardware acceleration in the iaa_crypto
driver to be loaded by default with "iaa_verify_compress" disabled, to
facilitate performance comparisons with software compressors (which also
do not run compress verification by default). Earlier, iaa_crypto compress
verification used to be enabled by default.

The iaa_crypto driver documentation has been updated with this change.

With this patch, if users want to enable compress verification, they can do
so with these steps:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo 1 > /sys/bus/dsa/drivers/crypto/verify_compress
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 8e0e98d50972..bc5912f22ae1 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -239,7 +239,7 @@ The available attributes are:
 
       echo 0 > /sys/bus/dsa/drivers/crypto/verify_compress
 
-    The default setting is '1' - verify all compresses.
+    The default setting is '0' - to not verify compresses.
 
   - sync_mode
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index cfd4f5ead67b..815b5d718625 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -83,7 +83,7 @@ static bool iaa_distribute_decomps = true;
 static bool iaa_distribute_comps = true;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress = false;
 
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
-- 
2.27.0

