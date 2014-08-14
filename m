From: weiyj_lk@163.com
Subject: [PATCH] crypto: qat - Fix return value check in adf_chr_drv_create()
Date: Thu, 14 Aug 2014 09:00:44 +0800
Message-ID: <1407978044-15750-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Bruce W. Allan" <bruce.w.allan@intel.com>,
	John Griffin <john.griffin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:51775 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaHNBBG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Aug 2014 21:01:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function device_create() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index d97069b..6f7816e 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -111,7 +111,7 @@ static int adf_chr_drv_create(void)
 	drv_device = device_create(adt_ctl_drv.drv_class, NULL,
 				   MKDEV(adt_ctl_drv.major, 0),
 				   NULL, DEVICE_NAME);
-	if (!drv_device) {
+	if (IS_ERR(drv_device)) {
 		pr_err("QAT: failed to create device\n");
 		goto err_cdev_del;
 	}
