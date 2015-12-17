From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 15/24] crypto: atmel-aes: fix atmel_aes_remove()
Date: Thu, 17 Dec 2015 17:48:46 +0100
Message-ID: <c0dc652dd6f5014d350398a35a041266daf2dfdf.1450366831.git.cyrille.pitchen@atmel.com>
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

Add missing call to atmel_aes_buff_cleanup().

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 68e4177ad61b..343199cfed23 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1469,6 +1469,7 @@ static int atmel_aes_remove(struct platform_device *pdev)
 	tasklet_kill(&aes_dd->queue_task);
 
 	atmel_aes_dma_cleanup(aes_dd);
+	atmel_aes_buff_cleanup(aes_dd);
 
 	return 0;
 }
-- 
1.8.2.2
