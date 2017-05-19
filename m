From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 1/9] crypto: add hmac IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:23 +0200
Message-ID: <20170519065331.27670-2-clabbe.montjoie@gmail.com>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.lendacky@amd.com, gary.hook@amd.com,
        boris.brezillon@free-electrons.com, arno@natisbad.org,
        matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
        salvatore.benedetto@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34169 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbdESGzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 02:55:50 -0400
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Many HMAC users directly use directly 0x36/0x5c values.
It's better with crypto to use a name instead of directly some crypto
constant.

This patch simply add HMAC_IPAD_VALUE/HMAC_OPAD_VALUE defines in a new
include file "crypto/hmac.h" and use them in crypto/hmac.c

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/hmac.c         | 5 +++--
 include/crypto/hmac.h | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)
 create mode 100644 include/crypto/hmac.h

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 72e38c098bb3..92871dc2a63e 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -74,8 +75,8 @@ static int hmac_setkey(struct crypto_shash *parent,
 	memcpy(opad, ipad, bs);
 
 	for (i = 0; i < bs; i++) {
-		ipad[i] ^= 0x36;
-		opad[i] ^= 0x5c;
+		ipad[i] ^= HMAC_IPAD_VALUE;
+		opad[i] ^= HMAC_OPAD_VALUE;
 	}
 
 	return crypto_shash_init(shash) ?:
diff --git a/include/crypto/hmac.h b/include/crypto/hmac.h
new file mode 100644
index 000000000000..ef09f7938204
--- /dev/null
+++ b/include/crypto/hmac.h
@@ -0,0 +1,7 @@
+#ifndef _CRYPTO_HMAC_H
+#define _CRYPTO_HMAC_H
+
+#define HMAC_IPAD_VALUE 0x36
+#define HMAC_OPAD_VALUE 0x5c
+
+#endif /* _CRYPTO_HMAC_H */
-- 
2.13.0
