Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620E8C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01FF822D50
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438604AbgLLKYp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 05:24:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438603AbgLLKYj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 05:24:39 -0500
X-Gm-Message-State: AOAM530+xaKNxs4IWX1vFwtED/as/jioTycSy3Eh0CYZlSA4DYbIJyuX
        O7VwYUjl4qGKHPoyoahQNjXk93NY75eoqGIQkT0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607757876;
        bh=LFk/bFbBaLa8sIoViCOS2xA/UMpCtW509dPSQj5OyiE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=arcrHA9ncebBDfw1C3V6f9qVIK60eQq3GVSLtZEzWgZYXZr4ZMZw4DuD/G2Tvi2Y8
         KahzvF97RIVz0Qsx4D+c+F0rtHXqRMm/RQC7VpRrHbt2fhmh0c2bADHEmhfkdNNxey
         vbqW+wBzRD3wzTMb0DghLYFk9DJa2V1ZEo77TbiQQLXbXHlQR1OGRlPURn6zkdLgKK
         zkJ+VxVfGVxzm/7Zu6lPhZJbCtSET7AORswKTscpnSzOD2Hinb2V5LyhLZ4PYKjakO
         l6FUlDbr+PnDw48r8f9XA3I1/FEmemIA5I9c7gqaSoEdG6HCna2LlNbfil9ea8OLTs
         Od22f4a4GDv5A==
X-Google-Smtp-Source: ABdhPJylaMOKQi6GzGcqMhPxzXajQQBBGN9gqe1QPIbCuZ2QCaiQvKAal+b7kiraHyAPn2eqyO9JuUqtKXfk1AcBBjQ=
X-Received: by 2002:aca:b809:: with SMTP id i9mr12007508oif.174.1607757875411;
 Fri, 11 Dec 2020 23:24:35 -0800 (PST)
MIME-Version: 1.0
References: <20201103162809.28167-1-ardb@kernel.org> <X9RmlccBrwoY7zXS@sol.localdomain>
In-Reply-To: <X9RmlccBrwoY7zXS@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 12 Dec 2020 08:24:24 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEyZXKiiO55qRMyTGkThBspGnPAFdxRkc+d9H29AmhoZQ@mail.gmail.com>
Message-ID: <CAMj1kXEyZXKiiO55qRMyTGkThBspGnPAFdxRkc+d9H29AmhoZQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - optimize for non-block size multiples
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andre Przywara <andre.przywara@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 12 Dec 2020 at 07:43, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Ard,
>
> On Tue, Nov 03, 2020 at 05:28:09PM +0100, Ard Biesheuvel wrote:
> > @@ -42,24 +42,24 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
> >  {
> >       u8 buf[CHACHA_BLOCK_SIZE];
> >
> > -     while (bytes >= CHACHA_BLOCK_SIZE * 4) {
> > -             chacha_4block_xor_neon(state, dst, src, nrounds);
> > -             bytes -= CHACHA_BLOCK_SIZE * 4;
> > -             src += CHACHA_BLOCK_SIZE * 4;
> > -             dst += CHACHA_BLOCK_SIZE * 4;
> > -             state[12] += 4;
> > -     }
> > -     while (bytes >= CHACHA_BLOCK_SIZE) {
> > -             chacha_block_xor_neon(state, dst, src, nrounds);
> > -             bytes -= CHACHA_BLOCK_SIZE;
> > -             src += CHACHA_BLOCK_SIZE;
> > -             dst += CHACHA_BLOCK_SIZE;
> > -             state[12]++;
> > +     while (bytes > CHACHA_BLOCK_SIZE) {
> > +             unsigned int l = min(bytes, CHACHA_BLOCK_SIZE * 4U);
> > +
> > +             chacha_4block_xor_neon(state, dst, src, nrounds, l);
> > +             bytes -= l;
> > +             src += l;
> > +             dst += l;
> > +             state[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
> >       }
> >       if (bytes) {
> > -             memcpy(buf, src, bytes);
> > -             chacha_block_xor_neon(state, buf, buf, nrounds);
> > -             memcpy(dst, buf, bytes);
> > +             const u8 *s = src;
> > +             u8 *d = dst;
> > +
> > +             if (bytes != CHACHA_BLOCK_SIZE)
> > +                     s = d = memcpy(buf, src, bytes);
> > +             chacha_block_xor_neon(state, d, s, nrounds);
> > +             if (d != dst)
> > +                     memcpy(dst, buf, bytes);
> >       }
> >  }
> >
>
> Shouldn't this be incrementing the block counter after chacha_block_xor_neon()?
> It might be needed by the library API.
>

Yeah, good point. 'bytes' could be exactly CHACHA_BLOCK_SIZE now,
which wasn't the case before.

I'll send a fix.

> Also, even with that fixed, this patch is causing the self-tests (both the
> chacha20poly1305_selftest(), and the crypto API tests for chacha20-neon,
> xchacha20-neon, and xchacha12-neon) to fail when I boot a kernel in QEMU.  This
> doesn't happen on real hardware (Raspberry Pi 2), and I don't see any other bugs
> in this patch, so I'm not sure what the problem is.  Did you run the self-tests
> on every platform you tested this on?
>

Does your QEMU lack this patch? I found that bug working on this code.

https://git.qemu.org/?p=qemu.git;a=commitdiff;h=604cef3e57eaeeef77074d78f6cf2eca1be11c62
