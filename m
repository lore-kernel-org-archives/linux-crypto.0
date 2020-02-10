Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867E6C352A3
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 11:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B802082F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 11:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJLEn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 06:04:43 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:32912 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgBJLEn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 06:04:43 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j16rn-0002aQ-CC; Mon, 10 Feb 2020 19:04:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j16rf-00051U-QY; Mon, 10 Feb 2020 19:04:31 +0800
Date:   Mon, 10 Feb 2020 19:04:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Message-ID: <20200210110431.mhn7hlkmp3usad7s@gondor.apana.org.au>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain>
 <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
 <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com>
 <20200128211229.GA224488@gmail.com>
 <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
 <20200207072709.GB8284@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207072709.GB8284@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 06, 2020 at 11:27:09PM -0800, Eric Biggers wrote:
>
> Yes, for rfc4106 the tests don't pass the same IV in both places.  This is
> because I wrote the tests from the perspective of a generic AEAD that doesn't
> have this weird IV quirk, and then I added the minimum quirks to get the weird
> algorithms like rfc4106 passing.
> 
> Since the actual behavior of the generic implementation of rfc4106 is that the
> last 8 bytes of the AAD are ignored, that means that currently the tests just
> avoid mutating these bytes when generating inauthentic input tests.  They don't
> know that they're (apparently) meant to be another copy of the IV.
> 
> So it seems we need to clearly define the behavior when the two IV copies don't
> match.  Should one or the other be used, should an error be returned, or should
> the behavior be unspecified (in which case the tests would need to be updated)?
> 
> Unspecified behavior is bad, but it would be easiest for software to use
> req->iv, while hardware might want to use the IV in the scatterlist...
> 
> Herbert and Stephan, any idea what was intended here?

I think unspecified would be OK here to give the hardware the
maximum latitude.  However, we also don't want it to crash or
do something funny so perhaps generate the test vectors as you
do now but compare it against the generic using two IV values?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
