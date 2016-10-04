From: Alec Ari <alec@onelabs.com>
Subject: [PATCH] Fix Kconfig dependencies for FIPS
Date: Tue, 04 Oct 2016 19:34:30 -0300
Message-ID: <07ccbb0be0cfb824a5ee1c03eeca8f36@onelabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bongo.birch.relay.mailchannels.net ([23.83.209.21]:55223 "EHLO
        bongo.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751201AbcJDWvj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2016 18:51:39 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8160D128411
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2016 22:34:32 +0000 (UTC)
Received: from cp11.deluxehosting.com (ip-10-107-69-155.us-west-2.compute.internal [10.107.69.155])
        by relay.mailchannels.net (Postfix) with ESMTPA id CFFBB126D27
        for <linux-crypto@vger.kernel.org>; Tue,  4 Oct 2016 22:34:31 +0000 (UTC)
Received: from [::1] (port=36109 helo=onelabs.com)
        by cp11.deluxehosting.com with esmtpa (Exim 4.87)
        (envelope-from <alec@onelabs.com>)
        id 1brYIA-0001tM-P3
        for linux-crypto@vger.kernel.org; Tue, 04 Oct 2016 18:34:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently FIPS depends on MODULE_SIG, even if MODULES is disabled.
This change allows the enabling of FIPS without support for modules.

If module loading support is enabled, only then does
FIPS require MODULE_SIG.

Signed-off-by: Alec Ari <neotheuser@gmail.com>
---
  crypto/Kconfig | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 84d7148..fd28805 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -24,7 +24,7 @@ comment "Crypto core or helper"
  config CRYPTO_FIPS
  	bool "FIPS 200 compliance"
  	depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) && 
!CRYPTO_MANAGER_DISABLE_TESTS
-	depends on MODULE_SIG
+	depends on (MODULE_SIG || !MODULES)
  	help
  	  This options enables the fips boot option which is
  	  required if you want to system to operate in a FIPS 200
-- 
2.7.3
