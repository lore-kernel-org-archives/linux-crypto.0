Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF7825B1D2
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012914; cv=none; b=W4Mg2gSKPTzk/hiRqmveNFoIakOYEclgRTOigKL6ZxnPcSl6W48OSwLzgl/dgl4G8j8pKdaOR1LP5u13BsomO3a1H5ZXgdrSj++VXc51EA8cZ8tf8ounkVykglvEoo5O3S+kutDeQ1nDS3cYQYv+etN2sqvFmioM7qN++8iers4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012914; c=relaxed/simple;
	bh=6ndKKDy0odFX5NtVdYKV6Lab+zc5aNXaVMracC0hGM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H6K4iKKPqBY474fRLfUGH8EbnlYUFNhTP9XUeCzlY0VJRsJBrx0XNWsPof7oU05QZGS0k8Y1h2XH+dFy8F4gdeCyY7iJ67IehhV9VWkLaPVGnCJzdYLEaug2JkxK3dvD0/YC0YT8chGXEg6Rg/FK8YXBZfMu4hhZ7Ze/pV6OSCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RlQ/XxdI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RlQ/XxdI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012913; x=1777548913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ndKKDy0odFX5NtVdYKV6Lab+zc5aNXaVMracC0hGM4=;
  b=RlQ/XxdIW3caNod0D3GEcoJhH9GErmXnfhz9M65sT1FljNeuHVbrTFsM
   jUQ5AK2XDCyJLxFFdN56R9AwiLvZeVlf/hNojFVrSkM2Dw8aJYxn9auJl
   NGsJyo0HyvRsDTI3Mcc3/HtXhxTtBgoQPTpOxcrc5xblPhOofK7U2Az8o
   8JdGjBMyw4boEhY+OHGf6fcCWfRcV85XqwpY7ASvRrgqY5B45SIyRB/Dy
   xIQFXjBiPFCfJ7APIWuW1iABsfNEt1wSztnjKJ8H0S3vwcbd3oBfNQU1t
   yMd1jgIHv1RUC09Yp1WDxJLhW/xIH5VphIUMvWNNPbgrzwAeW4XDd+WV/
   w==;
X-CSE-ConnectionGUID: Kopseo8ZR+26PSR8GW7W4g==
X-CSE-MsgGUID: 2sgIERTCQOmSt7qUJ9oXhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331150"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331150"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:12 -0700
X-CSE-ConnectionGUID: QOfm1KweS1CW5Ta838kZuA==
X-CSE-MsgGUID: dq2cEDvBQNapL52IEXjO6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812536"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:10 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 05/11] crypto: qat - add GEN6 firmware loader
Date: Wed, 30 Apr 2025 12:34:47 +0100
Message-Id: <20250430113453.1587497-6-suman.kumar.chakraborty@intel.com>
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

From: Jack Xu <jack.xu@intel.com>

Add support for the QAT GEN6 devices in the firmware loader.
This includes handling firmware images signed with the RSA 3K and the
XMSS algorithms.

Co-developed-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Jack Xu <jack.xu@intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
 .../qat/qat_common/icp_qat_fw_loader_handle.h |   1 +
 .../intel/qat/qat_common/icp_qat_uclo.h       |  23 +++
 drivers/crypto/intel/qat/qat_common/qat_hal.c |   3 +
 .../crypto/intel/qat/qat_common/qat_uclo.c    | 154 +++++++++++++++++-
 5 files changed, 176 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index a39f506322f6..ed8b85360573 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -34,6 +34,8 @@
 #define PCI_DEVICE_ID_INTEL_QAT_402XXIOV 0x4945
 #define PCI_DEVICE_ID_INTEL_QAT_420XX 0x4946
 #define PCI_DEVICE_ID_INTEL_QAT_420XXIOV 0x4947
