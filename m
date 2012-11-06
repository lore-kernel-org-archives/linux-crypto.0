From: Nicolas Royer <nicolas@eukrea.com>
Subject: [PATCH 5/5] crypto: Atmel SHA driver: add support for latest release of the IP (0x410)
Date: Tue,  6 Nov 2012 17:33:43 +0100
Message-ID: <1352219623-30530-1-git-send-email-nicolas@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, plagnioj@jcrosoft.com, eric@eukrea.com,
	Nicolas Royer <nicolas@eukrea.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:58912 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2KFQdv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2012 11:33:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Updates from IP release 0x320 to 0x400:
 - add DMA support (previous IP revision use PDC)
 - add DMA double input buffer support
 - add SHA224 support

Update from IP release 0x400 to 0x410:
 - add SHA384 and SHA512 support

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric B=C3=A9nard <eric@eukrea.com>
Tested-by: Eric B=C3=A9nard <eric@eukrea.com>
---
 drivers/crypto/Kconfig          |    8 +-
 drivers/crypto/atmel-sha-regs.h |    7 +-
 drivers/crypto/atmel-sha.c      |  586 +++++++++++++++++++++++++++++++=
+-------
 3 files changed, 497 insertions(+), 104 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 308c7fb..0f4076b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -360,15 +360,17 @@ config CRYPTO_DEV_ATMEL_TDES
 	  will be called atmel-tdes.
=20
 config CRYPTO_DEV_ATMEL_SHA
-	tristate "Support for Atmel SHA1/SHA256 hw accelerator"
+	tristate "Support for Atmel SHA hw accelerator"
 	depends on ARCH_AT91
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	select CRYPTO_ALGAPI
 	help
-	  Some Atmel processors have SHA1/SHA256 hw accelerator.
+	  Some Atmel processors have SHA1/SHA224/SHA256/SHA384/SHA512
+	  hw accelerator.
 	  Select this if you want to use the Atmel module for
-	  SHA1/SHA256 algorithms.
+	  SHA1/SHA224/SHA256/SHA384/SHA512 algorithms.
=20
 	  To compile this driver as a module, choose M here: the module
 	  will be called atmel-sha.
diff --git a/drivers/crypto/atmel-sha-regs.h b/drivers/crypto/atmel-sha=
-regs.h
index dc53a20..83b2d74 100644
--- a/drivers/crypto/atmel-sha-regs.h
+++ b/drivers/crypto/atmel-sha-regs.h
@@ -14,10 +14,13 @@
 #define SHA_MR_MODE_MANUAL		0x0
 #define SHA_MR_MODE_AUTO		0x1
 #define SHA_MR_MODE_PDC			0x2
-#define	SHA_MR_DUALBUFF			(1 << 3)
 #define SHA_MR_PROCDLY			(1 << 4)
 #define SHA_MR_ALGO_SHA1		(0 << 8)
 #define SHA_MR_ALGO_SHA256		(1 << 8)
+#define SHA_MR_ALGO_SHA384		(2 << 8)
+#define SHA_MR_ALGO_SHA512		(3 << 8)
+#define SHA_MR_ALGO_SHA224		(4 << 8)
+#define	SHA_MR_DUALBUFF			(1 << 16)
=20
 #define SHA_IER				0x10
 #define SHA_IDR				0x14
@@ -33,6 +36,8 @@
 #define SHA_ISR_URAT_MR			(0x2 << 12)
 #define SHA_ISR_URAT_WO			(0x5 << 12)
=20
+#define	SHA_HW_VERSION		0xFC
+
 #define SHA_TPR				0x108
 #define SHA_TCR				0x10C
 #define SHA_TNPR			0x118
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index bcdf55f..408ea25 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -38,6 +38,7 @@
 #include <crypto/sha.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
+#include <linux/platform_data/crypto-atmel.h>
 #include "atmel-sha-regs.h"
=20
 /* SHA flags */
@@ -52,11 +53,12 @@
 #define SHA_FLAGS_FINUP		BIT(16)
 #define SHA_FLAGS_SG		BIT(17)
 #define SHA_FLAGS_SHA1		BIT(18)
-#define SHA_FLAGS_SHA256	BIT(19)
-#define SHA_FLAGS_ERROR		BIT(20)
-#define SHA_FLAGS_PAD		BIT(21)
-
-#define SHA_FLAGS_DUALBUFF	BIT(24)
+#define SHA_FLAGS_SHA224	BIT(19)
+#define SHA_FLAGS_SHA256	BIT(20)
+#define SHA_FLAGS_SHA384	BIT(21)
+#define SHA_FLAGS_SHA512	BIT(22)
+#define SHA_FLAGS_ERROR		BIT(23)
+#define SHA_FLAGS_PAD		BIT(24)
=20
 #define SHA_OP_UPDATE	1
 #define SHA_OP_FINAL	2
@@ -65,6 +67,12 @@
=20
 #define ATMEL_SHA_DMA_THRESHOLD		56
=20
+struct atmel_sha_caps {
+	bool	has_dma;
+	bool	has_dualbuff;
+	bool	has_sha224;
+	bool	has_sha_384_512;
+};
=20
 struct atmel_sha_dev;
