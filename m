Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72852236FD
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778494148; cv=none; b=IRpLW57PsVcKuasKe1S68jGDnptDP/6QMA7x+6QdSEsZZiy9rwLA3kOvzmz0SAF4I3Pxi/HOfIbiDrtSmRb0sb7dpeACGNDrdnJncrf+TtPa+X13kdtFLwnxGBxp1HGXPkFCzu3/+lEAIpPnkPc9jjaiq0r6d3PIKU7c3o4hgcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778494148; c=relaxed/simple;
	bh=tLrUAWPHfkd1S0MOGuZUJUZqeQlW5Sqf8EsmggKNTwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dseChGDp8OO4tzMWg1RPB0TWfDvvKcVI+NZIv9IaFk+oMRv2Eew0m7PwuzWRoT7c8WGHdg4UPQdqQ7B8KBTT7ISj09McM4gkBgxgTume2rAZn9OKDT2DZRFMyxnLSQralThy+538372Q8q1nuE0wRZUmGetNirqcvZ1PrE/Ddd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jsiQA+jZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jsiQA+jZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778494146; x=1810030146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tLrUAWPHfkd1S0MOGuZUJUZqeQlW5Sqf8EsmggKNTwA=;
  b=jsiQA+jZUIUHJXMHSREoUNnoF6vBZnDWqQWgtjtC7eOcyPTEfDWGkkuG
   x4EBZh1u3A/jBngD+aV7bjRa6gVDDuHd0/ny1AKfsoic585AclkACk29Y
   ic8mlog+QHjj3lNlfyLERa8BK3MkkSR475xOpB/5TiVBHBDY64v93pc07
   ZZXMXM6PTbXWO38xny9yXBcY06uYy2QflM/2oB/SpMunVto5oTo5Gfskt
   m1OH2Ls+vEFPJcZIxnqdCk6zz578ocawPrRRJF/HV7AnhZnRqa5H7Lc/g
   sZW0VsMNUIr7uTWGw4OCcpoYdFKKpiK1Z9Kmi716NPDRAnpMV8lRw5O0y
   w==;
X-CSE-ConnectionGUID: rRB9BiL0RZimACdA1rkIHw==
X-CSE-MsgGUID: u7C5uvPrTxKXeq9m4vVtHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="90478174"
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="90478174"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 03:09:06 -0700
X-CSE-ConnectionGUID: fPj7Zh/BSGqFqaAqdH74EA==
X-CSE-MsgGUID: UHIMeffjQKWj7Pe6USEPkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="232929478"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by fmviesa006.fm.intel.com with ESMTP; 11 May 2026 03:09:03 -0700
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
Subject: [PATCH v3 2/2] crypto: qat - rename adf_ctl_drv.c to adf_module.c
Date: Mon, 11 May 2026 11:04:09 +0100
Message-ID: <20260511100854.29474-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511100854.29474-1-giovanni.cabiddu@intel.com>
References: <20260511100854.29474-1-giovanni.cabiddu@intel.com>
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

