From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/5] camellia: code shrink #4
Date: Fri, 23 Nov 2007 21:22:01 +0800
Message-ID: <20071123132201.GH18862@gondor.apana.org.au>
References: <200711221441.45027.vda.linux@googlemail.com> <200711221444.24172.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1075 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755904AbXKWNWX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 08:22:23 -0500
Content-Disposition: inline
In-Reply-To: <200711221444.24172.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:44:24PM -0800, Denys Vlasenko wrote:
> On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> > camellia8:
> >         Analogously to camellia7 patch, move
> >         "absorb kw2 to other subkeys" and "absorb kw4 to other subkeys"
> >         code parts into camellia_setup_tail(). This further reduces
> >         source and object code size at the cost of two brances
> >         in key setup code.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com> 

Applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
