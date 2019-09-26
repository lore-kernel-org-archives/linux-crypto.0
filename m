Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F68EC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 12:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AA42053B
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 12:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dFDT0ENL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfIZMHi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 08:07:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36846 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfIZMHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 08:07:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so2472952wrd.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 05:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lgz3ykn0J1611V8g8NNmnl+h8BpKmtD1iteZu1IiJJw=;
        b=dFDT0ENLfXt9uaJ50Aw2h7K4yxCgH9ZtEkIQvBhv0T3oGn4Qbjc7Z47N2womRSoVNg
         2TI0kIsniShBBDTw1bGlXCy9WsEvIwCkMfpWcuIUXeHC6p1JmluKcFkwEGpfFeOX81KG
         UqYrANPaqOkNnd0hRGJdpVycC7YbPvuK4fahirQoiHJyVQ6np5yMH42pACMbwxw0sjt7
         xRE+nZ96M/uNcOZFbKQ+7HpIjar845wIy77tofEcNeMFOfRidpQzGl8tNk/1pfCPGgFj
         iPoohC9WiqXFh0vA6WH2g0q5/v0yNsevGFoivZW37IcjCPAihP0ThyrnyZXdqfdPhNRN
         HPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lgz3ykn0J1611V8g8NNmnl+h8BpKmtD1iteZu1IiJJw=;
        b=feYwEfQOfc6gYRGZ9dpDVBkndZrpPJ0w+gBrIALdv9lT/DAXdx/bnfYZGvlRgn5sod
         0+EAQmumglOv8e0LCZffomUW87JgZM95kihlNSD7eJjXZzYLsBaAfmInyhvrKogOF4pm
         1gnpbYCtE+iik9aWV5+vrI9+mO23zz6AxBnrQfjjRMYMMI0igb1a8F0ZVtWWIufDC7T7
         izOvia+rUfuBpRN90n3wAMqTwMAq7foaxtAkOy+vHkLeaWksg3AHedqSDx02sJVSFS2L
         fDSWY1WflU3F8jYdydyILtAzika65D+04Q4bysXnXZG0+SK2dtM5tkhbucDmaH2DOpFG
         KnLg==
X-Gm-Message-State: APjAAAVpYEczIQbLHEojbE1XqPi9ROQlcY5dWDR1uTzKb/pVboBjvsX2
        9oiR7z26Q1g9y4ir82R2IqjyhIuwRVAl2sQAU2DXyw==
X-Google-Smtp-Source: APXvYqxKJAKiVTi/SM/k4makQ9seBUM/RCtYkaz2l9Eht9UxGhazoIK8qhJz/i4JA4NO9LK9VHa8LpvfPqiFYsibAmk=
X-Received: by 2002:adf:de08:: with SMTP id b8mr2634015wrm.200.1569499655200;
 Thu, 26 Sep 2019 05:07:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org> <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
In-Reply-To: <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 26 Sep 2019 14:07:23 +0200
Message-ID: <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
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
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Sep 2019 at 10:59, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
...
>
> Instead what we=E2=80=99ve wound up with in this series is a Frankenstein=
=E2=80=99s
> monster of Zinc, which appears to have basically the same goal as
> Zinc, and even much of the same implementation just moved to a
> different directory, but then skimps on making it actually work well
> and introduces problems. (I=E2=80=99ll elucidate on some specific issues =
later
> in this email so that we can get on the same page with regards to
> security requirements for WireGuard.) I surmise from this Zinc-but-not
> series is that what actually is going on here is mostly some kind of
> power or leadership situation, which is what you=E2=80=99ve described to =
me
> also at various other points and in person.

I'm not sure what you are alluding to here. I have always been very
clear about what I like about Zinc and what I don't like about Zinc.

I agree that it makes absolutely no sense for casual, in-kernel crypto
to jump through all the hoops that the crypto API requires. But for
operating on big chunks of data on the kernel heap, we have an
existing API that we should leverage if we can, and fix if we need to
so that all its users can benefit.

> I also recognize that I am
> at least part way to blame for whatever dynamic there has stagnated
> this process; let me try to rectify that:
>
> A principle objection you=E2=80=99ve had is that Zinc moves to its own
> directory, with its own name, and tries to segment itself off from the
> rest of the crypto API=E2=80=99s infrastructure. You=E2=80=99ve always fe=
lt this
> should be mixed in with the rest of the crypto API=E2=80=99s infrastructu=
re
> and directory structures in one way or another. Let=E2=80=99s do both of =
those
> things =E2=80=93 put this in a directory structure you find appropriate a=
nd
> hook this into the rest of the crypto API=E2=80=99s infrastructure in a w=
ay
> you find appropriate. I might disagree, which is why Zinc does things
> the way it does, but I=E2=80=99m open to compromise and doing things more=
 your
