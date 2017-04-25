From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Add a module author
Date: Tue, 25 Apr 2017 08:59:44 -0500
Message-ID: <20170425135944.5726.83246.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0087.outbound.protection.outlook.com ([104.47.40.87]:12016
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031688AbdDYN74 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 09:59:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CC: <stable@vger.kernel.org> # 4.9.x+

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 92d1c6959f08..b7504562715c 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -31,6 +31,7 @@
 #include "ccp-dev.h"
 
 MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
+MODULE_AUTHOR("Gary R Hook <gary.hook@amd.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
