From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 3/9] crypto: ixp4xx - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:25 +0200
Message-ID: <20170519065331.27670-4-clabbe.montjoie@gmail.com>
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
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33323 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdESGzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2017 02:55:50 -0400
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/ixp4xx_crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 771dd26c7076..427cbe012729 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -23,6 +23,7 @@
 #include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/aes.h>
+#include <crypto/hmac.h>
 #include <crypto/sha.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
@@ -90,8 +91,6 @@
 #define CTL_FLAG_PERFORM_AEAD	0x0008
 #define CTL_FLAG_MASK		0x000f
 
-#define HMAC_IPAD_VALUE   0x36
-#define HMAC_OPAD_VALUE   0x5C
 #define HMAC_PAD_BLOCKLEN SHA1_BLOCK_SIZE
 
 #define MD5_DIGEST_SIZE   16
-- 
2.13.0