> way.
>

It doesn't have to be your way or my way. The whole point of being
part of this community is that we find solutions that work for
everyone, through discussion and iterative prototyping. Turning up out
of the blue with a 50,000 line patch set and a take-it-or-leave-it
attitude goes counter to that, and this is why we have made so little
progress over the past year.

But I am happy with your willingness to collaborate and find common
ground, which was also my motivation for spending a considerable
amount of time to prepare this patch set.

> Another objection you=E2=80=99ve had is that Zinc replaces many existing
> implementations with its own. Martin wasn=E2=80=99t happy about that eith=
er.
> So let=E2=80=99s not do that, and we=E2=80=99ll have some wholesale repla=
cement of
> implementations in future patchsets at future dates discussed and
> benched and bikeshedded independently from this.
>
> Finally, perhaps most importantly, Zinc=E2=80=99s been my design rather t=
han
> our design. Let=E2=80=99s do this together instead of me git-send-email(1=
)-ing
> a v37.
>
> If the process of doing that together will be fraught with difficulty,
> I=E2=80=99m still open to the =E2=80=9C7 patch series=E2=80=9D with the u=
gly cryptoapi.c
> approach, as described at the top.

If your aim is to write ugly code and use that as a munition

> But I think if we start with Zinc
> and whittle it down in accordance with the above, we=E2=80=99ll get somet=
hing
> mutually acceptable, and somewhat similar to this series, with a few
> important exceptions, which illustrate some of the issues I see in
> this RFC:
>
> Issue 1) No fast implementations for the =E2=80=9Cit=E2=80=99s just funct=
ions=E2=80=9D interface.
>
> This is a deal breaker. I know you disagree here and perhaps think all
> dynamic dispatch should be by loadable modules configured with
> userspace policy and lots of function pointers and dynamically
> composable DSL strings, as the current crypto API does it. But I think
> a lot of other people agree with me here (and they=E2=80=99ve chimed in
> before) that the branch predictor does things better, doesn=E2=80=99t hav=
e
> Spectre issues, and is very simple to read and understand. For
> reference, here=E2=80=99s what that kind of thing looks like: [2].
>

This is one of the issues in the 'fix it for everyone else as well'
category. If we can improve the crypto API to be less susceptible to
these issues (e.g., using static calls), everybody benefits. I'd be
happy to collaborate on that.

> In this case, the relevance is that the handshake in WireGuard is
> extremely performance sensitive, in order to fend off DoS. One of the
> big design gambits in WireGuard is =E2=80=93 can we make it 1-RTT to redu=
ce
> the complexity of the state machine, but keep the crypto efficient
> enough that this is still safe to do from a DoS perspective. The
> protocol succeeds at this goal, but in many ways, just by a hair when
> at scale, and so I=E2=80=99m really quite loathe to decrease handshake
> performance.
...
> Taken together, we simply can=E2=80=99t skimp on the implementations avai=
lable
> on the handshake layer, so we=E2=80=99ll need to add some form of
> implementation selection, whether it=E2=80=99s the method Zinc uses ([2])=
, or
> something else we cook up together.
>

So are you saying that the handshake timing constraints in the
WireGuard protocol are so stringent that we can't run it securely on,
e.g., an ARM CPU that lacks a NEON unit? Or given that you are not
providing accelerated implementations of blake2s or Curve25519 for
arm64, we can't run it securely on arm64 at all?

Typically, I would prefer to only introduce different versions of the
same algorithm if there is a clear performance benefit for an actual
use case.

Framing this as a security issue rather than a performance issue is
slightly disingenuous, since people are less likely to challenge it.
But the security of any VPN protocol worth its salt should not hinge
on the performance delta between the reference C code and a version
that was optimized for a particular CPU.

> Issue 2) Linus=E2=80=99 objection to the async API invasion is more corre=
ct
> than he realizes.
>
> I could re-enumerate my objections to the API there, but I think we
> all get it. It=E2=80=99s horrendous looking. Even the introduction of the
> ivpad member (what on earth?) in the skb cb made me shutter.

Your implementation of RFC7539 truncates the nonce to 64-bits, while
RFC7539 defines a clear purpose for the bits you omit. Since the Zinc
library is intended to be standalone (and you are proposing its use in
other places, like big_keys.c), you might want to document your
justification for doing so in the general case, instead of ridiculing
the code I needed to write to work around this limitation.

> But
> there=E2=80=99s actually another issue at play:
>
> wg_noise_handshake_begin_session=E2=86=92derive_keys=E2=86=92symmetric_ke=
y_init is all
> part of the handshake. We cannot afford to allocate a brand new crypto
> object, parse the DSL string, connect all those function pointers,
> etc.

Parsing the string and connecting the function pointers happens only
once, and only when the transform needs to be instantiated from its
constituent parts. Subsequent invocations will just grab the existing
object.

