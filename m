From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 23/24] crypto: atmel-aes: add support to GCM mode
Date: Thu, 17 Dec 2015 18:13:07 +0100
Message-ID: <18d8b9b74c961a7bf5822d044185eecd1d8883e5.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds support to the GCM mode.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/Kconfig          |   1 +
 drivers/crypto/atmel-aes-regs.h |  10 +
 drivers/crypto/atmel-aes.c      | 453 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 462 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 95dccdea4dd1..da9ab9649a14 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -380,6 +380,7 @@ config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on AT_XDMAC || AT_HDMAC || COMPILE_TEST
 	select CRYPTO_AES
+	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
 	help
 	  Some Atmel processors have AES hw accelerator.
diff --git a/drivers/crypto/atmel-aes-regs.h b/drivers/crypto/atmel-aes-regs.h
index 2786bb1a5aa0..6c2951bb70b1 100644
--- a/drivers/crypto/atmel-aes-regs.h
+++ b/drivers/crypto/atmel-aes-regs.h
@@ -9,6 +9,7 @@
 #define	AES_MR			0x04
 #define AES_MR_CYPHER_DEC		(0 << 0)
 #define AES_MR_CYPHER_ENC		(1 << 0)
+#define AES_MR_GTAGEN			(1 << 1)
 #define	AES_MR_DUALBUFF			(1 << 3)
 #define AES_MR_PROCDLY_MASK		(0xF << 4)
 #define AES_MR_PROCDLY_OFFSET	4
@@ -26,6 +27,7 @@
 #define AES_MR_OPMOD_OFB		(0x2 << 12)
 #define AES_MR_OPMOD_CFB		(0x3 << 12)
 #define AES_MR_OPMOD_CTR		(0x4 << 12)
+#define AES_MR_OPMOD_GCM		(0x5 << 12)
 #define AES_MR_LOD				(0x1 << 15)
 #define AES_MR_CFBS_MASK		(0x7 << 16)
 #define AES_MR_CFBS_128b		(0x0 << 16)
@@ -44,6 +46,7 @@
 #define	AES_ISR		0x1C
 #define AES_INT_DATARDY		(1 << 0)
 #define AES_INT_URAD		(1 << 8)
+#define AES_INT_TAGRDY		(1 << 16)
 #define AES_ISR_URAT_MASK	(0xF << 12)
 #define AES_ISR_URAT_IDR_WR_PROC	(0x0 << 12)
 #define AES_ISR_URAT_ODR_RD_PROC	(0x1 << 12)
@@ -57,6 +60,13 @@
 #define AES_ODATAR(x)	(0x50 + ((x) * 0x04))
 #define AES_IVR(x)		(0x60 + ((x) * 0x04))
 
+#define AES_AADLENR	0x70
+#define AES_CLENR	0x74
+#define AES_GHASHR(x)	(0x78 + ((x) * 0x04))
+#define AES_TAGR(x)	(0x88 + ((x) * 0x04))
+#define AES_CTRR	0x98
+#define AES_GCMHR(x)	(0x9c + ((x) * 0x04))
+
 #define AES_HW_VERSION	0xFC
 
 #endif /* __ATMEL_AES_REGS_H__ */
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index ea645b4ee997..0a37e5683c80 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -36,6 +36,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/internal/aead.h>
 #include <linux/platform_data/crypto-atmel.h>
 #include <dt-bindings/dma/at91.h>
 #include "atmel-aes-regs.h"
@@ -53,8 +54,9 @@
 #define SIZE_IN_WORDS(x)	((x) >> 2)
 
 /* AES flags */
-/* Reserve bits [18:16] [14:12] [0] for mode (same as for AES_MR) */
+/* Reserve bits [18:16] [14:12] [1:0] for mode (same as for AES_MR) */
 #define AES_FLAGS_ENCRYPT	AES_MR_CYPHER_ENC
+#define AES_FLAGS_GTAGEN	AES_MR_GTAGEN
 #define AES_FLAGS_OPMODE_MASK	(AES_MR_OPMOD_MASK | AES_MR_CFBS_MASK)
 #define AES_FLAGS_ECB		AES_MR_OPMOD_ECB
 #define AES_FLAGS_CBC		AES_MR_OPMOD_CBC
@@ -65,9 +67,11 @@
 #define AES_FLAGS_CFB16		(AES_MR_OPMOD_CFB | AES_MR_CFBS_16b)
 #define AES_FLAGS_CFB8		(AES_MR_OPMOD_CFB | AES_MR_CFBS_8b)
 #define AES_FLAGS_CTR		AES_MR_OPMOD_CTR
