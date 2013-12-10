From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 2/3] crypto: ccp - CCP Kconfig fixes
Date: Tue, 10 Dec 2013 10:38:39 -0600
Message-ID: <20131210163838.24304.38541.stgit@tlendack-t1.amdoffice.net>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:35347
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904Ab3LJQip (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:45 -0500
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update the Kconfig to include PCI on the 'depends on'
and add 'select HW_RANDOM' to insure the necessary PCI
and HW_RANDOM functions are available/included in the
build.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig     |    2 +-
 drivers/crypto/ccp/Kconfig |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4954d75..9dee00f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -401,7 +401,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on X86
+	depends on X86 && PCI
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 335ed5c..7639ffc 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -2,6 +2,7 @@ config CRYPTO_DEV_CCP_DD
 	tristate "Cryptographic Coprocessor device driver"
 	depends on CRYPTO_DEV_CCP
 	default m
+	select HW_RANDOM
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
 	  which can be used to accelerate or offload encryption operations
