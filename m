From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v1 3/8] crypto:chcr- Fix key length for RFC4106
Date: Fri,  6 Jan 2017 14:01:34 +0530
Message-ID: <6d8e61299e051d51dacdb6bfd6c5e582b230027c.1483599449.git.harsh@chelsio.com>
References: <cover.1483599449.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: hariprasad@chelsio.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1483599449.git.harsh@chelsio.com>
In-Reply-To: <cover.1483599449.git.harsh@chelsio.com>
References: <cover.1483599449.git.harsh@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Check keylen before copying salt to avoid wrap around of Integer.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index deec7c0..6c2dea3 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2194,8 +2194,8 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	unsigned int ck_size;
 	int ret = 0, key_ctx_size = 0;
 
-	if (get_aead_subtype(aead) ==
-	    CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) {
+	if (get_aead_subtype(aead) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106 &&
+	    keylen > 3) {
 		keylen -= 4;  /* nonce/salt is present in the last 4 bytes */
 		memcpy(aeadctx->salt, key + keylen, 4);
 	}
-- 
1.8.2.3
