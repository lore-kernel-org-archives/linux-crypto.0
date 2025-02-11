Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3871E8835
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 10:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739268012; cv=none; b=BU6UqiVEQVpziaKzhZRAKPD8fPZ6yMms3hslMnEs/9aJKe+IowSdNwMazx6Bi0Gg5imWd8R1xCXwX9cgAd/DmijaVQSYGPs9OEWkx0V/Y1+P7SYloOAeWc+rxOjbtUM52g0JRNm/YSyarrYSiuSzepefVCaqkn1xET2EuAU3MRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739268012; c=relaxed/simple;
	bh=UrX4fAAXuaYWVJ+TWG7YU31ZhRrq5hNw3Bj6jhKR52g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8LG54KKAnuDIuqCSXoDgMRZzPjv8501kHXVYAHETpAz6tyF1FhQBMD5jTSsjNybmoDfSOSxVIS7CW/uBhczJHJ8QEhWjZf9pL+ZlBCMwPruNz5n3AIukXathAEOPox6pHH9KOp1usGIQeU/fNDg+TTbZbb0oZjwXkqOb78OH5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7KcpXrQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7KcpXrQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739268010; x=1770804010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UrX4fAAXuaYWVJ+TWG7YU31ZhRrq5hNw3Bj6jhKR52g=;
  b=l7KcpXrQquvE4FWkkg7v1Hv9AI7MCV4CtolzjuaJqt9dyPGEW96JhoHl
   nkOqw3dtnOYXipbGt0/F2iSguYPXvmTcsMrGXpiaVp5clJGRo0Sak+Puh
   ZWfL/4qPvSPRRPdsVGongiPheR71WRCt7627m4s/QFT795ockEmKrffNC
   r74mo5qtDN4w4RkJFD9/z7P5qKRkreTgxMYiP93OJWEyLpDD/KZj5iNKU
   gJL3kcr78lI5fQm27Ju15AmycEdGMdxb12AVdiECT/V6AcdTFhS4WumLD
   TtxN83X2HbzZGEUa3vtwVqUVpjfWo0qirbrsux7CDb8tyDwPkcK2a77B/
   A==;
X-CSE-ConnectionGUID: JwZctBrtQOi+p/yvDOyqDA==
X-CSE-MsgGUID: Bdkc7ueFQpa48y1HOlWz/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="27477131"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="27477131"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 02:00:10 -0800
X-CSE-ConnectionGUID: f0SOTQlHT++L8PCDy0w7Ew==
X-CSE-MsgGUID: sDmD+dIkS0m9D22MM3zISQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112321342"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by orviesa010.jf.intel.com with ESMTP; 11 Feb 2025 02:00:08 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] crypto: qat - reorder objects in qat_common Makefile
Date: Tue, 11 Feb 2025 09:58:53 +0000
Message-ID: <20250211095952.14442-3-giovanni.cabiddu@intel.com>
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

The objects in the qat_common Makefile are currently listed in a random
order.

Reorder the objects alphabetically to make it easier to find where to
add a new object.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/Makefile | 66 ++++++++++----------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index c515cc1e986a..af5df29fd2e3 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -1,62 +1,62 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE='"CRYPTO_QAT"'
-intel_qat-y := adf_cfg.o \
-	adf_isr.o \
-	adf_ctl_drv.o \
+intel_qat-y := adf_accel_engine.o \
+	adf_admin.o \
+	adf_aer.o \
+	adf_cfg.o \
 	adf_cfg_services.o \
+	adf_clock.o \
+	adf_ctl_drv.o \
 	adf_dev_mgr.o \
-	adf_init.o \
-	adf_accel_engine.o \
-	adf_aer.o \
-	adf_transport.o \
-	adf_admin.o \
-	adf_hw_arbiter.o \
-	adf_sysfs.o \
-	adf_sysfs_ras_counters.o \
+	adf_gen2_config.o \
+	adf_gen2_dc.o \
 	adf_gen2_hw_csr_data.o \
 	adf_gen2_hw_data.o \
-	adf_gen2_config.o \
 	adf_gen4_config.o \
+	adf_gen4_dc.o \
 	adf_gen4_hw_csr_data.o \
 	adf_gen4_hw_data.o \
-	adf_gen4_vf_mig.o \
 	adf_gen4_pm.o \
-	adf_gen2_dc.o \
-	adf_gen4_dc.o \
 	adf_gen4_ras.o \
 	adf_gen4_timer.o \
-	adf_clock.o \
+	adf_gen4_vf_mig.o \
+	adf_hw_arbiter.o \
+	adf_init.o \
+	adf_isr.o \
 	adf_mstate_mgr.o \
-	qat_crypto.o \
-	qat_compression.o \
-	qat_comp_algs.o \
-	qat_algs.o \
-	qat_asym_algs.o \
-	qat_algs_send.o \
-	adf_rl.o \
 	adf_rl_admin.o \
+	adf_rl.o \
+	adf_sysfs.o \
+	adf_sysfs_ras_counters.o \
 	adf_sysfs_rl.o \
-	qat_uclo.o \
-	qat_hal.o \
+	adf_transport.o \
+	qat_algs.o \
+	qat_algs_send.o \
+	qat_asym_algs.o \
 	qat_bl.o \
-	qat_mig_dev.o
+	qat_comp_algs.o \
+	qat_compression.o \
+	qat_crypto.o \
+	qat_hal.o \
+	qat_mig_dev.o \
+	qat_uclo.o
 
-intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
+intel_qat-$(CONFIG_DEBUG_FS) += adf_cnv_dbgfs.o \
+				adf_dbgfs.o \
 				adf_fw_counters.o \
-				adf_cnv_dbgfs.o \
 				adf_gen4_pm_debugfs.o \
 				adf_gen4_tl.o \
-				adf_heartbeat.o \
 				adf_heartbeat_dbgfs.o \
+				adf_heartbeat.o \
 				adf_pm_dbgfs.o \
 				adf_telemetry.o \
 				adf_tl_debugfs.o \
-				adf_dbgfs.o
+				adf_transport_debug.o
 
-intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
+intel_qat-$(CONFIG_PCI_IOV) += adf_gen2_pfvf.o adf_gen4_pfvf.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
-			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
-			       adf_gen2_pfvf.o adf_gen4_pfvf.o
+			       adf_pfvf_utils.o adf_pfvf_vf_msg.o \
+			       adf_pfvf_vf_proto.o adf_sriov.o adf_vf_isr.o
 
 intel_qat-$(CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION) += adf_heartbeat_inject.o
-- 
2.48.1

