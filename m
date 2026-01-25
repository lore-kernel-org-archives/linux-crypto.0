Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274D71DE2B4;
	Sun, 25 Jan 2026 03:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312146; cv=none; b=V3AXgXtphmacgmalOX/0EmIcLPrJZDRvV33jsqBRutGsMucflpFZ+IQov6uib9MQ5CJDB2hQ0iyIf1plWsNERaqzXX/SHXc2c4Ulal1EcoPtTwO71u2U31Y2ligfWU+DJd5UfYhUsRu0WakjYiJNPwBC3kGNQRLXiYFUOhffNU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312146; c=relaxed/simple;
	bh=HginJqtQSQq0Ia4ge8Ae50CgYR2ju2nDIKlkjuhKBrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UPNsevXDpqRJAvfroVL3U5P5DNYmxIsWy6RNJS3EIfY/TN2xNbRdbPdbxHbZByBPNdnQv/YFwHPFWdqkGOxMsDMaj8ajJoyQCwbWvsAR+51ILbwxi9WsEoToO9TlvaMczQLdiHSH6slqN16pvk2YfX1r1QqEcnMtijO38kcTec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MGWEpS90; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MGWEpS90"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312145; x=1800848145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HginJqtQSQq0Ia4ge8Ae50CgYR2ju2nDIKlkjuhKBrg=;
  b=MGWEpS90UdzWzm4ECR7UthHrE1M3w2/6y71YQZVYgmvB5bxsxcawuE9n
   8TrL9b77kZTurr9YltFBflWb+UmlU6uHUJ/+wTHe9afNpS1X62DiLMgnJ
   kZcgsE4Jp8Sc/qOZSYDlTYqvf1hdO+Kn72SnzhjxQR6VnWkaTSs5TUm6O
   L5KWmDuG2iwkc0ntyHgzSn5NY7RYvTOhWw4GRK13Q9IdYVW4lx5C5XlPN
   qkzlRvYdpinRGTL6VY2cid1y1ZFYoa9NyF7xL22M5ddQZ98EPAoIlB9e1
   GtLylHoB2JWgD53TxSgk8r+ibBcDoEv5fGxmXqaSLS661hxhj+sqPXh5Z
   g==;
X-CSE-ConnectionGUID: NCxU4yIETC6waDnRi3hNTg==
X-CSE-MsgGUID: oYQgmfqTRTe/IbJ9InFH9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887317"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887317"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:42 -0800
X-CSE-ConnectionGUID: +xXaY1bWTuGRO1KctRHYgg==
X-CSE-MsgGUID: 0fD2i0KTSqutMlXHxVNJRA==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:41 -0800
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
Subject: [PATCH v14 02/26] crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
Date: Sat, 24 Jan 2026 19:35:13 -0800
Message-Id: <20260125033537.334628-3-kanchana.p.sridhar@intel.com>
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

Replace sprintf() with sysfs_emit() in verify_compress_show() and
sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
provides better bounds checking.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index e21d5fe9004c..8057e8d1571a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sysfs.h>
 #include <linux/device.h>
 #include <linux/iommu.h>
 #include <uapi/linux/idxd.h>
@@ -92,7 +93,7 @@ static bool use_irq;
 
 static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
 {
-	return sprintf(buf, "%d\n", iaa_verify_compress);
+	return sysfs_emit(buf, "%d\n", iaa_verify_compress);
 }
 
 static ssize_t verify_compress_store(struct device_driver *driver,
@@ -150,11 +151,11 @@ static ssize_t sync_mode_show(struct device_driver *driver, char *buf)
 	int ret = 0;
 
 	if (!async_mode && !use_irq)
-		ret = sprintf(buf, "%s\n", "sync");
+		ret = sysfs_emit(buf, "%s\n", "sync");
 	else if (async_mode && !use_irq)
-		ret = sprintf(buf, "%s\n", "async");
+		ret = sysfs_emit(buf, "%s\n", "async");
 	else if (async_mode && use_irq)
-		ret = sprintf(buf, "%s\n", "async_irq");
+		ret = sysfs_emit(buf, "%s\n", "async_irq");
 
 	return ret;
 }
-- 
2.27.0

