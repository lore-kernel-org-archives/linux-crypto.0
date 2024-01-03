Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF30C1798C
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jan 2024 04:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CISFNrom"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704254989; x=1735790989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lS/DMn1u+PBnTm7P+jEYqFGS+WpaxZVAiRWyh4icSx4=;
  b=CISFNromqnaM8lB9Kv24EKZ1hzvYH7zpSNxylcU2moP1y1Dt0MKEGRWf
   6NoQRS/vikvR5JJQ9M11jB9xaAhnSk6UfqaKyrw/2bMIy6C1a4q9e2KAZ
   qOxK7auQdaLIluI2xkoqcPBuDn8NSUkgruKQuHSlY5iEbV2IT1I3CayVf
   rdYfMMSR3+1LlieTrn+aBG8gFW9R99b2nWsiPq5BDIi7fc7kjr7l9WNKk
   DSOFGnDQE6Xmey0NhpyASRMQS9PW+QwqLSNLknsxYfaOuiAAsJtrGr7oG
   3/ztirhuKFzdocsxisMZSxZc8Ocs6sQQXeaIEtvcg4cS2Xym/TtGIU8yI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3725544"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="3725544"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="1111241952"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="1111241952"
Received: from myep-mobl1.png.intel.com ([10.107.5.97])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:46 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>
Subject: [PATCH 6/9] crypto: qat - add fatal error notification
Date: Wed,  3 Jan 2024 12:07:19 +0800
Message-Id: <20240103040722.14467-7-mun.chun.yep@intel.com>
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

Notify a fatal error condition and optionally reset the device in
the following cases:
  * if the device reports an uncorrectable fatal error through an
    interrupt
  * if the heartbeat feature detects that the device is not
    responding

This patch is based on earlier work done by Shashank Gupta.

Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_heartbeat.c | 3 +++
 drivers/crypto/intel/qat/qat_common/adf_isr.c       | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
index f88b1bc6857e..fe8428d4ff39 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
@@ -229,6 +229,9 @@ void adf_heartbeat_status(struct adf_accel_dev *accel_dev,
 			"Heartbeat ERROR: QAT is not responding.\n");
 		*hb_status = HB_DEV_UNRESPONSIVE;
 		hb->hb_failed_counter++;
+		if (adf_notify_fatal_error(accel_dev))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to notify fatal error\n");
 		return;
 	}
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 3557a0d6dea2..9d60fff5a76c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -139,8 +139,13 @@ static bool adf_handle_ras_int(struct adf_accel_dev *accel_dev)
 
 	if (ras_ops->handle_interrupt &&
 	    ras_ops->handle_interrupt(accel_dev, &reset_required)) {
-		if (reset_required)
+		if (reset_required) {
 			dev_err(&GET_DEV(accel_dev), "Fatal error, reset required\n");
+			if (adf_notify_fatal_error(accel_dev))
+				dev_err(&GET_DEV(accel_dev),
+					"Failed to notify fatal error\n");
+		}
+
 		return true;
 	}
 
-- 
2.34.1

