From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: rng - move __crypto_rng_cast to the rng header
Date: Tue,  9 May 2017 10:32:22 +0200
Message-ID: <20170509083222.1100-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: nhorman@tuxdriver.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch move __crypto_rng_cast() to the right header like other
__algo_cast functions.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/rng.c         | 5 -----
 include/crypto/rng.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index f46dac5..5e84692 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -33,11 +33,6 @@ struct crypto_rng *crypto_default_rng;
 EXPORT_SYMBOL_GPL(crypto_default_rng);
 static int crypto_default_rng_refcnt;
 
-static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
-{
-	return container_of(tfm, struct crypto_rng, base);
-}
-
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index b95ede3..4281193 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -197,4 +197,9 @@ static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
 	return crypto_rng_alg(tfm)->seedsize;
 }
 
+static inline struct crypto_rng *__crypto_rng_cast(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_rng, base);
+}
+
 #endif
-- 
2.10.2
