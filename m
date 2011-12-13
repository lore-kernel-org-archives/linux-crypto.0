From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 5/7] crypto - serpent-sse2: select LRW and XTS
Date: Tue, 13 Dec 2011 12:53:12 +0200
Message-ID: <20111213105312.14934.47362.stgit@localhost6.localdomain6>
References: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51456 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LMKxO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:53:14 -0500
In-Reply-To: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

serpent-sse2 uses functions from LRW and XTS modules, so selecting would appear
to be better option than using #ifdefs in serpent_sse2_glue.c to enable/disable
LRW and XTS features.

This also fixes build problem when serpent-sse2 would be build into kernel but
XTS/LRW are build as modules.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3cd303b..d7d4d4e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -770,6 +770,8 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_SERPENT
+	select CRYPTO_LRW
+	select CRYPTO_XTS
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
 
@@ -788,6 +790,8 @@ config CRYPTO_SERPENT_SSE2_586
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_SERPENT
+	select CRYPTO_LRW
+	select CRYPTO_XTS
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
 
