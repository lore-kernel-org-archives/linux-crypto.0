Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C7375F62
	for <linux-crypto@vger.kernel.org>; Thu,  1 Oct 2026 12:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790857708; cv=none; b=uVNudBkqBKyPz3i+47z0S/nM3+QobrX3SWdhhv0PGpA2E2u2zTYUvEuSFsfuNuwAqt/70ziVWJOvWlKFBn1mzYB87CnWa4Nggne40N75LRGhKpsi3HTOw9M0J3LWNA7qkCC8Y9GUxrerrVhmE/UcJWUWZpedAML2WarxGdLhgWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790857708; c=relaxed/simple;
	bh=mCAJQll2ndLW5e6HbTsTqseqxsNxUTgV8lSxa8qEXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dkBNzerXg73Z5HdKzSBqo3+kpU2CliH9ZgUCKjd0B9vXbxbxFBUldUNUr0LTpysJwaoLhkWBtBjI4JiTAExP1fEZlAIws8RPr2Ad9hI3hqQhrzJewnWzfIWKwK4kb3vUtei8SjvDdhvfypTO53kAy2VfpZOMz/GKDekngFthy9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IkolRAWq; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IkolRAWq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790857706; x=1822393706;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mCAJQll2ndLW5e6HbTsTqseqxsNxUTgV8lSxa8qEXr4=;
  b=IkolRAWqdP73bUD5bnpz+gcY8bdvkFC04VRT0D/v+iDz1PhqT4cUlFwr
   f5Het3zOBnyVYX3Jc5nTCqv6r/ip8Grgu0iz1htzMJ25GmYR4JLQdXGkb
   fhbR4ipDagP7YzE1W6Dk5mb+XN7tC92Kv9fbRKZNMjnxeAELnvF/KN73O
   9hqjvzsReChf4+XWsztlmca+QbOH3rwfzmhdEy41E9vGSwKR7voU6zy+d
   68u46e36XwEehbX6akbX/Mk1k/4J11xJAnwh0UOKc0YLhNKpJOyFXtrx9
   /mAoR7KsotnQZ+v0WCxgtRGPlJxa7V9RzOlJa++QF36PATakGflWyZat1
   w==;
