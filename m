Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33A9C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 05:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C122C206C2
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 05:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uHejEa96"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfHMFJy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 01:09:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39473 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfHMFJx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 01:09:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so255276wmg.4
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 22:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ZnFsdjJmeL4sHyht3BAAxUOXidvsHhILUUcniVeWojA=;
        b=uHejEa96zT80k3ajRLhA4BU+iT0qQ8fUJh8p50Rq4bAy8PIv1sU801kZmyDKqIDfFC
         +ov5ks5m/Js+C+og7ZP33zk9wv3lHMtjTc23VbhD/jEweDKfiEXbIiHHyiTsCUdgxW/6
         qJPaNwbdxIZkfeASrPxFLhm6Zrppy2WLaNoebYrHgoKmT8gMfTo2t9g3uokkg6LGSmR9
         xeNuGcnsgHOKSkFQOT51KBctHIh0szAY8NEKyiGtzFdSdfxMgnETf0MhoTzcYXeIgGBz
         VHWh3fKhqVM50xqbr2JpkRw9yceaamAeuVbr2qsVrM+i6aaal3CoOCgqSX3nbrk3s8t9
         /HSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ZnFsdjJmeL4sHyht3BAAxUOXidvsHhILUUcniVeWojA=;
        b=Y38FETzWChb1nLZUL2jNefNvqNh7BfNEZsuHBgIsekIw7rwbgfrLVUNy3YdeSrJXLQ
         vAYIMY0vXKlnEAyu3JNHi9Z4M6RJWbq9/JlyRDAD04bx+XuiZchKWU9mx6DrukIMzEFj
         9W7b9bFfnUvGVNDJPh54QZu1HoYNvd0x+1CrUYbUQET9K91RrYGIbV6rsICRs4DT+0BG
         yxvU+/5tyRj5i2LTlW8JwREKHSiHTlapIBilYm0Nz4itlQeufRvzd8koPZui4WAr7sU+
         RUGiW9d4uyhzYYz8KVvRtGImz3+5HnlwNkbA+MYpL/CoP0SxUtau04CkdnE+bV7HYMKY
         4YuQ==
X-Gm-Message-State: APjAAAWnn0PKIoa9zxiQ17qe3Yc6wBw+E6bpUUa6z9YrgfamE6kWkaux
        3Cz1Fc2IRtijZgb6fGUtUzRrK/qrBpxl3bfQGDbYsP7QKRs=
X-Google-Smtp-Source: APXvYqwf7IjfSieinPs7ESCgDSduH5DW1k3a5XCnPYLPKw+bqOUKAY8U4nqBAvyr2mcYG875gSTrVGL3J/7ddOJRc/A=
X-Received: by 2002:a1c:f511:: with SMTP id t17mr744937wmh.53.1565672991566;
 Mon, 12 Aug 2019 22:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-3-ard.biesheuvel@linaro.org> <20190812194747.GB131059@gmail.com>
In-Reply-To: <20190812194747.GB131059@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 13 Aug 2019 08:09:41 +0300
Message-ID: <CAKv+Gu-9aHY0op6MEmN8PfQhNa0kv=xNYB6rqtaCoiUdH4OASA@mail.gmail.com>
Subject: Re: [PATCH v10 2/7] fs: crypto: invoke crypto API for ESSIV handling
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Aug 2019 at 22:47, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Aug 12, 2019 at 05:53:19PM +0300, Ard Biesheuvel wrote:
> > Instead of open coding the calculations for ESSIV handling, use a
> > ESSIV skcipher which does all of this under the hood.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> This looks fine (except for one comment below), but this heavily conflicts with
> the fscrypt patches planned for v5.4.  So I suggest moving this to the end of
> the series and having Herbert take only 1-6, and I'll apply this one to the
> fscrypt tree later.
>

I think the same applies to dm-crypt: at least patch #7 cannot be
applied until my eboiv patch is applied there as well, but [Milan
should confirm] I'd expect them to prefer taking those patches via the
dm tree anyway.

Herbert, what would you prefer:
- taking a pull request from a [signed] tag based on v4.3-rc1 that
contains patches #1, #4, #5 and #6, allowing Eric and Milan/Mike to
merge it as well, and apply the respective fscrypt and dm-crypt
changes on top
- just take patches #1, #4, #5 and #6 as usual, and let the fscrypt
and dm-crypt changes be reposted to the respective lists during the
next cycle


>
> > ---
> >  fs/crypto/Kconfig           |  1 +
> >  fs/crypto/crypto.c          |  5 --
> >  fs/crypto/fscrypt_private.h |  9 --
> >  fs/crypto/keyinfo.c         | 92 +-------------------
> >  4 files changed, 4 insertions(+), 103 deletions(-)
> >
> > diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> > index 5fdf24877c17..6f3d59b880b7 100644
> > --- a/fs/crypto/Kconfig
> > +++ b/fs/crypto/Kconfig
> > @@ -5,6 +5,7 @@ config FS_ENCRYPTION
> >       select CRYPTO_AES
> >       select CRYPTO_CBC
> >       select CRYPTO_ECB
> > +     select CRYPTO_ESSIV
> >       select CRYPTO_XTS
> >       select CRYPTO_CTS
> >       select KEYS
>
> In v5.3 I removed the 'select CRYPTO_SHA256', so now ESSIV shouldn't be selected
> here either.  Instead we should just update the documentation:
>
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 82efa41b0e6c02..a1e2ab12a99943 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -193,7 +193,8 @@ If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
>  AES-128-CBC was added only for low-powered embedded devices with
>  crypto accelerators such as CAAM or CESA that do not support XTS.  To
>  use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
> -implementation) must be enabled so that ESSIV can be used.
> +implementation) and CONFIG_CRYPTO_ESSIV must be enabled so that ESSIV
> +can be used.
>
>  Adiantum is a (primarily) stream cipher-based mode that is fast even
>  on CPUs without dedicated crypto instructions.  It's also a true
