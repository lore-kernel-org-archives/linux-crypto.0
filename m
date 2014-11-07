From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for
 userspace
Date: Fri, 7 Nov 2014 12:05:31 +0800
Message-ID: <20141107040531.GA9865@gondor.apana.org.au>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
 <20141106195953.13328.77022.stgit@tstruk-mobl1>
 <20141107025607.GA9474@gondor.apana.org.au>
 <545C3FDB.4010106@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34260 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKGEFi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 23:05:38 -0500
Content-Disposition: inline
In-Reply-To: <545C3FDB.4010106@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 06, 2014 at 07:43:23PM -0800, Tadeusz Struk wrote:
>
> Yes, I know that PF_ALG wasn't designed to expose hardware specific
> implementation, but the problem is that currently there is no interface
> that allows using HW acceleration for algorithms such as RSA, DSA, or
> Diffie-Hellman.
> Using PF_ALG works perfectly for this purpose. I can get around 130K RSA
> decrypt operations per second with 1024 bits modulus. This also scales
> very well for more accelerators.
> PF_ALG meant to be crypto interface for user space and this is what I'm
> using it for here :) Is there any way I can make it (more) acceptable?

I see.  What we need to do is first fold the current asymmetric
crypto code under crypto/asymmetric into the crypto API properly
and then export that through algif.

You can then simply implement a hardware driver for such algorithms
as you currently do for other crypto API algorithms.

I'll try to work on that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
