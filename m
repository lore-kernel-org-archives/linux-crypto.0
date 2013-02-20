From: Nicolas Royer <nicolas@eukrea.com>
Subject: [PATCH 2/4 v2] crypto: Atmel AES driver: add support for latest release of the IP (0x130)
Date: Wed, 20 Feb 2013 17:10:24 +0100
Message-ID: <1361376626-28987-2-git-send-email-nicolas@eukrea.com>
References: <1361376626-28987-1-git-send-email-nicolas@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, plagnioj@jcrosoft.com, eric@eukrea.com,
	Nicolas Royer <nicolas@eukrea.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:46739 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935313Ab3BTQLY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Feb 2013 11:11:24 -0500
In-Reply-To: <1361376626-28987-1-git-send-email-nicolas@eukrea.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Updates from previous IP release (0x120):
 - add cfb64 support
 - add DMA double input buffer support

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric B=C3=A9nard <eric@eukrea.com>
Tested-by: Eric B=C3=A9nard <eric@eukrea.com>
---
v2 : add CKEY fix.

 drivers/crypto/atmel-aes.c | 471 +++++++++++++++++++++++++++++++++----=
--------
 1 file changed, 353 insertions(+), 118 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index c9d9d5c..e1c85cb 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -38,7 +38,7 @@
 #include <crypto/aes.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
-#include <linux/platform_data/atmel-aes.h>
+#include <linux/platform_data/crypto-atmel.h>
 #include "atmel-aes-regs.h"
=20
 #define CFB8_BLOCK_SIZE		1
@@ -47,7 +47,7 @@
 #define CFB64_BLOCK_SIZE	8
=20
 /* AES flags */
-#define AES_FLAGS_MODE_MASK	0x01ff
+#define AES_FLAGS_MODE_MASK	0x03ff
 #define AES_FLAGS_ENCRYPT	BIT(0)
 #define AES_FLAGS_CBC		BIT(1)
 #define AES_FLAGS_CFB		BIT(2)
@@ -55,21 +55,26 @@
 #define AES_FLAGS_CFB16		BIT(4)
 #define AES_FLAGS_CFB32		BIT(5)
 #define AES_FLAGS_CFB64		BIT(6)
-#define AES_FLAGS_OFB		BIT(7)
-#define AES_FLAGS_CTR		BIT(8)
+#define AES_FLAGS_CFB128	BIT(7)
+#define AES_FLAGS_OFB		BIT(8)
+#define AES_FLAGS_CTR		BIT(9)
=20
 #define AES_FLAGS_INIT		BIT(16)
 #define AES_FLAGS_DMA		BIT(17)
 #define AES_FLAGS_BUSY		BIT(18)
+#define AES_FLAGS_FAST		BIT(19)
=20
-#define AES_FLAGS_DUALBUFF	BIT(24)
-
-#define ATMEL_AES_QUEUE_LENGTH	1
-#define ATMEL_AES_CACHE_SIZE	0
+#define ATMEL_AES_QUEUE_LENGTH	50
=20
 #define ATMEL_AES_DMA_THRESHOLD		16
=20
=20
+struct atmel_aes_caps {
+	bool	has_dualbuff;
+	bool	has_cfb64;
+	u32		max_burst_size;
+};
+
 struct atmel_aes_dev;
