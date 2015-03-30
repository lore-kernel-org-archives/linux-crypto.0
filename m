From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 13/20] crypto: mark Serpent AVX helper ciphers
Date: Mon, 30 Mar 2015 22:07:05 +0200
Message-ID: <3809491.8663rLpNxe@tachyon.chronox.de>
References: <3417827.fluZli1WvQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3417827.fluZli1WvQ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Flag all Serpent AVX helper ciphers as internal ciphers to prevent
them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/serpent_avx_glue.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 7e21739..c8d478a 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -378,7 +378,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__ecb-serpent-avx",
 	.cra_driver_name	= "__driver-ecb-serpent-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -397,7 +398,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__cbc-serpent-avx",
 	.cra_driver_name	= "__driver-cbc-serpent-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -416,7 +418,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__ctr-serpent-avx",
 	.cra_driver_name	= "__driver-ctr-serpent-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -436,7 +439,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__lrw-serpent-avx",
 	.cra_driver_name	= "__driver-lrw-serpent-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -459,7 +463,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__xts-serpent-avx",
 	.cra_driver_name	= "__driver-xts-serpent-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
