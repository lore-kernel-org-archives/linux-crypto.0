From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6 09/38] crypto: ccp: Build the AMD secure processor driver only with AMD CPU support
Date: Thu, 19 Oct 2017 21:33:44 -0500
Message-ID: <20171020023413.122280-10-brijesh.singh@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: bp@alien8.de, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: kvm@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0081.outbound.protection.outlook.com ([104.47.38.81]:36505
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751935AbdJTCe4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2017 22:34:56 -0400
In-Reply-To: <20171020023413.122280-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Borislav Petkov <bp@suse.de>

This is AMD-specific hardware so present it in Kconfig only when AMD
CPU support is enabled or on ARM64 where it is also used.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/ccp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 6d626606b9c5..9c84f9838931 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_CCP_DD
 	tristate "Secure Processor device driver"
+	depends on CPU_SUP_AMD || ARM64
 	default m
 	help
 	  Provides AMD Secure Processor device driver.
-- 
2.9.5
