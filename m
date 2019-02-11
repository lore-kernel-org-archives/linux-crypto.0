Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B976AC282D7
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 17:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DE42229E
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 17:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DS8fHmlh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfBKR2t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:28:49 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:35594 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbfBKR2t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 12:28:49 -0500
Received: by mail-it1-f194.google.com with SMTP id v72so163325itc.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Feb 2019 09:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hEOQzzk4xnw1lE439NKJnWZB7JJxP/JEAS97OWrd7Bc=;
        b=DS8fHmlhSXAAvqpjlp0ayzobhAQKtGtmYEreN8xQxhSHHmmk9urSf2hsOWDykFwcpN
         q0c7Hu3hjtO59OmhUi1FQZrAfGCJ8mZITMFDNAUjT7vmDqiPEA+dmBa9IUs7+qoq7pWZ
         tGqePf2chzEuDb/wUAcOWg//Oemo5+qs4gOqIpFlBj1PL4mKFAmOulnijWkf1U/nR5h1
         Qq/Kg9tJNaklkaEwvkv6pWhYJtBWWSUW641ebmdSjh+cw47pZGXuvVVCUEBysiqY9Ovy
         3bALWl1F67LMmP3g8QQoEsI5tr4+XSeSzXDTH7c3ZbSBCrGylkF/sc//riXuZyECPQwl
         tj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEOQzzk4xnw1lE439NKJnWZB7JJxP/JEAS97OWrd7Bc=;
        b=B5O8yWaFJqMTd9ghBqeUdKWwux8DWzklw0Ylb4TekNjXc1XwLAdSkq+penVuXGx40U
         pYC9kdUhUU2pI1ZiSPidehk3j/eyhQpqBjDQuDtEWjcGG2ZBVrsGk2FD8cJRdKyURp+u
         Yyn+z/VZGTNuKWTas5Sb7FQBREaEs2+mTmhEvGVi3tIHalt1pnh36mmK9w6T7/R80W4I
         Iw9xxGIKT9OvTP/hZfu5vyl7pFU55FmTnj7u1lLrWTMt8JTLLfE8y4cs5TivWmR9B2CZ
         dTLmpCC+vQWRYD/WRkRLWif9SxuywDpXY55LAMS6dTcgZ3ucEpGsmNNWgipxehKPlkxw
         HjcQ==
X-Gm-Message-State: AHQUAuaAsy6/P9TcOSEWS5Z5UHBoy9D3okrFI5uzZyqplJwopYIE7Wu/
        vQ0a65zpjSfPTbx5TeeGaVknmCt3tOntRWJnDPdJKEkl
X-Google-Smtp-Source: AHgI3Ia9g/7W11Utn2LXM5hualOGABBWud2tI2d7ZSqzsfo2IrZA34h0QB5bvV8JYLCsNh/N77ifNS29Brp9Qntb73c=
X-Received: by 2002:a24:4582:: with SMTP id c2mr388915itd.158.1549906128564;
 Mon, 11 Feb 2019 09:28:48 -0800 (PST)
MIME-Version: 1.0
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au> <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208114532.5yznhgeq6m6gh5fo@gondor.apana.org.au> <VI1PR0402MB34851754919DFF6FD0FDA57D98640@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34851754919DFF6FD0FDA57D98640@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 11 Feb 2019 18:28:36 +0100
Message-ID: <CAKv+Gu9nzpefv=TVh23dqk6etgvZS_KUfHsaJ=hjwwtjckT8Gw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 11 Feb 2019 at 16:13, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 2/8/2019 1:45 PM, Herbert Xu wrote:
> > On Fri, Feb 08, 2019 at 08:41:37AM +0000, Horia Geanta wrote:
> >>
> >> So if there is a real intention to support offloading skcipher, as this old
> >> commit suggests:
> >>
> >> 84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")
> >>     This patch adds the necessary changes for GCM to be used with async
> >>     ciphers.  This would allow it to be used with hardware devices that
> >>     support CTR.
> >>
> >> then we must take special care when building skcipher req->src and avoid having
> >> it's first entry (auth_tag[16] in crypto_gcm_req_priv_ctx structure) sharing a
> >> cache line with req->iv.
> >
> > Could you prepare a patch for this?
> >
> Yes, will do.
>
> Note that I am seeing the same issue on CCM.
>
> Also for GCM, besides auth_tag there is iauth_tag[16] buffer that is added in a
> 1-entry S/G in gcm_hash_len():
>         sg_init_one(&pctx->sg, pctx->iauth_tag, 16);
>

Yes, but I suppose the issue only occurs when writing data from the
device, no? AFAICT, iauth_tag[] is passed into the device but never
updated by it.

> It looks like there other places where this happens, for e.g. "tail" member of
> poly_req (crypto/cacha20poly1305.c) in poly_tail():
>         sg_set_buf(preq->src, &preq->tail, sizeof(preq->tail));
>

Same here. If it never occurs in the destination of the scatterlist,
it should be safe for non-cache coherent DMA (since DMA to the device
does not involve cache invalidation)

However, it would be nice if we could test this in some way ...
