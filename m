From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 09/20] crypto: mark CAST5 helper ciphers
Date: Fri, 27 Mar 2015 23:55:12 +0100
Message-ID: <3148039.MhEL5pH0Yj@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46773 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbbC0XFd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2015 19:05:33 -0400
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Flag all CAST5 helper ciphers as internal ciphers to prevent them
from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/cast5_avx_glue.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index 60ada67..236c809 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -341,7 +341,8 @@ static struct crypto_alg cast5_algs[6] = { {
 	.cra_name		= "__ecb-cast5-avx",
 	.cra_driver_name	= "__driver-ecb-cast5-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAST5_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast5_ctx),
 	.cra_alignmask		= 0,
@@ -360,7 +361,8 @@ static struct crypto_alg cast5_algs[6] = { {
 	.cra_name		= "__cbc-cast5-avx",
 	.cra_driver_name	= "__driver-cbc-cast5-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= CAST5_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast5_ctx),
 	.cra_alignmask		= 0,
@@ -379,7 +381,8 @@ static struct crypto_alg cast5_algs[6] = { {
 	.cra_name		= "__ctr-cast5-avx",
 	.cra_driver_name	= "__driver-ctr-cast5-avx",
 	.cra_priority		= 0,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
+				  CRYPTO_ALG_INTERNAL,
 	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct cast5_ctx),
 	.cra_alignmask		= 0,
-- 
2.1.0
