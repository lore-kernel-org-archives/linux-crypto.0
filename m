Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C46FC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 11:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416D1218AE
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 11:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zqv0ds1n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfKHL2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:28:53 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35512 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbfKHL2x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 06:28:53 -0500
Received: by mail-wm1-f65.google.com with SMTP id 8so5862814wmo.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 03:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTVha1GpZWP2ZgYmAsnWNBQcpL16mC7DyhHb6pX7E54=;
        b=Zqv0ds1nIrTjgYl9kUySnLsanOxRhcdGI5DSh7RmfkDAY/0eJQMuFfoffJFPi8Csbl
         A3RtHdGIcSywI6bGQfYsZyepaLElyJAUv1wN+EwGL58esOLcnowtNnYNcEVoP+0MtWCz
         Lbh/JnLHv7uCL/pBmh8z2LKjNDSEkxUJaL+ySdXySGP1RNFn6Eh38J8/S02k/znl/w5F
         TF3R1cIiJM1/mvj7mQoabGOr5MlHMKuQDocZFfHtoIbKsUk8CqFqcshMS42/mcYqLF8J
         rYuZBw9/CkLPz5vqLK3uS80pShcPBty039zIJSTVjRro9zjSk4ZTjjSqlcUoUDNCDy56
         GWAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTVha1GpZWP2ZgYmAsnWNBQcpL16mC7DyhHb6pX7E54=;
        b=AH9mwhvysVSsSvJ6Crf2a9pjmwuDAFhDplUoc3DVs1nzqZOOsRWZQGxAmdyNoZgGfP
         VrqNQ4m0XvMRaSegp3aqyoDcqpF/W61zVyQSy3rDgmuDxQQdZDHHfVfjAjvQ3Lld6E6Q
         vpXcnuq+hC/x4TOSuWcbr/FSlH5/NkSWD0wf4Pb+gZFEuQgrHIkOCUKRkCNSTC/sRjMN
         FW4whQwbwHG+SgPsQNgzmdU7qucX22u+iuX5gUOlU+FvjNYjCvTXhMFe1LFDKi7tBETu
         mgjA+ZTmHC3/vbrN8PUYWHP31psj9srZuSM/+7E19WtD2z5XkJ0vBE2TGqSfKzaJmw5U
         +RlQ==
X-Gm-Message-State: APjAAAXRvh46i+4/E/nMvuX9RToJ8TMB2nI+SFa+yO9sVHUIC5f/IMu6
        6iBs38FF86Mj2oELD577Rir6wbGz9dGO9ogTTY5ONQ==
X-Google-Smtp-Source: APXvYqytof0HUVs50DFFWUP374Lzn3jU2qUSF/X0hnDYgOqIfqSObsgi70mO7sYYehjA7bi1pduT10c6e1WKH1Z4BdY=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr7817525wme.53.1573212531341;
 Fri, 08 Nov 2019 03:28:51 -0800 (PST)
MIME-Version: 1.0
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-23-ard.biesheuvel@linaro.org> <20191023045157.GB361298@sol.localdomain>
 <CAKv+Gu_9rY6OBEZ9iZQ53CWRQbd+k64JL4Tuazn3BO3ohF2g6w@mail.gmail.com>
In-Reply-To: <CAKv+Gu_9rY6OBEZ9iZQ53CWRQbd+k64JL4Tuazn3BO3ohF2g6w@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 12:28:40 +0100
Message-ID: <CAKv+Gu-FjMsqiCpJurSG3FOGynpmdcJJPt15FGOsZK5kQjX-mg@mail.gmail.com>
Subject: Re: [PATCH v4 22/35] crypto: BLAKE2s - generic C library
 implementation and selftest
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

On Wed, 6 Nov 2019 at 17:41, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 23 Oct 2019 at 06:51, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Oct 17, 2019 at 09:09:19PM +0200, Ard Biesheuvel wrote:
> > > diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
> > > new file mode 100644
> > > index 000000000000..7ba00fcc6b60
> > > --- /dev/null
> > > +++ b/lib/crypto/blake2s-selftest.c
> > > @@ -0,0 +1,2093 @@
> > > +// SPDX-License-Identifier: GPL-2.0 OR MIT
> > > +/*
> > > + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> > > + */
> > > +
> > > +#include <crypto/blake2s.h>
> > > +#include <linux/string.h>
> > > +
> > > +static const u8 blake2s_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
> > [...]
> > > +bool __init blake2s_selftest(void)
> > > +{
> > > +     u8 key[BLAKE2S_KEY_SIZE];
> > > +     u8 buf[ARRAY_SIZE(blake2s_testvecs)];
> > > +     u8 hash[BLAKE2S_HASH_SIZE];
> > > +     size_t i;
> > > +     bool success = true;
> > > +
> > > +     for (i = 0; i < BLAKE2S_KEY_SIZE; ++i)
> > > +             key[i] = (u8)i;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i)
> > > +             buf[i] = (u8)i;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(blake2s_keyed_testvecs); ++i) {
> > > +             blake2s(hash, buf, key, BLAKE2S_HASH_SIZE, i, BLAKE2S_KEY_SIZE);
> > > +             if (memcmp(hash, blake2s_keyed_testvecs[i], BLAKE2S_HASH_SIZE)) {
> > > +                     pr_err("blake2s keyed self-test %zu: FAIL\n", i + 1);
> > > +                     success = false;
> > > +             }
> > > +     }
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i) {
> > > +             blake2s(hash, buf, NULL, BLAKE2S_HASH_SIZE, i, 0);
> > > +             if (memcmp(hash, blake2s_testvecs[i], BLAKE2S_HASH_SIZE)) {
> > > +                     pr_err("blake2s unkeyed self-test %zu: FAIL\n", i + i);
> > > +                     success = false;
> > > +             }
> > > +     }
> > > +     return success;
> > > +}
> >
> > The only tests here are for blake2s(), with 0 and 32-byte keys.  There's no
> > tests that incremental blake2s_update()s work correctly, nor any other key
> > sizes.  And these don't get tested properly by the blake2s-generic shash tests
> > either, because blake2s-generic has a separate implementation of the boilerplate
> > and calls blake2s_compress_generic() directly.  Did you consider implementing
> > blake2s-generic on top of blake2s_init/update/final instead?
> >
>
> That would make blake2s-generic use the accelerated implementations as
> well, which I tried to avoid.
>
> I will add some test cases here instead.
>
> > Also, blake2s_hmac() needs tests.
> >
>
> Ack

I cooked up another set of test cases for keyed and plain blake2s
which use arbitrary combinations of supported key and digest lengths.

The delta patch is at the top of this branch:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=wireguard-crypto-library-api-v5

The blake2s_hmac() code is actually broken: it ignores the 'outlen'
parameter except for the memcpy() at the end, which means it runs both
blake2s with the full length digest twice and then simply truncates it
at the end.

Given that blake2s hmac seems to be a WireGuard invention, which only
uses the full digest length, would anyone mind if I change this to
blake2s256_hmac() and drop the outlen parameter? Then, we at least
have parity with openssl HMAC() and EVP_blake2s256().
