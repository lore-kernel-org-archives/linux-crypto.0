Return-Path: <SRS0=RZ7K=U4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0209C4321A
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jun 2019 08:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94780214AF
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Jun 2019 08:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HJN5RLEu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfF2Irn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 Jun 2019 04:47:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42399 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfF2Irm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Jun 2019 04:47:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so8557172wrl.9
        for <linux-crypto@vger.kernel.org>; Sat, 29 Jun 2019 01:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4FNg41YQwajU7cT7Ywyxjw7b0xpWcB4D/z1SX509r4A=;
        b=HJN5RLEu2XiDF8MDnjqVDk9fCREPXuX3MBlawnhLROYC75leT02oRC89oQ/IlAHh+K
         1lRy/GGp7WXVS3MWV1h36Nq/1gdiv+zX1OQlcl5TL2i+8FEbMX/fs4IUh8PIKC62Mbt2
         sb/KWG+S51buXOqaryXkiOH271D84zQgC7zRmWNIipBOkYLnxDFX9TvVqoDwDbcszuWT
         N0qElAEnuknMR0BrYKMHRcRos8DjUHCAVBLCRc0CYMkh1hlwsy8SBtR6MDl6AjVRz5QI
         zn1/pU04O2CmnHsEtojKRUKjTl7v/TZ/bLOcN6jucFJPLUUUaKXH0sbTsrSuSWLJq060
         WmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4FNg41YQwajU7cT7Ywyxjw7b0xpWcB4D/z1SX509r4A=;
        b=l7AjFcAVpQhftprKw4eo8DbEu+2F4yAvL8wzJLM4zdpqQRDvjKJNn9Ra58d38Tabr4
         2Mv90ohwkIlD61+cPfFNNMBtepKC5l2+yXgwM9ka+foAXreF/+6X8nzFZJWPv+Bvg9cF
         7Sb4Z6zMPSOhqNqVgQcLmP1I1Jt7CK3K8F7IkwmhXoeM+gEwPa/NG+FjbFbhWaTRGxED
         NPcUlC0vRmVmsgIrLfKU63iOFMSDa8M7VCn8fo0gGxtDkdimjtYPYid4XBRADqJhTH2Q
         2JBF4spg2nUEym2T10WE5Fskapn+yMF5b7bRMvySV/BhDxPmuDBaBX7TKyBgkKMuBwcm
         042w==
X-Gm-Message-State: APjAAAUrUdnE7AhHy9AZ+4m/X1hxo79XnqZ6xT689nF1opoZXyRPu15K
        hrFpc6USbINs9IzQUyioCzgubt/wnPjo9ced+7/D4w==
X-Google-Smtp-Source: APXvYqw5U0wTn0SlcbSn1fqgZ0tg0YzjaDyqGlK3aQ/glY9nDqFJnEowP+FMdHnWN3T6LOoxAiFnjcLYzMGZui1KoQA=
X-Received: by 2002:a5d:5589:: with SMTP id i9mr1715090wrv.198.1561798060614;
 Sat, 29 Jun 2019 01:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
 <20190628170746.28768-3-ard.biesheuvel@linaro.org> <20190628174924.GB103946@gmail.com>
In-Reply-To: <20190628174924.GB103946@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 29 Jun 2019 10:47:29 +0200
Message-ID: <CAKv+Gu-Pf4n3M3nORxjtFk_U+c5gLP56zXaijvJ1dgpEkCHhEA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] crypto: aegis128l/aegis256 - remove x86 and
 generic implementations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 28 Jun 2019 at 19:49, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 07:07:41PM +0200, Ard Biesheuvel wrote:
> > Three variants of AEGIS were proposed for the CAESAR competition, and
> > only one was selected for the final portfolio: AEGIS128.
> >
> > The other variants, AEGIS128L and AEGIS256, are not likely to ever turn
> > up in networking protocols or other places where interoperability
> > between Linux and other systems is a concern, nor are they likely to
> > be subjected to further cryptanalysis. However, uninformed users may
> > think that AEGIS128L (which is faster) is equally fit for use.
> >
> > So let's remove them now, before anyone starts using them and we are
> > forced to support them forever.
> >
> > Note that there are no known flaws in the algorithms or in any of these
> > implementations, but they have simply outlived their usefulness.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/x86/crypto/Makefile               |   4 -
> >  arch/x86/crypto/aegis128l-aesni-asm.S  | 826 ----------------
> >  arch/x86/crypto/aegis128l-aesni-glue.c | 297 ------
> >  arch/x86/crypto/aegis256-aesni-asm.S   | 703 --------------
> >  arch/x86/crypto/aegis256-aesni-glue.c  | 297 ------
> >  crypto/Makefile                        |   2 -
> >  crypto/aegis128l.c                     | 522 -----------
> >  crypto/aegis256.c                      | 473 ----------
> >  crypto/testmgr.c                       |  12 -
> >  crypto/testmgr.h                       | 984 --------------------
> >  10 files changed, 4120 deletions(-)
> >
>
> Need to remove the options from crypto/Kconfig too.
>

Indeed.
