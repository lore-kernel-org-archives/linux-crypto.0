From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - add missing tests for camellia and
 ghash
Date: Wed, 26 Sep 2012 22:45:34 -0700
Message-ID: <20120927054534.GH22311@gondor.apana.org.au>
References: <20120921072710.11930.17414.stgit@localhost6.localdomain6>
 <20120921.121204.1043966198515282180.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:42937 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755846Ab2I0Fph (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:45:37 -0400
Content-Disposition: inline
In-Reply-To: <20120921.121204.1043966198515282180.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 21, 2012 at 12:12:04PM -0400, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Fri, 21 Sep 2012 10:27:10 +0300
> 
> > Add missing tests for ctr(camellia), lrw(camellia), xts(camellia) and ghash,
> > as these have test vectors available.
> > 
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
