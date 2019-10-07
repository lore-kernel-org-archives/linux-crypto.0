Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043E5C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C193D205C9
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570464321;
	bh=tZ52lW+2owZ6FS8euu9Nt3i0FCpurv5BeoGCv2dYG3s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=tNlLRLH4DqHOZBVjNRQADsWROgW+I6tHSCAFTylQ9Qm42/WwMFAI/roEcYWMXEg/G
	 EsnrW1qj4lcEPmXvhCNEQXS1PVJv51Em0nceXx/auyporIW15m4IYEIlp5GtORglPU
	 erN8FBaTgwnh3l5k3z1t0jAXFCbpv1BZiJtyzBQs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfJGQFU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbfJGQFU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:05:20 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D285C205C9
        for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2019 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570464319;
        bh=tZ52lW+2owZ6FS8euu9Nt3i0FCpurv5BeoGCv2dYG3s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VkuU+YoIU5W6SZLGb2McUzcOZB3NJf2191T66r4PcBZsw0EosDDPIhFV5LrC0Da24
         Hx8b52vSREg5zQK8UgMHkulwcy/yRJaP9vm6ks2f3JgbjaMYQ9uqY4NNSQV8rLdHcH
         XYjOAiP5TQzXvPl0ZHm+mSUIFvXtDFfWXRePNuRI=
Received: by mail-wr1-f43.google.com with SMTP id o18so15947113wrv.13
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:05:18 -0700 (PDT)
X-Gm-Message-State: APjAAAUqGLgyUB21OBVhoyaY2uY1JMO2wcZ9iDoTh7i5Ln7JxtY2rMrC
        ZdBjJtcHfJHHLnKy9bHh41XYt6KlnPZBEV2uWr/0ig==
X-Google-Smtp-Source: APXvYqxt2Ft7TRJQPkWnG0+SWoAhkDWxKaZZBY5ChQ4TEulQhELWUtfKz6md9frIu0mI7A5zNxJmsUicBtgvJ2HpGbg=
X-Received: by 2002:a05:6000:1632:: with SMTP id v18mr24495521wrb.61.1570464317306;
 Mon, 07 Oct 2019 09:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
 <04D32F59-34D4-4EBF-80E3-69088D14C5D8@amacapital.net> <CAKv+Gu8s6AuZfdVUSmpgi-eY_9oZr-j4sdFygUOR3uvQXji+rQ@mail.gmail.com>
 <CALCETrXWSu_fY5BetMah=iEOqSgkOphMOKcMrtiWyN0QqbZspw@mail.gmail.com> <CAKv+Gu8u8Oco==YRPSa4mq_eZyUcB_Apj-k_vo=7WvTwCp8k+A@mail.gmail.com>
In-Reply-To: <CAKv+Gu8u8Oco==YRPSa4mq_eZyUcB_Apj-k_vo=7WvTwCp8k+A@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 7 Oct 2019 09:05:05 -0700
X-Gmail-Original-Message-ID: <CALCETrXes_vNPXurB91VH0nZYiZRYrDMDhOy6jrw=tMFiT_nGA@mail.gmail.com>
Message-ID: <CALCETrXes_vNPXurB91VH0nZYiZRYrDMDhOy6jrw=tMFiT_nGA@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

On Mon, Oct 7, 2019 at 8:12 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Mon, 7 Oct 2019 at 17:02, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > On Sun, Oct 6, 2019 at 10:24 PM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Mon, 7 Oct 2019 at 06:44, Andy Lutomirski <luto@amacapital.net> wrote:
> > > >
> >
> > > > > Actually, this can be addressed by retaining the module dependencies
> > > > > as before, but permitting the arch module to be omitted at load time.
> > > >
> > > > I think that, to avoid surprises, you should refuse to load the arch module if the generic module is loaded, too.
> > > >
> > >
> > > Most arch code depends on CPU features that may not be available given
> > > the context, either because they are SIMD or because they are optional
> > > CPU instructions. So we need both modules at the same time anyway, so
> > > that we can fall back to the generic code at runtime.
> > >
> > > So what I'd like is to have the generic module provide the library
> > > interface, but rely on arch modules that are optional.
> > >
> > > We already have 95% of what we need with weak references. We have the
> > > ability to test for presence of the arch code at runtime, and we even
> > > have code patching for all architectures (through static relocations).
> > >
> > > However, one could argue that this is more a [space] optimization than
> > > anything else, so I am willing to park this discussion until support
> > > for static calls has been merged, and proceed with something simpler.
> >
> > I'd suggest tabling it until static calls are merged.  PeterZ just
> > sent a new patchbomb for it anyway.
> >
>
> As it turns out, static calls are a poor fit for this. Imagine an interface like
>
> poly1305_init(state)
> poly1305_update(state, input)
> poly1305_fina(state, digest)
>
> which can be implemented by different libraries. The problem is that
> state is opaque, and so it is generally not guaranteed that a sequence
> that was started using one implementation can be completed using
> another one.
>
> Since the whole point is having a simple library interface,
> complicating this with RCU hooks or other crazy plumbing to ensure
> that no calls are in progress when you switch one out for another one,
> I don't think static calls are suitable for this use case.
>
> > What I'm trying to get at here and apparently saying badly is that I
> > want to avoid a situation where lsmod shows the arch module loaded but
> > the arch code isn't actually executing.
>
> My goal here is to allow the generic library to be loaded with or
> without the arch code, with the arch code always being used when it is
> loaded. This is what I implemented using weak references, but it
> requires a tweak in the module loader (two lines but not pretty).
> Using weak references preserves the dependency order, since the
> generic module will depend on the arch module (and up the refcount) it
> any of its weak references were fulfilled by the arch module in
> question. Using static calls will invert the dependency relation,
> since the arch code will need to perform a static_call_update() to
> make [users of] the generic library point to its code. How this works
> with managing the module refcounts and unload order is an open
> question afaict.

Indeed.  Dealing with unloading when static calls are in use may be messy.

>
> > Regardless of how everything
> > gets wired up (static calls, weak refs, etc), the system's behavior
> > should match the system's configuration, which means that we should
> > not allow any improper order of loading things so that everything
> > *appears* to be loaded but does not actually function.
> >
>
> Yes. that is the whole point.
>
> > Saying "modprobe will do the right thing and let's not worry about
> > silly admins using insmod directly" is not a good solution.
>
> Agreed.
>
> I have disregarded static calls and weak references for the time
> being, and I will proceed with an implementation that uses neither.
> The downside of this is that, e.g., we are forced to load the NEON
> module on non-NEON capable hardware without calling any of its code,
> but this is basically the Zinc situation only with the NEON and the
> generic code living in different modules.

Makes sense.  It can always be improved after the initial
implementation is merged.
