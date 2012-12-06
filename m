From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cast5/cast6 - move lookup tables to shared
 module
Date: Thu, 6 Dec 2012 17:19:03 +0800
Message-ID: <20121206091903.GA15870@gondor.apana.org.au>
References: <20121113094314.23872.30309.stgit@localhost6.localdomain6>
 <20121113.135304.281580343771830320.davem@davemloft.net>
 <20121113215020.841366cnfloetcsg@www.dalek.fi>
 <20121113.145246.1782542703964753357.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:34261 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754060Ab2LFJTK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Dec 2012 04:19:10 -0500
Content-Disposition: inline
In-Reply-To: <20121113.145246.1782542703964753357.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 13, 2012 at 02:52:46PM -0500, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Tue, 13 Nov 2012 21:50:20 +0200
> 
> > Quoting David Miller <davem@davemloft.net>:
> > 
> >> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> >> Date: Tue, 13 Nov 2012 11:43:14 +0200
> >>
> >>> CAST5 and CAST6 both use same lookup tables, which can be moved shared
> >>> module
> >>> 'cast_common'.
> >>>
> >>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> >>
> >> Does this work if you make CAST5 modular and CAST6 static, or vice
> >> versa?
> >>
> > 
> > Yes, dependencies force common module to be built-in/static in both
> > cases and will be build as module only if both cast5 and cast6 are
> > also.
> 
> Fair enough:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