> The allocations involved here aren=E2=80=99t really okay at all in that
> path. That=E2=80=99s why the cryptoapi.c idea above involves just using a=
 pool
> of pre-allocated objects if we=E2=80=99re going to be using that API at a=
ll.
> Also keep in mind that WireGuard instances sometimes have hundreds of
> thousands of peers.
>

My preference would be to address this by permitting per-request keys
in the AEAD layer. That way, we can instantiate the transform only
once, and just invoke it with the appropriate key on the hot path (and
avoid any per-keypair allocations)

> I=E2=80=99d recommend leaving this synchronous as it exists now, as Linus
> suggested, and we can revisit that later down the road. There are a
> number of improvements to the async API we could make down the line
> that could make this viable in WireGuard. For example, I could imagine
> decoupling the creation of the cipher object from its keys and
> intermediate buffers, so that we could in fact allocate the cipher
> objects with their DSLs globally in a safe way, while allowing the
> keys and working buffers to come from elsewhere. This is deep plumbing
> into the async API, but I think we could get there in time.
>

My changes actually move all the rfc7539() intermediate buffers to the
stack, so the only remaining allocation is the per-keypair one.

> There=E2=80=99s also a degree of practicality: right now there is zero Ch=
aPoly
> async acceleration hardware anywhere that would fit into the crypto
> API. At some point, it might come to exist and have incredible
> performance, and then we=E2=80=99ll both feel very motivated to make this=
 work
> for WireGuard. But it might also not come to be (AES seems to have won
> over most of the industry), in which case, why hassle?
>

As I already pointed out, we have supported hardware already: CAAM is
in mainline, and Inside-Secure patches are on the list.

> Issue 3) WireGuard patch is out of date.
>
> This is my fault, because I haven=E2=80=99t posted in a long time. There =
are
> some important changes in the main WireGuard repo. I=E2=80=99ll roll anot=
her
> patch soon for this so we have something recent to work off of. Sorry
> about that.
>

This is the reason I included your WG patch verbatim, to make it
easier to rebase to newer versions. In fact, I never intended or
expected anything but discussion from this submission, let alone
anyone actually merging it :-)

> Issue 4) FPU register batching?
>
> When I introduced the simd_get/simd_put/simd_relax thing, people
> seemed to think it was a good idea. My benchmarks of it showed
> significant throughput improvements. Your patchset doesn=E2=80=99t have
> anything similar to this.

It uses the existing SIMD batching, and enhances it slightly for the
Poly1305/shash case.

> But on the other hand, last I spoke with the
> x86 FPU guys, I thought they might actually be in the process of
> making simd_get/put obsolete with some internal plumbing to make
> restoration lazier. I=E2=80=99ll see tglx later today and will poke him a=
bout
> this, as this might already be a non-issue.
>

We've already made improvements here for arm64 as well (and ARM
already used lazy restore). But I think it still makes sense to
amortize these calls over a reasonable chunk of data, i.e., a packet.

>
> So given the above, how would you like to proceed? My personal
> preference would be to see you start with the Zinc patchset and rename
> things and change the infrastructure to something that fits your
> preferences, and we can see what that looks like. Less appealing would
> be to do several iterations of you reworking Zinc from scratch and
> going through the exercises all over again, but if you prefer that I
> guess I could cope. Alternatively, maybe this is a lot to chew on, and
> we should just throw caution into the wind, implement cryptoapi.c for
> WireGuard (as described at the top), and add C functions to the crypto
> API sometime later? This is what I had envisioned in [1].
>

It all depends on whether we are interested in supporting async
accelerators or not, and it is clear what my position is on this
point.

I am not convinced that we need accelerated implementations of blake2s
and curve25519, but if we do, I'd like those to be implemented as
individual modules under arch/*/crypto, with some moduleloader fu for
weak symbols or static calls thrown in if we have to. Exposing them as
shashes seems unnecessary to me at this point.

My only objection to your simd get/put interface is that it uses a
typedef rather than a struct definition (although I also wonder how we
can avoid two instances living on the same call stack, unless we
forbid functions that take a struct simd* to call functions that don't
take one, but these are details we should be able to work out.)

What I *don't* want is to merge WireGuard with its own library based
crypto now, and extend that later for async accelerators once people
realize that we really do need that as well.

> And for the avoidance of doubt, or in case any of the above message
> belied something different, I really am happy and relieved to have an
> opportunity to work on this _with you_, and I am much more open than
> before to compromise and finding practical solutions to the past
> political issues. Also, if you=E2=80=99re into chat, we can always spec s=
ome
> of the nitty-gritty aspects out over IRC or even the old-fashioned
> telephone. Thanks again for pushing this forward.
>

My pleasure :-)
