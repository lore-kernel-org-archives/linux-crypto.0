Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0ABC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1703D20FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgJLUj0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:33953 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbgJLUjX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:23 -0400
IronPort-SDR: Xo2nFey3OAD0otS9lnf6QUr+2rjxMym2vQ4CUaZmd3qwUtOOJ0pWSZf4yXc7ZRFVFS62YTA3WP
 7RxYpv0p3SkQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913107"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913107"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:23 -0700
IronPort-SDR: ccNyrkBhKwtkdeNDSQr2HkCYryE33CNWWDPF0qIHAcldAfPEvTf6aZMqrjvSWWkG5K25Z+D77S
 wJtYQ1tE4nXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328179"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:21 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 11/31] crypto: qat - use admin mask to send fw constants
Date:   Mon, 12 Oct 2020 21:38:27 +0100
Message-Id: <20201012203847.340030-12-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce admin AE mask. If this mask set, the fw constant message is
sent only to engines that belong to that set, otherwise it is sent to
all engines.

This is in preparation for the qat_4xxx driver where the constant message
should be sent only to admin engines.

In GEN2 devices (c62x, c3xxx and dh895xcc), the admin AE mask is 0 and
the fw constants message is sent to all AEs.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 1 +
 drivers/crypto/qat/qat_common/adf_admin.c         | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 5f57850c2e8d..779f62fde3bd 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -171,6 +171,7 @@ struct adf_hw_device_data {
 	u32 instance_id;
 	u16 accel_mask;
 	u16 ae_mask;
+	u32 admin_ae_mask;
 	u16 tx_rings_mask;
 	u8 tx_rx_gap;
 	u8 num_banks;
diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 6d94746d266f..dcd580d2afe2 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -182,7 +182,7 @@ static int adf_set_fw_constants(struct adf_accel_dev *accel_dev)
 	struct icp_qat_fw_init_admin_req req;
 	struct icp_qat_fw_init_admin_resp resp;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	u32 ae_mask = hw_device->ae_mask;
+	u32 ae_mask = hw_device->admin_ae_mask ?: hw_device->ae_mask;
 
 	memset(&req, 0, sizeof(req));
 	memset(&resp, 0, sizeof(resp));
-- 
2.26.2

