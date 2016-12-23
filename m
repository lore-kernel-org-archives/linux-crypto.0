From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 11/12] crypto: atmel-authenc: add support to
 authenc(hmac(shaX), Y(aes)) modes
Date: Fri, 23 Dec 2016 12:34:03 +0100
Message-ID: <1548507.knvAQkH9bK@tauon.atsec.com>
References: <cover.1482424395.git.cyrille.pitchen@atmel.com>
 <2a6cc4637621d2ef0d84754817128c43795cb022.1482424395.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, nicolas.ferre@atmel.com,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 davem@davemloft.net, linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <2a6cc4637621d2ef0d84754817128c43795cb022.1482424395.git.cyrille.pitchen@atmel.com>
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

Am Donnerstag, 22. Dezember 2016, 17:38:00 CET schrieb Cyrille Pitchen:

Hi Cyrille,

> This patchs allows to combine the AES and SHA hardware accelerators on
> some Atmel SoCs. Doing so, AES blocks are only written to/read from the
> AES hardware. Those blocks are also transferred from the AES to the SHA
> accelerator internally, without additionnal accesses to the system busses.
> 
> Hence, the AES and SHA accelerators work in parallel to process all the
> data blocks, instead of serializing the process by (de)crypting those
> blocks first then authenticating them after like the generic
> crypto/authenc.c driver does.
> 
> Of course, both the AES and SHA hardware accelerators need to be available
> before we can start to process the data blocks. Hence we use their crypto
> request queue to synchronize both drivers.
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> ---
>  drivers/crypto/Kconfig          |  12 +
>  drivers/crypto/atmel-aes-regs.h |  16 ++
>  drivers/crypto/atmel-aes.c      | 471
> +++++++++++++++++++++++++++++++++++++++- drivers/crypto/atmel-authenc.h  | 
> 64 ++++++
>  drivers/crypto/atmel-sha-regs.h |  14 ++
>  drivers/crypto/atmel-sha.c      | 344 +++++++++++++++++++++++++++--
>  6 files changed, 906 insertions(+), 15 deletions(-)
>  create mode 100644 drivers/crypto/atmel-authenc.h
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 79564785ae30..719a868d8ea1 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -415,6 +415,18 @@ config CRYPTO_DEV_BFIN_CRC
>  	  Newer Blackfin processors have CRC hardware. Select this if you
>  	  want to use the Blackfin CRC module.
> 
> +config CRYPTO_DEV_ATMEL_AUTHENC
> +	tristate "Support for Atmel IPSEC/SSL hw accelerator"
> +	depends on (ARCH_AT91 && HAS_DMA) || COMPILE_TEST
> +	select CRYPTO_AUTHENC
> +	select CRYPTO_DEV_ATMEL_AES
> +	select CRYPTO_DEV_ATMEL_SHA
> +	help
> +	  Some Atmel processors can combine the AES and SHA hw accelerators
> +	  to enhance support of IPSEC/SSL.
> +	  Select this if you want to use the Atmel modules for
> +	  authenc(hmac(shaX),Y(cbc)) algorithms.
> +
>  config CRYPTO_DEV_ATMEL_AES
>  	tristate "Support for Atmel AES hw accelerator"
>  	depends on HAS_DMA
> diff --git a/drivers/crypto/atmel-aes-regs.h
> b/drivers/crypto/atmel-aes-regs.h index 0ec04407b533..7694679802b3 100644
> --- a/drivers/crypto/atmel-aes-regs.h
> +++ b/drivers/crypto/atmel-aes-regs.h
> @@ -68,6 +68,22 @@
>  #define AES_CTRR	0x98
>  #define AES_GCMHR(x)	(0x9c + ((x) * 0x04))
> 
> +#define AES_EMR		0xb0
> +#define AES_EMR_APEN		BIT(0)	/* Auto Padding Enable */
> +#define AES_EMR_APM		BIT(1)	/* Auto Padding Mode */
> +#define AES_EMR_APM_IPSEC	0x0
> +#define AES_EMR_APM_SSL		BIT(1)
> +#define AES_EMR_PLIPEN		BIT(4)	/* PLIP Enable */
> +#define AES_EMR_PLIPD		BIT(5)	/* PLIP Decipher */
> +#define AES_EMR_PADLEN_MASK	(0xFu << 8)
> +#define AES_EMR_PADLEN_OFFSET	8
> +#define AES_EMR_PADLEN(padlen)	(((padlen) << AES_EMR_PADLEN_OFFSET) &\
> +				 AES_EMR_PADLEN_MASK)
> +#define AES_EMR_NHEAD_MASK	(0xFu << 16)
> +#define AES_EMR_NHEAD_OFFSET	16
> +#define AES_EMR_NHEAD(nhead)	(((nhead) << AES_EMR_NHEAD_OFFSET) &\
> +				 AES_EMR_NHEAD_MASK)
> +
>  #define AES_TWR(x)	(0xc0 + ((x) * 0x04))
>  #define AES_ALPHAR(x)	(0xd0 + ((x) * 0x04))
> 
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index 9fd2f63b8bc0..3c651e0c3113 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -41,6 +41,7 @@
>  #include <linux/platform_data/crypto-atmel.h>
>  #include <dt-bindings/dma/at91.h>
>  #include "atmel-aes-regs.h"
> +#include "atmel-authenc.h"
> 
>  #define ATMEL_AES_PRIORITY	300
> 
> @@ -78,6 +79,7 @@
>  #define AES_FLAGS_INIT		BIT(2)
>  #define AES_FLAGS_BUSY		BIT(3)
>  #define AES_FLAGS_DUMP_REG	BIT(4)
> +#define AES_FLAGS_OWN_SHA	BIT(5)
> 
>  #define AES_FLAGS_PERSISTENT	(AES_FLAGS_INIT | AES_FLAGS_BUSY)
> 
> @@ -92,6 +94,7 @@ struct atmel_aes_caps {
>  	bool			has_ctr32;
>  	bool			has_gcm;
>  	bool			has_xts;
> +	bool			has_authenc;
>  	u32			max_burst_size;
>  };
> 
> @@ -144,10 +147,31 @@ struct atmel_aes_xts_ctx {
>  	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
>  };
> 
> +#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
> +struct atmel_aes_authenc_ctx {
> +	struct atmel_aes_base_ctx	base;
> +	struct atmel_sha_authenc_ctx	*auth;
> +};
> +#endif
> +
>  struct atmel_aes_reqctx {
>  	unsigned long		mode;
>  };
> 
> +#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
> +struct atmel_aes_authenc_reqctx {
> +	struct atmel_aes_reqctx	base;
> +
> +	struct scatterlist	src[2];
> +	struct scatterlist	dst[2];
> +	size_t			textlen;
> +	u32			digest[SHA512_DIGEST_SIZE / sizeof(u32)];
> +
> +	/* auth_req MUST be place last. */
> +	struct ahash_request	auth_req;
> +};
> +#endif
> +
>  struct atmel_aes_dma {
>  	struct dma_chan		*chan;
>  	struct scatterlist	*sg;
> @@ -291,6 +315,9 @@ static const char *atmel_aes_reg_name(u32 offset, char
> *tmp, size_t sz) snprintf(tmp, sz, "GCMHR[%u]", (offset - AES_GCMHR(0)) >>
> 2);
>  		break;
> 
> +	case AES_EMR:
> +		return "EMR";
> +
>  	case AES_TWR(0):
>  	case AES_TWR(1):
>  	case AES_TWR(2):
> @@ -463,8 +490,16 @@ static inline bool atmel_aes_is_encrypt(const struct
> atmel_aes_dev *dd) return (dd->flags & AES_FLAGS_ENCRYPT);
>  }
> 
> +#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
> +static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err);
> +#endif
> +
>  static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
>  {
> +#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
> +	atmel_aes_authenc_complete(dd, err);
> +#endif
> +
>  	clk_disable(dd->iclk);
>  	dd->flags &= ~AES_FLAGS_BUSY;
> 
> @@ -1931,6 +1966,407 @@ static struct crypto_alg aes_xts_alg = {
>  	}
>  };
> 
> +#ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
> +/* authenc aead functions */
> +
> +static int atmel_aes_authenc_start(struct atmel_aes_dev *dd);
> +static int atmel_aes_authenc_init(struct atmel_aes_dev *dd, int err,
> +				  bool is_async);
> +static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
> +				      bool is_async);
> +static int atmel_aes_authenc_digest(struct atmel_aes_dev *dd);
> +static int atmel_aes_authenc_final(struct atmel_aes_dev *dd, int err,
> +				   bool is_async);
> +
> +static void atmel_aes_authenc_complete(struct atmel_aes_dev *dd, int err)
> +{
> +	struct aead_request *req = aead_request_cast(dd->areq);
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +
> +	if (err && (dd->flags & AES_FLAGS_OWN_SHA))
> +		atmel_sha_authenc_abort(&rctx->auth_req);
> +	dd->flags &= ~AES_FLAGS_OWN_SHA;
> +}
> +
> +static int atmel_aes_authenc_copy_assoc(struct aead_request *req)
> +{
> +	size_t buflen, assoclen = req->assoclen;
> +	off_t skip = 0;
> +	u8 buf[256];
> +
> +	while (assoclen) {
> +		buflen = min_t(size_t, assoclen, sizeof(buf));
> +
> +		if (sg_pcopy_to_buffer(req->src, sg_nents(req->src),
> +				       buf, buflen, skip) != buflen)
> +			return -EINVAL;
> +
> +		if (sg_pcopy_from_buffer(req->dst, sg_nents(req->dst),
> +					 buf, buflen, skip) != buflen)
> +			return -EINVAL;
> +
> +		skip += buflen;
> +		assoclen -= buflen;
> +	}

This seems to be a very expansive operation. Wouldn't it be easier, leaner and 
with one less memcpy to use the approach of crypto_authenc_copy_assoc?

Instead of copying crypto_authenc_copy_assoc, what about carving the logic in 
crypto/authenc.c out into a generic aead helper code as we need to add that to 
other AEAD implementations?
> +
> +	return 0;
> +}
> +
> +static int atmel_aes_authenc_start(struct atmel_aes_dev *dd)
> +{
> +	struct aead_request *req = aead_request_cast(dd->areq);
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
> +	int err;
> +
> +	atmel_aes_set_mode(dd, &rctx->base);
> +
> +	err = atmel_aes_hw_init(dd);
> +	if (err)
> +		return atmel_aes_complete(dd, err);
> +
> +	return atmel_sha_authenc_schedule(&rctx->auth_req, ctx->auth,
> +					  atmel_aes_authenc_init, dd);
> +}
> +
> +static int atmel_aes_authenc_init(struct atmel_aes_dev *dd, int err,
> +				  bool is_async)
> +{
> +	struct aead_request *req = aead_request_cast(dd->areq);
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +
> +	if (is_async)
> +		dd->is_async = true;
> +	if (err)
> +		return atmel_aes_complete(dd, err);
> +
> +	/* If here, we've got the ownership of the SHA device. */
> +	dd->flags |= AES_FLAGS_OWN_SHA;
> +
> +	/* Configure the SHA device. */
> +	return atmel_sha_authenc_init(&rctx->auth_req,
> +				      req->src, req->assoclen,
> +				      rctx->textlen,
> +				      atmel_aes_authenc_transfer, dd);
> +}
> +
> +static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
> +				      bool is_async)
> +{
> +	struct aead_request *req = aead_request_cast(dd->areq);
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +	bool enc = atmel_aes_is_encrypt(dd);
> +	struct scatterlist *src, *dst;
> +	u32 iv[AES_BLOCK_SIZE / sizeof(u32)];
> +	u32 emr;
> +
> +	if (is_async)
> +		dd->is_async = true;
> +	if (err)
> +		return atmel_aes_complete(dd, err);
> +
> +	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
> +	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
> +	dst = src;
> +
> +	if (req->src != req->dst) {
> +		err = atmel_aes_authenc_copy_assoc(req);
> +		if (err)
> +			return atmel_aes_complete(dd, err);
> +
> +		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
> +	}
> +
> +	/* Configure the AES device. */
> +	memcpy(iv, req->iv, sizeof(iv));
> +
> +	/*
> +	 * Here we always set the 2nd parameter of atmel_aes_write_ctrl() to
> +	 * 'true' even if the data transfer is actually performed by the CPU (so
> +	 * not by the DMA) because we must force the AES_MR_SMOD bitfield to the
> +	 * value AES_MR_SMOD_IDATAR0. Indeed, both AES_MR_SMOD and SHA_MR_SMOD
> +	 * must be set to *_MR_SMOD_IDATAR0.
> +	 */
> +	atmel_aes_write_ctrl(dd, true, iv);
> +	emr = AES_EMR_PLIPEN;
> +	if (!enc)
> +		emr |= AES_EMR_PLIPD;
> +	atmel_aes_write(dd, AES_EMR, emr);
> +
> +	/* Transfer data. */
> +	return atmel_aes_dma_start(dd, src, dst, rctx->textlen,
> +				   atmel_aes_authenc_digest);
> +}
> +
> +static int atmel_aes_authenc_digest(struct atmel_aes_dev *dd)
> +{
> +	struct aead_request *req = aead_request_cast(dd->areq);
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +
> +	/* atmel_sha_authenc_final() releases the SHA device. */
> +	dd->flags &= ~AES_FLAGS_OWN_SHA;
> +	return atmel_sha_authenc_final(&rctx->auth_req,
> +				       rctx->digest, sizeof(rctx->digest),
> +				       atmel_aes_authenc_final, dd);
> +}
> +
> +static int atmel_aes_authenc_final(struct atmel_aes_dev *dd, int err,
> +				   bool is_async)
> +{
> +	struct aead_request *req = aead_request_cast(dd->areq);
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	bool enc = atmel_aes_is_encrypt(dd);
> +	u32 idigest[SHA512_DIGEST_SIZE / sizeof(u32)], *odigest = rctx->digest;
> +	u32 offs, authsize;
> +
> +	if (is_async)
> +		dd->is_async = true;
> +	if (err)
> +		goto complete;
> +
> +	offs = req->assoclen + rctx->textlen;
> +	authsize = crypto_aead_authsize(tfm);
> +	if (enc) {
> +		scatterwalk_map_and_copy(odigest, req->dst, offs, authsize, 1);
> +	} else {
> +		scatterwalk_map_and_copy(idigest, req->src, offs, authsize, 0);
> +		if (crypto_memneq(idigest, odigest, authsize))
> +			err = -EBADMSG;
> +	}
> +
> +complete:
> +	return atmel_aes_complete(dd, err);
> +}
> +
> +static int atmel_aes_authenc_setkey(struct crypto_aead *tfm, const u8 *key,
> +				    unsigned int keylen)
> +{
> +	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
> +	struct crypto_authenc_keys keys;
> +	u32 flags;
> +	int err;
> +
> +	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
> +		goto badkey;
> +
> +	if (keys.enckeylen > sizeof(ctx->base.key))
> +		goto badkey;
> +
> +	/* Save auth key. */
> +	flags = crypto_aead_get_flags(tfm);
> +	err = atmel_sha_authenc_setkey(ctx->auth,
> +				       keys.authkey, keys.authkeylen,
> +				       &flags);
> +	crypto_aead_set_flags(tfm, flags & CRYPTO_TFM_RES_MASK);
> +	if (err)
> +		return err;
> +
> +	/* Save enc key. */
> +	ctx->base.keylen = keys.enckeylen;
> +	memcpy(ctx->base.key, keys.enckey, keys.enckeylen);

memzero_explicit(keys) please
> +
> +	return 0;
> +
> +badkey:
> +	crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +	return -EINVAL;
> +}
> +
> +static int atmel_aes_authenc_init_tfm(struct crypto_aead *tfm,
> +				      unsigned long auth_mode)
> +{
> +	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
> +	unsigned int auth_reqsize = atmel_sha_authenc_get_reqsize();
> +
> +	ctx->auth = atmel_sha_authenc_spawn(auth_mode);
> +	if (IS_ERR(ctx->auth))
> +		return PTR_ERR(ctx->auth);
> +
> +	crypto_aead_set_reqsize(tfm, (sizeof(struct atmel_aes_authenc_reqctx) +
> +				      auth_reqsize));
> +	ctx->base.start = atmel_aes_authenc_start;
> +
> +	return 0;
> +}
> +
> +static int atmel_aes_authenc_hmac_sha1_init_tfm(struct crypto_aead *tfm)
> +{
> +	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA1);
> +}
> +
> +static int atmel_aes_authenc_hmac_sha224_init_tfm(struct crypto_aead *tfm)
> +{
> +	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA224);
> +}
> +
> +static int atmel_aes_authenc_hmac_sha256_init_tfm(struct crypto_aead *tfm)
> +{
> +	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA256);
> +}
> +
> +static int atmel_aes_authenc_hmac_sha384_init_tfm(struct crypto_aead *tfm)
> +{
> +	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA384);
> +}
> +
> +static int atmel_aes_authenc_hmac_sha512_init_tfm(struct crypto_aead *tfm)
> +{
> +	return atmel_aes_authenc_init_tfm(tfm, SHA_FLAGS_HMAC_SHA512);
> +}
> +
> +static void atmel_aes_authenc_exit_tfm(struct crypto_aead *tfm)
> +{
> +	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
> +
> +	atmel_sha_authenc_free(ctx->auth);
> +}
> +
> +static int atmel_aes_authenc_crypt(struct aead_request *req,
> +				   unsigned long mode)
> +{
> +	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	struct atmel_aes_base_ctx *ctx = crypto_aead_ctx(tfm);
> +	u32 authsize = crypto_aead_authsize(tfm);
> +	bool enc = (mode & AES_FLAGS_ENCRYPT);
> +	struct atmel_aes_dev *dd;
> +
> +	/* Compute text length. */
> +	rctx->textlen = req->cryptlen - (enc ? 0 : authsize);

Is there somewhere a check that authsize is always < req->cryptlen (at least 
it escaped me)? Note, this logic will be exposed to user space which may do 
funky things.
> +
> +	/*
> +	 * Currently, empty messages are not supported yet:
> +	 * the SHA auto-padding can be used only on non-empty messages.
> +	 * Hence a special case needs to be implemented for empty message.
> +	 */
> +	if (!rctx->textlen && !req->assoclen)
> +		return -EINVAL;
> +
> +	rctx->base.mode = mode;
> +	ctx->block_size = AES_BLOCK_SIZE;
> +
> +	dd = atmel_aes_find_dev(ctx);
> +	if (!dd)
> +		return -ENODEV;
> +
> +	return atmel_aes_handle_queue(dd, &req->base);

Ciao
Stephan
