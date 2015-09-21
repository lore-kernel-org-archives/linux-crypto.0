From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 2/3] crypto: keywrap - enable compilation
Date: Mon, 21 Sep 2015 20:58:56 +0200
Message-ID: <288574657.FV0It7AO1b@tachyon.chronox.de>
References: <3564891.reL3VOPkWo@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34137 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932743AbbIUTA6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 15:00:58 -0400
In-Reply-To: <3564891.reL3VOPkWo@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hook keywrap source code into Kconfig and Makefile

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 7 +++++++
 crypto/Makefile | 1 +
 2 files changed, 8 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index fc93444..7240821 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -348,6 +348,13 @@ config CRYPTO_XTS
 	  key size 256, 384 or 512 bits. This implementation currently
 	  can't handle a sectorsize which is not a multiple of 16 bytes.
 
+config CRYPTO_KEYWRAP
+	tristate "Key wrapping support"
+	select CRYPTO_BLKCIPHER
+	help
+	  Support for key wrapping (NIST SP800-38F / RFC3394) without
+	  padding.
+
 comment "Hash modes"
 
 config CRYPTO_CMAC
diff --git a/crypto/Makefile b/crypto/Makefile
index e2c5981..1f4e13c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
+obj-$(CONFIG_CRYPTO_KEYWRAP) += keywrap.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
-- 
2.4.3
