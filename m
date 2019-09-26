Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DE7C432C2
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 09:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57541206B7
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 09:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iTX3QD6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfIZJGM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 05:06:12 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:32909 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfIZJGM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 05:06:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2019 05:06:11 EDT
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 50fc4b0d
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Sep 2019 08:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=C/a/ScbtsuAo
        2usQTTTVSlNKZCA=; b=iTX3QD6wIlmCveL3eRyySI76IJdz6ppm5S2uFtA7DXYA
        Vchg4FKmg2zXHnGe+FoXwPm/jK8d1dWzZeVCxVCZSyn+64OJuX6MLTVApldhUnyy
        mGtK2CSDVp5R2syEKaQ6HY367Y/NtipTZ/OGsOfX1iPHVl+N+aUxbTzhrJQ7mxun
        CA6GHoJ+M/H8pFw9xDXS3UU7LI8MkHIJRGzBiL5BnDSzFvaJiXWsExotF4dd4WsJ
        7u9k9ySI3zfG286G6SWLf43MM1D8UmbHS/FuGqq96+JQDMMvXt7ibEgbRxwxR+we
        0bbZKtJGWj5gH5GzwUVXqbgZlIsMAqf/+DYvv1XbZw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 31ad2ec8 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Sep 2019 08:13:37 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id f21so1291395otl.13
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 01:59:28 -0700 (PDT)
X-Gm-Message-State: APjAAAVsxcHC7XUGxPvE4jl8je/PObcsL4uQrS8WGP1vCiFlI0lT6pKx
        okHRnrWH3g0o4Y//irUxyIATYUnd4LIzhs3Ap7U=
X-Google-Smtp-Source: APXvYqyO5UX9X3fiYBRFcC2tw9W9x7GeBspCy9izcw06vv1rMPrTR+YDmz6QiN2+ZG6bOYzjiY5GguC0/H4oCQ3jCkY=
X-Received: by 2002:a9d:65d2:: with SMTP id z18mr1860027oth.52.1569488366735;
 Thu, 26 Sep 2019 01:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 26 Sep 2019 10:59:14 +0200
X-Gmail-Original-Message-ID: <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
Message-ID: <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] crypto: wireguard using the existing crypto API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

 Hi Ard,

Thanks for taking the initiative on this. When I first discussed with
DaveM porting WireGuard to the crypto API and doing Zinc later
yesterday, I thought to myself, =E2=80=9CI wonder if Ard might want to work=
 on
this with me=E2=80=A6=E2=80=9D and sent you a message on IRC. It didn=E2=80=
=99t occur to me
that you were the one who had pushed this endeavor!

I must admit, though, I=E2=80=99m a bit surprised to see how it=E2=80=99s a=
ppearing.
When I wrote [1], I had really imagined postponing the goals of Zinc
entirely, and instead writing a small shim that calls into the
existing crypto API machinery. I imagined the series to look like
this:

1. Add blake2s generic as a crypto API shash object.
2. Add blake2s x86_64 as a crypto API shash object.
3. Add curve25519 generic as a crypto API dh object.
4. Add curve25519 x86_64 as a crypto API dh object.
5. Add curve25519 arm as a crypto API dh object.
6. The unmodified WireGuard commit.
7. A =E2=80=9Ccryptoapi.c=E2=80=9D file for WireGuard that provides definit=
ions of the
=E2=80=9Cjust functions=E2=80=9D approach of Zinc, but does so in terms of =
the crypto
API=E2=80=99s infrastructure, with global per-cpu lists and a few locks to
handle quick buffer and tfm reuse.

I wouldn=E2=80=99t expect (7) to be pretty, for the various reasons that mo=
st
people dislike the crypto API, but at least it would somewhat =E2=80=9Cwork=
=E2=80=9D,
not affect the general integrity of WireGuard, and provide a clear
path forward in an evolutionary manner for gradually, piecemeal,
swapping out pieces of that for a Zinc-like thing, however that winds
up appearing.

Instead what we=E2=80=99ve wound up with in this series is a Frankenstein=
=E2=80=99s
monster of Zinc, which appears to have basically the same goal as
Zinc, and even much of the same implementation just moved to a
different directory, but then skimps on making it actually work well
and introduces problems. (I=E2=80=99ll elucidate on some specific issues la=
ter
in this email so that we can get on the same page with regards to
security requirements for WireGuard.) I surmise from this Zinc-but-not
series is that what actually is going on here is mostly some kind of
power or leadership situation, which is what you=E2=80=99ve described to me
also at various other points and in person. I also recognize that I am
at least part way to blame for whatever dynamic there has stagnated
this process; let me try to rectify that:

