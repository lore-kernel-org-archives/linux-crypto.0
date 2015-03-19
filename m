From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 15/16] crypto: mark GHASH ARMv8 vmull.p64 helper ciphers
Date: Thu, 19 Mar 2015 08:06:11 +0100
Message-ID: <3244898.RTNRNmndv4@tachyon.chronox.de>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46740 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbbCSHLA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 03:11:00 -0400
In-Reply-To: <21952258.n2qYaab1Is@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Flag all GHASH ARMv8 vmull.p64 helper ciphers as internal ciphers
to prevent them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm/crypto/ghash-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 8c959d1..9960aed 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -141,7 +141,7 @@ static struct shash_alg ghash_alg = {
 		.cra_name	= "ghash",
 		.cra_driver_name = "__driver-ghash-ce",
 		.cra_priority	= 0,
-		.cra_flags	= CRYPTO_ALG_TYPE_SHASH,
+		.cra_flags	= CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_INTERNAL,
 		.cra_blocksize	= GHASH_BLOCK_SIZE,
 		.cra_ctxsize	= sizeof(struct ghash_key),
 		.cra_module	= THIS_MODULE,
-- 
2.1.0
