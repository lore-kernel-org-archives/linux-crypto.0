From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 7/7] crypto: octeon - enable OCTEON SHA1/256/512 module selection
Date: Sun,  8 Mar 2015 22:07:47 +0200
Message-ID: <1425845267-14413-8-git-send-email-aaro.koskinen@iki.fi>
References: <1425845267-14413-1-git-send-email-aaro.koskinen@iki.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
	Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:59864 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbCHUIE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 16:08:04 -0400
In-Reply-To: <1425845267-14413-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable user to select OCTEON SHA1/256/512 modules.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 crypto/Kconfig | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 50f4da4..38b2315 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -546,6 +546,15 @@ config CRYPTO_SHA512_SSSE3
 	  Extensions version 1 (AVX1), or Advanced Vector Extensions
 	  version 2 (AVX2) instructions, when available.
 
+config CRYPTO_SHA1_OCTEON
+	tristate "SHA1 digest algorithm (OCTEON)"
+	depends on CPU_CAVIUM_OCTEON
+	select CRYPTO_SHA1
+	select CRYPTO_HASH
+	help
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using OCTEON crypto instructions, when available.
+
 config CRYPTO_SHA1_SPARC64
 	tristate "SHA1 digest algorithm (SPARC64)"
 	depends on SPARC64
@@ -610,6 +619,15 @@ config CRYPTO_SHA256
 	  This code also includes SHA-224, a 224 bit hash with 112 bits
 	  of security against collision attacks.
 
+config CRYPTO_SHA256_OCTEON
+	tristate "SHA224 and SHA256 digest algorithm (OCTEON)"
+	depends on CPU_CAVIUM_OCTEON
+	select CRYPTO_SHA256
+	select CRYPTO_HASH
+	help
+	  SHA-256 secure hash standard (DFIPS 180-2) implemented
+	  using OCTEON crypto instructions, when available.
+
 config CRYPTO_SHA256_SPARC64
 	tristate "SHA224 and SHA256 digest algorithm (SPARC64)"
 	depends on SPARC64
@@ -631,6 +649,15 @@ config CRYPTO_SHA512
 	  This code also includes SHA-384, a 384 bit hash with 192 bits
 	  of security against collision attacks.
 
+config CRYPTO_SHA512_OCTEON
+	tristate "SHA384 and SHA512 digest algorithms (OCTEON)"
+	depends on CPU_CAVIUM_OCTEON
+	select CRYPTO_SHA512
+	select CRYPTO_HASH
+	help
+	  SHA-512 secure hash standard (DFIPS 180-2) implemented
+	  using OCTEON crypto instructions, when available.
+
 config CRYPTO_SHA512_SPARC64
 	tristate "SHA384 and SHA512 digest algorithm (SPARC64)"
 	depends on SPARC64
-- 
2.2.0
