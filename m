Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAFEC43464
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B382520874
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgIUH7V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:59:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:56554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgIUH7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 03:59:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A9C9B4FA;
        Mon, 21 Sep 2020 07:59:51 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
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
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Petr Tesarik <ptesarik@suse.cz>,
        Nicolai Stange <nstange@suse.de>
Subject: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
Date:   Mon, 21 Sep 2020 09:58:16 +0200
Message-Id: <20200921075857.4424-1-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

first of all, my apologies for the patch bomb following up in reply to this
mail here -- it's not meant to receive any serious review at all, but only
to support the discussion I'm hoping to get going.

As some of you might already be aware of, all new submissions for FIPS
certification will be required to comply with NIST SP800-90B from Nov 7th
on ([1], sec. 7.18 "Entropy Estimation and Compliance with SP 800-90B").
For reference: broadly speaking, NIST SP800-90B is about noise sources,
SP800-90A about the DRBG algorithms stacked on top and SP800-90C about how
everything is supposed to be glued together. The main requirements from
SP800-90B are
- no correlations between different noise sources,
- to continuously run certain health tests on a noise source's output and
- to provide an interface enabling access to the raw noise samples for
  validation purposes.

To my knowledge, all SP800-90B compliant noise sources available on Linux
today are either based on the Jitter RNG one way or another or on
architectural RNGs like e.g. x86's RDSEED or arm64's RNDRRS. Currently,
there's an in-kernel Jitter RNG implementation getting registered (c.f.
crypto/drbg.c, (*)) with the Crypto RNG API, which is also accessible from
userspace via AF_ALG. The userspace haveged ([2]) or jitterentropy
integrations ([3]) are worth mentioning in this context, too. So in
summary, I think that for the in-kernel entropy consumers falling under the
scope of FIPS, the currently only way to stay compliant would be to draw it
from said Crypto API RNG. For userspace applications there's the additional
option to invoke haveged and alike.

OTOH, CPU jitter based techniques are not uncontroversial ([4]). In any
case, it would certainly be a good idea to mix (xor or whatever) any jitter
output with entropy obtained from /dev/random (**). If I'm not mistaken,
the mentioned Crypto API RNG implementation (crypto/drbg.c) follows exactly
this approach, but doesn't enforce it yet: there's no
wait_for_random_bytes() and early DRBG invocations could in principle run
on seeds dominated entirely by jitterentropy. However, this can probably
get sorted quite easily and thus, one reasonable way towards maintaining
FIPS resp. SP800-90 compliance would be to
- make crypto/drbg.c invoke wait_for_random_bytes(),
- make all relevant in-kernel consumers to draw their random numbers from
  the Crypto RNG API, if not already the case and
- convert all relevant userspace to use a SP800-90B conforming Jitter RNG
  style noise source for compliance reasons, either by invoking the
  kernel's Crypto RNG API or by diffent means, and mix that with
  /dev/random.

Even though this would probably be feasible, I'm not sure that giving up on
/dev/random being the primary, well established source of randomness in
favor of each and every userspace crypto library rolling its own entropy
collection scheme is necessarily the best solution (it might very well be
though).

An obvious alternative would be to make /dev/random conform to SP800-90B.
Stephan Müller posted his "LRNG" patchset ([5]), in which he proposed to
introduce a second, independent implementation aiming at SP800-90[A-C]
conformance. However, it's in the 35th iteration now and my impression is
that there's hardly any discussion happening around this for quite a while
now. I haven't followed the earlier development, but I can imagine several
reasons for that:
- people are not really interested in FIPS or even questioning the whole
  concept in the first place (c.f. Theodore Ts'o remarks on this topic
  at [6]),
- potential reviewers got merely discouraged by the diffstat or
- people dislike the approach of having two competing implementations for
  what is basically the same functionality in the kernel.

