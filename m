Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20F9C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 18:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C41672085A
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554057776;
	bh=rjjtmntnms3fEb/NXZwocY6kJ1asFY7ljJalC3VpySE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YT7dC7MPaR0nJCg6XguRYn9clTRE8is+yPEwydk6OpPCAjbsxWs4j0dala+mdhbcP
	 N6fpq3C7kLrzcWb56WqKqgsOgcRt4+NcO0fEOvH97PIajcg8rQBY4j+DXxfGkhPhr5
	 zKqf3jOCb6v1Bv3Q59OT4HSbrx5khsywdNoiCd7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbfCaSmt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 14:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfCaSms (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 14:42:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4A620882;
        Sun, 31 Mar 2019 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554057767;
        bh=rjjtmntnms3fEb/NXZwocY6kJ1asFY7ljJalC3VpySE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PE6DPbJOoyxXsqeIG6IPLu1qBSMnl9gg8SERBHu22q0rTAKajhxfs9KT6XC4FQWsq
         D65uRyo8z4vrrXB4QmfHdTlaao6tPUGA3mI9hPJ8KRV5UH2JkQcvpBEYBBDAMI1T36
         l553dAhXs3jb4SBF0vsomMxsjKzuocWBpLHUXlco=
Date:   Sun, 31 Mar 2019 11:42:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Samuel Neves <samuel.c.p.neves@gmail.com>
Subject: Re: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
Message-ID: <20190331184244.GA723@sol.localdomain>
References: <20190322071122.6677-1-Jason@zx2c4.com>
 <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
 <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
 <20190330055307.GA8001@sol.localdomain>
 <CAHmME9o+HqyrXX403bSXJX4Xs0dsZ9Qo=owiu7QGzBbaLQWZag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9o+HqyrXX403bSXJX4Xs0dsZ9Qo=owiu7QGzBbaLQWZag@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 31, 2019 at 08:18:13PM +0200, Jason A. Donenfeld wrote:
> On Sat, Mar 30, 2019 at 6:53 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > poly1305-simd is among the failing algorithms because it loses carry bits when
> > handling long "all 0xff bytes" inputs.  poly1305-avx2-x86_64.S is definitely
> > broken, and poly1305-sse2-x86_64.S *might* be too.  I am working on a patch...
> 
> Yea.... yikes. I'm kind of souring on this plan of having to deal with
> that code in Zinc, versus the extensively studied, fuzzed, and
> scrutinized code from Andy. Subtle carry bugs like that are kind of a
> testament to my overall plan of preferring formally verified or
> heavily used implementations to bespoke ones. This stuff is hard to
> get right.
> 
> Jason

I agree that Andy's Poly1305 code is better and we should probably switch to it,
but to be fair it's also longer and more complex, and I think you overestimate
the extent to which it's actually been "studied, fuzzed, and scrutinized".  Andy
previously made essentially the same mistake in three of his Poly1305
implementations as well, which he had to fix:
https://mta.openssl.org/pipermail/openssl-commits/2016-April/006639.html

Also OpenSSL's PowerPC implementation of AES-CTR that was incorporated into the
kernel was incorrect, as was recently fixed by

	commit dcf7b48212c0fab7df69e84fab22d6cb7c8c0fb9
	Author: Daniel Axtens <dja@axtens.net>
	Date:   Fri Mar 15 13:09:01 2019 +1100

	    crypto: vmx - fix copy-paste error in CTR mode
	    
	    The original assembly imported from OpenSSL has two copy-paste
	    errors in handling CTR mode. When dealing with a 2 or 3 block tail,
	    the code branches to the CBC decryption exit path, rather than to
	    the CTR exit path.
	
and by https://github.com/openssl/openssl/pull/8510.  This took almost 5 years.

I also still think the extent that you keep emphasizing the phrase "formally
verified" when discussing Zinc is somewhat misleading, because the only
implementation that is actually formally verified is Curve25519 in C.  No other
algorithms or implementations are formally verified.  E.g. none of the Poly1305
implementations under discussion are formally verified.  That needs to be made
very clear, and as one consequence of that we really need good tests.

- Eric
