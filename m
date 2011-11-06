From: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
Subject: [PATCH] crypto: Small spelling correction for Kconfig CRYPTO_USER
Date: Sun,  6 Nov 2011 10:41:44 +0100
Message-ID: <c9c19b031b97c43a545514347c744c41365d8b90.1320572454.git.joerg@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:1545 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1KFKQm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 Nov 2011 05:16:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: J=C3=B6rg Sommer <joerg@alea.gnuu.de>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 527a857..733208f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -105,7 +105,7 @@ config CRYPTO_USER
 	depends on NET
 	select CRYPTO_MANAGER
 	help
-	  Userapace configuration for cryptographic instantiations such as
+	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
=20
 config CRYPTO_MANAGER_DISABLE_TESTS
--=20
1.7.7.1
