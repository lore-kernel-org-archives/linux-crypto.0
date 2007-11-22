From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] camellia: 64-bit optimization
Date: Thu, 22 Nov 2007 20:25:28 +0800
Message-ID: <20071122122528.GA9556@gondor.apana.org.au>
References: <200711210022.28510.vda.linux@googlemail.com> <200711210023.49410.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1676 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbXKVM2x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 07:28:53 -0500
Content-Disposition: inline
In-Reply-To: <200711210023.49410.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 21, 2007 at 12:23:49AM -0800, Denys Vlasenko wrote:
> On Wednesday 21 November 2007 00:22, Denys Vlasenko wrote:
> > Patches start from 5 because pathches 1..4 are already
> > in cryptodev-2.6.
> >
> > camellia5:
> >         adds 64-bit key setup, it is used if BITS_PER_LONG is 64.
> >
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Denys, I really appreciate your work in cleaning this algorithm up.

However, I just can't accept 600 lines of new code just to do setkey
faster/smaller on 64-bit platforms.  You know, some people have to
study these files line-by-line in order have them pass government
certifications and such.

OK I went back and looked at the figures, so we're talking about
either 1K extra on 64-bit if we use the 32-bit version or 2K extra
on 32-bit if we went for the 64-bit version.

Either way it doesn't seem to be a big deal.  So how about just
picking one and sticking with it?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
