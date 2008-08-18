From: Christian Hohnstaedt <christian@hohnstaedt.de>
Subject: [PATCH] ixp4xx_crypto: avoid firmware loading during module initialisation
Date: Mon, 18 Aug 2008 08:44:55 +0200
Message-ID: <20080818064455.GK22567@mail3.prorata.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.prorata.de ([62.145.31.200]:42481 "EHLO mail3.prorata.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYHRGvj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Aug 2008 02:51:39 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

 By moving the firmware-loading to the transform initialisation,
 the driver may be compiled in.

 Notify the user if the firmware does not support AES, or even
 no crypto at all.

Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>
---
 drivers/crypto/ixp4xx_crypto.c |   44 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 42a107f..c3aa5a4 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -438,10 +438,6 @@ static int init_ixp_crypto(void)
 	if (!npe_c)
 		return ret;
 
-	if (!npe_running(npe_c)) {
-		npe_load_firmware(npe_c, npe_name(npe_c), dev);
-	}
-
 	/* buffer_pool will also be used to sometimes store the hmac,
 	 * so assure it is large enough
 	 */
@@ -526,9 +522,45 @@ static void free_sa_dir(struct ix_sa_dir *dir)
 static int init_tfm(struct crypto_tfm *tfm)
 {
 	struct ixp_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 msg[2] = { 0, 0 };
+	static u32 image_id = 0;
 	int ret;
 
 	atomic_set(&ctx->configuring, 0);
+
+	if (!npe_running(npe_c)) {
+		ret = npe_load_firmware(npe_c, npe_name(npe_c), dev);
+		if (ret)
+			return ret;
+		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		image_id = msg[1];
+	}
+	if (!image_id) {
+		if (npe_send_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		image_id = msg[1];
+	}
+	switch ((image_id>>16) & 0xff) {
+		case 3:
+			if (cipher_cfg_enc(tfm) & MOD_AES) {
+				printk(KERN_ERR "Firmware of %s lacks AES "
+					"support\n", npe_name(npe_c));
+				return -ENODEV;
+			}
+		case 4:
+		case 5:
+			break;
+		default:
+			printk(KERN_ERR "Firmware of %s lacks crypto support\n",
+				npe_name(npe_c));
+			return -ENODEV;
+	}
 	ret = init_sa_dir(&ctx->encrypt);
 	if (ret)
 		return ret;
@@ -537,6 +569,10 @@ static int init_tfm(struct crypto_tfm *tfm)
 		free_sa_dir(&ctx->encrypt);
 	}
 	return ret;
+
+npe_error:
+	printk(KERN_ERR "%s not responding\n", npe_name(npe_c));
+	return -EIO;
 }
 
 static int init_tfm_ablk(struct crypto_tfm *tfm)
-- 
1.5.6.3

