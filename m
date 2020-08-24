Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195B6C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 11:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E632F2074D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 11:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHXLUy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 07:20:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58272 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgHXLUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 07:20:54 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kAAWw-00036n-GT; Mon, 24 Aug 2020 21:20:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Aug 2020 21:20:50 +1000
Date:   Mon, 24 Aug 2020 21:20:50 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 6/6] crypto: cmac - Use cbc skcipher instead of raw cipher
Message-ID: <20200824112050.GA23301@gondor.apana.org.au>
References: <20200818082410.GA24497@gondor.apana.org.au>
 <E1k7ww8-0000fp-U0@fornost.hmeau.com>
 <CAMj1kXH6FTYDvzpwmga5K_2SRDBCyfPOmJJd3JN2vUjZLzTL7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXH6FTYDvzpwmga5K_2SRDBCyfPOmJJd3JN2vUjZLzTL7w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 24, 2020 at 11:47:30AM +0200, Ard Biesheuvel wrote:
>
> OK, so you are using a page size buffer for every request in flight,
> and using that as a scratch buffer for the destination of the cbc()
> transform?

Not necessarily.  It'll only allocate the page if the request size
exceeds the buffer we already have in the request context.  The
request context size is dependent on the request context size of
the underlying CBC, but it should be at least 512 bytes long.

I should probably test always using the 512-byte buffer and perhaps
it might be good enough.

Note that the numbers I'm getting with aesni is already very close
to the numbers of the underly cbc-aesni encryption so there is not
much room for improvement.

> I am not a fan of this approach, tbh. High latency/high bandwidth
> users will cause lots of GFP_ATOMIC allocations, and synchronous CPU

We could make the request context size be at least 2048 bytes long
and that would obviate the need to allocate the page buffer.

In any case, the cost of the page allocation is going to be drowned
out by the crypto since this would only happen for large requests.

> implementations will cause lots of writes polluting the D-cache for no
> good reason. Non-cache coherent accelerators will cause unnecessary
> traffic on the memory bus in addition to the undesirable D-cache
> behavior.

Perhaps, but would this be significant compared to the crypto cost?
Only numbers can tell.

> What we could do instead is having a certain flag/behavior in skcipher
> where writes are omitted entirely, and cbcmac/cmac could opt into
> that. But imho, the best way to improve this is to have a new AES-NI
> asm helper (which I already implemented in my v2) that wraps the
> AES-NI primitives in the right way to implement cbcmac.

As I said before, I'm totally fine with a native aesni implementation
for ccm/cbcmac as long as it's fully async like everything else.  But
a ccm/cbcmac based on cbc still makes sense since we're not going to
reimplement the same thing in every crypto driver out there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
