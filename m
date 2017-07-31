From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: ccp - select CONFIG_CRYPTO_RSA
Date: Mon, 31 Jul 2017 23:10:57 +0200
Message-ID: <20170731211104.2012741-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:53773 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751337AbdGaVLY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 17:11:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without the base RSA code, we run into a link error:

ERROR: "rsa_parse_pub_key" [drivers/crypto/ccp/ccp-crypto.ko] undefined!
ERROR: "rsa_parse_priv_key" [drivers/crypto/ccp/ccp-crypto.ko] undefined!

Like the other drivers implementing RSA in hardware, this
can be avoided by always enabling the base support when we build
CCP.

Fixes: ceeec0afd684 ("crypto: ccp - Add support for RSA on the CCP")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 15b63fd3d180..6d626606b9c5 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -27,6 +27,7 @@ config CRYPTO_DEV_CCP_CRYPTO
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
+	select CRYPTO_RSA
 	help
 	  Support for using the cryptographic API with the AMD Cryptographic
 	  Coprocessor. This module supports offload of SHA and AES algorithms.
-- 
2.9.0
