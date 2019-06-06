Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5A4C28D19
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA3820868
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y2RWECTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfFFGnJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:43:09 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:53550 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFGnB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:43:01 -0400
Received: by mail-it1-f195.google.com with SMTP id m187so1502115ite.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Jun 2019 23:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fAmwhrw558wPfYHxjN+8HYUKXtrdMSbO0EAw2Cpf0/Y=;
        b=Y2RWECTNdkv+bdqw56t/foazdmSKW9C7UxFQGxElH4MDqQBFAo0IvyTHLt9KdqZg1X
         Q/QIt1+bxXD+WNT5G3hLKNVmPxusK2ThjQQJ9BxejHuN0tvOTSu3/UHYf/4JfxMpEKME
         65oaStHZ6AKM/54UQy6jDVNNsG5GKYIwb6vbkowvq7TtLf6k+ib4vBSoHlXOMC8U7gPR
         DqAoyLvIebgUjw1Xu5iVpyp7QMPNRJvk2iJID9gxT1F+hKuCZPvz+ncNiAQWwmADxY7Z
         ACC5BZ9iMQD148kDb59+r9Rc23mHRrpir2NUmfLhL6EY4cD9GExP80lO3aVxaKDjA37A
         iAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fAmwhrw558wPfYHxjN+8HYUKXtrdMSbO0EAw2Cpf0/Y=;
        b=R52iAXWYXfZICCN0TjI3bFzXc+QpJoLxKefuFN95uUwYFDq/nhON1DScxIvB5VDEZD
         OzecQ4fBa1DmrOsupbtSxWrcBqbSs9dSPHbawUgLJiZmRz2okXPYZSvYrzS0T/O4Nv4i
         FGCNZvit+rftFslKLUakJELTz7DXhfZGHFBZ6CUJMUOg3ry3HS0JQW5PXtrTgf7S4p+H
         kWv+2iW3m4pHboiAW9rEiJosa3YstUKaCKei4xoQVDFYGp+0FZVcTVJ17vYOlPFadNGO
         aFe9t1e+JLxa+BfH9nr+YVdlPdt8kzf8Mf6KqmP9jJRbapz6B+c6G5DXtZRBKZ54C6qb
         USjQ==
X-Gm-Message-State: APjAAAXbOut0yCoQpLtftG7Lq2nzWAjYqWRfhoxcg7ZYxidGTrAiNmXA
        LZI3FgQ9Pq29r5K+9M7FslM4SUxFLCSs7cbHrGulVg==
X-Google-Smtp-Source: APXvYqz86e78yfLOLdlh1MV/pnoTIXiTUppGfvfKOxeaUm9ISXwFavbNpBwij9JySv01+d6Iq8N/vHDVsb8dioEsUfY=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr29258959jar.2.1559803380499;
 Wed, 05 Jun 2019 23:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190529202728.GA35103@gmail.com> <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au> <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au> <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com> <20190606063724.n77z7gaf32tmyxng@gondor.apana.org.au>
In-Reply-To: <20190606063724.n77z7gaf32tmyxng@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Jun 2019 08:42:46 +0200
Message-ID: <CAKv+Gu-YtKRsUYMMD_PNoFvrPpmwTD7fJNs64Q-34L8-TvucqA@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
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

On Thu, 6 Jun 2019 at 08:37, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, May 30, 2019 at 04:31:09PM +0200, Ard Biesheuvel wrote:
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
>
> Hi Ard:
>
> I presume you will be submitting this patch at some point?  When
> you do please base it on top of your other one which I'm about to
> merge.
>

I'm not sure I follow. Do you want a better fix for the CBC output IV
going forward? Or is this about other modes?
