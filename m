Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A45325CC6A;
	Fri, 28 Feb 2025 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736833; cv=none; b=Mzw8Za1dOrT1rojDGVUgaDOMeDGpzXIZOKsODDfIjpE8B8vRZJKMMFPUK6FfmWfb416LdnwTK90UMZ04BURhNVWkJmEEOO4sdllw5wdmWnJMP6W3zSPQAOOFQNzuJ9kaPptebIjo6amNiF0KxzQkaKkS+eQftmshg3gmgzd7Oao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736833; c=relaxed/simple;
	bh=yHP5Zb8+z92UaMlcfYAxfjtnW5rOspDIJ08VjR15a3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DU9uuj6fkmE836LeEveoeWRnI6qbPe5V9+HBsu+5QgRf2XOhe53EwR7w0AA44TXF18/Lul7BJpSCJRldkr/c5Y+VJ7hc9/qp599vVxNKqZElDSS7km4YJLoNYPdg4DbbGEoIQYzJJLnkMtJG7T66owzmM6/JugXlu3O55My7DDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HQsukyb6; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HQsukyb6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736831; x=1772272831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yHP5Zb8+z92UaMlcfYAxfjtnW5rOspDIJ08VjR15a3A=;
  b=HQsukyb6m7Ge1YL8jGw8mLTJ2pGW/ZGBu6Ul4b9ohKXPJDgniCS2Nv4+
   sUQnqnetT+zUMeZIzl3tmiAzINymTYdJ3JtvBDE7+I9Z78mpqYMS/kZtj
   HRrNlw0xC/Dfdvmd80EoovsYimV1ypAkuX/50nMZQqmQP2yGwASvEo2qO
   q2fQ6SGZ2/w3M5+KNe7goXm3RWwy/1wFohZM6qQwnxL4euo0iNpA+Bu8z
   Dpjbn9G1sQQHzLBP5LBCyVzoU4egd4LvpzY4gW/TpRjuuMlndgSdEN6wr
   kDejQ/9TVpFpUn8tuNohPULxxOnGk2pVwZQDW8EZVGrlL+yEFcCAan81f
   Q==;
X-CSE-ConnectionGUID: JODzmQylRlilWnhf4QsAaA==
X-CSE-MsgGUID: FVbjWJfpTbiKr16Ns69xnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902628"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902628"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:27 -0800
X-CSE-ConnectionGUID: 1Lk0WXSiQfKjC9odq4aZtg==
X-CSE-MsgGUID: tjEWDpYHRb+PYAqFYWOxZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325717"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:27 -0800
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
Subject: [PATCH v7 06/15] crypto: iaa - Disable iaa_verify_compress by default.
Date: Fri, 28 Feb 2025 02:00:15 -0800
Message-Id: <20250228100024.332528-7-kanchana.p.sridhar@intel.com>
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
index 4dac4852c113..5038fd7ced02 100644
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

