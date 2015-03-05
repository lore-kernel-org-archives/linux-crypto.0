From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 11/17] crypto: talitos - Move hash chain handling into talitos2.h
Date: Thu,  5 Mar 2015 17:46:06 +0100 (CET)
Message-ID: <20150305164607.006801A2425@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move hash chain handling into talitos2.h as only SEC2 has sg chaining capatibility

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  | 34 ----------------------------------
 drivers/crypto/talitos2.h | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3190762..6c1f6f1 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -458,23 +458,6 @@ static void talitos_unregister_rng(struct device *dev)
 
 #define MD5_BLOCK_SIZE    64
 
-#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
-#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
-
-struct talitos_ahash_req_ctx {
-	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
-	unsigned int hw_context_size;
-	u8 buf[HASH_MAX_BLOCK_SIZE];
-	u8 bufnext[HASH_MAX_BLOCK_SIZE];
-	unsigned int swinit;
-	unsigned int first;
-	unsigned int last;
-	unsigned int to_hash_later;
-	u64 nbuf;
-	struct scatterlist bufsl[2];
-	struct scatterlist *psrc;
-};
-
 /*
  * derive number of elements in scatterlist
  */
@@ -913,23 +896,6 @@ static int ahash_init_sha224_swinit(struct ahash_request *areq)
 	return 0;
 }
 
-static void ahash_process_chain(struct scatterlist *src, int nbytes,
-				bool *chained,
-				struct talitos_ahash_req_ctx *req_ctx,
-				int nbytes_to_hash)
-{
-	if (req_ctx->nbuf) {
-		unsigned int nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
-
-		sg_init_table(req_ctx->bufsl, nsg);
-		sg_set_buf(req_ctx->bufsl, req_ctx->buf, req_ctx->nbuf);
-		if (nsg > 1)
-			scatterwalk_sg_chain(req_ctx->bufsl, 2, src);
-		req_ctx->psrc = req_ctx->bufsl;
-	} else
-		req_ctx->psrc = src;
-}
-
 static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index 10c7313..7edc563 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -223,6 +223,40 @@ static inline void do_init_device(struct talitos_private *priv)
 	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
 }
 
+#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
+#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
+
+struct talitos_ahash_req_ctx {
+	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
+	unsigned int hw_context_size;
+	u8 buf[HASH_MAX_BLOCK_SIZE];
+	u8 bufnext[HASH_MAX_BLOCK_SIZE];
+	unsigned int swinit;
+	unsigned int first;
+	unsigned int last;
+	unsigned int to_hash_later;
+	u64 nbuf;
+	struct scatterlist bufsl[2];
+	struct scatterlist *psrc;
+};
+
+static inline void ahash_process_chain(struct scatterlist *src, int nbytes,
+				bool *chained,
+				struct talitos_ahash_req_ctx *req_ctx,
+				int nbytes_to_hash)
+{
+	if (req_ctx->nbuf) {
+		unsigned int nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
+
+		sg_init_table(req_ctx->bufsl, nsg);
+		sg_set_buf(req_ctx->bufsl, req_ctx->buf, req_ctx->nbuf);
+		if (nsg > 1)
+			scatterwalk_sg_chain(req_ctx->bufsl, 2, src);
+		req_ctx->psrc = req_ctx->bufsl;
+	} else
+		req_ctx->psrc = src;
+}
+
 #define DEF_TALITOS_DONE(name, ch_done_mask)				\
 static void talitos_done_##name(unsigned long data)			\
 {									\
-- 
2.1.0
