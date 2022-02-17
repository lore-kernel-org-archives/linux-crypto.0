Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46319C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Feb 2022 07:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiBQHN0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Feb 2022 02:13:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiBQHN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Feb 2022 02:13:26 -0500
X-Greylist: delayed 304 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 23:13:11 PST
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8480298AFA
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 23:13:10 -0800 (PST)
Received: from mail-wr1-f53.google.com ([209.85.221.53]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MwwqB-1oDecZ1ZUJ-00ySaK for <linux-crypto@vger.kernel.org>; Thu, 17 Feb 2022
 08:08:04 +0100
Received: by mail-wr1-f53.google.com with SMTP id o24so7296158wro.3
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 23:08:04 -0800 (PST)
X-Gm-Message-State: AOAM531MxwravBU6TDAwd3lFdN0LpauYi0jQxip+TfvPuGwxu1FR32kR
        7bZ8G/MNbM1uEt/Zi77crFWqB/ngQ37oPRMvy1w=
X-Google-Smtp-Source: ABdhPJz56hQ4yFgBgAFZmrCVGvaq26OxoGL97mAkpuIsaGTOfsArnu/xLDwGg2ZOqwcLNp7GMrlrc/f8PwCaU93fGwc=
X-Received: by 2002:adf:ea01:0:b0:1e4:b3e6:1f52 with SMTP id
 q1-20020adfea01000000b001e4b3e61f52mr1152774wrm.317.1645081684017; Wed, 16
 Feb 2022 23:08:04 -0800 (PST)
MIME-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com> <20220210232812.798387-2-nhuck@google.com>
 <Yg2CKcftTJFfH+s4@sol.localdomain>
In-Reply-To: <Yg2CKcftTJFfH+s4@sol.localdomain>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 17 Feb 2022 08:07:48 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0AyNDRmzm8DOP2ieKtkXCJNEYdSVxzG5w-XmiZk3w+pg@mail.gmail.com>
Message-ID: <CAK8P3a0AyNDRmzm8DOP2ieKtkXCJNEYdSVxzG5w-XmiZk3w+pg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/7] crypto: xctr - Add XCTR support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:yzwIVfU0L/K/F6dyLoT6ifQ63BinEIDYvCLHuWiotTlVjMFdup0
 LvsYEzX2kTfBZctqZfldPFKpsQ4J3+FkDNWBlikfXfOkR9sFBfLS5BhNCMAqoB9zWAiO2Rr
 +oHFJUkbJhYvmMrqXp+G8ay93Tqxl2IJZ8MUiPtUryqN0OxvALpXsv6AzCEPBOGmXc6XQSJ
 DlwQyZ7vOCKxJHENopvQw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IfB1qRLoJHY=:cZuQYf3awOQNOt5KtNzjF8
 TuSbdz26DKd6D2PUzrSf0P5nqee/0iJBrctw/fY7oKpPzPR0KQXVPdYLmO5YlkxgYD6nnfL5F
 KK8C9bZ21NKIwsXiD8DTb2yOu5REpkpyWsmxoDhx258/MK4EKz9ALjSA1bPvlHT30QkRAqkXO
 UdCG0y1Q0EzdUv48Ut4DMXDkl3Ywear0jPSjBeU4E06BsLu8YY5pgCU7njzSG9ulu7Jgw5McZ
 DG6AKiYM2ZfDPvjFHIW9fnpy0Fta5lYJ33sVPGqGgy4CH6AMNsVn6k2W68Sl4RLAz2G1bhrKa
 ijbS/gh3IoUyMtu5CmLaeSyH8lhXZpKatozrN5u3w0kJ3q376wz2EZBN9ivTNvAGLJYHCvI2X
 YsfmkgYGrNXhfsNA0fVTdyBiGm+JVEMx+EF+SwHjwjGu240IcFr1dqhsZlfpEyluXU02XODJk
 UFVH6b86tKRjlAF9pgsLo4ERNfc/RM36htBwh3bp1kt13J9XvhjyCNiG5Vv7coJjF9ZnyObop
 BP118/KN191Htr3EcU7WG3jhZv10vm+SgZCHJGGU14G9cq/5bXjy0GnSHUuFZB6Hx0CtDq8z+
 CLzDArGUWPslcaMQEG5GLJ1dFpiVuc6P0KmX9QT99m7y+VhS0E1ebyWMChw0P+n+FQlHeIrHD
 UR7jqS7N7C3AW6U9WsnO94rkjLAopLjm0JtO+KJQn3C7Bt3KDVkV7UNkawJkyolIqa80=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 17, 2022 at 12:00 AM Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Feb 10, 2022 at 11:28:06PM +0000, Nathan Huckleberry wrote:
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index fa1741bb568f..8543f34fa200 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -452,6 +452,15 @@ config CRYPTO_PCBC
> >         PCBC: Propagating Cipher Block Chaining mode
> >         This block cipher algorithm is required for RxRPC.
> >
> > +config CRYPTO_XCTR
> > +     tristate
> > +     select CRYPTO_SKCIPHER
> > +     select CRYPTO_MANAGER
> > +     help
> > +       XCTR: XOR Counter mode. This blockcipher mode is a variant of CTR mode
> > +       using XORs and little-endian addition rather than big-endian arithmetic.
> > +       XCTR mode is used to implement HCTR2.
>
> Now that this option isn't user-selectable, no one will see this help text.
> I think it would be best to remove it, and make sure that the comment in
> crypto/xctr.c fully explains what XCTR is (currently it's a bit inadequate).

I generally prefer to have a help text in Kconfig even for hidden symbols,
and I read those when trying to find my way through code I'm not familiar
with. It's probably a good idea to expand the comment in the source
file as well, but I would suggest leaving this one in here.

         Arnd
