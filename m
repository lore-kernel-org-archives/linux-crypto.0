Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC1E17994
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jan 2024 04:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jwkD7D1y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704254993; x=1735790993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lguSdR6QXqn8hVNllEu1nTHqYQxCdzyg65OTZKCQ3mE=;
  b=jwkD7D1yYM0v9j7bSiGrtnsHh1VejcBZ5oGZtkAvzTYM0CyP8nlfQFXp
   N/yBMn2mDQfaViLtLuqKnu3ScKNEHEF3j9grp2iP/yrCMiA323iVb8ZHU
   odMG6Otd+8vaVrgKBdBW0KWJQo3Fq/T763Up/1JqPAZwp/aAaI+R+rBQG
   VIy2AKy/GOjx22bOD1B5ul61GYK3pHNGGLfgPFUH0EXzMbGGxkaPQuTHB
   Nu8YftgWGAjlniTiLobxhlFQkfr2lUeLCJLnh5wf5BNtLXD4FlkVN/1mw
   lYpLwwtEF3uw7GhmvG03GkZXfkfaBz2fZqA77V5KrGq5j0i+ZZMu/KsDF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3725561"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="3725561"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="1111241970"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="1111241970"
Received: from myep-mobl1.png.intel.com ([10.107.5.97])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:50 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Furong Zhou <furong.zhou@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>
Subject: [PATCH 8/9] crypto: qat - limit heartbeat notifications
Date: Wed,  3 Jan 2024 12:07:21 +0800
Message-Id: <20240103040722.14467-9-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103040722.14467-1-mun.chun.yep@intel.com>
References: <20240103040722.14467-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Furong Zhou <furong.zhou@intel.com>

When the driver detects an heartbeat failure, it starts the recovery
flow. Set a limit so that the number of events is limited in case the
heartbeat status is read too frequently.

Signed-off-by: Furong Zhou <furong.zhou@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_heartbeat.c | 17 ++++++++++++++---
 .../crypto/intel/qat/qat_common/adf_heartbeat.h |  3 +++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index fe8428d4ff39..ef23cd817818 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -205,6 +205,19 @@ static int adf_hb_get_status(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
+static void adf_heartbeat_reset(struct adf_accel_dev *accel_dev)
+{
+	u64 curr_time = adf_clock_get_current_time();
+	u64 last_reset = curr_time - accel_dev->heartbeat->last_hb_reset_time;
+
+	if (last_reset < ADF_CFG_HB_RESET_MS)
+		return;
+
+	accel_dev->heartbeat->last_hb_reset_time = curr_time;
+	if (adf_notify_fatal_error(accel_dev))
+		dev_err(&GET_DEV(accel_dev), "Failed to notify fatal error\n");
+}
+
 void adf_heartbeat_status(struct adf_accel_dev *accel_dev,
 			  enum adf_device_heartbeat_status *hb_status)
 {
@@ -229,9 +242,7 @@ void adf_heartbeat_status(struct adf_accel_dev *accel_dev,
 			"Heartbeat ERROR: QAT is not responding.\n");
 		*hb_status = HB_DEV_UNRESPONSIVE;
 		hb->hb_failed_counter++;
-		if (adf_notify_fatal_error(accel_dev))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to notify fatal error\n");
+		adf_heartbeat_reset(accel_dev);
 		return;
 	}
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
index 75db563f23ba..900876baac66 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
@@ -13,6 +13,8 @@ struct dentry;
 #define ADF_CFG_HB_TIMER_DEFAULT_MS 500
 #define ADF_CFG_HB_COUNT_THRESHOLD 3
 
+#define ADF_CFG_HB_RESET_MS 5000
+
 enum adf_device_heartbeat_status {
 	HB_DEV_UNRESPONSIVE = 0,
 	HB_DEV_ALIVE,
@@ -30,6 +32,7 @@ struct adf_heartbeat {
 	unsigned int hb_failed_counter;
 	unsigned int hb_timer;
 	u64 last_hb_check_time;
+	u64 last_hb_reset_time;
 	bool ctrs_cnt_checked;
 	struct hb_dma_addr {
 		dma_addr_t phy_addr;
-- 
2.34.1

