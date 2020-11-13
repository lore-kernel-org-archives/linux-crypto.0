Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF89C388F7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 16:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2BC21D1A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 16:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgKMQqv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 11:46:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:5727 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgKMQqv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 11:46:51 -0500
IronPort-SDR: 60YB41Ni8N5lo9iKxYIGUsvrzvAf03/Ff0SPvbKRusxCs+1t3YcvvF5uK5K+5XKW8wEZ459AbN
 cpq2a7mj/Xug==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="234655777"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="234655777"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:46:50 -0800
IronPort-SDR: zXk7YYhkic0qOfTL33sSYc8khcuQ1kkxltblYEebek3UHUDFVRA3vYrruVpufs0DnzTtEttBji
 1JRX0+D7u+Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="328926310"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga006.jf.intel.com with ESMTP; 13 Nov 2020 08:46:49 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 1/3] crypto: qat - target fw images to specific AEs
Date:   Fri, 13 Nov 2020 16:46:41 +0000
Message-Id: <20201113164643.103383-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113164643.103383-1-giovanni.cabiddu@intel.com>
References: <20201113164643.103383-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce support for devices that require multiple firmware images.
If a device requires more than a firmware image to operate, load the
image to the appropriate Acceleration Engine (AE).

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  3 +
 .../crypto/qat/qat_common/adf_accel_engine.c  | 58 +++++++++++++++++--
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 5694422ec66c..1484f10dbfdf 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -175,6 +175,9 @@ struct adf_hw_device_data {
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
+	char *(*uof_get_name)(u32 obj_num);
+	u32 (*uof_get_num_objs)(void);
+	u32 (*uof_get_ae_mask)(u32 obj_num);
 	struct adf_hw_csr_ops csr_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index 08aaaf2b4659..ca4eae8cdd0b 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -7,12 +7,55 @@
 #include "adf_common_drv.h"
 #include "icp_qat_uclo.h"
 
+static int adf_ae_fw_load_images(struct adf_accel_dev *accel_dev, void *fw_addr,
+				 u32 fw_size)
+{
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	struct icp_qat_fw_loader_handle *loader;
+	char *obj_name;
+	u32 num_objs;
+	u32 ae_mask;
+	int i;
+
+	loader = loader_data->fw_loader;
+	num_objs = hw_device->uof_get_num_objs();
+
+	for (i = 0; i < num_objs; i++) {
+		obj_name = hw_device->uof_get_name(i);
+		ae_mask = hw_device->uof_get_ae_mask(i);
+
+		if (qat_uclo_set_cfg_ae_mask(loader, ae_mask)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Invalid mask for UOF image\n");
+			goto out_err;
+		}
+		if (qat_uclo_map_obj(loader, fw_addr, fw_size, obj_name)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to map UOF firmware\n");
+			goto out_err;
+		}
+		if (qat_uclo_wr_all_uimage(loader)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to load UOF firmware\n");
+			goto out_err;
+		}
+		qat_uclo_del_obj(loader);
+	}
+
+	return 0;
+
+out_err:
+	adf_ae_fw_release(accel_dev);
+	return -EFAULT;
+}
+
 int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	void *uof_addr, *mmp_addr;
-	u32 uof_size, mmp_size;
+	void *fw_addr, *mmp_addr;
+	u32 fw_size, mmp_size;
 
 	if (!hw_device->fw_name)
 		return 0;
@@ -30,15 +73,20 @@ int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 		goto out_err;
 	}
 
-	uof_size = loader_data->uof_fw->size;
-	uof_addr = (void *)loader_data->uof_fw->data;
+	fw_size = loader_data->uof_fw->size;
+	fw_addr = (void *)loader_data->uof_fw->data;
 	mmp_size = loader_data->mmp_fw->size;
 	mmp_addr = (void *)loader_data->mmp_fw->data;
+
 	if (qat_uclo_wr_mimage(loader_data->fw_loader, mmp_addr, mmp_size)) {
 		dev_err(&GET_DEV(accel_dev), "Failed to load MMP\n");
 		goto out_err;
 	}
-	if (qat_uclo_map_obj(loader_data->fw_loader, uof_addr, uof_size, NULL)) {
+
+	if (hw_device->uof_get_num_objs)
+		return adf_ae_fw_load_images(accel_dev, fw_addr, fw_size);
+
+	if (qat_uclo_map_obj(loader_data->fw_loader, fw_addr, fw_size, NULL)) {
 		dev_err(&GET_DEV(accel_dev), "Failed to map FW\n");
 		goto out_err;
 	}
-- 
2.28.0

