From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/9] crypto: ixp4xx - Use IPAD/OPAD constant
Date: Mon, 24 Apr 2017 16:16:23 +0200
Message-ID: <20170424141629.27155-3-clabbe.montjoie@gmail.com>
References: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
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
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35221 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171893AbdDXOSp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 10:18:45 -0400
In-Reply-To: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/ixp4xx_crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 771dd26..3b7680c 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -90,8 +90,6 @@
 #define CTL_FLAG_PERFORM_AEAD	0x0008
 #define CTL_FLAG_MASK		0x000f
 
-#define HMAC_IPAD_VALUE   0x36
-#define HMAC_OPAD_VALUE   0x5C
 #define HMAC_PAD_BLOCKLEN SHA1_BLOCK_SIZE
 
 #define MD5_DIGEST_SIZE   16
-- 
2.10.2
