Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C65C43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB821207BC
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="cbD50RK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgIUImX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:42:23 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:22290 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIUImX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 04:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1600677738;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=QSTMXPkqbndCvLkEI42WOEEkdC9UKl9v/BphBg7gqyU=;
        b=cbD50RK9fzAa2rrxXLLlpWZvGOF4zbJhOcIMCrnYJ5tOfgfpgszyEycpe1RcsF3jVf
        5ZKnPQsfsc9V5UwyGFY40wTjd4S/A/t1DiLk0dcGvsxWHbLWETcBm8TBlDdwWOvoSDfe
        hGEkfmucEA2m46r3w4wuSomtZmhMN3bPRJQJXYAQra5DK+CPK+Gia4vfaT3gUoWeHQ/5
        hDIzOreS7Ok8v2UIlF+RmMH+ChHHbpMhGoj63rxOXjGq+5jaccLcYOyeAlAU2D6BpSTF
        5esg6aGcA48j6Zyinn+E5ee0cvI6kfi6inrVUhOnMrEEhScStDCwqo+9FTMtkBuHBkN5
        2bYQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvdOeibKgE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.7 DYNA|AUTH)
        with ESMTPSA id 002e9aw8L8ebG1D
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 21 Sep 2020 10:40:37 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Nicolai Stange <nstange@suse.de>
Cc:     linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Torsten Duwe <duwe@suse.de>, Petr Tesarik <ptesarik@suse.cz>,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
Date:   Mon, 21 Sep 2020 10:40:37 +0200
Message-ID: <8618155.4vTCxPXJkl@tauon.chronox.de>
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
References: <20200921075857.4424-1-nstange@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 21. September 2020, 09:58:16 CEST schrieb Nicolai Stange:

Hi Nicolai,

> Hi all,
>=20
> first of all, my apologies for the patch bomb following up in reply to th=
is
> mail here -- it's not meant to receive any serious review at all, but only
> to support the discussion I'm hoping to get going.

Thank you for this effort!
>=20
> As some of you might already be aware of, all new submissions for FIPS
> certification will be required to comply with NIST SP800-90B from Nov 7th
> on ([1], sec. 7.18 "Entropy Estimation and Compliance with SP 800-90B").
> For reference: broadly speaking, NIST SP800-90B is about noise sources,
> SP800-90A about the DRBG algorithms stacked on top and SP800-90C about how
> everything is supposed to be glued together. The main requirements from
> SP800-90B are
> - no correlations between different noise sources,
> - to continuously run certain health tests on a noise source's output and
> - to provide an interface enabling access to the raw noise samples for
>   validation purposes.
>=20
> To my knowledge, all SP800-90B compliant noise sources available on Linux
> today are either based on the Jitter RNG one way or another or on
> architectural RNGs like e.g. x86's RDSEED or arm64's RNDRRS. Currently,
> there's an in-kernel Jitter RNG implementation getting registered (c.f.
> crypto/drbg.c, (*)) with the Crypto RNG API, which is also accessible from
> userspace via AF_ALG. The userspace haveged ([2]) or jitterentropy
> integrations ([3]) are worth mentioning in this context, too. So in
> summary, I think that for the in-kernel entropy consumers falling under t=
he
> scope of FIPS, the currently only way to stay compliant would be to draw =
it
> from said Crypto API RNG. For userspace applications there's the addition=
al
> option to invoke haveged and alike.
>=20
> OTOH, CPU jitter based techniques are not uncontroversial ([4]). In any
> case, it would certainly be a good idea to mix (xor or whatever) any jitt=
er
> output with entropy obtained from /dev/random (**). If I'm not mistaken,
> the mentioned Crypto API RNG implementation (crypto/drbg.c) follows exact=
ly
> this approach, but doesn't enforce it yet: there's no
> wait_for_random_bytes() and early DRBG invocations could in principle run
> on seeds dominated entirely by jitterentropy. However, this can probably
> get sorted quite easily and thus, one reasonable way towards maintaining
> FIPS resp. SP800-90 compliance would be to
> - make crypto/drbg.c invoke wait_for_random_bytes(),
> - make all relevant in-kernel consumers to draw their random numbers from
>   the Crypto RNG API, if not already the case and
> - convert all relevant userspace to use a SP800-90B conforming Jitter RNG
>   style noise source for compliance reasons, either by invoking the
>   kernel's Crypto RNG API or by diffent means, and mix that with
>   /dev/random.
>=20
> Even though this would probably be feasible, I'm not sure that giving up =
on
> /dev/random being the primary, well established source of randomness in
> favor of each and every userspace crypto library rolling its own entropy
> collection scheme is necessarily the best solution (it might very well be
> though).
>=20
> An obvious alternative would be to make /dev/random conform to SP800-90B.
> Stephan M=FCller posted his "LRNG" patchset ([5]), in which he proposed to
> introduce a second, independent implementation aiming at SP800-90[A-C]
> conformance. However, it's in the 35th iteration now and my impression is
> that there's hardly any discussion happening around this for quite a while
> now. I haven't followed the earlier development, but I can imagine several
> reasons for that:
> - people are not really interested in FIPS or even questioning the whole
>   concept in the first place (c.f. Theodore Ts'o remarks on this topic
>   at [6]),
> - potential reviewers got merely discouraged by the diffstat or

