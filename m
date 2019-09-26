Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED88C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 20:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9BD22459
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 20:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="1LHJ9pk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfIZUra (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 16:47:30 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:38001 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbfIZUra (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 16:47:30 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8ceefd07
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Sep 2019 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=odjmu8NOWxa0
        KFPPRUgXVTFrz7c=; b=1LHJ9pk2cud5unKkdy4Ch7E3MUvcT4Qq2cqsr1bUWVO4
        acRbOgHdKoDcxSOCr51EquVlpHiLbHoJC9JZLiFN6FT/Qv+gHvgGkns/g8aIicQ+
        WBb3Pdhn/NgwdNZuwklCXbvObg/Hxy1l9LDx4x4JOCe/7sNilWDIsaVI20D0w+HG
        gz5SslToNHthbfzGqPuN9CDCIdn5fnV91CdwZTQ1iEKxRW43zmu8Z3OZdFgb+eQj
        Zv6OMvPVapAgMTMUXur8PPKApKjzm9e5URWaxEK5NtQ1qHgImOdvdJkdtXezaZqt
        6aEYE3L9SlqEhmBJjwE6zLOZI5JvqBPdfdrncWs/QQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1677263e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Sep 2019 20:01:32 +0000 (UTC)
Received: by mail-oi1-f177.google.com with SMTP id t84so3316315oih.10
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 13:47:26 -0700 (PDT)
X-Gm-Message-State: APjAAAU1V4GWSkXAwTgaKDgGS311qEBwEXRMShYLWPnvliyOh+svMHmF
        uSmJSMIYeFLh2rw3pY4MuJlN4tlXBqIFhwWqRfg=
X-Google-Smtp-Source: APXvYqwmbUdvvol/2cgZvnoKGoii6bLsYJQ67wnVSYO8QGeHSpQ4UZu0wAYgIJcmM01RDSC9slpe0YuBzWlUX7yCrIE=
X-Received: by 2002:a05:6808:b0d:: with SMTP id s13mr4315089oij.52.1569530845135;
 Thu, 26 Sep 2019 13:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <CAHmME9oDhnv7aX77oEERof0TGihk4mDe9B_A3AntaTTVsg9aoA@mail.gmail.com> <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
In-Reply-To: <CAKv+Gu-RLRhwDahgvfvr2J9R+3GPM6vh4mjO73VcekusdzbuMA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 26 Sep 2019 22:47:12 +0200
X-Gmail-Original-Message-ID: <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
Message-ID: <CAHmME9rKFUvsQ6hhsKjxxVSnyNQsTaqBKGABoHibCiCBmfxCOA@mail.gmail.com>
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

On Thu, Sep 26, 2019 at 2:07 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> attitude goes counter to that, and this is why we have made so little
> progress over the past year.

I also just haven't submitted much in the past year, taking a bit of a
break to see how things would settle. Seemed like rushing things
wasn't prudent, so I slowed down.

> But I am happy with your willingness to collaborate and find common
> ground, which was also my motivation for spending a considerable
> amount of time to prepare this patch set.

Super.

> > If the process of doing that together will be fraught with difficulty,
> > I=E2=80=99m still open to the =E2=80=9C7 patch series=E2=80=9D with the=
 ugly cryptoapi.c
> > approach, as described at the top.
>
> If your aim is to write ugly code and use that as a munition

No, this is not a matter of munition at all. Please take my words
seriously; I am entirely genuine here. Three people I greatly respect
made a very compelling argument to me, prompting the decision in [1].
The argument was that trying to fix the crypto layer AND trying to get
WireGuard merged at the same time was ambitious and crazy. Maybe
instead, they argued, I should just use the old crypto API, get
WireGuard in, and then begin the Zinc process after. I think
procedurally, that's probably good advice, and the people I was
talking to seemed to have a really firm grasp on what works and what
doesn't in the mainlining process. Now it's possible their judgement
is wrong, but I really am open, in earnest, to following it. And the
way that would look would be not trying to fix the crypto API now,
getting WireGuard in based on whatever we can cobble together based on
the current foundations with some intermediate file (cryptoapi.c in my
previous email) to prevent it from infecting WireGuard. This isn't
"munition"; it's a serious proposal.