=20
@@ -73,8 +81,8 @@ struct atmel_sha_reqctx {
 	unsigned long	flags;
 	unsigned long	op;
=20
-	u8	digest[SHA256_DIGEST_SIZE] __aligned(sizeof(u32));
-	size_t	digcnt;
+	u8	digest[SHA512_DIGEST_SIZE] __aligned(sizeof(u32));
+	u64	digcnt[2];
 	size_t	bufcnt;
 	size_t	buflen;
 	dma_addr_t	dma_addr;
@@ -84,6 +92,8 @@ struct atmel_sha_reqctx {
 	unsigned int	offset;	/* offset in current sg */
 	unsigned int	total;	/* total request */
=20
+	size_t block_size;
+
 	u8	buffer[0] __aligned(sizeof(u32));
 };
=20
@@ -97,7 +107,12 @@ struct atmel_sha_ctx {
=20
 };
=20
-#define ATMEL_SHA_QUEUE_LENGTH	1
+#define ATMEL_SHA_QUEUE_LENGTH	50
+
+struct atmel_sha_dma {
+	struct dma_chan			*chan;
+	struct dma_slave_config dma_conf;
+};
=20
 struct atmel_sha_dev {
 	struct list_head	list;
@@ -114,6 +129,12 @@ struct atmel_sha_dev {
 	unsigned long		flags;
 	struct crypto_queue	queue;
 	struct ahash_request	*req;
+
+	struct atmel_sha_dma	dma_lch_in;
+
+	struct atmel_sha_caps	caps;
+
+	u32	hw_version;
 };
=20
 struct atmel_sha_drv {
@@ -137,14 +158,6 @@ static inline void atmel_sha_write(struct atmel_sh=
a_dev *dd,
 	writel_relaxed(value, dd->io_base + offset);
 }
=20
-static void atmel_sha_dualbuff_test(struct atmel_sha_dev *dd)
-{
-	atmel_sha_write(dd, SHA_MR, SHA_MR_DUALBUFF);
-
-	if (atmel_sha_read(dd, SHA_MR) & SHA_MR_DUALBUFF)
-		dd->flags |=3D SHA_FLAGS_DUALBUFF;
-}
-
 static size_t atmel_sha_append_sg(struct atmel_sha_reqctx *ctx)
 {
 	size_t count;
@@ -176,31 +189,58 @@ static size_t atmel_sha_append_sg(struct atmel_sh=
a_reqctx *ctx)
 }
=20
 /*
- * The purpose of this padding is to ensure that the padded message
- * is a multiple of 512 bits. The bit "1" is appended at the end of
- * the message followed by "padlen-1" zero bits. Then a 64 bits block
- * equals to the message length in bits is appended.
+ * The purpose of this padding is to ensure that the padded message is=
 a
+ * multiple of 512 bits (SHA1/SHA224/SHA256) or 1024 bits (SHA384/SHA5=
12).
+ * The bit "1" is appended at the end of the message followed by
+ * "padlen-1" zero bits. Then a 64 bits block (SHA1/SHA224/SHA256) or
+ * 128 bits block (SHA384/SHA512) equals to the message length in bits
+ * is appended.
  *
- * padlen is calculated as followed:
+ * For SHA1/SHA224/SHA256, padlen is calculated as followed:
  *  - if message length < 56 bytes then padlen =3D 56 - message length
  *  - else padlen =3D 64 + 56 - message length
+ *
+ * For SHA384/SHA512, padlen is calculated as followed:
+ *  - if message length < 112 bytes then padlen =3D 112 - message leng=
th
+ *  - else padlen =3D 128 + 112 - message length
  */
 static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int l=
ength)
 {
 	unsigned int index, padlen;
-	u64 bits;
-	u64 size;
-
-	bits =3D (ctx->bufcnt + ctx->digcnt + length) << 3;
-	size =3D cpu_to_be64(bits);
-
-	index =3D ctx->bufcnt & 0x3f;
-	padlen =3D (index < 56) ? (56 - index) : ((64+56) - index);
-	*(ctx->buffer + ctx->bufcnt) =3D 0x80;
-	memset(ctx->buffer + ctx->bufcnt + 1, 0, padlen-1);
-	memcpy(ctx->buffer + ctx->bufcnt + padlen, &size, 8);
-	ctx->bufcnt +=3D padlen + 8;
-	ctx->flags |=3D SHA_FLAGS_PAD;
+	u64 bits[2];
+	u64 size[2];
+
+	size[0] =3D ctx->digcnt[0];
+	size[1] =3D ctx->digcnt[1];
+
+	size[0] +=3D ctx->bufcnt;
+	if (size[0] < ctx->bufcnt)
+		size[1]++;
+
+	size[0] +=3D length;
+	if (size[0]  < length)
+		size[1]++;
+
+	bits[1] =3D cpu_to_be64(size[0] << 3);
+	bits[0] =3D cpu_to_be64(size[1] << 3 | size[0] >> 61);
+
+	if (ctx->flags & (SHA_FLAGS_SHA384 | SHA_FLAGS_SHA512)) {
+		index =3D ctx->bufcnt & 0x7f;
+		padlen =3D (index < 112) ? (112 - index) : ((128+112) - index);
+		*(ctx->buffer + ctx->bufcnt) =3D 0x80;
+		memset(ctx->buffer + ctx->bufcnt + 1, 0, padlen-1);
+		memcpy(ctx->buffer + ctx->bufcnt + padlen, bits, 16);
+		ctx->bufcnt +=3D padlen + 16;
+		ctx->flags |=3D SHA_FLAGS_PAD;
+	} else {
+		index =3D ctx->bufcnt & 0x3f;
+		padlen =3D (index < 56) ? (56 - index) : ((64+56) - index);
+		*(ctx->buffer + ctx->bufcnt) =3D 0x80;
+		memset(ctx->buffer + ctx->bufcnt + 1, 0, padlen-1);
+		memcpy(ctx->buffer + ctx->bufcnt + padlen, &bits[1], 8);
+		ctx->bufcnt +=3D padlen + 8;
+		ctx->flags |=3D SHA_FLAGS_PAD;
+	}
 }
=20
 static int atmel_sha_init(struct ahash_request *req)
@@ -231,13 +271,35 @@ static int atmel_sha_init(struct ahash_request *r=
eq)
 	dev_dbg(dd->dev, "init: digest size: %d\n",
 		crypto_ahash_digestsize(tfm));
=20
-	if (crypto_ahash_digestsize(tfm) =3D=3D SHA1_DIGEST_SIZE)
+	switch (crypto_ahash_digestsize(tfm)) {
+	case SHA1_DIGEST_SIZE:
 		ctx->flags |=3D SHA_FLAGS_SHA1;
-	else if (crypto_ahash_digestsize(tfm) =3D=3D SHA256_DIGEST_SIZE)
+		ctx->block_size =3D SHA1_BLOCK_SIZE;
+		break;
+	case SHA224_DIGEST_SIZE:
+		ctx->flags |=3D SHA_FLAGS_SHA224;
+		ctx->block_size =3D SHA224_BLOCK_SIZE;
+		break;
+	case SHA256_DIGEST_SIZE:
 		ctx->flags |=3D SHA_FLAGS_SHA256;
+		ctx->block_size =3D SHA256_BLOCK_SIZE;
+		break;
+	case SHA384_DIGEST_SIZE:
+		ctx->flags |=3D SHA_FLAGS_SHA384;
+		ctx->block_size =3D SHA384_BLOCK_SIZE;
+		break;
+	case SHA512_DIGEST_SIZE:
+		ctx->flags |=3D SHA_FLAGS_SHA512;
+		ctx->block_size =3D SHA512_BLOCK_SIZE;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
=20
 	ctx->bufcnt =3D 0;
-	ctx->digcnt =3D 0;
+	ctx->digcnt[0] =3D 0;
+	ctx->digcnt[1] =3D 0;
 	ctx->buflen =3D SHA_BUFFER_LEN;
=20
 	return 0;
@@ -249,19 +311,28 @@ static void atmel_sha_write_ctrl(struct atmel_sha=
_dev *dd, int dma)
 	u32 valcr =3D 0, valmr =3D SHA_MR_MODE_AUTO;
=20
 	if (likely(dma)) {
-		atmel_sha_write(dd, SHA_IER, SHA_INT_TXBUFE);
+		if (!dd->caps.has_dma)
+			atmel_sha_write(dd, SHA_IER, SHA_INT_TXBUFE);
 		valmr =3D SHA_MR_MODE_PDC;
-		if (dd->flags & SHA_FLAGS_DUALBUFF)
-			valmr =3D SHA_MR_DUALBUFF;
+		if (dd->caps.has_dualbuff)
+			valmr |=3D SHA_MR_DUALBUFF;
 	} else {
 		atmel_sha_write(dd, SHA_IER, SHA_INT_DATARDY);
 	}
=20
-	if (ctx->flags & SHA_FLAGS_SHA256)
+	if (ctx->flags & SHA_FLAGS_SHA1)
+		valmr |=3D SHA_MR_ALGO_SHA1;
+	else if (ctx->flags & SHA_FLAGS_SHA224)
+		valmr |=3D SHA_MR_ALGO_SHA224;
+	else if (ctx->flags & SHA_FLAGS_SHA256)
 		valmr |=3D SHA_MR_ALGO_SHA256;
+	else if (ctx->flags & SHA_FLAGS_SHA384)
+		valmr |=3D SHA_MR_ALGO_SHA384;
+	else if (ctx->flags & SHA_FLAGS_SHA512)
+		valmr |=3D SHA_MR_ALGO_SHA512;
=20
 	/* Setting CR_FIRST only for the first iteration */
-	if (!ctx->digcnt)
+	if (!(ctx->digcnt[0] || ctx->digcnt[1]))
 		valcr =3D SHA_CR_FIRST;
=20
 	atmel_sha_write(dd, SHA_CR, valcr);
@@ -275,13 +346,15 @@ static int atmel_sha_xmit_cpu(struct atmel_sha_de=
v *dd, const u8 *buf,
 	int count, len32;
 	const u32 *buffer =3D (const u32 *)buf;
=20
-	dev_dbg(dd->dev, "xmit_cpu: digcnt: %d, length: %d, final: %d\n",
-						ctx->digcnt, length, final);
+	dev_dbg(dd->dev, "xmit_cpu: digcnt: 0x%llx 0x%llx, length: %d, final:=
 %d\n",
+		ctx->digcnt[1], ctx->digcnt[0], length, final);
=20
 	atmel_sha_write_ctrl(dd, 0);
=20
 	/* should be non-zero before next lines to disable clocks later */
-	ctx->digcnt +=3D length;
+	ctx->digcnt[0] +=3D length;
+	if (ctx->digcnt[0] < length)
+		ctx->digcnt[1]++;
=20
 	if (final)
 		dd->flags |=3D SHA_FLAGS_FINAL; /* catch last interrupt */
@@ -302,8 +375,8 @@ static int atmel_sha_xmit_pdc(struct atmel_sha_dev =
*dd, dma_addr_t dma_addr1,
 	struct atmel_sha_reqctx *ctx =3D ahash_request_ctx(dd->req);
 	int len32;
=20
-	dev_dbg(dd->dev, "xmit_pdc: digcnt: %d, length: %d, final: %d\n",
-						ctx->digcnt, length1, final);
+	dev_dbg(dd->dev, "xmit_pdc: digcnt: 0x%llx 0x%llx, length: %d, final:=
 %d\n",
+		ctx->digcnt[1], ctx->digcnt[0], length1, final);
=20
 	len32 =3D DIV_ROUND_UP(length1, sizeof(u32));
 	atmel_sha_write(dd, SHA_PTCR, SHA_PTCR_TXTDIS);
@@ -317,7 +390,9 @@ static int atmel_sha_xmit_pdc(struct atmel_sha_dev =
*dd, dma_addr_t dma_addr1,
 	atmel_sha_write_ctrl(dd, 1);
=20
 	/* should be non-zero before next lines to disable clocks later */
-	ctx->digcnt +=3D length1;
+	ctx->digcnt[0] +=3D length1;
+	if (ctx->digcnt[0] < length1)
+		ctx->digcnt[1]++;
=20
 	if (final)
 		dd->flags |=3D SHA_FLAGS_FINAL; /* catch last interrupt */
@@ -330,6 +405,86 @@ static int atmel_sha_xmit_pdc(struct atmel_sha_dev=
 *dd, dma_addr_t dma_addr1,
 	return -EINPROGRESS;
 }
=20
+static void atmel_sha_dma_callback(void *data)
+{
+	struct atmel_sha_dev *dd =3D data;
+
+	/* dma_lch_in - completed - wait DATRDY */
+	atmel_sha_write(dd, SHA_IER, SHA_INT_DATARDY);
+}
+
+static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma=
_addr1,
+		size_t length1, dma_addr_t dma_addr2, size_t length2, int final)
+{
+	struct atmel_sha_reqctx *ctx =3D ahash_request_ctx(dd->req);
+	struct dma_async_tx_descriptor	*in_desc;
+	struct scatterlist sg[2];
+
+	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %d, final:=
 %d\n",
+		ctx->digcnt[1], ctx->digcnt[0], length1, final);
+
+	if (ctx->flags & (SHA_FLAGS_SHA1 | SHA_FLAGS_SHA224 |
+			SHA_FLAGS_SHA256)) {
+		dd->dma_lch_in.dma_conf.src_maxburst =3D 16;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D 16;
+	} else {
+		dd->dma_lch_in.dma_conf.src_maxburst =3D 32;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D 32;
+	}
+
+	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf)=
;
+
+	if (length2) {
+		sg_init_table(sg, 2);
+		sg_dma_address(&sg[0]) =3D dma_addr1;
+		sg_dma_len(&sg[0]) =3D length1;
+		sg_dma_address(&sg[1]) =3D dma_addr2;
+		sg_dma_len(&sg[1]) =3D length2;
+		in_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_in.chan, sg, 2,
+			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	} else {
+		sg_init_table(sg, 1);
+		sg_dma_address(&sg[0]) =3D dma_addr1;
+		sg_dma_len(&sg[0]) =3D length1;
+		in_desc =3D dmaengine_prep_slave_sg(dd->dma_lch_in.chan, sg, 1,
+			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	}
+	if (!in_desc)
+		return -EINVAL;
+
+	in_desc->callback =3D atmel_sha_dma_callback;
+	in_desc->callback_param =3D dd;
+
+	atmel_sha_write_ctrl(dd, 1);
+
+	/* should be non-zero before next lines to disable clocks later */
+	ctx->digcnt[0] +=3D length1;
+	if (ctx->digcnt[0] < length1)
+		ctx->digcnt[1]++;
+
+	if (final)
+		dd->flags |=3D SHA_FLAGS_FINAL; /* catch last interrupt */
+
+	dd->flags |=3D  SHA_FLAGS_DMA_ACTIVE;
+
+	/* Start DMA transfer */
+	dmaengine_submit(in_desc);
+	dma_async_issue_pending(dd->dma_lch_in.chan);
+
+	return -EINPROGRESS;
+}
+
+static int atmel_sha_xmit_start(struct atmel_sha_dev *dd, dma_addr_t d=
ma_addr1,
+		size_t length1, dma_addr_t dma_addr2, size_t length2, int final)
+{
+	if (dd->caps.has_dma)
+		return atmel_sha_xmit_dma(dd, dma_addr1, length1,
+				dma_addr2, length2, final);
+	else
+		return atmel_sha_xmit_pdc(dd, dma_addr1, length1,
+				dma_addr2, length2, final);
+}
+
 static int atmel_sha_update_cpu(struct atmel_sha_dev *dd)
 {
 	struct atmel_sha_reqctx *ctx =3D ahash_request_ctx(dd->req);
@@ -337,7 +492,6 @@ static int atmel_sha_update_cpu(struct atmel_sha_de=
v *dd)
=20
 	atmel_sha_append_sg(ctx);
 	atmel_sha_fill_padding(ctx, 0);
-
 	bufcnt =3D ctx->bufcnt;
 	ctx->bufcnt =3D 0;
=20
@@ -349,17 +503,17 @@ static int atmel_sha_xmit_dma_map(struct atmel_sh=
a_dev *dd,
 					size_t length, int final)
 {
 	ctx->dma_addr =3D dma_map_single(dd->dev, ctx->buffer,
-				ctx->buflen + SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+				ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
 	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
 		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen +
-				SHA1_BLOCK_SIZE);
+				ctx->block_size);
 		return -EINVAL;
 	}
=20
 	ctx->flags &=3D ~SHA_FLAGS_SG;
=20
 	/* next call does not fail... so no unmap in the case of error */
-	return atmel_sha_xmit_pdc(dd, ctx->dma_addr, length, 0, 0, final);
+	return atmel_sha_xmit_start(dd, ctx->dma_addr, length, 0, 0, final);
 }
=20
 static int atmel_sha_update_dma_slow(struct atmel_sha_dev *dd)
@@ -372,8 +526,8 @@ static int atmel_sha_update_dma_slow(struct atmel_s=
ha_dev *dd)
=20
 	final =3D (ctx->flags & SHA_FLAGS_FINUP) && !ctx->total;
=20
-	dev_dbg(dd->dev, "slow: bufcnt: %u, digcnt: %d, final: %d\n",
-					 ctx->bufcnt, ctx->digcnt, final);
+	dev_dbg(dd->dev, "slow: bufcnt: %u, digcnt: 0x%llx 0x%llx, final: %d\=
n",
+		 ctx->bufcnt, ctx->digcnt[1], ctx->digcnt[0], final);
=20
 	if (final)
 		atmel_sha_fill_padding(ctx, 0);
@@ -400,30 +554,25 @@ static int atmel_sha_update_dma_start(struct atme=
l_sha_dev *dd)
 	if (ctx->bufcnt || ctx->offset)
 		return atmel_sha_update_dma_slow(dd);
=20
-	dev_dbg(dd->dev, "fast: digcnt: %d, bufcnt: %u, total: %u\n",
-			ctx->digcnt, ctx->bufcnt, ctx->total);
+	dev_dbg(dd->dev, "fast: digcnt: 0x%llx 0x%llx, bufcnt: %u, total: %u\=
n",
+		ctx->digcnt[1], ctx->digcnt[0], ctx->bufcnt, ctx->total);
=20
 	sg =3D ctx->sg;
=20
 	if (!IS_ALIGNED(sg->offset, sizeof(u32)))
 		return atmel_sha_update_dma_slow(dd);
=20
-	if (!sg_is_last(sg) && !IS_ALIGNED(sg->length, SHA1_BLOCK_SIZE))
-		/* size is not SHA1_BLOCK_SIZE aligned */
+	if (!sg_is_last(sg) && !IS_ALIGNED(sg->length, ctx->block_size))
+		/* size is not ctx->block_size aligned */
 		return atmel_sha_update_dma_slow(dd);
=20
 	length =3D min(ctx->total, sg->length);
=20
 	if (sg_is_last(sg)) {
 		if (!(ctx->flags & SHA_FLAGS_FINUP)) {
-			/* not last sg must be SHA1_BLOCK_SIZE aligned */
-			tail =3D length & (SHA1_BLOCK_SIZE - 1);
+			/* not last sg must be ctx->block_size aligned */
+			tail =3D length & (ctx->block_size - 1);
 			length -=3D tail;
-			if (length =3D=3D 0) {
-				/* offset where to start slow */
-				ctx->offset =3D length;
-				return atmel_sha_update_dma_slow(dd);
-			}
 		}
 	}
=20
@@ -434,7 +583,7 @@ static int atmel_sha_update_dma_start(struct atmel_=
sha_dev *dd)
=20
 	/* Add padding */
 	if (final) {
-		tail =3D length & (SHA1_BLOCK_SIZE - 1);
+		tail =3D length & (ctx->block_size - 1);
 		length -=3D tail;
 		ctx->total +=3D tail;
 		ctx->offset =3D length; /* offset where to start slow */
@@ -445,10 +594,10 @@ static int atmel_sha_update_dma_start(struct atme=
l_sha_dev *dd)
 		atmel_sha_fill_padding(ctx, length);
=20
 		ctx->dma_addr =3D dma_map_single(dd->dev, ctx->buffer,
-			ctx->buflen + SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+			ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
 		if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
 			dev_err(dd->dev, "dma %u bytes error\n",
-				ctx->buflen + SHA1_BLOCK_SIZE);
+				ctx->buflen + ctx->block_size);
 			return -EINVAL;
 		}
=20
@@ -456,7 +605,7 @@ static int atmel_sha_update_dma_start(struct atmel_=
sha_dev *dd)
 			ctx->flags &=3D ~SHA_FLAGS_SG;
 			count =3D ctx->bufcnt;
 			ctx->bufcnt =3D 0;
-			return atmel_sha_xmit_pdc(dd, ctx->dma_addr, count, 0,
+			return atmel_sha_xmit_start(dd, ctx->dma_addr, count, 0,
 					0, final);
 		} else {
 			ctx->sg =3D sg;
@@ -470,7 +619,7 @@ static int atmel_sha_update_dma_start(struct atmel_=
sha_dev *dd)
=20
 			count =3D ctx->bufcnt;
 			ctx->bufcnt =3D 0;
-			return atmel_sha_xmit_pdc(dd, sg_dma_address(ctx->sg),
+			return atmel_sha_xmit_start(dd, sg_dma_address(ctx->sg),
 					length, ctx->dma_addr, count, final);
 		}
 	}
@@ -483,7 +632,7 @@ static int atmel_sha_update_dma_start(struct atmel_=
sha_dev *dd)
 	ctx->flags |=3D SHA_FLAGS_SG;
=20
 	/* next call does not fail... so no unmap in the case of error */
-	return atmel_sha_xmit_pdc(dd, sg_dma_address(ctx->sg), length, 0,
+	return atmel_sha_xmit_start(dd, sg_dma_address(ctx->sg), length, 0,
 								0, final);
 }
=20
@@ -498,12 +647,13 @@ static int atmel_sha_update_dma_stop(struct atmel=
_sha_dev *dd)
 			if (ctx->sg)
 				ctx->offset =3D 0;
 		}
-		if (ctx->flags & SHA_FLAGS_PAD)
+		if (ctx->flags & SHA_FLAGS_PAD) {
 			dma_unmap_single(dd->dev, ctx->dma_addr,
-				ctx->buflen + SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+				ctx->buflen + ctx->block_size, DMA_TO_DEVICE);
+		}
 	} else {
 		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen +
-						SHA1_BLOCK_SIZE, DMA_TO_DEVICE);
+						ctx->block_size, DMA_TO_DEVICE);
 	}
