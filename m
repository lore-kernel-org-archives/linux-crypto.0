From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 08/16] crypto: mark ghash clmulni helper ciphers
Date: Thu, 19 Mar 2015 08:02:06 +0100
Message-ID: <2221181.Oy4pVhI2rv@tachyon.chronox.de>
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

Flag all ash clmulni helper ciphers as internal ciphers to prevent them
from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 8253d85..d4cd17d 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -154,7 +154,8 @@ static struct shash_alg ghash_alg = {
 		.cra_name		= "__ghash",
 		.cra_driver_name	= "__ghash-pclmulqdqni",
 		.cra_priority		= 0,
-		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH |
+					  CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct ghash_ctx),
 		.cra_module		= THIS_MODULE,
-- 
2.1.0
