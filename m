From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/4] crypto: ccp - Allow for selective disablement of crypto
 API algorithms
Date: Fri, 24 Jan 2014 16:17:56 -0600
Message-ID: <20140124221756.1894.88768.stgit@tlendack-t1.amdoffice.net>
References: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42124 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbaAXWSK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jan 2014 17:18:10 -0500
In-Reply-To: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduce module parameters that allow for disabling of a
crypto algorithm by not registering the algorithm with the
crypto API.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |   37 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 2636f04..b3f22b0 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/ccp.h>
@@ -24,6 +25,14 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD Cryptographic Coprocessor crypto API support");
 
+static unsigned int aes_disable;
+module_param(aes_disable, uint, 0444);
+MODULE_PARM_DESC(aes_disable, "Disable use of AES - any non-zero value");
+
+static unsigned int sha_disable;
+module_param(sha_disable, uint, 0444);
+MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
+
 
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
@@ -337,21 +346,25 @@ static int ccp_register_algs(void)
 {
 	int ret;
 
-	ret = ccp_register_aes_algs(&cipher_algs);
-	if (ret)
-		return ret;
+	if (!aes_disable) {
+		ret = ccp_register_aes_algs(&cipher_algs);
+		if (ret)
+			return ret;
 
-	ret = ccp_register_aes_cmac_algs(&hash_algs);
-	if (ret)
-		return ret;
+		ret = ccp_register_aes_cmac_algs(&hash_algs);
+		if (ret)
+			return ret;
 
-	ret = ccp_register_aes_xts_algs(&cipher_algs);
-	if (ret)
-		return ret;
+		ret = ccp_register_aes_xts_algs(&cipher_algs);
+		if (ret)
+			return ret;
+	}
 
-	ret = ccp_register_sha_algs(&hash_algs);
-	if (ret)
-		return ret;
+	if (!sha_disable) {
+		ret = ccp_register_sha_algs(&hash_algs);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
