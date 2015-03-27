From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 18/20] crypto: mark 64 bit ARMv8 AES helper ciphers
Date: Sat, 28 Mar 2015 00:00:48 +0100
Message-ID: <2028591.SejLJeA2Mz@tachyon.chronox.de>
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

Flag all 64 bit ARMv8 AES helper ciphers as internal ciphers to
prevent them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm64/crypto/aes-glue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index b1b5b89..05d9e16 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -284,7 +284,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__ecb-aes-" MODE,
 	.cra_driver_name	= "__driver-ecb-aes-" MODE,
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		= 7,
@@ -302,7 +303,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__cbc-aes-" MODE,
 	.cra_driver_name	= "__driver-cbc-aes-" MODE,
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		= 7,
@@ -320,7 +322,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__ctr-aes-" MODE,
 	.cra_driver_name	= "__driver-ctr-aes-" MODE,
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_alignmask		= 7,
@@ -338,7 +341,8 @@ static struct crypto_alg aes_algs[] = { {
 	.cra_name		= "__xts-aes-" MODE,
 	.cra_driver_name	= "__driver-xts-aes-" MODE,
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
 	.cra_alignmask		= 7,
-- 
2.1.0
