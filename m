From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 19/20] crypto: mcryptd to process CRYPTO_ALG_INTERNAL
Date: Sat, 28 Mar 2015 00:01:32 +0100
Message-ID: <3240728.vJTA2zCdgt@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The mcryptd is used as a wrapper around internal ciphers. Therefore,
the mcryptd must process the internal cipher by marking mcryptd as
internal if the underlying cipher is an internal cipher.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/mcryptd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index a8e8704..fe5b495a 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -258,6 +258,20 @@ out_free_inst:
 	goto out;
 }
 
+static inline void mcryptd_check_internal(struct rtattr **tb, u32 *type,
+					  u32 *mask)
+{
+	struct crypto_attr_type *algt;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return;
+	if ((algt->type & CRYPTO_ALG_INTERNAL))
+		*type |= CRYPTO_ALG_INTERNAL;
+	if ((algt->mask & CRYPTO_ALG_INTERNAL))
+		*mask |= CRYPTO_ALG_INTERNAL;
+}
+
 static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
@@ -480,9 +494,13 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	struct ahash_instance *inst;
 	struct shash_alg *salg;
 	struct crypto_alg *alg;
+	u32 type = 0;
+	u32 mask = 0;
 	int err;
 
-	salg = shash_attr_alg(tb[1], 0, 0);
+	mcryptd_check_internal(tb, &type, &mask);
+
+	salg = shash_attr_alg(tb[1], type, mask);
 	if (IS_ERR(salg))
 		return PTR_ERR(salg);
 
@@ -502,7 +520,10 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto out_free_inst;
 
-	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	type = CRYPTO_ALG_ASYNC;
+	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
+		type |= CRYPTO_ALG_INTERNAL;
+	inst->alg.halg.base.cra_flags = type;
 
 	inst->alg.halg.digestsize = salg->digestsize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct mcryptd_hash_ctx);
-- 
2.1.0
