Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81908C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5633520679
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UT3H9B2K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfKSP7Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:59:24 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39065 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfKSP7Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:59:24 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so4297787wmi.4
        for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2019 07:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kfNoRXWKFGkDRV0DfZM6alVug/n4iQKyInT5nlXcEY=;
        b=UT3H9B2K5h1aZ9OoJdw0Z24Kl86bRaqLI9fNRm+RMVQt6W4mEw2OkZLEYdZXTMFrfw
         LVTmUvzIfU1AGVaqMMKnZx2R3n1HSe9PhvU6FUK8OPyQe0jE7K/WMOAKkNg2Ye01OQ6S
         Ev39iU8ZFDt1rQO8KQaYQUD6S5tBQbMZh2+hoJ9A9XT4YEOb7rD/eA2ISvtoY8ZAPZmf
         GJ51HrraYmJTNA6ujHRLPGIS5656WjhiPEqz2NKzC2vLgKvQ1RRqeIxGaAbLeAK/cBhm
         CnBFw8ekJ0wszwI57K6ns5gErLu3Hk4uMyOKrcaYhFnKhVCFecRvu9ma++wO/pQyosX9
         FcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kfNoRXWKFGkDRV0DfZM6alVug/n4iQKyInT5nlXcEY=;
        b=EaqAmD8HtfMdIBDygubCmNRkgxf1OZ+A9Z6eojrr+2vYCVsF4Q/h/AHm4lL2CC5vVn
         UmcW/Td2IEs2+6WJnLPpmZwPy9EMaohMOiKGfVJIncmyMX/ibmAndKsLlUw5AcgArY7I
         OxHp782YQQwA4JB9iQRJ8EM/KFPPTSMMxFtDBhripIoJTqFzqX8tpTBmoQgsKe2tRQra
         zbYNMpjwFi22mqOWX/MMePW8td8EFKVYNVStAqHiYy5y2hv2kCBy1EpDW7CLSRvs5peU
         DYteAWzZ4Jgs4kzTRlzDTsns66qO3ozfk/Sks7ALa43nSSkSeDts2AAru6jGq9x1DRhm
         jTwQ==
X-Gm-Message-State: APjAAAVdf0KN2y9LaEmlr7nyv9VqMuw2HpQphmfI5yDwFvJXFKsKw6R7
        531WI13/jnIkjT05i+vwYsLCenqbE6qh070zkpzjIg==
X-Google-Smtp-Source: APXvYqx3Cl5Eabpl8ugB/eExTwmGL98Q6OBvbhfqnbMJ30U6MNBXAJ+P5f60WqPCgUz0HpJoW/hFX7cBwa7/xZzjrVI=
X-Received: by 2002:a1c:b1c3:: with SMTP id a186mr6784741wmf.10.1574179161649;
 Tue, 19 Nov 2019 07:59:21 -0800 (PST)
MIME-Version: 1.0
References: <20191108122240.28479-1-ardb@kernel.org> <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com>
 <20191115090921.jn45akou3cw4flps@gondor.apana.org.au> <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
 <CAKv+Gu96xbhS+yHbEjx6dD-rOcB8QYp-Gnnc3WMWfJ9KVbJzcg@mail.gmail.com> <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
In-Reply-To: <CAHmME9qRwA6yjwzoy=awWdyz40Lozf01XY2xxzYLE+G8bKsMzA@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 19 Nov 2019 16:59:10 +0100
Message-ID: <CAKv+Gu8mDrP9YyzXcN0x6sj8ehMcg01Ea8mU8d90chLyOrV4Eg@mail.gmail.com>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for WireGuard
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 Nov 2019 at 16:44, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Nov 19, 2019 at 4:34 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> > > - Zinc's generic C implementation of poly1305, which is faster and has
> > > separate implementations for u64 and u128.
>
> I assume your AndyP comment below didn't apply to this top item here.
> This one should be fairly uncontroversial in your opinion, right?
>

Yes.

> > > - x86_64 ChaCha20 from Zinc. Will be fun to discuss with Martin and Andy.
> > > - x86_64 Poly1305 from Zinc.
> >
> > As I pointed out in the private discussions we had, there are two
> > aspects two AndyP's benchmarking that don't carry over 100% to the
> > Linux kernel:
> > - Every microarchitecture is given equal weight, regardless of the
> > likelihood that the code will actually run on it. This makes some
> > sense for OpenSSL, I guess, but not for the kernel.
> > - Benchmarks are typically based on the performance of the core
> > cryptographics transformation rather than a representative workload.
> > This is especially relevant for network use cases, where packet sizes
> > are not necessarily fixed and usually not a multiple of the block size
> > (as opposed to disk encryption, where every single call is the same
> > size and a power of 2)
> >
> > So for future changes, could we please include performance numbers
> > based on realistic workloads?
>
> Yea I share your concerns here. From preliminary results, I think the
> Poly1305 code will be globally better, and I don't think we'll need an
> abundance of discussion about it.
>

Good.

> The ChaCha case is more interesting. I'll submit this with lots of
> packet-sized microbenchmarks, as well as on-the-wire WireGuard
> testing. Eric - I'm guessing you don't care too much about Adamantium
> performance on x86 where people are probably better off with AES-XTS,
> right? Are there other specific real world cases we care about? IPsec
> is another one, but those concerns, packet-size wise, are more or less
> the same as for WireGuard. But anyway, we can cross this bridge when
> we come to it.
>

As long as we can show that WireGuard really benefits without
regressing other users disproportionately, I think we're fine. There
are not /that/ many users to begin with ...

>
> > > - WireGuard! Hurrah!
> > >
> > I'm a bit surprised that this only appears at the end of your list :-)
>
> Haha, "last but not least" :)
>
> >
> > > If you have any feedback on how you'd like this prioritized, please
> > > pipe up. For example Dave - would you like WireGuard *now* or sometime
> > > later? I can probably get that cooking this week, though I do have
> > > some testing and fuzzing of it to do on top of the patches that just
> > > landed in cryptodev.
> > >
> >
> > We're at -rc8, and wireguard itself will not go via the crypto tree so
> > you should wait until after the merge window, rebase it onto -rc1 and
> > repost it.
>
> Thanks, yea, that makes sense. Netdev also has its own merge window
> schedule that I should aim to meet. I guess, based on this if I'm
> understanding correctly, we're looking at WireGuard for 5.5?
>

No, v5.6. The merge window for v5.5 will open this Sunday, so you'll
need to rebase on v5.5-rc1 once it is released, which will [hopefully]
have all the crypto pieces you need.

Note that this applies equally to the other changes: we can queue
performance tweaks in the crypto tree in parallel, and they will all
hit v5.6 at the same time.
