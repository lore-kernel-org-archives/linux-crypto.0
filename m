From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] crypto: fix typo in KPP dependency of CRYPTO_ECDH
Date: Sun, 26 Nov 2017 00:16:46 +0100
Message-ID: <20171125231646.19042-1-hauke@hauke-m.de>
Cc: linux-crypto@vger.kernel.org, salvatore.benedetto@intel.com,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "# v4 . 8+" <stable@vger.kernel.org>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This fixes a typo in the CRYPTO_KPP dependency of CRYPTO_ECDH.

Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f7911963bb79..9327fbfccf5a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -130,7 +130,7 @@ config CRYPTO_DH
 
 config CRYPTO_ECDH
 	tristate "ECDH algorithm"
-	select CRYTPO_KPP
+	select CRYPTO_KPP
 	select CRYPTO_RNG_DEFAULT
 	help
 	  Generic implementation of the ECDH algorithm
-- 
2.11.0
