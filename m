Return-Path: <SRS0=nD+4=Y4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84195CA9ECF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 09:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D04222CD
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 09:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mzcALg4I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfKDJG2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:06:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39945 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfKDJG2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Nov 2019 04:06:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id o28so16041888wro.7
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2019 01:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HreKd7spBJEdah5Hl1WVR5KBRx+F0xMdV0W9Xs+3+6U=;
        b=mzcALg4IkxO3+3ztuDuhvI/gaA7l+JDfftqtNdhcrYEIizWIIdY2DUWd/3r9vEVBwH
         ej6kqIkIps0szWcEg3P7ITdq1D+9+1YU6kMp6s4PLmCMFuHKOd3ggtbZJ9bxCK09Tznk
         CU201v1Wry6GKYXegyssNHKkjFWKzm1djXOg6BIIgG25ZxMMlWU386z6h1ivfPjopURa
         R4ZaaRPqRVxXCCGMQY4skYigotpZWP2uxYTnRSAALrkg5kd1a8BBiWYkeEhWfePqIF9M
         /pGko3KWCLiFw7bJmmu0mqZqAUmjTQt9vWFeJsp9a7Bhnw7bpnYGJGDKcb3mONj+MYAU
         SyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HreKd7spBJEdah5Hl1WVR5KBRx+F0xMdV0W9Xs+3+6U=;
        b=ZSzWP9mCQEiSR4vVlGATARq59wdWV2XCa0pDUB9FI+9A9v4l9In5deiaTQQOHibefK
         Kgkzoo7lpI9HeXIEoeE+J72ZesfMIitWPCJ8mBjV35lYkHUugSN7/bem9TLzyqrY+9Z9
         mawNTsCyhRPVChV6rvbDUQMcC485e5LbtFkkf9+ytJbPpsu8ABwA2XkPgJot96GQOUvU
         MlL6MP+/nNpUVYMNOA0xlNqOKbzxx9liZBKzAyeE/G/SsAhGQMXAbaq/TI0TTyntRDJa
         PfiroHuoaVv2yQ+OFrS8M93g5cCPXxYRuFG8i+XCEBuTT91ymjRwCb9OaNBIkFFvyDeV
         46bQ==
X-Gm-Message-State: APjAAAW8nBdjWVasWSsIfzhH217pv1lazkPnUOYYpaj5Tzuv6rtnMU6V
        L34Is5wAk6yV6p/8QSiphiF3ragOmeUA8s9omAyJFw==
X-Google-Smtp-Source: APXvYqyB1rJVhzJVPk2WnZWR/6B+Mot/8g7VsBHBS4BCNEfYbv6sfhgj1+OLKhjIL8zlnMqGhZ2jWkYXrRtGp/dKVeQ=
X-Received: by 2002:adf:f20d:: with SMTP id p13mr7446044wro.325.1572858385520;
 Mon, 04 Nov 2019 01:06:25 -0800 (PST)
MIME-Version: 1.0
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-3-ard.biesheuvel@linaro.org> <20191023030523.GB4278@sol.localdomain>
In-Reply-To: <20191023030523.GB4278@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 4 Nov 2019 10:06:14 +0100
Message-ID: <CAKv+Gu_U2t_UraXJy7h08BqbJiJQdT2KQpw9xjyzKWtzhr4ZRQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/35] crypto: chacha - move existing library code into lib/crypto
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 23 Oct 2019 at 05:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Oct 17, 2019 at 09:08:59PM +0200, Ard Biesheuvel wrote:
> > +static inline void chacha_crypt(u32 *state, u8 *dst, const u8 *src,
> > +                             unsigned int bytes, int nrounds)
> > +{
> > +     if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA))
> > +             chacha_crypt_arch(state, dst, src, bytes, nrounds);
> > +     else
> > +             chacha_crypt_generic(state, dst, src, bytes, nrounds);
> > +}
>
> How about also providing chacha20_crypt() which calls chacha_crypt(..., 20)?
> The 'nrounds' parameter is really for implementations, rather than users of the
> library API.  Users don't really have any business specifying the number of
> rounds as an int.
>

OK

> > +static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
> > +                             unsigned int keysize, int nrounds)
> > +{
> > +     struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +     int i;
> > +
> > +     if (keysize != CHACHA_KEY_SIZE)
> > +             return -EINVAL;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
> > +             ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
> > +
> > +     ctx->nrounds = nrounds;
> > +     return 0;
> > +}
>
> At the end of this patch series there are 5 drivers which wrap chacha_setkey()
> with chacha20_setkey() and chacha12_setkey() -- all 5 pairs identical.  How
> about providing those as inline functions here?
>

The reason I avoided this is because they are only invoked via
indirect calls, but actually, there's nothing wrong with letting the
compiler instantiate it where needed, so I'll change this.

> > +config CRYPTO_LIB_CHACHA
> > +     tristate "ChaCha library interface"
> > +     depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
> > +     select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
> > +     help
> > +       Enable the ChaCha library interface. This interface may be fulfilled
> > +       by either the generic implementation or an arch-specific one, if one
> > +       is available and enabled.
>
> Since this is a library for use within the kernel, and not a user-visible
> feature, I don't think it should be explicitly selectable.  I.e. it should just
> be "tristate", without the prompt string.
>

The issue here is that it is not implicitly selectable either due to
the dependencies. E.g, if you select the generic version as a builtin
and the accelerated version as a module, you could enable the
chachapoly library interface as a builtin but it won't use the
accelerated code at all. So either we declare here that both need to
be either builtin or modules, or we ignore that and allow people to
create suboptimal Kconfigs.