=20
 struct atmel_aes_ctx {
@@ -77,6 +82,8 @@ struct atmel_aes_ctx {
=20
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
+
+	u16		block_size;
 };
=20
 struct atmel_aes_reqctx {
@@ -112,20 +119,27 @@ struct atmel_aes_dev {
=20
 	struct scatterlist	*in_sg;
 	unsigned int		nb_in_sg;
-
+	size_t				in_offset;
 	struct scatterlist	*out_sg;
 	unsigned int		nb_out_sg;
+	size_t				out_offset;
=20
 	size_t	bufcnt;
+	size_t	buflen;
+	size_t	dma_size;
=20
-	u8	buf_in[ATMEL_AES_DMA_THRESHOLD] __aligned(sizeof(u32));
-	int	dma_in;
+	void	*buf_in;
+	int		dma_in;
+	dma_addr_t	dma_addr_in;
 	struct atmel_aes_dma	dma_lch_in;
=20
-	u8	buf_out[ATMEL_AES_DMA_THRESHOLD] __aligned(sizeof(u32));
-	int	dma_out;
+	void	*buf_out;
+	int		dma_out;
+	dma_addr_t	dma_addr_out;
 	struct atmel_aes_dma	dma_lch_out;
=20
+	struct atmel_aes_caps	caps;
+
 	u32	hw_version;
 };
=20
@@ -165,6 +179,37 @@ static int atmel_aes_sg_length(struct ablkcipher_r=
equest *req,
 	return sg_nb;
 }
=20
+static int atmel_aes_sg_copy(struct scatterlist **sg, size_t *offset,
+			void *buf, size_t buflen, size_t total, int out)
+{
+	unsigned int count, off =3D 0;
+
+	while (buflen && total) {
+		count =3D min((*sg)->length - *offset, total);
+		count =3D min(count, buflen);
+
+		if (!count)
+			return off;
+
+		scatterwalk_map_and_copy(buf + off, *sg, *offset, count, out);
+
+		off +=3D count;
+		buflen -=3D count;
+		*offset +=3D count;
+		total -=3D count;
+
+		if (*offset =3D=3D (*sg)->length) {
+			*sg =3D sg_next(*sg);
+			if (*sg)
+				*offset =3D 0;
+			else
+				total =3D 0;
+		}
+	}
+
+	return off;
+}
+
 static inline u32 atmel_aes_read(struct atmel_aes_dev *dd, u32 offset)
 {
 	return readl_relaxed(dd->io_base + offset);
@@ -190,14 +235,6 @@ static void atmel_aes_write_n(struct atmel_aes_dev=
 *dd, u32 offset,
 		atmel_aes_write(dd, offset, *value);
 }
=20
-static void atmel_aes_dualbuff_test(struct atmel_aes_dev *dd)
-{
-	atmel_aes_write(dd, AES_MR, AES_MR_DUALBUFF);
-
-	if (atmel_aes_read(dd, AES_MR) & AES_MR_DUALBUFF)
-		dd->flags |=3D AES_FLAGS_DUALBUFF;
-}
-
 static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_ctx *=
ctx)
 {
 	struct atmel_aes_dev *aes_dd =3D NULL;
@@ -225,7 +262,7 @@ static int atmel_aes_hw_init(struct atmel_aes_dev *=
dd)
=20
 	if (!(dd->flags & AES_FLAGS_INIT)) {
 		atmel_aes_write(dd, AES_CR, AES_CR_SWRST);
-		atmel_aes_dualbuff_test(dd);
+		atmel_aes_write(dd, AES_MR, 0xE << AES_MR_CKEY_OFFSET);
 		dd->flags |=3D AES_FLAGS_INIT;
 		dd->err =3D 0;
 	}
@@ -233,11 +270,19 @@ static int atmel_aes_hw_init(struct atmel_aes_dev=
 *dd)
 	return 0;
 }
=20
+static inline unsigned int atmel_aes_get_version(struct atmel_aes_dev =
*dd)
+{
+	return atmel_aes_read(dd, AES_HW_VERSION) & 0x00000fff;
+}
+
 static void atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
 {
 	atmel_aes_hw_init(dd);
=20
-	dd->hw_version =3D atmel_aes_read(dd, AES_HW_VERSION);
+	dd->hw_version =3D atmel_aes_get_version(dd);
+
+	dev_info(dd->dev,
+			"version: 0x%x\n", dd->hw_version);
=20
 	clk_disable_unprepare(dd->iclk);
 }
@@ -260,50 +305,77 @@ static void atmel_aes_dma_callback(void *data)
 	tasklet_schedule(&dd->done_task);
 }
=20
-static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd)
+static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
+		dma_addr_t dma_addr_in, dma_addr_t dma_addr_out, int length)
 {
+	struct scatterlist sg[2];
 	struct dma_async_tx_descriptor	*in_desc, *out_desc;
-	int nb_dma_sg_in, nb_dma_sg_out;
=20
-	dd->nb_in_sg =3D atmel_aes_sg_length(dd->req, dd->in_sg);
-	if (!dd->nb_in_sg)
-		goto exit_err;
+	dd->dma_size =3D length;
=20
-	nb_dma_sg_in =3D dma_map_sg(dd->dev, dd->in_sg, dd->nb_in_sg,
-			DMA_TO_DEVICE);
-	if (!nb_dma_sg_in)
-		goto exit_err;
+	if (!(dd->flags & AES_FLAGS_FAST)) {
+		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
+					   DMA_TO_DEVICE);
+	}
=20
-	in_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_in.chan, dd->in_sg,
-				nb_dma_sg_in, DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT  |  DMA_CTRL_ACK);
+	if (dd->flags & AES_FLAGS_CFB8) {
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_1_BYTE;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_1_BYTE;
+	} else if (dd->flags & AES_FLAGS_CFB16) {
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_2_BYTES;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_2_BYTES;
+	} else {
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+	}
=20
-	if (!in_desc)
-		goto unmap_in;
+	if (dd->flags & (AES_FLAGS_CFB8 | AES_FLAGS_CFB16 |
+			AES_FLAGS_CFB32 | AES_FLAGS_CFB64)) {
+		dd->dma_lch_in.dma_conf.src_maxburst =3D 1;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D 1;
+		dd->dma_lch_out.dma_conf.src_maxburst =3D 1;
+		dd->dma_lch_out.dma_conf.dst_maxburst =3D 1;
+	} else {
+		dd->dma_lch_in.dma_conf.src_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_out.dma_conf.src_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_out.dma_conf.dst_maxburst =3D dd->caps.max_burst_size;
+	}
=20
-	/* callback not needed */
+	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf)=
;
+	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_con=
f);
=20
-	dd->nb_out_sg =3D atmel_aes_sg_length(dd->req, dd->out_sg);
-	if (!dd->nb_out_sg)
-		goto unmap_in;
+	dd->flags |=3D AES_FLAGS_DMA;
=20
-	nb_dma_sg_out =3D dma_map_sg(dd->dev, dd->out_sg, dd->nb_out_sg,
-			DMA_FROM_DEVICE);
-	if (!nb_dma_sg_out)
-		goto unmap_out;
+	sg_init_table(&sg[0], 1);
+	sg_dma_address(&sg[0]) =3D dma_addr_in;
+	sg_dma_len(&sg[0]) =3D length;
=20
-	out_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_out.chan, dd->out_sg=
,
-				nb_dma_sg_out, DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	sg_init_table(&sg[1], 1);
+	sg_dma_address(&sg[1]) =3D dma_addr_out;
+	sg_dma_len(&sg[1]) =3D length;
+
+	in_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_in.chan, &sg[0],
+				1, DMA_MEM_TO_DEV,
+				DMA_PREP_INTERRUPT  |  DMA_CTRL_ACK);
+	if (!in_desc)
+		return -EINVAL;
=20
+	out_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_out.chan, &sg[1],
+				1, DMA_DEV_TO_MEM,
+				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!out_desc)
-		goto unmap_out;
+		return -EINVAL;
=20
 	out_desc->callback =3D atmel_aes_dma_callback;
 	out_desc->callback_param =3D dd;
