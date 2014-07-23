From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Remove "select OF" from Kconfig
Date: Wed, 23 Jul 2014 09:45:19 -0500
Message-ID: <20140723144519.19404.46876.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:15819
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757780AbaGWOp0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 10:45:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The addition of the "select OF if ARM64" has led to a Kconfig
recursive dependency error when "make ARCH=sh rsk7269_defconfig"
was run.  Since OF is selected by ARM64 and the of_property_read_bool
is defined no matter what, delete the Kconfig line that selects OF.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 474382d..7639ffc 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -3,7 +3,6 @@ config CRYPTO_DEV_CCP_DD
 	depends on CRYPTO_DEV_CCP
 	default m
 	select HW_RANDOM
-	select OF if ARM64
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
 	  which can be used to accelerate or offload encryption operations
