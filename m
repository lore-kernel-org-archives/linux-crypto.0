Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99240C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 23:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B43D2199C
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 23:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563836807;
	bh=ZJvWdGAmjpwuROfulbFGFibDBCPC8E0IzD64NPvqyq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TbrUvgyu1TDmU4tCWjJRxFx8njV1sS+v9CIIuwJPNmsOmafoZO3i2C08W6U9CV7dc
	 vmeES6nF2UKsVYEtHeTTGMqUGYy6qe8TvnRJtnp7e3g/xj4Yyueeq/xIXXdm0BdiYZ
	 zk06BZvvxEwfWW984mTGiTwSWkSnHpY4b5uMzJAw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbfGVXGq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 19:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbfGVXGq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 19:06:46 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4941C21955;
        Mon, 22 Jul 2019 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563836804;
        bh=ZJvWdGAmjpwuROfulbFGFibDBCPC8E0IzD64NPvqyq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8ovMaFJx/qiyD1WLqolunp3g8JR/gdWi44qe/m4BYzkdqXnw1ctkReuq6uu7PMWw
         UNi0ATPua7LcCKF3VsL1C0dN/jh+BL6Jf+PnoOOt2SiR1TKg+bAcE5pLx5WJyUx5Wc
         5fMCiRPCVX+1CWKhocUnVljn8WDxkcQoibBsLyh4=
Date:   Mon, 22 Jul 2019 16:06:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Testmgr fuzz testing
Message-ID: <20190722230641.GA22126@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB2973F2047FCE9EA5794E7DF7CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722160603.GA689@sol.localdomain>
 <MN2PR20MB2973E558C4C8732708EF3A06CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973E558C4C8732708EF3A06CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 22, 2019 at 10:09:03PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Monday, July 22, 2019 6:06 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au>; davem@davemloft.net
