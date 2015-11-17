From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 2/3] crypto-ixp4xx: Reduce assignment for a variable in
 init_ixp_crypto()
Date: Tue, 17 Nov 2015 16:45:35 +0100
Message-ID: <564B4B9F.9050106@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <5648D2C1.8050603@users.sourceforge.net>
 <564B489F.10308@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564B489F.10308@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 17 Nov 2015 15:45:32 +0100

The variable "ret" was set more often than necessary by the
init_ixp_crypto() function.

* Omit its initialisation at the beginning.

* Use an error return code in two cases directly.

* Improve compliance with the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/ixp4xx_crypto.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index e52496a..79b6958 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -433,17 +433,17 @@ static void crypto_done_action(unsigned long arg)
 
 static int init_ixp_crypto(struct device *dev)
 {
-	int ret = -ENODEV;
+	int ret;
 	u32 msg[2] = { 0, 0 };
 
 	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
 				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
 		printk(KERN_ERR "ixp_crypto: No HW crypto available\n");
-		return ret;
+		return -ENODEV;
 	}
 	npe_c = npe_request(NPE_ID);
 	if (!npe_c)
-		return ret;
+		return -ENODEV;
 
 	if (!npe_running(npe_c)) {
 		ret = npe_load_firmware(npe_c, npe_name(npe_c), dev);
@@ -481,13 +481,14 @@ static int init_ixp_crypto(struct device *dev)
 	BUILD_BUG_ON(SHA1_DIGEST_SIZE > sizeof(struct buffer_desc));
 	buffer_pool = dma_pool_create("buffer", dev,
 			sizeof(struct buffer_desc), 32, 0);
-	ret = -ENOMEM;
 	if (!buffer_pool) {
+		ret = -ENOMEM;
 		goto err;
 	}
 	ctx_pool = dma_pool_create("context", dev,
 			NPE_CTX_LEN, 16, 0);
 	if (!ctx_pool) {
+		ret = -ENOMEM;
 		goto err;
 	}
 	ret = qmgr_request_queue(SEND_QID, NPE_QLEN_TOTAL, 0, 0,
-- 
2.6.2
