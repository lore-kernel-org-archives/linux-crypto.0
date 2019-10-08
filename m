Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1971BC10F14
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 05:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3A920679
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 05:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GV/YRLgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfJHF4O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 01:56:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34462 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbfJHF4O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 01:56:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id j11so12012146wrp.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 22:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CyhBbLmeK5xzDBgrxXVgEMsiGq2PjuzaKHLJnIcb92w=;
        b=GV/YRLgngCmpXVyQGuufwjJShaTqtiVomDfYfWmPfFAnm3ZcgRBQcLxlU/EsIGpHra
         1W9fbLcuQfKn8wZwmYqxWlHhUkkt7qoFLsidtApAI6gGOu+SutoIV0drDMHIycDyatHm
         A6ktypX/9sSHU9Si6x6/PmLH70zkGL3sCZTNKM6rrpp0h6DOOO6l9iYJ/h6bUNKRhfm9
         7cPdPehnw5mu0NIKp1saVLOYRo3c5b/SGWP3W41deSlTUAfjjt+Rocw3YQtuFY0qDrwc
         /sCn3jT3bc0H4JBjiguYlj0DGLgoJOKAs9tz0KQ62jjVN4AwQZ1QRjVcRuReTVpxYqxs
         6vrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CyhBbLmeK5xzDBgrxXVgEMsiGq2PjuzaKHLJnIcb92w=;
        b=eu5hVDCUNCtBUcHV9MXpDaTjzqfpUxs/XYOAJLcm3QGNyzj5zkPTANgAgiQvFTy9x7
         DGEn3Imr6gr+iFsWrqGw+lrmQxSwAJDm+Fs2VKwl9ivE1svjqpaGfMH0AiWV3lGhM18U
         2NMgruDjhX4y5rdKO45yekUQ07suQnuJ1gYmE60tvVFs5gdQ00rxpfFCILckK34VYto4
         uTbqOkfFnwapZfS38ZlT0hA9D4WGq0pYMt7Vog5xnghZKgRWmGW0Eetfj4cXlYGpE62e
         lxNz8nnXHE306R89za3IqK/Yp25ch2pSsbH5zgGBgLRpa2m03dpYB630NGvhRNaB1xbA
         y8zQ==
X-Gm-Message-State: APjAAAVAilgVoCcp02qnvYXsipjmmWHq2prSnNrLrLTLyuKNRQOKuQ1X
        w1PwGTpj8bua/LdFeYEi0htI52LswjypteooY86CVQ==
X-Google-Smtp-Source: APXvYqxOyWKQI2w7Gw3bmPlUOnz9DnpvZiHmXuW9MAxiMKTfIEvwxUZkDuQ/UFRLi6IHjn/Ib4iSj4/oQLyBKMxLpoQ=
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr24800509wrn.200.1570514170913;
 Mon, 07 Oct 2019 22:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org> <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
In-Reply-To: <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 8 Oct 2019 07:55:58 +0200
Message-ID: <CAKv+Gu-NN-0p=xNfXPf7bQkOYio4uRXqLpjj+c--ctJ3JX9qhQ@mail.gmail.com>
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Andy Polyakov <appro@cryptogams.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 7 Oct 2019 at 23:02, Ren=C3=A9 van Dorst <opensource@vdorst.com> wr=
ote:
>
> Quoting Ard Biesheuvel <ard.biesheuvel@linaro.org>:
>
> > This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305 implementa=
tion
> > for MIPS authored by Andy Polyakov, and contributed by him to the OpenS=
SL
> > project. The file 'poly1305-mips.pl' is taken straight from this upstre=
am
> > GitHub repository [0] at commit 57c3a63be70b4f68b9eec1b043164ea790db649=
9,
> > and already contains all the changes required to build it as part of a
> > Linux kernel module.
> >
> > [0] https://github.com/dot-asm/cryptogams
> >
> > Co-developed-by: Andy Polyakov <appro@cryptogams.org>
> > Signed-off-by: Andy Polyakov <appro@cryptogams.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/mips/crypto/Makefile         |   14 +
> >  arch/mips/crypto/poly1305-glue.c  |  203 ++++
> >  arch/mips/crypto/poly1305-mips.pl | 1246 ++++++++++++++++++++
> >  crypto/Kconfig                    |    6 +
> >  4 files changed, 1469 insertions(+)
> >
> > <snip>
>
> Hi Ard,
>
> Is it also an option to include my mip32r2 optimized poly1305 version?
>
> Below the results which shows a good improvement over the Andy
> Polyakov version.
> I swapped the poly1305 assembly file and rename the function to
> <func_name>_mips
> Full WireGuard source with the changes [0]
>
> bytes |  RvD | openssl | delta | delta / openssl
>      0 |  155 |   168   |   -13 |  -7,74%
>      1 |  260 |   283   |   -23 |  -8,13%
>     16 |  215 |   236   |   -21 |  -8,90%
>     64 |  321 |   373   |   -52 | -13,94%
>    576 | 1440 |  1813   |  -373 | -20,57%
>   1280 | 2987 |  3801   |  -814 | -21,42%
>   1408 | 3268 |  4161   |  -893 | -21,46%
>   1420 | 3362 |  4267   |  -905 | -21,21%
>   1440 | 3337 |  4250   |  -913 | -21,48%
>   1536 | 3545 |  4531   |  -986 | -21,76%
>   4096 | 9160 | 11755   | -2595 | -22,08%
>

Hi Ren=C3=A9,

I agree that, given these numbers, we should definitely switch to your
code when building for 32r2 specifically. I'll incorporate that for
the next revision.
