Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645E8C28CC0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 22:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367AE24274
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 22:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MZcUvU4v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfE2WQa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 18:16:30 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:54787 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbfE2WQ3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 18:16:29 -0400
Received: by mail-it1-f196.google.com with SMTP id h20so6693404itk.4
        for <linux-crypto@vger.kernel.org>; Wed, 29 May 2019 15:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ed0vURi/joGtHA39ANyyCu3gvTMdDH/9prysCiHmBvY=;
        b=MZcUvU4vKeGgnexxMzFd2jS7IXVoW5E+4bMd7wKlVhoAV2EdkFfMc1DX6I9c9KWh7I
         XmXuU/iFxU/PQZTnpachL+VVlCxE3tM20GTz1k4ZaptUSiTmcSJsf/JJV2Mz2w3BPHW8
         rAJPDmzH0ORf4dFBjxfM3l3CtIIW6Fd6LlPSI3ztJLZpC5M0nfbaKGUtXivG9YmitHtc
         eD4ZxyJ+oo5+4UbW6iNdQPrFmo/nbWZItc4QVuTTMSyXLL/fq4HbM3AgpeV6vf4MrLmf
         WfF6yD/k900b/BWFTA6j+4gMl50hcPl2GR5wJySByKLYny+Hww1Z2zoSRSTFQFK5p1I1
         LdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ed0vURi/joGtHA39ANyyCu3gvTMdDH/9prysCiHmBvY=;
        b=InkZP0Fq+7nx0+N8C7uLOk+p/ipxVwMm1EaUbt882O00hRwF8BEabrE+vi0me3yPSR
         ZVPlV2A3IhYu8EZIiY+bnKL4uNt0BgTKE2FAumVIhi8d+UgiwMDwmO156gIwVxp+v0CM
         4TwLtbUrIXPOSx8Fu+ILNx8BPjEw+/QTuogCdw96C7oeuQo58CRSngxoQdxHgETcanKh
         WldLsUFg+lE3Lw65sCE9Ox4WMEat0iXR+ZDJjJx3dCYsh7MoKR69TCXae2ObR+DYMSCy
         2o4NzuVdO4DXF2FeKijkvH4pWeLK5nBV1QFUaXDiXFuBgx+jbMZw+qWP1ovnO4JdUUz5
         hOqA==
X-Gm-Message-State: APjAAAXw8o2PNq6ErwbtSGSVTM36zx54SCMNSj5EYoaVnT67dUTtaS0z
        jfMmJJ8zV68ilJ2Y81R6xSFYR9/NJYrh6b+FNU6wkQ==
X-Google-Smtp-Source: APXvYqwSKGnB5ubtPWG6xZhaEHH5GE9VMvo3u8DHRWqobNOYdqbQMOp4/O6IMFG0cGCTxFiTd/m2e8PFFudHg6vptWM=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr460724itg.104.1559168189120;
 Wed, 29 May 2019 15:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com> <20190529202728.GA35103@gmail.com>
In-Reply-To: <20190529202728.GA35103@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 00:16:16 +0200
Message-ID: <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 29 May 2019 at 22:27, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 29, 2019 at 08:10:56PM +0300, Iuliana Prodan wrote:
> > The generic GCM driver should ensure that whatever it passes into
> > scatterlists is safe for non-cache coherent DMA.
> > The issue was seen while running GCM on CAAM driver. But, since CAAM
> > does not support GHASH on i.MX6, only CTR skcipher part of the GCM is
> > offloaded.
> > The skcipher request received by CAAM has req->src pointing to
> > auth_tag[16] and req->iv pointing to iv[16]. Problem is that when
> > the iv is updated (crypto API requires skcipher implementations to
> > update the IV with the last ciphertext block) is written in iv[16],
> > which is on the same cacheline as auth_tag[16] that was previously
> > DMA mapped.
> > Solution is to use a pointer, aligned to cache line, instead of auth_tag
> > buffer, for encryption/decryption and then free it on completion.
> >
> > Link: https://lore.kernel.org/linux-crypto/20190208114459.5nixe76xmmkhur75@gondor.apana.org.au/
> > Cc: <stable@vger.kernel.org> # v4.19+
> > Fixes: adcbc688fe2f ("crypto: gcm - Convert to new AEAD interface")
> > Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> >
...
> So what about the other places that also pass an IV located next to the data,
> like crypto/ccm.c and crypto/adiantum.c?  If we're actually going to make this a
> new API requirement, then we need to add a debugging option that makes the API
> detect this violation so that the other places can be fixed too.
>
> Also, doing a kmalloc() per requset is inefficient and very error-prone.  In
> fact there are at least 3 bugs here: (1) not checking the return value, (2)
> incorrectly using GFP_KERNEL when it may be atomic context, and (3) not always
> freeing the memory.  Why not use cacheline-aligned memory within the request
> context, so that a separate kmalloc() isn't needed?
>
> Also, did you consider whether there's any way to make the crypto API handle
> this automatically, so that all the individual users don't have to?
>

Reading back that old thread, it appears that the core issue is that
the IV is copied when the scatterlist is already mapped for DMA. This
means the cacheline covering the IV and the auth tag is dirty while
the non-coherent DMA transaction takes place, and given that we clean
rather than invalidate the start and end of DMA mappings if they are
not aligned to the cache writeback granule size, whatever sits in the
cacheline overwrites whatever the device wrote in there.

Iuliana, did you try pulling the IV copy forward? I.e.,

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c0ece44f303b..11e91c0c9a96 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1835,11 +1835,6 @@ static int skcipher_decrypt(struct skcipher_request *req)
        u32 *desc;
        int ret = 0;

-       /* allocate extended descriptor */
-       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
-       if (IS_ERR(edesc))
-               return PTR_ERR(edesc);
-
        /*
         * The crypto API expects us to set the IV (req->iv) to the last
         * ciphertext block.
@@ -1848,6 +1843,11 @@ static int skcipher_decrypt(struct skcipher_request *req)
                scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
                                         ivsize, ivsize, 0);

+       /* allocate extended descriptor */
+       edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
+       if (IS_ERR(edesc))
+               return PTR_ERR(edesc);
+
        /* Create and submit job descriptor*/
        init_skcipher_job(req, edesc, false);
        desc = edesc->hw_desc;

This should ensure that the cacheline is cleaned when the DMA mapping
is created.
