From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/2] crypto: kpp - constify buffer passed to crypto_kpp_set_secret()
Date: Fri, 24 Feb 2017 15:46:58 -0800
Message-ID: <20170224234659.89423-2-ebiggers3@gmail.com>
References: <20170224234659.89423-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170224234659.89423-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Constify the buffer passed to crypto_kpp_set_secret() and
kpp_alg.set_secret, since it is never modified.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/dh.c                                   | 3 ++-
 crypto/ecdh.c                                 | 3 ++-
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 2 +-
 include/crypto/kpp.h                          | 6 +++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index ddcb528ab2cc..87e3542cf1b8 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -79,7 +79,8 @@ static int dh_set_params(struct dh_ctx *ctx, struct dh *params)
 	return 0;
 }
 
-static int dh_set_secret(struct crypto_kpp *tfm, void *buf, unsigned int len)
+static int dh_set_secret(struct crypto_kpp *tfm, const void *buf,
+			 unsigned int len)
 {
 	struct dh_ctx *ctx = dh_get_ctx(tfm);
 	struct dh params;
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 3de289806d67..63ca33771e4e 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -38,7 +38,8 @@ static unsigned int ecdh_supported_curve(unsigned int curve_id)
 	}
 }
 
-static int ecdh_set_secret(struct crypto_kpp *tfm, void *buf, unsigned int len)
+static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
+			   unsigned int len)
 {
 	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
 	struct ecdh params;
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 0d35dca2e925..2aab80bc241f 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -491,7 +491,7 @@ static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
 	ctx->g2 = false;
 }
 
-static int qat_dh_set_secret(struct crypto_kpp *tfm, void *buf,
+static int qat_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 			     unsigned int len)
 {
 	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 4307a2f2365f..ce8e1f79374b 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -74,7 +74,7 @@ struct crypto_kpp {
  * @base:		Common crypto API algorithm data structure
  */
 struct kpp_alg {
-	int (*set_secret)(struct crypto_kpp *tfm, void *buffer,
+	int (*set_secret)(struct crypto_kpp *tfm, const void *buffer,
 			  unsigned int len);
 	int (*generate_public_key)(struct kpp_request *req);
 	int (*compute_shared_secret)(struct kpp_request *req);
@@ -273,8 +273,8 @@ struct kpp_secret {
  *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm, void *buffer,
-					unsigned int len)
+static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
+					const void *buffer, unsigned int len)
 {
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
-- 
2.11.0.483.g087da7b7c-goog
