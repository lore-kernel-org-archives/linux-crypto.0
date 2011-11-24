From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: serpent-sse2 - should select CRYPTO_CRYPTD
Date: Thu, 24 Nov 2011 08:37:41 +0200
Message-ID: <20111124063741.17986.23462.stgit@localhost6.localdomain6>
References: <4ECD527E.8000506@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	linux-next@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	LKML <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:54258 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1KXGhp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Nov 2011 01:37:45 -0500
In-Reply-To: <4ECD527E.8000506@xenotime.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since serpent_sse2_glue.c uses cryptd, CRYPTO_SERPENT_SSE2_X86_64 and
CRYPTO_SERPENT_SSE2_586 should be selecting CRYPTO_CRYPTD.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 16e0c13..b8d1b10 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -770,6 +770,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	tristate "Serpent cipher algorithm (x86_64/SSE2)"
 	depends on X86 && 64BIT
 	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
 	select CRYPTO_SERPENT
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
@@ -787,6 +788,7 @@ config CRYPTO_SERPENT_SSE2_586
 	tristate "Serpent cipher algorithm (i586/SSE2)"
 	depends on X86 && !64BIT
 	select CRYPTO_ALGAPI
+	select CRYPTO_CRYPTD
 	select CRYPTO_SERPENT
 	help
 	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
