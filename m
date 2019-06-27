Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31756C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 07:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB9F5205C9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 07:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vbR3WYhU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfF0HE0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 03:04:26 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32888 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0HE0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 03:04:26 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so2516982iop.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 00:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZmkg14rhmcX5Dvn99I9Bdojb+GxN0kaY+JY2CKjAGo=;
        b=vbR3WYhUS9HeIiQnXzqMjOMfF59F2nBROJQUUfNES1Cd8B0fbpsjXssBRAwBd4OJWb
         UCpNtnUJlqgzQGSq6iTYX6coyVr/A4iw4si1tGeljV3UibLsB4dpN7hiG8JSFpTgw/O+
         Ud4ifzxOXHzXuDDLlYp0GOuHO2/CPZtQf8hCGmP+qIwKsbIcgxDo4T4DVrrwnLutmHVl
         zbqqUHgT1TnteK5e0ksflhMCgTp2MLDb4JZtBvfrENyu4SEt1xhsANAccIFeIhkB6a94
         XykjByBhbk34K9b33OPIQG+ZGnUDzklMMdD3fqmUXLson+2cL1cBzrus+P0MH0xC1eSY
         scug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZmkg14rhmcX5Dvn99I9Bdojb+GxN0kaY+JY2CKjAGo=;
        b=mBeHbGxYi182Pcgy2bN2wC6MhxsoiK5cd4f9gk+Q2DPHIKAVEi/cRU9WuBtmbmsECR
         Od+4v05BZnp/CuSbeg9yrJrxl8UXVBU3Fxl+/OV8oKOUV6cbXWcftHev3p4iP99zaExe
         beWlAZDwu/DpiuV+Q3n95EtrSuxg8iyNCG5+Dr/6n8d0fS09P5CL8Ci2i0pA72fialtk
         FbSWxlH28eqwKxtz+fhUaNoF40+R90quxSmgGF6piH/ruhGd0HxsFHMvJDQMlbyG0jmb
         8f77FWJeis7V+j2V2YJntQStyLgvrMsSKC8zdjCVGjiXHDX9E+I/s6XFiMXF8t4d1O1/
         WUog==
X-Gm-Message-State: APjAAAX4nc8hpoU16utFw52xId0YMvStaxDXcDvREghdfqcBQtBoYhDs
        A3sXZhDYIKZ3ZqP+48Ddw22vtaWF5cxKd4jfU1OlnrnIiBdrEQ==
X-Google-Smtp-Source: APXvYqyQ8lEGEOe574tAaBoj1hNDqt9LhwaGLmd8WzETW0ivzLxr8aw/A+Me4o6JpnjnyIzfoRf+ZGTv19sNDODhzm8=
X-Received: by 2002:a6b:7312:: with SMTP id e18mr2631988ioh.156.1561619065452;
 Thu, 27 Jun 2019 00:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org> <20190626204047.32131-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20190626204047.32131-2-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 09:04:10 +0200
Message-ID: <CAKv+Gu8ivcjgM0hjLHrf55kWHpoV8ZYYYLkPuaapMe6Yj37Zbg@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] crypto: essiv - create wrapper template for ESSIV generation
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 26 Jun 2019 at 22:40, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Implement a template that wraps a (skcipher,cipher,shash) or
> (aead,cipher,shash) tuple so that we can consolidate the ESSIV handling
> in fscrypt and dm-crypt and move it into the crypto API. This will result
> in better test coverage, and will allow future changes to make the bare
> cipher interface internal to the crypto subsystem, in order to increase
> robustness of the API against misuse.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig  |   4 +
>  crypto/Makefile |   1 +
>  crypto/essiv.c  | 636 ++++++++++++++++++++
>  3 files changed, 641 insertions(+)
>
...
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> new file mode 100644
> index 000000000000..fddf6dcc3823
> --- /dev/null
> +++ b/crypto/essiv.c
> @@ -0,0 +1,636 @@
...
> +static void essiv_aead_done(struct crypto_async_request *areq, int err)
> +{
> +       struct aead_request *req = areq->data;
> +       struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
> +
> +       if (rctx->iv)
> +               kfree(rctx->iv);
> +       aead_request_complete(req, err);
> +}
> +
> +static int essiv_aead_crypt(struct aead_request *req, bool enc)
> +{
> +       gfp_t gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL
> +                                                                : GFP_ATOMIC;
> +       struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +       const struct essiv_tfm_ctx *tctx = crypto_aead_ctx(tfm);
> +       struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
> +       struct aead_request *subreq = &rctx->aead_req;
> +       struct scatterlist *sg;
> +       int err;
> +
> +       crypto_cipher_encrypt_one(tctx->essiv_cipher, req->iv, req->iv);
> +
> +       /*
> +        * dm-crypt embeds the sector number and the IV in the AAD region, so
> +        * we have to copy the converted IV into the source scatterlist before
> +        * we pass it on. If the source and destination scatterlist pointers
> +        * are the same, we just update the IV copy in the AAD region in-place.
> +        * However, if they are different, the caller is not expecting us to
> +        * modify the memory described by the source scatterlist, and so we have
> +        * to do this little dance to create a new scatterlist that backs the
> +        * IV slot in the AAD region with a scratch buffer that we can freely
> +        * modify.
> +        */
> +       rctx->iv = NULL;
> +       if (req->src != req->dst) {
> +               int ivsize = crypto_aead_ivsize(tfm);
> +               int ssize = req->assoclen - ivsize;
> +               u8 *iv;
> +
> +               if (ssize < 0 || sg_nents_for_len(req->src, ssize) != 1)
> +                       return -EINVAL;
> +
> +               if (enc) {
> +                       rctx->iv = iv = kmemdup(req->iv, ivsize, gfp);

This allocation is not really needed - I'll enlarge the request ctx
struct instead so I can incorporate it as an anonymous member.

> +                       if (!iv)
> +                               return -ENOMEM;
> +               } else {
> +                       /*
> +                        * On the decrypt path, the ahash executes before the
> +                        * skcipher gets a chance to clobber req->iv with its
> +                        * output IV, so just map the buffer directly.
> +                        */
> +                       iv = req->iv;
> +               }
> +
> +               sg_init_table(rctx->sg, 4);
> +               sg_set_page(rctx->sg, sg_page(req->src), ssize, req->src->offset);
> +               sg_set_buf(rctx->sg + 1, iv, ivsize);
> +               sg = scatterwalk_ffwd(rctx->sg + 2, req->src, req->assoclen);
> +               if (sg != rctx->sg + 2)
> +                       sg_chain(rctx->sg, 3, sg);
> +               sg = rctx->sg;
> +       } else {
> +               scatterwalk_map_and_copy(req->iv, req->dst,
> +                                        req->assoclen - crypto_aead_ivsize(tfm),
> +                                        crypto_aead_ivsize(tfm), 1);
> +               sg = req->src;
> +       }
> +
> +       aead_request_set_tfm(subreq, tctx->u.aead);
> +       aead_request_set_ad(subreq, req->assoclen);
> +       aead_request_set_callback(subreq, aead_request_flags(req),
> +                                 essiv_aead_done, req);
> +       aead_request_set_crypt(subreq, sg, req->dst, req->cryptlen, req->iv);
> +
> +       err = enc ? crypto_aead_encrypt(subreq) :
> +                   crypto_aead_decrypt(subreq);
> +
> +       if (rctx->iv && err != -EINPROGRESS)
> +               kfree(rctx->iv);
> +
> +       return err;
> +}
> +
...