In either case, I figured it might perhaps help further discussion to
provide at least a rough idea of how bad the existing /dev/random
implementation would get cluttered when worked towards SP800-90B
compliance. So I implemented the required health tests for the interrupt
noise source -- the resulting patches can be found in reply to this mail.
I'd like to stress(!) that this should really only be considered a first
step and that there would still be a long way towards a complete solution;
known open items are listed below. Also, I'm fully aware that making those
continuous health tests block the best effort primary_crng reseeds upon
failure is a ridiculous thing to do -- that's again meant for demonstration
purposes only, c.f. the commit log from the next to last patch. Anyway,
those of you who are interested in some more details beyond the mere
diffstat can find them after the list of references below.

In summary, I can imagine three feasible ways towards SP800-90 compliance:
1.) Put the burden on consumers. For in-kernel users this would mean
    conversion to the Jitter backed Crypto RNG API, in case that hasn't
    happened yet. Userspace is free to use any approved Jitter based
    mechanism for compliance reasons, but is encouraged to mix that with
    /dev/random.
2.) Merge Stephan's LRNG. Users/distros would have to decide between either
    of the two competing implementations at kernel config time.
3.) Develop the existing /dev/random towards compliance, ideally w/o
    affecting !fips_enabled users too much. This would likely require some
    redundancies as well as some atrocities imposed by the specs.

I'm looking forward to hearing your opinions and suggestions! In case you
happen to know of anybody who's not on CC but might potentially be
interested in FIPS, I'd highly appreciate it if you could point him/her to
this thread. The usual suspects are probably (enterprise?) distro folks,
but there might be others I haven't thought of.

Many thanks for your time!

Nicolai


(*) That's an oversimplification for the sake of brevity: actually
    SP800-90A DRBGs stacked on top of the SP800-90B conforming
    jitterentropy source get registered with the Crypto API.
(**) "/dev/random" is used as a synonym for everything related to
     drivers/char/random.c throughout this mail.

[1] https://csrc.nist.gov/csrc/media/projects/cryptographic-module-validation-program/documents/fips140-2/fips1402ig.pdf
[2] http://www.issihosts.com/haveged/
[3] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html
    c.f. appendices C-E
[4] https://lwn.net/Articles/642166/
[5] https://lkml.kernel.org/r/5667034.lOV4Wx5bFT@positron.chronox.de
[6] https://lkml.kernel.org/r/20170919133959.5fgtioyonlsdyjf5@thunk.org
    https://lkml.kernel.org/r/20170920011642.cczekznqebf2zq5u@thunk.org
[7] https://lkml.kernel.org/r/aef70b42-763f-0697-f12e-1b8b1be13b07@gmail.com


As promised above, some more details on the RFC series sent alongside
follow. The primary goal was to implement that health test functionality as
required by SP800-90B for the existing drivers/char/random.c without
affecting !fips_enabled users in any way. As outlined below, I failed quite
miserably as far as performance is concerned, but that shouldn't be
something which cannot get rectified. Kernel version v5.9-rc4 had been used
as a basis. The series can be logically subdivided into the following
parts:
- [1-5]: Preparatory cleanup.
- [6-17]: Implement support for deferring entropy credit dispatch to the
  global balance to long after the corresponding pool mixing operation has
  taken place. Needed for "holding back" entropy until the health tests
  have finished on the latest pending batch of samples.
- [18-21]: Move arch_get_random_{seed_,}long() out of the interrupt path.
  Needed to adhere to how SP800-90C expects multiple noise source to get
  combined, but is also worthwhile on its own from a performance POV.
- [22-23]: Don't award entropy to non-SP800-90B conforming architectural
  RNGs if fips_enabled is set.
- [24]: Move rand_initialize() to after time_init(). A "fix" for what is
  currently a non-issue, but it's a prerequisite for the subsequent patch.
- [25]: Detect cycle counter resolution, subsequently needed for making a
  per-IRQ entropy assessment.
- [26-28]: Follow Stephan's LRNG approach in how much entropy gets
  awarded to what: a lot more than before to add_interrupt_randomness(),
  none to add_{disk,input}_randomness() anymore.
