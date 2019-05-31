Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A007CC04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 14:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7071126AA4
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 14:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="id5zSz0z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfEaO34 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 10:29:56 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:38172 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfEaO3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 10:29:55 -0400
Received: by mail-it1-f194.google.com with SMTP id h9so1385255itk.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 May 2019 07:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhU2mOPoFLwGA2dOvDV8attpdhaq15eRfh1ymXW+2tY=;
        b=id5zSz0zQXoYHEWjEZTJQ5GIS/tjA6keKA79RRGHOersZjuUkEcIV6yQlwYaIXp7i4
         AUxbwBsXGAOUOQiP2GTyJ+a9caIN29GjZsDdnCuH/DNJ3C2muxi8bYFBKL3XHRmC2ATD
         5eGjQab/czc+uuIMHnbs3ygTH849tyhnptQzET29pGVgWZDtEFoOshlk0PqWtWYlhxbU
         96qrICrdrS32cefsRc1CFZMAdzlUY+O5SCNfi0ze+SSBz+4IBj7X3Kg7SdhU9JKZEM5J
         13kYxPUsisCunDgmwCRnw0v1h6W2PbyTpb3CbiqNn5xzIBthtfgvlcmqt6LDxljrAzjy
         Ah+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhU2mOPoFLwGA2dOvDV8attpdhaq15eRfh1ymXW+2tY=;
        b=FQEe294lMyP/9DgAXhdrrh2IybISvZGJzIyXmtqOY6OkdGpA9+3uMA7MoGY8zddDo1
         ypxLYCZA/bDqsb+G4V5LePFC6VXPnz98YbVQLYLe+noEIEg3CXlC40ir9g8ApiKf59n6
         zKVMfFMwKCqgZJsJ6rjqPXoCCeiNZW88h8T+ZebjzOFMwHF8qLaJJBI2X94mzwWHlCRv
         SgN1PwN1KS0zwp89/FxqwUsZHa9l56mhIwkzFo+8hwHeXZAoNjKHFy33VkIAbk1qxsvK
         LD7saixoO3CmSl9Knqh6iYOYQf0ElcWWJfGIP+BUNXrImEWLyBynBBgBY/OA6UMIkApZ
         MwKg==
X-Gm-Message-State: APjAAAWSMcqQzGs2sbNQC8TRbMWo6/N08cSc3WYLksi08iAHKTg1qeLc
        dZ6vLRF7WErC0ai/xnB1RKU9HvHTtXam6kimP+FP02CY
X-Google-Smtp-Source: APXvYqzCCB094jX2Vz7Y7xqjyjsJ+NPteYMrow9ibyZEwWVZBMDKaeS3vf6FZEUURp1by+nVSmQIvMjUNrsRYG8f/2c=
X-Received: by 2002:a24:1614:: with SMTP id a20mr6828380ita.153.1559312994839;
 Fri, 31 May 2019 07:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190531081306.30359-1-ard.biesheuvel@linaro.org> <VI1PR0402MB348583A318B3AD13881745E198190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348583A318B3AD13881745E198190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 31 May 2019 16:29:42 +0200
Message-ID: <CAKv+Gu8r5gF24hCDDppjvDsPFgoqOHFNgWZ2VG0mMeg3ggo8_A@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - limit output IV to CBC to work around CTR
 mode DMA issue
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 31 May 2019 at 16:21, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 5/31/2019 11:14 AM, Ard Biesheuvel wrote:
> > The CAAM driver currently violates an undocumented and slightly
> > controversial requirement imposed by the crypto stack that a buffer
> > referred to by the request structure via its virtual address may not
> > be modified while any scatterlists passed via the same request
> > structure are mapped for inbound DMA.
> >
> IMO this requirement developed while discussing current issue,
> it did not exist a priori.
>

I won't argue with that.

> > This may result in errors like
> >
> >   alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
> >   alg: aead: Failed to load transform for gcm(aes): -2
> >
> > on non-cache coherent systems, due to the fact that the GCM driver
> > passes an IV buffer by virtual address which shares a cacheline with
> > the auth_tag buffer passed via a scatterlist, resulting in corruption
> > of the auth_tag when the IV is updated while the DMA mapping is live.
> >
> > Since the IV that is returned to the caller is only valid for CBC mode,
> > and given that the in-kernel users of CBC (such as CTS) don't trigger the
> > same issue as the GCM driver, let's just disable the output IV generation
> > for all modes except CBC for the time being.
> >
> > Cc: Horia Geanta <horia.geanta@nxp.com>
> > Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> > Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Link: https://lore.kernel.org/linux-crypto/1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com/
> Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
>
> Unfortunately this does not apply cleanly to -stable, I'll send a backport
> once it hits mainline.
>

Thanks.
