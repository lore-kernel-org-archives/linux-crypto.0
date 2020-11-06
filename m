Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C900C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E705B206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKFL3V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgKFL3V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:21 -0500
IronPort-SDR: 02rNWVXqGaPP4CAVhWQxal4jiXOdZ5YRriC8fBR56t8WXtvT147tv4WvTPZcymSEBV7Mlr6t9g
 Kcod5NF0ULSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698345"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698345"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:20 -0800
IronPort-SDR: ST7+LIjcTOepBvaeiTr7hJv7L6P9wzzYDTzVeYU9rzkv88D/aoDKPkzDbefZk9ueGvbd25UYtM
 mL3lgCaX44Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779384"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:18 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 27/32] crypto: qat - loader: add CSS3K support
Date:   Fri,  6 Nov 2020 19:28:05 +0800
Message-Id: <20201106112810.2566-28-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for CSS3K, which uses RSA3K as image signature algorithm,
to support the next generation of QAT devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  | 54 +++++++++++++------
 drivers/crypto/qat/qat_common/qat_hal.c       |  2 +
 drivers/crypto/qat/qat_common/qat_uclo.c      | 51 +++++++++---------
 4 files changed, 68 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 81dba42248bf..29710e88e8b8 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -33,6 +33,7 @@ struct icp_qat_fw_loader_chip_info {
 	u32 misc_ctl_csr;
 	u32 wakeup_event_val;
 	bool fw_auth;
+	bool css_3k;
 };
 
 struct icp_qat_fw_loader_handle {
diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index 5728a81d9dea..4315b4504c26 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -42,24 +42,48 @@
 #define ICP_QAT_SUOF_IMAG "SUF_IMAG"
 #define ICP_QAT_SIMG_AE_INIT_SEQ_LEN    (50 * sizeof(unsigned long long))
 #define ICP_QAT_SIMG_AE_INSTS_LEN       (0x4000 * sizeof(unsigned long long))
-#define ICP_QAT_CSS_FWSK_MODULUS_LEN    256
-#define ICP_QAT_CSS_FWSK_EXPONENT_LEN   4
-#define ICP_QAT_CSS_FWSK_PAD_LEN        252
-#define ICP_QAT_CSS_FWSK_PUB_LEN   (ICP_QAT_CSS_FWSK_MODULUS_LEN + \
-				    ICP_QAT_CSS_FWSK_EXPONENT_LEN + \
-				    ICP_QAT_CSS_FWSK_PAD_LEN)
-#define ICP_QAT_CSS_SIGNATURE_LEN   256
+
+#define DSS_FWSK_MODULUS_LEN    384 /* RSA3K */
+#define DSS_FWSK_EXPONENT_LEN   4
+#define DSS_FWSK_PADDING_LEN    380
+#define DSS_SIGNATURE_LEN       384 /* RSA3K */
+
+#define CSS_FWSK_MODULUS_LEN    256 /* RSA2K */
+#define CSS_FWSK_EXPONENT_LEN   4
+#define CSS_FWSK_PADDING_LEN    252
+#define CSS_SIGNATURE_LEN       256 /* RSA2K */
+
+#define ICP_QAT_CSS_FWSK_MODULUS_LEN(handle)	((handle)->chip_info->css_3k ? \
+						DSS_FWSK_MODULUS_LEN  : \
+						CSS_FWSK_MODULUS_LEN)
+
+#define ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle)	((handle)->chip_info->css_3k ? \
+						DSS_FWSK_EXPONENT_LEN : \
+						CSS_FWSK_EXPONENT_LEN)
+
+#define ICP_QAT_CSS_FWSK_PAD_LEN(handle)	((handle)->chip_info->css_3k ? \
+						DSS_FWSK_PADDING_LEN : \
+						CSS_FWSK_PADDING_LEN)
+
+#define ICP_QAT_CSS_FWSK_PUB_LEN(handle)	(ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) + \
+						ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle) + \
+						ICP_QAT_CSS_FWSK_PAD_LEN(handle))
+
+#define ICP_QAT_CSS_SIGNATURE_LEN(handle)	((handle)->chip_info->css_3k ? \
+						DSS_SIGNATURE_LEN : \
+						CSS_SIGNATURE_LEN)
+
 #define ICP_QAT_CSS_AE_IMG_LEN     (sizeof(struct icp_qat_simg_ae_mode) + \
 				    ICP_QAT_SIMG_AE_INIT_SEQ_LEN +         \
 				    ICP_QAT_SIMG_AE_INSTS_LEN)
