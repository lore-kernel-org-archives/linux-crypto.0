Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE7AC31E54
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 06:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 534562080A
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 06:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SSK4Jt0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfFPGwr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 02:52:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44435 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfFPGwq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 02:52:46 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so14540451iob.11
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jun 2019 23:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MEroY9WdNJ3bMgtxlxAekXl4sdcVNdwZiEJJn+vw10s=;
        b=SSK4Jt0gPnA0wUcxHdu0WtXAcfUIRDsJegUmNQGwk/gn6CiASev/AMuVKohQFwMIg6
         YWn17sBNos0XNIZLTb1R8nJ/f29BZIX0HQwlek4zhv212dWwcyXXfLsL1Mx93WgtiNQm
         yv8UmjX8pxEb1OLNS9GrXtnhN/x+NBX7HtCRT1bd5z/eLk0EQfU1yTM86RNF5nAujawS
         56SjBcCxMWTYZC141A9P/WO4WdtBLGUMkqb+JbS5t1kJ3fCEMGW0uPPvHtbgTORa9fc2
         hhlaQ1US3pKySqhxRqXJLJcGsAtnVJIsAaZXdfMVr31G3kqe8etbBjfW9kc4xsWkJpwO
         pL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEroY9WdNJ3bMgtxlxAekXl4sdcVNdwZiEJJn+vw10s=;
        b=MuzRs2lKk7gCJlFVyJWujSPC/NOkQRA3XXQJDW8WvDYMtf7lkrCalj3PIEYvOwUbIw
         pq7nAcy+I26TLAZpEy3O3Nt3fLtfMa+V+68Lyf0Mb1eWtpFaJBNMzZtafCyC+3GbEfAc
         ptzF0q8muLJl21BzR+eCTR25948VmShG2SjftUZF5Azw5xk7U89CVk8zeDK+NyZN68ta
         I1bXiGKVtWAdWOwKrMDGzEFyx4XLGh8LPBhEaRI6NXNbPIZ1r6Pbpo4hbHwaq6Um7dfj
         GgmIa0kyAZbx7N/bWT3IVhtrNSmEpzkQ6Dlndf3YquW7wCMfiatQU5yA7fAh0PHmX6nT
         QjFg==
X-Gm-Message-State: APjAAAU7bnG8Eii2SDXZuKD9sbBlgSfoOiJjvmbRnRnHWY6VTBwvwZWR
        G7TC0oShZfXXREmlUwud93MbT5jX2U2kd7MErFpXaA/lD32vvA==
X-Google-Smtp-Source: APXvYqzdUoCv2fiUjq2QrutOzMhc4eINkvnf/Jom7JC7pWW1nbM/MXmbf1vvC2LGdwiQghlFzy6bjkTRi30U03o4eEA=
X-Received: by 2002:a5d:9d97:: with SMTP id 23mr20300005ion.204.1560667965728;
 Sat, 15 Jun 2019 23:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190615091745.3100-1-ard.biesheuvel@linaro.org> <20190616012056.GA698@sol.localdomain>
In-Reply-To: <20190616012056.GA698@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 16 Jun 2019 08:52:32 +0200
Message-ID: <CAKv+Gu_j_y3oSPy8JbTdNYVjzsSw72gM+UcC6+u_WBtw6opX2Q@mail.gmail.com>
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

On Sun, 16 Jun 2019 at 03:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sat, Jun 15, 2019 at 11:17:45AM +0200, Ard Biesheuvel wrote:
> > The wusb code takes a very peculiar approach at implementing CBC-MAC,
> > by using plain CBC into a scratch buffer, and taking the output IV
> > as the MAC.
> >
> > We can clean up this code substantially by switching to the cbcmac
> > shash, as exposed by the CCM template. To ensure that the module is
> > loaded on demand, add the cbcmac template name as a module alias.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > v3: - add missing #include to fix build error spotted by kbuild test robot
> > v2: - use finup()/digest() where possible, and process b0+b1 using a single
> >       call to update()
> >     - make 'stv_hsmic_hs' static const and remove comment regarding GCC 4.1
> >
> > NOTE: I don't have any hardware to test this, but the built-in selftest
> >       still passes.
> >
> >  crypto/ccm.c                  |   1 +
> >  drivers/usb/wusbcore/crypto.c | 169 +++++---------------
> >  2 files changed, 45 insertions(+), 125 deletions(-)
> >
>
> drivers/usb/wusbcore/Kconfig also needs to be updated:
>
> diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> index 12e89189ca7d..2ec17d6af1f8 100644
> --- a/drivers/usb/wusbcore/Kconfig
> +++ b/drivers/usb/wusbcore/Kconfig
> @@ -6,9 +6,7 @@ config USB_WUSB
>         tristate "Enable Wireless USB extensions"
>         depends on UWB
>          select CRYPTO
> -        select CRYPTO_BLKCIPHER
> -        select CRYPTO_CBC
> -        select CRYPTO_MANAGER

We'll need this one, as it isn't implied by any of the other ones, and
cbcmac(aes) will be composed of the ccm template and the aes cipher on
all architectures except arm64.

> +        select CRYPTO_CCM
>          select CRYPTO_AES
>         help
>           Enable the host-side support for Wireless USB.
>
> > diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
> > index edb7263bff40..9ee66483ee54 100644
> > --- a/drivers/usb/wusbcore/crypto.c
> > +++ b/drivers/usb/wusbcore/crypto.c
>
> Other than that, this patch looks correct.  There are a massive number of things
> that need to be cleaned up in this code, but I guess we don't really care since
> as Greg said, this driver is planned to be removed anyway.  (It also seems the
> wireless USB specification is no longer available at usb.org.)  So I'm not going
> to bother being very picky...
>

Thanks Eric.
