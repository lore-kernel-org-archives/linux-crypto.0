Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF2B26E6E4
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 09:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363263; cv=none; b=mlG//G5Qkcict7C3qi/bJ/Tb9ogvQOkB9nJWBuEXLTCRdyXMOfgHqxwFTH0LjZd7LcvAySg5YGDA6U6hPymVw9RkMbODAdO//C7QN0Z9Y2ve+YieRPB2fz0Hj3ZBqywJ1gXKeLlO0Any3ywwqcvFbXBgJY5ZKq4Wyg87RCd8I9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363263; c=relaxed/simple;
	bh=mIdQirRWSgus96+gqXoMz/ZA95ZnCwIa2qwgdFRMaIE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CYRQnjZ61h4KDTjFZRSlyuKYwPVPN711iKVOVd6j8co/2o7eU7gtha5NxRTtBZcFwYL6Y7wQRfIHALUGMenVAtCBCqU2gtUfjDc9OxfeIo1UY3FdyF59CW715sWErTwWspxArp3VjPEV/mHyG/+jZj6o6ApOvhqYEP+LFL57UgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCCO5gWh; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCCO5gWh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751363263; x=1782899263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mIdQirRWSgus96+gqXoMz/ZA95ZnCwIa2qwgdFRMaIE=;
  b=gCCO5gWhV30d/vY1K2mg9/a8rqjnv1wouWOlljxILlQrFqUO0y1WwmN7
   SxUIuh7ECd6j5e1biWBf2LZ28jx0JOUJCGsfOfw9iXlVIvZPek94NTGC3
   alJcahW6tAhOWj8qpZqp9FjSIKQFmuq1lVJG0+Rl3TRuwY9k96h3Ofkv5
   EIXgj2NQTzTIyHnhgRKk2430/gzJb6ERJ2MMdIDO50oieY8bpeORplYX6
   F4p6sqww6WAoi1eYmyH+jmCBR3yUxV6g0p/CKoHtQDwrdIRX9FX9clt5q
   +/9WBqR70NJw/AdfHAmGETxkPmhO1MbfrtoR/7IEp1495AHi2YmoqalQc
   A==;
X-CSE-ConnectionGUID: kT/Ft7udRBGFKuGkTtjFxA==
X-CSE-MsgGUID: gVGz1AoiR9mgtiKjfLk+nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53483474"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53483474"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:47:42 -0700
X-CSE-ConnectionGUID: DDzRIhuETrmyxt7LbC5kLQ==
X-CSE-MsgGUID: YmhHwUwGSAOyCMdqBxEfew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154030078"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa009.fm.intel.com with ESMTP; 01 Jul 2025 02:47:40 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 4/5] crypto: qat - relocate and rename bank state structure definition
Date: Tue,  1 Jul 2025 10:47:29 +0100
Message-Id: <20250701094730.227991-5-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
References: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `bank_state` structure represents the state of a bank of rings.
As part of recent refactoring, the functions that interact with this
structure have been moved to a new unit, adf_bank_state.c.

To align with this reorganization, rename `struct bank_state` to
`struct adf_bank_state` and move its definition to adf_bank_state.h.
Also relocate the associated `struct ring_config` to the same header
to consolidate related definitions.

Update all references to use the new structure name.

This does not introduce any functional change.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  | 38 ++----------------
 .../intel/qat/qat_common/adf_bank_state.c     |  8 ++--
 .../intel/qat/qat_common/adf_bank_state.h     | 39 +++++++++++++++++--
 .../intel/qat/qat_common/adf_gen4_vf_mig.c    |  7 ++--
 4 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 2ee526063213..f76e0f6c66ae 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -157,39 +157,7 @@ struct admin_info {
 	u32 mailbox_offset;
 };
 
