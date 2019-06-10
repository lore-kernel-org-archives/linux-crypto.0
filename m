Return-Path: <SRS0=e/ms=UJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C45C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 16:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14743206C3
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 16:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZO+Laxch"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389658AbfFJQKy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:10:54 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36206 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389178AbfFJQKy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 12:10:54 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so7332363ioh.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2019 09:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E97Yb8B0mwXMPNhBZyrFfBtZxN5DgDGnnZK28ieRjoU=;
        b=ZO+Laxch1C/EX9l+VwzV8H1esnEBDADpsSOgq/PPE8tVAy+/k6D/560MJHwNqbL92D
         tNWgQ+lm8O+JEU1C3duT9US+x7mI3y9aKrrYgSl1GrkRMFbdT4YGTakIEK4wZVo4CooC
         LREEWmIJuCD0DqyI6F8k0pah9urNyucDR1lOqPtMN8WEIAvPZvNZ9WAlYF6neNvx4IWa
         XvpCypUos/Bpqtw+IrA+2lcB8NBvfjdG97r/AXYq4h2YoxIEUBhg2GVFZBsnBPKU2SaW
         D1J4BbKnYWL9KSyl9z8pYbcPdPvTLIzE0Doo0Gch/DN6W1Cb+KI8t1RGAli//g+Tg7Ut
         TIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E97Yb8B0mwXMPNhBZyrFfBtZxN5DgDGnnZK28ieRjoU=;
        b=CFypFXjO5XlD7fZp0xbz2N5fGiV7F7BEqNtBpzyiQ+Xws1k5M8/UgoL7yjWGoTKCH+
         qhbCehlrJuLmhhGPs4I7Im7SK2jaq9Q4LelgghNc7YFedKYO8gOa9JBOjcEacmjp0g/u
         k+b2KgwGzIgxtLas0USJDOkv9OWKUH/B3zKe0ickRoMKiezYizseQ86S3X3OsiAO+luz
         LTAIm9OMgHl6/Uqy+WnF9eoBPube2E1AshAr6d3bIVgadGYX2hz9fNZOIinvgmsaPzV6
         4BxiTN1qsmM63/TmqLMrdpG3LngN41Ut88hZKs1ppXL0cKfJuiXtPki2dYFFHruN4K0n
         ++Ng==
X-Gm-Message-State: APjAAAVmSKcFIDlP80jPxX1mOg58TtDiwenTg1f1XH6E2Y8/4t7uoVp+
        nCV4EKPGoiBki+4xActeE6XuXrvZgiTU0X6cw+i69g==
X-Google-Smtp-Source: APXvYqz7edc3cWdKVkckKy87Z9yiqKY6k4IFWah7AYqXr/fJIL8iCrHGZEjX7rBln3qysNnJUMhsjf61/jmbH41v6A4=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr10349469iob.49.1560183053533;
 Mon, 10 Jun 2019 09:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
 <20190609115509.26260-2-ard.biesheuvel@linaro.org> <20190610160622.GA63833@gmail.com>
In-Reply-To: <20190610160622.GA63833@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 10 Jun 2019 18:10:41 +0200
Message-ID: <CAKv+Gu-az2BBVLpKqw=m_5ttXYRT95CE8toxt8-+W13A_jmuAg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] crypto: arc4 - refactor arc4 core code into
 separate library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 10 Jun 2019 at 18:06, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Just some bike shedding:
>
> On Sun, Jun 09, 2019 at 01:55:03PM +0200, Ard Biesheuvel wrote:
> > diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
> > index 5b2c24ab0139..62ac95ec6860 100644
> > --- a/include/crypto/arc4.h
> > +++ b/include/crypto/arc4.h
> > @@ -6,8 +6,21 @@
> >  #ifndef _CRYPTO_ARC4_H
> >  #define _CRYPTO_ARC4_H
> >
> > +#include <linux/types.h>
> > +
> >  #define ARC4_MIN_KEY_SIZE    1
> >  #define ARC4_MAX_KEY_SIZE    256
> >  #define ARC4_BLOCK_SIZE              1
> >
> > +struct crypto_arc4_ctx {
> > +     u32 S[256];
> > +     u32 x, y;
> > +};
> > +
> > +int crypto_arc4_set_key(struct crypto_arc4_ctx *ctx, const u8 *in_key,
> > +                     unsigned int key_len);
> > +
> > +void crypto_arc4_crypt(struct crypto_arc4_ctx *ctx, u8 *out, const u8 *in,
> > +                    unsigned int len);
>
> How about naming these just arc4_* instead of crypto_arc4_*?  The crypto_*
> prefix is already used mostly for crypto API helper functions, i.e. functions
> that take take one of the abstract crypto API types like crypto_skcipher,
> shash_desc, etc.  For lib functions, the bare name seems more appropriate.  See
> e.g. sha256_update() vs. crypto_sha256_update().
>

That is also fine, although I am slightly concerned that we may run
into trouble with other algorithms in the future. But I do agree it
makes sense to make a clear distinction with the full blown API.

> > +++ b/lib/crypto/Makefile
> > @@ -0,0 +1,3 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
> > diff --git a/lib/crypto/libarc4.c b/lib/crypto/libarc4.c
> > new file mode 100644
> > index 000000000000..b828af2cc03b
> > --- /dev/null
> > +++ b/lib/crypto/libarc4.c
> > @@ -0,0 +1,74 @@
>
> How about arc4.c instead of libarc4.c?  The second "lib" is redundant, given
> that the file is already in the lib/ directory.
>

The problem here is that we'll end up with two modules named arc4.ko,
one in crypto/ and one in lib/crypto/. Perhaps we should rename the
other one? (especially once it implements ecb(arc4) only.)
