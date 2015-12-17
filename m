From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 20/24] crypto: atmel-aes: fix atmel-ctr-aes driver for RFC 3686
Date: Thu, 17 Dec 2015 18:13:04 +0100
Message-ID: <0bdf9a11ed008df03ebf1f03870fe2082bd25401.1450366831.git.cyrille.pitchen@atmel.com>
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

crypto_rfc3686_alloc() in crypto/ctr.c expects to be used with a stream
cipher (alg->cra_blocksize == 1).

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e964cb03cca5..5f6dc48616c0 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1075,7 +1075,7 @@ static struct crypto_alg aes_algs[] = {
 	.cra_driver_name	= "atmel-ctr-aes",
 	.cra_priority		= ATMEL_AES_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
 	.cra_alignmask		= 0xf,
 	.cra_type		= &crypto_ablkcipher_type,
-- 
1.8.2.2
