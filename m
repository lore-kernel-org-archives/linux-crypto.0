From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 15/20] crypto: mark Twofish AVX helper ciphers
Date: Fri, 27 Mar 2015 23:58:38 +0100
Message-ID: <2841739.EUoOT9A2qi@tachyon.chronox.de>
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

Flag all Twofish AVX helper ciphers as internal ciphers to prevent
them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/twofish_avx_glue.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 1ac531e..b5e2d56 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -340,7 +340,8 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_name		= "__ecb-twofish-avx",
 	.cra_driver_name	= "__driver-ecb-twofish-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= TF_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct twofish_ctx),
 	.cra_alignmask		= 0,
@@ -359,7 +360,8 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_name		= "__cbc-twofish-avx",
 	.cra_driver_name	= "__driver-cbc-twofish-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= TF_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct twofish_ctx),
 	.cra_alignmask		= 0,
@@ -378,7 +380,8 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_name		= "__ctr-twofish-avx",
 	.cra_driver_name	= "__driver-ctr-twofish-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct twofish_ctx),
 	.cra_alignmask		= 0,
@@ -398,7 +401,8 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_name		= "__lrw-twofish-avx",
 	.cra_driver_name	= "__driver-lrw-twofish-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= TF_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct twofish_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -421,7 +425,8 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_name		= "__xts-twofish-avx",
 	.cra_driver_name	= "__driver-xts-twofish-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= TF_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct twofish_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
