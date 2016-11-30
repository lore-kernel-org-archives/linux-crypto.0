From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/4] crypto: arm64/aes-ce-ccm - fix decrypt path with new
 skcipher interface
Date: Wed, 30 Nov 2016 13:24:37 +0000
Message-ID: <CAKv+Gu-K7v8KwwH5eOkNsvaFSRsayA72mLiYEhQ5Q_Ur9kPZgQ@mail.gmail.com>
References: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
 <1480424733-10797-3-git-send-email-ard.biesheuvel@linaro.org> <20161130131407.GA3958@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36053 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcK3NYj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:24:39 -0500
Received: by mail-io0-f182.google.com with SMTP id m5so209824807ioe.3
        for <linux-crypto@vger.kernel.org>; Wed, 30 Nov 2016 05:24:38 -0800 (PST)
In-Reply-To: <20161130131407.GA3958@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30 November 2016 at 13:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Nov 29, 2016 at 01:05:32PM +0000, Ard Biesheuvel wrote:
>> The new skcipher walk interface does not take into account whether we
>> are encrypting or decrypting. In the latter case, the walk should
>> disregard the MAC. Fix this in the arm64 CE driver.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Thanks for the patch.  I'm going to build this into the AEAD walker
> instead, by providing separate entry points for encryption and
> decryption.  Like this,
>

Yes, that's better, thanks

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---8<---
> Subject: crypto: skcipher - Add separate walker for AEAD decryption
>
> The AEAD decrypt interface includes the authentication tag in
> req->cryptlen.  Therefore we need to exlucde that when doing
> a walk over it.
>
> This patch adds separate walker functions for AEAD encryption
> and decryption.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 5367f81..aca07c6 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -500,8 +500,8 @@ int skcipher_walk_async(struct skcipher_walk *walk,
>  }
>  EXPORT_SYMBOL_GPL(skcipher_walk_async);
>
> -int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
> -                      bool atomic)
> +static int skcipher_walk_aead_common(struct skcipher_walk *walk,
> +                                    struct aead_request *req, bool atomic)
>  {
>         struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>         int err;
> @@ -514,7 +514,6 @@ int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
>         scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
>         scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
>
> -       walk->total = req->cryptlen;
>         walk->iv = req->iv;
>         walk->oiv = req->iv;
>
> @@ -535,8 +534,36 @@ int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
>
>         return err;
>  }
> +
> +int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
> +                      bool atomic)
> +{
> +       walk->total = req->cryptlen;
> +
> +       return skcipher_walk_aead_common(walk, req, atomic);
> +}
>  EXPORT_SYMBOL_GPL(skcipher_walk_aead);
>
> +int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
> +                              struct aead_request *req, bool atomic)
> +{
> +       walk->total = req->cryptlen;
> +
> +       return skcipher_walk_aead_common(walk, req, atomic);
> +}
> +EXPORT_SYMBOL_GPL(skcipher_walk_aead_encrypt);
> +
> +int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
> +                              struct aead_request *req, bool atomic)
> +{
> +       struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +
> +       walk->total = req->cryptlen - crypto_aead_authsize(tfm);
> +
> +       return skcipher_walk_aead_common(walk, req, atomic);
> +}
> +EXPORT_SYMBOL_GPL(skcipher_walk_aead_decrypt);
> +
>  static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
>  {
>         if (alg->cra_type == &crypto_blkcipher_type)
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index d55041f..8735979 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -149,6 +149,10 @@ int skcipher_walk_async(struct skcipher_walk *walk,
>                         struct skcipher_request *req);
>  int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
>                        bool atomic);
> +int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
> +                              struct aead_request *req, bool atomic);
> +int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
> +                              struct aead_request *req, bool atomic);
>  void skcipher_walk_complete(struct skcipher_walk *walk, int err);
>
>  static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
