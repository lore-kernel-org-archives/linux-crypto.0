From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 2/2] crypto: caam - add option for enabling DEBUG mode
Date: Wed, 14 Aug 2013 18:56:46 +0300
Message-ID: <1376495806-26226-2-git-send-email-alexandru.porosanu@freescale.com>
References: <1376495806-26226-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <kim.phillips@freescale.com>,
	<horia.geanta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:57168
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab3HNQBh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 12:01:37 -0400
In-Reply-To: <1376495806-26226-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds an option to the Kconfig file for
SEC which enables the user to see the debug messages
that are printed inside the SEC driver.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/Kconfig  |    8 ++++++++
 drivers/crypto/caam/Makefile |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index b44091c..ca89f6b 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -98,3 +98,11 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 
 	  To compile this as a module, choose M here: the module
 	  will be called caamrng.
+
+config CRYPTO_DEV_FSL_CAAM_DEBUG
+	bool "Enable debug output in CAAM driver"
+	depends on CRYPTO_DEV_FSL_CAAM
+	default n
+	help
+	  Selecting this will enable printing of various debug
+	  information in the CAAM driver.
diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index b1eb448..d56bd0e 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -1,6 +1,9 @@
 #
 # Makefile for the CAAM backend and dependent components
 #
+ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
+	EXTRA_CFLAGS := -DDEBUG
+endif
 
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
-- 
1.7.7.6
