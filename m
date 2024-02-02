Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDC01427B
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871323; cv=none; b=sjP43jqn+5oI5zZ2HHIYwbsAkuaSVUdW2GxrxEL5GFW2VrsA3yucC/US3VAvoB3w9Ev3Vjw39a5JI2hvVZFXfIN0TjSwt8Nv0n49mbEd2MfuaNAFBD+4UHw/OrUvpj5A25sAcnapmAuvcgDSTuqkQN2rlPWv+ukUAKPLRk2D1BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871323; c=relaxed/simple;
	bh=KngnFF4I4XEPY1rp+UV+AMgeWe/ZmDkbkgVvIvHrm+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EUkFAUgguSqYqJLsoBmFpFvxESe4sAfeBclbIRueGoqwkM5AXkxgLqZcH8QtihCn0Vt4xa9t3Sl4K5NTVapnwc/FFAtFcRmzMvIEVhZDOLcVjphGBgIAZ/kjtw+1UQgzb8TALKI14XhONDu0l8VnIQ6i0iFOC/ly7TYJ7B9rjvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SmvaNzAa; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SmvaNzAa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871322; x=1738407322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KngnFF4I4XEPY1rp+UV+AMgeWe/ZmDkbkgVvIvHrm+k=;
  b=SmvaNzAa9KBWg+A8iqnQZtOOv4FQUQnNOVbkupWTNFVPzFc9VE4EEmHr
   GESSFBgNl8oZycVg54OSXzHs2CXDc9wz5qlV0mifkbKJVtLH1ZdZR4vh5
   JifDcFOi3Y+lOodiAWHf+T/h7XWGQIN+OoEixvlaSX8HyAEI9uH2ZSC6T
   jsQRYsMdesblQW7Q9MmM1sXEYZXUCwM2vpkxYF0s6oVFEeJk5whXqJdll
   t3wb/zDM5sc7mIkxyIThR1DkZJ3jk/nsJ9ceaMiabyb8258TRPxWf9YzR
   Z7PfwHGYDDiIDHvBQY/9pv1J/ENkinN6wCzRrV/FbdL3QMaGWaAqBf9Qb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787374"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787374"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53648"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:20 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Furong Zhou <furong.zhou@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mun Chun Yep <mun.chun.yep@intel.com>
Subject: [PATCH v2 8/9] crypto: qat - limit heartbeat notifications
Date: Fri,  2 Feb 2024 18:53:23 +0800
Message-Id: <20240202105324.50391-9-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240202105324.50391-1-mun.chun.yep@intel.com>
References: <20240202105324.50391-1-mun.chun.yep@intel.com>
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
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_heartbeat.c | 17 ++++++++++++++---
 .../crypto/intel/qat/qat_common/adf_heartbeat.h |  3 +++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index fe8428d4ff39..b19aa1ef8eee 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -205,6 +205,19 @@ static int adf_hb_get_status(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
+static void adf_heartbeat_reset(struct adf_accel_dev *accel_dev)
+{
+	u64 curr_time = adf_clock_get_current_time();
+	u64 time_since_reset = curr_time - accel_dev->heartbeat->last_hb_reset_time;
+
+	if (time_since_reset < ADF_CFG_HB_RESET_MS)
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
index 24c3f4f24c86..16fdfb48b196 100644
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

