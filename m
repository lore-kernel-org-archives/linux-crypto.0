Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9F8C5DF63
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 16:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D061D207FA
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 16:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bPeFIzK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfKFQlw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 11:41:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41374 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfKFQlv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 11:41:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id p4so26651699wrm.8
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 08:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLicJusTtVqTk35lmpaxskkunrWX4fLsYDVcICHRFpU=;
        b=bPeFIzK9I5w3n9sSJ4MvwMf2BxmaZc9/k6slVDq6wspYW6rDiIsXMN2nQ9kKG72Kv7
         xJWKKlqKeMRbZ9s5K5Dvv/xHoDJp+wNlGyOyYGQaHmnL2LgtH92cIIXeZLbMVyb/HD1w
         VzuzFjDQRJL6npbjpEmdxCgQEVysTgytNYXlMIKdg1fOnP4uQAUoBmxH0niYV9bOQIHc
         GLeeOu+n4CidZ38kqxbyjxY2Po28r1FaJjV8QWJXPyzQaIFS95U/pNFvD0VDWGetC5No
         XYx3MsXk9DFR4CeLNujLQcZm3aLe4g78iKVEoTK44jxh/67ieA4NLnKqsaeuVEUU5gOK
         DUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLicJusTtVqTk35lmpaxskkunrWX4fLsYDVcICHRFpU=;
        b=KJ3jPAlhfRdcXIL4ZQcm1mg1hkyctxS74YRStHCTp2KcfX6gNyMizKcPvcX3Mk9R+B
         gnRGZuU2dONktKnCJK3/pITtdXu5kSPW/gwRg+Tyh2ZcJABJcJkebGGyS7TLDtQMH/BF
         DBEIph2UkkQJzZflT3f8pJ8GY00hzlckMaTA6F7xLu5fNdlnLwJtj9qxgsDv1hJf3UB7
         Gx78wyzDsNdXdPzvphdubB+Vvy2BuvBeL2lt4F8zhN1hJQNwgTEnTBGdTJclMKp7U5u/
         GbpgpBwq1JgIw1Mb9ygsLEJhtKak2mf078kj9lnOHteUECBZKzjSOYgr+xJwcdqg7B+I
         Y29g==
X-Gm-Message-State: APjAAAULNVK5yNH/Q3qsqAfn5qhVMHS0DX5VQur0Sqt4IswROU0eprCm
        1VC6C2/LsqyGHOemwp93s7ULoRrM4FVhGWwozleDDg==
X-Google-Smtp-Source: APXvYqysRfe7stPqx8Az8yVosY3nKKdiEypdWfJvIQX/gBo0ij4ScJTmtI+dZfoy5LwKqBcAjokMnrdepoDLq3UQUuY=
X-Received: by 2002:adf:f685:: with SMTP id v5mr3747430wrp.246.1573058509034;
 Wed, 06 Nov 2019 08:41:49 -0800 (PST)
MIME-Version: 1.0
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-23-ard.biesheuvel@linaro.org> <20191023045157.GB361298@sol.localdomain>
In-Reply-To: <20191023045157.GB361298@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 6 Nov 2019 17:41:37 +0100
Message-ID: <CAKv+Gu_9rY6OBEZ9iZQ53CWRQbd+k64JL4Tuazn3BO3ohF2g6w@mail.gmail.com>
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

On Wed, 23 Oct 2019 at 06:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Oct 17, 2019 at 09:09:19PM +0200, Ard Biesheuvel wrote:
> > diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
> > new file mode 100644
> > index 000000000000..7ba00fcc6b60
> > --- /dev/null
> > +++ b/lib/crypto/blake2s-selftest.c
> > @@ -0,0 +1,2093 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR MIT
> > +/*
> > + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> > + */
> > +
> > +#include <crypto/blake2s.h>
> > +#include <linux/string.h>
> > +
> > +static const u8 blake2s_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
> [...]
> > +bool __init blake2s_selftest(void)
> > +{
> > +     u8 key[BLAKE2S_KEY_SIZE];
> > +     u8 buf[ARRAY_SIZE(blake2s_testvecs)];
> > +     u8 hash[BLAKE2S_HASH_SIZE];
> > +     size_t i;
> > +     bool success = true;
> > +
> > +     for (i = 0; i < BLAKE2S_KEY_SIZE; ++i)
> > +             key[i] = (u8)i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i)
> > +             buf[i] = (u8)i;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(blake2s_keyed_testvecs); ++i) {
> > +             blake2s(hash, buf, key, BLAKE2S_HASH_SIZE, i, BLAKE2S_KEY_SIZE);
> > +             if (memcmp(hash, blake2s_keyed_testvecs[i], BLAKE2S_HASH_SIZE)) {
> > +                     pr_err("blake2s keyed self-test %zu: FAIL\n", i + 1);
> > +                     success = false;
> > +             }
> > +     }
> > +
> > +     for (i = 0; i < ARRAY_SIZE(blake2s_testvecs); ++i) {
> > +             blake2s(hash, buf, NULL, BLAKE2S_HASH_SIZE, i, 0);
> > +             if (memcmp(hash, blake2s_testvecs[i], BLAKE2S_HASH_SIZE)) {
> > +                     pr_err("blake2s unkeyed self-test %zu: FAIL\n", i + i);
> > +                     success = false;
> > +             }
> > +     }
> > +     return success;
> > +}
>
> The only tests here are for blake2s(), with 0 and 32-byte keys.  There's no
> tests that incremental blake2s_update()s work correctly, nor any other key
> sizes.  And these don't get tested properly by the blake2s-generic shash tests
> either, because blake2s-generic has a separate implementation of the boilerplate
> and calls blake2s_compress_generic() directly.  Did you consider implementing
> blake2s-generic on top of blake2s_init/update/final instead?
>

That would make blake2s-generic use the accelerated implementations as
well, which I tried to avoid.

I will add some test cases here instead.

> Also, blake2s_hmac() needs tests.
>

Ack
