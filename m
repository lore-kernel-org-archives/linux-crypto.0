Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B59225B665
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012921; cv=none; b=trOLNKeEejG7eJUPc3KvAgc62ChdXR70L02ZScAgeE9H9BcnDdwVb2ry9oMuj7fN95NpDauaSRJPisYaH/97w+hzme/bB6W85UMeJ/ox8bFVRPf22DOR8I3TXsy6dUdrJKmRhEJxUocAygYvBoyKV5XaOQt+wISE7Rs9GHbrmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012921; c=relaxed/simple;
	bh=17mAPsiBKbtl0RgTOIX9RXIqBH6nOcp4OdP7FDyDmQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ukui2O7NGnsH71CFMzkZL8AtEJgzKIBamu6oTcLzF8RUBEybkdp4aF6HlXDdV2WynpZMnVURmlXcpeRwQGRlbYdeX/uBAXNx0wV54JYvP3FemzgQMlk7FAFR3cb9gxYV2GNK28ctLqLshIhd51X+s89cCh8N9BmGwXY1e70VLYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nAmydsvj; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nAmydsvj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012919; x=1777548919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=17mAPsiBKbtl0RgTOIX9RXIqBH6nOcp4OdP7FDyDmQs=;
  b=nAmydsvjqikdrf5/0hkycb0a8ioT+9WnhCDkD2jeslFRxfiLGiRqTNvU
   d3TS5akX9GPOyaoLFAQ1Y/mLvABEbRSNaD0Q2WZfQjBvFKEppHFyHnD07
   DlQJI1uJ2eA3ZNRmOfkkB4jthqV9tw80DcWysrzANSsYufblhZ2PelOe0
   MznwwIavOPLFLvuXq2p9XYAI1JOZi8bnHf3HLpgIi0fmwa5WKvT+ZH5pX
   iq233f5AZeqdqFZlkHLdi0c+3wHZNYV9J8YroWZLqQyKh7NbwDoFFp4h0
   J08Xe+DpkB2azDfO4fxOy3wxoYe+u0UsVtyA1aRlVbYL5/kNJNBCWJzAh
   w==;
X-CSE-ConnectionGUID: 6bYeg3G9ThmtMIel+u5bGg==
X-CSE-MsgGUID: r5owAAbFQmC0nROYkN4KVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331162"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331162"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:19 -0700
X-CSE-ConnectionGUID: gi9UmMr1RjCO6aFupREO1w==
X-CSE-MsgGUID: IoXKwf0VRgiOtnxpvwyHVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812555"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:17 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 09/11] crypto: qat - update firmware api
Date: Wed, 30 Apr 2025 12:34:51 +0100
Message-Id: <20250430113453.1587497-10-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
References: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the firmware API to have partial decomp as an argument.
Modify the firmware descriptor to support auto-select best and partial
decompress.
Define the maximal auto-select best value.
Define the mask and bit position for the partial decompress field in the
firmware descriptor.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dc.c  |  3 ++-
 .../intel/qat/qat_common/icp_qat_fw_comp.h    | 23 ++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dc.c b/drivers/crypto/intel/qat/qat_common/adf_dc.c
index 4beb4b7dbf0e..3e8fb4e3ed97 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dc.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dc.c
@@ -46,7 +46,8 @@ int qat_comp_build_ctx(struct adf_accel_dev *accel_dev, void *ctx, enum adf_dc_a
 						      ICP_QAT_FW_COMP_NO_XXHASH_ACC,
 						      ICP_QAT_FW_COMP_CNV_ERROR_NONE,
 						      ICP_QAT_FW_COMP_NO_APPEND_CRC,
-						      ICP_QAT_FW_COMP_NO_DROP_DATA);
+						      ICP_QAT_FW_COMP_NO_DROP_DATA,
+						      ICP_QAT_FW_COMP_NO_PARTIAL_DECOMPRESS);
 	ICP_QAT_FW_COMN_NEXT_ID_SET(comp_cd_ctrl, ICP_QAT_FW_SLICE_DRAM_WR);
 	ICP_QAT_FW_COMN_CURR_ID_SET(comp_cd_ctrl, ICP_QAT_FW_SLICE_COMP);
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
index 04f645957e28..81969c515a17 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
@@ -44,6 +44,7 @@ enum icp_qat_fw_comp_20_cmd_id {
 #define ICP_QAT_FW_COMP_RET_DISABLE_TYPE0_HEADER_DATA_MASK 0x1
 #define ICP_QAT_FW_COMP_DISABLE_SECURE_RAM_AS_INTMD_BUF_BITPOS 7
 #define ICP_QAT_FW_COMP_DISABLE_SECURE_RAM_AS_INTMD_BUF_MASK 0x1
+#define ICP_QAT_FW_COMP_AUTO_SELECT_BEST_MAX_VALUE 0xFFFFFFFF
 
 #define ICP_QAT_FW_COMP_FLAGS_BUILD(sesstype, autoselect, enhanced_asb, \
 	ret_uncomp, secure_ram) \
