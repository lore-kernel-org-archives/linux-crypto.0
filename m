From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 1/2] crypto: twofish - disable AVX2 implementation
Date: Sun, 02 Jun 2013 19:51:47 +0300
Message-ID: <20130602165147.25743.88831.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:38242 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3FBQ7h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Jun 2013 12:59:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It appears that the performance of 'vpgatherdd' is suboptimal for this kind of
workload (tested on Core i5-4570) and causes twofish_avx2 to be significantly
slower than twofish_avx. So disable the AVX2 implementation to avoid
performance regressions.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index d1ca631..678a6ed 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1318,6 +1318,7 @@ config CRYPTO_TWOFISH_AVX_X86_64
 config CRYPTO_TWOFISH_AVX2_X86_64
 	tristate "Twofish cipher algorithm (x86_64/AVX2)"
 	depends on X86 && 64BIT
+	depends on BROKEN
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
