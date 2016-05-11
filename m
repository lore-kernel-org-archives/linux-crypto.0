From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat: remove unused vairable.
Date: Wed, 11 May 2016 13:21:29 -0700
Message-ID: <8e99795a-ed3c-8990-300a-031d7f61531e@intel.com>
References: <1462994953-3195-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Geliang Tang <geliangtang@163.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbcEKUWl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 16:22:41 -0400
In-Reply-To: <1462994953-3195-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/11/2016 12:28 PM, Muhammad Falak R Wani wrote:
> Remove the unused variable ret, and return 0 explicitly.

Thanks for the patch. In this case it will be even better
to change the adf_ctl_stop_devices() to a void function.
---8<---
Subject: [PATCH] crypto: qat - change the adf_ctl_stop_devices to void

Change the adf_ctl_stop_devices to a void function.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index db21b49..abc7a7f 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -270,10 +270,9 @@ static int adf_ctl_is_device_in_use(int id)
 	return 0;
 }
 
-static int adf_ctl_stop_devices(uint32_t id)
+static void adf_ctl_stop_devices(uint32_t id)
 {
 	struct adf_accel_dev *accel_dev;
-	int ret = 0;
 
 	list_for_each_entry(accel_dev, adf_devmgr_get_head(), list) {
 		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
@@ -298,7 +297,6 @@ static int adf_ctl_stop_devices(uint32_t id)
 			adf_dev_shutdown(accel_dev);
 		}
 	}
-	return ret;
 }
 
 static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
@@ -327,9 +325,8 @@ static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
 		pr_info("QAT: Stopping acceleration device qat_dev%d.\n",
 			ctl_data->device_id);
 
-	ret = adf_ctl_stop_devices(ctl_data->device_id);
-	if (ret)
-		pr_err("QAT: failed to stop device.\n");
+	adf_ctl_stop_devices(ctl_data->device_id);
+
 out:
 	kfree(ctl_data);
 	return ret;

Thanks,
-- 
TS