Maybe I followed the Linux principle a bit to much here? Release early,=20
release often.

But with the v35, all goals I tried to achieve are now in (namely the last =
was=20
to get rid of any non-cryptographic conditioning functions) and to have a v=
ery=20
clean data processing / entropy analysis. I do not expect big changes any=20
more.

> - people dislike the approach of having two competing implementations for
>   what is basically the same functionality in the kernel.

Is this really so bad considering the security implications on this topic? =
We=20
also have multiple file systems, multiple memory allocators, etc...
>=20
> In either case, I figured it might perhaps help further discussion to
> provide at least a rough idea of how bad the existing /dev/random
> implementation would get cluttered when worked towards SP800-90B
> compliance. So I implemented the required health tests for the interrupt
> noise source -- the resulting patches can be found in reply to this mail.
> I'd like to stress(!) that this should really only be considered a first
> step and that there would still be a long way towards a complete solution;
> known open items are listed below. Also, I'm fully aware that making those
> continuous health tests block the best effort primary_crng reseeds upon
> failure is a ridiculous thing to do -- that's again meant for demonstrati=
on
> purposes only, c.f. the commit log from the next to last patch. Anyway,
> those of you who are interested in some more details beyond the mere
> diffstat can find them after the list of references below.
>=20
> In summary, I can imagine three feasible ways towards SP800-90 compliance:
> 1.) Put the burden on consumers. For in-kernel users this would mean
>     conversion to the Jitter backed Crypto RNG API, in case that hasn't
>     happened yet. Userspace is free to use any approved Jitter based
>     mechanism for compliance reasons, but is encouraged to mix that with
>     /dev/random.
> 2.) Merge Stephan's LRNG. Users/distros would have to decide between eith=
er
>     of the two competing implementations at kernel config time.
> 3.) Develop the existing /dev/random towards compliance, ideally w/o
>     affecting !fips_enabled users too much. This would likely require some
>     redundancies as well as some atrocities imposed by the specs.
>=20
> I'm looking forward to hearing your opinions and suggestions! In case you
> happen to know of anybody who's not on CC but might potentially be
> interested in FIPS, I'd highly appreciate it if you could point him/her to
> this thread. The usual suspects are probably (enterprise?) distro folks,
> but there might be others I haven't thought of.
>=20
> Many thanks for your time!
>=20
> Nicolai
>=20
>=20
> (*) That's an oversimplification for the sake of brevity: actually
>     SP800-90A DRBGs stacked on top of the SP800-90B conforming
>     jitterentropy source get registered with the Crypto API.
> (**) "/dev/random" is used as a synonym for everything related to
>      drivers/char/random.c throughout this mail.
>=20
> [1]
> https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation=
=2Dp
> rogram/documents/fips140-2/fips1402ig.pdf [2]
> http://www.issihosts.com/haveged/
> [3] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html
>     c.f. appendices C-E
> [4] https://lwn.net/Articles/642166/
> [5] https://lkml.kernel.org/r/5667034.lOV4Wx5bFT@positron.chronox.de
> [6] https://lkml.kernel.org/r/20170919133959.5fgtioyonlsdyjf5@thunk.org
>     https://lkml.kernel.org/r/20170920011642.cczekznqebf2zq5u@thunk.org
> [7] https://lkml.kernel.org/r/aef70b42-763f-0697-f12e-1b8b1be13b07@gmail.=
com
>=20
>=20
> As promised above, some more details on the RFC series sent alongside
> follow. The primary goal was to implement that health test functionality =
as
> required by SP800-90B for the existing drivers/char/random.c without
> affecting !fips_enabled users in any way. As outlined below, I failed qui=
te
> miserably as far as performance is concerned, but that shouldn't be
> something which cannot get rectified. Kernel version v5.9-rc4 had been us=
ed
> as a basis. The series can be logically subdivided into the following
> parts:
> - [1-5]: Preparatory cleanup.
> - [6-17]: Implement support for deferring entropy credit dispatch to the
>   global balance to long after the corresponding pool mixing operation has
>   taken place. Needed for "holding back" entropy until the health tests
>   have finished on the latest pending batch of samples.
> - [18-21]: Move arch_get_random_{seed_,}long() out of the interrupt path.
>   Needed to adhere to how SP800-90C expects multiple noise source to get
>   combined, but is also worthwhile on its own from a performance POV.
> - [22-23]: Don't award entropy to non-SP800-90B conforming architectural
>   RNGs if fips_enabled is set.
> - [24]: Move rand_initialize() to after time_init(). A "fix" for what is
>   currently a non-issue, but it's a prerequisite for the subsequent patch.
> - [25]: Detect cycle counter resolution, subsequently needed for making a
>   per-IRQ entropy assessment.
> - [26-28]: Follow Stephan's LRNG approach in how much entropy gets
>   awarded to what: a lot more than before to add_interrupt_randomness(),
>   none to add_{disk,input}_randomness() anymore.
> - [29-33]: Introduce empty health test stubs and wire them up to
>   add_interrupt_randomness().
> - [34-36]: Implement the Adaptive Proportion Test (APT) as specified by
>   SP800-90B and squeeze some more statistical power out of it.
> - [37]: Implement SP800-90B's Repetition Count Test (RCT).
> - [38-40]: Implement the startup tests, which are nothing but the
>   continuous tests (APT + RCT) run on a specified amount of samples at
>   boot time.
> - [41]: Attempt to keep the system going in case the entropy estimate
>   had been too optimistic and the health tests keep failing.
>=20
> As the health tests are run from interrupt context on each sample, a
> performance measurement is due. To this end, I configured a Raspberry Pi =
2B
> (ARMv7 Cortex A7) to disable all peripherals, gated a
> 19.2 MHz / 2048 ~=3D 9.3 kHz clock signal to some edge triggered GPIO and
> function_graph traced add_interrupt_randomness() for 10 min from a busybox
> initramfs. Unfortunately, the results had been a bit disappointing: with
> fips_enabled being unset there had been a runtime degradation of ~12.5% w=
/o
> SMP and ~5% w/ SMP resp. on average merely due to the application of the
> patches onto the v5.9-rc4 base. However, as the amount of work should not
> have changed much and given that struct fast_pool still fits into a single
> cacheline, I'm optimistic that this can get rectified by e.g. introducing
> a static_key for fips_enabled and perhaps shuffling branches a bit such
> that the !fips_enabled code becomes more linear. OTOH, the impact of
> enabling the health tests by means of setting fips_enabled had not been so
> dramatic: the observed increase in average add_interrupt_randomness()
> runtimes had been 6% w/o SMP and 5% w/ SMP respectively.
>=20
> Apart from those well controlled experiments on a RPi, I also did some
> lax benchmarking on my x86 desktop (which has some Intel i9, IIRC).
> More specifically, I simply didn't touch the system and ftraced
> add_interrupt_randomness() for 15 mins. The number of captured events had
> been about 2000 in each configuration. Here the add_interrupt_randomness()
> performance improved greatly: from 4.3 us on average w/o the patches down
> to 2.0 us with the patches applied and fips_enabled. However, I suppose
> this gain was due to the removal of RDSEED from add_interrupt_randomness(=
).
> Indeed, when inspecting the distribution of add_interrupt_randomness()
> runtimes on plain v5.9-rc4 more closely, it can be seen that there's a
> good portion of events (about 1/4th) where add_interrupt_randomness() took
> about 10us. So I think that this comparison isn't really a fair one...
>=20
>=20
> To the best of my knowledge, these are the remaining open questions/items
> towards full SP800-90[A-C] compliance:
> - There's no (debugfs?) interface for accessing raw samples for validation
>   purposes yet. That would be doable though.

