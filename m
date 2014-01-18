From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/2] crypto: Simple crypto algorithm load balancer
Date: Sat, 18 Jan 2014 20:11:45 +0800
Message-ID: <20140118121145.GA19982@gondor.apana.org.au>
References: <52d9ced0.jqhVV3OvRxex2A9/%tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:39106 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaARMLw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Jan 2014 07:11:52 -0500
Content-Disposition: inline
In-Reply-To: <52d9ced0.jqhVV3OvRxex2A9/%tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 18, 2014 at 12:46:08AM +0000, Tadeusz Struk wrote:
> Hi,
> In case of multiple crypto devices implementing the same algorithms
> the arbitration, which one to use is based on the cra_priority.
> Currently the algorithm with the highest priority is always be used.
> In case of two algorithms with the same priority the one added last is used.
> There is no load balancing and on a busy system there can be a situation when
> there more crypto accelerators, but only one is used for all crypto jobs
> and the others sit idle.
> This patch implements a simple load balancing based on the priority
> of an algorithm and its usage refctr. The distribution for 10 algorithms
> and 3000000 tfm_alloc allocations is as follows:

Have you looked at pcrypt and whether it can be extended to handle
this or perhaps something similar to pcrypt can be created?

Hard-coding this into the API seems a bit heavy-handed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