A principle objection you=E2=80=99ve had is that Zinc moves to its own
directory, with its own name, and tries to segment itself off from the
rest of the crypto API=E2=80=99s infrastructure. You=E2=80=99ve always felt=
 this
should be mixed in with the rest of the crypto API=E2=80=99s infrastructure
and directory structures in one way or another. Let=E2=80=99s do both of th=
ose
things =E2=80=93 put this in a directory structure you find appropriate and
hook this into the rest of the crypto API=E2=80=99s infrastructure in a way
you find appropriate. I might disagree, which is why Zinc does things
the way it does, but I=E2=80=99m open to compromise and doing things more y=
our
way.

Another objection you=E2=80=99ve had is that Zinc replaces many existing
implementations with its own. Martin wasn=E2=80=99t happy about that either=
.
So let=E2=80=99s not do that, and we=E2=80=99ll have some wholesale replace=
ment of
implementations in future patchsets at future dates discussed and
benched and bikeshedded independently from this.

Finally, perhaps most importantly, Zinc=E2=80=99s been my design rather tha=
n
our design. Let=E2=80=99s do this together instead of me git-send-email(1)-=
ing
a v37.

If the process of doing that together will be fraught with difficulty,
I=E2=80=99m still open to the =E2=80=9C7 patch series=E2=80=9D with the ugl=
y cryptoapi.c
approach, as described at the top. But I think if we start with Zinc
and whittle it down in accordance with the above, we=E2=80=99ll get somethi=
ng
mutually acceptable, and somewhat similar to this series, with a few
important exceptions, which illustrate some of the issues I see in
this RFC:

Issue 1) No fast implementations for the =E2=80=9Cit=E2=80=99s just functio=
ns=E2=80=9D interface.

This is a deal breaker. I know you disagree here and perhaps think all
dynamic dispatch should be by loadable modules configured with
userspace policy and lots of function pointers and dynamically
composable DSL strings, as the current crypto API does it. But I think
a lot of other people agree with me here (and they=E2=80=99ve chimed in
before) that the branch predictor does things better, doesn=E2=80=99t have
Spectre issues, and is very simple to read and understand. For
reference, here=E2=80=99s what that kind of thing looks like: [2].

In this case, the relevance is that the handshake in WireGuard is
extremely performance sensitive, in order to fend off DoS. One of the
big design gambits in WireGuard is =E2=80=93 can we make it 1-RTT to reduce
the complexity of the state machine, but keep the crypto efficient
enough that this is still safe to do from a DoS perspective. The
protocol succeeds at this goal, but in many ways, just by a hair when
at scale, and so I=E2=80=99m really quite loathe to decrease handshake
performance. Here=E2=80=99s where that matters specifically:

- Curve25519 does indeed always appear to be taking tiny 32 byte stack
inputs in WireGuard. However, your statement, =E2=80=9Cthe fact that they
operate on small, fixed size buffers means that there is really no
point in providing alternative, SIMD based implementations of these,
and we can limit ourselves to generic C library version,=E2=80=9D is just
plain wrong in this case. Curve25519 only ever operates on 32 byte
inputs, because these represent curve scalars and points. It=E2=80=99s not
like a block cipher where parallelism helps with larger inputs or
something. In this case, there are some pretty massive speed
improvements between the generic C implementations and the optimized
ones. Like huge. On both ARM and on Intel. And Curve25519 is the most
expensive operation in WireGuard, and each handshake message invokes a
few of them. (Aside - Something to look forward to: I=E2=80=99m in the proc=
ess
of getting a formally verified x86_64 ADX implementation ready for
kernel usage, to replace our existing heavily-fuzzed one, which will
be cool.)

- Blake2s actually does benefit from the optimized code even for
relatively short inputs. While you might have been focused on the
super-super small inputs in noise.c, there are slightly larger ones in
cookie.c, and these are the most sensitive computations to make in
terms of DoS resistance; they=E2=80=99re on the =E2=80=9Cfront lines=E2=80=
=9D of the battle,
if you will. (Aside - Arguably WireGuard may have benefited from using
siphash with 128-bit outputs here, or calculated some security metrics
for DoS resistance in the face of forged 64-bit outputs or something,
or a different custom MAC, but hindsight is 20/20.)

