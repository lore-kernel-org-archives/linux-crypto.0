From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 10/11] crypto: gcm - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:17 +0200
Message-ID: <20170822080818.12486-11-clabbe.montjoie@gmail.com>
References: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, horia.geanta@nxp.com, dan.douglass@nxp.com,
        thomas.lendacky@amd.com, gary.hook@amd.com, harsh@chelsio.com,
        matthias.bgg@gmail.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch replace GCM IV size value by their constant name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/gcm.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 3841b5eafa7e..80cf6cfe082b 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -14,6 +14,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/null.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/gcm.h>
 #include <crypto/hash.h>
 #include "internal.h"
 #include <linux/completion.h>
@@ -197,8 +198,8 @@ static void crypto_gcm_init_common(struct aead_request *req)
 	struct scatterlist *sg;
 
 	memset(pctx->auth_tag, 0, sizeof(pctx->auth_tag));
-	memcpy(pctx->iv, req->iv, 12);
-	memcpy(pctx->iv + 12, &counter, 4);
+	memcpy(pctx->iv, req->iv, GCM_AES_IV_SIZE);
+	memcpy(pctx->iv + GCM_AES_IV_SIZE, &counter, 4);
 
 	sg_init_table(pctx->src, 3);
 	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
@@ -695,7 +696,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	inst->alg.base.cra_alignmask = ghash->base.cra_alignmask |
 				       ctr->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
-	inst->alg.ivsize = 12;
+	inst->alg.ivsize = GCM_AES_IV_SIZE;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(ctr);
 	inst->alg.maxauthsize = 16;
 	inst->alg.init = crypto_gcm_init_tfm;
@@ -832,20 +833,20 @@ static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
 	u8 *iv = PTR_ALIGN((u8 *)(subreq + 1) + crypto_aead_reqsize(child),
 			   crypto_aead_alignmask(child) + 1);
 
-	scatterwalk_map_and_copy(iv + 12, req->src, 0, req->assoclen - 8, 0);
+	scatterwalk_map_and_copy(iv + GCM_AES_IV_SIZE, req->src, 0, req->assoclen - 8, 0);
 
 	memcpy(iv, ctx->nonce, 4);
 	memcpy(iv + 4, req->iv, 8);
 
 	sg_init_table(rctx->src, 3);
-	sg_set_buf(rctx->src, iv + 12, req->assoclen - 8);
+	sg_set_buf(rctx->src, iv + GCM_AES_IV_SIZE, req->assoclen - 8);
 	sg = scatterwalk_ffwd(rctx->src + 1, req->src, req->assoclen);
 	if (sg != rctx->src + 1)
 		sg_chain(rctx->src, 2, sg);
 
 	if (req->src != req->dst) {
 		sg_init_table(rctx->dst, 3);
-		sg_set_buf(rctx->dst, iv + 12, req->assoclen - 8);
+		sg_set_buf(rctx->dst, iv + GCM_AES_IV_SIZE, req->assoclen - 8);
 		sg = scatterwalk_ffwd(rctx->dst + 1, req->dst, req->assoclen);
 		if (sg != rctx->dst + 1)
 			sg_chain(rctx->dst, 2, sg);
@@ -957,7 +958,7 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	err = -EINVAL;
 
 	/* Underlying IV size must be 12. */
-	if (crypto_aead_alg_ivsize(alg) != 12)
+	if (crypto_aead_alg_ivsize(alg) != GCM_AES_IV_SIZE)
 		goto out_drop_alg;
 
 	/* Not a stream cipher? */
@@ -980,7 +981,7 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4106_ctx);
 
-	inst->alg.ivsize = 8;
+	inst->alg.ivsize = GCM_RFC4106_IV_SIZE;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
 	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
@@ -1134,7 +1135,7 @@ static int crypto_rfc4543_init_tfm(struct crypto_aead *tfm)
 		tfm,
 		sizeof(struct crypto_rfc4543_req_ctx) +
 		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
-		align + 12);
+		align + GCM_AES_IV_SIZE);
 
 	return 0;
 
@@ -1199,7 +1200,7 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	err = -EINVAL;
 
 	/* Underlying IV size must be 12. */
-	if (crypto_aead_alg_ivsize(alg) != 12)
+	if (crypto_aead_alg_ivsize(alg) != GCM_AES_IV_SIZE)
 		goto out_drop_alg;
 
 	/* Not a stream cipher? */
@@ -1222,7 +1223,7 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4543_ctx);
 
-	inst->alg.ivsize = 8;
+	inst->alg.ivsize = GCM_RFC4543_IV_SIZE;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
 	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
-- 
2.13.0
