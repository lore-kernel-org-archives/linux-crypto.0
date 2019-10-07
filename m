Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FAEECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B2E21479
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 15:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QTaJ84Wi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfJGPMZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 11:12:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40742 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGPMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 11:12:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so7043849wrv.7
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 08:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1p0OfMCa1ZqMu/HdbF1dLDmeHh9sQqaQGFSoVRKm5g=;
        b=QTaJ84Wivj7ViFOasFVFZ2dj3Ot1OiE2g5DXLSCzVjsUMWFY2H0dAS45UW9hWWVwzL
         Q0hHXHU/1YTE+ug+myO81k09ekHkqNCxxnTX32Z7qwMNT7OKBolffIXGjsBCZ5NFwUJj
         igamA4/udJcnx3K8Ziup7t2I+Ro8dcH8goRio8o1oHq5h4csLYQi+SKLeb6dthcKdX5t
         E8a5xomZja3uh8K4VQmQvTVrkVoB8MuRt1XRQKRVRLFYLKWYcVW34r5jPPZV9CXPfyic
         mN48uxmspZIBO4U+XImplR64xRTIF66ofLHuTRF3rByJ5r/23qTyebnTrmYRp2HAPWAt
         6ugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1p0OfMCa1ZqMu/HdbF1dLDmeHh9sQqaQGFSoVRKm5g=;
        b=h9bQir0HZyCtZMjNK66k9UOFVdAaD3hpudS118M/ngh50NWPUPox61gpRc41kL6r3Y
         Alip6pwXWsMZ3vTWs/9wIlJYPjg5Sx85IruaQZwjGa37ABFDpDpzAiSyigZWmXWNnt80
         XMUu1w4bAQjgxpinJ1+JBawRdy2yf6pKd09v9Wb1xPrjcFbYQeVV4fuIB0XS1zMFO4Zn
         jF6piFvb7vbaet5m4rtDYZIRwqgl0Y8CET+1EoUTjK1GEDp6e3+IwkBUQNlXHczujIc0
         92NJsHrf4ysoDlhZVH+WBi2dPe/TI8UN7beENP+8Vlmawv+u4lnS9NEwY0yNh/yQN8Wd
         5ubg==
X-Gm-Message-State: APjAAAUqyHe9t5iZu03UXyAHYy3XR9EkEPqsU/FbVdID8n8cghSHLZAS
        7bg1zPCdLtbqI+gnm6voabkHCuilcZajdylsjc+zItCq6kkoaw==
X-Google-Smtp-Source: APXvYqx1MqcW7TT6IaHEc4cib4f2mjj7xUdUToqMJEMDNT+kyY1mcNR+HdldSYOJDYqqccdkWdTcAkRaMRawj533188=
X-Received: by 2002:adf:fb11:: with SMTP id c17mr24339838wrr.0.1570461141884;
 Mon, 07 Oct 2019 08:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
 <04D32F59-34D4-4EBF-80E3-69088D14C5D8@amacapital.net> <CAKv+Gu8s6AuZfdVUSmpgi-eY_9oZr-j4sdFygUOR3uvQXji+rQ@mail.gmail.com>
 <CALCETrXWSu_fY5BetMah=iEOqSgkOphMOKcMrtiWyN0QqbZspw@mail.gmail.com>
In-Reply-To: <CALCETrXWSu_fY5BetMah=iEOqSgkOphMOKcMrtiWyN0QqbZspw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 7 Oct 2019 17:12:10 +0200
Message-ID: <CAKv+Gu8u8Oco==YRPSa4mq_eZyUcB_Apj-k_vo=7WvTwCp8k+A@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 7 Oct 2019 at 17:02, Andy Lutomirski <luto@amacapital.net> wrote:
>
> On Sun, Oct 6, 2019 at 10:24 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Mon, 7 Oct 2019 at 06:44, Andy Lutomirski <luto@amacapital.net> wrote:
> > >
>
> > > > Actually, this can be addressed by retaining the module dependencies
> > > > as before, but permitting the arch module to be omitted at load time.
> > >
> > > I think that, to avoid surprises, you should refuse to load the arch module if the generic module is loaded, too.
> > >
> >
> > Most arch code depends on CPU features that may not be available given
> > the context, either because they are SIMD or because they are optional
> > CPU instructions. So we need both modules at the same time anyway, so
> > that we can fall back to the generic code at runtime.
> >
> > So what I'd like is to have the generic module provide the library
> > interface, but rely on arch modules that are optional.
> >
> > We already have 95% of what we need with weak references. We have the
> > ability to test for presence of the arch code at runtime, and we even
> > have code patching for all architectures (through static relocations).
> >
> > However, one could argue that this is more a [space] optimization than
> > anything else, so I am willing to park this discussion until support
> > for static calls has been merged, and proceed with something simpler.
>
> I'd suggest tabling it until static calls are merged.  PeterZ just
> sent a new patchbomb for it anyway.
>

As it turns out, static calls are a poor fit for this. Imagine an interface like

poly1305_init(state)
poly1305_update(state, input)
poly1305_fina(state, digest)

which can be implemented by different libraries. The problem is that
state is opaque, and so it is generally not guaranteed that a sequence
that was started using one implementation can be completed using
another one.

Since the whole point is having a simple library interface,
complicating this with RCU hooks or other crazy plumbing to ensure
that no calls are in progress when you switch one out for another one,
I don't think static calls are suitable for this use case.

> What I'm trying to get at here and apparently saying badly is that I
> want to avoid a situation where lsmod shows the arch module loaded but
> the arch code isn't actually executing.

My goal here is to allow the generic library to be loaded with or
without the arch code, with the arch code always being used when it is
loaded. This is what I implemented using weak references, but it
requires a tweak in the module loader (two lines but not pretty).
Using weak references preserves the dependency order, since the
generic module will depend on the arch module (and up the refcount) it
any of its weak references were fulfilled by the arch module in
question. Using static calls will invert the dependency relation,
since the arch code will need to perform a static_call_update() to
make [users of] the generic library point to its code. How this works
with managing the module refcounts and unload order is an open
question afaict.

> Regardless of how everything
> gets wired up (static calls, weak refs, etc), the system's behavior
> should match the system's configuration, which means that we should
> not allow any improper order of loading things so that everything
> *appears* to be loaded but does not actually function.
>

Yes. that is the whole point.

> Saying "modprobe will do the right thing and let's not worry about
> silly admins using insmod directly" is not a good solution.

Agreed.

I have disregarded static calls and weak references for the time
being, and I will proceed with an implementation that uses neither.
The downside of this is that, e.g., we are forced to load the NEON
module on non-NEON capable hardware without calling any of its code,
but this is basically the Zinc situation only with the NEON and the
generic code living in different modules.
