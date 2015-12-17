From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 06/24] crypto: atmel-aes: propagate error from atmel_aes_hw_version_init()
Date: Thu, 17 Dec 2015 17:48:37 +0100
Message-ID: <dea22778fbf867b60208b3b8fcf7230170cda6a3.1450366831.git.cyrille.pitchen@atmel.com>
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

Before this patch atmel_aes_hw_version_init() had no returned value.
However it calls atmel_aes_hw_init(), which may fail. So check the
returned code of atmel_aes_hw_init() and propagate error if needed.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 7d1b055811c4..9a9e1b88a384 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -280,16 +280,20 @@ static inline unsigned int atmel_aes_get_version(struct atmel_aes_dev *dd)
 	return atmel_aes_read(dd, AES_HW_VERSION) & 0x00000fff;
 }
 
-static void atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
+static int atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
 {
-	atmel_aes_hw_init(dd);
+	int err;
+
+	err = atmel_aes_hw_init(dd);
+	if (err)
+		return err;
 
 	dd->hw_version = atmel_aes_get_version(dd);
 
-	dev_info(dd->dev,
-			"version: 0x%x\n", dd->hw_version);
+	dev_info(dd->dev, "version: 0x%x\n", dd->hw_version);
 
 	clk_disable_unprepare(dd->iclk);
+	return 0;
 }
 
 static void atmel_aes_finish_req(struct atmel_aes_dev *dd, int err)
@@ -1407,7 +1411,9 @@ static int atmel_aes_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
-	atmel_aes_hw_version_init(aes_dd);
+	err = atmel_aes_hw_version_init(aes_dd);
+	if (err)
+		goto res_err;
 
 	atmel_aes_get_cap(aes_dd);
 
-- 
1.8.2.2