=20
 	return 0;
@@ -515,8 +665,8 @@ static int atmel_sha_update_req(struct atmel_sha_de=
v *dd)
 	struct atmel_sha_reqctx *ctx =3D ahash_request_ctx(req);
 	int err;
=20
-	dev_dbg(dd->dev, "update_req: total: %u, digcnt: %d, finup: %d\n",
-		 ctx->total, ctx->digcnt, (ctx->flags & SHA_FLAGS_FINUP) !=3D 0);
+	dev_dbg(dd->dev, "update_req: total: %u, digcnt: 0x%llx 0x%llx\n",
+		ctx->total, ctx->digcnt[1], ctx->digcnt[0]);
=20
 	if (ctx->flags & SHA_FLAGS_CPU)
 		err =3D atmel_sha_update_cpu(dd);
@@ -524,8 +674,8 @@ static int atmel_sha_update_req(struct atmel_sha_de=
v *dd)
 		err =3D atmel_sha_update_dma_start(dd);
=20
 	/* wait for dma completion before can take more data */
-	dev_dbg(dd->dev, "update: err: %d, digcnt: %d\n",
-			err, ctx->digcnt);
+	dev_dbg(dd->dev, "update: err: %d, digcnt: 0x%llx 0%llx\n",
+			err, ctx->digcnt[1], ctx->digcnt[0]);
=20
 	return err;
 }