+#define AES_FLAGS_GCM		AES_MR_OPMOD_GCM
 
 #define AES_FLAGS_MODE_MASK	(AES_FLAGS_OPMODE_MASK |	\
-				 AES_FLAGS_ENCRYPT)
+				 AES_FLAGS_ENCRYPT |		\
+				 AES_FLAGS_GTAGEN)
 
 #define AES_FLAGS_INIT		BIT(2)
 #define AES_FLAGS_BUSY		BIT(3)
@@ -83,6 +87,7 @@ struct atmel_aes_caps {
 	bool			has_dualbuff;
 	bool			has_cfb64;
 	bool			has_ctr32;
+	bool			has_gcm;
 	u32			max_burst_size;
 };
 
@@ -113,6 +118,22 @@ struct atmel_aes_ctr_ctx {
 	struct scatterlist	dst[2];
 };
 
+struct atmel_aes_gcm_ctx {
+	struct atmel_aes_base_ctx	base;
+
+	struct scatterlist	src[2];
+	struct scatterlist	dst[2];
+
+	u32			j0[AES_BLOCK_SIZE / sizeof(u32)];
+	u32			tag[AES_BLOCK_SIZE / sizeof(u32)];
+	u32			ghash[AES_BLOCK_SIZE / sizeof(u32)];
+	size_t			textlen;
+
+	const u32		*ghash_in;
+	u32			*ghash_out;
+	atmel_aes_fn_t		ghash_resume;
+};
+
 struct atmel_aes_reqctx {
 	unsigned long		mode;
 };
@@ -234,6 +255,12 @@ static inline size_t atmel_aes_padlen(size_t len, size_t block_size)
 	return len ? block_size - len : 0;
 }
 
