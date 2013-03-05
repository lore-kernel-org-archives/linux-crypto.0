From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] crypto: caam - fix typo "CRYPTO_AHASH"
Date: Tue, 05 Mar 2013 14:33:16 +0100
Message-ID: <1362490396.16460.87.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Kconfig entry for CAAM's hash algorithm implementations has always
selected CRYPTO_AHASH. But there's no corresponding Kconfig symbol.

It seems it was intended to select CRYPTO_HASH, like other crypto
drivers do. That would apparently (indirectly) select CRYPTO_HASH2,
which would enable the ahash functionality this driver uses.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested!

1) Apparently, one can indirectly select a Kconfig symbol. That actually
surprised me. But if the kconfig parser does not work this way this
patch (and it's explanation) is bogus.

 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 65c7668..b44091c 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -78,7 +78,7 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
 	tristate "Register hash algorithm implementations with Crypto API"
 	depends on CRYPTO_DEV_FSL_CAAM
 	default y
-	select CRYPTO_AHASH
+	select CRYPTO_HASH
 	help
 	  Selecting this will offload ahash for users of the
 	  scatterlist crypto API to the SEC4 via job ring.
-- 
1.7.11.7
