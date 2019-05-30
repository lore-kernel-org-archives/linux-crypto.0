Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5069DC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2576A25ADB
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfE3O1r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 10:27:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38382 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfE3O1r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 10:27:47 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWM1u-0006i2-9X; Thu, 30 May 2019 22:27:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWM1m-000474-6D; Thu, 30 May 2019 22:27:34 +0800
Date:   Thu, 30 May 2019 22:27:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
Message-ID: <20190530142734.qlhgzeal22zxfhk5@gondor.apana.org.au>
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com>
 <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au>
 <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <CAKv+Gu-jTWQP0Zp=QpuzX41v8Eb5Bvd0O9ajwSnFkDO-ijBf_A@mail.gmail.com>
 <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9JoC+GKJ6mMAE25mr_k2gbznh-83jApT4=FZsAW=jd8w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 30, 2019 at 03:55:07PM +0200, Ard Biesheuvel wrote:
>
> > Would this work?

I see.  You need to preserve the original IV.

> > diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> > index c0ece44f303b..2ef2f76a3cb8 100644
> > --- a/drivers/crypto/caam/caamalg.c
> > +++ b/drivers/crypto/caam/caamalg.c
> > @@ -1832,22 +1832,25 @@ static int skcipher_decrypt(struct
> > skcipher_request *req)
> >         struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
> >         int ivsize = crypto_skcipher_ivsize(skcipher);
> >         struct device *jrdev = ctx->jrdev;
> > +       u8 out_iv[AES_BLOCK_SIZE];
> >         u32 *desc;
> >         int ret = 0;
> >
> > -       /* allocate extended descriptor */
> > -       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
> > -       if (IS_ERR(edesc))
> > -               return PTR_ERR(edesc);
> > -
> >         /*
> >          * The crypto API expects us to set the IV (req->iv) to the last
> >          * ciphertext block.
> >          */
> >         if (ivsize)
> > -               scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
> > +               scatterwalk_map_and_copy(out_iv, req->src, req->cryptlen -
> >                                          ivsize, ivsize, 0);
> >
> > +       /* allocate extended descriptor */
> > +       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
> > +       if (IS_ERR(edesc))
> > +               return PTR_ERR(edesc);
> > +
> > +       memcpy(req->iv, out_iv, ivsize);
> > +
> >         /* Create and submit job descriptor*/
> >         init_skcipher_job(req, edesc, false);
> >         desc = edesc->hw_desc;
> 
> Umm never mind
> 
> /me hides in shame

So why doesn't this work?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
