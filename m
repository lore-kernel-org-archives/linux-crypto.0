Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FAC293C52;
	Fri,  4 Jul 2025 07:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751615654; cv=none; b=IwmR3MqZ0OzlgWGPBEL5HxcNuB1+2bt7MkUQyIhtNAAYxOauLV1w6nN/5OVinpPfR/Cpe+S1RHAKeCl3C/COx51Bf4U32fjQjkYRbPF6MDJhWqcSAlsu+wVCNeo9U2k7KcBrJvdiZfvHqXlCZd65eRhjvBqR97JTbk4KTUad1/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751615654; c=relaxed/simple;
	bh=IxQt0PoKk8BTvmWimbOLB4rG5iTXBM6oigomry2CjPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oYsfWwZlTh8ukZKUmA55mQKHq8zoF7VQymXX1dtLuWgeZX8GxtQVCqUm6IcI9vR3b7Tf0neOw19QKd0gz2OQAOWRmAzAkJJdDC0EZ/0HlLMUFA5d1OtPxkeAii2dSp9ZfIoneu62vXFGK+51+EkKSvKg5whLs+Gbrxk5o2iHZK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oz0J7ql0; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oz0J7ql0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751615653; x=1783151653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IxQt0PoKk8BTvmWimbOLB4rG5iTXBM6oigomry2CjPY=;
  b=Oz0J7ql0H7hQow6PD+s2CAFzqcX4iGlH1FoASYSlUqgc7Yt9KjDS2tCi
   fGx9UD/FrYhefMB++5aPmus1Zob44QvhkUUOGiapQt7IqKKF1Bo1qX5oM
   D3RzpGcS69lmAuo8XOF5TenSG1UD25pSupQORMKAiFtRK8SbEdxxabScK
   hDcoD3JQHj+rHxII1Cwr9qCOvmQacF6ltzBtIOIwIknIInhe53vomB01O
   /ge12NNrv0ch/MUdWUy8EOX4BGALyb4ZqxoRaCHP0QHaWf4u/b2iP83Qf
   +vW+cAvNxAECmg9Uww4GvivgmfKI3KmSyPE2z1LnsjwTmDkFf8q91WBc+
   w==;
X-CSE-ConnectionGUID: BttVJNpZT6+ti8AeuQqPgA==
X-CSE-MsgGUID: dv6nFQedRCyVRcFqNrZphA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76494511"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="76494511"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:54:11 -0700
X-CSE-ConnectionGUID: TZWybnM3T2OaX6AYFlRSrA==
X-CSE-MsgGUID: EyGJEJv5SXuqPS0vZtHSNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="158924166"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO svinhufvud.fi.intel.com) ([10.245.244.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:54:02 -0700
Received: from svinhufvud.lan (localhost [IPv6:::1])
	by svinhufvud.fi.intel.com (Postfix) with ESMTP id 18CED4445A;
	Fri,  4 Jul 2025 10:54:00 +0300 (EEST)
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Hadar Gat <hadar.gat@arm.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Patrick Venture <venture@google.com>,
	Nancy Yuen <yuenn@google.com>,
	Benjamin Fair <benjaminfair@google.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Marek Vasut <marex@denx.de>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	openbmc@lists.ozlabs.org,
	linux-rockchip@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 05/80] hwrng: Remove redundant pm_runtime_mark_last_busy() calls
Date: Fri,  4 Jul 2025 10:53:59 +0300
Message-Id: <20250704075359.3217036-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
References: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
pm_runtime_mark_last_busy().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
The cover letter of the set can be found here
<URL:https://lore.kernel.org/linux-pm/20250704075225.3212486-1-sakari.ailus@linux.intel.com>.

In brief, this patch depends on PM runtime patches adding marking the last
busy timestamp in autosuspend related functions. The patches are here, on
rc2:

        git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
                pm-runtime-6.17-rc1

 drivers/char/hw_random/atmel-rng.c     | 1 -
 drivers/char/hw_random/cctrng.c        | 1 -
 drivers/char/hw_random/mtk-rng.c       | 1 -
 drivers/char/hw_random/npcm-rng.c      | 1 -
 drivers/char/hw_random/omap3-rom-rng.c | 1 -
 drivers/char/hw_random/rockchip-rng.c  | 3 ---
 drivers/char/hw_random/stm32-rng.c     | 1 -
 7 files changed, 9 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index d2b00458761e..6ed24be3481d 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -80,7 +80,6 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
 	ret = 4;
 
 out:
-	pm_runtime_mark_last_busy(trng->dev);
 	pm_runtime_put_sync_autosuspend(trng->dev);
 	return ret;
 }
diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 4db198849695..a5be9258037f 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -98,7 +98,6 @@ static void cc_trng_pm_put_suspend(struct device *dev)
 {
 	int rc = 0;
 
-	pm_runtime_mark_last_busy(dev);
 	rc = pm_runtime_put_autosuspend(dev);
 	if (rc)
 		dev_err(dev, "pm_runtime_put_autosuspend returned %x\n", rc);
diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index b7fa1bc1122b..c89171df7635 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -98,7 +98,6 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
-	pm_runtime_mark_last_busy(priv->dev);
 	pm_runtime_put_sync_autosuspend(priv->dev);
 
 	return retval || !wait ? retval : -EIO;
diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 3e308c890bd2..40d6e29dea03 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -80,7 +80,6 @@ static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max--;
 	}
 
-	pm_runtime_mark_last_busy(priv->dev);
 	pm_runtime_put_sync_autosuspend(priv->dev);
 
 	return retval || !wait ? retval : -EIO;
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 8064c792caf0..aa71f61c3dc9 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -56,7 +56,6 @@ static int omap3_rom_rng_read(struct hwrng *rng, void *data, size_t max, bool w)
 	else
 		r = 4;
 
-	pm_runtime_mark_last_busy(ddata->dev);
 	pm_runtime_put_autosuspend(ddata->dev);
 
 	return r;
diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index fb4a30b95507..6e3ed4b85605 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -223,7 +223,6 @@ static int rk3568_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	/* Read random data stored in the registers */
 	memcpy_fromio(buf, rk_rng->base + TRNG_RNG_DOUT, to_read);
 out:
-	pm_runtime_mark_last_busy(rk_rng->dev);
 	pm_runtime_put_sync_autosuspend(rk_rng->dev);
 
 	return (ret < 0) ? ret : to_read;
@@ -263,7 +262,6 @@ static int rk3576_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	memcpy_fromio(buf, rk_rng->base + RKRNG_TRNG_DATA0, to_read);
 
 out:
-	pm_runtime_mark_last_busy(rk_rng->dev);
 	pm_runtime_put_sync_autosuspend(rk_rng->dev);
 
 	return (ret < 0) ? ret : to_read;
@@ -355,7 +353,6 @@ static int rk3588_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	/* close the TRNG */
 	rk_rng_writel(rk_rng, TRNG_V1_CTRL_NOP, TRNG_V1_CTRL);
 
-	pm_runtime_mark_last_busy(rk_rng->dev);
 	pm_runtime_put_sync_autosuspend(rk_rng->dev);
 
 	return (ret < 0) ? ret : to_read;
diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 98edbe796bc5..9a8c00586ab0 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -255,7 +255,6 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	}
 
 exit_rpm:
-	pm_runtime_mark_last_busy(priv->dev);
 	pm_runtime_put_sync_autosuspend(priv->dev);
 
 	return retval || !wait ? retval : -EIO;
-- 
2.39.5

