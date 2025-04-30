Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF925A630
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012912; cv=none; b=jwJhwzgpJaBGIcsll6RfS5GPCkhFSuyIFyRXgh7q3BLPyx246RYiapcsaJ2pTJLmfgbbfFueiw6JT63klj7Hn/MtZcy1kh2pLjwVuqcjjVbLZkIhRF1xveCchGVTwTP3OhRit3uN3tf9ctFCqrmDHHy2JdayAyspaPMMCgDt734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012912; c=relaxed/simple;
	bh=giGlaQyaAsE/jquEcnICW2V7Ki+PiVnr6kJifTwfMWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TaMUd+DtX5O1VJNMUOldZVk8wbnsp4WLr7fyG4DIxWmbLz1wmsMQOKmubhQb8z5JAj/pTyjszrBaNumDBf6Sq2x2QB9zGoWR6aYXn6bfutFgVqucx9V1tTDpGTy/MduaxR1nEVfqMYyk7v89fAA77XBDdJy+70odQphnmk4gLFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hGJi7rfI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hGJi7rfI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012910; x=1777548910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=giGlaQyaAsE/jquEcnICW2V7Ki+PiVnr6kJifTwfMWk=;
  b=hGJi7rfIjnlqv2WCrEtuaIANvpeiSoNOCO4ib4jCrFFNCUqJr8sefEbm
   B6vhDLMQGa4+/FK+SK4r7EdBsU24MFbSNJRH8fiVhy/BErZ28dK8WQ3sZ
   Eyt6i4yi7h/qimanV0kRlgAn3ODRnzNroSaahbkd0OGHwMy79Bn9DHUvv
   hSMsGE1WQY1ET86vxDXZ5Gkp1HzUrVKPjT5WM947IQdcO7DDd5iOWTRwf
   7e5PED9vQq+p3P5yYL96o7UtznMeoNcKtflqaCwzdkokFwnTisbp0gqKN
   nItzXf194UKx0suF+K8p9kd8ke3E8BieRoIQCy5DJ3QkGkTaWvrJiB33/
   Q==;
X-CSE-ConnectionGUID: +MMP1KKhSSqP8UUF+uGB5A==
X-CSE-MsgGUID: EkAZObzERa2XArJUUmLwyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331144"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331144"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:10 -0700
X-CSE-ConnectionGUID: +91lUjGMQq+t+Aywo/M03g==
X-CSE-MsgGUID: 24OgB6TeSBqPICbA0/mWyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812532"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:08 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 04/11] crypto: qat - refactor FW signing algorithm
Date: Wed, 30 Apr 2025 12:34:46 +0100
Message-Id: <20250430113453.1587497-5-suman.kumar.chakraborty@intel.com>
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

The current implementation is designed to support single FW signing
authentication only.
Refactor the implementation to support other FW signing methods.

This does not include any functional change.

Co-developed-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_common/qat_uclo.c    | 154 ++++++++++--------
 1 file changed, 84 insertions(+), 70 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 9dc26f5d2d01..d7f2ceb81f1f 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1033,6 +1033,23 @@ static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
 	return -EFAULT;
 }
 
+static unsigned int qat_uclo_simg_hdr2sign_len(struct icp_qat_fw_loader_handle *handle)
+{
+	return ICP_QAT_AE_IMG_OFFSET(handle);
+}
+
+static unsigned int qat_uclo_simg_hdr2cont_len(struct icp_qat_fw_loader_handle *handle)
+{
+	return ICP_QAT_AE_IMG_OFFSET(handle);
+}
+
+static unsigned int qat_uclo_simg_fw_type(struct icp_qat_fw_loader_handle *handle, void *img_ptr)
+{
+	struct icp_qat_css_hdr *hdr = img_ptr;
+
+	return hdr->fw_type;
+}
+
 static int qat_uclo_map_suof_file_hdr(struct icp_qat_fw_loader_handle *handle,
 				      struct icp_qat_suof_filehdr *suof_ptr,
 				      int suof_size)
