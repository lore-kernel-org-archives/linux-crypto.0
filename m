From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] camellia: code shrink
Date: Fri, 23 Nov 2007 21:06:24 +0800
Message-ID: <20071123130624.GE18862@gondor.apana.org.au>
References: <200711221441.45027.vda.linux@googlemail.com> <200711221445.02347.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1078 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755920AbXKWNW0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 08:22:26 -0500
Content-Disposition: inline
In-Reply-To: <200711221445.02347.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:45:02PM -0800, Denys Vlasenko wrote:
> On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> > Patches start from 5 because pathches 1..4 are already
> > in cryptodev-2.6.
> >
> > camellia5:
> >         Remove unused macro params.
> >         Use (u8)(expr) instead of (expr) & 0xff,
> >         helps gcc to realize how to use simpler commands.
> >         Move CAMELLIA_FLS macro closer to encrypt/decrypt routines.
> >
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
