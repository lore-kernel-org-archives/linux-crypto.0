From: Christian Hohnstaedt <christian@hohnstaedt.de>
Subject: [PATCH] ixp4xx_crypto: check firmware for crypto support
Date: Thu, 9 Apr 2009 15:46:34 +0200
Message-ID: <20090409134634.GO21117@mail3.prorata.de>
References: <200904091256010463689@163.com> <49DD9E23.9070101@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: timenhhf <timenhhf@163.com>, hzlyc <hzlyc@tom.com>,
	linux-crypto@vger.kernel.org
To: Karl Hiramoto <karl@hiramoto.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.prorata.de ([62.145.31.200]:50388 "EHLO mail3.prorata.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764918AbZDINxV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2009 09:53:21 -0400
Content-Disposition: inline
In-Reply-To: <49DD9E23.9070101@hiramoto.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 - the loaded firmware may not support crypto at all or
   only support DES and 3DES but not AES or
   support DES, 3DES and AES.

 - in case of no crypto support of the firmware, the module load will fail.
 - in case of missing AES support, the AES algorithms are not registered
   and a warning is printed during module load.

Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>
---
 drivers/crypto/ixp4xx_crypto.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index fdcd0ab..f72f414 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -415,6 +415,7 @@ static void crypto_done_action(unsigned long arg)
 static int init_ixp_crypto(void)
 {
 	int ret = -ENODEV;
+	u32 msg[2] = { 0, 0 };
 
 	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
 				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
@@ -426,9 +427,35 @@ static int init_ixp_crypto(void)
 		return ret;
 
 	if (!npe_running(npe_c)) {
-		npe_load_firmware(npe_c, npe_name(npe_c), dev);
+		ret = npe_load_firmware(npe_c, npe_name(npe_c), dev);
+		if (ret) {
+			return ret;
+		}
+		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+	} else {
+		if (npe_send_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
 	}
 
+	switch ((msg[1]>>16) & 0xff) {
+	case 3:
+		printk(KERN_WARNING "Firmware of %s lacks AES support\n",
+				npe_name(npe_c));
+		support_aes = 0;
+		break;
+	case 4:
+	case 5:
+		support_aes = 1;
+		break;
+	default:
+		printk(KERN_ERR "Firmware of %s lacks crypto support\n",
+			npe_name(npe_c));
+		return -ENODEV;
+	}
 	/* buffer_pool will also be used to sometimes store the hmac,
 	 * so assure it is large enough
 	 */
@@ -457,6 +484,10 @@ static int init_ixp_crypto(void)
 
 	qmgr_enable_irq(RECV_QID);
 	return 0;
+
+npe_error:
+	printk(KERN_ERR "%s not responding\n", npe_name(npe_c));
+	ret = -EIO;
 err:
 	if (ctx_pool)
 		dma_pool_destroy(ctx_pool);
-- 
1.6.0.3

