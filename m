From: Christoph Manszewski <c.manszewski@samsung.com>
Subject: [PATCH v2 3/4] crypto: s5p-sss: Minor code cleanup
Date: Mon, 17 Sep 2018 17:09:29 +0200
Message-ID: <20180917151009eucas1p145fdde4a56241418a49a1da14c5bdb02~VOIkhD_S60202502025eucas1p1F@eucas1p1.samsung.com>
References: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180917151009eucas1p145fdde4a56241418a49a1da14c5bdb02@eucas1p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537196970-5987-1-git-send-email-c.manszewski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Modifications in s5p-sss.c:
- remove unnecessary 'goto' statements (making code shorter),
- change uint_8 and uint_32 to u8 and u32 types (for consistency in the
driver and making code shorter),

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 54 +++++++++++++++---------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index b7216935236f..ba8f2e2ea88f 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -249,8 +249,8 @@ struct s5p_aes_reqctx {
 struct s5p_aes_ctx {
 	struct s5p_aes_dev		*dev;
 
-	uint8_t				aes_key[AES_MAX_KEY_SIZE];
-	uint8_t				nonce[CTR_RFC3686_NONCE_SIZE];
+	u8				aes_key[AES_MAX_KEY_SIZE];
+	u8				nonce[CTR_RFC3686_NONCE_SIZE];
 	int				keylen;
 };
 
@@ -518,46 +518,28 @@ static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
 
 static int s5p_set_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
-	int err;
-
-	if (!sg->length) {
-		err = -EINVAL;
-		goto exit;
-	}
+	if (!sg->length)
+		return -EINVAL;
 
-	err = dma_map_sg(dev->dev, sg, 1, DMA_FROM_DEVICE);
-	if (!err) {
-		err = -ENOMEM;
-		goto exit;
-	}
+	if (!dma_map_sg(dev->dev, sg, 1, DMA_FROM_DEVICE))
+		return -ENOMEM;
 
 	dev->sg_dst = sg;
-	err = 0;
 
-exit:
-	return err;
+	return 0;
 }
 
 static int s5p_set_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
-	int err;
-
-	if (!sg->length) {
-		err = -EINVAL;
-		goto exit;
-	}
+	if (!sg->length)
+		return -EINVAL;
 
-	err = dma_map_sg(dev->dev, sg, 1, DMA_TO_DEVICE);
-	if (!err) {
-		err = -ENOMEM;
-		goto exit;
-	}
+	if (!dma_map_sg(dev->dev, sg, 1, DMA_TO_DEVICE))
+		return -ENOMEM;
 
 	dev->sg_src = sg;
-	err = 0;
 
-exit:
-	return err;
+	return 0;
 }
 
 /*
@@ -662,8 +644,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 	bool tx_end = false;
 	bool hx_end = false;
 	unsigned long flags;
-	uint32_t status;
-	u32 st_bits;
+	u32 status, st_bits;
 	int err;
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -1832,7 +1813,7 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 };
 
 static void s5p_set_aes(struct s5p_aes_dev *dev,
-			const uint8_t *key, const uint8_t *iv,
+			const u8 *key, const u8 *iv,
 			unsigned int keylen)
 {
 	void __iomem *keystart;
@@ -1918,7 +1899,7 @@ static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
 static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 {
 	struct ablkcipher_request *req = dev->req;
-	uint32_t aes_control;
+	u32 aes_control;
 	unsigned long flags;
 	int err;
 	u8 *iv;
@@ -2026,7 +2007,7 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 	err = ablkcipher_enqueue_request(&dev->queue, req);
 	if (dev->busy) {
 		spin_unlock_irqrestore(&dev->lock, flags);
-		goto exit;
+		return err;
 	}
 	dev->busy = true;
 
@@ -2034,7 +2015,6 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 
 	tasklet_schedule(&dev->tasklet);
 
-exit:
 	return err;
 }
 
@@ -2056,7 +2036,7 @@ static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 }
 
 static int s5p_aes_setkey(struct crypto_ablkcipher *cipher,
-			  const uint8_t *key, unsigned int keylen)
+			  const u8 *key, unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct s5p_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
2.7.4
