Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15293ECE588
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB2702089C
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fpbUamZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbfJOKM6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:12:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45263 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbfJOKM6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 06:12:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so23058831wrm.12
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2019 03:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OFpENs/PN2nUro9OrNM8LsgBZDJfT5VvqwGFbZvHNY8=;
        b=fpbUamZ2tfiWR5n1UNPKwLUc2xDeqOVG/pjSPzUAny6yphTcFCG3iV1MtuQ8MVJgkn
         jWL89r0nLV0y7rK5uhFop61NkghDT6jsg9zyE57uD74yuVIZGgOh7544r8Xy+UEjWLzV
         ENvN/csbsb4XFYLsV/AQmOvJv15hoEQXqBT6oSWbYq7NJ5gw783KzXkhUzJYIxQMJyD4
         PSA9xX6quefgbCSJc7iOZkNTiv+AZHI5UMnAKBEIw9uJWXHUy5mrQNnYZMZgs1sIsF+7
         0rK8fkM779wJ0g8GCxtJNqbWrtxJKUHfK/RxqVnQYFXnektrMZwJx4H3o4mNrEOiAA5/
         y9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OFpENs/PN2nUro9OrNM8LsgBZDJfT5VvqwGFbZvHNY8=;
        b=pq0xuuz9pF6CgkUmi7JxulMPhElmWjfLZ+SSTIMuT4a6TXt5mR1LUt8OcZMsPSsu2k
         zYwU22R7tqSPkF8d147q9ONNU1DIh4gVComdTUuk74jgNYhAfYQSWRs5m2iWL4518u3w
         EeteifgwKZnp+URgsivNZo23SjWw0axWdrhK+6VgMy8lH4O6xrn0kS5QZInb/kONY+iq
         QRGVg3YcUvUDVyZe/dEKEfd1ExGLKdBczm5q0UpfdiPe0zdKlRxx0uW29pixR4zwB9Fl
         KqTRvOAsqwf0wZ/AqI7zCeeQCKaHC20oeOb0fc0F8xcStTj9YMynkaVPtBQBAF/BpUcC
         J6SA==
X-Gm-Message-State: APjAAAWsOg/X9amjhDVFbE2li0yBdJcrZcu/1y0zI4bHzqKMhNse9m8Y
        Atkb0basCabBLw91zsZbHv6R4PUmP1GacJLZbloYmA==
X-Google-Smtp-Source: APXvYqwR7hVT4xxa4vSU1/Cd/68oWbLvy4I74xkCRlBpXtarClZGdSW8rlKqnRzB7+G8rLrK9TO1fSMkqed0VfKcwOA=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr28597538wrf.325.1571134374116;
 Tue, 15 Oct 2019 03:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-3-ard.biesheuvel@linaro.org> <8021f3ad396dead64fca36cef018c914f9a3a55d.camel@strongswan.org>
In-Reply-To: <8021f3ad396dead64fca36cef018c914f9a3a55d.camel@strongswan.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 15 Oct 2019 12:12:43 +0200
Message-ID: <CAKv+Gu8NcgnxJS5TMKhfLF+NYeB+vYWUDzrP87Hck4-FQ0jShQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/29] crypto: x86/chacha - depend on generic chacha
 library instead of crypto driver
To:     Martin Willi <martin@strongswan.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Oct 2019 at 12:00, Martin Willi <martin@strongswan.org> wrote:
>
> Hi Ard,
>
> > Since turning the FPU on and off is cheap these days, simplify the
> > SIMD routine by dropping the per-page yield, which makes for a
> > cleaner switch to the library API as well.
>
> In my measurements that lazy FPU restore works as intended, and I could
> not identify any slowdown by this change.
>

Thanks for confirming.

> > +++ b/arch/x86/crypto/chacha_glue.c
> > @@ -127,32 +127,32 @@ static int chacha_simd_stream_xor [...]
> >
> > +     do_simd = (walk->total > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
>
> Given that most users (including chacha20poly1305) likely involve
> multiple operations under the same (real) FPU save/restore cycle, those
> length checks both in chacha and in poly1305 hardly make sense anymore.
>
> Obviously under tcrypt we get better results when engaging SIMD for any
> length, but also for real users this seems beneficial. But of course we
> may defer that to a later optimization patch.
>

Given that the description already reasons about FPU save/restore
being cheap these days, I think it would be appropriate to just get
rid of it right away. Especially in the chacha20poly1305 case, where
the separate chacha invocation for the poly nonce is guaranteed to
fail this check, we basically end up going back and forth between the
scalar and the SIMD code, which seems rather suboptimal to me.
