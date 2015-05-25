From: Cyril Bur <cyrilbur@gmail.com>
Subject: [PATCH] crypto: nx - tweak Makefile dependencies
Date: Mon, 25 May 2015 14:45:16 +1000
Message-ID: <1432529116-21279-1-git-send-email-cyrilbur@gmail.com>
Cc: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57174 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbEYEqm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 00:46:42 -0400
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <cyrilbur@gmail.com>;
	Mon, 25 May 2015 14:46:39 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id C1B062BB0057
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2015 14:46:34 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4P4kQlc22085708
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2015 14:46:34 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4P4k26f024128
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2015 14:46:02 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Selecting CRYPTO_DEV_NX causes a conditional include of nx/Kconfig but
options within nx/Kconfig do not depend on it. The included options should
depend on CRYPTO_DEV_NX since currently CRYPTO_DEV_NX cannot be built for
little endian. While Kconfig appears to understand this convoluted
dependency situation, it isn't explicitly stated.

This patch addresses the missing dependencies for CRYPTO_DEV_NX_ENCRYPT and
CRYPTO_DEV_NX_COMPRESS which should depend on CRYPTO_DEV_NX. It also makes
more sense to put all three options into the nx/Kconfig file and have the
file included unconditionally.

CC: Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
CC: Fionnuala Gunter <fin@linux.vnet.ibm.com>
CC: linux-crypto@vger.kernel.org
CC: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
---
 drivers/crypto/Kconfig    | 11 +----------
 drivers/crypto/nx/Kconfig | 11 +++++++++--
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 033c0c8..cc96a7d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -311,16 +311,7 @@ config CRYPTO_DEV_S5P
 	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
 	  algorithms execution.
 
-config CRYPTO_DEV_NX
-	bool "Support for IBM Power7+ in-Nest cryptographic acceleration"
-	depends on PPC64 && IBMVIO && !CPU_LITTLE_ENDIAN
-	default n
-	help
-	  Support for Power7+ in-Nest cryptographic acceleration.
-
-if CRYPTO_DEV_NX
-	source "drivers/crypto/nx/Kconfig"
-endif
+source "drivers/crypto/nx/Kconfig"
 
 config CRYPTO_DEV_UX500
 	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"
diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index f826166..0726f12 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -1,6 +1,13 @@
+config CRYPTO_DEV_NX
+	bool "Support for IBM Power7+ in-Nest cryptographic acceleration"
+	depends on PPC64 && IBMVIO && !CPU_LITTLE_ENDIAN
+	default n
+	help
+	  Support for Power7+ in-Nest cryptographic acceleration.
+
 config CRYPTO_DEV_NX_ENCRYPT
 	tristate "Encryption acceleration support"
-	depends on PPC64 && IBMVIO
+	depends on CRYPTO_DEV_NX
 	default y
 	select CRYPTO_AES
 	select CRYPTO_CBC
@@ -18,7 +25,7 @@ config CRYPTO_DEV_NX_ENCRYPT
 
 config CRYPTO_DEV_NX_COMPRESS
 	tristate "Compression acceleration support"
-	depends on PPC64 && IBMVIO
+	depends on CRYPTO_DEV_NX
 	default y
 	help
 	  Support for Power7+ in-Nest compression acceleration. This
-- 
1.9.1
