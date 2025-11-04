Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D0C319862;
	Tue,  4 Nov 2025 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247572; cv=none; b=tcXpmojBrKPkIiAxpHC0po0QU2vok086P6cKzCpun6RKDmP+bL8OI3UIO9OtEJ4ZO8gJfyyMh3ynaLf58M4beMZrrQvAZ94/fnnmyyqTo1Sfswux68GQyV6aL7oYs0ZUWCELSUYqdbYNdMTFH4g+/pt11E0ZzET9dc4ER4t5wGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247572; c=relaxed/simple;
	bh=9P9wKFrNJfPIpXmyA+iBMEWI3wiIcFTfyNcL9Mq5cwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PUQ1ievlgf8+xgoBoXlXvrwPXG9cFYHXMm0k+Gsi4qJ07xiUIzHBEECXrfFbnkvgnBFdXXUKhNzd99HvBqByZQHm2QE9wVbOtjssQ5wx6ZliAlIJF6LzArsqH5GvWlmZtTmIlmxhRKdKtVUY8P+g22t6ji3t2OyFoZc92CvSqMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cUBJw3qh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cUBJw3qh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247570; x=1793783570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9P9wKFrNJfPIpXmyA+iBMEWI3wiIcFTfyNcL9Mq5cwY=;
  b=cUBJw3qhDVHHyguzbvf/psVWv970yLFYQiogjuUKCvyQE4XBZzDMatMo
   9fz2Uf6HorutHrQsUmJXTxegWdq6ArRsd2rCyXoMZ8/zTNoafn87LLTBm
   bgZTricI2TVLgqJPJ+ChIBEfKSjj/PXlpHPMqvXc2lepifPP1UMxFpYbu
   hD2Ufg+frxHrvsSACW7PYZjgVQGEqNty+QRq1g/OoG/AqnEFVjhHHggkY
   +RvokFnfVCVsfIsFJeDJN5XVT8oLvK7I+zkatYaGLdev8zr3+kUamuJ3d
   0PPbsHhAb9YLHPGYtBKM7+KhnpCc53PfSQtDNGuDd5m3hz32QiEdz0uPR
   w==;
X-CSE-ConnectionGUID: wkUSoJxKR+OChPds7xFVXg==
X-CSE-MsgGUID: +ojsCGkXSm2owvGP7Vg8hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798687"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798687"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: yWAMtL9kQPGGUXHGs045lA==
X-CSE-MsgGUID: mcfHprBDQO2DIBpU0fv1wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795820"
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
Subject: [PATCH v13 15/22] crypto: iaa - Disable iaa_verify_compress by default.
Date: Tue,  4 Nov 2025 01:12:28 -0800
Message-Id: <20251104091235.8793-16-kanchana.p.sridhar@intel.com>
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
index d5e610ef4612..81a7dbd15f8b 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -239,7 +239,7 @@ The available attributes are:
 
       echo 0 > /sys/bus/dsa/drivers/crypto/verify_compress
 
-    The default setting is '1' - verify all compresses.
+    The default setting is '0' - to not verify compresses.
 
   - sync_mode
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 8f477577dbd1..349fea0af454 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -120,7 +120,7 @@ static bool iaa_distribute_decomps;
 static bool iaa_distribute_comps = true;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress;
 
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
-- 
2.27.0

