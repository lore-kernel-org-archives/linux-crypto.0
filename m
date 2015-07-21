From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/3] crypto: algif_akcipher - enable compilation
Date: Wed, 22 Jul 2015 00:13:39 +0200
Message-ID: <13692732.LcDMk6zc2n@tachyon.chronox.de>
References: <3908391.JkjAozYBaW@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47974 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbbGUWOf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 18:14:35 -0400
In-Reply-To: <3908391.JkjAozYBaW@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the Makefile and Kconfig updates to allow algif_akcipher to be
compiled.

CC: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 354bb69..d12ecc5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1623,6 +1623,15 @@ config CRYPTO_USER_API_AEAD
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
index a16a7e7..64823ab 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -116,6 +116,7 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_AKCIPHER) += algif_akcipher.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.4.3
