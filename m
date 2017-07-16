From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] crypto/rng: ensure that the RNG is ready before using
Date: Sun, 16 Jul 2017 19:22:06 +0200
Message-ID: <20170716172206.6541-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:56941 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbdGPRWM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jul 2017 13:22:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Otherwise, we might be seeding the RNG using bad randomness, which is
dangerous. The one use of this function from within the kernel -- not
from userspace -- is being removed (keys/big_key), so that call site
isn't relevant in assessing this.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/rng.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 5e8469244960..b4a618668161 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -43,12 +43,14 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 		if (!buf)
 			return -ENOMEM;
 
-		get_random_bytes(buf, slen);
+		err = get_random_bytes_wait(buf, slen);
+		if (err)
+			goto out;
 		seed = buf;
 	}
 
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
-
+out:
 	kzfree(buf);
 	return err;
 }
-- 
2.13.3
