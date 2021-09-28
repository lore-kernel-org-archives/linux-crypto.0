Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEC6C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E8961139
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhI1Lqo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:37927 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240403AbhI1Lqm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339065"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339065"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224807"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:45:01 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 08/12] crypto: qat - move pfvf collision detection values
Date:   Tue, 28 Sep 2021 12:44:36 +0100
Message-Id: <20210928114440.355368-9-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Keep adf_pf2vf_msg.h as much as possible focused on the protocol
definition.
Instead, collision parameters are an implementation detail which should
stay close to the code consuming them, therefore move them to
adf_pf2vf_msg.c.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 9 +++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 41f4b5643dbb..22977001271c 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -5,6 +5,15 @@
 #include "adf_common_drv.h"
 #include "adf_pf2vf_msg.h"
 
+#define ADF_IOV_MSG_COLLISION_DETECT_DELAY	10
+#define ADF_IOV_MSG_ACK_DELAY			2
+#define ADF_IOV_MSG_ACK_MAX_RETRY		100
+#define ADF_IOV_MSG_RETRY_DELAY			5
+#define ADF_IOV_MSG_MAX_RETRIES			3
+#define ADF_IOV_MSG_RESP_TIMEOUT	(ADF_IOV_MSG_ACK_DELAY * \
+					 ADF_IOV_MSG_ACK_MAX_RETRY + \
+					 ADF_IOV_MSG_COLLISION_DETECT_DELAY)
+
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
index ffd43aa50b57..a7d8f8367345 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
@@ -90,13 +90,4 @@
 /* VF->PF Compatible Version Request */
 #define ADF_VF2PF_COMPAT_VER_REQ_SHIFT		22
 
-/* Collision detection */
-#define ADF_IOV_MSG_COLLISION_DETECT_DELAY	10
-#define ADF_IOV_MSG_ACK_DELAY			2
-#define ADF_IOV_MSG_ACK_MAX_RETRY		100
-#define ADF_IOV_MSG_RETRY_DELAY			5
-#define ADF_IOV_MSG_MAX_RETRIES			3
-#define ADF_IOV_MSG_RESP_TIMEOUT	(ADF_IOV_MSG_ACK_DELAY * \
-					 ADF_IOV_MSG_ACK_MAX_RETRY + \
-					 ADF_IOV_MSG_COLLISION_DETECT_DELAY)
 #endif /* ADF_IOV_MSG_H */
-- 
2.31.1

