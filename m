From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 03/16] crypto: mark AES-NI helper ciphers
Date: Thu, 19 Mar 2015 07:59:04 +0100
Message-ID: <12301842.nfai4W14Rh@tachyon.chronox.de>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21952258.n2qYaab1Is@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Flag all AES-NI helper ciphers as internal ciphers to prevent them from
being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 6893f49..3d10a84 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1262,7 +1262,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__aes-aesni",
 	.cra_driver_name	= "__driver-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER | CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1281,7 +1281,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__ecb-aes-aesni",
 	.cra_driver_name	= "__driver-ecb-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1301,7 +1302,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__cbc-aes-aesni",
 	.cra_driver_name	= "__driver-cbc-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1365,7 +1367,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__ctr-aes-aesni",
 	.cra_driver_name	= "__driver-ctr-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1409,7 +1412,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__gcm-aes-aesni",
 	.cra_driver_name	= "__driver-gcm-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_AEAD,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
 				  AESNI_ALIGN,
@@ -1479,7 +1482,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__lrw-aes-aesni",
 	.cra_driver_name	= "__driver-lrw-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct aesni_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -1500,7 +1504,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__xts-aes-aesni",
 	.cra_driver_name	= "__driver-xts-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct aesni_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
