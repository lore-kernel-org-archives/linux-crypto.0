Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE9204C03
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 07:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744268802; cv=none; b=RQv5ZWuG5JhbYQr//amSH1a7ETj8A1vfNfMF9MYZ7c3W/QABvunjnBw81lR8CMW/2CyFI5thOuMLJQgi0dsRtQuZa7L01lIdcULPxRMuvjx40Dl/PvsEpa8ieZ0y5YXQRwYsVqZnJKQpEt3/uWzNSxOQvfzra0gCJ3Z6SIY3xBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744268802; c=relaxed/simple;
	bh=eVtQY8JBtI7OBFxIa1E1PA3pS0GE/8DYWFULSp6JaHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pKMdRlTj732iQ0k69dpkKoHDxlgNEEzxJJPElEmVeGMWxyQkEN+Sfs9124ejRU10wgLs46Sx61nXLkW00pIhA+lSm2TBxWSURcy+q+EFMUYmVvMmZyOMIHePVY86dSgJ4lEK4EyIpYj/QEvIJLa1ggcO/n676i+IxsiJbgd5pIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bW3nQTNW; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bW3nQTNW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744268801; x=1775804801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eVtQY8JBtI7OBFxIa1E1PA3pS0GE/8DYWFULSp6JaHg=;
  b=bW3nQTNWCEYn1wXzX8GcFxjuXgJRR0iA9VKrw1/N1W9a6XX09IweXXYb
   E2+ZL2/SsoZl0e/RQ7BVG6qVy4nlwj8rlH23f0aDmscj1O7J7NH6F/onS
   6XyM/3+agJvP57ykZaw4Tm+ABagmjCOQqln7SJ85ZzGSku9tgJNkE7Kdw
   uoGQSblsW/vR+umk5uVG6adhFxJeMtkzKbyKI8z9WtcOAL7vkhyKjs79a
   aXaDimdyAd7CaUB/hqJo5LqU5Kf6kwCH0hNReZ+vN5Xz9oKDue8ZMli07
   Oa2ixBo1h548s4gCZmEJn2Q9H6dMO5OwyQtmJVM5J0XaRk53HL3KQ501G
   w==;
X-CSE-ConnectionGUID: 2fxzTkesTXyHFgIJBAqy4Q==
X-CSE-MsgGUID: QS8Hd4OeTbqty5J1ctxQYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45484790"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45484790"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:39 -0700
X-CSE-ConnectionGUID: kVTH2jZVTbeS/zX/rcXnvA==
X-CSE-MsgGUID: BorZ3DaiT8GsjoUcY7tKvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128791501"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:06:36 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id AAD2D11FA2F;
	Thu, 10 Apr 2025 10:06:33 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1u2lzd-00FQT7-28;
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
Subject: [PATCH 1/3] hwrng: atmel - Add a local variable for struct device pointer
Date: Thu, 10 Apr 2025 10:06:21 +0300
Message-Id: <20250410070623.3676647-2-sakari.ailus@linux.intel.com>
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
 drivers/char/hw_random/atmel-rng.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 143406bc6939..5192c39ebaeb 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -56,12 +56,13 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 			   bool wait)
 {
 	struct atmel_trng *trng = container_of(rng, struct atmel_trng, rng);
+	struct device *dev = (struct device *)trng->rng.priv;
 	u32 *data = buf;
 	int ret;
 
-	ret = pm_runtime_get_sync((struct device *)trng->rng.priv);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
-		pm_runtime_put_sync((struct device *)trng->rng.priv);
+		pm_runtime_put_sync(dev);
 		return ret;
 	}
 
@@ -79,8 +80,8 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	ret = 4;
 
 out:
-	pm_runtime_mark_last_busy((struct device *)trng->rng.priv);
-	pm_runtime_put_sync_autosuspend((struct device *)trng->rng.priv);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_sync_autosuspend(dev);
 	return ret;
 }
 
-- 
2.39.5