@@ -117,7 +118,7 @@ struct icp_qat_fw_comp_req_params {
 #define ICP_QAT_FW_COMP_REQ_PARAM_FLAGS_BUILD(sop, eop, bfinal, cnv, cnvnr, \
 					      cnvdfx, crc, xxhash_acc, \
 					      cnv_error_type, append_crc, \
-					      drop_data) \
+					      drop_data, partial_decomp) \
 	((((sop) & ICP_QAT_FW_COMP_SOP_MASK) << \
 	ICP_QAT_FW_COMP_SOP_BITPOS) | \
 	(((eop) & ICP_QAT_FW_COMP_EOP_MASK) << \
@@ -139,7 +140,9 @@ struct icp_qat_fw_comp_req_params {
 	(((append_crc) & ICP_QAT_FW_COMP_APPEND_CRC_MASK) \
 	<< ICP_QAT_FW_COMP_APPEND_CRC_BITPOS) | \
 	(((drop_data) & ICP_QAT_FW_COMP_DROP_DATA_MASK) \
-	<< ICP_QAT_FW_COMP_DROP_DATA_BITPOS))
+	<< ICP_QAT_FW_COMP_DROP_DATA_BITPOS) | \
+	(((partial_decomp) & ICP_QAT_FW_COMP_PARTIAL_DECOMP_MASK) \
+	<< ICP_QAT_FW_COMP_PARTIAL_DECOMP_BITPOS))
 
 #define ICP_QAT_FW_COMP_NOT_SOP 0
 #define ICP_QAT_FW_COMP_SOP 1
@@ -161,6 +164,8 @@ struct icp_qat_fw_comp_req_params {
 #define ICP_QAT_FW_COMP_NO_APPEND_CRC 0
 #define ICP_QAT_FW_COMP_DROP_DATA 1
 #define ICP_QAT_FW_COMP_NO_DROP_DATA 0
+#define ICP_QAT_FW_COMP_PARTIAL_DECOMPRESS 1
+#define ICP_QAT_FW_COMP_NO_PARTIAL_DECOMPRESS 0
 #define ICP_QAT_FW_COMP_SOP_BITPOS 0
 #define ICP_QAT_FW_COMP_SOP_MASK 0x1
 #define ICP_QAT_FW_COMP_EOP_BITPOS 1
@@ -189,6 +194,8 @@ struct icp_qat_fw_comp_req_params {
 #define ICP_QAT_FW_COMP_APPEND_CRC_MASK 0x1
 #define ICP_QAT_FW_COMP_DROP_DATA_BITPOS 25
 #define ICP_QAT_FW_COMP_DROP_DATA_MASK 0x1
+#define ICP_QAT_FW_COMP_PARTIAL_DECOMP_BITPOS 27
+#define ICP_QAT_FW_COMP_PARTIAL_DECOMP_MASK 0x1
 
 #define ICP_QAT_FW_COMP_SOP_GET(flags) \
 	QAT_FIELD_GET(flags, ICP_QAT_FW_COMP_SOP_BITPOS, \
@@ -281,8 +288,18 @@ struct icp_qat_fw_comp_req {
 	union {
 		struct icp_qat_fw_xlt_req_params xlt_pars;
 		__u32 resrvd1[ICP_QAT_FW_NUM_LONGWORDS_2];
+		struct {
+			__u32 partial_decompress_length;
+			__u32 partial_decompress_offset;
+		} partial_decompress;
 	} u1;
-	__u32 resrvd2[ICP_QAT_FW_NUM_LONGWORDS_2];
+	union {
+		__u32 resrvd2[ICP_QAT_FW_NUM_LONGWORDS_2];
+		struct {
+			__u32 asb_value;
+			__u32 reserved;
+		} asb_threshold;
+	} u3;
 	struct icp_qat_fw_comp_cd_hdr comp_cd_ctrl;
 	union {
 		struct icp_qat_fw_xlt_cd_hdr xlt_cd_ctrl;
-- 
2.40.1

