From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 07/16] crypto: mark CAST6 helper ciphers
Date: Thu, 19 Mar 2015 08:01:34 +0100
Message-ID: <8919466.NiWs4XAAvc@tachyon.chronox.de>
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

Flag all CAST6 helper ciphers as internal ciphers to prevent them
from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/cast6_avx_glue.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 0160f68..f448810 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -372,7 +372,8 @@ static struct crypto_alg cast6_algs[10] = { {
 	.cra_name		= "__ecb-cast6-avx",
 	.cra_driver_name	= "__driver-ecb-cast6-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAST6_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast6_ctx),
 	.cra_alignmask		= 0,
@@ -391,7 +392,8 @@ static struct crypto_alg cast6_algs[10] = { {
 	.cra_name		= "__cbc-cast6-avx",
 	.cra_driver_name	= "__driver-cbc-cast6-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAST6_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast6_ctx),
 	.cra_alignmask		= 0,
@@ -410,7 +412,8 @@ static struct crypto_alg cast6_algs[10] = { {
 	.cra_name		= "__ctr-cast6-avx",
 	.cra_driver_name	= "__driver-ctr-cast6-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct cast6_ctx),
 	.cra_alignmask		= 0,
@@ -430,7 +433,8 @@ static struct crypto_alg cast6_algs[10] = { {
 	.cra_name		= "__lrw-cast6-avx",
 	.cra_driver_name	= "__driver-lrw-cast6-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAST6_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast6_lrw_ctx),
 	.cra_alignmask		= 0,
@@ -453,7 +457,8 @@ static struct crypto_alg cast6_algs[10] = { {
 	.cra_name		= "__xts-cast6-avx",
 	.cra_driver_name	= "__driver-xts-cast6-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAST6_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast6_xts_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
