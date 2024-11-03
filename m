Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4057C70804;
	Sun,  3 Nov 2024 03:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730604079; cv=none; b=sIxmBidBarZhB5BE75VSLuhgOnRROfMqoUAYncTu1/7DltWnRp3Xe1CwZEiPXcBDNqG/1Bdhf4LboC6eHCCq/TVewwhHFfgQxEKWxgd413u98+9M+qxr3PnKZDo3mGHAwTdpdOZ15IbyxqrDRKWlga+cx90JNS/VkMFj0qytf7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730604079; c=relaxed/simple;
	bh=pX2jvauw5wJ2+nUrjP9yXpyaB7Rg+Ni/oUTJYJHTKmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rdazcoripUNy1GECjNXBeBbGHcDzVySMuhsGP/8Bl4tml0BwIscF9ft65l/J948zuPE6IXAf7b6wjDRZu+vhpSfR0XEFe6vzP8GWFItk9KNcuJtC++3C2Dk54c2MEY+6VXcLgBWVbs7mp5kDPshgxw8IiEx+dkZJTw1JnK0h3n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBZ9ph+d; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBZ9ph+d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730604077; x=1762140077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pX2jvauw5wJ2+nUrjP9yXpyaB7Rg+Ni/oUTJYJHTKmc=;
  b=MBZ9ph+dxE2qI2bkTKfkfavdsaMnP+Y7GU55ANPvHhv+Xi53Z8l+KZtX
   pGuoez5FjCiXYvabZ62Hn2DiCNvK3Zn5a35Sq3s8NQ2rY6ynIdWjNmwx3
   SWiAy3z+eaGLFRaxaM/w+oabXYQZZsCV/RnoQoeoTMdDfZMzGmWtPSFNY
   /QZdCrirM4etxZjFLWLz9P8R/6hJD/8Kc/HXOr+VenZ5LNWRfcxo+O2ja
   7LE1+7JMuVeefoQ8KyJGGyYzyS/oAk7ASWG1xwMto3ia2ps1xlp2NAiC6
   ZEqfFDYN4HItiCohFM/67axXWW8DEh9IZunQ5/xlLcja3G5mtxEtnOAlw
   g==;
X-CSE-ConnectionGUID: evOk376OR5y7JQ+P7sXP4Q==
X-CSE-MsgGUID: pMcLC0MpTU+C28MgcUCR2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="30548266"
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="30548266"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 20:21:13 -0700
X-CSE-ConnectionGUID: wD/bMYhARqyYIrYFEHpnGg==
X-CSE-MsgGUID: wRKdRZrCQCS1ApOrudAP+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="83451878"
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
Subject: [PATCH v2 04/13] crypto: iaa - Make async mode the default.
Date: Sat,  2 Nov 2024 20:21:02 -0700
Message-Id: <20241103032111.333282-5-kanchana.p.sridhar@intel.com>
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
driver to be loaded by default in the most efficient/recommended "async"
mode for parallel compressions/decompressions, namely, asynchronous
submission of descriptors, followed by polling for job completions.
Earlier, the "sync" mode used to be the default.

This way, anyone that wants to use IAA can do so after building the kernel,
and without having to go through these steps to use async poll:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo async > /sys/bus/dsa/drivers/crypto/sync_mode
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 3ac3a37fd2e6..13f9d22811ff 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -153,7 +153,7 @@ static DRIVER_ATTR_RW(verify_compress);
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
-- 
2.27.0

