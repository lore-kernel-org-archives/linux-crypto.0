Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA5BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Mar 2022 02:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiCRCNa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 22:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiCRCNa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 22:13:30 -0400
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Mar 2022 19:12:11 PDT
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BB62B5EC1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 19:12:10 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 18 Mar
 2022 10:11:04 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 18 Mar
 2022 10:11:01 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <giovanni.cabiddu@intel.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <marco.chiappero@intel.com>,
        <fiona.trahe@intel.com>, <wojciech.ziemba@intel.com>
CC:     <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH] crypto: qat: Fix unsigned comparison with less than zero
Date:   Fri, 18 Mar 2022 10:10:59 +0800
Message-ID: <1647569459-18376-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c:67:5-8: WARNING: Unsigned expression compared with zero: ret < 0

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 6d10edc..0143835 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -52,7 +52,7 @@ static const char *const dev_cfg_services[] = {
 static int get_service_enabled(struct adf_accel_dev *accel_dev)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-	u32 ret;
+	s32 ret;
 
 	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
 				      ADF_SERVICES_ENABLED, services);
-- 
2.7.4

