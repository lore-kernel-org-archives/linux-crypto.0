Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DE8C001DB
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Aug 2023 03:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjHIDQp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHIDQp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Aug 2023 23:16:45 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8A1BEF
        for <linux-crypto@vger.kernel.org>; Tue,  8 Aug 2023 20:16:44 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RLFWh5fxyz1hwMV;
        Wed,  9 Aug 2023 11:13:52 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 9 Aug
 2023 11:16:42 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <giovanni.cabiddu@intel.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
        <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: qat - Remove unused function declarations
Date:   Wed, 9 Aug 2023 11:16:14 +0800
Message-ID: <20230809031614.9704-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
declared but never implemented these functions.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 799a2193d3e5..673b5044c62a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -58,12 +58,6 @@ int adf_dev_restart(struct adf_accel_dev *accel_dev);
 
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
-
-int adf_ctl_dev_register(void);
-void adf_ctl_dev_unregister(void);
-int adf_processes_dev_register(void);
-void adf_processes_dev_unregister(void);
-
 int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		       struct adf_accel_dev *pf);
 void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
@@ -182,8 +176,6 @@ int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
 int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
 		    unsigned char ae, unsigned long ctx_mask,
 		    unsigned short reg_num, unsigned int regdata);
-int qat_hal_wr_lm(struct icp_qat_fw_loader_handle *handle,
-		  unsigned char ae, unsigned short lm_addr, unsigned int value);
 void qat_hal_set_ae_tindex_mode(struct icp_qat_fw_loader_handle *handle,
 				unsigned char ae, unsigned char mode);
 int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle);
-- 
2.34.1