=20
-	dd->total -=3D dd->req->nbytes;
-
 	dmaengine_submit(out_desc);
 	dma_async_issue_pending(dd->dma_lch_out.chan);
=20
@@ -311,15 +383,6 @@ static int atmel_aes_crypt_dma(struct atmel_aes_de=
v *dd)
 	dma_async_issue_pending(dd->dma_lch_in.chan);
=20
 	return 0;
-
-unmap_out:
-	dma_unmap_sg(dd->dev, dd->out_sg, dd->nb_out_sg,
-		DMA_FROM_DEVICE);
-unmap_in:
-	dma_unmap_sg(dd->dev, dd->in_sg, dd->nb_in_sg,
-		DMA_TO_DEVICE);
-exit_err:
-	return -EINVAL;
 }
=20
 static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
@@ -352,30 +415,66 @@ static int atmel_aes_crypt_cpu_start(struct atmel=
_aes_dev *dd)
=20
 static int atmel_aes_crypt_dma_start(struct atmel_aes_dev *dd)
 {
-	int err;
+	int err, fast =3D 0, in, out;
+	size_t count;
+	dma_addr_t addr_in, addr_out;
+
+	if ((!dd->in_offset) && (!dd->out_offset)) {
+		/* check for alignment */
+		in =3D IS_ALIGNED((u32)dd->in_sg->offset, sizeof(u32)) &&
+			IS_ALIGNED(dd->in_sg->length, dd->ctx->block_size);
+		out =3D IS_ALIGNED((u32)dd->out_sg->offset, sizeof(u32)) &&
+			IS_ALIGNED(dd->out_sg->length, dd->ctx->block_size);
+		fast =3D in && out;
+
+		if (sg_dma_len(dd->in_sg) !=3D sg_dma_len(dd->out_sg))
+			fast =3D 0;
+	}
+
+
+	if (fast)  {
+		count =3D min(dd->total, sg_dma_len(dd->in_sg));
+		count =3D min(count, sg_dma_len(dd->out_sg));
+
+		err =3D dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+		if (!err) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			return -EINVAL;
+		}
+
+		err =3D dma_map_sg(dd->dev, dd->out_sg, 1,
+				DMA_FROM_DEVICE);
+		if (!err) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			dma_unmap_sg(dd->dev, dd->in_sg, 1,
+				DMA_TO_DEVICE);
+			return -EINVAL;
+		}
+
+		addr_in =3D sg_dma_address(dd->in_sg);
+		addr_out =3D sg_dma_address(dd->out_sg);
+
+		dd->flags |=3D AES_FLAGS_FAST;
=20
-	if (dd->flags & AES_FLAGS_CFB8) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-		dd->dma_lch_out.dma_conf.src_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_1_BYTE;
-	} else if (dd->flags & AES_FLAGS_CFB16) {
-		dd->dma_lch_in.dma_conf.dst_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_2_BYTES;
 	} else {
-		dd->dma_lch_in.dma_conf.dst_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.src_addr_width =3D
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		/* use cache buffers */
+		count =3D atmel_aes_sg_copy(&dd->in_sg, &dd->in_offset,
+				dd->buf_in, dd->buflen, dd->total, 0);
+
+		addr_in =3D dd->dma_addr_in;
+		addr_out =3D dd->dma_addr_out;
+
+		dd->flags &=3D ~AES_FLAGS_FAST;
 	}
