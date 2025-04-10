Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFDB202C26
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 07:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268803; cv=none; b=mvCtaOlDpuvaw9Vyz/jbgsuMYFUxKd1N67o+fBgqqwQJnjVEy62ycRd5HUY7efnNaRyfD/ozs4poKBb9A/5pyUXinw6aS8rpEtPGX45U67G2Xc6Q5wbIxl7h2s/5bLhMnZ8niHgD/iVwibz9ff3r0HTUo8MvEcbhFmKkbFWmQs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268803; c=relaxed/simple;
	bh=TE7iAMTJLA59sZpWYVqvYbWng+qFOuV9FpYpZVf3SEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZDp1y3kaZayXyQX5q2ylVdqOy7nrcDvGhqfNe/IsEdBo//o99ID7Abs1ixPXCzRoJACToYUkNahTbe1yScexKAjjMz2OhFhYN8QmWjv+8GJwCKlPjt7sG08jzAfC6i4W/buUF3/5tCsTwik2/J/hUxjRlao3jh9EYXMMSj25Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n0I/C6tg; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n0I/C6tg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744268802; x=1775804802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TE7iAMTJLA59sZpWYVqvYbWng+qFOuV9FpYpZVf3SEg=;
  b=n0I/C6tgLWS7kpL9mYduKa7xm7k4/uYtzXjMvIa9hu+kM0fA5mYSatg8
   hU76vhlJGvjaJUNwm6hTAXE/NSaM4l3M2y32OZKsc2f1CDVGeVOIan+ff
   7QAjZQSpO1OYtCgI4bwFojJ3umdiJVr+zrsdvWujBi7bgazB+kVl8umrb
   K23UaTcvjwPsIaivFwd4fPOsL1k0rSfFZHXV08+M7m2jhPAPGJ4W3rzPf
   uMwc06/OX1M7+C88I+5waESEZhi2Abq1CwDHfd8QZb4vO1qNat9pb4tpm
   AdZNnp0EFT/OxnVvbc4E+zQOpy1zrIodt8NcP/ScZLHo9zbF5Kjdasvw7
   g==;
X-CSE-ConnectionGUID: ia9BVW9nR7aRO5VL609+RQ==
X-CSE-MsgGUID: bP2mnaoMQ7+AGcy9trXslg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45484800"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45484800"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:39 -0700
X-CSE-ConnectionGUID: jcRV1cD5T0GwUaoEVA8YeA==
X-CSE-MsgGUID: RLnB8c7VT5SfdPnsXZyizA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128791502"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:36 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id ACEFF11FB1F;
	Thu, 10 Apr 2025 10:06:33 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2lzd-00FQTB-2E;
	Thu, 10 Apr 2025 10:06:33 +0300
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
Subject: [PATCH 2/3] hwrng: mtk - Add a local variable for struct device pointer
Date: Thu, 10 Apr 2025 10:06:22 +0300
Message-Id: <20250410070623.3676647-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250410070623.3676647-1-sakari.ailus@linux.intel.com>
References: <20250410070623.3676647-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a local variable for a struct device pointer instead of obtaining the
hwrng priv field and casting it as a struct device pointer whenever it's
needed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/char/hw_random/mtk-rng.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 1e3048f2bb38..38e57900080a 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -83,9 +83,10 @@ static bool mtk_rng_wait_ready(struct hwrng *rng, bool wait)
 static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct mtk_rng *priv = to_mtk_rng(rng);
+	struct device *dev = (struct device *)priv->rng.priv;
 	int retval = 0;
 
-	pm_runtime_get_sync((struct device *)priv->rng.priv);
+	pm_runtime_get_sync(dev);
 
 	while (max >= sizeof(u32)) {
 		if (!mtk_rng_wait_ready(rng, wait))
@@ -97,8 +98,8 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
-	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
-	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_sync_autosuspend(dev);
 
 	return retval || !wait ? retval : -EIO;
 }
-- 
2.39.5