@@ -562,12 +712,21 @@ static void atmel_sha_copy_hash(struct ahash_requ=
est *req)
 	u32 *hash =3D (u32 *)ctx->digest;
 	int i;
=20
-	if (likely(ctx->flags & SHA_FLAGS_SHA1))
+	if (ctx->flags & SHA_FLAGS_SHA1)
 		for (i =3D 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++)
 			hash[i] =3D atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
-	else
+	else if (ctx->flags & SHA_FLAGS_SHA224)
+		for (i =3D 0; i < SHA224_DIGEST_SIZE / sizeof(u32); i++)
+			hash[i] =3D atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
+	else if (ctx->flags & SHA_FLAGS_SHA256)
 		for (i =3D 0; i < SHA256_DIGEST_SIZE / sizeof(u32); i++)
 			hash[i] =3D atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
+	else if (ctx->flags & SHA_FLAGS_SHA384)
+		for (i =3D 0; i < SHA384_DIGEST_SIZE / sizeof(u32); i++)
+			hash[i] =3D atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
+	else
+		for (i =3D 0; i < SHA512_DIGEST_SIZE / sizeof(u32); i++)
+			hash[i] =3D atmel_sha_read(ctx->dd, SHA_REG_DIGEST(i));
 }
=20
 static void atmel_sha_copy_ready_hash(struct ahash_request *req)
