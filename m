Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EF12BD93C;
	Wed, 30 Apr 2025 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046401; cv=none; b=aw2QRhd84aDQW7RYj1W0bkTfnPiDTFgMiN/NehVYAt+tng6gEwAr8Qz0nWHIrGnU7sw/nnt767E1mkbjINpw79LGtCq2HY5UBb+YRBpq2pcNkNhPt5fOk8KdaihqK5u+XWD9Z9WgvXPWqtaeYv/nMFbptCKW1sjPFB7Hv33dl/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046401; c=relaxed/simple;
	bh=kMvINlBJY0QU3fOT+sYo/6tn6u6i0LjWeSaNDcOydOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mv5ZhYG4SeWXXQguKAnCUrY2LpI9K5zsnKiDyxvI/FEPx8p4zke3saMyOYDio/KXnoDkzefBSP9D07ski5NMl9C99Ocp4C10Zx/8BHgG9HDlJSHBPmZn4y+CBzgulYcoPl60it27f/xHipl/DdXrTMh1GYMoZ/On/uEkuPVYphk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lEsyDr+b; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lEsyDr+b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046400; x=1777582400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMvINlBJY0QU3fOT+sYo/6tn6u6i0LjWeSaNDcOydOE=;
  b=lEsyDr+bOFNt41KlTr1Ffvg2kLm2X08l8C3yyhwKMZ2IMWxqkHvdy7P5
   i0j8axhA534m0UkT9mi8UYzbZr1N44NT5KeO3Gt8gpfujFx5APHpHKJcB
   M4bBj/Qp03oyseIoAU7j+Zsg16F8GZZMQ5yD3Nuqn30qB4k/n8pLwuAbG
   cBAJeZjg2BqQMHeAm8SyWKZR4QrmipaHmdz9dy91l0JItIAFxS9TMSIxI
   i3CgbJ7ikClZTlhf5nhkAgSKPIJbZ253x4T3On4lPY/x+vbN1Xo9mwo8M
   MzL7vDSexUhYKZBYbvaFvNjh5zyqP+1Fmorx2bDuAaJJkL+dAyLSawGpk
   A==;
X-CSE-ConnectionGUID: CCWbk5vhS+ajGxUJcRSzrg==
X-CSE-MsgGUID: HSrz+qdiR1GxROP1BcGJQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388659"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388659"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:18 -0700
X-CSE-ConnectionGUID: FAB0Yim3ScWNBgAAQuz5mg==
X-CSE-MsgGUID: YqO5pxEATxO4SaOFddgc5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248929"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:17 -0700
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
Subject: [PATCH v9 13/19] crypto: iaa - Disable iaa_verify_compress by default.
Date: Wed, 30 Apr 2025 13:52:59 -0700
Message-Id: <20250430205305.22844-14-kanchana.p.sridhar@intel.com>
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

