From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PadLock XSHA
Date: Sat, 30 Aug 2008 23:21:04 +1000
Message-ID: <20080830132104.GA20867@gondor.apana.org.au>
References: <20080830084316.GA19371@gondor.apana.org.au> <48B918F4.9030604@logix.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44569 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbYH3NVJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Aug 2008 09:21:09 -0400
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

Ah yes, the finalisation is the killer.

I'm working on a new sync hash interface that moves the state
out of the tfm and was just thinking of how padlock-sha would
work within that.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
