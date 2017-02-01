From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -stable] crypto: ccm - deal with CTR ciphers that honour iv_out
Date: Wed, 1 Feb 2017 20:08:09 +0000
Message-ID: <CAKv+Gu9Em15JVQOo9civMMWOtwBR0R_a+K0P1Y-JOZJU5zPtnw@mail.gmail.com>
References: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35117 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdBAUIL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 15:08:11 -0500
Received: by mail-it0-f46.google.com with SMTP id 203so24982033ith.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 12:08:10 -0800 (PST)
In-Reply-To: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 January 2017 at 20:40, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The skcipher API mandates that chaining modes involving IVs calculate
> an outgoing IV value that is suitable for encrypting additional blocks
> of data. This means the CCM driver cannot assume that req->iv points to
> the original IV value when it calls crypto_ccm_auth. So pass a copy to
> the skcipher instead.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/ccm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index b388ac6edfb9..8976ef9bc2e7 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -362,7 +362,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>         unsigned int cryptlen = req->cryptlen;
>         u8 *authtag = pctx->auth_tag;
>         u8 *odata = pctx->odata;
> -       u8 *iv = req->iv;
> +       u8 iv[16];
>         int err;
>
>         cryptlen -= authsize;
> @@ -378,6 +378,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>         if (req->src != req->dst)
>                 dst = pctx->dst;
>
> +       memcpy(iv, req->iv, sizeof(iv));
>         skcipher_request_set_tfm(skreq, ctx->ctr);
>         skcipher_request_set_callback(skreq, pctx->flags,
>                                       crypto_ccm_decrypt_done, req);
> --
> 2.7.4
>

Herbert,

Could you please forward this patch to Linus as well? I noticed that the patch

crypto: arm64/aes-blk - honour iv_out requirement in CBC and CTR modes

is now in mainline, which means CCM is now broken on arm64, given that
the iv_out requirement for CTR apparently isn't honored by *any*
implementation, and CCM wrongly assumes that req->iv retains its value
across the call into the CTR skcipher

Thanks,
Ard.
