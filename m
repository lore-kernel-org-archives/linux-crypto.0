Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7C1E5B94
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298582; cv=none; b=GEmHaX7r8NnGfDYCkKLSh7gLTt1oM/WYtcUxofDvTm9u+jrjJtCVQ5a5001WBjoB0j0n8yrAqW8KcR+uIPwgeckMc0//t5Nt0HH60fQrCCFVe6cXwFCjU8jo+GdamcVi1EiM9lLmF+Hlm8ll8rYLvGXcprkKcsQXXVV31d2PbYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298582; c=relaxed/simple;
	bh=1rmJxpqqkGXBWjcPvpAAKCZLWRdEQASHVQu+D1tpj9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VOUHbqPlepWUamnzBUbJ9zlDZZ2iLRVyQ6LHIClpZIKz+HXh9rO4QsDJzLm7+U+dz5C1WX/Y0fPIzOknJ6ucEpeoYpUOWU3qve2/Gfqe4EPlyJ4Ncdmb+ZRFM99G8FOc/bfxBxPgilMfNyVdamFCvxZqbOfDdlrYMAS/+IJ8ubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=boE8mZOa; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="boE8mZOa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744298580; x=1775834580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1rmJxpqqkGXBWjcPvpAAKCZLWRdEQASHVQu+D1tpj9E=;
  b=boE8mZOaGkZXeJsBpnrTXl/cA++karg5YvdrzXBdv7+qVshQAmjm6Zzu
   auWUznf0+XRoqseoSAOedI5RrS/drTHJI8eLnqAcBUaGWPnp90J/MW9bN
   S0bC0bWMTiewJtcebnYtyQXL6AHgcG8Y9e0SydCYTq65kipCdjXuwLe3V
   R8cnK3foYNOShRWWi5nWaF9s6VCDaZ7Bn/jTIPeOKRzSifOlfg/h491es
   dLEjuphVYinajIy+4O+gbsRBYXGZiFbSciw3qChsXvwqDBXdE0Py+yUG+
   PaDzxRlkr9mWIadlEXgLVFzI3mSD/1C91RmufuPQtqNlihrlYkPoN6hPY
   w==;
X-CSE-ConnectionGUID: nsI+5ynGQPSgtzAqAAjiVQ==
X-CSE-MsgGUID: Sfy410ZBS6S4Jbu0izc+LQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="45716300"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45716300"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:56 -0700
X-CSE-ConnectionGUID: bC5JV7arSSy41yOILBG4rA==
X-CSE-MsgGUID: VvkIrii3SNinWOPC6+RzqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134108199"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:22:52 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id E87D411FB1F;
	Thu, 10 Apr 2025 18:22:49 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2tjt-00HOc3-30;
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
Subject: [PATCH v2 2/3] hwrng: mtk - Add struct device pointer to device context struct
Date: Thu, 10 Apr 2025 18:22:38 +0300
Message-Id: <20250410152239.4146166-3-sakari.ailus@linux.intel.com>
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
 drivers/char/hw_random/mtk-rng.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 1e3048f2bb38..b7fa1bc1122b 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -36,6 +36,7 @@ struct mtk_rng {
 	void __iomem *base;
 	struct clk *clk;
 	struct hwrng rng;
+	struct device *dev;
 };
 
 static int mtk_rng_init(struct hwrng *rng)
@@ -85,7 +86,7 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	struct mtk_rng *priv = to_mtk_rng(rng);
 	int retval = 0;
 
-	pm_runtime_get_sync((struct device *)priv->rng.priv);
+	pm_runtime_get_sync(priv->dev);
 
 	while (max >= sizeof(u32)) {
 		if (!mtk_rng_wait_ready(rng, wait))
@@ -97,8 +98,8 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
-	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
-	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
+	pm_runtime_mark_last_busy(priv->dev);
+	pm_runtime_put_sync_autosuspend(priv->dev);
 
 	return retval || !wait ? retval : -EIO;
 }
@@ -112,13 +113,13 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->dev = &pdev->dev;
 	priv->rng.name = pdev->name;
 #ifndef CONFIG_PM
 	priv->rng.init = mtk_rng_init;
 	priv->rng.cleanup = mtk_rng_cleanup;
 #endif
 	priv->rng.read = mtk_rng_read;
-	priv->rng.priv = (unsigned long)&pdev->dev;
 	priv->rng.quality = 900;
 
 	priv->clk = devm_clk_get(&pdev->dev, "rng");
-- 
2.39.5

