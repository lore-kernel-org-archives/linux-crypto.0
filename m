Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793359163;
	b=ZvlPAopi4EAi/y07mjZ/bPytpH8gmcFmtOpbzFHWQ2tg0F5JOiovkjBXqpTgu9HlAMDK
	 pfdNcqefYXruKYp3aUk1Q78OB97ebSnET89dRHF1IDvGTZddT7p1NwLCU0KHtraPNYPoC
	 4OkP1bIj0tmiH1CHAg+uoBbFPOFuAXw+CQrCs4pY2cZbc8TgawN4SaVIam/jC2WbndlpF
	 ik7EVcoRP1ac8KqXjPA3OIa9qrHd5xbQ0R4VZklm1ghedY2UEOybGD+cn2PNLHhrRq/th
	 ufL9T2GUtHhsBSSMcKdBdA/pkY9Nc7YdYj6w/sPDIx+sNzROako+C/VOCdcxNxrMeVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359163;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Organization:
	 Content-Transfer-Encoding;
	bh=5KJJCoSbhpmtShqhN2JaAjEuWJteUwpwrPa69Mx1cTE=;
	b=jZwVK9o3Q0myuSRB1u//PQmBm6gKpRXiYxODnIqk1sd6XufxdZt0ajUV17ohqIZMIRmz
	 1t5JHuJQeCOBfpzkZqqFEu462Ih1s6ihFuVNwikkqnaYIUIQEdpH52791tgAYpsTCzxoo
	 htaSgcKZRUKC2ii5vikV2NafCwqMsbdCDFUiesd+/oH+Z6hSFJNRJZ+CUFJicKzIbioNn
	 l49C/6aDJgftTdpdvzUcWn8iFEU+uiBNjLcesD6cY2VdHU74sbjcv6psvV/SHct5JyXA+
	 zTH8Sxg6e27Cv/CoXOEkGSfNYdhg4I3mRvA5IA7xmehdxdr6heFxBJ1e5sn9EfvJSfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gPEuTuQD;
	arc=none smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24819606A32C
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 11:19:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24819606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gPEuTuQD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793359162; x=1824895162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q0iG+B5jKgefyJqljYp8kPvhMj+QFiAjEOmlgJgl4ak=;
  b=gPEuTuQDuscN8IZM9TWIM3M/fPSfXoVX1rxr8GzytCFMVtAKs6U5JnhY
   k6sgSsS83egYpQ/OkUj6URIINSpg7tCoo6MlfcVziSHyNoAtaqNTBwvF9
   4S6lKOv0iiAczsRM5lUk2n1Yd2/DluH2YS1UxieU35aHjiSC49ziSTihi
   kf8qzy5t7jAiPRwkFFVGThX15Ov+T41f6uF9HWKA0xXzRrBp5e9hd1h0J
   mq8TYbWeMP9ireyaXMKFKhKzATjinlHedCjCzNgI4fHHLJruDUDP68Bt9
   Bu22NzFlML8HZi7RhbHDVHD71yT9oaz2AMn0Rxnb+YEs7EfkHtyDBFCr9
   A==;
X-CSE-ConnectionGUID: QfIH8KsCQACbjUCTHE80Vg==
X-CSE-MsgGUID: N/MArCtiS76RWoEPephNrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="1996919"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="1996919"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 04:19:21 -0700
X-CSE-ConnectionGUID: Ug6RhXSGQJanpknqWOu/Yw==
X-CSE-MsgGUID: ZaYljijJRuyrdVQA3ZkAnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5551080"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa002.fm.intel.com with ESMTP; 30 Oct 2026 04:19:19 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - make adf_ae_shutdown() a void function
Date: Fri, 30 Oct 2026 11:19:16 +0000
Message-ID: <20261030111916.483870-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

adf_ae_shutdown() has no failure mode and has always returned 0, yet
its only caller in adf_dev_shutdown() carries an error branch that
reports a shutdown failure and skips clearing
ADF_STATUS_AE_INITIALISED. That branch is unreachable.

Change the return type to void and drop the dead error handling.

Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_engine.c | 5 ++---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h   | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_init.c         | 8 ++------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
index 09d4f547e082..bb97bbedbb8a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
@@ -204,16 +204,15 @@ int adf_ae_init(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 
-int adf_ae_shutdown(struct adf_accel_dev *accel_dev)
+void adf_ae_shutdown(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
 
 	if (!hw_device->fw_name)
-		return 0;
+		return;
 
 	qat_hal_deinit(loader_data->fw_loader);
 	kfree(accel_dev->fw_loader);
 	accel_dev->fw_loader = NULL;
-	return 0;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 762a0b5e774a..533388cfa252 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -67,7 +67,7 @@ int adf_dev_started(struct adf_accel_dev *accel_dev);
 int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev);
 int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev);
 int adf_ae_init(struct adf_accel_dev *accel_dev);
-int adf_ae_shutdown(struct adf_accel_dev *accel_dev);
+void adf_ae_shutdown(struct adf_accel_dev *accel_dev);
 int adf_ae_fw_load(struct adf_accel_dev *accel_dev);
 void adf_ae_fw_release(struct adf_accel_dev *accel_dev);
 int adf_ae_start(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 81cb5e6c9f4a..6af0866b9539 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -393,12 +393,8 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 	}
 
 	if (test_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status)) {
-		if (adf_ae_shutdown(accel_dev))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to shutdown Accel Engine\n");
-		else
-			clear_bit(ADF_STATUS_AE_INITIALISED,
-				  &accel_dev->status);
+		adf_ae_shutdown(accel_dev);
+		clear_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status);
 	}
 
 	mutex_lock(&service_lock);
-- 
2.50.1