- While 25519 and Blake2s are already in use, the optimized versions
of ChaPoly wind up being faster as well, even if it=E2=80=99s just hitting =
the
boring SSE code.

- On MIPS, the optimized versions of ChaPoly are a necessity. They=E2=80=99=
re
boring integer/scalar code, but they do things that the compiler
simply cannot do on the platform and we benefit immensely from it.

Taken together, we simply can=E2=80=99t skimp on the implementations availa=
ble
on the handshake layer, so we=E2=80=99ll need to add some form of
implementation selection, whether it=E2=80=99s the method Zinc uses ([2]), =
or
something else we cook up together.

Issue 2) Linus=E2=80=99 objection to the async API invasion is more correct
than he realizes.

I could re-enumerate my objections to the API there, but I think we
all get it. It=E2=80=99s horrendous looking. Even the introduction of the
ivpad member (what on earth?) in the skb cb made me shutter. But
there=E2=80=99s actually another issue at play:

wg_noise_handshake_begin_session=E2=86=92derive_keys=E2=86=92symmetric_key_=
init is all
part of the handshake. We cannot afford to allocate a brand new crypto
object, parse the DSL string, connect all those function pointers,
etc. The allocations involved here aren=E2=80=99t really okay at all in tha=
t
path. That=E2=80=99s why the cryptoapi.c idea above involves just using a p=
ool
of pre-allocated objects if we=E2=80=99re going to be using that API at all=
.
Also keep in mind that WireGuard instances sometimes have hundreds of
thousands of peers.

I=E2=80=99d recommend leaving this synchronous as it exists now, as Linus
suggested, and we can revisit that later down the road. There are a
number of improvements to the async API we could make down the line
that could make this viable in WireGuard. For example, I could imagine
decoupling the creation of the cipher object from its keys and
intermediate buffers, so that we could in fact allocate the cipher
objects with their DSLs globally in a safe way, while allowing the
keys and working buffers to come from elsewhere. This is deep plumbing
into the async API, but I think we could get there in time.

There=E2=80=99s also a degree of practicality: right now there is zero ChaP=
oly
async acceleration hardware anywhere that would fit into the crypto
API. At some point, it might come to exist and have incredible
performance, and then we=E2=80=99ll both feel very motivated to make this w=
ork
for WireGuard. But it might also not come to be (AES seems to have won
over most of the industry), in which case, why hassle?

Issue 3) WireGuard patch is out of date.

This is my fault, because I haven=E2=80=99t posted in a long time. There ar=
e
some important changes in the main WireGuard repo. I=E2=80=99ll roll anothe=
r
patch soon for this so we have something recent to work off of. Sorry
about that.

Issue 4) FPU register batching?

When I introduced the simd_get/simd_put/simd_relax thing, people
seemed to think it was a good idea. My benchmarks of it showed
significant throughput improvements. Your patchset doesn=E2=80=99t have
anything similar to this. But on the other hand, last I spoke with the
x86 FPU guys, I thought they might actually be in the process of
making simd_get/put obsolete with some internal plumbing to make
restoration lazier. I=E2=80=99ll see tglx later today and will poke him abo=
ut
this, as this might already be a non-issue.


So given the above, how would you like to proceed? My personal
preference would be to see you start with the Zinc patchset and rename
things and change the infrastructure to something that fits your
preferences, and we can see what that looks like. Less appealing would
be to do several iterations of you reworking Zinc from scratch and
going through the exercises all over again, but if you prefer that I
guess I could cope. Alternatively, maybe this is a lot to chew on, and
we should just throw caution into the wind, implement cryptoapi.c for
WireGuard (as described at the top), and add C functions to the crypto
API sometime later? This is what I had envisioned in [1].

And for the avoidance of doubt, or in case any of the above message
belied something different, I really am happy and relieved to have an
opportunity to work on this _with you_, and I am much more open than
before to compromise and finding practical solutions to the past
political issues. Also, if you=E2=80=99re into chat, we can always spec som=
e
of the nitty-gritty aspects out over IRC or even the old-fashioned
telephone. Thanks again for pushing this forward.

Regards,
Jason

[1] https://lore.kernel.org/wireguard/CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2a=
tTPTyNFFmEdHLg@mail.gmail.com/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/li=
b/zinc/chacha20/chacha20-x86_64-glue.c?h=3Djd/wireguard#n54
