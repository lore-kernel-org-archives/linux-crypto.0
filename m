From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/2] crypto: blowfish - disable AVX2 implementation
Date: Sun, 02 Jun 2013 19:51:52 +0300
Message-ID: <20130602165152.25743.90142.stgit@localhost6.localdomain6>
References: <20130602165147.25743.88831.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:38806 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab3FBQ5s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Jun 2013 12:57:48 -0400
In-Reply-To: <20130602165147.25743.88831.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It appears that the performance of 'vpgatherdd' is suboptimal for this kind of
workload (tested on Core i5-4570) and causes blowfish-avx2 to be significantly
slower than blowfish-amd64. So disable the AVX2 implementation to avoid
performance regressions.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 678a6ed..8ca52c5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -842,6 +842,7 @@ config CRYPTO_BLOWFISH_X86_64
 config CRYPTO_BLOWFISH_AVX2_X86_64
 	tristate "Blowfish cipher algorithm (x86_64/AVX2)"
 	depends on X86 && 64BIT
+	depends on BROKEN
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
