From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 11/12] crypto: atmel-authenc: add support to
 authenc(hmac(shaX), Y(aes)) modes
Date: Thu, 26 Jan 2017 17:07:56 +0100
Message-ID: <f357d8d49f81b273132ab1ba69f2581f4eec5b90.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patchs allows to combine the AES and SHA hardware accelerators on
some Atmel SoCs. Doing so, AES blocks are only written to/read from the
AES hardware. Those blocks are also transferred from the AES to the SHA
accelerator internally, without additionnal accesses to the system busses.

Hence, the AES and SHA accelerators work in parallel to process all the
data blocks, instead of serializing the process by (de)crypting those
blocks first then authenticating them after like the generic
crypto/authenc.c driver does.

Of course, both the AES and SHA hardware accelerators need to be available
before we can start to process the data blocks. Hence we use their crypto
request queue to synchronize both drivers.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/Kconfig          |  12 ++
 drivers/crypto/atmel-aes-regs.h |  16 ++
 drivers/crypto/atmel-aes.c      | 448 +++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/atmel-authenc.h  |  64 ++++++
 drivers/crypto/atmel-sha-regs.h |  14 ++
 drivers/crypto/atmel-sha.c      | 344 ++++++++++++++++++++++++++++--
 6 files changed, 883 insertions(+), 15 deletions(-)
 create mode 100644 drivers/crypto/atmel-authenc.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index bf7da55cffe6..74824612d3e9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -415,6 +415,18 @@ config CRYPTO_DEV_BFIN_CRC
 	  Newer Blackfin processors have CRC hardware. Select this if you
 	  want to use the Blackfin CRC module.
 
+config CRYPTO_DEV_ATMEL_AUTHENC
+	tristate "Support for Atmel IPSEC/SSL hw accelerator"
+	depends on (ARCH_AT91 && HAS_DMA) || COMPILE_TEST
+	select CRYPTO_AUTHENC
+	select CRYPTO_DEV_ATMEL_AES
+	select CRYPTO_DEV_ATMEL_SHA
+	help
+	  Some Atmel processors can combine the AES and SHA hw accelerators
+	  to enhance support of IPSEC/SSL.
+	  Select this if you want to use the Atmel modules for
+	  authenc(hmac(shaX),Y(cbc)) algorithms.
+
 config CRYPTO_DEV_ATMEL_AES
 	tristate "Support for Atmel AES hw accelerator"
 	depends on HAS_DMA
diff --git a/drivers/crypto/atmel-aes-regs.h b/drivers/crypto/atmel-aes-regs.h
index 0ec04407b533..7694679802b3 100644
--- a/drivers/crypto/atmel-aes-regs.h
+++ b/drivers/crypto/atmel-aes-regs.h
@@ -68,6 +68,22 @@
 #define AES_CTRR	0x98
 #define AES_GCMHR(x)	(0x9c + ((x) * 0x04))
 
+#define AES_EMR		0xb0
+#define AES_EMR_APEN		BIT(0)	/* Auto Padding Enable */
+#define AES_EMR_APM		BIT(1)	/* Auto Padding Mode */
+#define AES_EMR_APM_IPSEC	0x0
+#define AES_EMR_APM_SSL		BIT(1)
+#define AES_EMR_PLIPEN		BIT(4)	/* PLIP Enable */
+#define AES_EMR_PLIPD		BIT(5)	/* PLIP Decipher */
+#define AES_EMR_PADLEN_MASK	(0xFu << 8)
+#define AES_EMR_PADLEN_OFFSET	8
+#define AES_EMR_PADLEN(padlen)	(((padlen) << AES_EMR_PADLEN_OFFSET) &\
+				 AES_EMR_PADLEN_MASK)
+#define AES_EMR_NHEAD_MASK	(0xFu << 16)
+#define AES_EMR_NHEAD_OFFSET	16
+#define AES_EMR_NHEAD(nhead)	(((nhead) << AES_EMR_NHEAD_OFFSET) &\
+				 AES_EMR_NHEAD_MASK)
+
 #define AES_TWR(x)	(0xc0 + ((x) * 0x04))
 #define AES_ALPHAR(x)	(0xd0 + ((x) * 0x04))
 
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9fd2f63b8bc0..29e20c37f3a6 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -41,6 +41,7 @@
 #include <linux/platform_data/crypto-atmel.h>
 #include <dt-bindings/dma/at91.h>
 #include "atmel-aes-regs.h"
+#include "atmel-authenc.h"
 
 #define ATMEL_AES_PRIORITY	300
 
@@ -78,6 +79,7 @@
 #define AES_FLAGS_INIT		BIT(2)
 #define AES_FLAGS_BUSY		BIT(3)
 #define AES_FLAGS_DUMP_REG	BIT(4)
+#define AES_FLAGS_OWN_SHA	BIT(5)
 
 #define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
 
@@ -92,6 +94,7 @@ struct atmel_aes_caps {
 	bool			has_ctr32;
 	bool			has_gcm;
 	bool			has_xts;
+	bool			has_authenc;
 	u32			max_burst_size;
 };
 
