From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Wed, 28 Jan 2009 14:54:37 +1100
Message-ID: <20090128035437.GC12904@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com> <20090116033105.GB10390@gondor.apana.org.au> <1232591537.6101.3.camel@yhuang-dev.sh.intel.com> <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59849 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752279AbZA1Dyn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 22:54:43 -0500
Content-Disposition: inline
In-Reply-To: <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 23, 2009 at 11:07:06PM -0800, Andrew Morton wrote:
>
> > +int cryptd_enqueue_request(struct cryptd_queue *queue,
> > +			   struct crypto_async_request *request)
> > +{
> > +	int cpu, err, queued;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	cpu = get_cpu();
> > +	cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> > +	spin_lock_bh(&cpu_queue->lock);
> > +	err = crypto_enqueue_request(&cpu_queue->queue, request);
> > +	spin_unlock_bh(&cpu_queue->lock);
> > +	/* INUSE should be set after queue->qlen assigned, but
> > +	 * spin_unlock_bh imply a memory barrior already */
> > +	if (!test_and_set_bit_lock(CRYPTD_STATE_INUSE, &cpu_queue->state)) {
> > +		queued = queue_work(kcrypto_wq, &cpu_queue->work);
> > +		BUG_ON(!queued);
> > +	}
> 
> Do we actually need to use CRYPTD_STATE_INUSE here?  The
> WORK_STRUCT_PENDING handling in the workqueue does basically the same
> thing?

Indeed, the INUSE stuff looks vestigial and can probably be removed.
 
> > +{
> > +	int cpu, in_queue;
> > +	struct cryptd_cpu_queue *cpu_queue;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> > +		spin_lock_bh(&cpu_queue->lock);
> > +		in_queue = crypto_tfm_in_queue(&cpu_queue->queue, tfm);
> > +		spin_unlock_bh(&cpu_queue->lock);
> > +		if (in_queue)
> > +			return 1;
> > +	}
> > +	return 0;
> > +}
> 
> Did you consider using for_each_online_cpu() and implementing CPU
> hotplug?  There might be situations where the number of possible CPUs
> is much greater than the number of online CPUs.

This is one of those things that just keeps changing. Once upon a
time I'd write code with CPU hotplug triggers and such and someone
would always come through to change them to for_each_possible_cpu
in the name of simplification :)

But yeah I personally still prefer the hotplug way, so no objections
from me.

Thanks for reviewing Andrew!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
