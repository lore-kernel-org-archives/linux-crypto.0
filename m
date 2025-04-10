Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB561E5B62
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298581; cv=none; b=CXaQy8dJYwDuUYfbXoqB+WYDTRFIHfD73tIXV8lyLvlT9Fg0On8FjRNVfVwShCIXf2zK9XbIkHUN/u9x4g9ehFcVxryNIJk1rhsGPIJboskwwjrthqmKdPtedy2sprCYzv/Iy60JCEE3WbGUjdaVEcC5TSo0i5SXvsDXb6ZhcBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298581; c=relaxed/simple;
	bh=2nEmXOWj61EFby8lltYJVgmKKKLIgiCDNpDNWcMK21o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HPMVa9iMfk0Ig1pREf6JnT16f3o+x5jiRZ+MCVhNNvlmhdmJvCW6pwlCdfnUZF0ClwWehVN2Du9ksQzCYiy8/mHWhvhclp2bPkfabmlWyjj8mQhLfM8x7IUzqWR/LkIeunansUIJGudN9s/7yA5On0QOzTjyok3KPTVLcilMV/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOVRpegt; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOVRpegt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744298580; x=1775834580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2nEmXOWj61EFby8lltYJVgmKKKLIgiCDNpDNWcMK21o=;
  b=kOVRpegtD5rbzNQWGftgu7oq5GC6qa7C7euWwPRaI8GPXoRIi0Jlqrh3
   7uG93wTs8QfrV8OUgboliMriC+NaexcrPH/+Azv4uXD0EG7bNOIvSRcVw
   0l2VIdRXDJreHKWjMoO5tDQFebtzYScvyHD+/04YlqNLI7xNK1gfvqAap
   5GQl2Fq5WOKXYS8NbYaVn37VKOAiaxThydDBQYK8IfPOjbm4mpkFWVm3O
   V8nQqZl12XvIbbMhAQ1RlMIqPVIkj1V0j9LovQR/EF3EkOBCPEu7xjGCQ
   l/VTCjmAVinv0j34ZNIQhdfngXnJxfzVDWB3nry4ctv4xkOaFL7CRpAkS
   g==;
X-CSE-ConnectionGUID: GbZ0U74JTOOTsNq2HXy94A==
X-CSE-MsgGUID: +XSs0FbkQsCwEyivaknttQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="45716291"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45716291"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:56 -0700
X-CSE-ConnectionGUID: xwrGhn4bQV2XQcBYOS31NQ==
X-CSE-MsgGUID: 7SLwaDhESOSRn2bA8q196Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134108201"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:53 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id E27B411FA2F;
	Thu, 10 Apr 2025 18:22:49 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2tjt-00HObz-2s;
	Thu, 10 Apr 2025 18:22:49 +0300
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-crypto@vger.kernel.org
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	openbmc@lists.ozlabs.org
Subject: [PATCH v2 1/3] hwrng: atmel - Add struct device pointer to device context struct
Date: Thu, 10 Apr 2025 18:22:37 +0300
Message-Id: <20250410152239.4146166-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250410152239.4146166-1-sakari.ailus@linux.intel.com>
References: <20250410152239.4146166-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a struct device pointer field to the device's context struct. This
makes using the unsigned long priv pointer in struct hwrng unnecessary, so
remove that one as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/char/hw_random/atmel-rng.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 143406bc6939..d2b00458761e 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -37,6 +37,7 @@ struct atmel_trng {
 	struct clk *clk;
 	void __iomem *base;
 	struct hwrng rng;
+	struct device *dev;
 	bool has_half_rate;
 };
 
@@ -59,9 +60,9 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	u32 *data = buf;
 	int ret;
 
-	ret = pm_runtime_get_sync((struct device *)trng->rng.priv);
+	ret = pm_runtime_get_sync(trng->dev);
 	if (ret < 0) {
-		pm_runtime_put_sync((struct device *)trng->rng.priv);
+		pm_runtime_put_sync(trng->dev);
 		return ret;
 	}
 
@@ -79,8 +80,8 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	ret = 4;
 
 out:
-	pm_runtime_mark_last_busy((struct device *)trng->rng.priv);
-	pm_runtime_put_sync_autosuspend((struct device *)trng->rng.priv);
+	pm_runtime_mark_last_busy(trng->dev);
+	pm_runtime_put_sync_autosuspend(trng->dev);
 	return ret;
 }
 
@@ -134,9 +135,9 @@ static int atmel_trng_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	trng->has_half_rate = data->has_half_rate;
+	trng->dev = &pdev->dev;
 	trng->rng.name = pdev->name;
 	trng->rng.read = atmel_trng_read;
-	trng->rng.priv = (unsigned long)&pdev->dev;
 	platform_set_drvdata(pdev, trng);
 
 #ifndef CONFIG_PM
-- 
2.39.5

