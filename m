From: Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH 2/2] crypto: atmel-aes - Reset the controller before each use
Date: Tue, 31 Oct 2017 16:25:24 +0100
Message-ID: <20171031152524.25216-3-romain.izard.pro@gmail.com>
References: <20171031152524.25216-1-romain.izard.pro@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Romain Izard <romain.izard.pro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171031152524.25216-1-romain.izard.pro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When using the rfc4543(gcm(aes))) mode, the registers of the hardware
engine are not empty after use. If the engine is not reset before its
next use, the following results will be invalid.

Always reset the hardware engine.

Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
---
 drivers/crypto/atmel-aes.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 53432ab97d7e..024914e82734 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -76,12 +76,11 @@
 				 AES_FLAGS_ENCRYPT |		\
 				 AES_FLAGS_GTAGEN)
 
-#define AES_FLAGS_INIT		BIT(2)
 #define AES_FLAGS_BUSY		BIT(3)
 #define AES_FLAGS_DUMP_REG	BIT(4)
 #define AES_FLAGS_OWN_SHA	BIT(5)
 
-#define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
+#define AES_FLAGS_PERSISTENT	AES_FLAGS_BUSY
 
 #define ATMEL_AES_QUEUE_LENGTH	50
 
@@ -450,11 +449,8 @@ static int atmel_aes_hw_init(struct atmel_aes_dev *dd)
 	if (err)
 		return err;
 
-	if (!(dd->flags & AES_FLAGS_INIT)) {
-		atmel_aes_write(dd, AES_CR, AES_CR_SWRST);
-		atmel_aes_write(dd, AES_MR, 0xE << AES_MR_CKEY_OFFSET);
-		dd->flags |= AES_FLAGS_INIT;
-	}
+	atmel_aes_write(dd, AES_CR, AES_CR_SWRST);
+	atmel_aes_write(dd, AES_MR, 0xE << AES_MR_CKEY_OFFSET);
 
 	return 0;
 }
-- 
2.14.1
