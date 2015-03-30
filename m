From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 11/20] crypto: mark CAST6 helper ciphers
Date: Mon, 30 Mar 2015 22:05:35 +0200
Message-ID: <2660913.jnV6zmVAxD@tachyon.chronox.de>
References: <3417827.fluZli1WvQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39583 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbbC3UIJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 16:08:09 -0400
In-Reply-To: <3417827.fluZli1WvQ@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
