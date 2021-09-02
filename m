Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CA8C432BE
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Sep 2021 08:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB8B061057
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Sep 2021 08:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbhIBIg1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Sep 2021 04:36:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:14276 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233391AbhIBIg1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Sep 2021 04:36:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="199258647"
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="199258647"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 01:35:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="691271517"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga005.fm.intel.com with ESMTP; 02 Sep 2021 01:35:07 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        kernel test robot <lkp@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH] crypto: qat - remove unneeded packed attribute
Date:   Thu,  2 Sep 2021 09:34:59 +0100
Message-Id: <20210902083459.238983-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove packed attribute from structures that do not need to be packed.
These are just used internally and not shared with firmware.

This also fixes a series of warning when compiling the driver with the
flag -Waddress-of-packed-member, similar to the following:

    drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c:102:28: warning: taking address of packed member 'csr_ops' of class or structure 'adf_hw_device_data' may result in an unaligned pointer value

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 38c0af6d4e43..5d4281c95866 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -42,13 +42,13 @@ struct adf_bar {
 	resource_size_t base_addr;
 	void __iomem *virt_addr;
 	resource_size_t size;
-} __packed;
+};
 
 struct adf_accel_msix {
 	struct msix_entry *entries;
 	char **names;
 	u32 num_entries;
-} __packed;
+};
 
 struct adf_accel_pci {
 	struct pci_dev *pci_dev;
@@ -56,7 +56,7 @@ struct adf_accel_pci {
 	struct adf_bar pci_bars[ADF_PCI_MAX_BARS];
 	u8 revid;
 	u8 sku;
-} __packed;
+};
 
 enum dev_state {
 	DEV_DOWN = 0,
@@ -96,7 +96,7 @@ struct adf_hw_device_class {
 	const char *name;
 	const enum adf_device_type type;
 	u32 instances;
-} __packed;
+};
 
 struct arb_info {
 	u32 arb_cfg;
@@ -195,7 +195,7 @@ struct adf_hw_device_data {
 	u8 num_logical_accel;
 	u8 num_engines;
 	u8 min_iov_compat_ver;
-} __packed;
+};
 
 /* CSR write macro */
 #define ADF_CSR_WR(csr_base, csr_offset, val) \
@@ -261,5 +261,5 @@ struct adf_accel_dev {
 	};
 	bool is_vf;
 	u32 accel_id;
-} __packed;
+};
 #endif
-- 
2.31.1

