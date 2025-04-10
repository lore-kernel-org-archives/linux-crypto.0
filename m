Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43F220AF77
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 07:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268805; cv=none; b=clRbYVOORdfmHLx9H97zKAUOa/IQb3OvxquU2mj5DiHweL4eV91pY1h61uJOJwm6nSkmRuS5/iUdv7O2ls2fYja+xGP+mhSUfaRH/rsHkww+b3PlxZLbUcGKQdZXEG897ypaDeT7npqmMjDeLxf3LMjS0t280/SOVvsS+kIq2YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268805; c=relaxed/simple;
	bh=eTuV2CyB5vjAJ0CZ1BcbW4eb89Fsn/ZCIyYBD5yo6Ow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DXktP2coSm0VuW8vh6pjWAEMwqui6Co4R13yV1KC2CzOmSO+FeKotsE+IkwfxCIrxfn0Lm7oMhMkwL++IDCmnCWFFjlYZc47lljLPBO5IZIOnqRyBMn6Yt64mSURL/L0yo2NWQWddDClqZj0GHomuR/LaBE6yhX0+p+mwRpTjQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iQXMUbHK; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQXMUbHK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744268804; x=1775804804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eTuV2CyB5vjAJ0CZ1BcbW4eb89Fsn/ZCIyYBD5yo6Ow=;
  b=iQXMUbHKyY+LUYtzVwuJeB3mt0IA7V7fchJiyPT9eIoBDKMFxNmhIo1P
   bQFJrsaFeTfnK7rxREp99jfITQigT0utfDX7tIS18acZjLW0ZYmfN5iQp
   oHtg+abQX4Kng02OuidRtAFZaLMc1R3u3HPYm2MmglpwQoabvAvT+/iaM
   97caIB40bs6OfCjxBif4rSOGHbeMv7K9XJkSMdVgpPo1RcfExTtMyEYqe
   in1jfTgXFVjrBieulTq5xqonTRuM/zfFnn7yiSNv6vaHgZkXCWCes0LdC
   QnT0s91Ogs5i4qVEn8KBqxOkI5syneBU+ybuCjuZG8is+usbFb35wDANO
   g==;
X-CSE-ConnectionGUID: DzR/+4++Qiqr2b9QZJHgIQ==
X-CSE-MsgGUID: eA/LFEuBS6OwXL1921ZT8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45484820"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45484820"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:40 -0700
X-CSE-ConnectionGUID: /9qgZoukRT2V3k+E473utg==
X-CSE-MsgGUID: eCd3L+qyRjqOTOU2EOJUdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128791505"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:36 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id B0BBE1203B9;
	Thu, 10 Apr 2025 10:06:33 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2lzd-00FQTF-2I;
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
Subject: [PATCH 3/3] hwrng: npcm - Add a local variable for struct device pointer
Date: Thu, 10 Apr 2025 10:06:23 +0300
Message-Id: <20250410070623.3676647-4-sakari.ailus@linux.intel.com>
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
 drivers/char/hw_random/npcm-rng.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 9ff00f096f38..beec96391af7 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -54,10 +54,11 @@ static void npcm_rng_cleanup(struct hwrng *rng)
 static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct npcm_rng *priv = to_npcm_rng(rng);
+	struct device *dev = (struct device *)priv->rng.priv
 	int retval = 0;
 	int ready;
 
-	pm_runtime_get_sync((struct device *)priv->rng.priv);
+	pm_runtime_get_sync(dev);
 
 	while (max) {
 		if (wait) {
@@ -79,8 +80,8 @@ static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max--;
 	}
 
-	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
-	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_sync_autosuspend(dev);
 
 	return retval || !wait ? retval : -EIO;
 }
-- 
2.39.5

