From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/5] camellia: code shrink #3
Date: Fri, 23 Nov 2007 21:14:59 +0800
Message-ID: <20071123131459.GG18862@gondor.apana.org.au>
References: <200711221441.45027.vda.linux@googlemail.com> <200711221443.55302.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1076 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755935AbXKWNWZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Nov 2007 08:22:25 -0500
Content-Disposition: inline
In-Reply-To: <200711221443.55302.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 02:43:55PM -0800, Denys Vlasenko wrote:
> On Thursday 22 November 2007 14:41, Denys Vlasenko wrote:
> > camellia7:
> >         Move "key XOR is end of F-function" code part into
> >         camellia_setup_tail(), it is sufficiently similar
> >         between camellia_setup128 and camellia_setup256.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com> 

Applied.  Thanks.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
