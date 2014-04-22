From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 1/2] crypto: atmel-aes: correct block size of cfb8 mode
Date: Tue, 22 Apr 2014 15:23:23 +0800
Message-ID: <1398151404-23408-2-git-send-email-leilei.zhao@atmel.com>
References: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas@eukrea.com>, <nicolas.ferre@atmel.com>,
	<leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1398151404-23408-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The block size of aes cfb8 mode shoule be 8 bit.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
---
 drivers/crypto/atmel-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index d7c9e31..12628a7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1069,7 +1069,7 @@ static struct crypto_alg aes_algs[] = {
 	.cra_driver_name	= "atmel-cfb8-aes",
 	.cra_priority		= 100,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize		= CFB64_BLOCK_SIZE,
+	.cra_blocksize		= CFB8_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct atmel_aes_ctx),
 	.cra_alignmask		= 0x0,
 	.cra_type		= &crypto_ablkcipher_type,
-- 
1.7.9.5