I use the patch 12/13 from my patch series successfully for random.c too.

> - try_to_generate_entropy() should probably get wired up to the health
>   tests as well. More or less straightfoward to implement, too.

Correct, but when assessing this function as part of [1], I found hardly an=
y=20
entropy being provided with this component.

[1] https://www.bsi.bund.de/SharedDocs/Downloads/EN/BSI/Publications/Studie=
s/
LinuxRNG/LinuxRNG_EN_V4_1.pdf?__blob=3DpublicationFile&v=3D2

> - Diverting fast_pool contents into net_rand_state is not allowed (for a
>   related discussion on this topic see [7]).

Totally agreed, this is a bad design.

> - I've been told that SP800-90A is not a hard requirement yet, but I
>   suppose it will eventually become one. This would mean that the chacha20
>   RNG would have to get replaced by something approved for fips_enabled.
> - The sequence of fast_pool -> input_pool -> extract_buf() operations
>   is to be considered a "non-vetted conditioning component" in SP800-90B
>   speak. It would follow that the output can't be estimated as having full
>   entropy, but only 0.999 of its length at max. (c.f. sec. 3.1.5.2). This
>   could be resolved by running a SP800-90A derivation function at CRNG
>   reseeding for fips_enabled. extract_buf(), which is already SHA1 based,
>   could perhaps be transformed into such one as well.