- [29-33]: Introduce empty health test stubs and wire them up to
  add_interrupt_randomness().
- [34-36]: Implement the Adaptive Proportion Test (APT) as specified by
  SP800-90B and squeeze some more statistical power out of it.
- [37]: Implement SP800-90B's Repetition Count Test (RCT).
- [38-40]: Implement the startup tests, which are nothing but the
  continuous tests (APT + RCT) run on a specified amount of samples at
  boot time.
- [41]: Attempt to keep the system going in case the entropy estimate
  had been too optimistic and the health tests keep failing.

As the health tests are run from interrupt context on each sample, a
performance measurement is due. To this end, I configured a Raspberry Pi 2B
(ARMv7 Cortex A7) to disable all peripherals, gated a
19.2 MHz / 2048 ~= 9.3 kHz clock signal to some edge triggered GPIO and
function_graph traced add_interrupt_randomness() for 10 min from a busybox
initramfs. Unfortunately, the results had been a bit disappointing: with
fips_enabled being unset there had been a runtime degradation of ~12.5% w/o
SMP and ~5% w/ SMP resp. on average merely due to the application of the
patches onto the v5.9-rc4 base. However, as the amount of work should not
have changed much and given that struct fast_pool still fits into a single
cacheline, I'm optimistic that this can get rectified by e.g. introducing
a static_key for fips_enabled and perhaps shuffling branches a bit such
that the !fips_enabled code becomes more linear. OTOH, the impact of
enabling the health tests by means of setting fips_enabled had not been so
dramatic: the observed increase in average add_interrupt_randomness()
runtimes had been 6% w/o SMP and 5% w/ SMP respectively.

Apart from those well controlled experiments on a RPi, I also did some
lax benchmarking on my x86 desktop (which has some Intel i9, IIRC).
More specifically, I simply didn't touch the system and ftraced
add_interrupt_randomness() for 15 mins. The number of captured events had
been about 2000 in each configuration. Here the add_interrupt_randomness()
performance improved greatly: from 4.3 us on average w/o the patches down
to 2.0 us with the patches applied and fips_enabled. However, I suppose
this gain was due to the removal of RDSEED from add_interrupt_randomness().
Indeed, when inspecting the distribution of add_interrupt_randomness()
runtimes on plain v5.9-rc4 more closely, it can be seen that there's a
good portion of events (about 1/4th) where add_interrupt_randomness() took
about 10us. So I think that this comparison isn't really a fair one...


To the best of my knowledge, these are the remaining open questions/items
towards full SP800-90[A-C] compliance:
- There's no (debugfs?) interface for accessing raw samples for validation
  purposes yet. That would be doable though.
- try_to_generate_entropy() should probably get wired up to the health
  tests as well. More or less straightfoward to implement, too.
- Diverting fast_pool contents into net_rand_state is not allowed (for a
  related discussion on this topic see [7]).
- I've been told that SP800-90A is not a hard requirement yet, but I
  suppose it will eventually become one. This would mean that the chacha20
  RNG would have to get replaced by something approved for fips_enabled.
- The sequence of fast_pool -> input_pool -> extract_buf() operations
  is to be considered a "non-vetted conditioning component" in SP800-90B
  speak. It would follow that the output can't be estimated as having full
  entropy, but only 0.999 of its length at max. (c.f. sec. 3.1.5.2). This
  could be resolved by running a SP800-90A derivation function at CRNG
  reseeding for fips_enabled. extract_buf(), which is already SHA1 based,
  could perhaps be transformed into such one as well.
- The only mention of combining different noise sources I was able to find
  had been in SP800-90C, sec. 5.3.4 ("Using Multiple Entropy Sources"):
  it clearly states that the outputs have to be combined by concatenation.
  add_hwgenerator_randomness() mixes into the same input_pool as
  add_interrupt_randomness() though and I would expect that this isn't
  allowed, independent of whether the noise source backing the former
  is SP800-90B compliant or not. IIUC, Stephan solved this for his LRNG
  by maintaing a separate pool for the hw generator.
