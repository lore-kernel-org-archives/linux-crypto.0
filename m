From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Sun, 3 May 2015 08:07:44 +0800
Message-ID: <20150503000744.GB16211@gondor.apana.org.au>
References: <20150430223652.10157.86151.stgit@tstruk-mobl1>
 <20150430223647.10157.82156.stgit@tstruk-mobl1>
 <4227.1430496240@warthog.procyon.org.uk>
 <5543C348.9060004@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, linux-kernel@vger.kernel.org, steved@redhat.com,
	vgoyal@redhat.com, james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39995 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbECAIU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 May 2015 20:08:20 -0400
Content-Disposition: inline
In-Reply-To: <5543C348.9060004@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 01, 2015 at 11:17:44AM -0700, Tadeusz Struk wrote:
>
> I'm fine with pkey. Herbert do you have preference with regards 'algo' vs 'alg'?

For interfaces with the crypto API alg should be used otherwise
you can use algo or whatever you like.

> >>  #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
> >> > +#define CRYPTO_ALG_TYPE_PKE		0x0000000b
> >> >  #define CRYPTO_ALG_TYPE_RNG		0x0000000c
> > Will filling a hole cause a problem with something that got obsoleted?
> 
> I hope not. I checked as far back as 2.6.18 and I don't see any clash.
> Herbert, what do you think?

Indeed you can't use this hole as it'll make you a hash algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