@@ -577,10 +736,16 @@ static void atmel_sha_copy_ready_hash(struct ahas=
h_request *req)
 	if (!req->result)
 		return;
=20
-	if (likely(ctx->flags & SHA_FLAGS_SHA1))
+	if (ctx->flags & SHA_FLAGS_SHA1)
 		memcpy(req->result, ctx->digest, SHA1_DIGEST_SIZE);
-	else
+	else if (ctx->flags & SHA_FLAGS_SHA224)
+		memcpy(req->result, ctx->digest, SHA224_DIGEST_SIZE);
+	else if (ctx->flags & SHA_FLAGS_SHA256)
 		memcpy(req->result, ctx->digest, SHA256_DIGEST_SIZE);
+	else if (ctx->flags & SHA_FLAGS_SHA384)
+		memcpy(req->result, ctx->digest, SHA384_DIGEST_SIZE);
+	else
+		memcpy(req->result, ctx->digest, SHA512_DIGEST_SIZE);
 }
=20
 static int atmel_sha_finish(struct ahash_request *req)
@@ -589,11 +754,11 @@ static int atmel_sha_finish(struct ahash_request =
*req)
 	struct atmel_sha_dev *dd =3D ctx->dd;
 	int err =3D 0;
=20
-	if (ctx->digcnt)
+	if (ctx->digcnt[0] || ctx->digcnt[1])
 		atmel_sha_copy_ready_hash(req);
