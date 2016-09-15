From: NTU <neotheuser@gmail.com>
Subject: [PATCH] Fix Kconfig dependencies for FIPS
Date: Thu, 15 Sep 2016 17:41:32 -0500
Message-ID: <CAM5Ud7Ph1LR_8F7Pm9x55B9bozuQL+=6NZfVMjPtTPiDswfUHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36309 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbcIOWld (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 18:41:33 -0400
Received: by mail-io0-f193.google.com with SMTP id z135so400433ioe.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2016 15:41:33 -0700 (PDT)
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
-    depends on MODULE_SIG
+    depends on (MODULE_SIG || !MODULES)
     help
       This options enables the fips boot option which is
       required if you want to system to operate in a FIPS 200
-- 
2.7.3
