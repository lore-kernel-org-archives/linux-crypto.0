From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Tue, 8 Sep 2015 09:07:00 +0800
Message-ID: <20150908010700.GA4927@gondor.apana.org.au>
References: <55ED9FDC.60602@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andrew.zaborowski@intel.com, smueller@chronox.de,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37125 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbIHBHK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 21:07:10 -0400
Content-Disposition: inline
In-Reply-To: <55ED9FDC.60602@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>
> The more I think about the sgl support the more it looks to me like it wasn't
> a good idea. It will be copied into a flat buffer somewhere along the way anyway.
> Like in the example below.
> 
> I have that conversion already done, and for SW it looks like the data is copied 4 times
> for a single operation:
> 1 - from sgl to flat buffer, because MPI doesn't take sgls, (if the src has more ents)
> 2 - from buff to MPI, then, after operation
> 3 - export from MPI to a buff and
> 4 - from buff to sgl (if is the output sg it also fragmented).
> 
> I can see now that with all these padding schemes there will be more buffer copied
> on top of this, so I wonder if it still make sense.
> Herbert?

I think it makes sense.  Because to implement algif_akcipher
someone will need to do the linearisation anyway.  Moreover there
is hardware out there that handles this transparently and we should
not cripple them.

We should add MPI helpers to read/write SG lists which can then
be used by those implementations that need the capability.  For
the sake of simplicity you can simply start with a copy but later
we can optimise it to be smarter.

You can always have a fast-path for the case where the SG list is
a single entry.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
