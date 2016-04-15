From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/3] crypto: qat - interrupts need to be enabled when VFs are disabled
Date: Fri, 15 Apr 2016 10:38:00 -0700
Message-ID: <1460741880-9479-3-git-send-email-tadeusz.struk@intel.com>
Cc: <tadeusz.struk@intel.com>,
	<sumanx.bangalore.sathyanarayana@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20191 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbcDORnR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 13:43:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IRQs need to be enabled when VFs go down in case some VF to PF
comms happens.

Tested-by: Suman Bangalore Sathyanarayana <sumanx.bangalore.sathyanarayana@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index a29470b..888c667 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -327,6 +327,8 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 			clear_bit(accel_dev->accel_id, &service->init_status);
 	}
 
+	hw_data->disable_iov(accel_dev);
+
 	if (test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status)) {
 		hw_data->free_irq(accel_dev);
 		clear_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
@@ -342,7 +344,6 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 	if (hw_data->exit_admin_comms)
 		hw_data->exit_admin_comms(accel_dev);
 
-	hw_data->disable_iov(accel_dev);
 	adf_cleanup_etr_data(accel_dev);
 	adf_dev_restore(accel_dev);
 }
-- 
2.1.4
