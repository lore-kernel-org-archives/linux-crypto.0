From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] crypto/nx: disable NX on little endian builds
Date: Sat, 7 Jun 2014 11:33:34 +1000
Message-ID: <20140607113334.474343b8@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org,
	nfont@linux.vnet.ibm.com, mhcerri@linux.vnet.ibm.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbaFGBdg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jun 2014 21:33:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The NX driver has endian issues so disable it for now.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03ccdb0..8280a7a3 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -313,7 +313,7 @@ config CRYPTO_DEV_S5P
 
 config CRYPTO_DEV_NX
 	bool "Support for IBM Power7+ in-Nest cryptographic acceleration"
-	depends on PPC64 && IBMVIO
+	depends on PPC64 && IBMVIO && !CPU_LITTLE_ENDIAN
 	default n
 	help
 	  Support for Power7+ in-Nest cryptographic acceleration.
