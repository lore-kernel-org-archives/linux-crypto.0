From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/2] crypto: qat - Fix typo in comments
Date: Fri, 29 Apr 2016 10:59:59 -0700
Message-ID: <1461952800-14876-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbcD2SAo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 14:00:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix copy and paste typo adf_isr.c

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index b81f79a..06d4901 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -302,7 +302,7 @@ static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
 }
 
 /**
- * adf_vf_isr_resource_free() - Free IRQ for acceleration device
+ * adf_isr_resource_free() - Free IRQ for acceleration device
  * @accel_dev:  Pointer to acceleration device.
  *
  * Function frees interrupts for acceleration device.
@@ -317,7 +317,7 @@ void adf_isr_resource_free(struct adf_accel_dev *accel_dev)
 EXPORT_SYMBOL_GPL(adf_isr_resource_free);
 
 /**
- * adf_vf_isr_resource_alloc() - Allocate IRQ for acceleration device
+ * adf_isr_resource_alloc() - Allocate IRQ for acceleration device
  * @accel_dev:  Pointer to acceleration device.
  *
  * Function allocates interrupts for acceleration device.
-- 
2.1.4
