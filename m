Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56D27D418
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871318; cv=none; b=qwd+UjRHYWgiBvocZ8BMVKwXrZpd/pv4XsV3ILUgFN2ax7uDyDCbTIWxgWmKJkEbGSXxLOZIOxx1NROIT9cdDPqpZM3PSca/BAUrYM2ACW5LYvnBl3O5i1WRLrOtNJBdC0g0Ml20lidsw7BnUumENYBDJVV5Msf6TUPTogklUAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871318; c=relaxed/simple;
	bh=aNdfu8a76RK9rIHvl77AB1xtT6MV9sknou2JE8sop7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B+AUD7b9GEvoKt9m5AGB5RFRHCPnunUEuW+JkzSWOLwg7quYmZIed2Gy8FuB91gxdbFc4aPtfbdLuo1cALPrPOBQq20WaJSlAa9CFXplP/G0ZGQA2HinTs1f6CrKOl/fGFklmLV/ChMPpfEZIqGul7p7WiAtbQ+oViU6SbdXlPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZNJneuj0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZNJneuj0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871317; x=1738407317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aNdfu8a76RK9rIHvl77AB1xtT6MV9sknou2JE8sop7I=;
  b=ZNJneuj0K/kNcd0ou9b/T6+oVYWBgoDrrQ7Vw2jXadL3wP8YVjuo51zq
   CUhSPbXuD+GDz442v6K0nAN5VXbjRsndccIbZGAOxB7HEyz00yxXnTcYK
   tH+vfvC34+Mdgko3NLUKPL1oClQQxZSqWFFhnijJB3qIR3DFr07BehN/f
   4zAkY/QG6a2FrqHLkHck0cyNkeGTzWBQF8aRjjxCZjjr+nS2p7yQ73tII
   L9N2CQx8NVM57EN9xqVcsy0jU8ws63+somNFA2pw7gPbKKzKlHcan417i
   KqCRgk2dPwviutngxUHb2ERTKaRyVuSXBUvQVVXvtCODH6sQB5x+gpSNu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787332"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787332"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53626"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:15 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 6/9] crypto: qat - add fatal error notification
Date: Fri,  2 Feb 2024 18:53:21 +0800
Message-Id: <20240202105324.50391-7-mun.chun.yep@intel.com>
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
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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
index a13d9885d60f..020d213f4c99 100644
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

