Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E812C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 16:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C1E621901
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563811567;
	bh=tPhWxppzQ9To3DzQHH984V//T4fEj7TpwRH9er1GsAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k/iP7lYL+eW9JtH+u+xHg3k+6C6vGsH2OoXIGmTWWnLZgJ5q878R4dYZlIytJyV71
	 w1C1C+R0IXwtmeSwHWHBFiNsCUdjcOkOXw8Pmnj2Tt0rqKnBQAHqCS16cT/INUeTo8
	 RAeH9QPly08eGYEYqbWEGfgV2OLZCoUsAc3B4P1g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfGVQGF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbfGVQGF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 12:06:05 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF216218EA;
        Mon, 22 Jul 2019 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563811565;
        bh=tPhWxppzQ9To3DzQHH984V//T4fEj7TpwRH9er1GsAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UAuJkNdXQhCOdAp0MT2zcXaS3tGuxAl12DW2j+YJoxuzi2U+ec4ipzNkhfrsJjopa
         7YDOvKd2/rOafBd2ICaDU4ItVx9pO/lcE9CwDYsjpUtjC6gpVXSRuR1cXiOIBabLCE
         oCH0c6BihHKKNecimmRUg1kB4l7iorwBvkcpJ+VY=
Date:   Mon, 22 Jul 2019 09:06:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: Testmgr fuzz testing
Message-ID: <20190722160603.GA689@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB2973F2047FCE9EA5794E7DF7CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973F2047FCE9EA5794E7DF7CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Mon, Jul 22, 2019 at 10:27:22AM +0000, Pascal Van Leeuwen wrote:
> Eric,
> 
> While fixing some issues in the inside-secure driver reported by the fuzz, I noticed that the
> results are actually not repeatable: odds are  high that on the next run, the error case is 
> actually not hit anymore since they're typically very specific  corner cases.
> 
> There's 2 problems with that:
> a) Without repeatability, I cannot verify whether my fix actually worked. In fact, I cannot
> even verify with any certainty that any modification I do won't fail somewhere else :-(
> b) Odds are very significant that important corner cases are not hit by the fuzzing
> 
> Issue a) is usually solved by making the random generation deterministic, i.e. ensure
> you seed it with a known constant and pull the random numbers strictly sequentially.
> (you may or may not add the *option* to  pull the seed from some true random source)
> 
> Issue b) would be best solved by splitting the fuzz testing into two parts, a (properly
> constrained!) random part and a part with fixed known corner cases where you use
> constant parameters (like lengths and such) but depend on the generic implementation
> for the actual vector generation (as specifications usually don't provide vectors for
> all interesting corner cases but we consider the generic implementation to be correct) 
> 

Sure, it's not always repeatable, but that's the nature of fuzz testing.  We
*could* start with a constant seed, but then all the random numbers would change
every time anyone made any minor change to the fuzz tests anyway.

In my experience the bugs found by the fuzz tests tend to be found within a
couple hundred iterations, so are seen within a few boots at most with the
default fuzz_iterations=100, and are "always" seen with fuzz_iterations=1000.
Raising fuzz_iterations to 10000 didn't find anything else.

If you find otherwise and come across some really rare case, you should either
add a real test vector (i.e. not part of the fuzz tests) for it, or you should
update the fuzz tests to generate the case more often so that it's likely to be
hit with the default fuzz_iterations=100.  I don't think it's necessary to split
the fuzz testing into 2 parts; instead we just need to boost the probability of
generating known edge cases (e.g. see what generate_random_bytes() already does).

- Eric