> > Subject: Re: Testmgr fuzz testing
> > 
> > Hi Pascal,
> > 
> > On Mon, Jul 22, 2019 at 10:27:22AM +0000, Pascal Van Leeuwen wrote:
> > > Eric,
> > >
> > > While fixing some issues in the inside-secure driver reported by the fuzz, I noticed that the
> > > results are actually not repeatable: odds are  high that on the next run, the error case is
> > > actually not hit anymore since they're typically very specific  corner cases.
> > >
> > > There's 2 problems with that:
> > > a) Without repeatability, I cannot verify whether my fix actually worked. In fact, I cannot
> > > even verify with any certainty that any modification I do won't fail somewhere else :-(
> > > b) Odds are very significant that important corner cases are not hit by the fuzzing
> > >
> > > Issue a) is usually solved by making the random generation deterministic, i.e. ensure
> > > you seed it with a known constant and pull the random numbers strictly sequentially.
> > > (you may or may not add the *option* to  pull the seed from some true random source)
> > >
> > > Issue b) would be best solved by splitting the fuzz testing into two parts, a (properly
> > > constrained!) random part and a part with fixed known corner cases where you use
> > > constant parameters (like lengths and such) but depend on the generic implementation
> > > for the actual vector generation (as specifications usually don't provide vectors for
> > > all interesting corner cases but we consider the generic implementation to be correct)
> > >
> > 
> > Sure, it's not always repeatable, but that's the nature of fuzz testing.  
> >
> No. It's not repeatable *at all*. The odds of getting the exact same sequence of random
> numbers should approach zero, assuming that random generator is half decent and 
> properly seeded with another (true?) random value. 
> 
> For us hardware engineers, (constrained) random testing is our bread and butter.
> Given the design complexity we're dealing with today and the fact that any serious bug may 
> actually put us out of business (considering mask costs and respin turnaround), it's the only 
> way to cope. So I have many years of experience and I can assure you that being "not always
> repeatable" does not NEED to be the "nature of fuzz testing".  As one of the first things you 
> learn (the hard way) is to log the random seed(s) and make them controllable ... somehow.
> Because nothing is as frustrating as finding a bug after days of simulation and then
> not being able to reproduce it with waves and debugging enabled ...
> 
> >We *could* start with a constant seed, but then all the random numbers would change
> > every time anyone made any minor change to the fuzz tests anyway.
> > 
> Yes, this is a well known fact: any change to either the design, the test environment or
> the test itself may affect the random generation and cause different behavior.
> Which may be a problem if you want to hit a specific case with 100% certainty - in
> which case you should indeed make a dedicated test for that instead.
> (but usually, you don't realise the corner case exists until you first hit it ...)
> 
> *However* this is NOT relevant to the repeatability-for-debugging situation, as in
> that case, you should should not change *anything* until you've thoroughly root-
> caused the issue. (or created a baseline in your source control system such that you
> can always go back to the *exact* situation  that caused the error).
> This is (hardware) verification 101.

I meant repeatable in the sense that the same bug is hit, even if the generated
test case is not 100% identical.

Anyway, you're welcome to send a patch changing the fuzzing code to use a
constant seed, if you really think it would be useful and can provide proper
justification for it.  I'm not sure why you keep sending these long rants, when
you could simply send a patch yourself.

> 
> > In my experience the bugs found by the fuzz tests tend to be found within a
> > couple hundred iterations, so are seen within a few boots at most with the
> > default fuzz_iterations=100, and are "always" seen with fuzz_iterations=1000.
> > Raising fuzz_iterations to 10000 didn't find anything else.
> > 
> That may be because you've been working mostly with software implementations
> which were already in pretty good shape to begin with. Hardware tends to have 
> many more (tricky) corner cases.
> The odds of hitting a specific corner case in just 100 or 1000 vectors is really not
> as high as you may think. Especially if many of the vectors being generated are
> actually illegal and just test for proper error response from the driver.
> 
> Just try to compute the (current) odds of getting an AAD length and cipher text
> length that are zero at the same time. Which is a relevant corner case at least for
> our hardware. In fact, having the digestsize zero at the same time as well is yet 
> another corner case requiring yet another workaround. The odds of those 3 
> cases colliding while generating random lengths over a decent range are really,
> really slim.
> 
> Also, how fast you can reboot depends very much on the platform you're 
> working on. It quickly becomes annoying if rebooting takes minutes and plenty
> of manual interaction. Speaking from experience.
> 
> > If you find otherwise and come across some really rare case, you should either
> > add a real test vector (i.e. not part of the fuzz tests) for it, 
> >
> The problem with "generating a test vector for it" is that it requires a known-
> good reference implementation, which is usually hard to find. And then you
> have to convert it to testmgr.h format and add it there manually. Which is both
> cumbersome and will cause testmgr.h (and kernel size) to explode at some point.
> 
> While in the overal majority of cases you don't really care about the input data
> itself at all, so it's fine to generate that randomly, what you care about are things 
> like specific lengths, alignments, sizes, IV (counter) values and combinations thereof.
> 
> Also, adding those as "normal" test vectors will cause the normal boot produre to
> slow to a crawl verifying  loads of obscure corner cases that are really only relevant
> during development anyway. 
> 
> And why bother if you have the generic implementation available to do all 
> this on-the-fly and only with the extra tests enabled, just like you do with the full 
> random vectors?
> 
> It was just a crazy idea anyway, based on a real-life observation I made.

Being too lazy to add a test vector isn't really an excuse, and it won't bloat
the kernel size or boot time unless you add a massive number of test vectors or
if they use very large lengths.  We could even make certain test vectors
conditional on CONFIG_CRYPTO_MANAGER_EXTRA_TESTS if it's an issue...

> 
> > or you should
> > update the fuzz tests to generate the case more often so that it's likely to be
> > hit with the default fuzz_iterations=100.  
> >
> Running just 10 times more iterations is really not going to be sufficient to hit
> the really tricky *combinations* of parameters, considering the ranges of the
> individual parameters. Just do some statistics on that and you'll soon realise.
> 
> Just some example for the AEAD corner case I mentioned before:
> 
> The odds of generating a zero authsize are 1/4 * 1/17 = 1/68. But that will still
> need to coincide with all other parameters (including key sizes) being legal.
> So there already, your 100 iterations come short.
> 
> A zero length AAD *and* plaintext happens only once every 8000+ vectors.
> And that also still has to coincide with key sizes etc. being legal. So there even
> 10000 iterations would not be enough to be *sure* to hit that.
> 
> To have some reasonable shot at hitting the combination those two cases
> you'd need well over a million iterations ...
> 
> > I don't think it's necessary to split
> > the fuzz testing into 2 parts; instead we just need to boost the probability of
> > generating known edge cases (e.g. see what generate_random_bytes() already does).
> > 
> I guess somehow tweaking the random generation such that the probability of 
> generating the interesting cases becomes *significantly* higher would work too.
> To me, that's just implementation detail though.
> 

Like I said, if you encounter bugs that the fuzz tests should be finding but
aren't, it would be really helpful if you added test vectors for them and/or
updated the fuzz tests to generate those cases more often.  I was simply
pointing out that to do the latter, we don't really need to split the tests into
2 parts; it would be sufficient just to change the probabilities with which
different things are generated.  Note that the probabilities can be conditional
on other things, which can get around the issue where a bunch of small
independent probabilities are multiplied together.

- Eric
