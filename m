From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: implement new prng, Vegard's PRNG
Date: Fri, 27 Mar 2009 14:58:35 +0800
Message-ID: <20090327065835.GA27208@gondor.apana.org.au>
References: <20090225151243.GA31418@damson.getinternet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40498 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbZC0G6k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 02:58:40 -0400
Content-Disposition: inline
In-Reply-To: <20090225151243.GA31418@damson.getinternet.no>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 25, 2009 at 04:12:43PM +0100, Vegard Nossum wrote:
>
> I realize that submitting a non-cryptographically secure algorithm to a
> crypto mailing list might not make too much sense. On the other hand, it
> shouldn't hurt either, and I've written this, so why not? I don't know
> if this is actually useful for anything at all, so this patch is more of
> an "it exists" rather than a serious patch submission.
> 
> The only obvious property of this algorithm is its fixed, known sequence
> period.
> 
> (Note: I didn't actually test the code either, so it could all be wrong.)
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

If we actually had an in-kernel user for this then I'd be more
than happy to add this :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
