From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/5] camellia: code shrink #2
Date: Fri, 23 Nov 2007 21:12:29 +0800
Message-ID: <20071123131229.GF18862@gondor.apana.org.au>
References: <200711221441.45027.vda.linux@googlemail.com> <200711221443.25426.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1073 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755037AbXKWNWW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 08:22:22 -0500
Content-Disposition: inline
In-Reply-To: <200711221443.25426.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:43:25PM -0800, Denys Vlasenko wrote:
> On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> > camellia6:
> >         unifies encrypt/decrypt routines for different key lengths.
> >         This reduces module size by ~25%, with tiny (less than 1%)
> >         speed impact.
> >         Also collapses encrypt/decrypt into more readable
> >         (visually shorter) form using macros.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Also applied.  Thanks Denys!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
