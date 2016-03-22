From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 2/3] crypto: s5p-sss - Handle unaligned buffers
Date: Tue, 22 Mar 2016 10:58:24 +0900
Message-ID: <1458611905-30157-2-git-send-email-k.kozlowski@samsung.com>
References: <1458611905-30157-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1458611905-30157-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

During crypto selftests on Odroid XU3 (Exynos5422) some of the
algorithms failed because of passing AES-block unaligned source and
destination buffers:

alg: skcipher: encryption failed on chunk test 1 for ecb-aes-s5p: ret=22

Handle such case by copying the buffers to a new aligned and contiguous
space.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>

---

Changes since v2:
1. Fix infinite loop in s5p_is_sg_aligned().

Changes since v1:
1. Add Vladimir's acked-by.

Driver tested on Exynos4412/Trats2 and Exynos5422/Odroid XU4 with crypto
manager self-tests and tcrypt:
$ modprobe tcrypt sec=1 mode=500
---
 drivers/crypto/s5p-sss.c | 150 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 138 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 60f835455a41..3730fb0af4d8 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -28,6 +28,7 @@
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
+#include <crypto/scatterwalk.h>
 
 #define _SBF(s, v)                      ((v) << (s))
 #define _BIT(b)                         _SBF(b, 1)
@@ -185,6 +186,10 @@ struct s5p_aes_dev {
 	struct scatterlist         *sg_src;
 	struct scatterlist         *sg_dst;
 
+	/* In case of unaligned access: */
+	struct scatterlist         *sg_src_cpy;
+	struct scatterlist         *sg_dst_cpy;
+
 	struct tasklet_struct       tasklet;
 	struct crypto_queue         queue;
 	bool                        busy;
@@ -244,8 +249,45 @@ static void s5p_set_dma_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 	SSS_WRITE(dev, FCBTDMAL, sg_dma_len(sg));
 }
 
+static void s5p_free_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist **sg)
+{
+	int len;
+
+	if (!*sg)
+		return;
+
+	len = ALIGN(dev->req->nbytes, AES_BLOCK_SIZE);
+	free_pages((unsigned long)sg_virt(*sg), get_order(len));
+
+	kfree(*sg);
+	*sg = NULL;
+}
+
+static void s5p_sg_copy_buf(void *buf, struct scatterlist *sg,
+			    unsigned int nbytes, int out)
+{
+	struct scatter_walk walk;
+
+	if (!nbytes)
+		return;
+
+	scatterwalk_start(&walk, sg);
+	scatterwalk_copychunks(buf, &walk, nbytes, out);
+	scatterwalk_done(&walk, out, 0);
+}
+
 static void s5p_aes_complete(struct s5p_aes_dev *dev, int err)
 {
+	if (dev->sg_dst_cpy) {
+		dev_dbg(dev->dev,
+			"Copying %d bytes of output data back to original place\n",
+			dev->req->nbytes);
+		s5p_sg_copy_buf(sg_virt(dev->sg_dst_cpy), dev->req->dst,
+				dev->req->nbytes, 1);
+	}
+	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
+	s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
+
 	/* holding a lock outside */
 	dev->req->base.complete(&dev->req->base, err);
 	dev->busy = false;
@@ -261,14 +303,36 @@ static void s5p_unset_indata(struct s5p_aes_dev *dev)
 	dma_unmap_sg(dev->dev, dev->sg_src, 1, DMA_TO_DEVICE);
 }
 
+static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
+			    struct scatterlist **dst)
+{
+	void *pages;
+	int len;
+
+	*dst = kmalloc(sizeof(**dst), GFP_ATOMIC);
+	if (!*dst)
+		return -ENOMEM;
+
+	len = ALIGN(dev->req->nbytes, AES_BLOCK_SIZE);
+	pages = (void *)__get_free_pages(GFP_ATOMIC, get_order(len));
+	if (!pages) {
+		kfree(*dst);
+		*dst = NULL;
+		return -ENOMEM;
+	}
+
+	s5p_sg_copy_buf(pages, src, dev->req->nbytes, 0);
+
+	sg_init_table(*dst, 1);
+	sg_set_buf(*dst, pages, len);
+
+	return 0;
+}
+
 static int s5p_set_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	int err;
 