=20
-	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf)=
;
-	dmaengine_slave_config(dd->dma_lch_out.chan, &dd->dma_lch_out.dma_con=
f);
+	dd->total -=3D count;
=20
-	dd->flags |=3D AES_FLAGS_DMA;
-	err =3D atmel_aes_crypt_dma(dd);
+	err =3D atmel_aes_crypt_dma(dd, addr_in, addr_out, count);
+
+	if (err && (dd->flags & AES_FLAGS_FAST)) {
+		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+	}
=20
 	return err;
 }
@@ -410,6 +509,8 @@ static int atmel_aes_write_ctrl(struct atmel_aes_de=
v *dd)
 			valmr |=3D AES_MR_CFBS_32b;
 		else if (dd->flags & AES_FLAGS_CFB64)
 			valmr |=3D AES_MR_CFBS_64b;
+		else if (dd->flags & AES_FLAGS_CFB128)
+			valmr |=3D AES_MR_CFBS_128b;
 	} else if (dd->flags & AES_FLAGS_OFB) {
 		valmr |=3D AES_MR_OPMOD_OFB;
 	} else if (dd->flags & AES_FLAGS_CTR) {
@@ -423,7 +524,7 @@ static int atmel_aes_write_ctrl(struct atmel_aes_de=
v *dd)
=20
 	if (dd->total > ATMEL_AES_DMA_THRESHOLD) {
 		valmr |=3D AES_MR_SMOD_IDATAR0;
-		if (dd->flags & AES_FLAGS_DUALBUFF)
+		if (dd->caps.has_dualbuff)
 			valmr |=3D AES_MR_DUALBUFF;
 	} else {
 		valmr |=3D AES_MR_SMOD_AUTO;
@@ -477,7 +578,9 @@ static int atmel_aes_handle_queue(struct atmel_aes_=
dev *dd,
 	/* assign new request to device */
 	dd->req =3D req;
 	dd->total =3D req->nbytes;
+	dd->in_offset =3D 0;
 	dd->in_sg =3D req->src;
+	dd->out_offset =3D 0;
 	dd->out_sg =3D req->dst;
=20
 	rctx =3D ablkcipher_request_ctx(req);
@@ -506,18 +609,86 @@ static int atmel_aes_handle_queue(struct atmel_ae=
s_dev *dd,
 static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
 {
 	int err =3D -EINVAL;
+	size_t count;
=20
 	if (dd->flags & AES_FLAGS_DMA) {
-		dma_unmap_sg(dd->dev, dd->out_sg,
-			dd->nb_out_sg, DMA_FROM_DEVICE);
-		dma_unmap_sg(dd->dev, dd->in_sg,
-			dd->nb_in_sg, DMA_TO_DEVICE);
 		err =3D 0;
+		if  (dd->flags & AES_FLAGS_FAST) {
+			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
+			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+		} else {
+			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
+				dd->dma_size, DMA_FROM_DEVICE);
+
+			/* copy data */
+			count =3D atmel_aes_sg_copy(&dd->out_sg, &dd->out_offset,
+				dd->buf_out, dd->buflen, dd->dma_size, 1);
+			if (count !=3D dd->dma_size) {
+				err =3D -EINVAL;
+				pr_err("not all data converted: %u\n", count);
+			}
+		}
+	}
+
+	return err;
+}
+
+
+static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
+{
+	int err =3D -ENOMEM;
+
+	dd->buf_in =3D (void *)__get_free_pages(GFP_KERNEL, 0);
+	dd->buf_out =3D (void *)__get_free_pages(GFP_KERNEL, 0);
+	dd->buflen =3D PAGE_SIZE;
+	dd->buflen &=3D ~(AES_BLOCK_SIZE - 1);
+
+	if (!dd->buf_in || !dd->buf_out) {
+		dev_err(dd->dev, "unable to alloc pages.\n");
+		goto err_alloc;
+	}
+
+	/* MAP here */
+	dd->dma_addr_in =3D dma_map_single(dd->dev, dd->buf_in,
+					dd->buflen, DMA_TO_DEVICE);
+	if (dma_mapping_error(dd->dev, dd->dma_addr_in)) {
+		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		err =3D -EINVAL;
+		goto err_map_in;
+	}
+
+	dd->dma_addr_out =3D dma_map_single(dd->dev, dd->buf_out,
+					dd->buflen, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dd->dev, dd->dma_addr_out)) {
+		dev_err(dd->dev, "dma %d bytes error\n", dd->buflen);
+		err =3D -EINVAL;
+		goto err_map_out;
 	}
=20
+	return 0;
+
+err_map_out:
+	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
+		DMA_TO_DEVICE);
+err_map_in:
+	free_page((unsigned long)dd->buf_out);
+	free_page((unsigned long)dd->buf_in);
+err_alloc:
+	if (err)
+		pr_err("error: %d\n", err);
 	return err;
 }
=20
+static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
+{
+	dma_unmap_single(dd->dev, dd->dma_addr_out, dd->buflen,
+			 DMA_FROM_DEVICE);
+	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
+		DMA_TO_DEVICE);
+	free_page((unsigned long)dd->buf_out);
+	free_page((unsigned long)dd->buf_in);
+}
+
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned lo=
ng mode)
 {
 	struct atmel_aes_ctx *ctx =3D crypto_ablkcipher_ctx(
@@ -525,9 +696,30 @@ static int atmel_aes_crypt(struct ablkcipher_reque=
st *req, unsigned long mode)
 	struct atmel_aes_reqctx *rctx =3D ablkcipher_request_ctx(req);
 	struct atmel_aes_dev *dd;
=20
-	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
-		pr_err("request size is not exact amount of AES blocks\n");
-		return -EINVAL;
+	if (mode & AES_FLAGS_CFB8) {
+		if (!IS_ALIGNED(req->nbytes, CFB8_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB8 blocks\n");
+			return -EINVAL;
+		}
+		ctx->block_size =3D CFB8_BLOCK_SIZE;
+	} else if (mode & AES_FLAGS_CFB16) {
+		if (!IS_ALIGNED(req->nbytes, CFB16_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB16 blocks\n");
+			return -EINVAL;
+		}
+		ctx->block_size =3D CFB16_BLOCK_SIZE;
+	} else if (mode & AES_FLAGS_CFB32) {
+		if (!IS_ALIGNED(req->nbytes, CFB32_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of CFB32 blocks\n");
+			return -EINVAL;
+		}
+		ctx->block_size =3D CFB32_BLOCK_SIZE;
+	} else {
+		if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
+			pr_err("request size is not exact amount of AES blocks\n");
+			return -EINVAL;
+		}
+		ctx->block_size =3D AES_BLOCK_SIZE;
 	}
=20
 	dd =3D atmel_aes_find_dev(ctx);
@@ -551,14 +743,12 @@ static bool atmel_aes_filter(struct dma_chan *cha=
n, void *slave)
 	}
 }
=20
-static int atmel_aes_dma_init(struct atmel_aes_dev *dd)
+static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
+	struct crypto_platform_data *pdata)
 {
 	int err =3D -ENOMEM;
-	struct aes_platform_data	*pdata;
 	dma_cap_mask_t mask_in, mask_out;
=20
-	pdata =3D dd->dev->platform_data;
-
 	if (pdata && pdata->dma_slave->txdata.dma_dev &&
 		pdata->dma_slave->rxdata.dma_dev) {
=20
@@ -568,28 +758,38 @@ static int atmel_aes_dma_init(struct atmel_aes_de=
v *dd)
=20
 		dd->dma_lch_in.chan =3D dma_request_channel(mask_in,
 				atmel_aes_filter, &pdata->dma_slave->rxdata);
+
 		if (!dd->dma_lch_in.chan)
 			goto err_dma_in;
=20
 		dd->dma_lch_in.dma_conf.direction =3D DMA_MEM_TO_DEV;
 		dd->dma_lch_in.dma_conf.dst_addr =3D dd->phys_base +
 			AES_IDATAR(0);
-		dd->dma_lch_in.dma_conf.src_maxburst =3D 1;
-		dd->dma_lch_in.dma_conf.dst_maxburst =3D 1;
+		dd->dma_lch_in.dma_conf.src_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_in.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
 		dd->dma_lch_in.dma_conf.device_fc =3D false;
=20
 		dma_cap_zero(mask_out);
 		dma_cap_set(DMA_SLAVE, mask_out);
 		dd->dma_lch_out.chan =3D dma_request_channel(mask_out,
 				atmel_aes_filter, &pdata->dma_slave->txdata);
+
 		if (!dd->dma_lch_out.chan)
 			goto err_dma_out;
=20
 		dd->dma_lch_out.dma_conf.direction =3D DMA_DEV_TO_MEM;
 		dd->dma_lch_out.dma_conf.src_addr =3D dd->phys_base +
 			AES_ODATAR(0);
-		dd->dma_lch_out.dma_conf.src_maxburst =3D 1;
-		dd->dma_lch_out.dma_conf.dst_maxburst =3D 1;
+		dd->dma_lch_out.dma_conf.src_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_out.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dd->dma_lch_out.dma_conf.dst_maxburst =3D dd->caps.max_burst_size;
+		dd->dma_lch_out.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
 		dd->dma_lch_out.dma_conf.device_fc =3D false;
=20
 		return 0;
@@ -665,13 +865,13 @@ static int atmel_aes_ofb_decrypt(struct ablkciphe=
r_request *req)
 static int atmel_aes_cfb_encrypt(struct ablkcipher_request *req)
 {
 	return atmel_aes_crypt(req,
-		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB);
+		AES_FLAGS_ENCRYPT | AES_FLAGS_CFB | AES_FLAGS_CFB128);
 }
=20
 static int atmel_aes_cfb_decrypt(struct ablkcipher_request *req)
 {
 	return atmel_aes_crypt(req,
-		AES_FLAGS_CFB);
+		AES_FLAGS_CFB | AES_FLAGS_CFB128);
 }
=20
 static int atmel_aes_cfb64_encrypt(struct ablkcipher_request *req)
@@ -753,7 +953,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0xf,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -773,7 +973,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0xf,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -794,7 +994,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0xf,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -815,7 +1015,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0xf,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -836,7 +1036,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D CFB32_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0x3,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -857,7 +1057,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D CFB16_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0x1,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -899,7 +1099,7 @@ static struct crypto_alg aes_algs[] =3D {
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0xf,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -915,15 +1115,14 @@ static struct crypto_alg aes_algs[] =3D {
 },
 };
=20
-static struct crypto_alg aes_cfb64_alg[] =3D {
-{
+static struct crypto_alg aes_cfb64_alg =3D {
 	.cra_name		=3D "cfb64(aes)",
 	.cra_driver_name	=3D "atmel-cfb64-aes",
 	.cra_priority		=3D 100,
 	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		=3D CFB64_BLOCK_SIZE,
 	.cra_ctxsize		=3D sizeof(struct atmel_aes_ctx),
-	.cra_alignmask		=3D 0x0,
+	.cra_alignmask		=3D 0x7,
 	.cra_type		=3D &crypto_ablkcipher_type,
 	.cra_module		=3D THIS_MODULE,
 	.cra_init		=3D atmel_aes_cra_init,
@@ -936,7 +1135,6 @@ static struct crypto_alg aes_cfb64_alg[] =3D {
 		.encrypt	=3D atmel_aes_cfb64_encrypt,
 		.decrypt	=3D atmel_aes_cfb64_decrypt,
 	}
-},
 };
=20
 static void atmel_aes_queue_task(unsigned long data)
@@ -969,7 +1167,14 @@ static void atmel_aes_done_task(unsigned long dat=
a)
 	err =3D dd->err ? : err;
=20
 	if (dd->total && !err) {
-		err =3D atmel_aes_crypt_dma_start(dd);
+		if (dd->flags & AES_FLAGS_FAST) {
+			dd->in_sg =3D sg_next(dd->in_sg);
+			dd->out_sg =3D sg_next(dd->out_sg);
+			if (!dd->in_sg || !dd->out_sg)
+				err =3D -EINVAL;
+		}
+		if (!err)
+			err =3D atmel_aes_crypt_dma_start(dd);
 		if (!err)
 			return; /* DMA started. Not fininishing. */
 	}
@@ -1003,8 +1208,8 @@ static void atmel_aes_unregister_algs(struct atme=
l_aes_dev *dd)
=20
 	for (i =3D 0; i < ARRAY_SIZE(aes_algs); i++)
 		crypto_unregister_alg(&aes_algs[i]);
-	if (dd->hw_version >=3D 0x130)
-		crypto_unregister_alg(&aes_cfb64_alg[0]);
+	if (dd->caps.has_cfb64)
+		crypto_unregister_alg(&aes_cfb64_alg);
 }
=20
 static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
@@ -1017,10 +1222,8 @@ static int atmel_aes_register_algs(struct atmel_=
aes_dev *dd)
 			goto err_aes_algs;
 	}
