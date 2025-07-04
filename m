Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB66D28C2C9;
	Fri,  4 Jul 2025 07:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751615651; cv=none; b=COUF4LZfOU8P0kkzxeO01jkYysyfA6rK3HWVVVt9Qs9aoxsrDOEG6c1w3lkzR6dE8Ef9iBU6BxT8YUUikzQDu01D+Z27TPis9Xf8AsfiqB1Fpx4P+nmiwnC4qt05nHHxAINpmnqsT0QICY/hqzCG91IvzdFE+zuKvhBok3t13gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751615651; c=relaxed/simple;
	bh=egUHL6RyLJfuRq1gVjjLudjmpTQnx+4gpQe9sleSvp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kiBmtNBqpXdwTw/kfB47mK7/FRMQaUOQaJswCxjqj2fGO/EiTLwrPEy3DIFN3s81wbOc4r9PcJ6+0SARKYkMfXhUVqm/LbPrIFzNWDPAZwDDiZ3Yp4IxPipvHb9nkmOCgyMgeMoJUjEs+h8WiOSHK3a55dusA8WeUmSjkRlb6sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E0q1HzRZ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E0q1HzRZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751615649; x=1783151649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=egUHL6RyLJfuRq1gVjjLudjmpTQnx+4gpQe9sleSvp8=;
  b=E0q1HzRZxiDYHxbPp+oXwLkZZnZZ+8+yvv+f6Qy/IxwxMzx25DapJWFl
   mJAzXl3l9s5i3rDnANPc6s7cHty6dH2mYSSYWEUEQzjdMRsG8UwFvRwAy
   COfM5YESB+0eX+AiwbNSE8Mz4housoNlc/AaukPADiJmevPAyX/gDt4Cr
   HrlAS5gDjSKYanIZ/rxsYNyYk375/1/rPmQ5QoJuHJTIJqrTVix0cY4Wx
   XsL+x1W10ezcBU+tJQdfAfFpjpmEPjN3trNVqQl05SA5oL3EQe+BfxDpy
   yhBZEqyf4neToUzz6H0O1iVZzhT8rDyiQREg1FdDI1EeiN9PAmF3KJtKg
   w==;
X-CSE-ConnectionGUID: 2NvexcnATf6O3LUQmSuPgA==
X-CSE-MsgGUID: U9ObsUCOSNKsQz7OM1bPIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76494485"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="76494485"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:54:09 -0700
X-CSE-ConnectionGUID: phoA/CdOScGQ5w7h4YAwIw==
X-CSE-MsgGUID: nyKMon0+Sb2jJnHLR6QVFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="158924179"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO svinhufvud.fi.intel.com) ([10.245.244.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 00:54:05 -0700
Received: from svinhufvud.lan (localhost [IPv6:::1])
	by svinhufvud.fi.intel.com (Postfix) with ESMTP id AF13844419;
	Fri,  4 Jul 2025 10:54:02 +0300 (EEST)
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Eric Biggers <ebiggers@google.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/80] crypto: Remove redundant pm_runtime_mark_last_busy() calls
Date: Fri,  4 Jul 2025 10:54:02 +0300
Message-Id: <20250704075402.3217279-1-sakari.ailus@linux.intel.com>
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

 drivers/crypto/ccree/cc_pm.c      | 1 -
 drivers/crypto/hisilicon/qm.c     | 1 -
 drivers/crypto/omap-aes-gcm.c     | 1 -
 drivers/crypto/omap-aes.c         | 1 -
 drivers/crypto/omap-des.c         | 1 -
 drivers/crypto/omap-sham.c        | 1 -
 drivers/crypto/stm32/stm32-cryp.c | 1 -
 drivers/crypto/stm32/stm32-hash.c | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 6124fbbbed94..bbd118f8de0e 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -77,6 +77,5 @@ int cc_pm_get(struct device *dev)
 
 void cc_pm_put_suspend(struct device *dev)
 {
-	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 }
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 7c41f9593d03..2e4ee7ecfdfb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -912,7 +912,6 @@ static void qm_pm_put_sync(struct hisi_qm *qm)
 	if (!test_bit(QM_SUPPORT_RPM, &qm->caps))
 		return;
 
-	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 }
 
diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index c498950402e8..1f4586509ca4 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -38,7 +38,6 @@ static void omap_aes_gcm_finish_req(struct omap_aes_dev *dd, int ret)
 
 	crypto_finalize_aead_request(dd->engine, req, ret);
 
-	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
 }
 
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 1ecf5f6ac04e..244e24e52987 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -400,7 +400,6 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	crypto_finalize_skcipher_request(dd->engine, req, err);
 
-	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
 }
 
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index a099460d5f21..9c5538ae17db 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -489,7 +489,6 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 
 	crypto_finalize_skcipher_request(dd->engine, req, err);
 
-	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
 }
 
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 56f192cb976d..6328e8026b91 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1167,7 +1167,6 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	dd->flags &= ~(BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
 			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
 
-	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
 
 	ctx->offset = 0;
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 5ce88e7a8f65..a89b4c5d62a0 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -851,7 +851,6 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 	if (!err && (!(is_gcm(cryp) || is_ccm(cryp) || is_ecb(cryp))))
 		stm32_cryp_get_iv(cryp);
 
-	pm_runtime_mark_last_busy(cryp->dev);
 	pm_runtime_put_autosuspend(cryp->dev);
 
 	if (is_gcm(cryp) || is_ccm(cryp))
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 768b27de4737..a4436728b0db 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1373,7 +1373,6 @@ static void stm32_hash_unprepare_request(struct ahash_request *req)
 		*preg++ = stm32_hash_read(hdev, HASH_CSR(i));
 
 pm_runtime:
-	pm_runtime_mark_last_busy(hdev->dev);
 	pm_runtime_put_autosuspend(hdev->dev);
 }
 
-- 
2.39.5

