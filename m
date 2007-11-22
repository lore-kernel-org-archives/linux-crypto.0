From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] camellia: code shrink
Date: Thu, 22 Nov 2007 20:28:26 +0800
Message-ID: <20071122122826.GB9556@gondor.apana.org.au>
References: <200711210022.28510.vda.linux@googlemail.com> <200711210025.10316.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1674 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbXKVM2r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 07:28:47 -0500
Content-Disposition: inline
In-Reply-To: <200711210025.10316.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 21, 2007 at 12:25:10AM -0800, Denys Vlasenko wrote:
> On Wednesday 21 November 2007 00:22, Denys Vlasenko wrote:
> > camellia6:
> >         unifies encrypt/decrypt routines for different key lengths.
> >         This reduces module size by ~25%, with tiny (less than 1%)
> >         speed impact.
> >         Also collapses encrypt/decrypt into more readable
> >         (visually shorter) form using macros.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Sorry, this doesn't apply without applying 1/4.

You couldn't have picked a better patch order :)

Seriously, you'll make both of us happier if you put the easy
patches first and the contentious stuff at the end.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
