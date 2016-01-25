From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: hash - select CRYPTO_HASH where needed
Date: Mon, 25 Jan 2016 17:51:21 +0100
Message-ID: <1453740685-1980366-1-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ghash and poly1305 hash implementations can be enabled when
CONFIG_CRYPTO_HASH is turned off, causing a link error:

crypto/built-in.o: In function `ghash_mod_init':
(.init.text+0xd0): undefined reference to `crypto_register_shash'
crypto/built-in.o: In function `ghash_mod_exit':
(.exit.text+0xb4): undefined reference to `crypto_unregister_shash'
crypto/built-in.o: In function `poly1305_mod_init':
(.init.text+0xb4): undefined reference to `crypto_register_shash'
crypto/built-in.o: In function `poly1305_mod_exit':
(.exit.text+0x98): undefined reference to `crypto_unregister_shash'

This adds an explicit 'select', like all other hashes have it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 99109b93604a..2d76676a1253 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -472,11 +472,13 @@ config CRYPTO_CRCT10DIF_PCLMUL
 config CRYPTO_GHASH
 	tristate "GHASH digest algorithm"
 	select CRYPTO_GF128MUL
+	select CRYPTO_HASH
 	help
 	  GHASH is message digest algorithm for GCM (Galois/Counter Mode).
 
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
+	select CRYPTO_HASH
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
-- 
2.7.0