=20
-	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt,
-		ctx->bufcnt);
+	dev_dbg(dd->dev, "digcnt: 0x%llx 0x%llx, bufcnt: %d\n", ctx->digcnt[1=
],
+		ctx->digcnt[0], ctx->bufcnt);
=20
 	return err;
 }
@@ -628,9 +793,8 @@ static int atmel_sha_hw_init(struct atmel_sha_dev *=
dd)
 {
 	clk_prepare_enable(dd->iclk);
=20
-	if (SHA_FLAGS_INIT & dd->flags) {
+	if (!(SHA_FLAGS_INIT & dd->flags)) {
 		atmel_sha_write(dd, SHA_CR, SHA_CR_SWRST);
-		atmel_sha_dualbuff_test(dd);
 		dd->flags |=3D SHA_FLAGS_INIT;
 		dd->err =3D 0;
 	}
@@ -638,6 +802,23 @@ static int atmel_sha_hw_init(struct atmel_sha_dev =
*dd)
 	return 0;
 }
=20
+static inline unsigned int atmel_sha_get_version(struct atmel_sha_dev =
*dd)
+{
+	return atmel_sha_read(dd, SHA_HW_VERSION) & 0x00000fff;
+}
+
+static void atmel_sha_hw_version_init(struct atmel_sha_dev *dd)
+{
+	atmel_sha_hw_init(dd);
+
+	dd->hw_version =3D atmel_sha_get_version(dd);
+
+	dev_info(dd->dev,
+			"version: 0x%x\n", dd->hw_version);
+
+	clk_disable_unprepare(dd->iclk);
+}
+
 static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 				  struct ahash_request *req)
 {
@@ -682,10 +863,9 @@ static int atmel_sha_handle_queue(struct atmel_sha=
_dev *dd,
=20
 	if (ctx->op =3D=3D SHA_OP_UPDATE) {
 		err =3D atmel_sha_update_req(dd);
-		if (err !=3D -EINPROGRESS && (ctx->flags & SHA_FLAGS_FINUP)) {
+		if (err !=3D -EINPROGRESS && (ctx->flags & SHA_FLAGS_FINUP))
 			/* no final() after finup() */
 			err =3D atmel_sha_final_req(dd);
-		}
 	} else if (ctx->op =3D=3D SHA_OP_FINAL) {
 		err =3D atmel_sha_final_req(dd);
 	}
@@ -808,7 +988,7 @@ static int atmel_sha_cra_init_alg(struct crypto_tfm=
 *tfm, const char *alg_base)
 	}
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct atmel_sha_reqctx) +
-				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
+				 SHA_BUFFER_LEN + SHA512_BLOCK_SIZE);
=20
 	return 0;
 }