-struct ring_config {
-	u64 base;
-	u32 config;
-	u32 head;
-	u32 tail;
-	u32 reserved0;
-};
-
-struct bank_state {
-	u32 ringstat0;
-	u32 ringstat1;
-	u32 ringuostat;
-	u32 ringestat;
-	u32 ringnestat;
-	u32 ringnfstat;
-	u32 ringfstat;
-	u32 ringcstat0;
-	u32 ringcstat1;
-	u32 ringcstat2;
-	u32 ringcstat3;
-	u32 iaintflagen;
-	u32 iaintflagreg;
-	u32 iaintflagsrcsel0;
-	u32 iaintflagsrcsel1;
-	u32 iaintcolen;
-	u32 iaintcolctl;
-	u32 iaintflagandcolen;
-	u32 ringexpstat;
-	u32 ringexpintenable;
-	u32 ringsrvarben;
-	u32 reserved0;
-	struct ring_config rings[ADF_ETR_MAX_RINGS_PER_BANK];
-};
+struct adf_bank_state;
 
 struct adf_hw_csr_ops {
 	u64 (*build_csr_ring_base_addr)(dma_addr_t addr, u32 size);
@@ -338,9 +306,9 @@ struct adf_hw_device_data {
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
 	int (*ring_pair_reset)(struct adf_accel_dev *accel_dev, u32 bank_nr);
 	int (*bank_state_save)(struct adf_accel_dev *accel_dev, u32 bank_number,
-			       struct bank_state *state);
+			       struct adf_bank_state *state);
 	int (*bank_state_restore)(struct adf_accel_dev *accel_dev,
-				  u32 bank_number, struct bank_state *state);
+				  u32 bank_number, struct adf_bank_state *state);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	const char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_bank_state.c b/drivers/crypto/intel/qat/qat_common/adf_bank_state.c
index 2a0bbee8a288..225d55d56a4b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_bank_state.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_bank_state.c
@@ -30,7 +30,7 @@ static inline int check_stat(u32 (*op)(void __iomem *, u32), u32 expect_val,
 }
 
 static void bank_state_save(struct adf_hw_csr_ops *ops, void __iomem *base,
-			    u32 bank, struct bank_state *state, u32 num_rings)
+			    u32 bank, struct adf_bank_state *state, u32 num_rings)
 {
 	u32 i;
 
@@ -60,7 +60,7 @@ static void bank_state_save(struct adf_hw_csr_ops *ops, void __iomem *base,
 }
 
 static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
-			      u32 bank, struct bank_state *state, u32 num_rings,
+			      u32 bank, struct adf_bank_state *state, u32 num_rings,
 			      int tx_rx_gap)
 {
 	u32 val, tmp_val, i;
@@ -185,7 +185,7 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
  * Returns 0 on success, error code otherwise
  */
 int adf_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
-			struct bank_state *state)
+			struct adf_bank_state *state)
 {
 	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
@@ -215,7 +215,7 @@ EXPORT_SYMBOL_GPL(adf_bank_state_save);
  * Returns 0 on success, error code otherwise
  */
 int adf_bank_state_restore(struct adf_accel_dev *accel_dev, u32 bank_number,
-			   struct bank_state *state)
+			   struct adf_bank_state *state)
 {
 	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_bank_state.h b/drivers/crypto/intel/qat/qat_common/adf_bank_state.h
index 85b15ed161f4..48b573d692dd 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_bank_state.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_bank_state.h
@@ -6,11 +6,44 @@
 #include <linux/types.h>
 
 struct adf_accel_dev;
-struct bank_state;
+
+struct ring_config {
+	u64 base;
+	u32 config;
+	u32 head;
+	u32 tail;
+	u32 reserved0;
+};
+
+struct adf_bank_state {
+	u32 ringstat0;
+	u32 ringstat1;
+	u32 ringuostat;
+	u32 ringestat;
+	u32 ringnestat;
+	u32 ringnfstat;
+	u32 ringfstat;
+	u32 ringcstat0;
+	u32 ringcstat1;
+	u32 ringcstat2;
+	u32 ringcstat3;
+	u32 iaintflagen;
+	u32 iaintflagreg;
+	u32 iaintflagsrcsel0;
+	u32 iaintflagsrcsel1;
+	u32 iaintcolen;
+	u32 iaintcolctl;
+	u32 iaintflagandcolen;
+	u32 ringexpstat;
+	u32 ringexpintenable;
+	u32 ringsrvarben;
+	u32 reserved0;
+	struct ring_config rings[ADF_ETR_MAX_RINGS_PER_BANK];
+};
 
 int adf_bank_state_restore(struct adf_accel_dev *accel_dev, u32 bank_number,
-			   struct bank_state *state);
+			   struct adf_bank_state *state);
 int adf_bank_state_save(struct adf_accel_dev *accel_dev, u32 bank_number,
-			struct bank_state *state);
+			struct adf_bank_state *state);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
index a62eb5e8dbe6..adb21656a3ba 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
@@ -9,6 +9,7 @@
 #include <asm/errno.h>
 
 #include "adf_accel_devices.h"
+#include "adf_bank_state.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_hw_data.h"
 #include "adf_gen4_pfvf.h"
@@ -358,7 +359,7 @@ static int adf_gen4_vfmig_load_etr_regs(struct adf_mstate_mgr *sub_mgr,
 
 	pf_bank_nr = vf_bank_info->bank_nr + vf_bank_info->vf_nr * hw_data->num_banks_per_vf;
 	ret = hw_data->bank_state_restore(accel_dev, pf_bank_nr,
-					  (struct bank_state *)state);
+					  (struct adf_bank_state *)state);
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to load regs for vf%d bank%d\n",
@@ -585,7 +586,7 @@ static int adf_gen4_vfmig_save_etr_regs(struct adf_mstate_mgr *subs, u8 *state,
 	pf_bank_nr += vf_bank_info->vf_nr * hw_data->num_banks_per_vf;
 
 	ret = hw_data->bank_state_save(accel_dev, pf_bank_nr,
-				       (struct bank_state *)state);
+				       (struct adf_bank_state *)state);
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to save regs for vf%d bank%d\n",
@@ -593,7 +594,7 @@ static int adf_gen4_vfmig_save_etr_regs(struct adf_mstate_mgr *subs, u8 *state,
 		return ret;
 	}
 
-	return sizeof(struct bank_state);
+	return sizeof(struct adf_bank_state);
 }
 
 static int adf_gen4_vfmig_save_etr_bank(struct adf_accel_dev *accel_dev,
-- 
2.40.1

