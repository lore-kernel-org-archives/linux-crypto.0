Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A098EC5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 406432242A
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MolZ5cQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgKTKe0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:34:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgKTKe0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 05:34:26 -0500
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EFF2224C
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 10:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605868465;
        bh=Rb6vnug4QK2Kz5PQy7ZIgAY72ROa1vMcjCxpNhX802A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MolZ5cQpG+OJMA19MRz+gRZHPUxHJN+QtEdh+iqt7fdPzgfpJRBpnP65bTHPcQAEH
         vPgZ/5DgK3TcOoVCrjOVoiOKaO8yo5cQj+inMoXwPtpXmYBzi1F2B6PJ/9SeETP9Wn
         ltoCisuC/EmjY7UA+Z2BJbtlUS5nYK8ZYhs476AI=
Received: by mail-oi1-f179.google.com with SMTP id a130so1792753oif.7
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 02:34:25 -0800 (PST)
X-Gm-Message-State: AOAM533fzKubUAuMQ4BMYR5LcWCODfqgHrdVjOC7rd7q1CoNOhL6kteq
        8AztpFZiunjZI5xzszYVQ+LO5mX/M9KzZdtOSkk=
X-Google-Smtp-Source: ABdhPJxKVZ94xsH9vyp1Qk3gmno2+kF5jLW0ye++8lnV4ICIn+RuMYVzQO/n9CPH4RKbZBaKi1zWwEUw37gkmEA8I+Q=
X-Received: by 2002:aca:5c82:: with SMTP id q124mr5981883oib.33.1605868464880;
 Fri, 20 Nov 2020 02:34:24 -0800 (PST)
MIME-Version: 1.0
References: <20201109083143.2884-1-ardb@kernel.org> <20201109083143.2884-3-ardb@kernel.org>
 <20201120034440.GA18047@gondor.apana.org.au> <CAMj1kXFd1ab2uLbQ7UvL7_+ObLGbfh=p3aRm3GhAvH0tcOYQ5g@mail.gmail.com>
 <20201120100936.GA22225@gondor.apana.org.au>
In-Reply-To: <20201120100936.GA22225@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Nov 2020 11:34:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGu67h96=RvVDRM2z9-N4KcvOLnr6EurjkpbPdZQfh6qw@mail.gmail.com>
Message-ID: <CAMj1kXGu67h96=RvVDRM2z9-N4KcvOLnr6EurjkpbPdZQfh6qw@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Nov 2020 at 11:09, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Nov 20, 2020 at 10:24:44AM +0100, Ard Biesheuvel wrote:
> >
> > OK, I'll apply this on top
> >
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 9ff2d687e334..959ee48f66a8 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -202,7 +202,7 @@ config CRYPTO_AUTHENC
> >  config CRYPTO_TEST
> >         tristate "Testing module"
> >         depends on m || CRYPTO_MANAGER_EXTRA_TESTS
> > -       select CRYPTO_MANAGER
> > +       depends on CRYPTO_MANAGER
>
> How about just removing the depends line altogether?
>

That may break the build, and therefore randconfig build testing:


crypto/tcrypt.o: In function `do_mult_aead_op':
tcrypt.c:(.text+0x180): undefined reference to `crypto_aead_encrypt'
tcrypt.c:(.text+0x194): undefined reference to `crypto_aead_decrypt'
crypto/tcrypt.o: In function `do_mult_acipher_op':
tcrypt.c:(.text+0x2a0): undefined reference to `crypto_skcipher_encrypt'
tcrypt.c:(.text+0x2b4): undefined reference to `crypto_skcipher_decrypt'
crypto/tcrypt.o: In function `test_skcipher_speed':
tcrypt.c:(.text+0xf60): undefined reference to `crypto_alloc_skcipher'
tcrypt.c:(.text+0x1088): undefined reference to `crypto_skcipher_setkey'
tcrypt.c:(.text+0x1534): undefined reference to `crypto_skcipher_encrypt'
tcrypt.c:(.text+0x1570): undefined reference to `crypto_skcipher_decrypt'
tcrypt.c:(.text+0x15e8): undefined reference to `crypto_skcipher_encrypt'
tcrypt.c:(.text+0x1624): undefined reference to `crypto_skcipher_decrypt'
tcrypt.c:(.text+0x168c): undefined reference to `crypto_skcipher_encrypt'
tcrypt.c:(.text+0x16a8): undefined reference to `crypto_skcipher_decrypt'
crypto/tcrypt.o: In function `test_mb_aead_speed.constprop.23':
tcrypt.c:(.text+0x2020): undefined reference to `crypto_alloc_aead'
tcrypt.c:(.text+0x2048): undefined reference to `crypto_aead_setauthsize'
tcrypt.c:(.text+0x23a4): undefined reference to `crypto_aead_setkey'
tcrypt.c:(.text+0x27d0): undefined reference to `crypto_aead_encrypt'
crypto/tcrypt.o: In function `test_mb_skcipher_speed':
tcrypt.c:(.text+0x28ec): undefined reference to `crypto_alloc_skcipher'
tcrypt.c:(.text+0x2c08): undefined reference to `crypto_skcipher_setkey'
crypto/tcrypt.o: In function `test_aead_speed.constprop.22':
tcrypt.c:(.text+0x320c): undefined reference to `crypto_alloc_aead'
tcrypt.c:(.text+0x331c): undefined reference to `crypto_aead_setkey'
tcrypt.c:(.text+0x3328): undefined reference to `crypto_aead_setauthsize'
tcrypt.c:(.text+0x33ec): undefined reference to `crypto_aead_encrypt'
tcrypt.c:(.text+0x3428): undefined reference to `crypto_aead_decrypt'
tcrypt.c:(.text+0x3488): undefined reference to `crypto_aead_encrypt'
tcrypt.c:(.text+0x34c4): undefined reference to `crypto_aead_decrypt'
tcrypt.c:(.text+0x3528): undefined reference to `crypto_aead_encrypt'
tcrypt.c:(.text+0x3564): undefined reference to `crypto_aead_decrypt'
tcrypt.c:(.text+0x3744): undefined reference to `crypto_aead_encrypt'
crypto/tcrypt.o: In function `do_test':
tcrypt.c:(.text+0x3ad0): undefined reference to `alg_test'
tcrypt.c:(.text+0x3af4): undefined reference to `alg_test'
tcrypt.c:(.text+0x3b18): undefined reference to `alg_test'
tcrypt.c:(.text+0x3b34): undefined reference to `alg_test'
tcrypt.c:(.text+0x3b50): undefined reference to `alg_test'
