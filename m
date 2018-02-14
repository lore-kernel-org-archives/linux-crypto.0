From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] crypto: caam: Delete an error message for a failed memory
 allocation in seven functions
Date: Wed, 14 Feb 2018 19:31:27 +0100
Message-ID: <594d974d-577d-353d-9e99-4f98ad911cb4@users.sourceforge.net>
References: <9a9a602d-93da-457d-c37d-2acbb4b7b5d5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <9a9a602d-93da-457d-c37d-2acbb4b7b5d5@users.sourceforge.net>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 18:22:38 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamalg.c  |  6 +-----
 drivers/crypto/caam/caamhash.c | 12 +++---------
 drivers/crypto/caam/key_gen.c  |  4 +---
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2188235be02d..d1f25a90552a 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1561,7 +1561,6 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
 			GFP_DMA | flags);
 	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
 		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, 0, 0);
 		return ERR_PTR(-ENOMEM);
@@ -1770,7 +1769,6 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
 			GFP_DMA | flags);
 	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
 		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, 0, 0);
 		return ERR_PTR(-ENOMEM);
@@ -3372,10 +3370,8 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 	struct crypto_alg *alg;
 
 	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
-	if (!t_alg) {
-		pr_err("failed to allocate t_alg\n");
+	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	alg = &t_alg->crypto_alg;
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0beb28196e20..dc269eba08ad 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -362,10 +362,8 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	int ret;
 
 	desc = kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
-	if (!desc) {
-		dev_err(jrdev, "unable to allocate key input memory\n");
+	if (!desc)
 		return -ENOMEM;
-	}
 
 	init_job_desc(desc, 0);
 
@@ -689,10 +687,8 @@ static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
 	unsigned int sg_size = sg_num * sizeof(struct sec4_sg_entry);
 
 	edesc = kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
+	if (!edesc)
 		return NULL;
-	}
 
 	init_job_desc_shared(edesc->hw_desc, sh_desc_dma, desc_len(sh_desc),
 			     HDR_SHARE_DEFER | HDR_REVERSE);
@@ -1818,10 +1814,8 @@ caam_hash_alloc(struct caam_hash_template *template,
 	struct crypto_alg *alg;
 
 	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
-	if (!t_alg) {
-		pr_err("failed to allocate t_alg\n");
+	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	t_alg->ahash_alg = template->template_ahash;
 	halg = &t_alg->ahash_alg;
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 312b5f042f31..dd077ac8c41e 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -66,10 +66,8 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 		return -EINVAL;
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
-	if (!desc) {
-		dev_err(jrdev, "unable to allocate key input memory\n");
+	if (!desc)
 		return ret;
-	}
 
 	dma_addr_in = dma_map_single(jrdev, (void *)key_in, keylen,
 				     DMA_TO_DEVICE);
-- 
2.16.1

