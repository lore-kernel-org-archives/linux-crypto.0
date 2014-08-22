From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: crypto: mv_cesa.h: Add missing #define
Date: Fri, 22 Aug 2014 18:33:37 +0200
Message-ID: <1408725217-2342-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Clearly this was meant to be an include guard, but the #define was
missing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/crypto/mv_cesa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
index 08fcb11..9249d3e 100644
--- a/drivers/crypto/mv_cesa.h
+++ b/drivers/crypto/mv_cesa.h
@@ -1,4 +1,5 @@
 #ifndef __MV_CRYPTO_H__
+#define __MV_CRYPTO_H__
 
 #define DIGEST_INITIAL_VAL_A	0xdd00
 #define DIGEST_INITIAL_VAL_B	0xdd04
-- 
2.0.4