+#define PCI_DEVICE_ID_INTEL_QAT_6XXX 0x4948
+
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_DEVICE_FUSECTL_MASK 0x80000000
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
index 7eb5daef4f88..6887930c7995 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -35,6 +35,7 @@ struct icp_qat_fw_loader_chip_info {
 	u32 wakeup_event_val;
 	bool fw_auth;
 	bool css_3k;
+	bool dual_sign;
 	bool tgroup_share_ustore;
 	u32 fcu_ctl_csr;
 	u32 fcu_sts_csr;
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
index 1c7bcd8e4055..6313c35eff0c 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
@@ -7,6 +7,7 @@
 #define ICP_QAT_AC_C62X_DEV_TYPE   0x01000000
 #define ICP_QAT_AC_C3XXX_DEV_TYPE  0x02000000
 #define ICP_QAT_AC_4XXX_A_DEV_TYPE 0x08000000
+#define ICP_QAT_AC_6XXX_DEV_TYPE   0x80000000
 #define ICP_QAT_UCLO_MAX_AE       17
 #define ICP_QAT_UCLO_MAX_CTX      8
 #define ICP_QAT_UCLO_MAX_UIMAGE   (ICP_QAT_UCLO_MAX_AE * ICP_QAT_UCLO_MAX_CTX)
@@ -81,6 +82,21 @@
 #define ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN    0x40000
 #define ICP_QAT_CSS_RSA3K_MAX_IMAGE_LEN    0x30000
 
+/* All lengths below are in bytes */
+#define ICP_QAT_DUALSIGN_OPAQUE_HDR_LEN		12
+#define ICP_QAT_DUALSIGN_OPAQUE_HDR_ALIGN_LEN	16
+#define ICP_QAT_DUALSIGN_OPAQUE_DATA_LEN	3540
+#define ICP_QAT_DUALSIGN_XMSS_PUBKEY_LEN	64
+#define ICP_QAT_DUALSIGN_XMSS_SIG_LEN		2692
+#define ICP_QAT_DUALSIGN_XMSS_SIG_ALIGN_LEN	2696
+#define ICP_QAT_DUALSIGN_MISC_INFO_LEN		16
+#define ICP_QAT_DUALSIGN_FW_TYPE_LEN		7
+#define ICP_QAT_DUALSIGN_MODULE_TYPE		0x14
+#define ICP_QAT_DUALSIGN_HDR_LEN		0x375
+#define ICP_QAT_DUALSIGN_HDR_VER		0x40001
+#define ICP_QAT_DUALSIGN_HDR_LEN_OFFSET		4
+#define ICP_QAT_DUALSIGN_HDR_VER_OFFSET		8
+
 #define ICP_QAT_CTX_MODE(ae_mode) ((ae_mode) & 0xf)
 #define ICP_QAT_NN_MODE(ae_mode) (((ae_mode) >> 0x4) & 0xf)
 #define ICP_QAT_SHARED_USTORE_MODE(ae_mode) (((ae_mode) >> 0xb) & 0x1)
@@ -440,6 +456,13 @@ struct icp_qat_fw_auth_desc {
 	unsigned int   img_ae_init_data_low;
 	unsigned int   img_ae_insts_high;
 	unsigned int   img_ae_insts_low;
+	unsigned int   cpp_mask;
+	unsigned int   reserved;
+	unsigned int   xmss_pubkey_high;
+	unsigned int   xmss_pubkey_low;
+	unsigned int   xmss_sig_high;
+	unsigned int   xmss_sig_low;
+	unsigned int   reserved2[2];
 };
 
 struct icp_qat_auth_chunk {
diff --git a/drivers/crypto/intel/qat/qat_common/qat_hal.c b/drivers/crypto/intel/qat/qat_common/qat_hal.c
index 841c1d7d3ffe..da4eca6e1633 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -698,6 +698,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	case PCI_DEVICE_ID_INTEL_QAT_401XX:
 	case PCI_DEVICE_ID_INTEL_QAT_402XX:
 	case PCI_DEVICE_ID_INTEL_QAT_420XX:
+	case PCI_DEVICE_ID_INTEL_QAT_6XXX:
 		handle->chip_info->mmp_sram_size = 0;
 		handle->chip_info->nn = false;
 		handle->chip_info->lm2lm3 = true;
@@ -712,6 +713,8 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->wakeup_event_val = 0x80000000;
 		handle->chip_info->fw_auth = true;
 		handle->chip_info->css_3k = true;
+		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_6XXX)
+			handle->chip_info->dual_sign = true;
 		handle->chip_info->tgroup_share_ustore = true;
 		handle->chip_info->fcu_ctl_csr = FCU_CONTROL_4XXX;
 		handle->chip_info->fcu_sts_csr = FCU_STATUS_4XXX;
diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index d7f2ceb81f1f..21d652a1c8ef 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/pci_ids.h>
+#include <linux/wordpart.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "icp_qat_uclo.h"
@@ -737,6 +738,8 @@ qat_uclo_get_dev_type(struct icp_qat_fw_loader_handle *handle)
 	case PCI_DEVICE_ID_INTEL_QAT_402XX:
 	case PCI_DEVICE_ID_INTEL_QAT_420XX:
 		return ICP_QAT_AC_4XXX_A_DEV_TYPE;
+	case PCI_DEVICE_ID_INTEL_QAT_6XXX:
+		return ICP_QAT_AC_6XXX_DEV_TYPE;
 	default:
 		pr_err("unsupported device 0x%x\n", handle->pci_dev->device);
 		return 0;
@@ -1035,17 +1038,30 @@ static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
 
 static unsigned int qat_uclo_simg_hdr2sign_len(struct icp_qat_fw_loader_handle *handle)
 {
+	if (handle->chip_info->dual_sign)
+		return ICP_QAT_DUALSIGN_OPAQUE_DATA_LEN;
+
 	return ICP_QAT_AE_IMG_OFFSET(handle);
 }
 
 static unsigned int qat_uclo_simg_hdr2cont_len(struct icp_qat_fw_loader_handle *handle)
 {
+	if (handle->chip_info->dual_sign)
+		return ICP_QAT_DUALSIGN_OPAQUE_DATA_LEN + ICP_QAT_DUALSIGN_MISC_INFO_LEN;
+
 	return ICP_QAT_AE_IMG_OFFSET(handle);
 }
 
 static unsigned int qat_uclo_simg_fw_type(struct icp_qat_fw_loader_handle *handle, void *img_ptr)
 {
 	struct icp_qat_css_hdr *hdr = img_ptr;
+	char *fw_hdr = img_ptr;
+	unsigned int offset;
+
+	if (handle->chip_info->dual_sign) {
+		offset = qat_uclo_simg_hdr2sign_len(handle) + ICP_QAT_DUALSIGN_FW_TYPE_LEN;
+		return *(fw_hdr + offset);
+	}
 
 	return hdr->fw_type;
 }
@@ -1390,16 +1406,27 @@ static int qat_uclo_check_image(struct icp_qat_fw_loader_handle *handle,
 	if (handle->chip_info->fw_auth) {
 		header_len = qat_uclo_simg_hdr2sign_len(handle);
 		simg_type = qat_uclo_simg_fw_type(handle, image);
-
 		css_hdr = image;
-		if ((css_hdr->header_len * css_dword_size) != header_len)
-			goto err;
-		if ((css_hdr->size * css_dword_size) != size)
-			goto err;
+
+		if (handle->chip_info->dual_sign) {
+			if (css_hdr->module_type != ICP_QAT_DUALSIGN_MODULE_TYPE)
+				goto err;
+			if (css_hdr->header_len != ICP_QAT_DUALSIGN_HDR_LEN)
+				goto err;
+			if (css_hdr->header_ver != ICP_QAT_DUALSIGN_HDR_VER)
+				goto err;
+		} else {
+			if (css_hdr->header_len * css_dword_size != header_len)
+				goto err;
+			if (css_hdr->size * css_dword_size != size)
+				goto err;
+			if (size <= header_len)
+				goto err;
+		}
+
 		if (fw_type != simg_type)
 			goto err;
-		if (size <= header_len)
-			goto err;
+
 		size -= header_len;
 	}
 
@@ -1515,6 +1542,115 @@ static int qat_uclo_build_auth_desc_RSA(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
+static int qat_uclo_build_auth_desc_dualsign(struct icp_qat_fw_loader_handle *handle,
+					     char *image, unsigned int size,
+					     struct icp_firml_dram_desc *dram_desc,
+					     unsigned int fw_type,
+					     struct icp_qat_fw_auth_desc **desc)
+{
+	struct icp_qat_simg_ae_mode *simg_ae_mode;
+	struct icp_qat_fw_auth_desc *auth_desc;
+	unsigned int chunk_offset, img_offset;
+	u64 bus_addr, addr;
+	char *virt_addr;
+
+	virt_addr = dram_desc->dram_base_addr_v;
+	virt_addr += sizeof(struct icp_qat_auth_chunk);
+	bus_addr  = dram_desc->dram_bus_addr + sizeof(struct icp_qat_auth_chunk);
+
+	auth_desc = dram_desc->dram_base_addr_v;
+	auth_desc->img_len = size - qat_uclo_simg_hdr2sign_len(handle);
+	auth_desc->css_hdr_high = upper_32_bits(bus_addr);
+	auth_desc->css_hdr_low = lower_32_bits(bus_addr);
+	memcpy(virt_addr, image, ICP_QAT_DUALSIGN_OPAQUE_HDR_LEN);
+
+	img_offset = ICP_QAT_DUALSIGN_OPAQUE_HDR_LEN;
+	chunk_offset = ICP_QAT_DUALSIGN_OPAQUE_HDR_ALIGN_LEN;
+
+	/* RSA pub key */
+	addr = bus_addr + chunk_offset;
+	auth_desc->fwsk_pub_high = upper_32_bits(addr);
+	auth_desc->fwsk_pub_low = lower_32_bits(addr);
+	memcpy(virt_addr + chunk_offset, image + img_offset, ICP_QAT_CSS_FWSK_MODULUS_LEN(handle));
+
+	img_offset += ICP_QAT_CSS_FWSK_MODULUS_LEN(handle);
+	chunk_offset += ICP_QAT_CSS_FWSK_MODULUS_LEN(handle);
+	/* RSA padding */
+	memset(virt_addr + chunk_offset, 0, ICP_QAT_CSS_FWSK_PAD_LEN(handle));
+
+	chunk_offset += ICP_QAT_CSS_FWSK_PAD_LEN(handle);
+	/* RSA exponent */
+	memcpy(virt_addr + chunk_offset, image + img_offset, ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle));
+
+	img_offset += ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle);
+	chunk_offset += ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle);
+	/* RSA signature */
+	addr = bus_addr + chunk_offset;
+	auth_desc->signature_high = upper_32_bits(addr);
+	auth_desc->signature_low = lower_32_bits(addr);
+	memcpy(virt_addr + chunk_offset, image + img_offset, ICP_QAT_CSS_SIGNATURE_LEN(handle));
+
+	img_offset += ICP_QAT_CSS_SIGNATURE_LEN(handle);
+	chunk_offset += ICP_QAT_CSS_SIGNATURE_LEN(handle);
+	/* XMSS pubkey */
+	addr = bus_addr + chunk_offset;
+	auth_desc->xmss_pubkey_high = upper_32_bits(addr);
+	auth_desc->xmss_pubkey_low = lower_32_bits(addr);
+	memcpy(virt_addr + chunk_offset, image + img_offset, ICP_QAT_DUALSIGN_XMSS_PUBKEY_LEN);
+
+	img_offset += ICP_QAT_DUALSIGN_XMSS_PUBKEY_LEN;
+	chunk_offset += ICP_QAT_DUALSIGN_XMSS_PUBKEY_LEN;
+	/* XMSS signature */
+	addr = bus_addr + chunk_offset;
+	auth_desc->xmss_sig_high = upper_32_bits(addr);
+	auth_desc->xmss_sig_low = lower_32_bits(addr);
+	memcpy(virt_addr + chunk_offset, image + img_offset, ICP_QAT_DUALSIGN_XMSS_SIG_LEN);
+
+	img_offset += ICP_QAT_DUALSIGN_XMSS_SIG_LEN;
+	chunk_offset += ICP_QAT_DUALSIGN_XMSS_SIG_ALIGN_LEN;
+
+	if (dram_desc->dram_size < (chunk_offset + auth_desc->img_len)) {
+		pr_err("auth chunk memory size is not enough to store data\n");
+		return -ENOMEM;
+	}
+
+	/* Signed data */
+	addr = bus_addr + chunk_offset;
+	auth_desc->img_high = upper_32_bits(addr);
+	auth_desc->img_low = lower_32_bits(addr);
+	memcpy(virt_addr + chunk_offset, image + img_offset, auth_desc->img_len);
+
+	chunk_offset += ICP_QAT_DUALSIGN_MISC_INFO_LEN;
+	/* AE firmware */
+	if (fw_type == CSS_AE_FIRMWARE) {
+		/* AE mode data */
+		addr = bus_addr + chunk_offset;
+		auth_desc->img_ae_mode_data_high = upper_32_bits(addr);
+		auth_desc->img_ae_mode_data_low = lower_32_bits(addr);
+		simg_ae_mode =
+			(struct icp_qat_simg_ae_mode *)(virt_addr + chunk_offset);
+		auth_desc->ae_mask = simg_ae_mode->ae_mask & handle->cfg_ae_mask;
+
+		chunk_offset += sizeof(struct icp_qat_simg_ae_mode);
+		/* AE init seq */
+		addr = bus_addr + chunk_offset;
+		auth_desc->img_ae_init_data_high = upper_32_bits(addr);
+		auth_desc->img_ae_init_data_low = lower_32_bits(addr);
+
+		chunk_offset += ICP_QAT_SIMG_AE_INIT_SEQ_LEN;
+		/* AE instructions */
+		addr = bus_addr + chunk_offset;
+		auth_desc->img_ae_insts_high = upper_32_bits(addr);
+		auth_desc->img_ae_insts_low = lower_32_bits(addr);
+	} else {
+		addr = bus_addr + chunk_offset;
+		auth_desc->img_ae_insts_high = upper_32_bits(addr);
+		auth_desc->img_ae_insts_low = lower_32_bits(addr);
+	}
+	*desc = auth_desc;
+	return 0;
+}
+
 static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 				char *image, unsigned int size,
 				struct icp_qat_fw_auth_desc **desc)
@@ -1533,6 +1669,10 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	auth_chunk->chunk_size = img_desc.dram_size;
 	auth_chunk->chunk_bus_addr = img_desc.dram_bus_addr;
 
+	if (handle->chip_info->dual_sign)
+		return qat_uclo_build_auth_desc_dualsign(handle, image, size, &img_desc,
+							 simg_fw_type, desc);
+
 	return qat_uclo_build_auth_desc_RSA(handle, image, size, &img_desc,
 					    simg_fw_type, desc);
 }
-- 
2.40.1

