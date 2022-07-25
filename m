Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCC2C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 10:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGYKku (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 06:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiGYKkt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 06:40:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC3060F4
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 03:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658745648; x=1690281648;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bMQTkSo4cdAgEh6YROgs0CilkrJrjDHl3/W1+HdpOZk=;
  b=drqY6A0eY8kow4jtP6RH9KyO8qOB3jv3EPWiiVqoYm71D7ZTowaUn8wW
   NskzY72XmLKExeylCwsZOqVijLcTR8Eufz8iD+SFqPZGtQnRgWYmSWP+3
   to6vwwIz0sMw/tTdZNbPmXh7ndD1q8mj3RtlplQOcRnaowXGvgt7q7wuS
   HVMxqo+E07DJ8fIrAJqSoj4WgC06Xi5YWCbV/HKyRQspWdOvLN0jvzHXW
   34nk7cnP0QUlaZjX+gQjv77ERBQizFgadiJwhwOP95ORUO8tIv0KNFzLw
   KcaFKoABxhaDOOik2PRYqgK6p5v4A//20cJ5EFCvCgPb+/KLxreepjtFq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="287679554"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="287679554"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 03:40:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="689016282"
Received: from 984fee006c34.jf.intel.com ([10.165.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Jul 2022 03:40:48 -0700
From:   Srinivas Kerekare <srinivas.kerekare@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Srinivas Kerekare <srinivas.kerekare@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH RESEND] crypto: qat - add check to validate firmware images
Date:   Mon, 25 Jul 2022 11:40:09 +0100
Message-Id: <20220725104009.76267-1-srinivas.kerekare@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function qat_uclo_check_image() validates the MMP and AE firmware
images. If the QAT device supports firmware authentication (indicated
by the handle to firmware loader), the input signed binary MMP and AE
images are validated by parsing the following information:
- Header length
- Full size of the binary
- Type of binary image (MMP or AE Firmware)

Firmware binaries use RSA3K for signing and verification.
The header length for the RSA3k is 0x384 bytes.

All the size field values in the binary are quantified
as DWORDS (1 DWORD = 4bytes).

On an invalid value the function prints an error message and returns
with an error code "EINVAL".

Signed-off-by: Srinivas Kerekare <srinivas.kerekare@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_uclo.h |  3 +-
 drivers/crypto/qat/qat_common/qat_uclo.c     | 56 +++++++++++++++++++-
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index 4b36869bf460..69482abdb8b9 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -86,7 +86,8 @@
 					ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) + \
 					ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle) + \
 					ICP_QAT_CSS_SIGNATURE_LEN(handle))
-#define ICP_QAT_CSS_MAX_IMAGE_LEN   0x40000
+#define ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN    0x40000
+#define ICP_QAT_CSS_RSA3K_MAX_IMAGE_LEN    0x30000
 
 #define ICP_QAT_CTX_MODE(ae_mode) ((ae_mode) & 0xf)
 #define ICP_QAT_NN_MODE(ae_mode) (((ae_mode) >> 0x4) & 0xf)
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 0fe5a474aa45..b7f7869ef8b2 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1367,6 +1367,48 @@ static void qat_uclo_ummap_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	}
 }
 
+static int qat_uclo_check_image(struct icp_qat_fw_loader_handle *handle,
+				char *image, unsigned int size,
+				unsigned int fw_type)
+{
+	char *fw_type_name = fw_type ? "MMP" : "AE";
+	unsigned int css_dword_size = sizeof(u32);
+
+	if (handle->chip_info->fw_auth) {
+		struct icp_qat_css_hdr *css_hdr = (struct icp_qat_css_hdr *)image;
+		unsigned int header_len = ICP_QAT_AE_IMG_OFFSET(handle);
+
+		if ((css_hdr->header_len * css_dword_size) != header_len)
+			goto err;
+		if ((css_hdr->size * css_dword_size) != size)
+			goto err;
+		if (fw_type != css_hdr->fw_type)
+			goto err;
+		if (size <= header_len)
+			goto err;
+		size -= header_len;
+	}
+
+	if (fw_type == CSS_AE_FIRMWARE) {
+		if (size < sizeof(struct icp_qat_simg_ae_mode *) +
+		    ICP_QAT_SIMG_AE_INIT_SEQ_LEN)
+			goto err;
+		if (size > ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN)
+			goto err;
+	} else if (fw_type == CSS_MMP_FIRMWARE) {
+		if (size > ICP_QAT_CSS_RSA3K_MAX_IMAGE_LEN)
+			goto err;
+	} else {
+		pr_err("QAT: Unsupported firmware type\n");
+		return -EINVAL;
+	}
+	return 0;
+
+err:
+	pr_err("QAT: Invalid %s firmware image\n", fw_type_name);
+	return -EINVAL;
+}
+
 static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 				char *image, unsigned int size,
 				struct icp_qat_fw_auth_desc **desc)
@@ -1379,7 +1421,7 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	struct icp_qat_simg_ae_mode *simg_ae_mode;
 	struct icp_firml_dram_desc img_desc;
 
-	if (size > (ICP_QAT_AE_IMG_OFFSET(handle) + ICP_QAT_CSS_MAX_IMAGE_LEN)) {
+	if (size > (ICP_QAT_AE_IMG_OFFSET(handle) + ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN)) {
 		pr_err("QAT: error, input image size overflow %d\n", size);
 		return -EINVAL;
 	}
@@ -1547,6 +1589,11 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 {
 	struct icp_qat_fw_auth_desc *desc = NULL;
 	int status = 0;
+	int ret;
+
+	ret = qat_uclo_check_image(handle, addr_ptr, mem_size, CSS_MMP_FIRMWARE);
+	if (ret)
+		return ret;
 
 	if (handle->chip_info->fw_auth) {
 		status = qat_uclo_map_auth_fw(handle, addr_ptr, mem_size, &desc);
@@ -2018,8 +2065,15 @@ static int qat_uclo_wr_suof_img(struct icp_qat_fw_loader_handle *handle)
 	struct icp_qat_fw_auth_desc *desc = NULL;
 	struct icp_qat_suof_handle *sobj_handle = handle->sobj_handle;
 	struct icp_qat_suof_img_hdr *simg_hdr = sobj_handle->img_table.simg_hdr;
+	int ret;
 
 	for (i = 0; i < sobj_handle->img_table.num_simgs; i++) {
+		ret = qat_uclo_check_image(handle, simg_hdr[i].simg_buf,
+					   simg_hdr[i].simg_len,
+					   CSS_AE_FIRMWARE);
+		if (ret)
+			return ret;
+
 		if (qat_uclo_map_auth_fw(handle,
 					 (char *)simg_hdr[i].simg_buf,
 					 (unsigned int)
-- 
2.36.1

