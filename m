From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 09/24] crypto: atmel-aes: remove useless write in the Control Register
Date: Thu, 17 Dec 2015 17:48:40 +0100
Message-ID: <1ace62ded06cbf4992e92aa3c3453b01054f56f4.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

As claimed by the datasheet, writing 0 into the Control Register has no
effet. So we remove this useless register access.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 48407a7f6f61..f1ea9c893561 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -511,7 +511,7 @@ static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 				 const u32 *iv)
 {
-	u32 valcr = 0, valmr = 0;
+	u32 valmr = 0;
 
 	/* MR register must be set before IV registers */
 	if (dd->ctx->keylen == AES_KEYSIZE_128)
@@ -554,7 +554,6 @@ static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 		valmr |= AES_MR_SMOD_AUTO;
 	}
 
-	atmel_aes_write(dd, AES_CR, valcr);
 	atmel_aes_write(dd, AES_MR, valmr);
 
 	atmel_aes_write_n(dd, AES_KEYWR(0), dd->ctx->key,
-- 
1.8.2.2
