Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA3A3E5A0E
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 08:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662696; cv=none; b=iSNTELzSw2eBxXLbLNvnPiN1yVV/g0TZwGnwCXp/l1LtsRkGlisMPi3//lUsEUaNNaMy4QCMpC8WVl2gTHV7uXltVrEtowgQHDKo+HOAp+qb+TTL5HlKydaMVnIJcwqpGhvsdGQb3IS3ERoyX/+A2+7LG5e0y1rhgGd68xiBpas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662696; c=relaxed/simple;
	bh=BVZBKeE8QXGSX9SoLhs/tzMNqf1IwAxxfs0wp2PlIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t2LJ0gt/YHAfmAZYoU7P5AWDVXYEcFswoLqtXxYZe4odBSrcJJEkiVE0HcXAZEJvMatQAin63ZXQ27H9UBdHHaaa87DeWHSNRk0noiJEJ5BCqwGwcD9pkgDW7QPssI+zeCyqATp8HJC/EChdOcCHNfZpiz3wNXnK3ZlzemdMCKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5RWxwL7; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5RWxwL7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778662695; x=1810198695;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BVZBKeE8QXGSX9SoLhs/tzMNqf1IwAxxfs0wp2PlIGE=;
  b=R5RWxwL7xjvhyXysdMKL9Zn4sWgIRDl2P5mh2PqSSW5u9nJSqjHhNYJA
   MALDOIpd2SH/oVaorTu9twGDs103wlcis4ePtvN8wipuCzl3ic7PwmLue
   1BZS13oe6fSN9WhG0Tw5lNdW74s3cRQj+4rTs2tRUOpJl0iYKHhtb3IYW
   NTohmO/lfwY0nFJcKGmSfyXPt/akcXuJ+wHITb1NoOPC7XXwsZyRq4sm8
   ywVWRAs5rkiM4gUeOhkjQ8H6Pvam6N9UIUsQLSBhJbaVBEmTWiCGondOr
   ziq6Q0VgXni1d/qGkmTYmiQx2QSq1DcrLXtg6itponkiC0RpWb3exbIzf
   A==;
X-CSE-ConnectionGUID: nd4YKDmxQdS2ayBsuEs4ng==
X-CSE-MsgGUID: QM1z9rkiQYCXxQn0/xoElw==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="79614383"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="79614383"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 01:58:14 -0700
X-CSE-ConnectionGUID: n0z+Mkl5Tq6+pNjM+aYTmw==
X-CSE-MsgGUID: GTpvaP6KTReaKIKZ579vEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239840183"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 01:58:11 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [PATCH] crypto: qat - remove MODULE_VERSION
Date: Wed, 13 May 2026 09:57:45 +0100
Message-ID: <20260513085808.626413-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

In-tree drivers do not need MODULE_VERSION as the kernel release
identifies the version of their code. The static version "0.6.0", which
the QAT drivers currently report, can be misleading as it might suggest
the drivers are outdated.

Remove MODULE_VERSION() from all QAT driver modules and the related
ADF_DRV_VERSION, ADF_MAJOR_VERSION, ADF_MINOR_VERSION and
ADF_BUILD_VERSION macros from adf_common_drv.h.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c         | 1 -
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c          | 1 -
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c         | 1 -
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c       | 1 -
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c          | 1 -
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c        | 1 -
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 7 -------
 drivers/crypto/intel/qat/qat_common/adf_module.c     | 1 -
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c      | 1 -
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c    | 1 -
 10 files changed, 16 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index cfa00daeb4fb..566adc0a2d11 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -210,6 +210,5 @@ MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_420XX_FW);
 MODULE_FIRMWARE(ADF_420XX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_SOFTDEP("pre: crypto-intel_qat");
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index c9be5dcddb27..daca73651c14 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -214,6 +214,5 @@ MODULE_FIRMWARE(ADF_402XX_FW);
 MODULE_FIRMWARE(ADF_4XXX_MMP);
 MODULE_FIRMWARE(ADF_402XX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_SOFTDEP("pre: crypto-intel_qat");
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index bceb5dd8b148..7a59bca3242f 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -256,5 +256,4 @@ MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_C3XXX_FW);
 MODULE_FIRMWARE(ADF_C3XXX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index c622793e94a8..0881575f7670 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -225,5 +225,4 @@ module_exit(adfdrv_release);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 23ccb72b6ea2..4972e52dd944 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -256,5 +256,4 @@ MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_C62X_FW);
 MODULE_FIRMWARE(ADF_C62X_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index 4840d44bbd5b..d3f728b9f2f2 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -225,5 +225,4 @@ module_exit(adfdrv_release);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index e8dd76751dfb..a05d149423b0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -9,13 +9,6 @@
 #include "icp_qat_fw_loader_handle.h"
 #include "icp_qat_hal.h"
 
-#define ADF_MAJOR_VERSION	0
-#define ADF_MINOR_VERSION	6
-#define ADF_BUILD_VERSION	0
-#define ADF_DRV_VERSION		__stringify(ADF_MAJOR_VERSION) "." \
-				__stringify(ADF_MINOR_VERSION) "." \
-				__stringify(ADF_BUILD_VERSION)
-
 #define ADF_STATUS_RESTARTING 0
 #define ADF_STATUS_STARTING 1
 #define ADF_STATUS_CONFIGURED 2
diff --git a/drivers/crypto/intel/qat/qat_common/adf_module.c b/drivers/crypto/intel/qat/qat_common/adf_module.c
index fccaa71eeedc..30069feec3c1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_module.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_module.c
@@ -60,5 +60,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_ALIAS_CRYPTO("intel_qat");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_INTERNAL");
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index b59e0cc49e52..8a863d7d86d7 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -256,5 +256,4 @@ MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_DH895XCC_FW);
 MODULE_FIRMWARE(ADF_DH895XCC_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_QAT");
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index 7cd528ee31e7..f8a6e10a1de7 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -225,5 +225,4 @@ module_exit(adfdrv_release);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
-MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_IMPORT_NS("CRYPTO_QAT");

base-commit: dd0db6d3f236c9b81a9495a2d9e532237d3d6944
-- 
2.54.0

