Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F6397694
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 09:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778231965; cv=none; b=flmfcZkf8Fu0rCFJZvBpJBRzadVGtHbwLY+CqV9iuKThTZUMBrGR3eADg8bH3K6R+ZuO6IBXCIw8MaGKVI0hZXCxoWhmpYoPVTFfX7Ze5gVLQuXTrV1T74a5/MCCeS5PKLBkCKeW43TPrskGC+y792j+noYh4WwH84+g2B/3v2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778231965; c=relaxed/simple;
	bh=tLrUAWPHfkd1S0MOGuZUJUZqeQlW5Sqf8EsmggKNTwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyDY7FftHoi12E3rngh/iVuKwnxFgZ5zVwqAJm5GXwSGaiTMkKdL0h0gvhRVwcoOMIrF8ohWNqhOjy5Z8n6/klTX+e5WCYlDM9zOvC4sQf9S4B19n093zJYPE+WQAmj4NtJSIyN8BUckgKqaztsd7iBVUcSipljpTCLIJKV5Qhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H5yR4Tnt; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H5yR4Tnt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778231961; x=1809767961;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tLrUAWPHfkd1S0MOGuZUJUZqeQlW5Sqf8EsmggKNTwA=;
  b=H5yR4TntpTb5fNETG4p4ZbpWtlj3420prCw8Aq1GGEG/vBJem8Pw7lVG
   g/odErI0oj49PRbsXFKUYygGpNMWewcaa/3vxegNq2Zb5cXv1vHWXUV+d
   swrfheEVedFTuYJ3Uflpys7Z5dJRYyKLz/ewq1jB5XN3Gm+vJjY0/irHf
   ui2BWsq5pQ7mMeJL3ugACYLJhpav3bNO+C/tHToKqMMbxU3sf/Xv7YE//
   Pic/8q0UbwcadbG4BgV+iJrAQN7ADolT7ePpQQse6fx3NfqJIFbCrQyHO
   WdvcBImfAZ+WhTiofHHNLCBzotnUqBxy9mlJR2jmorjvVIeWq6FJBlYGF
   A==;
X-CSE-ConnectionGUID: EatpTGTFQkWMFdFP8bVYFg==
X-CSE-MsgGUID: 0hkb25x2QAG4aRLosJQC4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="79238691"
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="79238691"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 02:19:21 -0700
X-CSE-ConnectionGUID: olFhwNEHSMGJts2hQb+1DA==
X-CSE-MsgGUID: mKog6Q18QFyRZw31h08fGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="240712894"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa003.jf.intel.com with ESMTP; 08 May 2026 02:19:19 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	wangzhi@stu.xidian.edu.cn,
	byu@xidian.edu.cn,
	w15303746062@163.com,
	vdronov@redhat.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 2/2] crypto: qat - rename adf_ctl_drv.c to adf_module.c
Date: Fri,  8 May 2026 10:18:24 +0100
Message-ID: <20260508091912.206913-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260508091912.206913-1-giovanni.cabiddu@intel.com>
References: <20260508091912.206913-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Now that the character device and IOCTL interface have been removed,
adf_ctl_drv.c only contains module_init/module_exit hooks. Rename it
to adf_module.c to better reflect its purpose and rename the init/exit
functions accordingly.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/Makefile              | 2 +-
 .../intel/qat/qat_common/{adf_ctl_drv.c => adf_module.c}  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/crypto/intel/qat/qat_common/{adf_ctl_drv.c => adf_module.c} (84%)

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 9478111c8437..2b1649001518 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -9,7 +9,6 @@ intel_qat-y := adf_accel_engine.o \
 	adf_cfg.o \
 	adf_cfg_services.o \
 	adf_clock.o \
-	adf_ctl_drv.o \
 	adf_dc.o \
 	adf_dev_mgr.o \
 	adf_gen2_config.o \
@@ -26,6 +25,7 @@ intel_qat-y := adf_accel_engine.o \
 	adf_hw_arbiter.o \
 	adf_init.o \
 	adf_isr.o \
+	adf_module.o \
 	adf_mstate_mgr.o \
 	adf_rl_admin.o \
 	adf_rl.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_module.c
similarity index 84%
rename from drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
rename to drivers/crypto/intel/qat/qat_common/adf_module.c
index f01f2946de6e..fccaa71eeedc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_module.c
@@ -7,7 +7,7 @@
 
 #include "adf_common_drv.h"
 
-static int __init adf_register_ctl_device_driver(void)
+static int __init adf_register_module(void)
 {
 	if (adf_init_misc_wq())
 		goto err_misc_wq;
@@ -43,7 +43,7 @@ static int __init adf_register_ctl_device_driver(void)
 	return -EFAULT;
 }
 
-static void __exit adf_unregister_ctl_device_driver(void)
+static void __exit adf_unregister_module(void)
 {
 	adf_exit_misc_wq();
 	adf_exit_aer();
@@ -54,8 +54,8 @@ static void __exit adf_unregister_ctl_device_driver(void)
 	adf_clean_vf_map(false);
 }
 
-module_init(adf_register_ctl_device_driver);
-module_exit(adf_unregister_ctl_device_driver);
+module_init(adf_register_module);
+module_exit(adf_unregister_module);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-- 
2.54.0

