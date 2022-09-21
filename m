Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF69ECAAD8
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Sep 2022 09:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiIUJOa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Sep 2022 05:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiIUJOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Sep 2022 05:14:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9288E452
        for <linux-crypto@vger.kernel.org>; Wed, 21 Sep 2022 02:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663751618; x=1695287618;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LTq3z5bw0idCyJW7ACZWXh0z/fEdKp/vHv4ZUPquF9c=;
  b=HtoPDO2couy/5MdubfLpbqk2qiATiE7eVLkuj1japeUv855hINrokkLo
   MXX+oWl+BkKsMGOtsoYy3EAeYuVSwr7oJEOmk4+qEC4qmQ7RiJzLWQLVK
   G3qq/UV4w/Ju6jfTh/yUKbs5FVIQO7TTmG26BxPXdvMauiMSTxHcHB5Dp
   sNdsCYF6kDbMkjj61Ti4d1tS2ok83BvPjfHuyKGWgg39TUnrLSb4YEEbm
   hOOeAFRmenbxWEGWg+l/Ttv1JnVnfRlo5r/v1WIUr+DHv0a2BvfQVmfAL
   bmZapZ2oUFaNnOvnrirsi1Lwfp1YJlZBGoKnM2lq9bLTLcY8SUMRNfc0e
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="282996122"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="282996122"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 02:13:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="596899920"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by orsmga006.jf.intel.com with ESMTP; 21 Sep 2022 02:13:36 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Ciunas Bennett <ciunas.bennett@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2] crypto: qat - add limit to linked list parsing
Date:   Wed, 21 Sep 2022 10:09:24 +0100
Message-Id: <20220921090923.213968-1-adam.guerin@intel.com>
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
v2: improved patch based off feedback from ML
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

base-commit: 8aee6d5494bfb2e535307eb3e80e38cc5cc1c7a6
-- 
2.37.3

