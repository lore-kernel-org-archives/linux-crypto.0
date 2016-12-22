From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix comments describing adf_disable_sriov()
Date: Thu, 22 Dec 2016 14:59:24 +0000
Message-ID: <20161222145924.5870-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Ahsan Atta <ahsan.atta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:16907 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756592AbcLVO7d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 09:59:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ahsan Atta <ahsan.atta@intel.com>

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_sriov.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 9320ae1..b36d865 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -162,9 +162,9 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 
 /**
  * adf_disable_sriov() - Disable SRIOV for the device
- * @pdev:  Pointer to pci device.
+ * @accel_dev:  Pointer to accel device.
  *
- * Function disables SRIOV for the pci device.
+ * Function disables SRIOV for the accel device.
  *
  * Return: 0 on success, error code otherwise.
  */
-- 
2.9.3
