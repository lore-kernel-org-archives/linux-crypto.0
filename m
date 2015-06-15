From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 06/11] crypto: caam - Enable MXC devices to select CAAM driver in Kconfig
Date: Mon, 15 Jun 2015 16:52:54 -0700
Message-ID: <1434412379-11623-7-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:51101
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751084AbbFPAIY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:08:24 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steve Cornelius <steve.cornelius@freescale.com>

Allow CAAM to be selected in the kernel for Freescale i.MX6 devices if
ARCH_MXC is enabled.

Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index e7555ff..bc9aa07 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_FSL_CAAM
 	tristate "Freescale CAAM-Multicore driver backend"
-	depends on FSL_SOC
+	depends on FSL_SOC || ARCH_MXC
 	help
 	  Enables the driver module for Freescale's Cryptographic Accelerator
 	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4).
-- 
2.1.4
