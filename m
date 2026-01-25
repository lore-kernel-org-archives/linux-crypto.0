Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A5E1F75A6;
	Sun, 25 Jan 2026 03:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312174; cv=none; b=kuYnbT4ev+h8LwuFpkVCY9PWvHnwcdWuU7BOXUVCbdqSlDpsHWl+3LyszQvwkuS6cDt8FoX3F8jpHoo0Ph7XIoeJ99XGdths3hgK6hyt7hiVIBKAh5b86O6oltbkcJNOKuB6nS03vPKjW1i0DACBxFpywYz5NzkpFBoDSdSNSrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312174; c=relaxed/simple;
	bh=BTzto9LJZ4dLalRZ5djoz1jmTvw0aNZ/Qf035G+8x48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lg+Cg8R50yhvpyj5TqNGHeYLIYOM0n1OdiInQDgXlQBNzifMorZqSOt7OuLC0+oT9KbGQaTfA9F19gU4t6ZrhMIJI3476pRJBZYf9NY9FjxLiQmcd/oSw69kL7KBkQe9XONI8eHmKdloZ8URAhzxU/KY0UdVwWgcVX2JDmWqYyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=imjyim9m; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="imjyim9m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312172; x=1800848172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTzto9LJZ4dLalRZ5djoz1jmTvw0aNZ/Qf035G+8x48=;
  b=imjyim9mv//8z4MWJIbiVM+Vhf6G/ckGuihs+CAcPhToZpopBjuXFsbi
   SbNGWGrBfBXWjDQzR/jgH2HwyG6EAmIpdxDKgTpMQpztrU1gnDgJGNwg+
   YOUVNs/dVM0Bqv2hUwApe1+2JaFmVEd8bnn9zSf7LoKp1OIBZXTV/Puoe
   NS1GFdbHWXRo9LG+0n6okVgkeTnzFKYZr6mICS1f6yT9ggNGW/Any4fkY
   DaxUmaNcQfNVcI9Wo/BjWWvs3nzM40OH5/2gpNMHB+u8Qi5CH3RfGbIVK
   f1iE30ThdPjqkW5TAxQFSMXgD0YxuJv/Is+Ph+c8m9JrOo+W54sghsYHu
   w==;
X-CSE-ConnectionGUID: CSYlkDMqRvWT4D3fzuAFSg==
X-CSE-MsgGUID: 273H3JUmQYK8MbF4zy78bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887603"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887603"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:08 -0800
X-CSE-ConnectionGUID: asSjYB5sRwCnHWdNtxnXag==
X-CSE-MsgGUID: KwOt10VzRiyXQir+QElPeQ==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:06 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 20/26] crypto: iaa - Disable iaa_verify_compress by default.
Date: Sat, 24 Jan 2026 19:35:31 -0800
Message-Id: <20260125033537.334628-21-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
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
index f6e18f458fbf..7bc4a80bd68b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -121,7 +121,7 @@ static bool iaa_distribute_decomps;
 static bool iaa_distribute_comps = true;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress;
 
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
-- 
2.27.0