- SP800-90A sets an upper bound on how many bits may be drawn from a
  DRBG/crng before a reseed *must* take place ("reseed_interval"). In
  principle that shouldn't matter much in practice, at least not with
  CONFIG_NUMA: with reseed_interval == 2^32 bits, a single CRNG instance
  would be allowed to hand out only 500MB worth of randomness before
  reseeding, but a (single) numa crng chained to the primary_crng may
  produce as much as 8PB before the latter must eventually get reseeded
  from the input_pool. But AFAICT, a SP800-90A conforming implementation
  would still have to provide provisions for a blocking extract_crng().
- It's entirely unclear to me whether support for "prediction resistance
  requests" is optional. It would be a pity if it weren't, because IIUC
  that would effectively imply a return to the former blocking_pool
  behaviour, which is obviously a no-no.


Nicolai Stange (41):
  random: remove dead code in credit_entropy_bits()
  random: remove dead code for nbits < 0 in credit_entropy_bits()
  random: prune dead assignment to entropy_bits in credit_entropy_bits()
  random: drop 'reserved' parameter from extract_entropy()
  random: don't reset entropy to zero on overflow
  random: factor the exponential approximation in credit_entropy_bits()
    out
  random: let pool_entropy_delta() take nbits in units of
    2^-ENTROPY_SHIFT
  random: introduce __credit_entropy_bits_fast() for hot paths
  random: protect ->entropy_count with the pool spinlock
  random: implement support for delayed entropy dispatching
  random: convert add_timer_randomness() to queued_entropy API
  random: convert add_interrupt_randomness() to queued_entropy API
  random: convert try_to_generate_entropy() to queued_entropy API
  random: drop __credit_entropy_bits_fast()
  random: convert add_hwgenerator_randomness() to queued_entropy API
  random: convert random_ioctl() to queued_entropy API
  random: drop credit_entropy_bits() and credit_entropy_bits_safe()
  random: move arch_get_random_seed() calls in crng_reseed() into own
    loop
  random: reintroduce arch_has_random() + arch_has_random_seed()
  random: provide min_crng_reseed_pool_entropy()
  random: don't invoke arch_get_random_long() from
    add_interrupt_randomness()
  random: introduce arch_has_sp800_90b_random_seed()
  random: don't award entropy to non-SP800-90B arch RNGs in FIPS mode
  init: call time_init() before rand_initialize()
  random: probe cycle counter resolution at initialization
  random: implement support for evaluating larger fast_pool entropies
  random: increase per-IRQ event entropy estimate if in FIPS mode
  random: don't award entropy to disk + input events if in FIPS mode
  random: move definition of struct queued_entropy and related API
    upwards
  random: add a queued_entropy instance to struct fast_pool
  random: introduce struct health_test + health_test_reset()
    placeholders
  random: introduce health test stub and wire it up
  random: make health_test_process() maintain the get_cycles() delta
  random: implement the "Adaptive Proportion" NIST SP800-90B health test
  random: improve the APT's statistical power
  random: optimize the APT's presearch
  random: implement the "Repetition Count" NIST SP800-90B health test
  random: enable NIST SP800-90B startup tests
  random: make the startup tests include muliple APT invocations
  random: trigger startup health test on any failure of the health tests
  random: lower per-IRQ entropy estimate upon health test failure

 arch/arm64/include/asm/archrandom.h   |   33 +-
 arch/powerpc/include/asm/archrandom.h |   17 +-
 arch/s390/include/asm/archrandom.h    |   19 +-
 arch/x86/include/asm/archrandom.h     |   26 +-
 drivers/char/random.c                 | 1141 ++++++++++++++++++++++---
 include/linux/random.h                |   17 +
 init/main.c                           |    2 +-
 7 files changed, 1101 insertions(+), 154 deletions(-)

--
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer

-- 
2.26.2

