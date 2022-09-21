Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B918ECAAD8
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Sep 2022 09:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiIUJlR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Sep 2022 05:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiIUJlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Sep 2022 05:41:16 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10618E987
        for <linux-crypto@vger.kernel.org>; Wed, 21 Sep 2022 02:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663753275; x=1695289275;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R2olj1wj/HFpAWz79tzLY/V0ghBPK0i2tWvQoopD9pw=;
  b=iXI4bkIU5CqSkFw8xFUcJJrIQx1DgR9UxDSUJ5BlrYA4Y8RiVIdoCU/e
   9gI35AuOQ8zY1tVgGLB7BdLjh29WvRE5MevQJsowWXYn505wgzbgpnm9M
   /dyQ8xr6BJhIG/ARO6Tah9DRMpjTgwNyOthA55RcE6LJeOhRZK5S1dws0
   h97ttrSVuUZ/8lXM6oIJrWpCQPIWti+wAqTGqSmHpt1enVBsqh/QaZqQp
   vyHk5LVYRhaWQYKS6jaiEsUXJ2fKs2k1zFeL0by8U8LnvSA+NtSURalX6
   HmRC5Kl7U5VRz3H/SPqkIGHhr4o2NoIokC5CXIT94pApF6ZW2bDmg1eOZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="280328545"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="280328545"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 02:41:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="708372206"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Sep 2022 02:41:14 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [RESEND] crypto: qat - add limit to linked list parsing
Date:   Wed, 21 Sep 2022 10:38:30 +0100
Message-Id: <20220921093830.214377-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

adf_copy_key_value_data() copies data from userland to kernel, based on
a linked link provided by userland. If userland provides a circular
list (or just a very long one) then it would drive a long loop where
allocation occurs in every loop. This could lead to low memory conditions.
Adding a limit to stop endless loop.

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Co-developed-by: Ciunas Bennett <ciunas.bennett@intel.com>
Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 508c18edd692..82b69e1f725b 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -16,6 +16,9 @@
 #include "adf_cfg_common.h"
 #include "adf_cfg_user.h"
 
+#define ADF_CFG_MAX_SECTION 512
+#define ADF_CFG_MAX_KEY_VAL 256
+
 #define DEVICE_NAME "qat_adf_ctl"
 
 static DEFINE_MUTEX(adf_ctl_lock);
@@ -137,10 +140,11 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 	struct adf_user_cfg_key_val key_val;
 	struct adf_user_cfg_key_val *params_head;
 	struct adf_user_cfg_section section, *section_head;
+	int i, j;
 
 	section_head = ctl_data->config_section;
 
-	while (section_head) {
+	for (i = 0; section_head && i < ADF_CFG_MAX_SECTION; i++) {
 		if (copy_from_user(&section, (void __user *)section_head,
 				   sizeof(*section_head))) {
 			dev_err(&GET_DEV(accel_dev),
@@ -156,7 +160,7 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 
 		params_head = section.params;
 
-		while (params_head) {
+		for (j = 0; params_head && j < ADF_CFG_MAX_KEY_VAL; j++) {
 			if (copy_from_user(&key_val, (void __user *)params_head,
 					   sizeof(key_val))) {
 				dev_err(&GET_DEV(accel_dev),
-- 
2.37.3