X-CSE-ConnectionGUID: LXHRRsPzSaGMj0mjXng76w==
X-CSE-MsgGUID: azcDafM3RDO0NXxiEpIo0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="107993414"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="107993414"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 05:28:26 -0700
X-CSE-ConnectionGUID: VFkoqOEOR0S6vRVd06/Rkg==
X-CSE-MsgGUID: XEWQLgWJRjWJbZPXbfRTgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="272406859"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa009.fm.intel.com with ESMTP; 01 Oct 2026 05:28:24 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - remove unused get_num_accels()
Date: Thu,  1 Oct 2026 13:28:41 +0100
Message-ID: <20261001122841.2271248-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The get_num_accels() hook in struct adf_hw_device_data has had no
callers since commit d237230728c5 ("crypto: qat - remove unused
character device and IOCTLs"), which deleted its last user in
adf_ctl_drv.c. Every device driver still populates it and two
implementations are still exported, all of it dead code.

Remove the hook, its generation-level implementations
adf_gen2_get_num_accels() and adf_gen4_get_num_accels(), the
per-device static implementations and all the assignments.

The hw_data->num_accel field is left untouched as it is still used.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c   | 1 -
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 1 -
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 6 ------
 drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   | 1 -
 .../crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   | 6 ------
 drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c     | 1 -
 drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c | 6 ------
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h  | 1 -
 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c   | 9 ---------
 drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h   | 1 -
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c   | 6 ------
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h   | 1 -
 .../crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 1 -
 .../intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    | 6 ------
 14 files changed, 47 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 19f9f738630b..d6f1f626cf5a 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -443,7 +443,6 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->enable_error_correction = adf_gen4_enable_error_correction;
 	hw_data->get_accel_mask = adf_gen4_get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
-	hw_data->get_num_accels = adf_gen4_get_num_accels;
 	hw_data->get_num_aes = adf_gen4_get_num_aes;
 	hw_data->get_sram_bar_id = adf_gen4_get_sram_bar_id;
 	hw_data->get_etr_bar_id = adf_gen4_get_etr_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 49b425be34c8..7d9dd44ca477 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -412,7 +412,6 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->enable_error_correction = adf_gen4_enable_error_correction;
 	hw_data->get_accel_mask = adf_gen4_get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
-	hw_data->get_num_accels = adf_gen4_get_num_accels;
 	hw_data->get_num_aes = adf_gen4_get_num_aes;
 	hw_data->get_sram_bar_id = adf_gen4_get_sram_bar_id;
 	hw_data->get_etr_bar_id = adf_gen4_get_etr_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 388087e64540..ca9bc5dccf67 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -326,11 +326,6 @@ static u32 get_accel_mask(struct adf_hw_device_data *self)
 	return ADF_GEN6_ACCELERATORS_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	return ADF_GEN6_MAX_ACCELERATORS;
-}
-
 static u32 get_num_aes(struct adf_hw_device_data *self)
 {
 	return self ? hweight32(self->ae_mask) : 0;
@@ -1023,7 +1018,6 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
-	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 07f2c42a68f5..b9cc6c97778a 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -129,7 +129,6 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_accel_cap = adf_gen2_get_accel_cap;
-	hw_data->get_num_accels = adf_gen2_get_num_accels;
 	hw_data->get_num_aes = adf_gen2_get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index db3c33fa1881..8a5cce516436 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -24,11 +24,6 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ADF_C3XXXIOV_ACCELENGINES_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	return ADF_C3XXXIOV_MAX_ACCELERATORS;
-}
-
 static u32 get_num_aes(struct adf_hw_device_data *self)
 {
 	return ADF_C3XXXIOV_MAX_ACCELENGINES;
@@ -80,7 +75,6 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
-	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 0b410b41474d..aed1c951754a 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -131,7 +131,6 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_accel_cap = adf_gen2_get_accel_cap;
-	hw_data->get_num_accels = adf_gen2_get_num_accels;
 	hw_data->get_num_aes = adf_gen2_get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 7f00035d3661..ded32eaae48d 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -24,11 +24,6 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ADF_C62XIOV_ACCELENGINES_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	return ADF_C62XIOV_MAX_ACCELERATORS;
-}
-
 static u32 get_num_aes(struct adf_hw_device_data *self)
 {
 	return ADF_C62XIOV_MAX_ACCELENGINES;
@@ -80,7 +75,6 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
-	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index a84380125fe5..b77f461e8583 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -279,7 +279,6 @@ struct adf_hw_device_data {
 	u32 (*get_misc_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_etr_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_num_aes)(struct adf_hw_device_data *self);
-	u32 (*get_num_accels)(struct adf_hw_device_data *self);
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
index 6a505e9a5cf9..bff89c8538f0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.c
@@ -7,15 +7,6 @@
 #include "icp_qat_hw.h"
 #include <linux/pci.h>
 
-u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self)
-{
-	if (!self || !self->accel_mask)
-		return 0;
-
-	return hweight16(self->accel_mask);
-}
-EXPORT_SYMBOL_GPL(adf_gen2_get_num_accels);
-
 u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self)
 {
 	if (!self || !self->ae_mask)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
index 59bad368a921..3caeb1d178cf 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen2_hw_data.h
@@ -78,7 +78,6 @@
 #define ADF_GEN2_SMIAPF1_MASK_OFFSET    (0x3A000 + 0x30)
 #define ADF_GEN2_SMIA1_MASK             0x1
 
-u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self);
 u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self);
 void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev);
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index f4a58f04071a..d9a0ed7eee3d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -21,12 +21,6 @@ u32 adf_gen4_get_accel_mask(struct adf_hw_device_data *self)
 }
 EXPORT_SYMBOL_GPL(adf_gen4_get_accel_mask);
 
-u32 adf_gen4_get_num_accels(struct adf_hw_device_data *self)
-{
-	return ADF_GEN4_MAX_ACCELERATORS;
-}
-EXPORT_SYMBOL_GPL(adf_gen4_get_num_accels);
-
 u32 adf_gen4_get_num_aes(struct adf_hw_device_data *self)
 {
 	if (!self || !self->ae_mask)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index cd26b6724c43..46dfa23d825f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -157,7 +157,6 @@ void adf_gen4_get_arb_info(struct arb_info *arb_info);
 u32 adf_gen4_get_etr_bar_id(struct adf_hw_device_data *self);
 u32 adf_gen4_get_heartbeat_clock(struct adf_hw_device_data *self);
 u32 adf_gen4_get_misc_bar_id(struct adf_hw_device_data *self);
-u32 adf_gen4_get_num_accels(struct adf_hw_device_data *self);
 u32 adf_gen4_get_num_aes(struct adf_hw_device_data *self);
 enum dev_sku_info adf_gen4_get_sku(struct adf_hw_device_data *self);
 u32 adf_gen4_get_sram_bar_id(struct adf_hw_device_data *self);
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 5b4bd0ba1ccb..c318015fc2e2 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -229,7 +229,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_accel_cap = get_accel_cap;
-	hw_data->get_num_accels = adf_gen2_get_num_accels;
 	hw_data->get_num_aes = adf_gen2_get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 828456c43b76..6fd5bb333859 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -24,11 +24,6 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ADF_DH895XCCIOV_ACCELENGINES_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	return ADF_DH895XCCIOV_MAX_ACCELERATORS;
-}
-
 static u32 get_num_aes(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCCIOV_MAX_ACCELENGINES;
@@ -80,7 +75,6 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
-	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-- 
2.50.1