The core issue may very well be the SHA-1: using SHA-1 and folding its outp=
ut=20
in half may be an artificial limit of the upper bound of entropy.

> - The only mention of combining different noise sources I was able to find
>   had been in SP800-90C, sec. 5.3.4 ("Using Multiple Entropy Sources"):
>   it clearly states that the outputs have to be combined by concatenation.
>   add_hwgenerator_randomness() mixes into the same input_pool as
>   add_interrupt_randomness() though and I would expect that this isn't
>   allowed, independent of whether the noise source backing the former
>   is SP800-90B compliant or not. IIUC, Stephan solved this for his LRNG
>   by maintaing a separate pool for the hw generator.

See 90B section 3.1.6: combining both via vetted conditioning function is=20
accepted.=20

> - SP800-90A sets an upper bound on how many bits may be drawn from a
>   DRBG/crng before a reseed *must* take place ("reseed_interval"). In
>   principle that shouldn't matter much in practice, at least not with
>   CONFIG_NUMA: with reseed_interval =3D=3D 2^32 bits, a single CRNG insta=
nce
>   would be allowed to hand out only 500MB worth of randomness before
>   reseeding, but a (single) numa crng chained to the primary_crng may
>   produce as much as 8PB before the latter must eventually get reseeded
>   from the input_pool. But AFAICT, a SP800-90A conforming implementation
>   would still have to provide provisions for a blocking extract_crng().

The hard limit is 2^48 generate operation with up to 2^16 bytes each. This =
is=20
a very large amount of data. If we start triggering reseeds early enough, a=
=20
hard blocking may not be needed.

> - It's entirely unclear to me whether support for "prediction resistance
>   requests" is optional. It would be a pity if it weren't, because IIUC
>   that would effectively imply a return to the former blocking_pool
>   behaviour, which is obviously a no-no.

This is not required.


Ciao
Stephan


