From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH  v2 3/3] crypto: qat - Add support for RSA algorithm
Date: Wed, 15 Jul 2015 23:16:44 +0800
Message-ID: <20150715151644.GA3508@gondor.apana.org.au>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1>
 <20150714183259.18949.581.stgit@tstruk-mobl1>
 <20150715130333.GA2006@gondor.apana.org.au>
 <55A676BF.3090500@intel.com>
 <20150715150939.GA3347@gondor.apana.org.au>
 <55A678EB.4020604@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43188 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbGOPQr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 11:16:47 -0400
Content-Disposition: inline
In-Reply-To: <55A678EB.4020604@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2015 at 08:14:51AM -0700, Tadeusz Struk wrote:
> On 07/15/2015 08:09 AM, Herbert Xu wrote:
> >> This is even more complicated because the user can first allocate request
> >> > and then call setkey causing fallback. I'm now thinking about adding the
> >> > limitation to rsa generic or I can still use rsa-generic which I know that
> >> > its ctx is smaller than mine. What do you think?
> > This would preclude any future assembly implementations from being
> > used.  Besides this is how we implement fallbacks everywhere else
> > in the crypto API so I don't see why this one should be different.
> 
> Are you ok if I just add the same constrains to rsa-generic?

Yes that would work.  Of course if any future hardware implementation
wanted to support other key sizes we'd have to add a fallback to qat.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
