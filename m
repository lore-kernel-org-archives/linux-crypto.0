Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51FE26B08F
	for <linux-crypto@vger.kernel.org>; Sat,  9 May 2026 07:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778310242; cv=none; b=VXTDwwh6KmhhijNRJtD1ufxooOujv8iyVNTlqkrSkNuHwZvJAisAcnjomp1vAL1AjzMZkCC+5xqamqE53v0LaCrm9HffhVpA3RswHmuI10exZqVrxZigQfFklQaG3aWVymE6nQnGfF9tbVPdCCxUp0uBNp983yrb6h4MNqfekjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778310242; c=relaxed/simple;
	bh=tLrUAWPHfkd1S0MOGuZUJUZqeQlW5Sqf8EsmggKNTwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UL13PaAUxYnNWStGTNp1yCjdAsF/rkCzowGts1TDpzqmnFBlbr2ZuH30qvSMyf1VaOpU1n1OgRg2CJgOScfEAedVDofZFeXdJTnkEySPl4EQkrhM5JYLQdN2JrY6qOeTvM9aUUDb6Rhc5MmT/Lt4B7S1xDxB6vd5SFnnO9pyFwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gwD3Apfi; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gwD3Apfi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778310240; x=1809846240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tLrUAWPHfkd1S0MOGuZUJUZqeQlW5Sqf8EsmggKNTwA=;
  b=gwD3ApfiKX11uUVoFa5+KkydbSeU8EN8wraRrdqXKVqf7rJZDg+K+PYi
   bHysTBGFL/v86ObD+O5HybZoOaErvaNXQ9apbASie9w1W1KLILSLJhios
   V0GmhK+3rbBaHL6q8JYR+uZ2aJoLmHr07FXlYMyWwNnoXjtnmEla9TUKS
   Y4gEgADNofhwU5d72KWZZxC1vyEMK562WNIHDdYi4lL2MAsf2E3n5Ue/Y
   2PCgNy8gdn41paTL8cpwcSxMDpvDuk7vy+wsW7J0Sj95M1/2oGwKZxd1J
   h0pPvxao0lV7hpAUVML/ptD8/MdciPbnw+/CPtLK5Uy5pEh79IjhmJDTY
   g==;
X-CSE-ConnectionGUID: SWgCXSHMSiOLcHsXmLkPZA==
X-CSE-MsgGUID: 8rz1gnEsR1Opqlw8cxrIPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="90660197"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="90660197"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 00:04:00 -0700
X-CSE-ConnectionGUID: KzKc4i2PQe+k4GJQlcDNVg==
X-CSE-MsgGUID: zFN8GMAaQvC6CmebgUjZTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="234304149"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by fmviesa008.fm.intel.com with ESMTP; 09 May 2026 00:03:58 -0700
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
Subject: [PATCH v2 2/2] crypto: qat - rename adf_ctl_drv.c to adf_module.c
Date: Sat,  9 May 2026 08:00:13 +0100
Message-ID: <20260509070340.12201-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260509070340.12201-1-giovanni.cabiddu@intel.com>
References: <20260509070340.12201-1-giovanni.cabiddu@intel.com>
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

