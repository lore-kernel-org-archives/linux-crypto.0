From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 2/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Thu, 3 Jul 2008 16:22:56 -0400
Message-ID: <20080703202256.GC5237@hmsendeavour.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2927 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbYGCUXH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2008 16:23:07 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch 2/2: Add Kconfig & Makefile support to build prng module

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 Kconfig  |    9 +++++++++
 Makefile |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/crypto/Kconfig b/crypto/Kconfig
index 795e31c..615ce9b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -666,6 +666,15 @@ config CRYPTO_LZO
 	help
 	  This is the LZO algorithm.
 
+comment "Random Number Generation"
+
+config CRYPTO_PRNG
+	tristate "Pseudo Random Number Generation for Cryptographic modules"
+	help
+	  This option enables the generic pseudo random number generator
+	  for cryptographic modules.  Uses the Algorithm specified in 
+	  ANSI X9.31 A.2.4
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index d4f3ed8..ef61b3b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -69,7 +69,7 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
