From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] crypto: public_key: select CRYPTO_AKCIPHER
Date: Wed, 18 May 2016 16:55:56 +0200
Message-ID: <1463583366-1689248-1-git-send-email-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:54874 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbcERO4f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 10:56:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In some rare randconfig builds, we can end up with
ASYMMETRIC_PUBLIC_KEY_SUBTYPE enabled but CRYPTO_AKCIPHER disabled,
which fails to link because of the reference to crypto_alloc_akcipher:

crypto/built-in.o: In function `public_key_verify_signature':
:(.text+0x110e4): undefined reference to `crypto_alloc_akcipher'

This adds a Kconfig 'select' statement to ensure the dependency
is always there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use CRYPTO_AKCIPHER instead of CRYPTO_AKCIPHER2
 crypto/asymmetric_keys/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index e28e912000a7..331f6baf2df8 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -13,6 +13,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	tristate "Asymmetric public-key crypto algorithm subtype"
 	select MPILIB
 	select CRYPTO_HASH_INFO
+	select CRYPTO_AKCIPHER
 	help
 	  This option provides support for asymmetric public key type handling.
 	  If signature generation and/or verification are to be used,
-- 
2.7.0
