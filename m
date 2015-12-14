From: "Pathak, Rahul (R.)" <rpathak@visteon.com>
Subject: [PATCH 2/2] crypto: omap-aes,omap-des: Removed unused variable "err"
Date: Mon, 14 Dec 2015 08:45:23 +0000
Message-ID: <20151214084517.GA8751@visteon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <930EB13A8BC92A48B985757CB53E5398@eurprd06.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rahul Pathak <rpathak@visteon.com>

Removed unused variable "err" and directly return "0"

Reported by coccicheck -
./drivers/crypto/omap-aes.c:542:5-8: Unneeded variable: "err". Return "0" on line 551
./drivers/crypto/omap-des.c:530:5-8: Unneeded variable: "err". Return "0" on line 539

Signed-off-by: Rahul Pathak <rpathak@visteon.com>
---
 drivers/crypto/omap-aes.c | 4 +---
 drivers/crypto/omap-des.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index eba2314..dd355bd 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -539,8 +539,6 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 {
-	int err = 0;
-
 	pr_debug("total: %d\n", dd->total);
 
 	omap_aes_dma_stop(dd);
@@ -548,7 +546,7 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 	dmaengine_terminate_all(dd->dma_lch_in);
 	dmaengine_terminate_all(dd->dma_lch_out);
 
-	return err;
+	return 0;
 }
 
 static int omap_aes_check_aligned(struct scatterlist *sg, int total)
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 0a70e46..a95ee4f 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -527,8 +527,6 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 
 static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
 {
-	int err = 0;
-
 	pr_debug("total: %d\n", dd->total);
 
 	omap_des_dma_stop(dd);
@@ -536,7 +534,7 @@ static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
 	dmaengine_terminate_all(dd->dma_lch_in);
 	dmaengine_terminate_all(dd->dma_lch_out);
 
-	return err;
+	return 0;
 }
 
 static int omap_des_copy_needed(struct scatterlist *sg)
-- 
1.9.1
