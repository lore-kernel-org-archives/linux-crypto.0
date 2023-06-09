Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E90EC7EE2F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 16:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjFIQs7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 12:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjFIQsu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 12:48:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50B03A91
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329325; x=1717865325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X35jdhTDVSLx+rDQU9oRjwIAvr0AwMnXIZkYSkdtSDg=;
  b=l5vvYKpCbQKEcJ1sUMOrkL+glYBMeUJjDkQ84gEU/3IpMoSPalBZqDR9
   p6xg852r2B1ek457g2Z+kiplvFPBo5I/82nFqlnmomi/0goukwn7shLV/
   3Wwi4zOEuTiUfGpXyYEkfxf796Ldhhx+Xd+dfAzVtKKKgiJ0020lfXhvy
   bUZoF0EX63lSkeMrUTlB2/vQC6WZYo3k9lXp91K1weYa7tCOzjyuqQHpH
   +cTZBLmPKPs5OrKRIm99cN0Tnz7YYc2hq2zUpT1Ec2PutYFUH+Y+OoW9/
   ZEn+FDcRS/tPVAvrCd5R5KlU9LOVc6IwcQ5KdxhUuvX5hDm06UuP3fnh2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="337999087"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337999087"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:48:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957214176"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957214176"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 09:48:26 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/4] crypto: qat - make fw images name constant
Date:   Fri,  9 Jun 2023 17:38:20 +0100
Message-Id: <20230609163821.6533-3-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609163821.6533-1-adam.guerin@intel.com>
References: <20230609163821.6533-1-adam.guerin@intel.com>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Update fw image names to be constant throughout the driver.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c    | 6 +++---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_accel_engine.c  | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h    | 2 +-
 drivers/crypto/intel/qat/qat_common/qat_uclo.c          | 8 ++++----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index c961fa6ce5aa..7a2f56567298 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -14,7 +14,7 @@
 
 struct adf_fw_config {
 	u32 ae_mask;
-	char *obj_name;
+	const char *obj_name;
 };
 
 static struct adf_fw_config adf_4xxx_fw_cy_config[] = {
@@ -312,7 +312,7 @@ static u32 uof_get_num_objs(void)
 	return ARRAY_SIZE(adf_4xxx_fw_cy_config);
 }
 
-static char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
+static const char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
@@ -324,7 +324,7 @@ static char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
 	}
 }
 
-static char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_num)
+static const char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 93938bb0fca0..5240185a023e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -204,7 +204,7 @@ struct adf_hw_device_data {
 	int (*ring_pair_reset)(struct adf_accel_dev *accel_dev, u32 bank_nr);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
-	char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
+	const char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	u32 (*uof_get_num_objs)(void);
 	u32 (*uof_get_ae_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	int (*dev_config)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
index 4ce2b666929e..6be064dc64c8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
@@ -13,7 +13,7 @@ static int adf_ae_fw_load_images(struct adf_accel_dev *accel_dev, void *fw_addr,
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
 	struct icp_qat_fw_loader_handle *loader;
-	char *obj_name;
+	const char *obj_name;
 	u32 num_objs;
 	u32 ae_mask;
 	int i;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 2c2ac4dc9753..9976cfe65488 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -188,7 +188,7 @@ void qat_uclo_del_obj(struct icp_qat_fw_loader_handle *handle);
 int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle, void *addr_ptr,
 		       int mem_size);
 int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
-		     void *addr_ptr, u32 mem_size, char *obj_name);
+		     void *addr_ptr, u32 mem_size, const char *obj_name);
 int qat_uclo_set_cfg_ae_mask(struct icp_qat_fw_loader_handle *handle,
 			     unsigned int cfg_ae_mask);
 int adf_init_misc_wq(void);
diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 3ba8ca20b3d7..ce837bcc1cab 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1685,7 +1685,7 @@ static void qat_uclo_del_mof(struct icp_qat_fw_loader_handle *handle)
 }
 
 static int qat_uclo_seek_obj_inside_mof(struct icp_qat_mof_handle *mobj_handle,
-					char *obj_name, char **obj_ptr,
+					const char *obj_name, char **obj_ptr,
 					unsigned int *obj_size)
 {
 	struct icp_qat_mof_objhdr *obj_hdr = mobj_handle->obj_table.obj_hdr;
@@ -1837,8 +1837,8 @@ static int qat_uclo_check_mof_format(struct icp_qat_mof_file_hdr *mof_hdr)
 
 static int qat_uclo_map_mof_obj(struct icp_qat_fw_loader_handle *handle,
 				struct icp_qat_mof_file_hdr *mof_ptr,
-				u32 mof_size, char *obj_name, char **obj_ptr,
-				unsigned int *obj_size)
+				u32 mof_size, const char *obj_name,
+				char **obj_ptr, unsigned int *obj_size)
 {
 	struct icp_qat_mof_chunkhdr *mof_chunkhdr;
 	unsigned int file_id = mof_ptr->file_id;
@@ -1888,7 +1888,7 @@ static int qat_uclo_map_mof_obj(struct icp_qat_fw_loader_handle *handle,
 }
 
 int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
-		     void *addr_ptr, u32 mem_size, char *obj_name)
+		     void *addr_ptr, u32 mem_size, const char *obj_name)
 {
 	char *obj_addr;
 	u32 obj_size;
-- 
2.40.1

