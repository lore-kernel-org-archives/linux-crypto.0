From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 12/16] crypto: mark Twofish AVX helper ciphers
Date: Thu, 19 Mar 2015 08:04:27 +0100
Message-ID: <9207118.9aZ0nu436e@tachyon.chronox.de>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46745 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbbCSHLE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 03:11:04 -0400
In-Reply-To: <21952258.n2qYaab1Is@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
