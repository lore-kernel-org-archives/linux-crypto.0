From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PadLock XSHA
Date: Sun, 31 Aug 2008 12:09:41 +1000
Message-ID: <20080831020941.GA25048@gondor.apana.org.au>
References: <20080830084316.GA19371@gondor.apana.org.au> <48B918F4.9030604@logix.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46471 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755005AbYHaCJp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Aug 2008 22:09:45 -0400
Content-Disposition: inline
In-Reply-To: <48B918F4.9030604@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 30, 2008 at 09:55:00PM +1200, Michal Ludvig wrote:
> 
> IIRC The first versions of VIA PadLock required the input data to be
> aligned on 16-bytes boundaries and more importantly they always
> finalised the hash. Therefore we had to collect all data before hashing
> them.

Hmm, the current manual states that it does a bswap on the input
and therefore alignment isn't required.  There is no mention about
older processors requiring 16-byte alignment.

Do you know if the old alignment requirement is documented anywhere?
Or even better do you have a processor that enforces this?

Not requiring the alignment would allow IPsec at least to avoid
having to copy the data.

> AFAIK Recent versions of PadLock don't insist on finalising the hash and
>  don't insist on input data alignment either and this workaround isn't
> needed anymore. I don't know if VIA still sells their motherboard models
> with the older CPUs or not.

Interesting.  I couldn't find anything in the manual about not
requireing finalisation.  Do you know where I can find out more
about this?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
