From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 06/16] crypto: mark AVX Camellia helper ciphers
Date: Thu, 19 Mar 2015 08:00:45 +0100
Message-ID: <2554610.Db7dJZEiWq@tachyon.chronox.de>
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

Flag all AVX Camellia helper ciphers as internal ciphers to prevent
them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/camellia_aesni_avx_glue.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index ed38d95..78818a1 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -335,7 +335,8 @@ static struct crypto_alg cmll_algs[10] = { {
 	.cra_name		= "__ecb-camellia-aesni",
 	.cra_driver_name	= "__driver-ecb-camellia-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_ctx),
 	.cra_alignmask		= 0,
@@ -354,7 +355,8 @@ static struct crypto_alg cmll_algs[10] = { {
 	.cra_name		= "__cbc-camellia-aesni",
 	.cra_driver_name	= "__driver-cbc-camellia-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_ctx),
 	.cra_alignmask		= 0,
@@ -373,7 +375,8 @@ static struct crypto_alg cmll_algs[10] = { {
 	.cra_name		= "__ctr-camellia-aesni",
 	.cra_driver_name	= "__driver-ctr-camellia-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct camellia_ctx),
 	.cra_alignmask		= 0,
@@ -393,7 +396,8 @@ static struct crypto_alg cmll_algs[10] = { {
 	.cra_name		= "__lrw-camellia-aesni",
 	.cra_driver_name	= "__driver-lrw-camellia-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -416,7 +420,8 @@ static struct crypto_alg cmll_algs[10] = { {
 	.cra_name		= "__xts-camellia-aesni",
 	.cra_driver_name	= "__driver-xts-camellia-aesni",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
