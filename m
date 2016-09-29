From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/1] crypto: atmel-aes: fix compiler error when VERBOSE_DEBUG is defined
Date: Thu, 29 Sep 2016 18:46:57 +0200
Message-ID: <605a4f64ee501aeaffbd43b7b45fd9b3d997bd7b.1475167206.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>, <levent.demir@inria.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes a compiler error when VERBOSE_DEBUG is defined. Indeed,
in atmel_aes_write(), the 3rd argument of atmel_aes_reg_name() was
missing.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Reported-by: Levent Demir <levent.demir@inria.fr>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e3d40a8dfffb..1d9e7bd3f377 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -317,7 +317,7 @@ static inline void atmel_aes_write(struct atmel_aes_dev *dd,
 		char tmp[16];
 
 		dev_vdbg(dd->dev, "write 0x%08x into %s\n", value,
-			 atmel_aes_reg_name(offset, tmp));
+			 atmel_aes_reg_name(offset, tmp, sizeof(tmp)));
 	}
 #endif /* VERBOSE_DEBUG */
 
-- 
2.7.4
