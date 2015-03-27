From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 05/20] crypto: mark AES-NI helper ciphers
Date: Fri, 27 Mar 2015 23:52:50 +0100
Message-ID: <3664021.7iPbL1dFhP@tachyon.chronox.de>
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

Flag all AES-NI helper ciphers as internal ciphers to prevent them from
being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 6893f49..f9a78f3 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -797,7 +797,9 @@ static int rfc4106_init(struct crypto_tfm *tfm)
 		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
 	struct crypto_aead *cryptd_child;
 	struct aesni_rfc4106_gcm_ctx *child_ctx;
-	cryptd_tfm = cryptd_alloc_aead("__driver-gcm-aes-aesni", 0, 0);
+	cryptd_tfm = cryptd_alloc_aead("__driver-gcm-aes-aesni",
+				       CRYPTO_ALG_INTERNAL,
+				       CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 
@@ -1262,7 +1264,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__aes-aesni",
 	.cra_driver_name	= "__driver-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER | CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1281,7 +1283,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__ecb-aes-aesni",
 	.cra_driver_name	= "__driver-ecb-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1301,7 +1304,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__cbc-aes-aesni",
 	.cra_driver_name	= "__driver-cbc-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1365,7 +1369,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__ctr-aes-aesni",
 	.cra_driver_name	= "__driver-ctr-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
 				  AESNI_ALIGN - 1,
@@ -1409,7 +1414,7 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__gcm-aes-aesni",
 	.cra_driver_name	= "__driver-gcm-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_AEAD,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
 				  AESNI_ALIGN,
@@ -1479,7 +1484,8 @@ static struct crypto_alg aesni_algs[] = { {
 	.cra_name		= "__lrw-aes-aesni",
 	.cra_driver_name	= "__driver-lrw-aes-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct aesni_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -1500,7 +1506,8 @@ static struct crypto_alg aesni_algs[] = { {
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