-#define ICP_QAT_CSS_AE_SIMG_LEN    (sizeof(struct icp_qat_css_hdr) + \
-				    ICP_QAT_CSS_FWSK_PUB_LEN + \
-				    ICP_QAT_CSS_SIGNATURE_LEN + \
-				    ICP_QAT_CSS_AE_IMG_LEN)
-#define ICP_QAT_AE_IMG_OFFSET	   (sizeof(struct icp_qat_css_hdr) + \
-				    ICP_QAT_CSS_FWSK_MODULUS_LEN + \
-				    ICP_QAT_CSS_FWSK_EXPONENT_LEN + \
-				    ICP_QAT_CSS_SIGNATURE_LEN)
+#define ICP_QAT_CSS_AE_SIMG_LEN(handle) (sizeof(struct icp_qat_css_hdr) + \
+					ICP_QAT_CSS_FWSK_PUB_LEN(handle) + \
+					ICP_QAT_CSS_SIGNATURE_LEN(handle) + \
+					ICP_QAT_CSS_AE_IMG_LEN)
+#define ICP_QAT_AE_IMG_OFFSET(handle) (sizeof(struct icp_qat_css_hdr) + \
+					ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) + \
+					ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle) + \
+					ICP_QAT_CSS_SIGNATURE_LEN(handle))
 #define ICP_QAT_CSS_MAX_IMAGE_LEN   0x40000
 
 #define ICP_QAT_CTX_MODE(ae_mode) ((ae_mode) & 0xf)
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index eae1a5e0efeb..8470139bcfe8 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -706,6 +706,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->misc_ctl_csr = MISC_CONTROL;
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = true;
+		handle->chip_info->css_3k = false;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		handle->chip_info->sram_visible = true;
@@ -717,6 +718,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->misc_ctl_csr = MISC_CONTROL;
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = false;
+		handle->chip_info->css_3k = false;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 0b1cf0708e2e..933b6357971f 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1039,10 +1039,11 @@ static int qat_uclo_map_suof_file_hdr(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-static void qat_uclo_map_simg(struct icp_qat_suof_handle *suof_handle,
+static void qat_uclo_map_simg(struct icp_qat_fw_loader_handle *handle,
 			      struct icp_qat_suof_img_hdr *suof_img_hdr,
 			      struct icp_qat_suof_chunk_hdr *suof_chunk_hdr)
 {
+	struct icp_qat_suof_handle *suof_handle = handle->sobj_handle;
 	struct icp_qat_simg_ae_mode *ae_mode;
 	struct icp_qat_suof_objhdr *suof_objhdr;
 
@@ -1057,10 +1058,10 @@ static void qat_uclo_map_simg(struct icp_qat_suof_handle *suof_handle,
 	suof_img_hdr->css_key = (suof_img_hdr->css_header +
 				 sizeof(struct icp_qat_css_hdr));
 	suof_img_hdr->css_signature = suof_img_hdr->css_key +
-				      ICP_QAT_CSS_FWSK_MODULUS_LEN +
-				      ICP_QAT_CSS_FWSK_EXPONENT_LEN;
+				      ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
+				      ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle);
 	suof_img_hdr->css_simg = suof_img_hdr->css_signature +
-				 ICP_QAT_CSS_SIGNATURE_LEN;
+				 ICP_QAT_CSS_SIGNATURE_LEN(handle);
 
 	ae_mode = (struct icp_qat_simg_ae_mode *)(suof_img_hdr->css_simg);
 	suof_img_hdr->ae_mask = ae_mode->ae_mask;
@@ -1169,7 +1170,7 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 	}
 
 	for (i = 0; i < suof_handle->img_table.num_simgs; i++) {
-		qat_uclo_map_simg(handle->sobj_handle, &suof_img_hdr[i],
+		qat_uclo_map_simg(handle, &suof_img_hdr[i],
 				  &suof_chunk_hdr[1 + i]);
 		ret = qat_uclo_check_simg_compat(handle,
 						 &suof_img_hdr[i]);
@@ -1270,13 +1271,13 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	unsigned int length, simg_offset = sizeof(*auth_chunk);
 	struct icp_firml_dram_desc img_desc;
 
-	if (size > (ICP_QAT_AE_IMG_OFFSET + ICP_QAT_CSS_MAX_IMAGE_LEN)) {
+	if (size > (ICP_QAT_AE_IMG_OFFSET(handle) + ICP_QAT_CSS_MAX_IMAGE_LEN)) {
 		pr_err("QAT: error, input image size overflow %d\n", size);
 		return -EINVAL;
 	}
 	length = (css_hdr->fw_type == CSS_AE_FIRMWARE) ?
-		 ICP_QAT_CSS_AE_SIMG_LEN + simg_offset :
-		 size + ICP_QAT_CSS_FWSK_PAD_LEN + simg_offset;
+		 ICP_QAT_CSS_AE_SIMG_LEN(handle) + simg_offset :
+		 size + ICP_QAT_CSS_FWSK_PAD_LEN(handle) + simg_offset;
 	if (qat_uclo_simg_alloc(handle, &img_desc, length)) {
 		pr_err("QAT: error, allocate continuous dram fail\n");
 		return -ENOMEM;
@@ -1303,42 +1304,42 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 
 	memcpy((void *)(uintptr_t)virt_addr,
 	       (void *)(image + sizeof(*css_hdr)),
-	       ICP_QAT_CSS_FWSK_MODULUS_LEN);
+	       ICP_QAT_CSS_FWSK_MODULUS_LEN(handle));
 	/* padding */
-	memset((void *)(uintptr_t)(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN),
-	       0, ICP_QAT_CSS_FWSK_PAD_LEN);
+	memset((void *)(uintptr_t)(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN(handle)),
+	       0, ICP_QAT_CSS_FWSK_PAD_LEN(handle));
 
 	/* exponent */
-	memcpy((void *)(uintptr_t)(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN +
-	       ICP_QAT_CSS_FWSK_PAD_LEN),
+	memcpy((void *)(uintptr_t)(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
+	       ICP_QAT_CSS_FWSK_PAD_LEN(handle)),
 	       (void *)(image + sizeof(*css_hdr) +
-			ICP_QAT_CSS_FWSK_MODULUS_LEN),
+			ICP_QAT_CSS_FWSK_MODULUS_LEN(handle)),
 	       sizeof(unsigned int));
 
 	/* signature */
 	bus_addr = ADD_ADDR(auth_desc->fwsk_pub_high,
 			    auth_desc->fwsk_pub_low) +
-		   ICP_QAT_CSS_FWSK_PUB_LEN;
-	virt_addr = virt_addr + ICP_QAT_CSS_FWSK_PUB_LEN;
+		   ICP_QAT_CSS_FWSK_PUB_LEN(handle);
+	virt_addr = virt_addr + ICP_QAT_CSS_FWSK_PUB_LEN(handle);
 	auth_desc->signature_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
 	auth_desc->signature_low = (unsigned int)bus_addr;
 
 	memcpy((void *)(uintptr_t)virt_addr,
 	       (void *)(image + sizeof(*css_hdr) +
-	       ICP_QAT_CSS_FWSK_MODULUS_LEN +
-	       ICP_QAT_CSS_FWSK_EXPONENT_LEN),
-	       ICP_QAT_CSS_SIGNATURE_LEN);
+	       ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
+	       ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle)),
+	       ICP_QAT_CSS_SIGNATURE_LEN(handle));
 
 	bus_addr = ADD_ADDR(auth_desc->signature_high,
 			    auth_desc->signature_low) +
-		   ICP_QAT_CSS_SIGNATURE_LEN;
-	virt_addr += ICP_QAT_CSS_SIGNATURE_LEN;
+		   ICP_QAT_CSS_SIGNATURE_LEN(handle);
+	virt_addr += ICP_QAT_CSS_SIGNATURE_LEN(handle);
 
 	auth_desc->img_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
 	auth_desc->img_low = (unsigned int)bus_addr;
-	auth_desc->img_len = size - ICP_QAT_AE_IMG_OFFSET;
+	auth_desc->img_len = size - ICP_QAT_AE_IMG_OFFSET(handle);
 	memcpy((void *)(uintptr_t)virt_addr,
-	       (void *)(image + ICP_QAT_AE_IMG_OFFSET),
+	       (void *)(image + ICP_QAT_AE_IMG_OFFSET(handle)),
 	       auth_desc->img_len);
 	virt_addr = virt_base;
 	/* AE firmware */
@@ -1377,8 +1378,8 @@ static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 	virt_addr = (void *)((uintptr_t)desc +
 		     sizeof(struct icp_qat_auth_chunk) +
 		     sizeof(struct icp_qat_css_hdr) +
-		     ICP_QAT_CSS_FWSK_PUB_LEN +
-		     ICP_QAT_CSS_SIGNATURE_LEN);
+		     ICP_QAT_CSS_FWSK_PUB_LEN(handle) +
+		     ICP_QAT_CSS_SIGNATURE_LEN(handle));
 	for_each_set_bit(i, &ae_mask, handle->hal_handle->ae_max_num) {
 		int retry = 0;
 
-- 
2.25.4

