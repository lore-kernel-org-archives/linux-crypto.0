From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2] crypto: talitos: Extend max key length for
 SHA384/512-HMAC and AEAD
Date: Tue, 2 May 2017 09:38:35 -0400
Message-ID: <20170502133835.GA17402@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, horia.geanta@nxp.com
To: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from darwin.bork.org ([65.49.60.145]:36326 "EHLO darwin.bork.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdEBNig (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 May 2017 09:38:36 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


An updated patch that also handles the additional key length requirements
for the AEAD algorithms.

The max keysize is not 96.  For SHA384/512 it's 128, and for the AEAD
algorithms it's longer still.  Extend the max keysize for the
AEAD size for AES256 + HMAC(SHA512).

Cc: <stable@vger.kernel.org> # 3.6+
Fixes: 357fb60502ede ("crypto: talitos - add sha224, sha384 and sha512 to existing AEAD algorithms")
Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0bba6a1..79791c6 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -816,7 +816,7 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#define TALITOS_MAX_KEY_SIZE		96
+#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 struct talitos_ctx {
@@ -1495,6 +1495,11 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 {
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 
+	if (keylen > TALITOS_MAX_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
 	memcpy(&ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
-- 
1.7.10.4


-- 
Martin Hicks P.Eng.    |      mort@bork.org
Bork Consulting Inc.   |  +1 (613) 266-2296
