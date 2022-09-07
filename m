Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC2BECAAD3
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 09:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIGJTD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 05:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiIGJTC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 05:19:02 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14D296745
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 02:19:01 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3457bc84d53so41659267b3.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Sep 2022 02:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=l0xEQsbE2eoqhPdBFlcigg1eN1FK5AXrP7+HDFAlaUE=;
        b=sUS1aDgkN2F7qDNQFo7UhD5sIWnOsIti/09pvl8QW2dvlDcrWdWMWhSCBnJPOVWWw/
         LCza7grxM0GEHXYfbaYp7mCIHrSp8qPirbI6CnCxPC7H8KmRqKXeSNY8eGYJ8GJ4hvCd
         yHmviexb3XBBXRYvr7S4mRDKFgU5qbCOcTjSxxSusazG4KgJZEaEDoNrrosAdxpRq0L4
         DM8qYmkbI4AnjMwS4GbqGFBy2HPy9VX16T1gHZ9uL24h/YYcwbmRMEC+CzIpqRpKM5Z8
         NaQwiM6YY7HhhlVPucpDtDPxhSyDklnzVLhA2JzHYldjutBkTes37WSX25Q/xAZ4MAc9
         +9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=l0xEQsbE2eoqhPdBFlcigg1eN1FK5AXrP7+HDFAlaUE=;
        b=JJR8DGvltQidm/kbRrlK/luwm5erdb7nvnu9/lszk7l6hFSd0Du0xG8VA7hgUOKr8D
         43ixAIDrQrLDThoXejfIGkRMIF4Y4AhvR85kwhtByhnwj1vCL7YFOPWQsPsO+sUIHEHa
         UjtPNlQqIIB/aOuXVezdDO/D8on5r2whiHkHaQn8QdCCiaFS5sv2HxzmmWZjlzYCR4BW
         CVgwFjYk5RfuUAfr+6GKP31ZzSkYEtnFo5s06B4iIpYH2T0PBCUuoi36XcKsh64Jsinq
         8VyEYIl0y6n7YHMIGrZNJYeYGqeEuNJefgI2OvbK9IAO1Gk5ROLJEL3lv/FdzwiBmS8D
         pmUQ==
X-Gm-Message-State: ACgBeo1TU/TAuuuT98bHoNSvUGl+waEb9i/nblX2wSPxMVg2rY+WFgiQ
        vnVwebsJlbjUCRnJkpEQVVZicXdHG4H00cuqI56Wlg==
X-Google-Smtp-Source: AA6agR4sGDmad8J6SsCn9OzzNznBTVx37Wjtmkh4S0tz8IuBXk4DHNwwKMcMYxXfF4zetY6o1eGSrmXVp75zdbZ5nV0=
X-Received: by 2002:a81:92c4:0:b0:340:bd1f:3e35 with SMTP id
 j187-20020a8192c4000000b00340bd1f3e35mr2227850ywg.324.1662542340831; Wed, 07
 Sep 2022 02:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220906202017.5093fd23@canb.auug.org.au> <YxfFzGObDWsylCK+@quark>
In-Reply-To: <YxfFzGObDWsylCK+@quark>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 7 Sep 2022 11:18:24 +0200
Message-ID: <CAG_fn=UcWy+gbYLDM2WQZ=BZuVRML17KJ0L+=zsSg7+yDo4oGA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mm tree with the crypto tree
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Robert Elliott <elliott@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 7, 2022 at 12:12 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Sep 06, 2022 at 08:20:17PM +1000, Stephen Rothwell wrote:
> > diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
> > index 9bb0f7939c6b..856f5d8ca65f 100644
> > --- a/arch/x86/crypto/Kconfig
> > +++ b/arch/x86/crypto/Kconfig
> > @@ -5,6 +5,7 @@ menu "Accelerated Cryptographic Algorithms for CPU (x86=
)"
> >  config CRYPTO_CURVE25519_X86
> >       tristate "Public key crypto: Curve25519 (ADX)"
> >       depends on X86 && 64BIT
> > +     depends on !KMSAN # avoid false positives from assembly
> >       select CRYPTO_LIB_CURVE25519_GENERIC
> >       select CRYPTO_ARCH_HAVE_LIB_CURVE25519
> >       help
> > @@ -16,6 +17,7 @@ config CRYPTO_CURVE25519_X86
> >  config CRYPTO_AES_NI_INTEL
> >       tristate "Ciphers: AES, modes: ECB, CBC, CTS, CTR, XTR, XTS, GCM =
(AES-NI)"
> >       depends on X86
> > +     depends on !KMSAN # avoid false positives from assembly
> >       select CRYPTO_AEAD
> >       select CRYPTO_LIB_AES
> >       select CRYPTO_ALGAPI
> > @@ -32,6 +34,7 @@ config CRYPTO_AES_NI_INTEL
> >  config CRYPTO_BLOWFISH_X86_64
> >       tristate "Ciphers: Blowfish, modes: ECB, CBC"
> >       depends on X86 && 64BIT
> > +     depends on !KMSAN # avoid false positives from assembly
> >       select CRYPTO_SKCIPHER
> >       select CRYPTO_BLOWFISH_COMMON
> >       imply CRYPTO_CTR
> > @@ -44,6 +47,7 @@ config CRYPTO_BLOWFISH_X86_64
> >  config CRYPTO_CAMELLIA_X86_64
> >       tristate "Ciphers: Camellia with modes: ECB, CBC"
> >       depends on X86 && 64BIT
> > +     depends on !KMSAN # avoid false positives from assembly
> >       select CRYPTO_SKCIPHER
> >       imply CRYPTO_CTR
> >       help
> > @@ -55,6 +59,7 @@ config CRYPTO_CAMELLIA_X86_64
> >  config CRYPTO_CAMELLIA_AESNI_AVX_X86_64
> >       tristate "Ciphers: Camellia with modes: ECB, CBC (AES-NI/AVX)"
> >       depends on X86 && 64BIT
> > +     depends on !KMSAN # avoid false positives from assembly
> >       select CRYPTO_SKCIPHER
> >       select CRYPTO_CAMELLIA_X86_64
> >       select CRYPTO_SIMD
>
> Are there any options in arch/x86/crypto/Kconfig that *don't* need a depe=
ndency
> on !KMSAN?  If not, this could be done in a much simpler way.

Am I understanding right that arch/x86/crypto is supposed to contain
algorithms implemented in x86 assembly rather than plain C?
If so, we should definitely disable all of them under KMSAN to avoid
false positives. And, yes, in a simpler way :)

What's the best way to handle this? Send another patch series? Or
maybe just an update for "crypto: kmsan: disable accelerated configs
under KMSAN"?

> - Eric



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