The funny thing, though, is that all the while I was under the
impression somebody had figured out a great way to do this, it turns
out you were busy with basically Zinc-but-not. So we're back to square
one: you and I both want the crypto API to change, and now we have to
figure out a way forward together on how to do this, prompting my last
email to you, indicating that I was open to all sorts of compromises.
However, I still remain fully open to following the prior suggestion,
of not doing that at all right now, and instead basing this on the
existing crypto API as-is.

[1] https://lore.kernel.org/wireguard/CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2a=
tTPTyNFFmEdHLg@mail.gmail.com/

> > reference, here=E2=80=99s what that kind of thing looks like: [2].
>
> This is one of the issues in the 'fix it for everyone else as well'
> category. If we can improve the crypto API to be less susceptible to
> these issues (e.g., using static calls), everybody benefits. I'd be
> happy to collaborate on that.

Good. I'm happy to learn that you're all for having fast
implementations that underlie the simple function calls.

> > Taken together, we simply can=E2=80=99t skimp on the implementations av=
ailable
> > on the handshake layer, so we=E2=80=99ll need to add some form of
> > implementation selection, whether it=E2=80=99s the method Zinc uses ([2=
]), or
> > something else we cook up together.
>
> So are you saying that the handshake timing constraints in the
> WireGuard protocol are so stringent that we can't run it securely on,
> e.g., an ARM CPU that lacks a NEON unit? Or given that you are not
> providing accelerated implementations of blake2s or Curve25519 for
> arm64, we can't run it securely on arm64 at all?

Deployed at scale, the handshake must have a certain performance to
not be DoS'd. I've spent a long time benching these and attacking my
own code.  I won't be comfortable with this going in without the fast
implementations for the handshake. And down the line, too, we can look
into how to even improve the DoS resistance. I think there's room for
improvement, and I hope at some point you'll join us in discussions on
WireGuard internals. But the bottom line is that we need those fast
primitives.

> Typically, I would prefer to only introduce different versions of the
> same algorithm if there is a clear performance benefit for an actual
> use case.

As I was saying, this is indeed the case.

> Framing this as a security issue rather than a performance issue is
> slightly disingenuous, since people are less likely to challenge it.

I'm not being disingenuous. DoS resistance is a real issue with
WireGuard. You might argue that FourQ and Siphash would have made
better choices, and that's an interesting discussion, but it is what
it is. The thing needs fast implementations. And we're going to have
to implement that code anyway for other things, so might as well get
it working well now.

> But the security of any VPN protocol worth its salt

You're not required to use WireGuard.

> Parsing the string and connecting the function pointers happens only
> once, and only when the transform needs to be instantiated from its
> constituent parts. Subsequent invocations will just grab the existing
> object.

That's good to know. It doesn't fully address the issue, though.

> My preference would be to address this by permitting per-request keys
> in the AEAD layer. That way, we can instantiate the transform only
> once, and just invoke it with the appropriate key on the hot path (and
> avoid any per-keypair allocations)

That'd be a major improvement to the async interface, yes.

> > So given the above, how would you like to proceed? My personal
> > preference would be to see you start with the Zinc patchset and rename
> > things and change the infrastructure to something that fits your
> > preferences, and we can see what that looks like. Less appealing would
> > be to do several iterations of you reworking Zinc from scratch and
> > going through the exercises all over again, but if you prefer that I
> > guess I could cope. Alternatively, maybe this is a lot to chew on, and
> > we should just throw caution into the wind, implement cryptoapi.c for
> > WireGuard (as described at the top), and add C functions to the crypto
> > API sometime later? This is what I had envisioned in [1].

> It all depends on whether we are interested in supporting async
> accelerators or not, and it is clear what my position is on this
> point.

