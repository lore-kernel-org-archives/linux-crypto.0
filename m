From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix incorrect accelerator mask for C3X devices
Date: Tue, 30 Aug 2016 18:56:00 +0100
Message-ID: <1472579760-3698-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20911 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758403AbcH3R4I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2016 13:56:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Maksim Lukoshkov <maksim.lukoshkov@intel.com>

Fix incorrect value of ADF_C3XXX_ACCELERATORS_MASK.

Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index 2f2681d..afc9a0a 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -55,7 +55,7 @@
 #define ADF_C3XXX_MAX_ACCELERATORS 3
 #define ADF_C3XXX_MAX_ACCELENGINES 6
 #define ADF_C3XXX_ACCELERATORS_REG_OFFSET 16
-#define ADF_C3XXX_ACCELERATORS_MASK 0x3
+#define ADF_C3XXX_ACCELERATORS_MASK 0x7
 #define ADF_C3XXX_ACCELENGINES_MASK 0x3F
 #define ADF_C3XXX_ETR_MAX_BANKS 16
 #define ADF_C3XXX_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
-- 
1.7.4.1