-	if (!IS_ALIGNED(sg_dma_len(sg), AES_BLOCK_SIZE)) {
-		err = -EINVAL;
-		goto exit;
-	}
 	if (!sg_dma_len(sg)) {
 		err = -EINVAL;
 		goto exit;
@@ -291,10 +355,6 @@ static int s5p_set_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	int err;
 
-	if (!IS_ALIGNED(sg_dma_len(sg), AES_BLOCK_SIZE)) {
-		err = -EINVAL;
-		goto exit;
-	}
 	if (!sg_dma_len(sg)) {
 		err = -EINVAL;
 		goto exit;
@@ -394,6 +454,71 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	memcpy_toio(keystart, key, keylen);
 }
 
+static bool s5p_is_sg_aligned(struct scatterlist *sg)
+{
+	while (sg) {
+		if (!IS_ALIGNED(sg_dma_len(sg), AES_BLOCK_SIZE))
+			return false;
+		sg = sg_next(sg);
+	}
+
+	return true;
+}
+
+static int s5p_set_indata_start(struct s5p_aes_dev *dev,
+				struct ablkcipher_request *req)
+{
+	struct scatterlist *sg;
+	int err;
+
+	dev->sg_src_cpy = NULL;
+	sg = req->src;
+	if (!s5p_is_sg_aligned(sg)) {
+		dev_dbg(dev->dev,
+			"At least one unaligned source scatter list, making a copy\n");
+		err = s5p_make_sg_cpy(dev, sg, &dev->sg_src_cpy);
+		if (err)
+			return err;
+
+		sg = dev->sg_src_cpy;
+	}
+
+	err = s5p_set_indata(dev, sg);
+	if (err) {
+		s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
+		return err;
+	}
+
+	return 0;
+}
+
+static int s5p_set_outdata_start(struct s5p_aes_dev *dev,
+				struct ablkcipher_request *req)
+{
+	struct scatterlist *sg;
+	int err;
+
+	dev->sg_dst_cpy = NULL;
+	sg = req->dst;
+	if (!s5p_is_sg_aligned(sg)) {
+		dev_dbg(dev->dev,
+			"At least one unaligned dest scatter list, making a copy\n");
+		err = s5p_make_sg_cpy(dev, sg, &dev->sg_dst_cpy);
+		if (err)
+			return err;
+
+		sg = dev->sg_dst_cpy;
+	}
+
+	err = s5p_set_outdata(dev, sg);
+	if (err) {
+		s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
+		return err;
+	}
+
+	return 0;
+}
+
 static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 {
 	struct ablkcipher_request  *req = dev->req;
@@ -430,19 +555,19 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 		  SSS_FCINTENCLR_BTDMAINTENCLR | SSS_FCINTENCLR_BRDMAINTENCLR);
 	SSS_WRITE(dev, FCFIFOCTRL, 0x00);
 
-	err = s5p_set_indata(dev, req->src);
+	err = s5p_set_indata_start(dev, req);
 	if (err)
 		goto indata_error;
 
-	err = s5p_set_outdata(dev, req->dst);
+	err = s5p_set_outdata_start(dev, req);
 	if (err)
 		goto outdata_error;
 
 	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
 	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
 
-	s5p_set_dma_indata(dev,  req->src);
-	s5p_set_dma_outdata(dev, req->dst);
+	s5p_set_dma_indata(dev,  dev->sg_src);
+	s5p_set_dma_outdata(dev, dev->sg_dst);
 
 	SSS_WRITE(dev, FCINTENSET,
 		  SSS_FCINTENSET_BTDMAINTENSET | SSS_FCINTENSET_BRDMAINTENSET);
@@ -452,6 +577,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	return;
 
 outdata_error:
+	s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
 	s5p_unset_indata(dev);
 
 indata_error:
-- 
2.5.0
