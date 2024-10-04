Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F371487F4
	for <linux-crypto@vger.kernel.org>; Fri,  4 Oct 2024 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728034880; cv=none; b=a6v0besvN0MMOAMSf2Vw01It47zzxN70wLtGfzioeuX4Pun3YRkpShZGURcOzC9mP82gaPzAiy3jdyyrpem8mIF7+Ez8MIj1/nRcDxXX6HNtGv9HrNiW4pxZeG/+PXY+idyNRo0ki40HRDRNefNKUap4/pSafnrbjMs1aNww8rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728034880; c=relaxed/simple;
	bh=8ktEPHr11bpTyXw0rsSjug/eW6Ki4885nNCtJRjYKwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lVpTSJ+xLZ7OegXHq7Gh1/j06s5NkX806n6OV8uQlGB2Yz10L1yiWIGKDP6pXU2hdCcQYCH43eP28CtNSHg6H0mSEnwIcBPfhHIJm772dBD1PYUB5j53MSqfUgSP3Pc8U6cgQW7NiJOWKnQH2Tj3BMsA3FCECUSFlvbIG8igDF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=We6G6ueo; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="We6G6ueo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728034879; x=1759570879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ktEPHr11bpTyXw0rsSjug/eW6Ki4885nNCtJRjYKwk=;
  b=We6G6ueoi1Uy2EYMwRGyP+qpHcIsfy8IJa8Aw8hPN+wdoNHw/7SDkzeW
   LPhDj6zFtcA3fvH702vUzLj0lFqT8JVPAj07JeXNNTvvp1iQi98zAsw9m
   NjHVFBlA8we1RxWU94bxTr2Dl6R63PRPRVW01D7CqmID1rnqG0FBiB+/U
   37A9RgTO3luopG63LIohaxUNVoUIlOAMSiBYb6da60cQezTrgJ0cYRINa
   1UbYWaprqX4Fkq4VK3BY22gPTzycoaJjxlLrf/gtN0pHOYEkE3vyktW4C
   UW59ZVGd/ez4PwgMepO2lzW7pbHWwLfjZO+mJr5EwAeSfojOVpcXey6QU
   w==;
X-CSE-ConnectionGUID: ZAdqrFJsT5mfiIhLqmmnlQ==
X-CSE-MsgGUID: 27HFXT3oRR6Dqw6UZYmNvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11214"; a="37856186"
X-IronPort-AV: E=Sophos;i="6.11,177,1725346800"; 
   d="scan'208";a="37856186"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 02:41:18 -0700
X-CSE-ConnectionGUID: VPz0gbRmRt6KJtQ9pycZyA==
X-CSE-MsgGUID: sH2NfNaJSCSeBohKD0GCww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,177,1725346800"; 
   d="scan'208";a="74331922"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 02:41:16 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
	by kekkonen.fi.intel.com (Postfix) with ESMTP id 08F6A120CED;
	Fri,  4 Oct 2024 12:41:12 +0300 (EEST)
Received: from sailus by punajuuri.localdomain with local (Exim 4.96)
	(envelope-from <sakari.ailus@linux.intel.com>)
	id 1sweoC-000TW7-04;
	Fri, 04 Oct 2024 12:41:12 +0300
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH 06/51] crypto: Switch to __pm_runtime_put_autosuspend()
Date: Fri,  4 Oct 2024 12:41:12 +0300
Message-Id: <20241004094112.113453-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241004094101.113349-1-sakari.ailus@linux.intel.com>
References: <20241004094101.113349-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm_runtime_put_autosuspend() will soon be changed to include a call to
pm_runtime_mark_last_busy(). This patch switches the current users to
__pm_runtime_put_autosuspend() which will continue to have the
functionality of old pm_runtime_put_autosuspend().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/crypto/ccree/cc_pm.c                     | 2 +-
 drivers/crypto/hisilicon/qm.c                    | 2 +-
 drivers/crypto/omap-aes-gcm.c                    | 2 +-
 drivers/crypto/omap-aes.c                        | 2 +-
 drivers/crypto/omap-des.c                        | 2 +-
 drivers/crypto/omap-sham.c                       | 2 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c    | 2 +-
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 2 +-
 drivers/crypto/stm32/stm32-crc32.c               | 4 ++--
 drivers/crypto/stm32/stm32-cryp.c                | 2 +-
 drivers/crypto/stm32/stm32-hash.c                | 2 +-
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 6124fbbbed94..e4b7eab2e143 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -78,5 +78,5 @@ int cc_pm_get(struct device *dev)
 void cc_pm_put_suspend(struct device *dev)
 {
 	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
+	__pm_runtime_put_autosuspend(dev);
 }
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 07983af9e3e2..13408c43fa20 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -840,7 +840,7 @@ static void qm_pm_put_sync(struct hisi_qm *qm)
 		return;
 
 	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
