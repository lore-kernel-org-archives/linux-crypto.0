Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C3AC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 08:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B7820720
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 08:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593677557;
	bh=LuyrR1JHUg9VesjG9zPrRg3I1TEzpQxtQPBMNUD2YXI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=F5FUid8wqYeAjgc5A5Y0SRxdAWxGft6YmAL2Z1kr9YIPbrbPKoKvRXm0gT0Bwm6/2
	 PwqGLQfF+wWBI4nBE41ThyceKMeWKsYEOadq4gLv+9UPF92tj07OxUzNy9ijclnK8z
	 TEpJrHPXIiVJOTrVc5IH9WOPC3X54AwvS7nhokW0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgGBIMg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgGBIMg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 04:12:36 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E836D20720
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2020 08:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593677556;
        bh=LuyrR1JHUg9VesjG9zPrRg3I1TEzpQxtQPBMNUD2YXI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UDrxkpvoEAdcw5M/7RyEBHR3r6+ydsZth6dnWyuOcTwSWp22lXKlnzkMhjJHNxoNJ
         Cww/uD3o8vYCZ9Dv3Dkl8sildQ2z9KQQHKdtOayBQtpE1Y6V1OioC4rj6PLXWEYZey
         63cAskwcYocsB559XNk7Y2KusCEr4yp77NhvLUjI=
Received: by mail-ot1-f53.google.com with SMTP id n24so21275850otr.13
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2020 01:12:35 -0700 (PDT)
X-Gm-Message-State: AOAM533ycTbqy9+6RlCIgGnEqCYJ6T9EhHoGk58faAXK1RfJV9DKing2
        sLYeAZ/MfGEAsY7M97wOB6UBvlgcySCfC+RkgTQ=
X-Google-Smtp-Source: ABdhPJz3i8Sjuqice7C4nqWeC5CQn9vd4ZIldyMAaK1GpujJm94fLxnhySVxDbHIEdPUnV486Y5DHyvCPubrjM302K0=
X-Received: by 2002:a9d:688:: with SMTP id 8mr25685726otx.108.1593677555286;
 Thu, 02 Jul 2020 01:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au> <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
 <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
 <CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com>
 <20200702074533.GC4253@gondor.apana.org.au> <CAMj1kXHT9Puv2tC4_J2kVMjSF5es_9k+URVwsvao6TReS_5aJA@mail.gmail.com>
 <20200702075616.GA4394@gondor.apana.org.au> <20200702080045.GA4472@gondor.apana.org.au>
In-Reply-To: <20200702080045.GA4472@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 2 Jul 2020 10:12:24 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEgGOihAm_cYjs2_FaTn2KiSh-g3VroTm6Z=SZdG=Jr7g@mail.gmail.com>
Message-ID: <CAMj1kXEgGOihAm_cYjs2_FaTn2KiSh-g3VroTm6Z=SZdG=Jr7g@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Jul 2020 at 09:56, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 02, 2020 at 09:51:29AM +0200, Ard Biesheuvel wrote:
> >
> > I'll wait for the code to be posted (please put me on cc), but my
>
> Sure I will.
>
> > suspicion is that carrying opaque state like that is going to bite us
> > down the road.
>
> Well it's only going to be arc4 at first, where it's definitely
> an improvement over modifying the tfm context in encrypt/decrypt.
>

I agree that the current approach is flawed, but starting multiple
requests with the same state essentially comes down to IV reuse in a
stream cipher, which will cause it to fail catastrophically.
(ciphertext1 ^ ciphertext2 == plaintext1 ^ plaintext2)

I wonder if we should simply try to get rid of arc4 in the crypto API,
as you suggested. There are a couple of WEP implementations that could
be switched over to the library interface, and the KerberosV
implementation of RC4-HMAC(md5) was added for Windows 2000
compatibility based on RFC 4757 [0], which was deprecated by RFC 8429
[1], since Windows Domain Controllers running Windows Server 2008r2 or
later can use newer algorithms.

[0] https://tools.ietf.org/html/rfc4757
[1] https://tools.ietf.org/html/rfc8429


>
> On Thu, Jul 02, 2020 at 05:56:16PM +1000, Herbert Xu wrote:
> >
> > For XTS I haven't decided whether to go this way or not.  If it
> > does work out though we could even extend it to AEAD.
>
> But there is clearly a need for this functionality, and it's
> not just af_alg.  Have a look at net/sunrpc/auth_gss/gss_krb5_crypto.c,
> it has three versions of the same crypto code (arc4, cts, and
> everything else), in order to deal with continuing requests just
> like algif_skcipher.
>
> Perhaps at the end of this we could distill it down to just one.
>

I agree that there is a gap here.

Perhaps we can decouple ARC4 from the other cases? ARC4 is too quirky
and irrelevant to model this on top of, I think.
