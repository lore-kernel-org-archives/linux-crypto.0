Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B797AC31E50
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 18:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B1B20866
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 18:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J53VliZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfFPSZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 14:25:31 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38109 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfFPSZb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 14:25:31 -0400
Received: by mail-io1-f66.google.com with SMTP id d12so8523960iod.5
        for <linux-crypto@vger.kernel.org>; Sun, 16 Jun 2019 11:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3Arpmy1FqFbai2jFV7A32rIgKalw4zz1T4egHdTM1Q=;
        b=J53VliZa7ga0/F1EcWr9clfaa8BGIvQt9D3/186ZMVYvachuFn8fsd0VZbtDA8wQm8
         B/JeYzAHs6eAcs33hz65pcr0iQRP0Uwb24SAqbNBrRiPJP1xqGtqN2QSc9ULAi0B1/kt
         c3LdZUo5buKngXLCPheb+CpKIJ+JWli/QQYC565PZzvYFugH1dSt/ukj+MCjwIAZBRkB
         29lnyB+qm5AiaK2Fhp0oDk55Q7XX0V6B9pBBWHlFFNHX9voi0rMx+xKYKlzxc33RMVYh
         gT4oIihT+1+8112DFzwy9Mds201jIImWQuMX2qNyupdxbGviyA+/H4JrlxprxZHOdgtS
         q6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3Arpmy1FqFbai2jFV7A32rIgKalw4zz1T4egHdTM1Q=;
        b=gb88BVt90kDARuqgPJ+Y1PczPH+SnJksGARn4TJzplHDLlADqqrL/66MUch37SXRBl
         2rMfF4TXk4IdCSUMVYe4Mu9I/AQFDN8e+nIifkgHoXJ7wvmoP5jsNm6PQ90JiVowlcIa
         axK/XcM3wNGOdBJ42UTwyKeBotO2kqeXLNv86ioKk2y/IJb87uSHKzN6L5UhRhvVbLN4
         A/5Y0qzXZoU/8Hyd/tgepXbfJoff9IsafTiw1BLgs5LwAUKLeXtcbGsDPFBVVlCVK3kI
         RJuBz83tNgxZxjWu3XkWyrk+RuFiVom/iZ41Y314WQQzPDxm8b9da6ViV5UNTqeqlwCY
         uX4Q==
X-Gm-Message-State: APjAAAVls1pW6lgiTcN+C10p9QWBIrCfB/Tc0RP47psRVhQk5IiS98qa
        Q16Umydi/Cgl0SWHAcKE7coC2qs7Z7dhgc4F9rX4sR/tgmw=
X-Google-Smtp-Source: APXvYqzQ60Up5Foe2d3aljP1+cwPYln9V2X4zMlIB/LjUPLv4g7RKXCdRoKISpEotPV+vCs2qT3WzRaDY2w1eVy3h9I=
X-Received: by 2002:a02:1a86:: with SMTP id 128mr80765506jai.95.1560709530418;
 Sun, 16 Jun 2019 11:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190615091745.3100-1-ard.biesheuvel@linaro.org>
 <20190616012056.GA698@sol.localdomain> <CAKv+Gu_j_y3oSPy8JbTdNYVjzsSw72gM+UcC6+u_WBtw6opX2Q@mail.gmail.com>
 <20190616071951.GC698@sol.localdomain>
In-Reply-To: <20190616071951.GC698@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 16 Jun 2019 20:25:18 +0200
Message-ID: <CAKv+Gu8ngYYHVTb3hzLo28_f2861SRX2yc5fFkp1k0PR=Zi4tQ@mail.gmail.com>
Subject: Re: [PATCH v3] wusb: switch to cbcmac transform
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-usb <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 16 Jun 2019 at 09:19, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Jun 16, 2019 at 08:52:32AM +0200, Ard Biesheuvel wrote:
> > On Sun, 16 Jun 2019 at 03:20, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Sat, Jun 15, 2019 at 11:17:45AM +0200, Ard Biesheuvel wrote:
> > > > The wusb code takes a very peculiar approach at implementing CBC-MAC,
> > > > by using plain CBC into a scratch buffer, and taking the output IV
> > > > as the MAC.
> > > >
> > > > We can clean up this code substantially by switching to the cbcmac
> > > > shash, as exposed by the CCM template. To ensure that the module is
> > > > loaded on demand, add the cbcmac template name as a module alias.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > ---
> > > > v3: - add missing #include to fix build error spotted by kbuild test robot
> > > > v2: - use finup()/digest() where possible, and process b0+b1 using a single
> > > >       call to update()
> > > >     - make 'stv_hsmic_hs' static const and remove comment regarding GCC 4.1
> > > >
> > > > NOTE: I don't have any hardware to test this, but the built-in selftest
> > > >       still passes.
> > > >
> > > >  crypto/ccm.c                  |   1 +
> > > >  drivers/usb/wusbcore/crypto.c | 169 +++++---------------
> > > >  2 files changed, 45 insertions(+), 125 deletions(-)
> > > >
> > >
> > > drivers/usb/wusbcore/Kconfig also needs to be updated:
> > >
> > > diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> > > index 12e89189ca7d..2ec17d6af1f8 100644
> > > --- a/drivers/usb/wusbcore/Kconfig
> > > +++ b/drivers/usb/wusbcore/Kconfig
> > > @@ -6,9 +6,7 @@ config USB_WUSB
> > >         tristate "Enable Wireless USB extensions"
> > >         depends on UWB
> > >          select CRYPTO
> > > -        select CRYPTO_BLKCIPHER
> > > -        select CRYPTO_CBC
> > > -        select CRYPTO_MANAGER
> >
> > We'll need this one, as it isn't implied by any of the other ones, and
> > cbcmac(aes) will be composed of the ccm template and the aes cipher on
> > all architectures except arm64.
> >
> > > +        select CRYPTO_CCM
>
> Are you talking about CRYPTO_MANAGER?  One of my recent patches added
> 'select CRYPTO_MANAGER' to the templates that didn't already select it,
> including CCM.  See in cryptodev.git:
>
>         commit c8a3315a5f691cc4be16421aeb0608495c9a33ba
>         Author: Eric Biggers <ebiggers@google.com>
>         Date:   Mon May 20 09:49:46 2019 -0700
>
>             crypto: make all templates select CRYPTO_MANAGER
>
> So it shouldn't need to be selected here.
>

Ah yes, thanks for pointing that out.
