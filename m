From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: chcr: select CRYPTO_GF128MUL
Date: Tue,  5 Dec 2017 11:10:26 +0100
Message-ID: <20171205101032.985159-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:64826 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753205AbdLEKKz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 05:10:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without the gf128mul library support, we can run into a link
error:

drivers/crypto/chelsio/chcr_algo.o: In function `chcr_update_tweak':
chcr_algo.c:(.text+0x7e0): undefined reference to `gf128mul_x8_ble'

This adds a Kconfig select statement for it, next to the ones we
already have.

Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/chelsio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 3e104f5aa0c2..b56b3f711d94 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -5,6 +5,7 @@ config CRYPTO_DEV_CHELSIO
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_AUTHENC
+	select CRYPTO_GF128MUL
 	---help---
 	  The Chelsio Crypto Co-processor driver for T6 adapters.
 
-- 
2.9.0
