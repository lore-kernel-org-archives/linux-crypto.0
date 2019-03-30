Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E8FC43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 05:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95DDA218AC
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 05:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553925192;
	bh=300x5lKN5PNp2ZSK0jpwu0my1uyo1fPRIJbpsqjvHa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vRzVlffkTCPADQLuPJnhdbnTzuau1mSv9Yv2uQfmStYBHbLtTxd+QHpBaKJw9zVGF
	 639uhEVdBzZcJ0sLAadqMANYjnFZY+9tTt9N8+d5viIAbYqxmmgrTFAKMhCMsRNA1Z
	 DrrXhnCQ5wGRDkgj2RlWQoKyXW2L6Jz7ur8C6vvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbfC3FxL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 01:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfC3FxL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 01:53:11 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B892D218A3;
        Sat, 30 Mar 2019 05:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553925190;
        bh=300x5lKN5PNp2ZSK0jpwu0my1uyo1fPRIJbpsqjvHa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DEHf6oJ32fW2O+3axS/D1HmmNYz7RNv8wkw4j7qARDmm/pnS7TK3zfULGB1dVKxgH
         iY6eMgwhoTYrs9dDzoapdngSGcT/2TDs04MGyYxHyak29Uq6aeHbI0ZnT7houMQper
         S2IMFs464djEZ65d+XB2ErGtoXJYqZ+t24FQQsGc=
Date:   Fri, 29 Mar 2019 22:53:08 -0700
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
Message-ID: <20190330055307.GA8001@sol.localdomain>
References: <20190322071122.6677-1-Jason@zx2c4.com>
 <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
 <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pAgi=Li_C5xEq7EfmNq5p4BRc3rDxXjiz+xz0rSYikXA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 25, 2019 at 12:57:20PM +0100, Jason A. Donenfeld wrote:
> Hey Herbert,
> 
> On Mon, Mar 25, 2019 at 12:52 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Sorry but adding new implementations of chacha20/poly1305 without
> > removing the existing ones is not acceptable.  I really think
> > we ought to separate the zinc interface from these new crypto
> > implementations.  They have nothing to do with each other.
> >
> > As we've been stuck on this point for so long, let's get the
> > ball rolling by first merging just the zinc interface itself
> > with the existing chacha20/poly1305 code.  Then we can replace
> > these implementations with your implementations without getting
> > bogged down by all these other discussions.
> >
> > AFAICS once we resolve Thomas's concerns with regards to the simd
> > patch, then we can merge the zinc interface right away and go from
> > there.
> 
> I think we're slightly closer to being same page, but I haven't
> followed up here yet because I was waiting for something else first.
> 
> Your previous patchset left out a few implementations and wasn't
> totally complete with regards to the glue code. I'm going to whip
> something up now that is Zinc, but where there's already an existing
> assembly implementation in the tree (i.e. Martin's code), it uses that
> instead of what I've been posting until now. Then, after that lands, I
> can post stand-alone patches for replacing the various
> implementations, and we can discuss those separately, alongside all
> the various discussion of verification and benchmarks and so forth.
> 
> So, I'll have something to examine somewhat soon. Working on it now.
> 
> Jason

FYI, today I started work on updating testmgr to do fuzz tests where it
generates random test vectors using the generic implementation of each hash,
skcipher, and aead algorithm registered with the crypto API, and tests the other
implementations against them.

poly1305-simd is among the failing algorithms because it loses carry bits when
handling long "all 0xff bytes" inputs.  poly1305-avx2-x86_64.S is definitely
broken, and poly1305-sse2-x86_64.S *might* be too.  I am working on a patch...

It would be interesting to hear whether the Zinc self-tests detect this too.  I
couldn't easily tell from testing Herbert's Zinc patch series, because it seemed
most of the Zinc self-tests were failing for other reasons.

FWIW, this type of thing is one of the reasons we made the performance-critical
part of Adiantum's hash function be NH rather than Poly1305, and for now
crypto/adiantum.c only uses the C implementation of Poly1305.  Fast NH
implementations are much simpler and less error-prone than Poly1305.  Of course,
proper testing will help a lot...

- Eric