=20
-	atmel_aes_hw_version_init(dd);
-
-	if (dd->hw_version >=3D 0x130) {
-		err =3D crypto_register_alg(&aes_cfb64_alg[0]);
+	if (dd->caps.has_cfb64) {
+		err =3D crypto_register_alg(&aes_cfb64_alg);
 		if (err)
 			goto err_aes_cfb64_alg;
 	}
@@ -1036,10 +1239,32 @@ err_aes_algs:
 	return err;
 }
=20
+static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
+{
+	dd->caps.has_dualbuff =3D 0;
+	dd->caps.has_cfb64 =3D 0;
+	dd->caps.max_burst_size =3D 1;
+
+	/* keep only major version number */
+	switch (dd->hw_version & 0xff0) {
+	case 0x130:
+		dd->caps.has_dualbuff =3D 1;
+		dd->caps.has_cfb64 =3D 1;
+		dd->caps.max_burst_size =3D 4;
+		break;
+	case 0x120:
+		break;
+	default:
+		dev_warn(dd->dev,
+				"Unmanaged aes version, set minimum capabilities\n");
+		break;
+	}
+}
+
 static int atmel_aes_probe(struct platform_device *pdev)
 {
 	struct atmel_aes_dev *aes_dd;
-	struct aes_platform_data	*pdata;
+	struct crypto_platform_data *pdata;
 	struct device *dev =3D &pdev->dev;
 	struct resource *aes_res;
 	unsigned long aes_phys_size;
@@ -1099,7 +1324,7 @@ static int atmel_aes_probe(struct platform_device=
 *pdev)
 	}
