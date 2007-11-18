From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sun, 18 Nov 2007 12:04:01 +0800
Message-ID: <20071118040401.GA25625@gondor.apana.org.au>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <20071117195324.GA4010@2ka.mipt.ru> <20071118031402.GA25388@gondor.apana.org.au> <473FB1E0.600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	mb@bu3sch.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4481 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752358AbXKREEW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 23:04:22 -0500
Content-Disposition: inline
In-Reply-To: <473FB1E0.600@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 18, 2007 at 04:30:40AM +0100, Patrick McHardy wrote:
>
> On a related issue, I think the rng interface is not very suitable
> for chips like HIFN that have a constant random bandwidth, it would
> make a lot more sense to return the time to wait to the core, instead
> of waiting 10us in all cases. 256 cycles at a speed of 266MHz comes
> down to 0.96us, so we're waiting about 10 times as long as necessary.
> Since its busy waiting anyway, I'd think that from a performance POV
> constant polling or returning the exact amount of time would be more
> reasonable.

I agree, a better interface would be to let the hardware do the
blocking where necessary.

Michael, what do you think about this?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
