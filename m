Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B63E13C9B3;
	Sun,  3 Nov 2024 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604082; cv=none; b=eK8CriJSr2/Y/xZXebf3uRoAqvyCDZHda8HOp2aHhemIclf0XtVnPvCU0PykVMZGUIHH+BlyIgQD2HKE0G4pmuBV+TaHK4J8RMhstJxb3tYJgTKZvoZmcEUooH1Hqyt3kpLATBiIGaHndkeaG3rfA8reOUUKprW5/WCept9SYrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604082; c=relaxed/simple;
	bh=yFcfU2b3t6Krq275SHD6OXxnKnpJ7Jmrcy/87R0bztw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q0uHdyVy6rJgHNoMY1oAj9ihSnPol6maJgcdGRbSZdT98z7boQA23xzM1mWb3V1L8mmjuBUNc4IT1rpOYF8rV2UElwbCeU9ZsRW1ev1WUr2ZisIb+xxdlWAN78sfNeoiv1JPTHrxjp7EgRAuvJFs04ki5ZzrBAFcoSmuVxkxTts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J5xFT5OG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J5xFT5OG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604080; x=1762140080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yFcfU2b3t6Krq275SHD6OXxnKnpJ7Jmrcy/87R0bztw=;
  b=J5xFT5OGBtS7vcf0+JkTXerKtHUzCLLPkWEpPsz2pMTs3GYbnwuVg/Et
   vyGVZbcmQaVsl5oWlA/AOQUl2hdLz9SLxm/nJ4mnlCBUdRz/dWgwtB4Ob
   3THQIyYJ+8ryF4Ce5PCFawuGtXQ9Uh4i6vZ0lBoO+YJ3WSGipIUpmz5Yd
   r78frB96gZiphbN/I5hmUUTdM1RGSBKNuK+Iqe//VbInpY1o9oQ2Lzm2R
   VWKKgAWmhFCd+L+/6k/rQJH+PnK/qCQNtTL2PWPPNwTGN2p4SFdC/UAc8
   Ze19AUFqHpH0mxz4fCwQ9FS7R+J68WhkMn3lMv3CyBvDtW8gqgH5795Om
   w==;
X-CSE-ConnectionGUID: gEJ5eK1cT4aGhL20eSnoxQ==
X-CSE-MsgGUID: aKsA0/NbRhKQpg6mf/5+vQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548284"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548284"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:13 -0700
X-CSE-ConnectionGUID: IZm7M30DRUaPx/sFE11RKA==
X-CSE-MsgGUID: y0vGMHT2TVG++pkTY3TWAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451881"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 02 Nov 2024 20:21:13 -0700
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
Subject: [PATCH v2 05/13] crypto: iaa - Disable iaa_verify_compress by default.
Date: Sat,  2 Nov 2024 20:21:03 -0700
Message-Id: <20241103032111.333282-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
References: <20241103032111.333282-1-kanchana.p.sridhar@intel.com>
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