@@ -826,7 +1006,7 @@ static void atmel_sha_cra_exit(struct crypto_tfm *=
tfm)
 	tctx->fallback =3D NULL;
 }
=20
-static struct ahash_alg sha_algs[] =3D {
+static struct ahash_alg sha_1_256_algs[] =3D {
 {
 	.init		=3D atmel_sha_init,
 	.update		=3D atmel_sha_update,
@@ -875,6 +1055,79 @@ static struct ahash_alg sha_algs[] =3D {
 },
 };
=20
+static struct ahash_alg sha_224_alg =3D {
+	.init		=3D atmel_sha_init,
+	.update		=3D atmel_sha_update,
+	.final		=3D atmel_sha_final,
+	.finup		=3D atmel_sha_finup,
+	.digest		=3D atmel_sha_digest,
+	.halg =3D {
+		.digestsize	=3D SHA224_DIGEST_SIZE,
+		.base	=3D {
+			.cra_name		=3D "sha224",
+			.cra_driver_name	=3D "atmel-sha224",
+			.cra_priority		=3D 100,
+			.cra_flags		=3D CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		=3D SHA224_BLOCK_SIZE,
+			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
+			.cra_alignmask		=3D 0,
+			.cra_module		=3D THIS_MODULE,
+			.cra_init		=3D atmel_sha_cra_init,
+			.cra_exit		=3D atmel_sha_cra_exit,
+		}
+	}
+};
+
+static struct ahash_alg sha_384_512_algs[] =3D {
+{
+	.init		=3D atmel_sha_init,
+	.update		=3D atmel_sha_update,
+	.final		=3D atmel_sha_final,
+	.finup		=3D atmel_sha_finup,
+	.digest		=3D atmel_sha_digest,
+	.halg =3D {
+		.digestsize	=3D SHA384_DIGEST_SIZE,
+		.base	=3D {
+			.cra_name		=3D "sha384",
+			.cra_driver_name	=3D "atmel-sha384",
+			.cra_priority		=3D 100,
+			.cra_flags		=3D CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		=3D SHA384_BLOCK_SIZE,
+			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
+			.cra_alignmask		=3D 0x3,
+			.cra_module		=3D THIS_MODULE,
+			.cra_init		=3D atmel_sha_cra_init,
+			.cra_exit		=3D atmel_sha_cra_exit,
+		}
+	}
+},
+{
+	.init		=3D atmel_sha_init,
+	.update		=3D atmel_sha_update,
+	.final		=3D atmel_sha_final,
+	.finup		=3D atmel_sha_finup,
+	.digest		=3D atmel_sha_digest,
+	.halg =3D {
+		.digestsize	=3D SHA512_DIGEST_SIZE,
+		.base	=3D {
+			.cra_name		=3D "sha512",
+			.cra_driver_name	=3D "atmel-sha512",
+			.cra_priority		=3D 100,
+			.cra_flags		=3D CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		=3D SHA512_BLOCK_SIZE,
+			.cra_ctxsize		=3D sizeof(struct atmel_sha_ctx),
+			.cra_alignmask		=3D 0x3,
+			.cra_module		=3D THIS_MODULE,
+			.cra_init		=3D atmel_sha_cra_init,
+			.cra_exit		=3D atmel_sha_cra_exit,
+		}
+	}
+},
+};
+
 static void atmel_sha_done_task(unsigned long data)
 {
 	struct atmel_sha_dev *dd =3D (struct atmel_sha_dev *)data;
@@ -941,32 +1194,142 @@ static void atmel_sha_unregister_algs(struct at=
mel_sha_dev *dd)
 {
 	int i;
=20
-	for (i =3D 0; i < ARRAY_SIZE(sha_algs); i++)
-		crypto_unregister_ahash(&sha_algs[i]);
+	for (i =3D 0; i < ARRAY_SIZE(sha_1_256_algs); i++)
+		crypto_unregister_ahash(&sha_1_256_algs[i]);
+
+	if (dd->caps.has_sha224)
+		crypto_unregister_ahash(&sha_224_alg);
+
+	if (dd->caps.has_sha_384_512) {
+		for (i =3D 0; i < ARRAY_SIZE(sha_384_512_algs); i++)
+			crypto_unregister_ahash(&sha_384_512_algs[i]);
+	}
 }
=20
 static int atmel_sha_register_algs(struct atmel_sha_dev *dd)
 {
 	int err, i, j;
=20
-	for (i =3D 0; i < ARRAY_SIZE(sha_algs); i++) {
-		err =3D crypto_register_ahash(&sha_algs[i]);
+	for (i =3D 0; i < ARRAY_SIZE(sha_1_256_algs); i++) {
+		err =3D crypto_register_ahash(&sha_1_256_algs[i]);
 		if (err)
-			goto err_sha_algs;
+			goto err_sha_1_256_algs;
+	}
+
+	if (dd->caps.has_sha224) {
+		err =3D crypto_register_ahash(&sha_224_alg);
+		if (err)
+			goto err_sha_224_algs;
+	}
+
+	if (dd->caps.has_sha_384_512) {
+		for (i =3D 0; i < ARRAY_SIZE(sha_384_512_algs); i++) {
+			err =3D crypto_register_ahash(&sha_384_512_algs[i]);
+			if (err)
+				goto err_sha_384_512_algs;
+		}
 	}
=20
 	return 0;
=20
-err_sha_algs:
+err_sha_384_512_algs:
+	for (j =3D 0; j < i; j++)
+		crypto_unregister_ahash(&sha_384_512_algs[j]);
+	crypto_unregister_ahash(&sha_224_alg);
+err_sha_224_algs:
+	i =3D ARRAY_SIZE(sha_1_256_algs);
+err_sha_1_256_algs:
 	for (j =3D 0; j < i; j++)
-		crypto_unregister_ahash(&sha_algs[j]);
+		crypto_unregister_ahash(&sha_1_256_algs[j]);
=20
 	return err;
 }
=20
+static bool atmel_sha_filter(struct dma_chan *chan, void *slave)
+{
+	struct at_dma_slave	*sl =3D slave;
+
+	if (sl && sl->dma_dev =3D=3D chan->device->dev) {
+		chan->private =3D sl;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static int atmel_sha_dma_init(struct atmel_sha_dev *dd,
+				struct crypto_platform_data *pdata)
+{
+	int err =3D -ENOMEM;
+	dma_cap_mask_t mask_in;
+
+	if (pdata && pdata->dma_slave->rxdata.dma_dev) {
+		/* Try to grab DMA channel */
+		dma_cap_zero(mask_in);
+		dma_cap_set(DMA_SLAVE, mask_in);
+
+		dd->dma_lch_in.chan =3D dma_request_channel(mask_in,
+				atmel_sha_filter, &pdata->dma_slave->rxdata);
+
+		if (!dd->dma_lch_in.chan)
+			return err;
+
+		dd->dma_lch_in.dma_conf.direction =3D DMA_MEM_TO_DEV;
+		dd->dma_lch_in.dma_conf.dst_addr =3D dd->phys_base +
+			SHA_REG_DIN(0);
+		dd->dma_lch_in.dma_conf.src_maxburst =3D 1;
+		dd->dma_lch_in.dma_conf.src_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dd->dma_lch_in.dma_conf.dst_maxburst =3D 1;
+		dd->dma_lch_in.dma_conf.dst_addr_width =3D
+			DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dd->dma_lch_in.dma_conf.device_fc =3D false;
+
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+static void atmel_sha_dma_cleanup(struct atmel_sha_dev *dd)
+{
+	dma_release_channel(dd->dma_lch_in.chan);
+}
+
+static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
+{
+
+	dd->caps.has_dma =3D 0;
+	dd->caps.has_dualbuff =3D 0;
+	dd->caps.has_sha224 =3D 0;
+	dd->caps.has_sha_384_512 =3D 0;
+
+	/* keep only major version number */
+	switch (dd->hw_version & 0xff0) {
+	case 0x410:
+		dd->caps.has_dma =3D 1;
+		dd->caps.has_dualbuff =3D 1;
+		dd->caps.has_sha224 =3D 1;
+		dd->caps.has_sha_384_512 =3D 1;
+		break;
+	case 0x400:
+		dd->caps.has_dma =3D 1;
+		dd->caps.has_dualbuff =3D 1;
+		dd->caps.has_sha224 =3D 1;
+		break;
+	case 0x320:
+		break;
+	default:
+		dev_warn(dd->dev,
+				"Unmanaged sha version, set minimum capabilities\n");
+		break;
+	}
+}
+
 static int __devinit atmel_sha_probe(struct platform_device *pdev)
 {
 	struct atmel_sha_dev *sha_dd;
+	struct crypto_platform_data	*pdata;
 	struct device *dev =3D &pdev->dev;
 	struct resource *sha_res;
 	unsigned long sha_phys_size;
@@ -1018,7 +1381,7 @@ static int __devinit atmel_sha_probe(struct platf=
orm_device *pdev)
 	}
=20
 	/* Initializing the clock */
-	sha_dd->iclk =3D clk_get(&pdev->dev, NULL);
+	sha_dd->iclk =3D clk_get(&pdev->dev, "sha_clk");
 	if (IS_ERR(sha_dd->iclk)) {
 		dev_err(dev, "clock intialization failed.\n");
 		err =3D PTR_ERR(sha_dd->iclk);
@@ -1032,6 +1395,22 @@ static int __devinit atmel_sha_probe(struct plat=
form_device *pdev)
 		goto sha_io_err;
 	}
=20
+	atmel_sha_hw_version_init(sha_dd);
+
+	atmel_sha_get_cap(sha_dd);
+
+	if (sha_dd->caps.has_dma) {
+		pdata =3D pdev->dev.platform_data;
+		if (!pdata) {
+			dev_err(&pdev->dev, "platform data not available\n");
+			err =3D -ENXIO;
+			goto err_pdata;
+		}
+		err =3D atmel_sha_dma_init(sha_dd, pdata);
+		if (err)
+			goto err_sha_dma;
+	}
+
 	spin_lock(&atmel_sha.lock);
 	list_add_tail(&sha_dd->list, &atmel_sha.dev_list);
 	spin_unlock(&atmel_sha.lock);
@@ -1048,6 +1427,10 @@ err_algs:
 	spin_lock(&atmel_sha.lock);
 	list_del(&sha_dd->list);
 	spin_unlock(&atmel_sha.lock);
+	if (sha_dd->caps.has_dma)
+		atmel_sha_dma_cleanup(sha_dd);
+err_sha_dma:
+err_pdata:
 	iounmap(sha_dd->io_base);
 sha_io_err:
 	clk_put(sha_dd->iclk);
@@ -1078,6 +1461,9 @@ static int __devexit atmel_sha_remove(struct plat=
form_device *pdev)
=20
 	tasklet_kill(&sha_dd->done_task);
=20
+	if (sha_dd->caps.has_dma)
+		atmel_sha_dma_cleanup(sha_dd);
+
 	iounmap(sha_dd->io_base);
=20
 	clk_put(sha_dd->iclk);
@@ -1102,6 +1488,6 @@ static struct platform_driver atmel_sha_driver =3D=
 {
=20
 module_platform_driver(atmel_sha_driver);
=20
-MODULE_DESCRIPTION("Atmel SHA1/SHA256 hw acceleration support.");
+MODULE_DESCRIPTION("Atmel SHA (1/256/224/384/512) hw acceleration supp=
ort.");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Nicolas Royer - Eukr=C3=A9a Electromatique");
--=20
1.7.6.5
