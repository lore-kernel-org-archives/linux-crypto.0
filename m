From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v8 4/4] crypto: algif_akcipher - enable compilation
Date: Thu, 10 Aug 2017 08:40:20 +0200
Message-ID: <2936451.27GRxPPosH@positron.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58434 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751732AbdHJGkr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 02:40:47 -0400
In-Reply-To: <26359147.tCiuJ5s8mz@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the Makefile and Kconfig updates to allow algif_akcipher to be
compiled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0a121f9ddf8e..fdcec68545f3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1760,6 +1760,15 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
+config CRYPTO_USER_API_AKCIPHER
+	tristate "User-space interface for asymmetric key cipher algorithms"
+	depends on NET
+	select CRYPTO_AKCIPHER2
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for asymmetric
+	  key cipher algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index d41f0331b085..12dbf2c5fe7c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -133,6 +133,7 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_AKCIPHER) += algif_akcipher.o
 
 ecdh_generic-y := ecc.o
 ecdh_generic-y += ecdh.o
-- 
2.13.4
