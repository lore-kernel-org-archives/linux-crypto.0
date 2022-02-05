Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2594C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 07:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376677AbiBEH5F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 02:57:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34706 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBEH5C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 02:57:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADFCAB83984
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 07:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F89C340F1
        for <linux-crypto@vger.kernel.org>; Sat,  5 Feb 2022 07:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644047820;
        bh=l8kNEFDmMd28vZeHX+NKHPLjqLXMnmXFmLelanXOy7Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Gyib2ZjAhNiU3o6dRCm7raG3gTwSh1aAIsjKO9hkjbB4GdqJAE9Bx9fHFMxMyoIn+
         x2PDgJYb013qqeccGstMTvU30n5YUWmPOIsStvYdG3gtCdmOqOkAW2Q0Xs2STWqKii
         UfStQ3uRvxP2dVodPv/VENdEy8GxsEFS5wOtFJWBeNvvEWknAXwo9IIhjz8YxaySzL
         AGI+RfWztnautacaROB8gyXH3233OMm41Q9Vgi5Bhkz0asVUd+8bT78gYJ5dKEGxZG
         Z5AtEnQathO13+IupeWHusBosR2IJezU10S4qNQilPwuTshfHQfrF1YWFoJOT1V3eH
         0JXog0n1T6QqQ==
Received: by mail-wm1-f50.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so5686707wmb.1
        for <linux-crypto@vger.kernel.org>; Fri, 04 Feb 2022 23:57:00 -0800 (PST)
X-Gm-Message-State: AOAM531j4h2JLL5TPgJRJpcynMAdvv0CNxZPHndFO+vwy5XIroWC2gJS
        YnfyB6z2MGX/HYH/WcFrWZ6RGlrHIpuTmiIWCiM=
X-Google-Smtp-Source: ABdhPJwP8OpbeQeMJxC5cBXSPb12zT4aq306iyHLAjbsRorHeIwOlMBLn7sjJuVeKXeiubfogUgppoCsKdi5MhoFNrc=
X-Received: by 2002:a05:600c:2b89:: with SMTP id j9mr2026615wmc.190.1644047818675;
 Fri, 04 Feb 2022 23:56:58 -0800 (PST)
MIME-Version: 1.0
References: <20220129224529.76887-1-ardb@kernel.org> <20220129224529.76887-2-ardb@kernel.org>
 <Yf3+NmfUd0GhOm88@gondor.apana.org.au>
In-Reply-To: <Yf3+NmfUd0GhOm88@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 5 Feb 2022 08:56:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGMxTp_Jr_oZUknsM+hCsydTwdsFpdkXJR=Sq4g_E4Sfg@mail.gmail.com>
Message-ID: <CAMj1kXGMxTp_Jr_oZUknsM+hCsydTwdsFpdkXJR=Sq4g_E4Sfg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] lib/xor: make xor prototypes more friendely to
 compiler vectorization
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 5 Feb 2022 at 05:34, Herbert Xu <herbert@gondor.apana.org.au> wrote=
:
>
> On Sat, Jan 29, 2022 at 11:45:28PM +0100, Ard Biesheuvel wrote:
> >
> > diff --git a/arch/arm64/lib/xor-neon.c b/arch/arm64/lib/xor-neon.c
> > index d189cf4e70ea..e8d189f3897f 100644
> > --- a/arch/arm64/lib/xor-neon.c
> > +++ b/arch/arm64/lib/xor-neon.c
>
> I think this still fails to build on arm64:
>

Oops, failed to rebase onto the arm64 tree, which carries another XOR
patch of mine.


> ../arch/arm64/lib/xor-neon.c:13:6: warning: no previous prototype for =E2=
=80=98xor_arm64_neon_2=E2=80=99 [-Wmissing-prototypes]
>    13 | void xor_arm64_neon_2(unsigned long bytes, unsigned long * __rest=
rict p1,
>       |      ^~~~~~~~~~~~~~~~
> ../arch/arm64/lib/xor-neon.c:40:6: warning: no previous prototype for =E2=
=80=98xor_arm64_neon_3=E2=80=99 [-Wmissing-prototypes]
>    40 | void xor_arm64_neon_3(unsigned long bytes, unsigned long * __rest=
rict p1,
>       |      ^~~~~~~~~~~~~~~~
> ../arch/arm64/lib/xor-neon.c:76:6: warning: no previous prototype for =E2=
=80=98xor_arm64_neon_4=E2=80=99 [-Wmissing-prototypes]
>    76 | void xor_arm64_neon_4(unsigned long bytes, unsigned long * __rest=
rict p1,
>       |      ^~~~~~~~~~~~~~~~
> ../arch/arm64/lib/xor-neon.c:121:6: warning: no previous prototype for =
=E2=80=98xor_arm64_neon_5=E2=80=99 [-Wmissing-prototypes]
>   121 | void xor_arm64_neon_5(unsigned long bytes, unsigned long * __rest=
rict p1,
>       |      ^~~~~~~~~~~~~~~~
> ../arch/arm64/lib/xor-neon.c: In function =E2=80=98xor_neon_init=E2=80=99=
:
> ../arch/arm64/lib/xor-neon.c:316:29: error: assignment to =E2=80=98void (=
*)(long unsigned int,  long unsigned int * __restrict__,  const long unsign=
ed int * __restrict__,  const long unsigned int * __restrict__)=E2=80=99 fr=
om incompatible pointer type =E2=80=98void (*)(long unsigned int,  long uns=
igned int *, long unsigned int *, long unsigned int *)=E2=80=99 [-Werror=3D=
incompatible-pointer-types]
>   316 |   xor_block_inner_neon.do_3 =3D xor_arm64_eor3_3;
>       |                             ^
> ../arch/arm64/lib/xor-neon.c:317:29: error: assignment to =E2=80=98void (=
*)(long unsigned int,  long unsigned int * __restrict__,  const long unsign=
ed int * __restrict__,  const long unsigned int * __restrict__,  const long=
 unsigned int * __restrict__)=E2=80=99 from incompatible pointer type =E2=
=80=98void (*)(long unsigned int,  long unsigned int *, long unsigned int *=
, long unsigned int *, long unsigned int *)=E2=80=99 [-Werror=3Dincompatibl=
e-pointer-types]
>   317 |   xor_block_inner_neon.do_4 =3D xor_arm64_eor3_4;
>       |                             ^
> ../arch/arm64/lib/xor-neon.c:318:29: error: assignment to =E2=80=98void (=
*)(long unsigned int,  long unsigned int * __restrict__,  const long unsign=
ed int * __restrict__,  const long unsigned int * __restrict__,  const long=
 unsigned int * __restrict__,  const long unsigned int * __restrict__)=E2=
=80=99 from incompatible pointer type =E2=80=98void (*)(long unsigned int, =
 long unsigned int *, long unsigned int *, long unsigned int *, long unsign=
ed int *, long unsigned int *)=E2=80=99 [-Werror=3Dincompatible-pointer-typ=
es]
>   318 |   xor_block_inner_neon.do_5 =3D xor_arm64_eor3_5;
>       |                             ^
> cc1: some warnings being treated as errors
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
