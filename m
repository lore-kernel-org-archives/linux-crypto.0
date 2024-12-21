Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7D11EC4F7;
	Sat, 21 Dec 2024 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762687; cv=none; b=mnjoR+hS+Dxiw87EcsRty5jjOAccfDqTOYueRYWUj9aTX0xZkRUV8+UkVq2BID+xygWdu3bsNkemUNyZqEl2FelX90VkOa85DWpBkLFIBWsnd1hoSd7qLnmcrrHsDN/yUMC86Ay33HyW5APV9JGNZ8+NMBY8sJ4HQnoNyyzRoVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762687; c=relaxed/simple;
	bh=3AC0t67W9YXnQaqtfbv5O8FRwsYURPHnfKQ9TbAZwNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A7sMDCYNTDRmc1QGzE4PfLLlYmgLgjyLU0Sj26P/fPjMCis++SRQoOV11rFzjJFts/HjHgZZVegkFNGqxNxomHUqYPRreIu0rs9GE/fe9nn7z2fYIdNl4i0rmWBqKwREaytNG37TL1T/RYLecJ26QW4oFsOhuRGLnfHPzCIEynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nK+Hgfjl; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nK+Hgfjl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762685; x=1766298685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3AC0t67W9YXnQaqtfbv5O8FRwsYURPHnfKQ9TbAZwNM=;
  b=nK+HgfjlXQy464lMuSwSn3EA7nFVooi9uAd9HsvNeKyGc0+Tu4RXHAb/
   RzK6iwUN5OpFxRsaP4bGJDecJeemzfjWN4pRgxtV9nAMwiRX/0f5hnzAb
   gboxJ5FHSIys0KMeB/cUGYSoSimSdbrEmL2w1r4C8zEp9iHIFDBs7Cd9j
   PSrPW1xkGsNl0j/PBZvuVPUR/3DWZ3uQOOv34hxA6FlX6qIlOuXU0+Mg6
   76bL0gT1buYWt+sh1pGHaK3XUd31YqAx3f9tHFJf4Xiu64iCBHKSTYAKa
   OSXGuFfZqOGX/RjG9KO9hH5xL5vgWdOANUcMMzsZf0U5SBBpfaIxnm4kA
   A==;
X-CSE-ConnectionGUID: PPUUucX7RZmwmeDORnbh5A==
X-CSE-MsgGUID: 9iLLWbaST/qLOoHyR4biCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021671"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021671"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:20 -0800
X-CSE-ConnectionGUID: z4BLm9q9QQGNlzkgRdLZ0g==
X-CSE-MsgGUID: SerZT0HOQPixyY2N5jgjOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184592"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:21 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
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
Subject: [PATCH v5 06/12] crypto: iaa - Disable iaa_verify_compress by default.
Date: Fri, 20 Dec 2024 22:31:13 -0800
Message-Id: <20241221063119.29140-7-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
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

With this patch, if users want to enable compress verification, they can do
so with these steps:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo 1 > /sys/bus/dsa/drivers/crypto/verify_compress
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 6d49f82165fe..f4807a828034 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -94,7 +94,7 @@ static bool iaa_crypto_enabled;
 static bool iaa_crypto_registered;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress = false;
 
 static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
 {
-- 
2.27.0

