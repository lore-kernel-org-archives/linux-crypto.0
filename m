From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] crypto: s5p-sss - Use consistent indentation for variables and
 members
Date: Fri, 27 May 2016 13:49:40 +0200
Message-ID: <1464349780-27674-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Vladimir Zapolskiy <vz@mleia.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11697 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcE0Lty (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 07:49:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Bring some consistency by:
1. Replacing fixed-space indentation of structure members with just
   tabs.
2. Remove indentation in declaration of local variable between type and
   name.  Driver was mixing usage of such indentation and lack of it.
   When removing indentation, reorder variables in
   reversed-christmas-tree order with first variables being initialized
   ones.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/crypto/s5p-sss.c | 80 ++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 2b3a0cfe3331..dce1af0ce85c 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -155,43 +155,43 @@
  * expansion of its usage.
  */
 struct samsung_aes_variant {
-	unsigned int		    aes_offset;
+	unsigned int			aes_offset;
 };
 
 struct s5p_aes_reqctx {
-	unsigned long mode;
+	unsigned long			mode;
 };
 
 struct s5p_aes_ctx {
-	struct s5p_aes_dev         *dev;
+	struct s5p_aes_dev		*dev;
 
-	uint8_t                     aes_key[AES_MAX_KEY_SIZE];
-	uint8_t                     nonce[CTR_RFC3686_NONCE_SIZE];
-	int                         keylen;
+	uint8_t				aes_key[AES_MAX_KEY_SIZE];
+	uint8_t				nonce[CTR_RFC3686_NONCE_SIZE];
+	int				keylen;
 };
 
 struct s5p_aes_dev {
-	struct device              *dev;
-	struct clk                 *clk;
-	void __iomem               *ioaddr;
-	void __iomem               *aes_ioaddr;
-	int                         irq_fc;
+	struct device			*dev;
+	struct clk			*clk;
+	void __iomem			*ioaddr;
+	void __iomem			*aes_ioaddr;
+	int				irq_fc;
 
-	struct ablkcipher_request  *req;
-	struct s5p_aes_ctx         *ctx;
-	struct scatterlist         *sg_src;
-	struct scatterlist         *sg_dst;
+	struct ablkcipher_request	*req;
+	struct s5p_aes_ctx		*ctx;
+	struct scatterlist		*sg_src;
+	struct scatterlist		*sg_dst;
 
 	/* In case of unaligned access: */
-	struct scatterlist         *sg_src_cpy;
-	struct scatterlist         *sg_dst_cpy;
+	struct scatterlist		*sg_src_cpy;
+	struct scatterlist		*sg_dst_cpy;
 
-	struct tasklet_struct       tasklet;
-	struct crypto_queue         queue;
-	bool                        busy;
-	spinlock_t                  lock;
+	struct tasklet_struct		tasklet;
+	struct crypto_queue		queue;
+	bool				busy;
+	spinlock_t			lock;
 
-	struct samsung_aes_variant *variant;
+	struct samsung_aes_variant	*variant;
 };
 
 static struct s5p_aes_dev *s5p_dev;
@@ -421,11 +421,11 @@ static bool s5p_aes_rx(struct s5p_aes_dev *dev)
 static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
-	struct s5p_aes_dev     *dev  = platform_get_drvdata(pdev);
-	uint32_t                status;
-	unsigned long           flags;
-	bool			set_dma_tx = false;
-	bool			set_dma_rx = false;
+	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
+	bool set_dma_tx = false;
+	bool set_dma_rx = false;
+	unsigned long flags;
+	uint32_t status;
 
 	spin_lock_irqsave(&dev->lock, flags);
 
@@ -538,10 +538,10 @@ static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
 
 static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 {
-	struct ablkcipher_request  *req = dev->req;
-	uint32_t                    aes_control;
-	int                         err;
-	unsigned long               flags;
+	struct ablkcipher_request *req = dev->req;
+	uint32_t aes_control;
+	unsigned long flags;
+	int err;
 
 	aes_control = SSS_AES_KEY_CHANGE_MODE;
 	if (mode & FLAGS_AES_DECRYPT)
@@ -653,10 +653,10 @@ exit:
 
 static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
-	struct crypto_ablkcipher   *tfm    = crypto_ablkcipher_reqtfm(req);
-	struct s5p_aes_ctx         *ctx    = crypto_ablkcipher_ctx(tfm);
-	struct s5p_aes_reqctx      *reqctx = ablkcipher_request_ctx(req);
-	struct s5p_aes_dev         *dev    = ctx->dev;
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct s5p_aes_reqctx *reqctx = ablkcipher_request_ctx(req);
+	struct s5p_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct s5p_aes_dev *dev = ctx->dev;
 
 	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
 		dev_err(dev->dev, "request size is not exact amount of AES blocks\n");
@@ -671,7 +671,7 @@ static int s5p_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 static int s5p_aes_setkey(struct crypto_ablkcipher *cipher,
 			  const uint8_t *key, unsigned int keylen)
 {
-	struct crypto_tfm  *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct s5p_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (keylen != AES_KEYSIZE_128 &&
@@ -763,11 +763,11 @@ static struct crypto_alg algs[] = {
 
 static int s5p_aes_probe(struct platform_device *pdev)
 {
-	int                 i, j, err = -ENODEV;
-	struct s5p_aes_dev *pdata;
-	struct device      *dev = &pdev->dev;
-	struct resource    *res;
+	struct device *dev = &pdev->dev;
+	int i, j, err = -ENODEV;
 	struct samsung_aes_variant *variant;
+	struct s5p_aes_dev *pdata;
+	struct resource *res;
 
 	if (s5p_dev)
 		return -EEXIST;
-- 
1.9.1
