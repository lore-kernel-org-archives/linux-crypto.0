From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
	skcipher operations
Date: Fri, 26 Nov 2010 20:57:08 +0800
Message-ID: <20101126125708.GA28786@gondor.apana.org.au>
References: <20101115115120.GA3797@gondor.apana.org.au> <E1PHxca-00011N-As@gondolin.me.apana.org.au> <1289832949.1979.71.camel@martin> <20101119095136.GA22665@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41936 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZM5N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Nov 2010 07:57:13 -0500
Content-Disposition: inline
In-Reply-To: <20101119095136.GA22665@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 19, 2010 at 05:51:36PM +0800, Herbert Xu wrote:
> 
> Miroslave found quite a few more problems with the patch-set
> so here is another revision with those problems resolved:

OK two more bugs found and fixed so here is one more revision:

* If recvmsg leaves bytes behind in the last SG entry it gets
  freed incorrectly.
* sendmsg's SG loop did not apply the socket limit, causing
  crashes with large sends.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
