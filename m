Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B44C433E7
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5704220BED
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgJLUjV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:33953 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:20 -0400
IronPort-SDR: J0Glf7CwbXYru1GwbTOGZpAwCUSCKkhPoONwG3t7T1Xv+oUKQ0CJs/ULFKyUCWP+uXES0eGSbt
 m7DB0lrJPmqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913093"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913093"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:19 -0700
IronPort-SDR: n1NqhKUMpGir7bzHKyAni0axBg5PXuPWSZFUru34RILqzVKjP+OZb0Z7hg30Iz/YeGbUsQoPIq
 ewHCz+9YYaSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328162"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:18 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 09/31] crypto: qat - rename ME in AE
Date:   Mon, 12 Oct 2020 21:38:25 +0100
Message-Id: <20201012203847.340030-10-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename occurrences of ME in the admin module with the acronym AE
(Acceleration Engine) as the two are equivalent.
This is to keep a single acronym for engined in the codebase and
follow the documentation in https://01.org/intel-quickassist-technology.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c             | 6 +++---
 drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 3ae7c89ce82a..13a5e8659682 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -163,7 +163,7 @@ static int adf_send_admin(struct adf_accel_dev *accel_dev,
 	return 0;
 }
 
-static int adf_init_me(struct adf_accel_dev *accel_dev)
+static int adf_init_ae(struct adf_accel_dev *accel_dev)
 {
 	struct icp_qat_fw_init_admin_req req;
 	struct icp_qat_fw_init_admin_resp resp;
@@ -172,7 +172,7 @@ static int adf_init_me(struct adf_accel_dev *accel_dev)
 
 	memset(&req, 0, sizeof(req));
 	memset(&resp, 0, sizeof(resp));
-	req.cmd_id = ICP_QAT_FW_INIT_ME;
+	req.cmd_id = ICP_QAT_FW_INIT_AE;
 
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
@@ -206,7 +206,7 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 {
 	int ret;
 
-	ret = adf_init_me(accel_dev);
+	ret = adf_init_ae(accel_dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
index 3868bcbed252..f05ad17fbdd6 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
@@ -6,7 +6,7 @@
 #include "icp_qat_fw.h"
 
 enum icp_qat_fw_init_admin_cmd_id {
-	ICP_QAT_FW_INIT_ME = 0,
+	ICP_QAT_FW_INIT_AE = 0,
 	ICP_QAT_FW_TRNG_ENABLE = 1,
 	ICP_QAT_FW_TRNG_DISABLE = 2,
 	ICP_QAT_FW_CONSTANTS_CFG = 3,
-- 
2.26.2

