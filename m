Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89AAC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 15:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B7225C57
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 15:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lL0jFZyX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbfE3PNV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 11:13:21 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55063 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfE3PNR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 11:13:17 -0400
Received: by mail-it1-f193.google.com with SMTP id h20so10459625itk.4
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 08:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eui9rhOOSVJFATgLQfCGElNgPrb4OxaEYuZCLtveNFI=;
        b=lL0jFZyXj4J/Ygv652tIZe3DhYPOGYTmW6ZY+3SfO6Wh561kGa2XE2vP7SD8riaC/K
         6MjIbSaBhpLEhFuBCvTgWUuPh5I1PqIK15SUDjDwNwpEFnomrlAKI+aX5IzfCTtMh0Ph
         aR/JboBTnkQONECjroqMRGOrnmFn8sZSoLKgZoF2ota2m3GHqcjbOLMiCx0FxZpazIgY
         8ekUxTlebeuu/Jgo0vHAjFJiGdos5EF/9QM/1c0HesGdp2q/synyRcimtImw8BE3aruN
         /IxRaS9heQNupFlL9HMC+pvf8hLp3SlfsCfP4RLX6xovRdTiMi9mZEz9pqrNm/tYE/PS
         eBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eui9rhOOSVJFATgLQfCGElNgPrb4OxaEYuZCLtveNFI=;
        b=Qaqy4SWxZtGHpc8zhGfzuiZrc1o6ZPIgjNjYceERTr7GI/LKnxwXv6jXis/7Ygb909
         2Dk7Ljp8DJ4hvubUu8rQiUcpllk5EWeU8cCgnnsBH8H0anBgJjQtH/nHEKt3HkLud1mw
         1fzL+FxGxC0l+c99e25hTokFyZl0dOMDKlabW4bThItiYL4zqCUirE+3rLk3CSk73Nwo
         NlhENyIvkFdUYX1CPdFZ3eoQ+CX8qCuIDh9mzdA5AJgw8NWusOSGelOiccWr/7hEPMxQ
         kJf0jQFNe7MR6q0bytpvaiYNqaPINqovpDEITvLld++7Ou1gX7JVWqgSeaVyXJGCAJEr
         5oGw==
X-Gm-Message-State: APjAAAU8cKZqLIeUXNxC6GMkB7Vw4i8CRltl4njLKhxtwq1cXsDNrF/v
        Jhcg6sxrHhlbkeAiDmlM8KYnESqLrzadTp6iWAE2Yg==
X-Google-Smtp-Source: APXvYqyhleoAdX565uQ6xxDGStKu19Q1bSx7tU5fBGlRoqZYCKlU8fKHxrwKIc1CJhFHh9RKbpp/OZAcrdvyVn75mCU=
X-Received: by 2002:a02:b01c:: with SMTP id p28mr2849778jah.130.1559229195998;
 Thu, 30 May 2019 08:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com> <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au> <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au> <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com> <AM6PR09MB3523A665C9D9334659F05F90D2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523A665C9D9334659F05F90D2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 17:13:03 +0200
Message-ID: <CAKv+Gu-5VvJpgECttU-JRSJDZc_WUvVpw1e4BFq4dQu3EHKu+w@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 May 2019 at 16:53, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> >
> > This might work:
> >
> > diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> > index c0ece44f303b..3d313d2a279a 100644
> > --- a/drivers/crypto/caam/caamalg.c
> > +++ b/drivers/crypto/caam/caamalg.c
> > @@ -1661,7 +1661,8 @@ static int aead_decrypt(struct aead_request *req)
> >   * allocate and map the skcipher extended descriptor for skcipher
> >   */
> >  static struct skcipher_edesc *skcipher_edesc_alloc(struct
> > skcipher_request *req,
> > -                                                  int desc_bytes)
> > +                                                  int desc_bytes,
> > +                                                  u8 const *input_iv)
> >  {
> >         struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
> >         struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
> > @@ -1745,7 +1746,7 @@ static struct skcipher_edesc
> > *skcipher_edesc_alloc(struct skcipher_request *req,
> >         /* Make sure IV is located in a DMAable area */
> >         if (ivsize) {
> >                 iv = (u8 *)edesc->hw_desc + desc_bytes + sec4_sg_bytes;
> > -               memcpy(iv, req->iv, ivsize);
> > +               memcpy(iv, input_iv, ivsize);
> >
> >                 iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_TO_DEVICE);
> >                 if (dma_mapping_error(jrdev, iv_dma)) {
> > @@ -1801,7 +1802,8 @@ static int skcipher_encrypt(struct skcipher_request
> > *req)
> >         int ret = 0;
> >
> >         /* allocate extended descriptor */
> > -       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
> > +       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ,
> > +                                    req->iv);
> >         if (IS_ERR(edesc))
> >                 return PTR_ERR(edesc);
> >
> > @@ -1832,13 +1834,11 @@ static int skcipher_decrypt(struct
> > skcipher_request *req)
> >         struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
> >         int ivsize = crypto_skcipher_ivsize(skcipher);
> >         struct device *jrdev = ctx->jrdev;
> > +       u8 in_iv[AES_BLOCK_SIZE];
> >         u32 *desc;
> >         int ret = 0;
> >
> > -       /* allocate extended descriptor */
> > -       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
> > -       if (IS_ERR(edesc))
> > -               return PTR_ERR(edesc);
> > +       memcpy(in_iv, req->iv, ivsize);
> >
> >         /*
> >          * The crypto API expects us to set the IV (req->iv) to the last
> > @@ -1848,6 +1848,11 @@ static int skcipher_decrypt(struct skcipher_request
> > *req)
> >                 scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen
> > -
> >                                          ivsize, ivsize, 0);
> >
> > +       /* allocate extended descriptor */
> > +       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ,
> > in_iv);
> > +       if (IS_ERR(edesc))
> > +               return PTR_ERR(edesc);
> > +
> >         /* Create and submit job descriptor*/
> >         init_skcipher_job(req, edesc, false);
> >         desc = edesc->hw_desc;
>
> Interesting. This discussion made me reevaluate my own implementation.
>
> First thing I realised is that I *am* currently doing the IV copying with
> the data buffer mapped for DMA ... If I understand correctly that may be a
> bad idea on some systems? I which case I will need to do my copy earlier.
>

Yes, this may break on non-coherent systems, since the DMA layer does
not expect cachelines covering the mapped region to enter the dirty
state while the mapping is active. DMA unmap does a clean+invalidate
to make the data written to main memory by the device visible to the
CPU, and it does not expect the 'clean' part of that operation to
result in any writebacks. If such a writeback does occur, it does so
at cacheline granularity, therefore potentially overwriting some data
that was just written by the device.

> Second thing is the above implementation made me realise I don't need to
> buffer the IV as part of the skcipher_request_ctx, I can just copy the
> original req->iv to some local variable, pass a pointer to that along and
> then overwrite req->iv directly. More elegant and hopefully also more
> efficient ...
>
