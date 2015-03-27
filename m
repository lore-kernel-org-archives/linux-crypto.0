From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 14/20] crypto: mark Serpent SSE2 helper ciphers
Date: Fri, 27 Mar 2015 23:57:57 +0100
Message-ID: <4977630.JRnifKaEc6@tachyon.chronox.de>
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

Flag all Serpent SSE2 helper ciphers as internal ciphers to prevent
them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/serpent_sse2_glue.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index bf025ad..3643dd5 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -387,7 +387,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__ecb-serpent-sse2",
 	.cra_driver_name	= "__driver-ecb-serpent-sse2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -406,7 +407,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__cbc-serpent-sse2",
 	.cra_driver_name	= "__driver-cbc-serpent-sse2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -425,7 +427,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__ctr-serpent-sse2",
 	.cra_driver_name	= "__driver-ctr-serpent-sse2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct serpent_ctx),
 	.cra_alignmask		= 0,
@@ -445,7 +448,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__lrw-serpent-sse2",
 	.cra_driver_name	= "__driver-lrw-serpent-sse2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -468,7 +472,8 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_name		= "__xts-serpent-sse2",
 	.cra_driver_name	= "__driver-xts-serpent-sse2",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct serpent_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
