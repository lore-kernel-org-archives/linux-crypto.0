Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7836C28D1B
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFBD1207E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CVnld91Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbfFFGxY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:53:24 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35649 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfFFGxY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:53:24 -0400
Received: by mail-it1-f196.google.com with SMTP id n189so1494269itd.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Jun 2019 23:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IeWfpZT2bFu7Dyu6HFjhOwPn1OYpekVmcZCpvqk6qKA=;
        b=CVnld91YvVoVvgxrQghCO6cF6OrC6trSC4vE53CvvCJjcSY/x/Hx3em6U42Eo3F1hf
         tUxVAkOnnbCMfJIaFQ3lUeffMZO+TA5t9VHjNIuCRHFDG1IEFw70uBUAnJj0Pbzni5TG
         SbjuI/PYh9gcfUE1/wsKnl8NOq3d/F/asB95k4A19DAQ2Q0M5gj0AEa9ET9mppwEdGpv
         x/JfcIu13/Hi2LlQ+HVhKMddC67BfZgLidKsdaqwALvH/UBHwZxi1DDINIaOgtG6WtEv
         79TxzsMn6BO3bQiUSh1l9ffQbxPv4d/fZVoQkde22GnVoTctrgEudKXMdyGduDC1jK8H
         tO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IeWfpZT2bFu7Dyu6HFjhOwPn1OYpekVmcZCpvqk6qKA=;
        b=NXciyKIBp4GDIz6vDKwo8acLSbHwrHtj4RdaKA9kVRiQh0MgN8FmQVraiNprzRBo16
         oESdqMshfZxhk74ujeUyka8V1uzZe6cta1cEppZ+N7GtilJP9vywc10cBXtEZhpa+wpg
         meoc983jgNimWMRhImpAtNnj7EmFh4EoB2U45SBCagt5nbJzQCrv9842be0tkCjR2YGf
         DXzqE5cSDA/Ux/3qk7kWIyvsmygbV3vjVLSTEaeW2YoywDWo1OcntyI483FmDbUTlKm9
         LdCwfIW6k9YW5wzZBMlvwyOhBdEvRhdvmbg4M7K+aUvsJT8zGRDchOdr3kDyd0N5OEnT
         z4bA==
X-Gm-Message-State: APjAAAU87hAWbh813sn2xbGpYX6zh0n6kA8rIxyBxqD+fE8Qz15V80Yh
        7wTdH6q7eT8fBntgDrzfEjQFdy26DdMys9V3VJZYBA==
X-Google-Smtp-Source: APXvYqyZCVLads/57MgQ4TfPK2w6tD57a5LXkzlkRKl4t86BTh/t9o0DCnL0cKdDZJAERWOA3hu6eG1Vhds84Wqh+0A=
X-Received: by 2002:a24:4f88:: with SMTP id c130mr4314064itb.104.1559804002863;
 Wed, 05 Jun 2019 23:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au> <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
 <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au> <CAKv+Gu8jJQCZwiHFORUJUzRaAizWzBQ95EAgYe36sFrcvzb6vg@mail.gmail.com>
 <CAKv+Gu-KBgiyNY2Dypx6vqtmpTXNfOxxWxJf50BTiF2rCOFqnw@mail.gmail.com>
 <20190606063724.n77z7gaf32tmyxng@gondor.apana.org.au> <CAKv+Gu-YtKRsUYMMD_PNoFvrPpmwTD7fJNs64Q-34L8-TvucqA@mail.gmail.com>
 <20190606064603.lvde6dproqi3vwcq@gondor.apana.org.au>
In-Reply-To: <20190606064603.lvde6dproqi3vwcq@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Jun 2019 08:53:10 +0200
Message-ID: <CAKv+Gu-DokZ179_Gx8_20v_pQ3w_CARKdO0xdsO8CRZJG1uOqA@mail.gmail.com>
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

On Thu, 6 Jun 2019 at 08:46, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 06, 2019 at 08:42:46AM +0200, Ard Biesheuvel wrote:
> > On Thu, 6 Jun 2019 at 08:37, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Thu, May 30, 2019 at 04:31:09PM +0200, Ard Biesheuvel wrote:
> > > >
> > > > This might work:
> > > >
> > > > diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> > > > index c0ece44f303b..3d313d2a279a 100644
> > > > --- a/drivers/crypto/caam/caamalg.c
> > > > +++ b/drivers/crypto/caam/caamalg.c
> > > > @@ -1661,7 +1661,8 @@ static int aead_decrypt(struct aead_request *req)
> > > >   * allocate and map the skcipher extended descriptor for skcipher
> > > >   */
> > > >  static struct skcipher_edesc *skcipher_edesc_alloc(struct
> > > > skcipher_request *req,
> > > > -                                                  int desc_bytes)
> > > > +                                                  int desc_bytes,
> > > > +                                                  u8 const *input_iv)
> > > >  {
> > > >         struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
> > > >         struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
> > > > @@ -1745,7 +1746,7 @@ static struct skcipher_edesc
> > > > *skcipher_edesc_alloc(struct skcipher_request *req,
> > > >         /* Make sure IV is located in a DMAable area */
> > > >         if (ivsize) {
> > > >                 iv = (u8 *)edesc->hw_desc + desc_bytes + sec4_sg_bytes;
> > > > -               memcpy(iv, req->iv, ivsize);
> > > > +               memcpy(iv, input_iv, ivsize);
> > > >
> > > >                 iv_dma = dma_map_single(jrdev, iv, ivsize, DMA_TO_DEVICE);
> > > >                 if (dma_mapping_error(jrdev, iv_dma)) {
> > >
> > > Hi Ard:
> > >
> > > I presume you will be submitting this patch at some point?  When
> > > you do please base it on top of your other one which I'm about to
> > > merge.
> >
> > I'm not sure I follow. Do you want a better fix for the CBC output IV
> > going forward? Or is this about other modes?
>
> You sent me a patch to fix CTR mode:
>
> https://patchwork.kernel.org/patch/10969747/
>

That patch does not fix CTR mode, it just disables copying the output
IV altogether for CTR mode so the DMA corruption does not occur.

> But your suggested fix for CBC mode itself where we need to do the
> copy (as seen quoted above) hasn't been submitted.
>

That same patch 'fixes' CBC, since CBC was never broken to begin with.
The CTS driver does not have something like the auth_tag sharing the
same cacheline with the IV, so CBC has always worked fine.

So I guess what you are after is a patch that, instead of dodging the
issue by limiting the copy to CBC, does not perform the copy at all
while anything is mapped for DMA? Then we can leave it up to the NXP
engineers to fix CTR mode.