+	__pm_runtime_put_autosuspend(dev);
 }
 
 static void qm_cq_head_update(struct hisi_qp *qp)
diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index c498950402e8..a5566268d928 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -39,7 +39,7 @@ static void omap_aes_gcm_finish_req(struct omap_aes_dev *dd, int ret)
 	crypto_finalize_aead_request(dd->engine, req, ret);
 
 	pm_runtime_mark_last_busy(dd->dev);
-	pm_runtime_put_autosuspend(dd->dev);
+	__pm_runtime_put_autosuspend(dd->dev);
 }
 
 static void omap_aes_gcm_done_task(struct omap_aes_dev *dd)
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index bad1adacbc84..bf0d953b8697 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -402,7 +402,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 	crypto_finalize_skcipher_request(dd->engine, req, err);
 
 	pm_runtime_mark_last_busy(dd->dev);
-	pm_runtime_put_autosuspend(dd->dev);
+	__pm_runtime_put_autosuspend(dd->dev);
 }
 
 int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 209d3dc03a9b..156ef345e7fe 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -493,7 +493,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 	crypto_finalize_skcipher_request(dd->engine, req, err);
 
 	pm_runtime_mark_last_busy(dd->dev);
-	pm_runtime_put_autosuspend(dd->dev);
+	__pm_runtime_put_autosuspend(dd->dev);
 }
 
 static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 5bcd9ab0f72a..6b36a1abd371 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1168,7 +1168,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
 
 	pm_runtime_mark_last_busy(dd->dev);
-	pm_runtime_put_autosuspend(dd->dev);
+	__pm_runtime_put_autosuspend(dd->dev);
 
 	ctx->offset = 0;
 
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 69d6019d8abc..0c9e1a7ee429 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -330,7 +330,7 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 theend:
-	pm_runtime_put_autosuspend(rkc->dev);
+	__pm_runtime_put_autosuspend(rkc->dev);
 
 	rk_hash_unprepare(engine, breq);
 
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 9393e10671c2..8ed80ab982ed 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -413,7 +413,7 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 	}
 
 theend:
-	pm_runtime_put_autosuspend(rkc->dev);
+	__pm_runtime_put_autosuspend(rkc->dev);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, areq, err);
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index e0faddbf8990..366f8ed11b7f 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -139,7 +139,7 @@ static int stm32_crc_init(struct shash_desc *desc)
 	spin_unlock_irqrestore(&crc->lock, flags);
 
 	pm_runtime_mark_last_busy(crc->dev);
-	pm_runtime_put_autosuspend(crc->dev);
+	__pm_runtime_put_autosuspend(crc->dev);
 
 	return 0;
 }
@@ -209,7 +209,7 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 
 pm_out:
 	pm_runtime_mark_last_busy(crc->dev);
-	pm_runtime_put_autosuspend(crc->dev);
+	__pm_runtime_put_autosuspend(crc->dev);
 
 	return 0;
 }
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 937f6dab8955..c4f926925f03 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -852,7 +852,7 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 		stm32_cryp_get_iv(cryp);
 
 	pm_runtime_mark_last_busy(cryp->dev);
-	pm_runtime_put_autosuspend(cryp->dev);
+	__pm_runtime_put_autosuspend(cryp->dev);
 
 	if (is_gcm(cryp) || is_ccm(cryp))
 		crypto_finalize_aead_request(cryp->engine, cryp->areq, err);
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 351827372ea6..0d4b8a491620 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1374,7 +1374,7 @@ static void stm32_hash_unprepare_request(struct ahash_request *req)
 
 pm_runtime:
 	pm_runtime_mark_last_busy(hdev->dev);
-	pm_runtime_put_autosuspend(hdev->dev);
+	__pm_runtime_put_autosuspend(hdev->dev);
 }
 
 static int stm32_hash_enqueue(struct ahash_request *req, unsigned int op)
-- 
2.39.5

