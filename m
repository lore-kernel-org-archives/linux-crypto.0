From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 12/20] crypto: mark Serpent AVX2 helper ciphers
Date: Mon, 30 Mar 2015 22:06:13 +0200
Message-ID: <1837318.P7A9y7EGFY@tachyon.chronox.de>
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

Flag all Serpent AVX2 helper ciphers as internal ciphers to prevent
them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/serpent_avx2_glue.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 437e47a..2f63dc8 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -309,7 +309,8 @@ static struct crypto_alg srp_algs[10] = { {
 	.cra_name		= "__ecb-serpent-avx2",
 	.cra_driver_name	= "__driver-ecb-serpent-avx2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -329,7 +330,8 @@ static struct crypto_alg srp_algs[10] = { {
 	.cra_name		= "__cbc-serpent-avx2",
 	.cra_driver_name	= "__driver-cbc-serpent-avx2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -349,7 +351,8 @@ static struct crypto_alg srp_algs[10] = { {
 	.cra_name		= "__ctr-serpent-avx2",
 	.cra_driver_name	= "__driver-ctr-serpent-avx2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -370,7 +373,8 @@ static struct crypto_alg srp_algs[10] = { {
 	.cra_name		= "__lrw-serpent-avx2",
 	.cra_driver_name	= "__driver-lrw-serpent-avx2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -394,7 +398,8 @@ static struct crypto_alg srp_algs[10] = { {
 	.cra_name		= "__xts-serpent-avx2",
 	.cra_driver_name	= "__driver-xts-serpent-avx2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
