From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Mon, 2 Feb 2009 14:44:03 +1100
Message-ID: <20090202034403.GA9089@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com> <20090116033105.GB10390@gondor.apana.org.au> <1232591537.6101.3.camel@yhuang-dev.sh.intel.com> <20090122030400.GA10229@gondor.apana.org.au> <1232608558.6101.13.camel@yhuang-dev.sh.intel.com> <20090122073040.GA12395@gondor.apana.org.au> <1233545425.19806.44.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60986 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbZBBDoJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Feb 2009 22:44:09 -0500
Content-Disposition: inline
In-Reply-To: <1233545425.19806.44.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 02, 2009 at 11:30:25AM +0800, Huang Ying wrote:
> 
> The only needed spin lock usage is cryptd_tfm_in_queue() now, I think we
> can protect that via RCU, what's your opinions?

We should just get rid of cryptd_tfm_in_queue since it's only used
for debugging.

> But I think the simplest method to pass requests to specified CPU is via
> work queue (queue_work_on()). We can add a function named
> cryptd_enqueue_request_on(), and construct a load-balance version cryptd
> on top of that.

That's fine by me.  I'm not so worried whether the load-balancing
version exists as a template alongside cryptd or on top of cryptd.

However, the default cryptd should definitely not perform balancing.
Also note that not doing balancing does not mean that we only use
one CPU.  cryptd should simply use the CPU on which the request was
received.  So if the requests are received in parallel then the work
would be carried out in parallel.

The load-balancing version would also need to ensure that the
completion handlers are invoked in the exact order in which the
requests were received since this is crucial for IPsec.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
