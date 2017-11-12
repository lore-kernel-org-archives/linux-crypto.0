From: Pierre Ducroquet <pinaraf@pinaraf.info>
Subject: [PATCH] Fix NULL pointer deref. on no default_rng
Date: Sun, 12 Nov 2017 15:24:32 +0100
Message-ID: <20171112142432.20186-1-pinaraf@pinaraf.info>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        Pierre Ducroquet <pinaraf@pinaraf.info>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from host.pinaraf.info ([37.187.77.179]:43890 "EHLO mx2.pinaraf.info"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751139AbdKLObj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Nov 2017 09:31:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If crypto_get_default_rng returns an error, the
function ecc_gen_privkey should return an error.
Instead, it currently tries to use the default_rng
nevertheless, thus creating a kernel panic with a
NULL pointer dereference.
Returning the error directly, as was supposedly
intended when looking at the code, fixes this.

Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
---
 crypto/ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 633a9bcdc574..18f32f2a5e1c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -964,7 +964,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 	 * DRBG with a security strength of 256.
 	 */
 	if (crypto_get_default_rng())
-		err = -EFAULT;
+		return -EFAULT;
 
 	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
 	crypto_put_default_rng();
-- 
2.15.0
