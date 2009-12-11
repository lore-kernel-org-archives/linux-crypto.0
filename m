From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/12] crypto: Correct size given to memset
Date: Fri, 11 Dec 2009 23:09:19 +0800
Message-ID: <20091211150919.GB736@gondor.apana.org.au>
References: <Pine.LNX.4.64.0912092022500.1870@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45409 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757923AbZLKPJR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2009 10:09:17 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912092022500.1870@ask.diku.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2009 at 08:23:09PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Memset should be given the size of the structure, not the size of the pointer.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> T *x;
> expression E;
> @@
> 
> memset(x, E, sizeof(
> + *
>  x))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Luckily these functions aren't used by anything.  Perhaps we
should get rid of them altogether.

Anyway, I've applied your patch.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
