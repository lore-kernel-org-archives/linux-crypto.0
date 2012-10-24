From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] New test vectors for camellia, blowfish, serpent,
 aes, des and des3_ede
Date: Wed, 24 Oct 2012 21:11:34 +0800
Message-ID: <20121024131134.GA3251@gondor.apana.org.au>
References: <20121020115050.17179.44149.stgit@localhost6.localdomain6>
 <20121020.135110.1138754268310415632.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:40748 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402Ab2JXNLk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2012 09:11:40 -0400
Content-Disposition: inline
In-Reply-To: <20121020.135110.1138754268310415632.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 20, 2012 at 01:51:10PM -0400, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Sat, 20 Oct 2012 14:52:41 +0300
> 
> > Test vectors for camellia, blowfish and serpent are expanded for future
> > implementations.
> > 
> > New test vectors for aes, des and des3_ede are added to test existing
> > implementations.
> > 
> > ---
> > 
> > Jussi Kivilinna (6):
> >       crypto: testmgr - expand camellia test vectors
> >       crypto: testmgr - expand blowfish test vectors
> >       crypto: testmgr - expand serpent test vectors
> >       crypto: testmgr - add new larger AES testvectors
> >       crypto: testmgr - add new larger DES testvectors
> >       crypto: testmgr - add new larger DES3_EDE testvectors
> 
> Thanks for doing this work:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
