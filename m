From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 17/20] crypto: mark ARMv8 AES helper ciphers
Date: Sat, 28 Mar 2015 00:00:02 +0100
Message-ID: <2637531.YSkNFdGsKx@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Flag all ARMv8 AES helper ciphers as internal ciphers to prevent
them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm/crypto/aes-ce-glue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index d2ee591..b445a5d 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -354,7 +354,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__ecb-aes-ce",
 	.cra_driver_name	= "__driver-ecb-aes-ce",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		= 7,
@@ -372,7 +373,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__cbc-aes-ce",
 	.cra_driver_name	= "__driver-cbc-aes-ce",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		= 7,
@@ -390,7 +392,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__ctr-aes-ce",
 	.cra_driver_name	= "__driver-ctr-aes-ce",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		= 7,
@@ -408,7 +411,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__xts-aes-ce",
 	.cra_driver_name	= "__driver-xts-aes-ce",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
 	.cra_alignmask		= 7,
-- 
2.1.0
