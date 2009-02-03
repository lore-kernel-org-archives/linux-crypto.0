From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: Per-CPU cryptd thread implementation based
	on kcrypto_wq
Date: Tue, 3 Feb 2009 20:21:48 +1100
Message-ID: <20090203092148.GA6402@gondor.apana.org.au>
References: <1233556940.19806.58.camel@yhuang-dev.sh.intel.com> <20090203011038.c12acc5b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55857 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbZBCJV4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2009 04:21:56 -0500
Content-Disposition: inline
In-Reply-To: <20090203011038.c12acc5b.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 03, 2009 at 01:10:38AM -0800, Andrew Morton wrote:
>
> > +{
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +	struct crypto_async_request *req, *backlog;
> > +
> > +	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
> > +	/* Only handle one request at a time to avoid hogging crypto
> > +	 * workqueue */
> 
> Not sure what that means.

It looks like this was copied from chainiv which put the work
in eventd, which is obviously no longer the case here.

> > +	if (!req)
> > +		goto out;
> > +
> > +	if (backlog)
> > +		backlog->complete(backlog, -EINPROGRESS);
> > +	req->complete(req, 0);
> > +out:
> > +	if (cpu_queue->queue.qlen)
> > +		queue_work(kcrypto_wq, &cpu_queue->work);
> 
> Again, unclear and needs commentary.
> 
> If we come here via the `goto out;' path above, this CPU queue has no
> more work do do, I think?  If so, why does it requeue itself?

This looks like another vestige from chainiv.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
