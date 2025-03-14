Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB708F54
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 13:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957786; cv=none; b=UuQqCEB10g1gPMwcrmsRK3kfs4nOJqf1/WSrBGbuWfYup4Vx2p7L4pFl+X5cejmzzqGR41IaDHtiYGb7extPzfwAloAy+bO/QXOqTgyxNqTlIJYOq+q+igzittp3ZlA0ED9LaKDfj3XpvxrhQVvE1mmGp9HHH+ulnuc0MFn7e4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957786; c=relaxed/simple;
	bh=gikrJBqRA3UADoGczVWjsY3dCBSt+S05UKW6dGseWjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO6qA3X9Bkv9ih1tuf4HD/DEC2WGqNa4pCLpMTj66gtGtudzr2BqmjXb6uvhUGcKLviyA/ugnOHx3PsAH0WUwlPiu5KeX0KMrw6tGLiIFf1HLiWu9Jpm6+Z3yWmsLyPfnwCw/RKZf2FHyXuvM09smGM0lejOu7DIema06+feEag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uv06PaZj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uv06PaZj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741957785; x=1773493785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gikrJBqRA3UADoGczVWjsY3dCBSt+S05UKW6dGseWjo=;
  b=Uv06PaZjh4Pk0cUDkQS4uG1tKReKFCqDlA0DaJ8UgiLg9IuRlqt9Dolk
   SGuS+Pkq3lPfXKk+yoAepNrK1XUqQoVBEboSfQaP8/P3WC/Dd5PLcAhAa
   RNRknHngruJT5Pj67wE5LxSVy03IF5ku7+7Cjhpnear2OXBfpbOdmrle7
   +hZnlW+gRpa+BtUKFAABB/aho70R5VBSg38Iddf+0ladJNgkiE89bLByW
   6kKePoWf0NVtb/3swVjsnBjRO4PHJ1D3ic6644GlcRLeKOQ0wLMaMS6Cy
   TRdGh1JCeHwk9yRfAkc9Lf6Wtppx84pMa9gl0qsmjTRQ413eENj7zrtBY
   A==;
X-CSE-ConnectionGUID: yC7ZiJ01TP2xpCNOUuWy5Q==
X-CSE-MsgGUID: EFQv3rf1Qi6fedMZseYOlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="53762333"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="53762333"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 06:09:45 -0700
X-CSE-ConnectionGUID: TF4CRcoaSpiK5KQVXLFBYQ==
X-CSE-MsgGUID: EKz3JfqsROylvZ/x89omdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121072111"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa006.fm.intel.com with ESMTP; 14 Mar 2025 06:09:43 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Jack Xu <jack.xu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/3] crypto: qat - optimize allocations for fw authentication
Date: Fri, 14 Mar 2025 12:57:54 +0000
Message-ID: <20250314130918.11877-5-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314130918.11877-2-giovanni.cabiddu@intel.com>
References: <20250314130918.11877-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Jack Xu <jack.xu@intel.com>

The memory requested to hold the image data for authentication will
never exceed `ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN`. Therefore, we can
simplify the allocation by always requesting the maximum size needed for
any image.

Also introduce the following checks:
 * Ensure the allocated memory is 8-byte aligned to meet the
   requirements of the authentication firmware.
 * Prevent overflow when constructing the authentication descriptor.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/icp_qat_uclo.h       |  8 ------
 .../crypto/intel/qat/qat_common/qat_uclo.c    | 25 ++++++++++++++-----
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
index 4b5e7dcd11d1..1c7bcd8e4055 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
@@ -43,7 +43,6 @@
 #define ICP_QAT_SUOF_OBJS "SUF_OBJS"
 #define ICP_QAT_SUOF_IMAG "SUF_IMAG"
 #define ICP_QAT_SIMG_AE_INIT_SEQ_LEN    (50 * sizeof(unsigned long long))
-#define ICP_QAT_SIMG_AE_INSTS_LEN       (0x4000 * sizeof(unsigned long long))
 
 #define DSS_FWSK_MODULUS_LEN    384 /* RSA3K */
 #define DSS_FWSK_EXPONENT_LEN   4
@@ -75,13 +74,6 @@
 						DSS_SIGNATURE_LEN : \
 						CSS_SIGNATURE_LEN)
 
-#define ICP_QAT_CSS_AE_IMG_LEN     (sizeof(struct icp_qat_simg_ae_mode) + \
-				    ICP_QAT_SIMG_AE_INIT_SEQ_LEN +         \
-				    ICP_QAT_SIMG_AE_INSTS_LEN)
-#define ICP_QAT_CSS_AE_SIMG_LEN(handle) (sizeof(struct icp_qat_css_hdr) + \
-					ICP_QAT_CSS_FWSK_PUB_LEN(handle) + \
-					ICP_QAT_CSS_SIGNATURE_LEN(handle) + \
-					ICP_QAT_CSS_AE_IMG_LEN)
 #define ICP_QAT_AE_IMG_OFFSET(handle) (sizeof(struct icp_qat_css_hdr) + \
 					ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) + \
 					ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle) + \
diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 61be6df50684..7678a93c6853 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
+#include <linux/align.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
@@ -1414,16 +1415,21 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	struct icp_qat_fw_auth_desc *auth_desc;
 	struct icp_qat_auth_chunk *auth_chunk;
 	u64 virt_addr,  bus_addr, virt_base;
-	unsigned int length, simg_offset = sizeof(*auth_chunk);
+	unsigned int simg_offset = sizeof(*auth_chunk);
 	struct icp_qat_simg_ae_mode *simg_ae_mode;
 	struct icp_firml_dram_desc img_desc;
+	int ret;
 
-	length = (css_hdr->fw_type == CSS_AE_FIRMWARE) ?
-		 ICP_QAT_CSS_AE_SIMG_LEN(handle) + simg_offset :
-		 size + ICP_QAT_CSS_FWSK_PAD_LEN(handle) + simg_offset;
-	if (qat_uclo_simg_alloc(handle, &img_desc, length)) {
+	ret = qat_uclo_simg_alloc(handle, &img_desc, ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN);
+	if (ret) {
 		pr_err("QAT: error, allocate continuous dram fail\n");
-		return -ENOMEM;
+		return ret;
+	}
+
+	if (!IS_ALIGNED(img_desc.dram_size, 8) || !img_desc.dram_bus_addr) {
+		pr_debug("QAT: invalid address\n");
+		qat_uclo_simg_free(handle, &img_desc);
+		return -EINVAL;
 	}
 
 	auth_chunk = img_desc.dram_base_addr_v;
@@ -1481,6 +1487,13 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	auth_desc->img_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
 	auth_desc->img_low = (unsigned int)bus_addr;
 	auth_desc->img_len = size - ICP_QAT_AE_IMG_OFFSET(handle);
+	if (bus_addr + auth_desc->img_len > img_desc.dram_bus_addr +
+					    ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN) {
+		pr_err("QAT: insufficient memory size for authentication data\n");
+		qat_uclo_simg_free(handle, &img_desc);
+		return -ENOMEM;
+	}
+
 	memcpy((void *)(uintptr_t)virt_addr,
 	       (void *)(image + ICP_QAT_AE_IMG_OFFSET(handle)),
 	       auth_desc->img_len);
-- 
2.48.1

