From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 16/20] crypto: mark NEON bit sliced AES helper ciphers
Date: Mon, 30 Mar 2015 22:09:27 +0200
Message-ID: <6209761.uITzfNyU61@tachyon.chronox.de>
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

Flag all NEON bit sliced AES helper ciphers as internal ciphers to
prevent them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm/crypto/aesbs-glue.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/aesbs-glue.c b/arch/arm/crypto/aesbs-glue.c
index 15468fb..6d68529 100644
--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -301,7 +301,8 @@ static struct crypto_alg aesbs_algs[] = { {
 	.cra_name		= "__cbc-aes-neonbs",
 	.cra_driver_name	= "__driver-cbc-aes-neonbs",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct aesbs_cbc_ctx),
 	.cra_alignmask		= 7,
@@ -319,7 +320,8 @@ static struct crypto_alg aesbs_algs[] = { {
 	.cra_name		= "__ctr-aes-neonbs",
 	.cra_driver_name	= "__driver-ctr-aes-neonbs",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct aesbs_ctr_ctx),
 	.cra_alignmask		= 7,
@@ -337,7 +339,8 @@ static struct crypto_alg aesbs_algs[] = { {
 	.cra_name		= "__xts-aes-neonbs",
 	.cra_driver_name	= "__driver-xts-aes-neonbs",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct aesbs_xts_ctx),
 	.cra_alignmask		= 7,
-- 
2.1.0
