From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [-mm patch] crypto/xcbc.c: make some code static
Date: Fri, 17 Nov 2006 13:44:16 +1100
Message-ID: <20061117024416.GA17286@gondor.apana.org.au>
References: <20061114014125.dd315fff.akpm@osdl.org> <20061117011929.GP31879@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:25617 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1424304AbWKQCoZ
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Nov 2006 21:44:25 -0500
To: Adrian Bunk <bunk@stusta.de>
Content-Disposition: inline
In-Reply-To: <20061117011929.GP31879@stusta.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 17, 2006 at 02:19:29AM +0100, Adrian Bunk wrote:
> On Tue, Nov 14, 2006 at 01:41:25AM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.19-rc5-mm2:
> >...
> >  git-cryptodev.patch
> >...
> >  git trees
> >...
> 
> This patch makes some needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Both patches applied.  Thanks Adrian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
