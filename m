From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH] picoxcell_crypto: add support for the picoxcell crypto
 engines
Date: Fri, 11 Feb 2011 11:57:47 +0000
Message-ID: <20110211115747.GF3057@pulham.picochip.com>
References: <1297180576-11581-1-git-send-email-jamie@jamieiles.com>
 <20110210220916.aac2b545.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jamie Iles <jamie@jamieiles.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58587 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1BKL5x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Feb 2011 06:57:53 -0500
Received: by eye27 with SMTP id 27so1286449eye.19
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2011 03:57:51 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20110210220916.aac2b545.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 10, 2011 at 10:09:16PM -0600, Kim Phillips wrote:
> On Tue, 8 Feb 2011 15:56:16 +0000
> Jamie Iles <jamie@jamieiles.com> wrote:
> 
> > Picochip picoXcell devices have two crypto engines, one targeted
> > at IPSEC offload and the other at WCDMA layer 2 ciphering.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > ---
> 
> nice driver ;).  Have a couple of comments though.

Hi Kim,

Thanks for the great review!

> 
> > +     help
> > +       This option enables support for the hardware offload engines in the
> > +       Picochip picoXcell SoC devices. Select this for IPSEC ESP offload
> > +       and for 3gpp Layer 2 ciphering support.
> 
> it'd be nice to mention what name the module will have.

Ok, will add.

> 
> > +#define SPACC_CRYPTO_AES_MAX_KEY_LEN 32
> > +#define SPACC_CRYPTO_AES_IV_LEN              16
> > +#define SPACC_CRYPTO_DES_IV_LEN              8
> 
> these are identical to algorithm-generic symbolic constants
> AES_MAX_KEY_SIZE, [AD]ES_BLOCK_SIZE - why not use them instead?

I wasn't aware of these constants but yes, that's much better.
> 
> > +struct spacc_generic_ctx;
> 
> this declaration isn't used prior to its definition, so it's not needed.

Ok, will remove.

> > +/* DDT format. This must match the hardware DDT format exactly. */
> > +struct spacc_ddt {
> > +     u32 p, len;
> 
> type-consistency: p should be a dma_addr_t

The reason I used a u32 was the the engine descriptor format is two 32 
bit words so I was trying to be explicit but I'll change this to 
dma_addr_t.

> 
> > +     /* AEAD specifc bits. */
> 
> specific

Good spot!

> > +static inline struct spacc_ablk_ctx *
> > +to_spacc_ablk_ctx(struct spacc_generic_ctx *ctx)
> > +{
> > +     return ctx ? container_of(ctx, struct spacc_ablk_ctx, generic) : NULL;
> > +}
> > +
> > +static inline struct spacc_aead_ctx *
> > +to_spacc_aead_ctx(struct spacc_generic_ctx *ctx)
> > +{
> > +     return ctx ? container_of(ctx, struct spacc_aead_ctx, generic) : NULL;
> > +}
> 
> these aren't being used anywhere.

Ok, will remove.

> 
> > +static inline struct spacc_alg *to_spacc_alg(struct crypto_alg *alg);
> 
> define it here - forward declarations should only be necessary when
> dealing with circular dependencies.

Hmm, not sure why I didn't do that originally!  Will change.

> 
> > +/*
> > + * Take a crypto request and scatterlists for the data and turn them into DDTs
> > + * for passing to the crypto engines. This also DMA maps the data so that the
> > + * crypto engines can DMA to/from them.
> > + */
> > +static struct spacc_ddt *spacc_sg_to_ddt(struct spacc_engine *engine,
> > +                                      struct scatterlist *payload,
> > +                                      unsigned nbytes,
> > +                                      enum dma_data_direction dir,
> > +                                      dma_addr_t *ddt_phys)
> > +{
> > +     unsigned nents, mapped_ents;
> > +     struct scatterlist *cur;
> > +     struct spacc_ddt *ddt;
> > +     int i;
> > +
> > +     nents = sg_count(payload, nbytes);
> > +     mapped_ents = dma_map_sg(engine->dev, payload, nents, dir);
> > +
> > +     if (mapped_ents + 1 > MAX_DDT_LEN) {
> > +             dma_unmap_sg(engine->dev, payload, nents, dir);
> > +             return NULL;
> > +     }
> > +
> > +     ddt = dma_pool_alloc(engine->req_pool, GFP_ATOMIC, ddt_phys);
> > +     if (ddt) {
> > +             for_each_sg(payload, cur, mapped_ents, i) {
> > +                     ddt[i].p = sg_dma_address(cur);
> > +                     ddt[i].len = sg_dma_len(cur);
> > +             }
> > +
> > +             ddt[mapped_ents].p = 0;
> > +             ddt[mapped_ents].len = 0;
> > +     } else {
> > +             dma_unmap_sg(engine->dev, payload, nents, dir);
> > +             ddt = NULL;
> > +     }
> > +
> > +     return ddt;
> > +}
> 
> easier to read would be:
> 
>         if (mapped_ents + 1 > MAX_DDT_LEN)
>                 goto out;
> 
>         ddt = dma_pool_alloc(engine->req_pool, GFP_ATOMIC, ddt_phys);
>         if (!ddt)
>                 goto out;
> 
>         for_each_sg(payload, cur, mapped_ents, i) {
>                 ddt[i].p = sg_dma_address(cur);
>                 ddt[i].len = sg_dma_len(cur);
>         }
>         ddt[mapped_ents].p = 0;
>         ddt[mapped_ents].len = 0;
> 
>         return ddt;
> 
> out:
>         dma_unmap_sg(engine->dev, payload, nents, dir);
>         return NULL;
> }
> 
> even more so by moving ddt_set() above it, and then using ddt_set() to
> assign the p, len pairs.

