From: Yang Pingchao <pingchao.yang@intel.com>
Subject: [PATCH] crypto: qat - remove redundant function call
Date: Wed,  6 Jan 2016 17:56:20 +0800
Message-ID: <1452074180-114970-1-git-send-email-pingchao.yang@intel.com>
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Yang Pingchao <pingchao.yang@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:45365 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbcAFJ4g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jan 2016 04:56:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

adf_dev_restore(accel_dev) was called in adf_dev_shutdown,no
need to call it in adf_device_reset_worker after adf_dev_shutdown
was called.

Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index e78a1d7..b40d9c8 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -121,7 +121,6 @@ static void adf_device_reset_worker(struct work_struct *work)
 	adf_dev_restarting_notify(accel_dev);
 	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
-	adf_dev_restore(accel_dev);
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-- 
2.6.4
