Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD1D20B1ED;
	Wed,  6 Nov 2024 19:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920873; cv=none; b=PM1VQVIV+GqguVHHn5XPpr/t7m+sPT7pxBdomWa2b0RoAUPrk0bFy4DnkGiaxKMKyfaxFlkMRzhWKNHyFOB+ASz7x+eIHC0Nklcu7thGYvaqcNpOZGgE97IbxTsLlY62ZWY0UYd15bDjSgN6PbKk/JYytrFK2teujP7lLJazFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920873; c=relaxed/simple;
	bh=yFcfU2b3t6Krq275SHD6OXxnKnpJ7Jmrcy/87R0bztw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hF2BxYrjP/vJROk5uL8o/2zIEKHhEEOrqh0Wpa1qF/JrU6Ae9GauL4RW7zJ8bd5waxSTZCmN3QwYUdIkn+iGJU5PcXoqh4Bm3oYZ1MJnlXkJfoZHdB5tsSrVRkvAMCMUZfH2K5d09z4KuwgoP5tPqdggwQmIYTSBPt/c+0EK7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RWxPAdgx; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RWxPAdgx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730920872; x=1762456872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yFcfU2b3t6Krq275SHD6OXxnKnpJ7Jmrcy/87R0bztw=;
  b=RWxPAdgxylYjUG53rTJ8A4T/7bkhZo95xssy3o/3sj1GmK/FpKVEzAeR
   DYLRyB/rcfhGvjGeh9+SBTddYjFTRQ3JxLjnvvFse4NCZC9cvHUedhmzA
   VF4xZXq2xQrVhG0ZDj1o+U2XC7ZmfovD3s9la0NFeb9V/FCjybiY/wVid
   GGa6ASV7vumFaXSu24XUUbb+o3noy4NnbzoyQ8twcZFGqnX7/XadPMk1o
   ifUXt8L2PjiTEWhSyEG8iGUN/IQaKE8ki5XX8NhR3YfJpDd7mgIcbwS7U
   KGwJ+5Xoryy9lfRKjUlSt3dbrT7VgQOQ6aGPXglWcDDrlfPkcNfnZ7cKk
   Q==;
X-CSE-ConnectionGUID: id3Y6l5VTFeDCCvN939Jbw==
X-CSE-MsgGUID: 3kkLtd0CSdGNyyLrW5G2Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41291984"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41291984"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 11:21:10 -0800
X-CSE-ConnectionGUID: X7LtG8ZhSOm9GUcPjmI2MQ==
X-CSE-MsgGUID: Ch43AaPUSz63XfnLGxWmQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="88695388"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 06 Nov 2024 11:21:09 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	zanussi@kernel.org
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v3 05/13] crypto: iaa - Disable iaa_verify_compress by default.
Date: Wed,  6 Nov 2024 11:20:57 -0800
Message-Id: <20241106192105.6731-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
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
index 13f9d22811ff..c4b143dd1ddd 100644
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