Yes, that's much cleaner.

> 
> > +static inline void ddt_set(struct spacc_ddt *ddt, unsigned long phys,
> 
> phys should be dma_addr_t

Ok.

> 
> > +static int spacc_aead_make_ddts(struct spacc_req *req, u8 *giv)
> > +{
> > +     struct aead_request *areq = container_of(req->req, struct aead_request,
> > +                                              base);
> > +     struct spacc_alg *alg = to_spacc_alg(req->req->tfm->__crt_alg);
> > +     struct spacc_engine *engine = req->engine;
> > +     struct spacc_ddt *src_ddt, *dst_ddt;
> > +     unsigned ivsize = alg->alg.cra_aead.ivsize;
> 
> no need to go through all those hoops to get to the ivsize - use helper
> fns crypto_aead_reqtfm() and crypto_aead_ivsize(), as is done at the
> callsite, or just pass it in from there.

Ok, will do.

> 
> > +static int spacc_aead_des_setkey(struct crypto_aead *aead, const u8 *key,
> > +                              unsigned int len)
> > +{
> > +     struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> > +     struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
> > +     int err = 0;
> > +     u32 tmp[DES_EXPKEY_WORDS];
> > +
> > +     err = des_ekey(tmp, key);
> > +     if (unlikely(!err) &&
> 
> might want to change the name of the variable err here to something
> like ret or is_weak so as to not mislead the reader.
> 
> > +         (crypto_aead_get_flags(aead)) & CRYPTO_TFM_REQ_WEAK_KEY) {
> > +             tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
> > +             return -EINVAL;
> > +     }
> > +     err = 0;
> > +
> > +     memcpy(ctx->cipher_key, key, len);
> > +     ctx->cipher_key_len = len;
> > +
> > +     return err;
> 
> actually, it doesn't look like this fn needs a return variable
> at all.

Ok, I'll get rid of err and put the des_ekey() call into the 
conditional.

> > +/* Set the key for the AES block cipher component of the AEAD 
> > transform. */
> > +static int spacc_aead_aes_setkey(struct crypto_aead *aead, const u8 *key,
> > +                              unsigned int len)
> > +{
> > +     struct crypto_tfm *tfm = crypto_aead_tfm(aead);
> > +     struct spacc_aead_ctx *ctx = crypto_tfm_ctx(tfm);
> > +     int err;
> > +
> > +     /*
> > +      * IPSec engine only supports 128 and 256 bit AES keys. If we get a
> > +      * request for any other size (192 bits) then we need to do a software
> > +      * fallback.
> > +      */
> > +     if (!(16 == len || 32 == len)) {
> 
> if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256)

Ok, I'll clean up all of these uses.

> > +             /*
> > +              * Set the fallback transform to use the same request flags as
> > +              * the hardware transform.
> > +              */
> > +             ctx->sw_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> > +             ctx->sw_cipher->base.crt_flags |=
> > +                     (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
> 
> parens not needed.

Ok.

> > +             err = crypto_aead_setkey(ctx->sw_cipher, key, len);
> > +     } else {
> > +             memcpy(ctx->cipher_key, key, len);
> > +             ctx->cipher_key_len = len;
> > +             err = 0;
> > +     }
> > +
> > +     return err;
> 
> 	return crypto_aead_setkey(ctx->sw_cipher, key, len);
> }
> memcpy(ctx->cipher_key, key, len);
> ctx->cipher_key_len = len;
> 
> return 0;

Ok.

> > +static int spacc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
> > +                          unsigned int keylen)
> > +{
> > +     struct spacc_aead_ctx *ctx = crypto_aead_ctx(tfm);
> > +     struct spacc_alg *alg = to_spacc_alg(tfm->base.__crt_alg);
> > +     struct rtattr *rta = (void *)key;
> > +     struct crypto_authenc_key_param *param;
> > +     unsigned int authkeylen, enckeylen;
> > +     int err = -EINVAL;
> > +
> > +     if (!RTA_OK(rta, keylen))
> > +             goto badkey;
> > +
> > +     if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
> > +             goto badkey;
> > +
> > +     if (RTA_PAYLOAD(rta) < sizeof(*param))
> > +             goto badkey;
> 
> I'm not sure, but it should be safe to remove the above three checks -
> they cause a false badkey failure if the keys aren't within an rtattr
> struct, which, e.g., something like testmgr.c wouldn't do.
> 
> > +     param = RTA_DATA(rta);
> > +     enckeylen = be32_to_cpu(param->enckeylen);
> > +
> > +     key += RTA_ALIGN(rta->rta_len);
> > +     keylen -= RTA_ALIGN(rta->rta_len);
> 
> actually, I doubt crypto drivers should be including rtnetlink.h at
> all...but it's probably ok for now - talitos still does :)

Yes, it doesn't seem the nicest way to pass the keys.  ixp4xx and 
crypto/authenc.c do the same thing (including the first 3 checks).  
Perhaps this is worth refactoring into a generic 
crypto_authenc_get_keys() helper?

> > +     if ((spacc_alg->ctrl_default & SPACC_CRYPTO_ALG_MASK) ==
> > +         SPA_CTRL_CIPH_ALG_AES &&
> > +         !(16 == ctx->cipher_key_len || 32 == ctx->cipher_key_len))
> 
> as above, please use symbolic equivalents

Ok.

> > +static void spacc_aead_complete(struct spacc_req *req)
> > +{
> > +     spacc_aead_free_ddts(req);
> > +
> > +     if (req->req->complete)
> > +             req->req->complete(req->req, req->result);
> 
> when is there not a completion function?

Ok, I'll remove that check.

> > +     /* Set the source and destination DDT pointers. */
> > +     writel((u32)req->src_addr, engine->regs + SPA_SRC_PTR_REG_OFFSET);
> > +     writel((u32)req->dst_addr, engine->regs + SPA_DST_PTR_REG_OFFSET);
> 
> cast necessary?

No, probably not.  I'll double check and remove if ok.

> > +     ctrl = spacc_alg->ctrl_default;
> > +     ctrl |= ((req->ctx_id << SPA_CTRL_CTX_IDX) |
> > +              (1 << SPA_CTRL_ICV_APPEND) |
> > +              (req->is_encrypt ? (1 << SPA_CTRL_ENCRYPT_IDX) : 0) |
> > +              (req->is_encrypt ? (1 << SPA_CTRL_AAD_COPY) : 0));
> > +     if (!req->is_encrypt)
> > +             ctrl |= (1 << SPA_CTRL_KEY_EXP);
> 
> ctrl = spacc_alg->ctrl_default | (req->ctx_id << SPA_CTRL_CTX_IDX) |
>        (1 << SPA_CTRL_ICV_APPEND);
> 
> if (req->is_encrypt)
> 	ctrl |= (1 << SPA_CTRL_ENCRYPT_IDX) | (1 << SPA_CTRL_AAD_COPY);
> else
> 	ctrl |= (1 << SPA_CTRL_KEY_EXP);

Yes, that's nicer.

> > +static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
> > +                         unsigned int len)
> > +{
> > +     struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> > +     struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
> > +     int err;
> > +     u32 tmp[DES_EXPKEY_WORDS];
> > +
> > +     if (len > SPACC_CRYPTO_AES_MAX_KEY_LEN) {
> 
> AES left overs in a DES setkey

Good spot, will fix.

> > +static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
> > +                         unsigned int len)
> > +{
> > +     struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> > +     struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
> > +     int err = 0;
> > +
> > +     if (len > SPACC_CRYPTO_AES_MAX_KEY_LEN) {
> > +             crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > +             return -EINVAL;
> > +     }
> > +
> > +     /*
> > +      * IPSec engine only supports 128 and 256 bit AES keys. If we get a
> > +      * request for any other size (192 bits) then we need to do a software
> > +      * fallback.
> > +      */
> > +     if (!(16 == len || 32 == len) && ctx->sw_cipher) {
> 
> symbolic constants

Ok.

> > +             /*
> > +              * Set the fallback transform to use the same request flags as
> > +              * the hardware transform.
> > +              */
> > +             ctx->sw_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> > +             ctx->sw_cipher->base.crt_flags |=
> > +                 (cipher->base.crt_flags & CRYPTO_TFM_REQ_MASK);
> 
> parens not necessary

Ok.

> > +static int spacc_ablk_need_fallback(struct spacc_req *req)
> > +{
> > +     struct spacc_ablk_ctx *ctx;
> > +     struct crypto_tfm *tfm = req->req->tfm;
> > +     struct crypto_alg *alg = req->req->tfm->__crt_alg;
> > +     struct spacc_alg *spacc_alg = to_spacc_alg(alg);
> > +
> > +     ctx = crypto_tfm_ctx(tfm);
> > +
> > +     return (spacc_alg->ctrl_default & SPACC_CRYPTO_ALG_MASK) ==
> > +                     SPA_CTRL_CIPH_ALG_AES &&
> > +             !(16 == ctx->key_len || 32 == ctx->key_len);
> 
> symbolic constants

Ok.

> > +static ssize_t spacc_stat_irq_thresh_store(struct device *dev,
> > +                                        struct device_attribute *attr,
> > +                                        const char *buf, size_t len)
> > +{
> > +     struct spacc_engine *engine = spacc_dev_to_engine(dev);
> > +     unsigned thresh = simple_strtoul(buf, NULL, 0);
> 
> consider using strict_strtoul (checkpatch)

Ok, will change.

> > +static struct spacc_alg ipsec_engine_algs[] = {
> > +     {
> > +             .ctrl_default = SPA_CTRL_CIPH_ALG_AES | SPA_CTRL_CIPH_MODE_CBC,
> > +             .key_offs = 0,
> > +             .iv_offs = SPACC_CRYPTO_AES_MAX_KEY_LEN,
> > +             .alg = {
> > +                     .cra_name = "cbc(aes)",
> > +                     .cra_driver_name = "cbc-aes-picoxcell",
> > +                     .cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
> > +                     .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
> > +                                  CRYPTO_ALG_ASYNC |
> > +                                  CRYPTO_ALG_NEED_FALLBACK,
> > +                     .cra_blocksize = 16,
> 
> symbolic constant, here and throughout the rest of this section.

Ok.

Thanks again for taking the time to review Kim!

Jamie