+static inline struct aead_request *
+aead_request_cast(struct crypto_async_request *req)
+{
+	return container_of(req, struct aead_request, base);
+}
+
 static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_base_ctx *ctx)
 {
 	struct atmel_aes_dev *aes_dd = NULL;
@@ -300,6 +327,11 @@ static inline void atmel_aes_set_mode(struct atmel_aes_dev *dd,
 	dd->flags = (dd->flags & AES_FLAGS_PERSISTENT) | rctx->mode;
 }
 
+static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
+{
+	return (dd->flags & AES_FLAGS_ENCRYPT);
+}
+
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
 	clk_disable_unprepare(dd->iclk);
@@ -1226,6 +1258,409 @@ static struct crypto_alg aes_cfb64_alg = {
 };
 
 
+/* gcm aead functions */
+
+static int atmel_aes_gcm_ghash(struct atmel_aes_dev *dd,
+			       const u32 *data, size_t datalen,
+			       const u32 *ghash_in, u32 *ghash_out,
+			       atmel_aes_fn_t resume);
+static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_ghash_finalize(struct atmel_aes_dev *dd);
+
+static int atmel_aes_gcm_start(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_process(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_length(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_data(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_tag_init(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_tag(struct atmel_aes_dev *dd);
+static int atmel_aes_gcm_finalize(struct atmel_aes_dev *dd);
+
+static inline struct atmel_aes_gcm_ctx *
+atmel_aes_gcm_ctx_cast(struct atmel_aes_base_ctx *ctx)
+{
+	return container_of(ctx, struct atmel_aes_gcm_ctx, base);
+}
+
+static int atmel_aes_gcm_ghash(struct atmel_aes_dev *dd,
+			       const u32 *data, size_t datalen,
+			       const u32 *ghash_in, u32 *ghash_out,
+			       atmel_aes_fn_t resume)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+
+	dd->data = (u32 *)data;
+	dd->datalen = datalen;
+	ctx->ghash_in = ghash_in;
+	ctx->ghash_out = ghash_out;
+	ctx->ghash_resume = resume;
+
+	atmel_aes_write_ctrl(dd, false, NULL);
+	return atmel_aes_wait_for_data_ready(dd, atmel_aes_gcm_ghash_init);
+}
+
+static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+
+	/* Set the data length. */
+	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_CLENR, 0);
+
+	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
+	if (ctx->ghash_in)
+		atmel_aes_write_block(dd, AES_GHASHR(0), ctx->ghash_in);
+
+	return atmel_aes_gcm_ghash_finalize(dd);
+}
+
+static int atmel_aes_gcm_ghash_finalize(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	u32 isr;
+
+	/* Write data into the Input Data Registers. */
+	while (dd->datalen > 0) {
+		atmel_aes_write_block(dd, AES_IDATAR(0), dd->data);
+		dd->data += 4;
+		dd->datalen -= AES_BLOCK_SIZE;
+
+		isr = atmel_aes_read(dd, AES_ISR);
+		if (!(isr & AES_INT_DATARDY)) {
+			dd->resume = atmel_aes_gcm_ghash_finalize;
+			atmel_aes_write(dd, AES_IER, AES_INT_DATARDY);
+			return -EINPROGRESS;
+		}
+	}
+
+	/* Read the computed hash from GHASHRx. */
+	atmel_aes_read_block(dd, AES_GHASHR(0), ctx->ghash_out);
+
+	return ctx->ghash_resume(dd);
+}
+
+
+static int atmel_aes_gcm_start(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct atmel_aes_reqctx *rctx = aead_request_ctx(req);
+	size_t ivsize = crypto_aead_ivsize(tfm);
+	size_t datalen, padlen;
+	const void *iv = req->iv;
+	u8 *data = dd->buf;
+	int err;
+
+	atmel_aes_set_mode(dd, rctx);
+
+	err = atmel_aes_hw_init(dd);
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	if (likely(ivsize == 12)) {
+		memcpy(ctx->j0, iv, ivsize);
+		ctx->j0[3] = cpu_to_be32(1);
+		return atmel_aes_gcm_process(dd);
+	}
+
+	padlen = atmel_aes_padlen(ivsize, AES_BLOCK_SIZE);
+	datalen = ivsize + padlen + AES_BLOCK_SIZE;
+	if (datalen > dd->buflen)
+		return atmel_aes_complete(dd, -EINVAL);
+
+	memcpy(data, iv, ivsize);
+	memset(data + ivsize, 0, padlen + sizeof(u64));
+	((u64 *)(data + datalen))[-1] = cpu_to_be64(ivsize * 8);
+
+	return atmel_aes_gcm_ghash(dd, (const u32 *)data, datalen,
+				   NULL, ctx->j0, atmel_aes_gcm_process);
+}
+
+static int atmel_aes_gcm_process(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	bool enc = atmel_aes_is_encrypt(dd);
+	u32 authsize;
+
+	/* Compute text length. */
+	authsize = crypto_aead_authsize(tfm);
+	ctx->textlen = req->cryptlen - (enc ? 0 : authsize);
+
+	/*
+	 * According to tcrypt test suite, the GCM Automatic Tag Generation
+	 * fails when both the message and its associated data are empty.
+	 */
+	if (likely(req->assoclen != 0 || ctx->textlen != 0))
+		dd->flags |= AES_FLAGS_GTAGEN;
+
+	atmel_aes_write_ctrl(dd, false, NULL);
+	return atmel_aes_wait_for_data_ready(dd, atmel_aes_gcm_length);
+}
+
+static int atmel_aes_gcm_length(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	struct aead_request *req = aead_request_cast(dd->areq);
+	u32 j0_lsw, *j0 = ctx->j0;
+	size_t padlen;
+
+	/* Write incr32(J0) into IV. */
+	j0_lsw = j0[3];
+	j0[3] = cpu_to_be32(be32_to_cpu(j0[3]) + 1);
+	atmel_aes_write_block(dd, AES_IVR(0), j0);
+	j0[3] = j0_lsw;
+
+	/* Set aad and text lengths. */
+	atmel_aes_write(dd, AES_AADLENR, req->assoclen);
+	atmel_aes_write(dd, AES_CLENR, ctx->textlen);
+
+	/* Check whether AAD are present. */
+	if (unlikely(req->assoclen == 0)) {
+		dd->datalen = 0;
+		return atmel_aes_gcm_data(dd);
+	}
+
+	/* Copy assoc data and add padding. */
+	padlen = atmel_aes_padlen(req->assoclen, AES_BLOCK_SIZE);
+	if (unlikely(req->assoclen + padlen > dd->buflen))
+		return atmel_aes_complete(dd, -EINVAL);
+	sg_copy_to_buffer(req->src, sg_nents(req->src), dd->buf, req->assoclen);
+
+	/* Write assoc data into the Input Data register. */
+	dd->data = (u32 *)dd->buf;
+	dd->datalen = req->assoclen + padlen;
+	return atmel_aes_gcm_data(dd);
+}
+
+static int atmel_aes_gcm_data(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	struct aead_request *req = aead_request_cast(dd->areq);
+	bool use_dma = (ctx->textlen >= ATMEL_AES_DMA_THRESHOLD);
+	struct scatterlist *src, *dst;
+	u32 isr, mr;
+
+	/* Write AAD first. */
+	while (dd->datalen > 0) {
+		atmel_aes_write_block(dd, AES_IDATAR(0), dd->data);
+		dd->data += 4;
+		dd->datalen -= AES_BLOCK_SIZE;
+
+		isr = atmel_aes_read(dd, AES_ISR);
+		if (!(isr & AES_INT_DATARDY)) {
+			dd->resume = atmel_aes_gcm_data;
+			atmel_aes_write(dd, AES_IER, AES_INT_DATARDY);
+			return -EINPROGRESS;
+		}
+	}
+
+	/* GMAC only. */
+	if (unlikely(ctx->textlen == 0))
+		return atmel_aes_gcm_tag_init(dd);
+
+	/* Prepare src and dst scatter lists to transfer cipher/plain texts */
+	src = scatterwalk_ffwd(ctx->src, req->src, req->assoclen);
+	dst = ((req->src == req->dst) ? src :
+	       scatterwalk_ffwd(ctx->dst, req->dst, req->assoclen));
+
+	if (use_dma) {
+		/* Update the Mode Register for DMA transfers. */
+		mr = atmel_aes_read(dd, AES_MR);
+		mr &= ~(AES_MR_SMOD_MASK | AES_MR_DUALBUFF);
+		mr |= AES_MR_SMOD_IDATAR0;
+		if (dd->caps.has_dualbuff)
+			mr |= AES_MR_DUALBUFF;
+		atmel_aes_write(dd, AES_MR, mr);
+
+		return atmel_aes_dma_start(dd, src, dst, ctx->textlen,
+					   atmel_aes_gcm_tag_init);
+	}
+
+	return atmel_aes_cpu_start(dd, src, dst, ctx->textlen,
+				   atmel_aes_gcm_tag_init);
+}
+
+static int atmel_aes_gcm_tag_init(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	struct aead_request *req = aead_request_cast(dd->areq);
+	u64 *data = dd->buf;
+
+	if (likely(dd->flags & AES_FLAGS_GTAGEN)) {
+		if (!(atmel_aes_read(dd, AES_ISR) & AES_INT_TAGRDY)) {
+			dd->resume = atmel_aes_gcm_tag_init;
+			atmel_aes_write(dd, AES_IER, AES_INT_TAGRDY);
+			return -EINPROGRESS;
+		}
+
+		return atmel_aes_gcm_finalize(dd);
+	}
+
+	/* Read the GCM Intermediate Hash Word Registers. */
+	atmel_aes_read_block(dd, AES_GHASHR(0), ctx->ghash);
+
+	data[0] = cpu_to_be64(req->assoclen * 8);
+	data[1] = cpu_to_be64(ctx->textlen * 8);
+
+	return atmel_aes_gcm_ghash(dd, (const u32 *)data, AES_BLOCK_SIZE,
+				   ctx->ghash, ctx->ghash, atmel_aes_gcm_tag);
+}
+
+static int atmel_aes_gcm_tag(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	unsigned long flags;
+
+	/*
+	 * Change mode to CTR to complete the tag generation.
+	 * Use J0 as Initialization Vector.
+	 */
+	flags = dd->flags;
+	dd->flags &= ~(AES_FLAGS_OPMODE_MASK | AES_FLAGS_GTAGEN);
+	dd->flags |= AES_FLAGS_CTR;
+	atmel_aes_write_ctrl(dd, false, ctx->j0);
+	dd->flags = flags;
+
+	atmel_aes_write_block(dd, AES_IDATAR(0), ctx->ghash);
+	return atmel_aes_wait_for_data_ready(dd, atmel_aes_gcm_finalize);
+}
+
+static int atmel_aes_gcm_finalize(struct atmel_aes_dev *dd)
+{
+	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	bool enc = atmel_aes_is_encrypt(dd);
+	u32 offset, authsize, itag[4], *otag = ctx->tag;
+	int err;
+
+	/* Read the computed tag. */
+	if (likely(dd->flags & AES_FLAGS_GTAGEN))
+		atmel_aes_read_block(dd, AES_TAGR(0), ctx->tag);
+	else
+		atmel_aes_read_block(dd, AES_ODATAR(0), ctx->tag);
+
+	offset = req->assoclen + ctx->textlen;
+	authsize = crypto_aead_authsize(tfm);
+	if (enc) {
+		scatterwalk_map_and_copy(otag, req->dst, offset, authsize, 1);
+		err = 0;
+	} else {
+		scatterwalk_map_and_copy(itag, req->src, offset, authsize, 0);
+		err = crypto_memneq(itag, otag, authsize) ? -EBADMSG : 0;
+	}
+
+	return atmel_aes_complete(dd, err);
+}
+
+static int atmel_aes_gcm_crypt(struct aead_request *req,
+			       unsigned long mode)
+{
+	struct atmel_aes_base_ctx *ctx;
+	struct atmel_aes_reqctx *rctx;
+	struct atmel_aes_dev *dd;
+
+	ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	ctx->block_size = AES_BLOCK_SIZE;
+
+	dd = atmel_aes_find_dev(ctx);
+	if (!dd)
+		return -ENODEV;
+
+	rctx = aead_request_ctx(req);
+	rctx->mode = AES_FLAGS_GCM | mode;
+
+	return atmel_aes_handle_queue(dd, &req->base);
+}
+
+static int atmel_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				unsigned int keylen)
+{
+	struct atmel_aes_base_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (keylen != AES_KEYSIZE_256 &&
+	    keylen != AES_KEYSIZE_192 &&
+	    keylen != AES_KEYSIZE_128) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	return 0;
+}
+
+static int atmel_aes_gcm_setauthsize(struct crypto_aead *tfm,
+				     unsigned int authsize)
+{
+	/* Same as crypto_gcm_authsize() from crypto/gcm.c */
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int atmel_aes_gcm_encrypt(struct aead_request *req)
+{
+	return atmel_aes_gcm_crypt(req, AES_FLAGS_ENCRYPT);
+}
+
+static int atmel_aes_gcm_decrypt(struct aead_request *req)
+{
+	return atmel_aes_gcm_crypt(req, 0);
+}
+
+static int atmel_aes_gcm_init(struct crypto_aead *tfm)
+{
+	struct atmel_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_aead_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
+	ctx->base.start = atmel_aes_gcm_start;
+
+	return 0;
+}
+
+static void atmel_aes_gcm_exit(struct crypto_aead *tfm)
+{
+
+}
+
+static struct aead_alg aes_gcm_alg = {
+	.setkey		= atmel_aes_gcm_setkey,
+	.setauthsize	= atmel_aes_gcm_setauthsize,
+	.encrypt	= atmel_aes_gcm_encrypt,
+	.decrypt	= atmel_aes_gcm_decrypt,
+	.init		= atmel_aes_gcm_init,
+	.exit		= atmel_aes_gcm_exit,
+	.ivsize		= 12,
+	.maxauthsize	= AES_BLOCK_SIZE,
+
+	.base = {
+		.cra_name		= "gcm(aes)",
+		.cra_driver_name	= "atmel-gcm-aes",
+		.cra_priority		= ATMEL_AES_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct atmel_aes_gcm_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+
 /* Probe functions */
 
 static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
@@ -1334,6 +1769,9 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
+	if (dd->caps.has_gcm)
+		crypto_unregister_aead(&aes_gcm_alg);
+
 	if (dd->caps.has_cfb64)
 		crypto_unregister_alg(&aes_cfb64_alg);
 
@@ -1357,8 +1795,16 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_cfb64_alg;
 	}
 
+	if (dd->caps.has_gcm) {
+		err = crypto_register_aead(&aes_gcm_alg);
+		if (err)
+			goto err_aes_gcm_alg;
+	}
+
 	return 0;
 
+err_aes_gcm_alg:
+	crypto_unregister_alg(&aes_cfb64_alg);
 err_aes_cfb64_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
@@ -1373,6 +1819,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 	dd->caps.has_dualbuff = 0;
 	dd->caps.has_cfb64 = 0;
 	dd->caps.has_ctr32 = 0;
+	dd->caps.has_gcm = 0;
 	dd->caps.max_burst_size = 1;
 
 	/* keep only major version number */
@@ -1381,12 +1828,14 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
 		dd->caps.has_ctr32 = 1;
+		dd->caps.has_gcm = 1;
 		dd->caps.max_burst_size = 4;
 		break;
 	case 0x200:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
 		dd->caps.has_ctr32 = 1;
+		dd->caps.has_gcm = 1;
 		dd->caps.max_burst_size = 4;
 		break;
 	case 0x130:
-- 
1.8.2.2