For a first version of WireGuard, no, I'm really not interested in
that. Adding it in there is more ambitious than it looks to get it
right. Async means more buffers, which means the queuing system for
WireGuard needs to be changed. There's already ongoing research into
this, and I'm happy to consider that research with a light toward
maybe having async stuff in the future. But sticking into the code now
as-is simply does not work from a buffering/queueing perspective. So
again, let's take an iterative approach here: first we do stuff with
the simple synchronous API. After the dust has settled, hardware is
available for testing, Van Jacobson has been taken off the bookshelf
for a fresh reading, and we've all sat down for a few interesting
conversations at netdev on queueing and bufferbloat, then let's start
working this in. In otherwords, just because technically you can glue
those APIs together, sort of, doesn't mean that approach makes sense
for the system as a whole.

> I am not convinced that we need accelerated implementations of blake2s
> and curve25519, but if we do, I'd like those to be implemented as
> individual modules under arch/*/crypto, with some moduleloader fu for
> weak symbols or static calls thrown in if we have to. Exposing them as
> shashes seems unnecessary to me at this point.

We need the accelerated implementations. And we'll need it for chapoly
too, obviously. So let's work out a good way to hook that all into the
Zinc-style interface. [2] does it in a very effective way that's
overall quite good for performance and easy to follow. The
chacha20-x86_64-glue.c code itself gets called via the static symbol
chacha20_arch. This is implemented for each platform with a fall back
to one that returns false, so that the generic code is called. The
Zinc stuff here is obvious, simple, and I'm pretty sure you know
what's up with it.

I prefer each of these glue implementations to live in
lib/zinc/chacha20/chacha20-${ARCH}-glue.c. You don't like that and
want things in arch/${ARCH}/crypto/chacha20-glue.c. Okay, sure, fine,
let's do all the naming and organization and political stuff how you
like, and I'll leave aside my arguments about why I disagree. Let's
take stock of where that leaves us, in terms of files:

- lib/crypto/chacha20.c: this has a generic implementation, but at the
top of the generic implementation, it has some code like "if
(chacha20_arch(..., ..., ...)) return;"
- arch/crypto/x86_64/chacha20-glue.c: this has the chacha20_arch()
implementation, which branches out to the various SIMD implementations
depending on some booleans calculated at module load time.
- arch/crypto/arm/chacha20-glue.c: this has the chacha20_arch()
implementation, which branches out to the various SIMD implementations
depending on some booleans calculated at module load time.
- arch/crypto/mips/chacha20-glue.c: this has the chacha20_arch()
implementation, which contains an assembly version that's always run
unconditionally.

Our goals are that chacha20_arch() from each of these arch glues gets
included in the lib/crypto/chacha20.c compilation unit. The reason why
we want it in its own unit is so that the inliner can get rid of
unreached code and more tightly integrate the branches. For the MIPS
case, the advantage is clear. Here's how Zinc handles it: [3]. Some
simple ifdefs and includes. Easy and straightforward. Some people
might object, though, and it sounds like you might. So let's talk
about some alternative mechanisms with their pros and cons:

- The zinc method: straightforward, but not everybody likes ifdefs.
- Stick the filename to be included into a Kconfig variable and let
the configuration system do the logic: also straightforward. Not sure
it's kosher, but it would work.
- Weak symbols: we don't get inlining or the dead code elimination.
- Function pointers: ditto, plus spectre.
- Other ideas you might have? I'm open to suggestions here.

[2] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/li=
b/zinc/chacha20/chacha20-x86_64-glue.c?h=3Djd/wireguard#n54
[3] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/tree/li=
b/zinc/chacha20/chacha20.c?h=3Djd/wireguard#n19

> What I *don't* want is to merge WireGuard with its own library based
> crypto now, and extend that later for async accelerators once people
> realize that we really do need that as well.

I wouldn't worry so much about that. Zinc/library-based-crypto is just
trying to fulfill the boring synchronous pure-code part of crypto
implementations. For the async stuff, we can work together on
improving the existing crypto API to be more appealing, in tandem with
some interesting research into packet queuing systems. From the other
thread, you might have seen that already Toke has cool ideas that I
hope we can all sit down and talk about. I'm certainly not interested
in "bolting" anything on to Zinc/library-based-crypto, and I'm happy
to work to improve the asynchronous API for doing asynchronous crypto.

Jason
