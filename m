From: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Subject: [PATCH 2/2] crypto: s5p-sss - Use memcpy_toio for iomem annotated memory
Date: Mon, 11 Jan 2016 20:45:51 +0900
Message-ID: <1452512751-4084-2-git-send-email-k.kozlowski.k@gmail.com>
References: <1452512751-4084-1-git-send-email-k.kozlowski.k@gmail.com>
Cc: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452512751-4084-1-git-send-email-k.kozlowski.k@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use memcpy_toio to fix following sparse warning:

drivers/crypto/s5p-sss.c:386:40: warning: incorrect type in argument 1 (different address spaces)
drivers/crypto/s5p-sss.c:386:40:    expected void *<noident>
drivers/crypto/s5p-sss.c:386:40:    got void [noderef] <asn:2>*

Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
---
 drivers/crypto/s5p-sss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index e10284744fd2..5f161a9777e3 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -383,7 +383,7 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	void __iomem *keystart;
 
 	if (iv)
-		memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+		memcpy_toio(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
@@ -392,7 +392,7 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	else
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(4);
 
-	memcpy(keystart, key, keylen);
+	memcpy_toio(keystart, key, keylen);
 }
 
 static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
-- 
2.1.4
