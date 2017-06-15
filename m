From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 01/13] crypto: inside-secure - use hmac ipad/opad constants
Date: Thu, 15 Jun 2017 09:56:17 +0200
Message-ID: <20170615075629.30907-2-antoine.tenart@free-electrons.com>
References: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53379 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752120AbdFOIAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:04 -0400
In-Reply-To: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace the hmac ipad/opad values by their defined constants.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 060ea034c9da..6eee1a502225 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -8,6 +8,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <crypto/hmac.h>
 #include <crypto/sha.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
@@ -774,8 +775,8 @@ static int safexcel_hmac_init_pad(struct ahash_request *areq,
 	memcpy(opad, ipad, blocksize);
 
 	for (i = 0; i < blocksize; i++) {
-		ipad[i] ^= 0x36;
-		opad[i] ^= 0x5c;
+		ipad[i] ^= HMAC_IPAD_VALUE;
+		opad[i] ^= HMAC_OPAD_VALUE;
 	}
 
 	return 0;
-- 
2.9.4
