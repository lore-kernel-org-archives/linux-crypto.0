Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C466225412;
	Thu,  6 Feb 2025 07:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826473; cv=none; b=huLqiT79fSz9S2iDri6pO+3Xx9JhSoC+ucxagdM57gN8c4FU1k5Rx+Y536pYygIvcR/tanD8GqpPJUndXvxOUjPvFR89OIotYXFY076fJ5+XHlcdVfPhOc1gnM3oeXy1LRjOu3YZfk2eGQI3M1+d1GZPBqJU29v5yf5qBawveEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826473; c=relaxed/simple;
	bh=3AC0t67W9YXnQaqtfbv5O8FRwsYURPHnfKQ9TbAZwNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BBuliX7G0IFAQz6onl+ogct+auLC2wE4naAc2PzcIJx1rJ32hial8KKTIsaXnFCXb9wbw3pEBZ4Y/6xaSjMMDwe3QmrjVE1AFeTyffaJRXVyA9zxtf4p69lJj8IIoYkgdRutdTRFg47ry1uFrpJKbYgH+tnXXBm71ullQ4OFT2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8drw6WV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8drw6WV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826471; x=1770362471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3AC0t67W9YXnQaqtfbv5O8FRwsYURPHnfKQ9TbAZwNM=;
  b=L8drw6WVcz0l5+PL/Tjva+mGCrHs6aVlvGcfuCSBmXWIVUGK32C9hDBA
   SqnmlgZZp7iGtdf4GSRslX0UTFTR7odOIRcObDdRQyLwVbt3Y8cco8zqG
   X/fv273NV0Hd/srLXlSfEqpaHXhEp9DDty82aVOM9/9XexqKY2nksusOd
   7RzJTJGuztJCMJOdZSE2uiHvVNg4Uskvzjekm5vyByt/BNQ+Q9X9A/Vay
   udoyJYB0PJeljUpZgjxERYBgeokjH9CGEQOy+ZFS2aPmkDXF7I+GaR/yP
   6vFibNnfpYJcmYrWXsDaZ55twq6pQSBgevEP8V+XaKpSNyp7RuwFLC2Xb
   Q==;
X-CSE-ConnectionGUID: 0AzmggkhRdeAe+O2647mnw==
X-CSE-MsgGUID: xk7Wz4PdQeOSTqTWrv7zJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962676"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962676"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:05 -0800
X-CSE-ConnectionGUID: BdejDC0cSAOKneED2yE52A==
X-CSE-MsgGUID: pucbyX2lQJO2lO5OQM3S4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022610"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:04 -0800
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
Subject: [PATCH v6 06/16] crypto: iaa - Disable iaa_verify_compress by default.
Date: Wed,  5 Feb 2025 23:20:52 -0800
Message-Id: <20250206072102.29045-7-kanchana.p.sridhar@intel.com>
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

