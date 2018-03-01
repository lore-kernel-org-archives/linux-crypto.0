From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4/4] crypto: s5p-sss - Constify pointed data (arguments and local variables)
Date: Thu,  1 Mar 2018 21:50:13 +0100
Message-ID: <1519937413-24468-4-git-send-email-krzk@kernel.org>
References: <1519937413-24468-1-git-send-email-krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519937413-24468-1-git-send-email-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Improve the code (safety and readability) by indicating that data passed
through pointer is not modified.  This adds const keyword in many places,
most notably:
 - the driver data (pointer to struct samsung_aes_variant),
 - scatterlist addresses written as value to device registers,
 - key and IV arrays.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index d7c8163e5068..bf7163042569 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -404,29 +404,31 @@ static const struct of_device_id s5p_sss_dt_match[] = {
 };
 MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
 
-static inline struct samsung_aes_variant *find_s5p_sss_version
-				   (struct platform_device *pdev)
+static inline const struct samsung_aes_variant *find_s5p_sss_version
+				   (const struct platform_device *pdev)
 {
 	if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node)) {
 		const struct of_device_id *match;
 
 		match = of_match_node(s5p_sss_dt_match,
 					pdev->dev.of_node);
-		return (struct samsung_aes_variant *)match->data;
+		return (const struct samsung_aes_variant *)match->data;
 	}
-	return (struct samsung_aes_variant *)
+	return (const struct samsung_aes_variant *)
 			platform_get_device_id(pdev)->driver_data;
 }
 
 static struct s5p_aes_dev *s5p_dev;
 
-static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
+static void s5p_set_dma_indata(struct s5p_aes_dev *dev,
+			       const struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
 	SSS_WRITE(dev, FCBRDMAL, sg_dma_len(sg));
 }
 
-static void s5p_set_dma_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
+static void s5p_set_dma_outdata(struct s5p_aes_dev *dev,
+				const struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBTDMAS, sg_dma_address(sg));
 	SSS_WRITE(dev, FCBTDMAL, sg_dma_len(sg));
@@ -619,7 +621,7 @@ static inline void s5p_hash_write(struct s5p_aes_dev *dd,
  * @sg:		scatterlist ready to DMA transmit
  */
 static void s5p_set_dma_hashdata(struct s5p_aes_dev *dev,
-				 struct scatterlist *sg)
+				 const struct scatterlist *sg)
 {
 	dev->hash_sg_cnt--;
 	SSS_WRITE(dev, FCHRDMAS, sg_dma_address(sg));
@@ -792,9 +794,9 @@ static void s5p_hash_read_msg(struct ahash_request *req)
  * @ctx:	request context
  */
 static void s5p_hash_write_ctx_iv(struct s5p_aes_dev *dd,
-				  struct s5p_hash_reqctx *ctx)
+				  const struct s5p_hash_reqctx *ctx)
 {
-	u32 *hash = (u32 *)ctx->digest;
+	const u32 *hash = (const u32 *)ctx->digest;
 	unsigned int i;
 
 	for (i = 0; i < ctx->nregs; i++)
@@ -818,7 +820,7 @@ static void s5p_hash_write_iv(struct ahash_request *req)
  */
 static void s5p_hash_copy_result(struct ahash_request *req)
 {
-	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	const struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
 
 	if (!req->result)
 		return;
@@ -1290,7 +1292,7 @@ static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
  */
 static void s5p_hash_update_dma_stop(struct s5p_aes_dev *dd)
 {
-	struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
+	const struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
 
 	dma_unmap_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE);
 	clear_bit(HASH_FLAGS_DMA_ACTIVE, &dd->hash_flags);
@@ -1717,7 +1719,7 @@ static void s5p_hash_cra_exit(struct crypto_tfm *tfm)
  */
 static int s5p_hash_export(struct ahash_request *req, void *out)
 {
-	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
+	const struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
 
 	memcpy(out, ctx, sizeof(*ctx) + ctx->bufcnt);
 
@@ -1831,7 +1833,8 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 };
 
 static void s5p_set_aes(struct s5p_aes_dev *dev,
-			uint8_t *key, uint8_t *iv, unsigned int keylen)
+			const uint8_t *key, const uint8_t *iv,
+			unsigned int keylen)
 {
 	void __iomem *keystart;
 
@@ -2150,7 +2153,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	int i, j, err = -ENODEV;
-	struct samsung_aes_variant *variant;
+	const struct samsung_aes_variant *variant;
 	struct s5p_aes_dev *pdata;
 	struct resource *res;
 	unsigned int hash_i;
-- 
2.7.4
