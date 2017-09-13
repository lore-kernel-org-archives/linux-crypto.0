From: Mathieu Malaterre <malat@debian.org>
Subject: [RFC PATCH] crypto: make the seed() function optional
Date: Wed, 13 Sep 2017 22:09:15 +0200
Message-ID: <20170913200915.20738-1-malat@debian.org>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Mathieu Malaterre <malat@debian.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This makes it simplier for driver author to not provide the seed() function
in case of a pseudo RNG where the seed operation is a no-op.

Document that the seed() function pointer is optional in header.

Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
The PRNG as found on Ingenic JZ4780 is one such example. This is found on a
MIPS Creator CI20 SoC.

 crypto/rng.c         | 7 ++++++-
 include/crypto/rng.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 5e8469244960..ed08581901a9 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -35,9 +35,14 @@ static int crypto_default_rng_refcnt;
 
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
+	struct rng_alg *ralg = crypto_rng_alg(tfm);
 	u8 *buf = NULL;
 	int err;
 
+	/* In case of PRNG, no need to seed */
+	if (!ralg->seed)
+		return 0;
+
 	if (!seed && slen) {
 		buf = kmalloc(slen, GFP_KERNEL);
 		if (!buf)
@@ -47,7 +52,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 		seed = buf;
 	}
 
-	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
+	err = ralg->seed(tfm, seed, slen);
 
 	kzfree(buf);
 	return err;
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index b95ede354a66..ac5d061d0297 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -32,7 +32,7 @@ struct crypto_rng;
  *		random number generator requires a seed for setting
  *		up a new state, the seed must be provided by the
  *		consumer while invoking this function. The required
- *		size of the seed is defined with @seedsize .
+ *		size of the seed is defined with @seedsize. Optional.
  * @set_ent:	Set entropy that would otherwise be obtained from
  *		entropy source.  Internal use only.
  * @seedsize:	The seed size required for a random number generator
-- 
2.11.0
