From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] crypto: qat: remove unused vairable.
Date: Thu, 12 May 2016 00:58:31 +0530
Message-ID: <1462994953-3195-1-git-send-email-falakreyaz@gmail.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Geliang Tang <geliangtang@163.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:32859 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbcEKT3Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 15:29:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the unused variable ret, and return 0 explicitly.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index db21b49..0f0677f 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -273,7 +273,6 @@ static int adf_ctl_is_device_in_use(int id)
 static int adf_ctl_stop_devices(uint32_t id)
 {
 	struct adf_accel_dev *accel_dev;
-	int ret = 0;
 
 	list_for_each_entry(accel_dev, adf_devmgr_get_head(), list) {
 		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
@@ -298,7 +297,7 @@ static int adf_ctl_stop_devices(uint32_t id)
 			adf_dev_shutdown(accel_dev);
 		}
 	}
-	return ret;
+	return 0;
 }
 
 static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
-- 
1.9.1
