Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03A6189F5C
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298580; cv=none; b=qXH8Y/67gvbhiPFU2Ps8OuTPFtLYOrrKFcS2OunGp8cY5KK2pPYcUn2XvQv3/cppwK1DDtWA/Eod1whK2fDvVrAg1AsOBqP4QrPqvGyktRuFjxxJBkCoszsUbOONN/rxQR1EFdDD8kUQIcID/IT3gGQJ1tancjoMjqTMBOqXX9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298580; c=relaxed/simple;
	bh=6Y6uk1OKDMurXHr6lYHInLtlxGOoJuYbcOgABgCGhk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qtdVBu3myoHgbeTAJPA2f3yIyTSer2EDlFQQuOBbbbg7XFX6zX1X1QcHgJtE2EdONMDk11rgmhuOQbEi8R+XnKMy0C0GTFbtsygqIcF1mLlmh5401iBWYEsiKfvYQ9UFXdsbhLeaVIRJakXNZubVK6kUvUiPBZ7Dzv2FhYnGHeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IH//wdEX; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IH//wdEX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744298579; x=1775834579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Y6uk1OKDMurXHr6lYHInLtlxGOoJuYbcOgABgCGhk4=;
  b=IH//wdEXSanYssKen3dnXEhTPrES0vbJznPAgzXZdUc4Jf+qRgpTM5Yy
   WoA5iQuajEkWRzZeAzaKlJbGUrMBLvldA4uw8jZbGcUE88+qGPJuOXgVM
   VwXVDCUqscss0MYGssaOYWP3SWRltvl8TbJnxPJM9vqQeS3wG+z96Bk+c
   r/No9Xn0nsUTMOpCtdjxx0BCg9E6fCKqJEIjkCOwSNAvsN0Yf12S4PFb3
   2/TvwoT2h+1Avov91Y+BOHbXBIRxAM3/PAhcJ6sJ8EGrkX8i+E4Q6HOnm
   NFwrOv7ZXnza8iNfT2PmPYMGEYt1HoXPWT2wdRC6xgVbIvBZvLbcxK3uf
   A==;
X-CSE-ConnectionGUID: CT+jPVphRz+fewXwAY5jqw==
X-CSE-MsgGUID: 9n/CUhscSribHiHMyj3bBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="45716280"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45716280"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:56 -0700
X-CSE-ConnectionGUID: lXZBb65zRtqhhZOoXu2Bbg==
X-CSE-MsgGUID: EKcd0ndITDqagjO31fW8Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134108197"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:52 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id EC2AF1203B9;
	Thu, 10 Apr 2025 18:22:49 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2tjt-00HOc9-35;
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
Subject: [PATCH v2 3/3] hwrng: npcm - Add struct device pointer to device context struct
Date: Thu, 10 Apr 2025 18:22:39 +0300
Message-Id: <20250410152239.4146166-4-sakari.ailus@linux.intel.com>
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
 drivers/char/hw_random/npcm-rng.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 9ff00f096f38..3e308c890bd2 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -32,6 +32,7 @@
 struct npcm_rng {
 	void __iomem *base;
 	struct hwrng rng;
+	struct device *dev;
 	u32 clkp;
 };
 
@@ -57,7 +58,7 @@ static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	int retval = 0;
 	int ready;
 
-	pm_runtime_get_sync((struct device *)priv->rng.priv);
+	pm_runtime_get_sync(priv->dev);
 
 	while (max) {
 		if (wait) {
@@ -79,8 +80,8 @@ static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max--;
 	}
 
-	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
-	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
+	pm_runtime_mark_last_busy(priv->dev);
+	pm_runtime_put_sync_autosuspend(priv->dev);
 
 	return retval || !wait ? retval : -EIO;
 }
@@ -109,7 +110,7 @@ static int npcm_rng_probe(struct platform_device *pdev)
 #endif
 	priv->rng.name = pdev->name;
 	priv->rng.read = npcm_rng_read;
-	priv->rng.priv = (unsigned long)&pdev->dev;
+	priv->dev = &pdev->dev;
 	priv->clkp = (u32)(uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
-- 
2.39.5

