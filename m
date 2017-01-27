From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/4] crypto: ccm - switch to separate cbcmac driver
Date: Fri, 27 Jan 2017 09:41:37 +0000
Message-ID: <CAKv+Gu8uY7=rVJWUerNiV6zk7tnA7Ke2cCwK7CQ-PNOPK99v6w@mail.gmail.com>
References: <1485451063-11822-1-git-send-email-ard.biesheuvel@linaro.org> <1485451063-11822-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34629 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932387AbdA0Jlj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2017 04:41:39 -0500
Received: by mail-io0-f178.google.com with SMTP id l66so56884277ioi.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jan 2017 01:41:38 -0800 (PST)
In-Reply-To: <1485451063-11822-3-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26 January 2017 at 17:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Update the generic CCM driver to defer CBC-MAC processing to a
> dedicated CBC-MAC ahash transform rather than open coding this
> transform (and much of the associated scatterwalk plumbing) in
> the CCM driver itself.
>
> This cleans up the code considerably, but more importantly, it allows
> the use of alternative CBC-MAC implementations that don't suffer from
> performance degradation due to significant setup time (e.g., the NEON
> based AES code needs to load the entire S-box into SIMD registers, which
> cannot be amortized over the entire input when using the AES cipher
> directly)
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig |   1 +
>  crypto/ccm.c   | 373 +++++++++++++-------
>  2 files changed, 238 insertions(+), 136 deletions(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 160f08e721cc..e8269d1b0282 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -263,6 +263,7 @@ comment "Authenticated Encryption with Associated Data"
>  config CRYPTO_CCM
>         tristate "CCM support"
>         select CRYPTO_CTR
> +       select CRYPTO_HASH
>         select CRYPTO_AEAD
>         help
>           Support for Counter with CBC MAC. Required for IPsec.
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 26b924d1e582..635f11fc52e7 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -11,6 +11,7 @@
>   */
>
>  #include <crypto/internal/aead.h>
> +#include <crypto/internal/hash.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/err.h>
> @@ -23,11 +24,11 @@
>
>  struct ccm_instance_ctx {
>         struct crypto_skcipher_spawn ctr;
> -       struct crypto_spawn cipher;
> +       struct crypto_ahash_spawn mac;
>  };
>
>  struct crypto_ccm_ctx {
> -       struct crypto_cipher *cipher;
> +       struct crypto_ahash *mac;
>         struct crypto_skcipher *ctr;
>  };
>
> @@ -44,7 +45,6 @@ struct crypto_rfc4309_req_ctx {
>
>  struct crypto_ccm_req_priv_ctx {
>         u8 odata[16];
> -       u8 idata[16];
>         u8 auth_tag[16];
>         u32 ilen;

This is unused now.

>         u32 flags;
> @@ -53,6 +53,15 @@ struct crypto_ccm_req_priv_ctx {
>         struct skcipher_request skreq;
>  };
>
> +struct cbcmac_tfm_ctx {
> +       struct crypto_cipher *child;
> +};
> +
> +struct cbcmac_desc_ctx {
> +       unsigned int len;
> +       u8 dg[];
> +};
> +
>  static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
>         struct aead_request *req)
>  {
> @@ -84,7 +93,7 @@ static int crypto_ccm_setkey(struct crypto_aead *aead, const u8 *key,
>  {
>         struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
>         struct crypto_skcipher *ctr = ctx->ctr;
> -       struct crypto_cipher *tfm = ctx->cipher;
> +       struct crypto_ahash *mac = ctx->mac;
>         int err = 0;
>
>         crypto_skcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
> @@ -96,11 +105,11 @@ static int crypto_ccm_setkey(struct crypto_aead *aead, const u8 *key,
>         if (err)
>                 goto out;
>
> -       crypto_cipher_clear_flags(tfm, CRYPTO_TFM_REQ_MASK);
> -       crypto_cipher_set_flags(tfm, crypto_aead_get_flags(aead) &
> +       crypto_ahash_clear_flags(mac, CRYPTO_TFM_REQ_MASK);
> +       crypto_ahash_set_flags(mac, crypto_aead_get_flags(aead) &
>                                     CRYPTO_TFM_REQ_MASK);
> -       err = crypto_cipher_setkey(tfm, key, keylen);
> -       crypto_aead_set_flags(aead, crypto_cipher_get_flags(tfm) &
> +       err = crypto_ahash_setkey(mac, key, keylen);
> +       crypto_aead_set_flags(aead, crypto_ahash_get_flags(mac) &
>                               CRYPTO_TFM_RES_MASK);
>
>  out:
> @@ -167,119 +176,59 @@ static int format_adata(u8 *adata, unsigned int a)
>         return len;
>  }
>
> -static void compute_mac(struct crypto_cipher *tfm, u8 *data, int n,
> -                      struct crypto_ccm_req_priv_ctx *pctx)
> -{
> -       unsigned int bs = 16;
> -       u8 *odata = pctx->odata;
> -       u8 *idata = pctx->idata;
> -       int datalen, getlen;
> -
> -       datalen = n;
> -
> -       /* first time in here, block may be partially filled. */
> -       getlen = bs - pctx->ilen;
> -       if (datalen >= getlen) {
> -               memcpy(idata + pctx->ilen, data, getlen);
> -               crypto_xor(odata, idata, bs);
> -               crypto_cipher_encrypt_one(tfm, odata, odata);
> -               datalen -= getlen;
> -               data += getlen;
> -               pctx->ilen = 0;
> -       }
> -
> -       /* now encrypt rest of data */
> -       while (datalen >= bs) {
> -               crypto_xor(odata, data, bs);
> -               crypto_cipher_encrypt_one(tfm, odata, odata);
> -
> -               datalen -= bs;
> -               data += bs;
> -       }
> -
> -       /* check and see if there's leftover data that wasn't
> -        * enough to fill a block.
> -        */
> -       if (datalen) {
> -               memcpy(idata + pctx->ilen, data, datalen);
> -               pctx->ilen += datalen;
> -       }
> -}
> -
> -static void get_data_to_compute(struct crypto_cipher *tfm,
> -                              struct crypto_ccm_req_priv_ctx *pctx,
> -                              struct scatterlist *sg, unsigned int len)
> -{
> -       struct scatter_walk walk;
> -       u8 *data_src;
> -       int n;
> -
> -       scatterwalk_start(&walk, sg);
> -
> -       while (len) {
> -               n = scatterwalk_clamp(&walk, len);
> -               if (!n) {
> -                       scatterwalk_start(&walk, sg_next(walk.sg));
> -                       n = scatterwalk_clamp(&walk, len);
> -               }
> -               data_src = scatterwalk_map(&walk);
> -
> -               compute_mac(tfm, data_src, n, pctx);
> -               len -= n;
> -
> -               scatterwalk_unmap(data_src);
> -               scatterwalk_advance(&walk, n);
> -               scatterwalk_done(&walk, 0, len);
> -               if (len)
> -                       crypto_yield(pctx->flags);
> -       }
> -
> -       /* any leftover needs padding and then encrypted */
> -       if (pctx->ilen) {
> -               int padlen;
> -               u8 *odata = pctx->odata;
> -               u8 *idata = pctx->idata;
> -
> -               padlen = 16 - pctx->ilen;
> -               memset(idata + pctx->ilen, 0, padlen);
> -               crypto_xor(odata, idata, 16);
> -               crypto_cipher_encrypt_one(tfm, odata, odata);
> -               pctx->ilen = 0;
> -       }
> -}
> -
>  static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
>                            unsigned int cryptlen)
>  {
> +       struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
>         struct crypto_aead *aead = crypto_aead_reqtfm(req);
>         struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
> -       struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
> -       struct crypto_cipher *cipher = ctx->cipher;
> +       AHASH_REQUEST_ON_STACK(ahreq, ctx->mac);
>         unsigned int assoclen = req->assoclen;
> -       u8 *odata = pctx->odata;
> -       u8 *idata = pctx->idata;
> -       int err;
> +       struct scatterlist sg[3];
> +       u8 odata[16];
> +       u8 idata[16];
> +       int ilen, err;
>
>         /* format control data for input */
>         err = format_input(odata, req, cryptlen);
>         if (err)
>                 goto out;
>
> -       /* encrypt first block to use as start in computing mac  */
> -       crypto_cipher_encrypt_one(cipher, odata, odata);
> +       sg_init_table(sg, 3);
> +       sg_set_buf(&sg[0], odata, 16);
>
>         /* format associated data and compute into mac */
>         if (assoclen) {
> -               pctx->ilen = format_adata(idata, assoclen);
> -               get_data_to_compute(cipher, pctx, req->src, req->assoclen);
> +               ilen = format_adata(idata, assoclen);
> +               sg_set_buf(&sg[1], idata, ilen);
> +               sg_chain(sg, 3, req->src);
>         } else {
> -               pctx->ilen = 0;
> +               ilen = 0;
> +               sg_chain(sg, 2, req->src);
>         }
>
> -       /* compute plaintext into mac */
> -       if (cryptlen)
> -               get_data_to_compute(cipher, pctx, plain, cryptlen);
> +       ahash_request_set_tfm(ahreq, ctx->mac);


This needs

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 635f11fc52e7..016059c0ffdc 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -208,6 +208,7 @@ static int crypto_ccm_auth(struct aead_request
*req, struct scatterlist *plain,
        }

        ahash_request_set_tfm(ahreq, ctx->mac);
+       ahash_request_set_callback(ahreq, pctx->flags, NULL, NULL);
        ahash_request_set_crypt(ahreq, sg, NULL, assoclen + ilen + 16);
        err = crypto_ahash_init(ahreq);
        if (err)

here

> +       ahash_request_set_crypt(ahreq, sg, NULL, assoclen + ilen + 16);
> +       err = crypto_ahash_init(ahreq);
> +       if (err)
> +               goto out;
> +       err = crypto_ahash_update(ahreq);
> +       if (err)
> +               goto out;
>
> +       /* we need to pad the MAC input to a round multiple of the block size */
> +       ilen = 16 - (assoclen + ilen) % 16;
> +       if (ilen < 16) {
> +               memset(idata, 0, ilen);
> +               sg_init_table(sg, 2);
> +               sg_set_buf(&sg[0], idata, ilen);
> +               sg_chain(sg, 2, plain);
> +               plain = sg;
> +               cryptlen += ilen;
> +       }
> +
> +       ahash_request_set_crypt(ahreq, plain, pctx->odata, cryptlen);
> +       err = crypto_ahash_finup(ahreq);
>  out:
>         return err;
>  }
> @@ -453,21 +402,21 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
>         struct aead_instance *inst = aead_alg_instance(tfm);
>         struct ccm_instance_ctx *ictx = aead_instance_ctx(inst);
>         struct crypto_ccm_ctx *ctx = crypto_aead_ctx(tfm);
> -       struct crypto_cipher *cipher;
> +       struct crypto_ahash *mac;
>         struct crypto_skcipher *ctr;
>         unsigned long align;
>         int err;
>
> -       cipher = crypto_spawn_cipher(&ictx->cipher);
> -       if (IS_ERR(cipher))
> -               return PTR_ERR(cipher);
> +       mac = crypto_spawn_ahash(&ictx->mac);
> +       if (IS_ERR(mac))
> +               return PTR_ERR(mac);
>
>         ctr = crypto_spawn_skcipher(&ictx->ctr);
>         err = PTR_ERR(ctr);
>         if (IS_ERR(ctr))
> -               goto err_free_cipher;
> +               goto err_free_mac;
>
> -       ctx->cipher = cipher;
> +       ctx->mac = mac;
>         ctx->ctr = ctr;
>
>         align = crypto_aead_alignmask(tfm);
> @@ -479,8 +428,8 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
>
>         return 0;
>
> -err_free_cipher:
> -       crypto_free_cipher(cipher);
> +err_free_mac:
> +       crypto_free_ahash(mac);
>         return err;
>  }
>
> @@ -488,7 +437,7 @@ static void crypto_ccm_exit_tfm(struct crypto_aead *tfm)
>  {
>         struct crypto_ccm_ctx *ctx = crypto_aead_ctx(tfm);
>
> -       crypto_free_cipher(ctx->cipher);
> +       crypto_free_ahash(ctx->mac);
>         crypto_free_skcipher(ctx->ctr);
>  }
>
> @@ -496,7 +445,7 @@ static void crypto_ccm_free(struct aead_instance *inst)
>  {
>         struct ccm_instance_ctx *ctx = aead_instance_ctx(inst);
>
> -       crypto_drop_spawn(&ctx->cipher);
> +       crypto_drop_ahash(&ctx->mac);
>         crypto_drop_skcipher(&ctx->ctr);
>         kfree(inst);
>  }
> @@ -505,12 +454,13 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
>                                     struct rtattr **tb,
>                                     const char *full_name,
>                                     const char *ctr_name,
> -                                   const char *cipher_name)
> +                                   const char *mac_name)
>  {
>         struct crypto_attr_type *algt;
>         struct aead_instance *inst;
>         struct skcipher_alg *ctr;
> -       struct crypto_alg *cipher;
> +       struct crypto_alg *mac_alg;
> +       struct hash_alg_common *mac;
>         struct ccm_instance_ctx *ictx;
>         int err;
>
> @@ -521,25 +471,26 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
>         if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
>                 return -EINVAL;
>
> -       cipher = crypto_alg_mod_lookup(cipher_name,  CRYPTO_ALG_TYPE_CIPHER,
> -                                      CRYPTO_ALG_TYPE_MASK);
> -       if (IS_ERR(cipher))
> -               return PTR_ERR(cipher);
> +       mac_alg = crypto_find_alg(mac_name, &crypto_ahash_type,
> +                                 CRYPTO_ALG_TYPE_HASH,
> +                                 CRYPTO_ALG_TYPE_AHASH_MASK |
> +                                 CRYPTO_ALG_ASYNC);
> +       if (IS_ERR(mac_alg))
> +               return PTR_ERR(mac_alg);
>
> +       mac = __crypto_hash_alg_common(mac_alg);
>         err = -EINVAL;
> -       if (cipher->cra_blocksize != 16)
> -               goto out_put_cipher;
> +       if (mac->digestsize != 16)
> +               goto out_put_mac;
>
>         inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
>         err = -ENOMEM;
>         if (!inst)
> -               goto out_put_cipher;
> +               goto out_put_mac;
>
>         ictx = aead_instance_ctx(inst);
> -
> -       err = crypto_init_spawn(&ictx->cipher, cipher,
> -                               aead_crypto_instance(inst),
> -                               CRYPTO_ALG_TYPE_MASK);
> +       err = crypto_init_ahash_spawn(&ictx->mac, mac,
> +                                     aead_crypto_instance(inst));
>         if (err)
>                 goto err_free_inst;
>
> @@ -548,7 +499,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
>                                    crypto_requires_sync(algt->type,
>                                                         algt->mask));
>         if (err)
> -               goto err_drop_cipher;
> +               goto err_drop_mac;
>
>         ctr = crypto_spawn_skcipher_alg(&ictx->ctr);
>
> @@ -564,16 +515,16 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
>         err = -ENAMETOOLONG;
>         if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
>                      "ccm_base(%s,%s)", ctr->base.cra_driver_name,
> -                    cipher->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
> +                    mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
>                 goto err_drop_ctr;
>
>         memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
>
>         inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
> -       inst->alg.base.cra_priority = (cipher->cra_priority +
> +       inst->alg.base.cra_priority = (mac->base.cra_priority +
>                                        ctr->base.cra_priority) / 2;
>         inst->alg.base.cra_blocksize = 1;
> -       inst->alg.base.cra_alignmask = cipher->cra_alignmask |
> +       inst->alg.base.cra_alignmask = mac->base.cra_alignmask |
>                                        ctr->base.cra_alignmask |
>                                        (__alignof__(u32) - 1);
>         inst->alg.ivsize = 16;
> @@ -593,23 +544,24 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
>         if (err)
>                 goto err_drop_ctr;
>
> -out_put_cipher:
> -       crypto_mod_put(cipher);
> +out_put_mac:
> +       crypto_mod_put(mac_alg);
>         return err;
>
>  err_drop_ctr:
>         crypto_drop_skcipher(&ictx->ctr);
> -err_drop_cipher:
> -       crypto_drop_spawn(&ictx->cipher);
> +err_drop_mac:
> +       crypto_drop_ahash(&ictx->mac);
>  err_free_inst:
>         kfree(inst);
> -       goto out_put_cipher;
> +       goto out_put_mac;
>  }
>
>  static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
>  {
>         const char *cipher_name;
>         char ctr_name[CRYPTO_MAX_ALG_NAME];
> +       char mac_name[CRYPTO_MAX_ALG_NAME];
>         char full_name[CRYPTO_MAX_ALG_NAME];
>
>         cipher_name = crypto_attr_alg_name(tb[1]);
> @@ -620,12 +572,16 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
>                      cipher_name) >= CRYPTO_MAX_ALG_NAME)
>                 return -ENAMETOOLONG;
>
> +       if (snprintf(mac_name, CRYPTO_MAX_ALG_NAME, "cbcmac(%s)",
> +                    cipher_name) >= CRYPTO_MAX_ALG_NAME)
> +               return -ENAMETOOLONG;
> +
>         if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm(%s)", cipher_name) >=
>             CRYPTO_MAX_ALG_NAME)
>                 return -ENAMETOOLONG;
>
>         return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
> -                                       cipher_name);
> +                                       mac_name);
>  }
>
>  static struct crypto_template crypto_ccm_tmpl = {
> @@ -899,14 +855,156 @@ static struct crypto_template crypto_rfc4309_tmpl = {
>         .module = THIS_MODULE,
>  };
>
> +static int crypto_cbcmac_digest_setkey(struct crypto_shash *parent,
> +                                    const u8 *inkey, unsigned int keylen)
> +{
> +       struct cbcmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
> +
> +       return crypto_cipher_setkey(ctx->child, inkey, keylen);
> +}
> +
> +static int crypto_cbcmac_digest_init(struct shash_desc *pdesc)
> +{
> +       struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
> +       int bs = crypto_shash_digestsize(pdesc->tfm);
> +
> +       memset(ctx->dg, 0, bs);
> +       ctx->len = 0;
> +
> +       return 0;
> +}
> +
> +static int crypto_cbcmac_digest_update(struct shash_desc *pdesc, const u8 *p,
> +                                      unsigned int len)
> +{
> +       struct crypto_shash *parent = pdesc->tfm;
> +       struct cbcmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
> +       struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
> +       struct crypto_cipher *tfm = tctx->child;
> +       int bs = crypto_shash_digestsize(parent);
> +
> +       while (len--) {
> +               ctx->dg[ctx->len++] ^= *p++;
> +
> +               if (ctx->len == bs) {
> +                       crypto_cipher_encrypt_one(tfm, ctx->dg, ctx->dg);
> +                       ctx->len = 0;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int crypto_cbcmac_digest_final(struct shash_desc *pdesc, u8 *out)
> +{
> +       struct crypto_shash *parent = pdesc->tfm;
> +       struct cbcmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
> +       struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
> +       struct crypto_cipher *tfm = tctx->child;
> +       int bs = crypto_shash_digestsize(parent);
> +
> +       if (ctx->len)
> +               crypto_cipher_encrypt_one(tfm, out, ctx->dg);
> +       else
> +               memcpy(out, ctx->dg, bs);
> +
> +       return 0;
> +}
> +
> +static int cbcmac_init_tfm(struct crypto_tfm *tfm)
> +{
> +       struct crypto_cipher *cipher;
> +       struct crypto_instance *inst = (void *)tfm->__crt_alg;
> +       struct crypto_spawn *spawn = crypto_instance_ctx(inst);
> +       struct cbcmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +       cipher = crypto_spawn_cipher(spawn);
> +       if (IS_ERR(cipher))
> +               return PTR_ERR(cipher);
> +
> +       ctx->child = cipher;
> +
> +       return 0;
> +};
> +
> +static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
> +{
> +       struct cbcmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
> +       crypto_free_cipher(ctx->child);
> +}
> +
> +static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
> +{
> +       struct shash_instance *inst;
> +       struct crypto_alg *alg;
> +       int err;
> +
> +       err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
> +       if (err)
> +               return err;
> +
> +       alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
> +                                 CRYPTO_ALG_TYPE_MASK);
> +       if (IS_ERR(alg))
> +               return PTR_ERR(alg);
> +
> +       inst = shash_alloc_instance("cbcmac", alg);
> +       err = PTR_ERR(inst);
> +       if (IS_ERR(inst))
> +               goto out_put_alg;
> +
> +       err = crypto_init_spawn(shash_instance_ctx(inst), alg,
> +                               shash_crypto_instance(inst),
> +                               CRYPTO_ALG_TYPE_MASK);
> +       if (err)
> +               goto out_free_inst;
> +
> +       inst->alg.base.cra_priority = alg->cra_priority;
> +       inst->alg.base.cra_blocksize = 1;
> +
> +       inst->alg.digestsize = alg->cra_blocksize;
> +       inst->alg.descsize = sizeof(struct cbcmac_desc_ctx) +
> +                            alg->cra_blocksize;
> +
> +       inst->alg.base.cra_ctxsize = sizeof(struct cbcmac_tfm_ctx);
> +       inst->alg.base.cra_init = cbcmac_init_tfm;
> +       inst->alg.base.cra_exit = cbcmac_exit_tfm;
> +
> +       inst->alg.init = crypto_cbcmac_digest_init;
> +       inst->alg.update = crypto_cbcmac_digest_update;
> +       inst->alg.final = crypto_cbcmac_digest_final;
> +       inst->alg.setkey = crypto_cbcmac_digest_setkey;
> +
> +       err = shash_register_instance(tmpl, inst);
> +
> +out_free_inst:
> +       if (err)
> +               shash_free_instance(shash_crypto_instance(inst));
> +
> +out_put_alg:
> +       crypto_mod_put(alg);
> +       return err;
> +}
> +
> +static struct crypto_template crypto_cbcmac_tmpl = {
> +       .name = "cbcmac",
> +       .create = cbcmac_create,
> +       .free = shash_free_instance,
> +       .module = THIS_MODULE,
> +};
> +
>  static int __init crypto_ccm_module_init(void)
>  {
>         int err;
>
> -       err = crypto_register_template(&crypto_ccm_base_tmpl);
> +       err = crypto_register_template(&crypto_cbcmac_tmpl);
>         if (err)
>                 goto out;
>
> +       err = crypto_register_template(&crypto_ccm_base_tmpl);
> +       if (err)
> +               goto out_undo_cbcmac;
> +
>         err = crypto_register_template(&crypto_ccm_tmpl);
>         if (err)
>                 goto out_undo_base;
> @@ -922,6 +1020,8 @@ static int __init crypto_ccm_module_init(void)
>         crypto_unregister_template(&crypto_ccm_tmpl);
>  out_undo_base:
>         crypto_unregister_template(&crypto_ccm_base_tmpl);
> +out_undo_cbcmac:
> +       crypto_register_template(&crypto_cbcmac_tmpl);
>         goto out;
>  }
>
> @@ -930,6 +1030,7 @@ static void __exit crypto_ccm_module_exit(void)
>         crypto_unregister_template(&crypto_rfc4309_tmpl);
>         crypto_unregister_template(&crypto_ccm_tmpl);
>         crypto_unregister_template(&crypto_ccm_base_tmpl);
> +       crypto_unregister_template(&crypto_cbcmac_tmpl);
>  }
>
>  module_init(crypto_ccm_module_init);
> --
> 2.7.4
>
