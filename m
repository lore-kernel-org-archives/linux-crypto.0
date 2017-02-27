From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 2/2] crypto: ctr - Propagate NEED_FALLBACK bit
Date: Sun, 26 Feb 2017 22:03:19 -0300
Message-ID: <1488157399-3587-3-git-send-email-marcelo.cerri@canonical.com>
References: <1488157399-3587-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488157399-3587-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When requesting a fallback algorithm, we should propagate the
NEED_FALLBACK bit when search for the underlying algorithm.

This will prevents drivers from allocating unnecessary fallbacks that
are never called. For instance, currently the vmx-crypto driver will use
the following chain of calls when calling the fallback implementation:

p8_aes_ctr -> ctr(p8_aes) -> aes-generic

However p8_aes will always delegate its calls to aes-generic. With this
patch, p8_aes_ctr will be able to use ctr(aes-generic) directly as its
fallback. The same applies to aes_s390.

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
---
 crypto/ctr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index a4f4a89..3afe21a 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -181,15 +181,24 @@ static void crypto_ctr_exit_tfm(struct crypto_tfm *tfm)
 static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 {
 	struct crypto_instance *inst;
+	struct crypto_attr_type *algt;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_BLKCIPHER);
 	if (err)
 		return ERR_PTR(err);
 
-	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	mask = CRYPTO_ALG_TYPE_MASK |
+		crypto_requires_off(algt->type, algt->mask,
+				    CRYPTO_ALG_NEED_FALLBACK);
+
+	alg = crypto_attr_alg(tb[1], CRYPTO_ALG_TYPE_CIPHER, mask);
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
 
-- 
2.7.4