=20
 	/* Initializing the clock */
-	aes_dd->iclk =3D clk_get(&pdev->dev, NULL);
+	aes_dd->iclk =3D clk_get(&pdev->dev, "aes_clk");
 	if (IS_ERR(aes_dd->iclk)) {
 		dev_err(dev, "clock intialization failed.\n");
 		err =3D PTR_ERR(aes_dd->iclk);
@@ -1113,7 +1338,15 @@ static int atmel_aes_probe(struct platform_devic=
e *pdev)
 		goto aes_io_err;
 	}
=20
-	err =3D atmel_aes_dma_init(aes_dd);
+	atmel_aes_hw_version_init(aes_dd);
+
+	atmel_aes_get_cap(aes_dd);
+
+	err =3D atmel_aes_buff_init(aes_dd);
+	if (err)
+		goto err_aes_buff;
+
+	err =3D atmel_aes_dma_init(aes_dd, pdata);
 	if (err)
 		goto err_aes_dma;
=20
@@ -1135,6 +1368,8 @@ err_algs:
 	spin_unlock(&atmel_aes.lock);
 	atmel_aes_dma_cleanup(aes_dd);
 err_aes_dma:
+	atmel_aes_buff_cleanup(aes_dd);
+err_aes_buff:
 	iounmap(aes_dd->io_base);
 aes_io_err:
 	clk_put(aes_dd->iclk);
--=20
1.8.1
