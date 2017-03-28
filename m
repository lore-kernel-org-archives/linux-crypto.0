From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] crypto: ccp - Mark driver as little-endian only
Date: Tue, 28 Mar 2017 11:58:05 +0200
Message-ID: <20170328095814.3734615-2-arnd@arndb.de>
References: <20170328095814.3734615-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:62787 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754373AbdC1KBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 06:01:03 -0400
In-Reply-To: <20170328095814.3734615-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver causes a warning when built as big-endian:

drivers/crypto/ccp/ccp-dev-v5.c: In function 'ccp5_perform_des3':
include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
 #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
                          ^
include/linux/byteorder/generic.h:87:21: note: in expansion of macro '__cpu_to_le32'
 #define cpu_to_le32 __cpu_to_le32
                     ^~~~~~~~~~~~~
drivers/crypto/ccp/ccp-dev-v5.c:436:28: note: in expansion of macro 'cpu_to_le32'
  CCP5_CMD_KEY_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SB);

The warning is correct, doing a 32-bit byte swap on a value that gets
assigned into a bit field cannot work, since we would only write zeroes
in this case, regardless of the input.

In fact, the use of bit fields in hardware defined data structures is
not portable to start with, so until all these bit fields get replaced
by something else, the driver cannot work on big-endian machines, and
I'm adding an annotation here to prevent it from being selected.

The CCPv3 code seems to not suffer from this problem, only v5 uses
bitfields.

Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function as v3")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/ccp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 2238f77aa248..07af9ece84f9 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -1,6 +1,7 @@
 config CRYPTO_DEV_CCP_DD
 	tristate "Cryptographic Coprocessor device driver"
 	depends on CRYPTO_DEV_CCP
+	depends on !CPU_BIG_ENDIAN || BROKEN
 	default m
 	select HW_RANDOM
 	select DMA_ENGINE
-- 
2.9.0