@@ -1064,9 +1081,9 @@ static void qat_uclo_map_simg(struct icp_qat_fw_loader_handle *handle,
 			      struct icp_qat_suof_chunk_hdr *suof_chunk_hdr)
 {
 	struct icp_qat_suof_handle *suof_handle = handle->sobj_handle;
-	unsigned int offset = ICP_QAT_AE_IMG_OFFSET(handle);
-	struct icp_qat_simg_ae_mode *ae_mode;
+	unsigned int offset = qat_uclo_simg_hdr2cont_len(handle);
 	struct icp_qat_suof_objhdr *suof_objhdr;
+	struct icp_qat_simg_ae_mode *ae_mode;
 
 	suof_img_hdr->simg_buf  = (suof_handle->suof_buf +
 				   suof_chunk_hdr->offset +
@@ -1362,21 +1379,24 @@ static void qat_uclo_ummap_auth_fw(struct icp_qat_fw_loader_handle *handle,
 }
 
 static int qat_uclo_check_image(struct icp_qat_fw_loader_handle *handle,
-				char *image, unsigned int size,
+				void *image, unsigned int size,
 				unsigned int fw_type)
 {
 	char *fw_type_name = fw_type ? "MMP" : "AE";
 	unsigned int css_dword_size = sizeof(u32);
+	unsigned int header_len, simg_type;
+	struct icp_qat_css_hdr *css_hdr;
 
 	if (handle->chip_info->fw_auth) {
-		struct icp_qat_css_hdr *css_hdr = (struct icp_qat_css_hdr *)image;
-		unsigned int header_len = ICP_QAT_AE_IMG_OFFSET(handle);
+		header_len = qat_uclo_simg_hdr2sign_len(handle);
+		simg_type = qat_uclo_simg_fw_type(handle, image);
 
+		css_hdr = image;
 		if ((css_hdr->header_len * css_dword_size) != header_len)
 			goto err;
 		if ((css_hdr->size * css_dword_size) != size)
 			goto err;
-		if (fw_type != css_hdr->fw_type)
+		if (fw_type != simg_type)
 			goto err;
 		if (size <= header_len)
 			goto err;
@@ -1403,113 +1423,85 @@ static int qat_uclo_check_image(struct icp_qat_fw_loader_handle *handle,
 	return -EINVAL;
 }
 
-static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
-				char *image, unsigned int size,
-				struct icp_qat_fw_auth_desc **desc)
+static int qat_uclo_build_auth_desc_RSA(struct icp_qat_fw_loader_handle *handle,
+					char *image, unsigned int size,
+					struct icp_firml_dram_desc *dram_desc,
+					unsigned int fw_type, struct icp_qat_fw_auth_desc **desc)
 {
 	struct icp_qat_css_hdr *css_hdr = (struct icp_qat_css_hdr *)image;
-	struct icp_qat_fw_auth_desc *auth_desc;
-	struct icp_qat_auth_chunk *auth_chunk;
-	u64 virt_addr,  bus_addr, virt_base;
-	unsigned int simg_offset = sizeof(*auth_chunk);
 	struct icp_qat_simg_ae_mode *simg_ae_mode;
-	struct icp_firml_dram_desc img_desc;
-	int ret;
+	struct icp_qat_fw_auth_desc *auth_desc;
+	char *virt_addr, *virt_base;
+	u64 bus_addr;
 
-	ret = qat_uclo_simg_alloc(handle, &img_desc, ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN);
-	if (ret) {
-		pr_err("error, allocate continuous dram fail\n");
-		return ret;
-	}
-
-	if (!IS_ALIGNED(img_desc.dram_size, 8) || !img_desc.dram_bus_addr) {
-		pr_debug("invalid address\n");
-		qat_uclo_simg_free(handle, &img_desc);
-		return -EINVAL;
-	}
-
-	auth_chunk = img_desc.dram_base_addr_v;
-	auth_chunk->chunk_size = img_desc.dram_size;
-	auth_chunk->chunk_bus_addr = img_desc.dram_bus_addr;
-	virt_base = (uintptr_t)img_desc.dram_base_addr_v + simg_offset;
-	bus_addr  = img_desc.dram_bus_addr + simg_offset;
-	auth_desc = img_desc.dram_base_addr_v;
-	auth_desc->css_hdr_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
-	auth_desc->css_hdr_low = (unsigned int)bus_addr;
+	virt_base = dram_desc->dram_base_addr_v;
+	virt_base += sizeof(struct icp_qat_auth_chunk);
+	bus_addr  = dram_desc->dram_bus_addr + sizeof(struct icp_qat_auth_chunk);
+	auth_desc = dram_desc->dram_base_addr_v;
+	auth_desc->css_hdr_high = upper_32_bits(bus_addr);
+	auth_desc->css_hdr_low = lower_32_bits(bus_addr);
 	virt_addr = virt_base;
 
-	memcpy((void *)(uintptr_t)virt_addr, image, sizeof(*css_hdr));
+	memcpy(virt_addr, image, sizeof(*css_hdr));
 	/* pub key */
 	bus_addr = ADD_ADDR(auth_desc->css_hdr_high, auth_desc->css_hdr_low) +
 			   sizeof(*css_hdr);
 	virt_addr = virt_addr + sizeof(*css_hdr);
 
-	auth_desc->fwsk_pub_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
-	auth_desc->fwsk_pub_low = (unsigned int)bus_addr;
+	auth_desc->fwsk_pub_high = upper_32_bits(bus_addr);
+	auth_desc->fwsk_pub_low = lower_32_bits(bus_addr);
 
-	memcpy((void *)(uintptr_t)virt_addr,
-	       (void *)(image + sizeof(*css_hdr)),
-	       ICP_QAT_CSS_FWSK_MODULUS_LEN(handle));
+	memcpy(virt_addr, image + sizeof(*css_hdr), ICP_QAT_CSS_FWSK_MODULUS_LEN(handle));
 	/* padding */
 	memset((void *)(uintptr_t)(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN(handle)),
 	       0, ICP_QAT_CSS_FWSK_PAD_LEN(handle));
 
 	/* exponent */
-	memcpy((void *)(uintptr_t)(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
-	       ICP_QAT_CSS_FWSK_PAD_LEN(handle)),
-	       (void *)(image + sizeof(*css_hdr) +
-			ICP_QAT_CSS_FWSK_MODULUS_LEN(handle)),
-	       sizeof(unsigned int));
+	memcpy(virt_addr + ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
+	       ICP_QAT_CSS_FWSK_PAD_LEN(handle), image + sizeof(*css_hdr) +
+	       ICP_QAT_CSS_FWSK_MODULUS_LEN(handle), sizeof(unsigned int));
 
 	/* signature */
 	bus_addr = ADD_ADDR(auth_desc->fwsk_pub_high,
 			    auth_desc->fwsk_pub_low) +
 		   ICP_QAT_CSS_FWSK_PUB_LEN(handle);
 	virt_addr = virt_addr + ICP_QAT_CSS_FWSK_PUB_LEN(handle);
-	auth_desc->signature_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
-	auth_desc->signature_low = (unsigned int)bus_addr;
+	auth_desc->signature_high = upper_32_bits(bus_addr);
+	auth_desc->signature_low = lower_32_bits(bus_addr);
 
-	memcpy((void *)(uintptr_t)virt_addr,
-	       (void *)(image + sizeof(*css_hdr) +
-	       ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
-	       ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle)),
-	       ICP_QAT_CSS_SIGNATURE_LEN(handle));
+	memcpy(virt_addr, image + sizeof(*css_hdr) + ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
+	       ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle), ICP_QAT_CSS_SIGNATURE_LEN(handle));
 
 	bus_addr = ADD_ADDR(auth_desc->signature_high,
 			    auth_desc->signature_low) +
 		   ICP_QAT_CSS_SIGNATURE_LEN(handle);
 	virt_addr += ICP_QAT_CSS_SIGNATURE_LEN(handle);
 
-	auth_desc->img_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
-	auth_desc->img_low = (unsigned int)bus_addr;
-	auth_desc->img_len = size - ICP_QAT_AE_IMG_OFFSET(handle);
-	if (bus_addr + auth_desc->img_len > img_desc.dram_bus_addr +
-					    ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN) {
+	auth_desc->img_high = upper_32_bits(bus_addr);
+	auth_desc->img_low = lower_32_bits(bus_addr);
+	auth_desc->img_len = size - qat_uclo_simg_hdr2sign_len(handle);
+	if (bus_addr + auth_desc->img_len >
+	    dram_desc->dram_bus_addr + ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN) {
 		pr_err("insufficient memory size for authentication data\n");
-		qat_uclo_simg_free(handle, &img_desc);
+		qat_uclo_simg_free(handle, dram_desc);
 		return -ENOMEM;
 	}
 
-	memcpy((void *)(uintptr_t)virt_addr,
-	       (void *)(image + ICP_QAT_AE_IMG_OFFSET(handle)),
-	       auth_desc->img_len);
+	memcpy(virt_addr, image + qat_uclo_simg_hdr2sign_len(handle), auth_desc->img_len);
 	virt_addr = virt_base;
 	/* AE firmware */
-	if (((struct icp_qat_css_hdr *)(uintptr_t)virt_addr)->fw_type ==
-	    CSS_AE_FIRMWARE) {
+	if (fw_type == CSS_AE_FIRMWARE) {
 		auth_desc->img_ae_mode_data_high = auth_desc->img_high;
 		auth_desc->img_ae_mode_data_low = auth_desc->img_low;
 		bus_addr = ADD_ADDR(auth_desc->img_ae_mode_data_high,
 				    auth_desc->img_ae_mode_data_low) +
 			   sizeof(struct icp_qat_simg_ae_mode);
 
-		auth_desc->img_ae_init_data_high =
-			(unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
-		auth_desc->img_ae_init_data_low = (unsigned int)bus_addr;
+		auth_desc->img_ae_init_data_high = upper_32_bits(bus_addr);
+		auth_desc->img_ae_init_data_low = lower_32_bits(bus_addr);
 		bus_addr += ICP_QAT_SIMG_AE_INIT_SEQ_LEN;
-		auth_desc->img_ae_insts_high =
-			(unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
-		auth_desc->img_ae_insts_low = (unsigned int)bus_addr;
+		auth_desc->img_ae_insts_high = upper_32_bits(bus_addr);
+		auth_desc->img_ae_insts_low = lower_32_bits(bus_addr);
 		virt_addr += sizeof(struct icp_qat_css_hdr);
 		virt_addr += ICP_QAT_CSS_FWSK_PUB_LEN(handle);
 		virt_addr += ICP_QAT_CSS_SIGNATURE_LEN(handle);
@@ -1523,6 +1515,28 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
+static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
+				char *image, unsigned int size,
+				struct icp_qat_fw_auth_desc **desc)
+{
+	struct icp_qat_auth_chunk *auth_chunk;
+	struct icp_firml_dram_desc img_desc;
+	unsigned int simg_fw_type;
+	int ret;
+
+	ret = qat_uclo_simg_alloc(handle, &img_desc, ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN);
+	if (ret)
+		return ret;
+
+	simg_fw_type = qat_uclo_simg_fw_type(handle, image);
+	auth_chunk = img_desc.dram_base_addr_v;
+	auth_chunk->chunk_size = img_desc.dram_size;
+	auth_chunk->chunk_bus_addr = img_desc.dram_bus_addr;
+
+	return qat_uclo_build_auth_desc_RSA(handle, image, size, &img_desc,
+					    simg_fw_type, desc);
+}
+
 static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 			    struct icp_qat_fw_auth_desc *desc)
 {
-- 
2.40.1

