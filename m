Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva020.nxp.com ([92.121.34.13]:33300 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbeKHXMa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Nov 2018 18:12:30 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cristian Stoica <cristian.stoica@microchip.com>,
        linux-crypto@vger.kernel.org,
        Cristian Stoica <cristian.stoica@nxp.com>
Subject: [PATCH 3/5] crypto: export CHACHAPOLY_IV_SIZE
Date: Thu,  8 Nov 2018 15:36:29 +0200
Message-Id: <20181108133631.15779-4-horia.geanta@nxp.com>
In-Reply-To: <20181108133631.15779-1-horia.geanta@nxp.com>
References: <20181108133631.15779-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Cristian Stoica <cristian.stoica@nxp.com>

Move CHACHAPOLY_IV_SIZE to header file, so it can be reused.

Signed-off-by: Cristian Stoica <cristian.stoica@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 crypto/chacha20poly1305.c | 2 --
 include/crypto/chacha20.h | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 600afa99941f..f9dd5453046a 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -22,8 +22,6 @@
 
 #include "internal.h"
 
-#define CHACHAPOLY_IV_SIZE	12
-
 struct chachapoly_instance_ctx {
 	struct crypto_skcipher_spawn chacha;
 	struct crypto_ahash_spawn poly;
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index f76302d99e2b..2d3129442a52 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -13,6 +13,7 @@
 #define CHACHA20_IV_SIZE	16
 #define CHACHA20_KEY_SIZE	32
 #define CHACHA20_BLOCK_SIZE	64
+#define CHACHAPOLY_IV_SIZE	12
 
 struct chacha20_ctx {
 	u32 key[8];
-- 
2.16.2
