From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 4/4] crypto: kdf - enable compilation
Date: Thu, 04 Aug 2016 20:41:22 +0200
Message-ID: <11579304.Ct112BsY3h@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <1908905.sE4dlalNOn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33972 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbcHDSl6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 14:41:58 -0400
In-Reply-To: <1908905.sE4dlalNOn@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Include KDF into Kconfig and Makefile for compilation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 7 +++++++
 crypto/Makefile | 1 +
 2 files changed, 8 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a9377be..91ef2a6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -372,6 +372,13 @@ config CRYPTO_KEYWRAP
 	  Support for key wrapping (NIST SP800-38F / RFC3394) without
 	  padding.
 
+config CRYPTO_KDF
+	tristate "Key Derivation Function (SP800-108)"
+	select CRYPTO_RNG
+	help
+	  Support for KDF compliant to SP800-108. All three types of
+	  KDF specified in SP800-108 are implemented.
+
 comment "Hash modes"
 
 config CRYPTO_CMAC
diff --git a/crypto/Makefile b/crypto/Makefile
index 99cc64a..9022280 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_KEYWRAP) += keywrap.o
+obj-$(CONFIG_CRYPTO_KDF) += kdf.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
-- 
2.7.4
