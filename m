From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5 4/4] crypto: kdf - enable compilation
Date: Tue, 09 Aug 2016 14:28:57 +0200
Message-ID: <2461264.8cTuJkSQam@positron.chronox.de>
References: <2808589.gm6f519sFh@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34366 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbcHIM3G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 08:29:06 -0400
In-Reply-To: <2808589.gm6f519sFh@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Include KDF into Kconfig and Makefile for compilation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 7 +++++++
 crypto/Makefile | 1 +
 2 files changed, 8 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 84d7148..16f3221 100644
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
