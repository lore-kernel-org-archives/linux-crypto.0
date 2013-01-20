From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/12] crypto: x86 assembler cleanups
Date: Sun, 20 Jan 2013 11:13:48 +1100
Message-ID: <20130120001348.GG26742@gondor.apana.org.au>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
 <20130119.103950.1071013942843164207.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jussi.kivilinna@mbnet.fi, linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:54434 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389Ab3ATANw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 19:13:52 -0500
Content-Disposition: inline
In-Reply-To: <20130119.103950.1071013942843164207.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 19, 2013 at 10:39:50AM -0500, David Miller wrote:
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date: Sat, 19 Jan 2013 13:38:45 +0200
> 
> > Change x86 crypto implementations to use ENTRY()/ENDPROC() as linux/linkage.h 
> > recommends use of ENDPROC() for assembler functions.
> > 
> > While at it, also change jump targets to local labels for some implementations.
> 
> For series:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