@@ -144,10 +147,31 @@ struct atmel_aes_xts_ctx {
 	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
 };
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+struct atmel_aes_authenc_ctx {
+	struct atmel_aes_base_ctx	base;
+	struct atmel_sha_authenc_ctx	*auth;
+};
+#endif
+
 struct atmel_aes_reqctx {
 	unsigned long		mode;
 };
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+struct atmel_aes_authenc_reqctx {
+	struct atmel_aes_reqctx	base;
+
+	struct scatterlist	src[2];
+	struct scatterlist	dst[2];
+	size_t			textlen;
+	u32			digest[SHA512_DIGEST_SIZE / sizeof(u32)];
+
+	/* auth_req MUST be place last. */
+	struct ahash_request	auth_req;
+};
+#endif
+
 struct atmel_aes_dma {
 	struct dma_chan		*chan;
 	struct scatterlist	*sg;
@@ -291,6 +315,9 @@ static const char *atmel_aes_reg_name(u32 offset, char *tmp, size_t sz)
 		snprintf(tmp, sz, "GCMHR[%u]", (offset - AES_GCMHR(0)) >> 2);
 		break;
 
+	case AES_EMR:
+		return "EMR";
+
 	case AES_TWR(0):
 	case AES_TWR(1):
 	case AES_TWR(2):
@@ -463,8 +490,16 @@ static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
 	return (dd->flags & AES_FLAGS_ENCRYPT);
 }
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
+#endif
+
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+	atmel_aes_authenc_complete(dd, err);
+#endif
+
 	clk_disable(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
@@ -1931,6 +1966,384 @@ static struct crypto_alg aes_xts_alg = {
 	}
 };
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+/* authenc aead functions */
+
+static int atmel_aes_authenc_start(struct atmel_aes_dev *dd);
+static int atmel_aes_authenc_init(struct atmel_aes_dev *dd, int err,
+				  bool is_async);
+static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
+				      bool is_async);
+static int atmel_aes_authenc_digest(struct atmel_aes_dev *dd);
+static int atmel_aes_authenc_final(struct atmel_aes_dev *dd, int err,
+				   bool is_async);
+
+static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err)
+{
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+
+	if (err && (dd->flags & AES_FLAGS_OWN_SHA))
+		atmel_sha_authenc_abort(&rctx->auth_req);
+	dd->flags &= ~AES_FLAGS_OWN_SHA;
+}
+
+static int atmel_aes_authenc_start(struct atmel_aes_dev *dd)
+{
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
+	int err;
+
+	atmel_aes_set_mode(dd, &rctx->base);
+
+	err = atmel_aes_hw_init(dd);
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	return atmel_sha_authenc_schedule(&rctx->auth_req, ctx->auth,
+					  atmel_aes_authenc_init, dd);
+}
+
+static int atmel_aes_authenc_init(struct atmel_aes_dev *dd, int err,
+				  bool is_async)
+{
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+
+	if (is_async)
+		dd->is_async = true;
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	/* If here, we've got the ownership of the SHA device. */
+	dd->flags |= AES_FLAGS_OWN_SHA;
+
+	/* Configure the SHA device. */
+	return atmel_sha_authenc_init(&rctx->auth_req,
+				      req->src, req->assoclen,
+				      rctx->textlen,
+				      atmel_aes_authenc_transfer, dd);
+}
+
+static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
+				      bool is_async)
+{
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+	bool enc = atmel_aes_is_encrypt(dd);
+	struct scatterlist *src, *dst;
+	u32 iv[AES_BLOCK_SIZE / sizeof(u32)];
+	u32 emr;
+
+	if (is_async)
+		dd->is_async = true;
+	if (err)
+		return atmel_aes_complete(dd, err);
+
+	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
+	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
+	dst = src;
+
+	if (req->src != req->dst)
+		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
+
+	/* Configure the AES device. */
+	memcpy(iv, req->iv, sizeof(iv));
+
+	/*
+	 * Here we always set the 2nd parameter of atmel_aes_write_ctrl() to
+	 * 'true' even if the data transfer is actually performed by the CPU (so
+	 * not by the DMA) because we must force the AES_MR_SMOD bitfield to the
+	 * value AES_MR_SMOD_IDATAR0. Indeed, both AES_MR_SMOD and SHA_MR_SMOD
+	 * must be set to *_MR_SMOD_IDATAR0.
+	 */
+	atmel_aes_write_ctrl(dd, true, iv);
+	emr = AES_EMR_PLIPEN;
+	if (!enc)
+		emr |= AES_EMR_PLIPD;
+	atmel_aes_write(dd, AES_EMR, emr);
+
+	/* Transfer data. */
+	return atmel_aes_dma_start(dd, src, dst, rctx->textlen,
+				   atmel_aes_authenc_digest);
+}
+
+static int atmel_aes_authenc_digest(struct atmel_aes_dev *dd)
+{
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+
+	/* atmel_sha_authenc_final() releases the SHA device. */
+	dd->flags &= ~AES_FLAGS_OWN_SHA;
+	return atmel_sha_authenc_final(&rctx->auth_req,
+				       rctx->digest, sizeof(rctx->digest),
+				       atmel_aes_authenc_final, dd);
+}
+
+static int atmel_aes_authenc_final(struct atmel_aes_dev *dd, int err,
+				   bool is_async)
+{
+	struct aead_request *req = aead_request_cast(dd->areq);
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	bool enc = atmel_aes_is_encrypt(dd);
+	u32 idigest[SHA512_DIGEST_SIZE / sizeof(u32)], *odigest = rctx->digest;
+	u32 offs, authsize;
+
+	if (is_async)
+		dd->is_async = true;
+	if (err)
+		goto complete;
+
+	offs = req->assoclen + rctx->textlen;
+	authsize = crypto_aead_authsize(tfm);
+	if (enc) {
+		scatterwalk_map_and_copy(odigest, req->dst, offs, authsize, 1);
+	} else {
+		scatterwalk_map_and_copy(idigest, req->src, offs, authsize, 0);
+		if (crypto_memneq(idigest, odigest, authsize))
+			err = -EBADMSG;
+	}
+
+complete:
+	return atmel_aes_complete(dd, err);
+}
+
+static int atmel_aes_authenc_setkey(struct crypto_aead *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
+	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
+		goto badkey;
+
+	if (keys.enckeylen > sizeof(ctx->base.key))
+		goto badkey;
+
+	/* Save auth key. */
+	flags = crypto_aead_get_flags(tfm);
+	err = atmel_sha_authenc_setkey(ctx->auth,
+				       keys.authkey, keys.authkeylen,
+				       &flags);
+	crypto_aead_set_flags(tfm, flags & CRYPTO_TFM_RES_MASK);
+	if (err) {
+		memzero_explicit(&keys, sizeof(keys));
+		return err;
+	}
+
+	/* Save enc key. */
+	ctx->base.keylen = keys.enckeylen;
+	memcpy(ctx->base.key, keys.enckey, keys.enckeylen);
+
+	memzero_explicit(&keys, sizeof(keys));
+	return 0;
+
+badkey:
+	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	memzero_explicit(&key, sizeof(keys));
+	return -EINVAL;
+}
+
+static int atmel_aes_authenc_init_tfm(struct crypto_aead *tfm,
+				      unsigned long auth_mode)
+{
+	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int auth_reqsize = atmel_sha_authenc_get_reqsize();
+
+	ctx->auth = atmel_sha_authenc_spawn(auth_mode);
+	if (IS_ERR(ctx->auth))
+		return PTR_ERR(ctx->auth);
+
+	crypto_aead_set_reqsize(tfm, (sizeof(struct atmel_aes_authenc_reqctx) +
+				      auth_reqsize));
+	ctx->base.start = atmel_aes_authenc_start;
+
+	return 0;
+}
+
+static int atmel_aes_authenc_hmac_sha1_init_tfm(struct crypto_aead *tfm)
+{
+	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA1);
+}
+
+static int atmel_aes_authenc_hmac_sha224_init_tfm(struct crypto_aead *tfm)
+{
+	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA224);
+}
+
+static int atmel_aes_authenc_hmac_sha256_init_tfm(struct crypto_aead *tfm)
+{
+	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA256);
+}
+
+static int atmel_aes_authenc_hmac_sha384_init_tfm(struct crypto_aead *tfm)
+{
+	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA384);
+}
+
+static int atmel_aes_authenc_hmac_sha512_init_tfm(struct crypto_aead *tfm)
+{
+	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA512);
+}
+
+static void atmel_aes_authenc_exit_tfm(struct crypto_aead *tfm)
+{
+	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
+
+	atmel_sha_authenc_free(ctx->auth);
+}
+
+static int atmel_aes_authenc_crypt(struct aead_request *req,
+				   unsigned long mode)
+{
+	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct atmel_aes_base_ctx *ctx = crypto_aead_ctx(tfm);
+	u32 authsize = crypto_aead_authsize(tfm);
+	bool enc = (mode & AES_FLAGS_ENCRYPT);
+	struct atmel_aes_dev *dd;
+
+	/* Compute text length. */
+	if (!enc && req->cryptlen < authsize)
+		return -EINVAL;
+	rctx->textlen = req->cryptlen - (enc ? 0 : authsize);
+
+	/*
+	 * Currently, empty messages are not supported yet:
+	 * the SHA auto-padding can be used only on non-empty messages.
+	 * Hence a special case needs to be implemented for empty message.
+	 */
+	if (!rctx->textlen && !req->assoclen)
+		return -EINVAL;
+
+	rctx->base.mode = mode;
+	ctx->block_size = AES_BLOCK_SIZE;
+
+	dd = atmel_aes_find_dev(ctx);
+	if (!dd)
+		return -ENODEV;
+
+	return atmel_aes_handle_queue(dd, &req->base);
+}
+
+static int atmel_aes_authenc_cbc_aes_encrypt(struct aead_request *req)
+{
+	return atmel_aes_authenc_crypt(req, AES_FLAGS_CBC | AES_FLAGS_ENCRYPT);
+}
+
+static int atmel_aes_authenc_cbc_aes_decrypt(struct aead_request *req)
+{
+	return atmel_aes_authenc_crypt(req, AES_FLAGS_CBC);
+}
+
+static struct aead_alg aes_authenc_algs[] = {
+{
+	.setkey		= atmel_aes_authenc_setkey,
+	.encrypt	= atmel_aes_authenc_cbc_aes_encrypt,
+	.decrypt	= atmel_aes_authenc_cbc_aes_decrypt,
+	.init		= atmel_aes_authenc_hmac_sha1_init_tfm,
+	.exit		= atmel_aes_authenc_exit_tfm,
+	.ivsize		= AES_BLOCK_SIZE,
+	.maxauthsize	= SHA1_DIGEST_SIZE,
+
+	.base = {
+		.cra_name		= "authenc(hmac(sha1),cbc(aes))",
+		.cra_driver_name	= "atmel-authenc-hmac-sha1-cbc-aes",
+		.cra_priority		= ATMEL_AES_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct atmel_aes_authenc_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+{
+	.setkey		= atmel_aes_authenc_setkey,
+	.encrypt	= atmel_aes_authenc_cbc_aes_encrypt,
+	.decrypt	= atmel_aes_authenc_cbc_aes_decrypt,
+	.init		= atmel_aes_authenc_hmac_sha224_init_tfm,
+	.exit		= atmel_aes_authenc_exit_tfm,
+	.ivsize		= AES_BLOCK_SIZE,
+	.maxauthsize	= SHA224_DIGEST_SIZE,
+
+	.base = {
+		.cra_name		= "authenc(hmac(sha224),cbc(aes))",
+		.cra_driver_name	= "atmel-authenc-hmac-sha224-cbc-aes",
+		.cra_priority		= ATMEL_AES_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct atmel_aes_authenc_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+{
+	.setkey		= atmel_aes_authenc_setkey,
+	.encrypt	= atmel_aes_authenc_cbc_aes_encrypt,
+	.decrypt	= atmel_aes_authenc_cbc_aes_decrypt,
+	.init		= atmel_aes_authenc_hmac_sha256_init_tfm,
+	.exit		= atmel_aes_authenc_exit_tfm,
+	.ivsize		= AES_BLOCK_SIZE,
+	.maxauthsize	= SHA256_DIGEST_SIZE,
+
+	.base = {
+		.cra_name		= "authenc(hmac(sha256),cbc(aes))",
+		.cra_driver_name	= "atmel-authenc-hmac-sha256-cbc-aes",
+		.cra_priority		= ATMEL_AES_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct atmel_aes_authenc_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+{
+	.setkey		= atmel_aes_authenc_setkey,
+	.encrypt	= atmel_aes_authenc_cbc_aes_encrypt,
+	.decrypt	= atmel_aes_authenc_cbc_aes_decrypt,
+	.init		= atmel_aes_authenc_hmac_sha384_init_tfm,
+	.exit		= atmel_aes_authenc_exit_tfm,
+	.ivsize		= AES_BLOCK_SIZE,
+	.maxauthsize	= SHA384_DIGEST_SIZE,
+
+	.base = {
+		.cra_name		= "authenc(hmac(sha384),cbc(aes))",
+		.cra_driver_name	= "atmel-authenc-hmac-sha384-cbc-aes",
+		.cra_priority		= ATMEL_AES_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct atmel_aes_authenc_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+{
+	.setkey		= atmel_aes_authenc_setkey,
+	.encrypt	= atmel_aes_authenc_cbc_aes_encrypt,
+	.decrypt	= atmel_aes_authenc_cbc_aes_decrypt,
+	.init		= atmel_aes_authenc_hmac_sha512_init_tfm,
+	.exit		= atmel_aes_authenc_exit_tfm,
+	.ivsize		= AES_BLOCK_SIZE,
+	.maxauthsize	= SHA512_DIGEST_SIZE,
+
+	.base = {
+		.cra_name		= "authenc(hmac(sha512),cbc(aes))",
+		.cra_driver_name	= "atmel-authenc-hmac-sha512-cbc-aes",
+		.cra_priority		= ATMEL_AES_PRIORITY,
+		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct atmel_aes_authenc_ctx),
+		.cra_alignmask		= 0xf,
+		.cra_module		= THIS_MODULE,
+	},
+},
+};
+#endif /* CONFIG_CRYPTO_DEV_ATMEL_AUTHENC */
 
 /* Probe functions */
 
@@ -2040,6 +2453,12 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+	if (dd->caps.has_authenc)
+		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++)
+			crypto_unregister_aead(&aes_authenc_algs[i]);
+#endif
+
 	if (dd->caps.has_xts)
 		crypto_unregister_alg(&aes_xts_alg);
 
@@ -2081,8 +2500,25 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 			goto err_aes_xts_alg;
 	}
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+	if (dd->caps.has_authenc) {
+		for (i = 0; i < ARRAY_SIZE(aes_authenc_algs); i++) {
+			err = crypto_register_aead(&aes_authenc_algs[i]);
+			if (err)
+				goto err_aes_authenc_alg;
+		}
+	}
+#endif
+
 	return 0;
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+	/* i = ARRAY_SIZE(aes_authenc_algs); */
+err_aes_authenc_alg:
+	for (j = 0; j < i; j++)
+		crypto_unregister_aead(&aes_authenc_algs[j]);
+	crypto_unregister_alg(&aes_xts_alg);
+#endif
 err_aes_xts_alg:
 	crypto_unregister_aead(&aes_gcm_alg);
 err_aes_gcm_alg:
@@ -2103,6 +2539,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 	dd->caps.has_ctr32 = 0;
 	dd->caps.has_gcm = 0;
 	dd->caps.has_xts = 0;
+	dd->caps.has_authenc = 0;
 	dd->caps.max_burst_size = 1;
 
 	/* keep only major version number */
@@ -2113,6 +2550,7 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 		dd->caps.has_ctr32 = 1;
 		dd->caps.has_gcm = 1;
 		dd->caps.has_xts = 1;
+		dd->caps.has_authenc = 1;
 		dd->caps.max_burst_size = 4;
 		break;
 	case 0x200:
@@ -2271,6 +2709,13 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	atmel_aes_get_cap(aes_dd);
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+	if (aes_dd->caps.has_authenc && !atmel_sha_authenc_is_ready()) {
+		err = -EPROBE_DEFER;
+		goto iclk_unprepare;
+	}
+#endif
+
 	err = atmel_aes_buff_init(aes_dd);
 	if (err)
 		goto err_aes_buff;
@@ -2307,7 +2752,8 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&aes_dd->done_task);
 	tasklet_kill(&aes_dd->queue_task);
 aes_dd_err:
-	dev_err(dev, "initialization failed.\n");
+	if (err != -EPROBE_DEFER)
+		dev_err(dev, "initialization failed.\n");
 
 	return err;
 }
diff --git a/drivers/crypto/atmel-authenc.h b/drivers/crypto/atmel-authenc.h
new file mode 100644
index 000000000000..2a60d1224143
--- /dev/null
+++ b/drivers/crypto/atmel-authenc.h
@@ -0,0 +1,64 @@
+/*
+ * API for Atmel Secure Protocol Layers Improved Performances (SPLIP)
+ *
+ * Copyright (C) 2016 Atmel Corporation
+ *
+ * Author: Cyrille Pitchen <cyrille.pitchen@atmel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * This driver is based on drivers/mtd/spi-nor/fsl-quadspi.c from Freescale.
+ */
+
+#ifndef __ATMEL_AUTHENC_H__
+#define __ATMEL_AUTHENC_H__
+
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+
+#include <crypto/authenc.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include "atmel-sha-regs.h"
+
+struct atmel_aes_dev;
+typedef int (*atmel_aes_authenc_fn_t)(struct atmel_aes_dev *, int, bool);
+
+struct atmel_sha_authenc_ctx;
+
+bool atmel_sha_authenc_is_ready(void);
+unsigned int atmel_sha_authenc_get_reqsize(void);
+
+struct atmel_sha_authenc_ctx *atmel_sha_authenc_spawn(unsigned long mode);
+void atmel_sha_authenc_free(struct atmel_sha_authenc_ctx *auth);
+int atmel_sha_authenc_setkey(struct atmel_sha_authenc_ctx *auth,
+			     const u8 *key, unsigned int keylen,
+			     u32 *flags);
+
+int atmel_sha_authenc_schedule(struct ahash_request *req,
+			       struct atmel_sha_authenc_ctx *auth,
+			       atmel_aes_authenc_fn_t cb,
+			       struct atmel_aes_dev *dd);
+int atmel_sha_authenc_init(struct ahash_request *req,
+			   struct scatterlist *assoc, unsigned int assoclen,
+			   unsigned int textlen,
+			   atmel_aes_authenc_fn_t cb,
+			   struct atmel_aes_dev *dd);
+int atmel_sha_authenc_final(struct ahash_request *req,
+			    u32 *digest, unsigned int digestlen,
+			    atmel_aes_authenc_fn_t cb,
+			    struct atmel_aes_dev *dd);
+void  atmel_sha_authenc_abort(struct ahash_request *req);
+
+#endif /* CONFIG_CRYPTO_DEV_ATMEL_AUTHENC */
+
+#endif /* __ATMEL_AUTHENC_H__ */
diff --git a/drivers/crypto/atmel-sha-regs.h b/drivers/crypto/atmel-sha-regs.h
index 1b9f3d33079e..1b0eba4a2706 100644
--- a/drivers/crypto/atmel-sha-regs.h
+++ b/drivers/crypto/atmel-sha-regs.h
@@ -29,6 +29,20 @@
 #define SHA_MR_HMAC			(1 << 11)
 #define	SHA_MR_DUALBUFF			(1 << 16)
 
+#define SHA_FLAGS_ALGO_MASK	SHA_MR_ALGO_MASK
+#define SHA_FLAGS_SHA1		SHA_MR_ALGO_SHA1
+#define SHA_FLAGS_SHA256	SHA_MR_ALGO_SHA256
+#define SHA_FLAGS_SHA384	SHA_MR_ALGO_SHA384
+#define SHA_FLAGS_SHA512	SHA_MR_ALGO_SHA512
+#define SHA_FLAGS_SHA224	SHA_MR_ALGO_SHA224
+#define SHA_FLAGS_HMAC		SHA_MR_HMAC
+#define SHA_FLAGS_HMAC_SHA1	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA1)
+#define SHA_FLAGS_HMAC_SHA256	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA256)
+#define SHA_FLAGS_HMAC_SHA384	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA384)
+#define SHA_FLAGS_HMAC_SHA512	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA512)
+#define SHA_FLAGS_HMAC_SHA224	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA224)
+#define SHA_FLAGS_MODE_MASK	(SHA_FLAGS_HMAC | SHA_FLAGS_ALGO_MASK)
+
 #define SHA_IER				0x10
 #define SHA_IDR				0x14
 #define SHA_IMR				0x18
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 78c3c02e4483..cc5294dbead4 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -41,6 +41,7 @@
 #include <crypto/internal/hash.h>
 #include <linux/platform_data/crypto-atmel.h>
 #include "atmel-sha-regs.h"
+#include "atmel-authenc.h"
 
 /* SHA flags */
 #define SHA_FLAGS_BUSY			BIT(0)
@@ -52,19 +53,6 @@
 #define SHA_FLAGS_DMA_READY		BIT(6)
 
 /* bits[11:8] are reserved. */
-#define SHA_FLAGS_ALGO_MASK	SHA_MR_ALGO_MASK
-#define SHA_FLAGS_SHA1		SHA_MR_ALGO_SHA1
-#define SHA_FLAGS_SHA256	SHA_MR_ALGO_SHA256
-#define SHA_FLAGS_SHA384	SHA_MR_ALGO_SHA384
-#define SHA_FLAGS_SHA512	SHA_MR_ALGO_SHA512
-#define SHA_FLAGS_SHA224	SHA_MR_ALGO_SHA224
-#define SHA_FLAGS_HMAC		SHA_MR_HMAC
-#define SHA_FLAGS_HMAC_SHA1	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA1)
-#define SHA_FLAGS_HMAC_SHA256	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA256)
-#define SHA_FLAGS_HMAC_SHA384	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA384)
-#define SHA_FLAGS_HMAC_SHA512	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA512)
-#define SHA_FLAGS_HMAC_SHA224	(SHA_FLAGS_HMAC | SHA_FLAGS_SHA224)
-#define SHA_FLAGS_MODE_MASK	(SHA_FLAGS_HMAC | SHA_FLAGS_ALGO_MASK)
 
 #define SHA_FLAGS_FINUP		BIT(16)
 #define SHA_FLAGS_SG		BIT(17)
@@ -156,6 +144,7 @@ struct atmel_sha_dev {
 	struct crypto_queue	queue;
 	struct ahash_request	*req;
 	bool			is_async;
+	bool			force_complete;
 	atmel_sha_fn_t		resume;
 	atmel_sha_fn_t		cpu_transfer_complete;
 
@@ -198,7 +187,7 @@ static inline int atmel_sha_complete(struct atmel_sha_dev *dd, int err)
 
 	clk_disable(dd->iclk);
 
-	if (dd->is_async && req->base.complete)
+	if ((dd->is_async || dd->force_complete) && req->base.complete)
 		req->base.complete(&req->base, err);
 
 	/* handle new request */
@@ -992,6 +981,7 @@ static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 	dd->req = ahash_request_cast(async_req);
 	start_async = (dd->req != req);
 	dd->is_async = start_async;
+	dd->force_complete = false;
 
 	/* WARNING: ctx->start() MAY change dd->is_async. */
 	err = ctx->start(dd);
@@ -2100,6 +2090,332 @@ static struct ahash_alg sha_hmac_algs[] = {
 },
 };
 
+#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
+/* authenc functions */
+
+static int atmel_sha_authenc_init2(struct atmel_sha_dev *dd);
+static int atmel_sha_authenc_init_done(struct atmel_sha_dev *dd);
+static int atmel_sha_authenc_final_done(struct atmel_sha_dev *dd);
+
+
+struct atmel_sha_authenc_ctx {
+	struct crypto_ahash	*tfm;
+};
+
+struct atmel_sha_authenc_reqctx {
+	struct atmel_sha_reqctx	base;
+
+	atmel_aes_authenc_fn_t	cb;
+	struct atmel_aes_dev	*aes_dev;
+
+	/* _init() parameters. */
+	struct scatterlist	*assoc;
+	u32			assoclen;
+	u32			textlen;
+
+	/* _final() parameters. */
+	u32			*digest;
+	unsigned int		digestlen;
+};
+
+static void atmel_sha_authenc_complete(struct crypto_async_request *areq,
+				       int err)
+{
+	struct ahash_request *req = areq->data;
+	struct atmel_sha_authenc_reqctx *authctx  = ahash_request_ctx(req);
+
+	authctx->cb(authctx->aes_dev, err, authctx->base.dd->is_async);
+}
+
+static int atmel_sha_authenc_start(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	int err;
+
+	/*
+	 * Force atmel_sha_complete() to call req->base.complete(), ie
+	 * atmel_sha_authenc_complete(), which in turn calls authctx->cb().
+	 */
+	dd->force_complete = true;
+
+	err = atmel_sha_hw_init(dd);
+	return authctx->cb(authctx->aes_dev, err, dd->is_async);
+}
+
+bool atmel_sha_authenc_is_ready(void)
+{
+	struct atmel_sha_ctx dummy;
+
+	dummy.dd = NULL;
+	return (atmel_sha_find_dev(&dummy) != NULL);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_is_ready);
+
+unsigned int atmel_sha_authenc_get_reqsize(void)
+{
+	return sizeof(struct atmel_sha_authenc_reqctx);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_get_reqsize);
+
+struct atmel_sha_authenc_ctx *atmel_sha_authenc_spawn(unsigned long mode)
+{
+	struct atmel_sha_authenc_ctx *auth;
+	struct crypto_ahash *tfm;
+	struct atmel_sha_ctx *tctx;
+	const char *name;
+	int err = -EINVAL;
+
+	switch (mode & SHA_FLAGS_MODE_MASK) {
+	case SHA_FLAGS_HMAC_SHA1:
+		name = "atmel-hmac-sha1";
+		break;
+
+	case SHA_FLAGS_HMAC_SHA224:
+		name = "atmel-hmac-sha224";
+		break;
+
+	case SHA_FLAGS_HMAC_SHA256:
+		name = "atmel-hmac-sha256";
+		break;
+
+	case SHA_FLAGS_HMAC_SHA384:
+		name = "atmel-hmac-sha384";
+		break;
+
+	case SHA_FLAGS_HMAC_SHA512:
+		name = "atmel-hmac-sha512";
+		break;
+
+	default:
+		goto error;
+	}
+
+	tfm = crypto_alloc_ahash(name,
+				 CRYPTO_ALG_TYPE_AHASH,
+				 CRYPTO_ALG_TYPE_AHASH_MASK);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto error;
+	}
+	tctx = crypto_ahash_ctx(tfm);
+	tctx->start = atmel_sha_authenc_start;
+	tctx->flags = mode;
+
+	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
+	if (!auth) {
+		err = -ENOMEM;
+		goto err_free_ahash;
+	}
+	auth->tfm = tfm;
+
+	return auth;
+
+err_free_ahash:
+	crypto_free_ahash(tfm);
+error:
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_spawn);
+
+void atmel_sha_authenc_free(struct atmel_sha_authenc_ctx *auth)
+{
+	if (auth)
+		crypto_free_ahash(auth->tfm);
+	kfree(auth);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_free);
+
+int atmel_sha_authenc_setkey(struct atmel_sha_authenc_ctx *auth,
+			     const u8 *key, unsigned int keylen,
+			     u32 *flags)
+{
+	struct crypto_ahash *tfm = auth->tfm;
+	int err;
+
+	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(tfm, *flags & CRYPTO_TFM_REQ_MASK);
+	err = crypto_ahash_setkey(tfm, key, keylen);
+	*flags = crypto_ahash_get_flags(tfm);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_setkey);
+
+int atmel_sha_authenc_schedule(struct ahash_request *req,
+			       struct atmel_sha_authenc_ctx *auth,
+			       atmel_aes_authenc_fn_t cb,
+			       struct atmel_aes_dev *aes_dev)
+{
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	struct atmel_sha_reqctx *ctx = &authctx->base;
+	struct crypto_ahash *tfm = auth->tfm;
+	struct atmel_sha_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct atmel_sha_dev *dd;
+
+	/* Reset request context (MUST be done first). */
+	memset(authctx, 0, sizeof(*authctx));
+
+	/* Get SHA device. */
+	dd = atmel_sha_find_dev(tctx);
+	if (!dd)
+		return cb(aes_dev, -ENODEV, false);
+
+	/* Init request context. */
+	ctx->dd = dd;
+	ctx->buflen = SHA_BUFFER_LEN;
+	authctx->cb = cb;
+	authctx->aes_dev = aes_dev;
+	ahash_request_set_tfm(req, tfm);
+	ahash_request_set_callback(req, 0, atmel_sha_authenc_complete, req);
+
+	return atmel_sha_handle_queue(dd, req);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_schedule);
+
+int atmel_sha_authenc_init(struct ahash_request *req,
+			   struct scatterlist *assoc, unsigned int assoclen,
+			   unsigned int textlen,
+			   atmel_aes_authenc_fn_t cb,
+			   struct atmel_aes_dev *aes_dev)
+{
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	struct atmel_sha_reqctx *ctx = &authctx->base;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	struct atmel_sha_dev *dd = ctx->dd;
+
+	if (unlikely(!IS_ALIGNED(assoclen, sizeof(u32))))
+		return atmel_sha_complete(dd, -EINVAL);
+
+	authctx->cb = cb;
+	authctx->aes_dev = aes_dev;
+	authctx->assoc = assoc;
+	authctx->assoclen = assoclen;
+	authctx->textlen = textlen;
+
+	ctx->flags = hmac->base.flags;
+	return atmel_sha_hmac_setup(dd, atmel_sha_authenc_init2);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_init);
+
+static int atmel_sha_authenc_init2(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	struct atmel_sha_reqctx *ctx = &authctx->base;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
+	size_t hs = ctx->hash_size;
+	size_t i, num_words = hs / sizeof(u32);
+	u32 mr, msg_size;
+
+	atmel_sha_write(dd, SHA_CR, SHA_CR_WUIHV);
+	for (i = 0; i < num_words; ++i)
+		atmel_sha_write(dd, SHA_REG_DIN(i), hmac->ipad[i]);
+
+	atmel_sha_write(dd, SHA_CR, SHA_CR_WUIEHV);
+	for (i = 0; i < num_words; ++i)
+		atmel_sha_write(dd, SHA_REG_DIN(i), hmac->opad[i]);
+
+	mr = (SHA_MR_MODE_IDATAR0 |
+	      SHA_MR_HMAC |
+	      SHA_MR_DUALBUFF);
+	mr |= ctx->flags & SHA_FLAGS_ALGO_MASK;
+	atmel_sha_write(dd, SHA_MR, mr);
+
+	msg_size = authctx->assoclen + authctx->textlen;
+	atmel_sha_write(dd, SHA_MSR, msg_size);
+	atmel_sha_write(dd, SHA_BCR, msg_size);
+
+	atmel_sha_write(dd, SHA_CR, SHA_CR_FIRST);
+
+	/* Process assoc data. */
+	return atmel_sha_cpu_start(dd, authctx->assoc, authctx->assoclen,
+				   true, false,
+				   atmel_sha_authenc_init_done);
+}
+
+static int atmel_sha_authenc_init_done(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+
+	return authctx->cb(authctx->aes_dev, 0, dd->is_async);
+}
+
+int atmel_sha_authenc_final(struct ahash_request *req,
+			    u32 *digest, unsigned int digestlen,
+			    atmel_aes_authenc_fn_t cb,
+			    struct atmel_aes_dev *aes_dev)
+{
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	struct atmel_sha_reqctx *ctx = &authctx->base;
+	struct atmel_sha_dev *dd = ctx->dd;
+
+	switch (ctx->flags & SHA_FLAGS_ALGO_MASK) {
+	case SHA_FLAGS_SHA1:
+		authctx->digestlen = SHA1_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA224:
+		authctx->digestlen = SHA224_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA256:
+		authctx->digestlen = SHA256_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA384:
+		authctx->digestlen = SHA384_DIGEST_SIZE;
+		break;
+
+	case SHA_FLAGS_SHA512:
+		authctx->digestlen = SHA512_DIGEST_SIZE;
+		break;
+
+	default:
+		return atmel_sha_complete(dd, -EINVAL);
+	}
+	if (authctx->digestlen > digestlen)
+		authctx->digestlen = digestlen;
+
+	authctx->cb = cb;
+	authctx->aes_dev = aes_dev;
+	authctx->digest = digest;
+	return atmel_sha_wait_for_data_ready(dd,
+					     atmel_sha_authenc_final_done);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_final);
+
+static int atmel_sha_authenc_final_done(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	size_t i, num_words = authctx->digestlen / sizeof(u32);
+
+	for (i = 0; i < num_words; ++i)
+		authctx->digest[i] = atmel_sha_read(dd, SHA_REG_DIGEST(i));
+
+	return atmel_sha_complete(dd, 0);
+}
+
+void atmel_sha_authenc_abort(struct ahash_request *req)
+{
+	struct atmel_sha_authenc_reqctx *authctx = ahash_request_ctx(req);
+	struct atmel_sha_reqctx *ctx = &authctx->base;
+	struct atmel_sha_dev *dd = ctx->dd;
+
+	/* Prevent atmel_sha_complete() from calling req->base.complete(). */
+	dd->is_async = false;
+	dd->force_complete = false;
+	(void)atmel_sha_complete(dd, 0);
+}
+EXPORT_SYMBOL_GPL(atmel_sha_authenc_abort);
+
+#endif /* CONFIG_CRYPTO_DEV_ATMEL_AUTHENC */
+
+
 static void atmel_sha_unregister_algs(struct atmel_sha_dev *dd)
 {
 	int i;
-- 
2.7.4
