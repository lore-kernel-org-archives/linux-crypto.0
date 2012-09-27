From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: testmgr - make test_aead also test 'dst !=
 src' code paths
Date: Wed, 26 Sep 2012 22:45:20 -0700
Message-ID: <20120927054519.GG22311@gondor.apana.org.au>
References: <20120921072647.11790.19493.stgit@localhost6.localdomain6>
 <20120921072652.11790.31387.stgit@localhost6.localdomain6>
 <20120921.121158.1208631613521248347.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59041 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754729Ab2I0FpX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:45:23 -0400
Content-Disposition: inline
In-Reply-To: <20120921.121158.1208631613521248347.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 21, 2012 at 12:11:58PM -0400, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Fri, 21 Sep 2012 10:26:52 +0300
> 
> > Currrently test_aead uses same buffer for destination and source. However
> > in any places, 'dst != src' take different path than 'dst == src' case.
> > 
> > Therefore make test_aead also run tests with destination buffer being
> > different than source buffer.
> > 
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
