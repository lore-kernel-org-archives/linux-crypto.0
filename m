From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - add test vector for fcrypt
Date: Sun, 20 Jan 2013 11:13:38 +1100
Message-ID: <20130120001337.GF26742@gondor.apana.org.au>
References: <20130119113136.20877.48105.stgit@localhost6.localdomain6>
 <20130119.103908.912267263630916931.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:47279 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389Ab3ATANm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 19:13:42 -0500
Content-Disposition: inline
In-Reply-To: <20130119.103908.912267263630916931.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 19, 2013 at 10:39:08AM -0500, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Sat, 19 Jan 2013 13:31:36 +0200
> 
> > fcrypt is used only as pcbc(fcrypt), but testmgr does not know this.
> > Use the zero key, zero plaintext pcbc(fcrypt) test vector for
> > testing plain 'fcrypt' to hide "no test for fcrypt" warnings.
> > 
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
