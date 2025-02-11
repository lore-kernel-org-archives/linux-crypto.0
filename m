Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F751F2373
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 10:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739268010; cv=none; b=eQOcPio2Lniqr8uplBR3IjB0y7UcrduioRL6hzF6kjED0cij6ifMDZmhOL6PN+zgsf8rpQmOpNAuSsvMOJS+Imdei5s373NTB1HxnpXaLzUMhV4Azk12wzbGQZXAhPhDLhmWUqP5Ecos6K5yk/No519dcr9tMcirOtiYPiwH8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739268010; c=relaxed/simple;
	bh=ro8caf7SM8Y1ZMwQAsFd5F/uNYeQwmr4nuVwl9FzKas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7eKOhtjFhcOM2Y/VlsuSkfCILN7yanY3IX8cSR7NjXNuFseswFk4pKx4xW5HvPBo26cMfKI50AIhuaqFUXYJAnZkE6Srv+qORE2U3wcuZLMmLOMO6ZKGA43DDvE0ILmYATJNswwSt/L1/T8g5Jclv4PIah1BNOWFC7zFin3+h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iRtQEft8; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iRtQEft8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739268009; x=1770804009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ro8caf7SM8Y1ZMwQAsFd5F/uNYeQwmr4nuVwl9FzKas=;
  b=iRtQEft8DVeTXBly6vfYDhOUPPQ8WSNBptqHMEMgAtalxAy1/aOljKbk
   APN5bOCAD3ik7KVeqwColUkQf3Z7CE54fvkWXvQI4rYoNTejWwSVZl5IL
   LYsIdfJlqP32+Rae6YExE4F2eUmuQl6/6WO2TxCjaltDA0V/4Vm3CTvQg
   1NUC1nTPOZrXnnj6VWDtIs/AY86RbQI3xu0NVsof37hKvnkvQgqmJB3pC
   i0qI2z5/LLgpd4hibsYienx+Cr+PAQ4E05p0QO8IaKKWy6Y1ar0Bzbq/7
   bQhlrFA5twNP74Mh1JZJDnVWcy+uU0zfJmdgC+yvCmIcqrfggoXdY/2oe
   Q==;
X-CSE-ConnectionGUID: 8bnPgRgSRSWjW3B2hlM4bg==
X-CSE-MsgGUID: YINzo5UPQAaqNrypRGT3yA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="27477127"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="27477127"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 02:00:08 -0800
X-CSE-ConnectionGUID: PSA598ErQiuJR6/+Masxrw==
X-CSE-MsgGUID: UOt6zjBLTCKAmPFx5eiWgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112321333"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by orviesa010.jf.intel.com with ESMTP; 11 Feb 2025 02:00:07 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] crypto: qat - fix object goals in Makefiles
Date: Tue, 11 Feb 2025 09:58:52 +0000
Message-ID: <20250211095952.14442-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211095952.14442-1-giovanni.cabiddu@intel.com>
References: <20250211095952.14442-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Align with kbuild documentation by using <module_name>-y instead of
<module_name>-objs, following the kernel convention for building modules
from multiple object files.

Link: https://docs.kernel.org/kbuild/makefiles.html#loadable-module-goals-obj-m
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/Makefile      | 2 +-
 drivers/crypto/intel/qat/qat_4xxx/Makefile       | 2 +-
 drivers/crypto/intel/qat/qat_c3xxx/Makefile      | 2 +-
 drivers/crypto/intel/qat/qat_c3xxxvf/Makefile    | 2 +-
 drivers/crypto/intel/qat/qat_c62x/Makefile       | 2 +-
 drivers/crypto/intel/qat/qat_c62xvf/Makefile     | 2 +-
 drivers/crypto/intel/qat/qat_common/Makefile     | 2 +-
 drivers/crypto/intel/qat/qat_dh895xcc/Makefile   | 2 +-
 drivers/crypto/intel/qat/qat_dh895xccvf/Makefile | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/Makefile b/drivers/crypto/intel/qat/qat_420xx/Makefile
index 45728659fbc4..72b24b1804cf 100644
--- a/drivers/crypto/intel/qat/qat_420xx/Makefile
+++ b/drivers/crypto/intel/qat/qat_420xx/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_420XX) += qat_420xx.o
-qat_420xx-objs := adf_drv.o adf_420xx_hw_data.o
+qat_420xx-y := adf_drv.o adf_420xx_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_4xxx/Makefile b/drivers/crypto/intel/qat/qat_4xxx/Makefile
index 9ba202079a22..e8480bb80dee 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/Makefile
+++ b/drivers/crypto/intel/qat/qat_4xxx/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_4XXX) += qat_4xxx.o
-qat_4xxx-objs := adf_drv.o adf_4xxx_hw_data.o
+qat_4xxx-y := adf_drv.o adf_4xxx_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/Makefile b/drivers/crypto/intel/qat/qat_c3xxx/Makefile
index 7a06ad519bfc..d9e568572da8 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/Makefile
+++ b/drivers/crypto/intel/qat/qat_c3xxx/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXX) += qat_c3xxx.o
-qat_c3xxx-objs := adf_drv.o adf_c3xxx_hw_data.o
+qat_c3xxx-y := adf_drv.o adf_c3xxx_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile b/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile
index 7ef633058c4f..31a908a211ac 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXXVF) += qat_c3xxxvf.o
-qat_c3xxxvf-objs := adf_drv.o adf_c3xxxvf_hw_data.o
+qat_c3xxxvf-y := adf_drv.o adf_c3xxxvf_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c62x/Makefile b/drivers/crypto/intel/qat/qat_c62x/Makefile
index cc9255b3b198..cbdaaa135e84 100644
--- a/drivers/crypto/intel/qat/qat_c62x/Makefile
+++ b/drivers/crypto/intel/qat/qat_c62x/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C62X) += qat_c62x.o
-qat_c62x-objs := adf_drv.o adf_c62x_hw_data.o
+qat_c62x-y := adf_drv.o adf_c62x_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/Makefile b/drivers/crypto/intel/qat/qat_c62xvf/Makefile
index 256786662d60..60e499b041ec 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/Makefile
+++ b/drivers/crypto/intel/qat/qat_c62xvf/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C62XVF) += qat_c62xvf.o
-qat_c62xvf-objs := adf_drv.o adf_c62xvf_hw_data.o
+qat_c62xvf-y := adf_drv.o adf_c62xvf_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 7acf9c576149..c515cc1e986a 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_QAT"'
-intel_qat-objs := adf_cfg.o \
+intel_qat-y := adf_cfg.o \
 	adf_isr.o \
 	adf_ctl_drv.o \
 	adf_cfg_services.o \
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/Makefile b/drivers/crypto/intel/qat/qat_dh895xcc/Makefile
index cfd3bd757715..5bf5c890c362 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/Makefile
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc.o
-qat_dh895xcc-objs := adf_drv.o adf_dh895xcc_hw_data.o
+qat_dh895xcc-y := adf_drv.o adf_dh895xcc_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile b/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile
index 64b54e92b2b4..93f9c81edf09 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf.o
-qat_dh895xccvf-objs := adf_drv.o adf_dh895xccvf_hw_data.o
+qat_dh895xccvf-y := adf_drv.o adf_dh895xccvf_hw_data.o
-- 
2.48.1

