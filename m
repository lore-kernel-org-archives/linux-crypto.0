Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BCE221281
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 09:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363265; cv=none; b=GRBpV6MAmDvOnNR/tFabq3JGEgm5LySFpc7dBTJa3jF4TILGcduy4FO4BKyyeEb2b82LMHCcYkHu8bHrKskzzj7QxKnDDR/I7c12woZRwvWuU94KVXARY4PPV4lnavxMqwDkS8X54WxM+2hnhlvrh1QhImaxO6YhBrp+7X5G4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363265; c=relaxed/simple;
	bh=egtT13QYwFyzDMwrRc2JRowXk2l0Z36ZxQ3kPWN7yaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6vs8yP5rarrdp1HqRrZvARfoN/LFq0D7x1sLOKalu70rsJeXST5XYS8XohAPR5OBBo6fkFX7xw0XZ2BfXU2azVZYQ4aXmZooOT5CdKNBr42nLyONP0SCdZ2yExIXcaKQbUlUNVwJWnNW2UtgEJ4LqPM8Taz5D60Z5cgm8VtwKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lXa4d87u; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lXa4d87u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751363264; x=1782899264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=egtT13QYwFyzDMwrRc2JRowXk2l0Z36ZxQ3kPWN7yaw=;
  b=lXa4d87u7ExCUaa4vaq+pCuJAJmqX6J+9B8f3mALbZpO7Fu35BpdZGGT
   Tty2/lY5Ca5veMqSx52HudrY4NSeXxjV8rPPRnFI/MFbhiBDjmaVLAg5H
   haGOxZJ6TmOUbfEdBwj/5CzCDxcCf7/vD5pOjFyba/MYJQKjgF3dhWuKI
   vbP2aiZZmWOvN8BS6cG+CNWbVnNksEIk7/47of9TvFGW/MnIf3LHqRQgF
   U3ZZ9cLfM1CkODoZgglgW6y8uKpDkQqHK+lrZP5cTvwtx5nlzadMTBiOW
   XU1T/kB1XADLQXTUhLq97OiQV4I9RbSpeIvVEwqacPkDHE6Pfx2/9HSuq
   Q==;
X-CSE-ConnectionGUID: udzCj3PWT4eec377GbNFHA==
X-CSE-MsgGUID: VkDUoV/GSxeMOuPY/zOO3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53483477"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53483477"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:47:44 -0700
X-CSE-ConnectionGUID: lAGeauKyQQWfYV8BChe8Nw==
X-CSE-MsgGUID: MaPKJ04UQEi60VXohrME4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154030093"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa009.fm.intel.com with ESMTP; 01 Jul 2025 02:47:42 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 5/5] crypto: qat - add live migration enablers for GEN6 devices
Date: Tue,  1 Jul 2025 10:47:30 +0100
Message-Id: <20250701094730.227991-6-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
References: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Małgorzata Mielnik <malgorzata.mielnik@intel.com>

The current implementation of the QAT live migration enablers is exclusive
to QAT GEN4 devices and resides within QAT GEN4 specific files. However,
the underlying mechanisms, such as the relevant CSRs and offsets,
can be shared between QAT GEN4 and QAT GEN6 devices.

Add the necessary enablers required to implement live migration for QAT
GEN6 devices to the abstraction layer to allow leveraging the existing
QAT GEN4 implementation.

Signed-off-by: Małgorzata Mielnik <malgorzata.mielnik@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c  | 4 ++++
 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c | 7 +++++++
 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 435d2ff38ab3..4d93d5a56ba3 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -10,6 +10,7 @@
 
 #include <adf_accel_devices.h>
 #include <adf_admin.h>
+#include <adf_bank_state.h>
 #include <adf_cfg.h>
 #include <adf_cfg_services.h>
 #include <adf_clock.h>
@@ -842,6 +843,8 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = ring_pair_reset;
 	hw_data->dev_config = dev_config;
+	hw_data->bank_state_save = adf_bank_state_save;
+	hw_data->bank_state_restore = adf_bank_state_restore;
 	hw_data->get_hb_clock = get_heartbeat_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->start_timer = adf_timer_start;
@@ -853,6 +856,7 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	adf_gen6_init_hw_csr_ops(&hw_data->csr_ops);
 	adf_gen6_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen6_init_dc_ops(&hw_data->dc_ops);
+	adf_gen6_init_vf_mig_ops(&hw_data->vfmig_ops);
 	adf_gen6_init_ras_ops(&hw_data->ras_ops);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
index 58a072e2f936..c9b151006dca 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
@@ -5,6 +5,7 @@
 #include "adf_gen4_config.h"
 #include "adf_gen4_hw_csr_data.h"
 #include "adf_gen4_pfvf.h"
+#include "adf_gen4_vf_mig.h"
 #include "adf_gen6_shared.h"
 
 struct adf_accel_dev;
@@ -47,3 +48,9 @@ int adf_gen6_no_dev_config(struct adf_accel_dev *accel_dev)
 	return adf_no_dev_config(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_gen6_no_dev_config);
+
+void adf_gen6_init_vf_mig_ops(struct qat_migdev_ops *vfmig_ops)
+{
+	adf_gen4_init_vf_mig_ops(vfmig_ops);
+}
+EXPORT_SYMBOL_GPL(adf_gen6_init_vf_mig_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
index bc8e71e984fc..fc6fad029a70 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
@@ -4,6 +4,7 @@
 #define ADF_GEN6_SHARED_H_
 
 struct adf_hw_csr_ops;
+struct qat_migdev_ops;
 struct adf_accel_dev;
 struct adf_pfvf_ops;
 
@@ -12,4 +13,5 @@ void adf_gen6_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 int adf_gen6_cfg_dev_init(struct adf_accel_dev *accel_dev);
 int adf_gen6_comp_dev_config(struct adf_accel_dev *accel_dev);
 int adf_gen6_no_dev_config(struct adf_accel_dev *accel_dev);
+void adf_gen6_init_vf_mig_ops(struct qat_migdev_ops *vfmig_ops);
 #endif/* ADF_GEN6_SHARED_H_ */
-- 
2.40.1

