Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C32C5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD2C322226
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckWT/HXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgKTJY5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:24:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTJY4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 04:24:56 -0500
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B49822226
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 09:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605864296;
        bh=6/moowqlNdpB66qj84VivfVu48Z+XrSgXY7wg0RBZuE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ckWT/HXO25eVrn3yXDHrIxMj5dTy2yK4FyTIj5+iTaFsr3JzP4NUCaRJ69MlPKyr+
         D400k/KkFWmo4Sal+8CGLsnpjEnvJRf5qzS9G2A19tBGu2eVEq0azdhnI84MBmczqG
         Dz9vAyYEMEf5Dgq/VyW2fVoc4QSJu0Oyw0CU23vE=
Received: by mail-oi1-f169.google.com with SMTP id t16so9678135oie.11
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 01:24:56 -0800 (PST)
X-Gm-Message-State: AOAM532Jjs/zqshTDZ4jw6e9zkrf8nEAjBFpAJB1hIFv88nWNpLf7LQ0
        YLKa8rmb9tb1Gh+psS6FiSFHh2Cxn/fv/Z08mEY=
X-Google-Smtp-Source: ABdhPJymO9UiFjVrx3RLxgSsI2GyauA6MC8iCVz851Miui9NWbo47o7WFX9k85qx0UdtH7EFuZrnNHpTfjvrQZGMD8Y=
X-Received: by 2002:aca:c657:: with SMTP id w84mr3952467oif.47.1605864295237;
 Fri, 20 Nov 2020 01:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20201109083143.2884-1-ardb@kernel.org> <20201109083143.2884-3-ardb@kernel.org>
 <20201120034440.GA18047@gondor.apana.org.au>
In-Reply-To: <20201120034440.GA18047@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Nov 2020 10:24:44 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFd1ab2uLbQ7UvL7_+ObLGbfh=p3aRm3GhAvH0tcOYQ5g@mail.gmail.com>
Message-ID: <CAMj1kXFd1ab2uLbQ7UvL7_+ObLGbfh=p3aRm3GhAvH0tcOYQ5g@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Nov 2020 at 04:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Nov 09, 2020 at 09:31:42AM +0100, Ard Biesheuvel wrote:
> > When working on crypto algorithms, being able to run tcrypt quickly
> > without booting an entire Linux installation can be very useful. For
> > instance, QEMU/kvm can be used to boot a kernel from the command line,
> > and having tcrypt.ko builtin would allow tcrypt to be executed to run
> > benchmarks, or to run tests for algortithms that need to be instantiated
> > from templates, without the need to make it past the point where the
> > rootfs is mounted.
> >
> > So let's relax the requirement that tcrypt can only be built as a
> > module when CRYPTO_MANAGER_EXTRA_TESTS is enabled, as this is already
> > documented as a crypto development-only symbol.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  crypto/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 094ef56ab7b4..9ff2d687e334 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -201,7 +201,7 @@ config CRYPTO_AUTHENC
> >
> >  config CRYPTO_TEST
> >       tristate "Testing module"
> > -     depends on m
> > +     depends on m || CRYPTO_MANAGER_EXTRA_TESTS
> >       select CRYPTO_MANAGER
> >       help
> >         Quick & dirty crypto test module.
>
> This breaks the build:
>
> crypto/Kconfig:150:error: recursive dependency detected!
> crypto/Kconfig:150:     symbol CRYPTO_MANAGER_EXTRA_TESTS depends on CRYPTO_MANAGER
> crypto/Kconfig:119:     symbol CRYPTO_MANAGER is selected by CRYPTO_TEST
> crypto/Kconfig:206:     symbol CRYPTO_TEST depends on CRYPTO_MANAGER_EXTRA_TESTS
> For a resolution refer to Documentation/kbuild/kconfig-language.rst
> subsection "Kconfig recursive dependency limitations"
>

OK, I'll apply this on top

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9ff2d687e334..959ee48f66a8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -202,7 +202,7 @@ config CRYPTO_AUTHENC
 config CRYPTO_TEST
        tristate "Testing module"
        depends on m || CRYPTO_MANAGER_EXTRA_TESTS
-       select CRYPTO_MANAGER
+       depends on CRYPTO_MANAGER
        help
          Quick & dirty crypto test module.
