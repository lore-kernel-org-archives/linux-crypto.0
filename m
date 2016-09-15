From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/6] crypto-caamhash: Delete an unnecessary initialisation in
 seven functions
Date: Thu, 15 Sep 2016 16:44:34 +0200
Message-ID: <a904a514-57f1-6c1a-4839-6150ddacf960@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Sep 2016 15:24:02 +0200

The local variable "ret" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamhash.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index b1dbc53..adb8b19 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -440,7 +440,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	u32 *desc;
 	struct split_key_result result;
 	dma_addr_t src_dma, dst_dma;
-	int ret = 0;
+	int ret;
 
 	desc = kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
@@ -517,7 +517,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 	struct device *jrdev = ctx->jrdev;
 	int blocksize = crypto_tfm_alg_blocksize(&ahash->base);
 	int digestsize = crypto_ahash_digestsize(ahash);
-	int ret = 0;
+	int ret;
 	u8 *hashed_key = NULL;
 
 #ifdef DEBUG
@@ -975,7 +975,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	int sec4_sg_bytes, sec4_sg_src_index;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	int ret = 0;
+	int ret;
 
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
 	sec4_sg_bytes = sec4_sg_src_index * sizeof(struct sec4_sg_entry);
@@ -1055,7 +1055,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	int ret = 0;
+	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
@@ -1139,7 +1139,7 @@ static int ahash_digest(struct ahash_request *req)
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
-	int ret = 0;
+	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
@@ -1218,7 +1218,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	int ret = 0;
+	int ret;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, 0, ctx->sh_desc_digest,
@@ -1408,7 +1408,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	int ret = 0;
+	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
-- 
2.10.0

