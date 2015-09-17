From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: Re: single_task_running() vs. preemption warnings (was Re: [PATCH]
 kvm: fix preemption warnings in kvm_vcpu_block)
Date: Thu, 17 Sep 2015 19:07:52 +0200
Message-ID: <20150917190752.27396fdb@BR9TG4T3.de.ibm.com>
References: <1442507270-67227-1-git-send-email-dingel@linux.vnet.ibm.com>
	<55FAEE0C.60904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	herbert@gondor.apana.org.au, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-crypto@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:52265 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbIQRIA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2015 13:08:00 -0400
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <dingel@linux.vnet.ibm.com>;
	Thu, 17 Sep 2015 18:07:58 +0100
In-Reply-To: <55FAEE0C.60904@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 17 Sep 2015 18:45:00 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> 
> 
> On 17/09/2015 18:27, Dominik Dingel wrote:
> > +			preempt_disable();
> > +			solo = single_task_running();
> > +			preempt_enable();
> > +
> >  			cur = ktime_get();
> > -		} while (single_task_running() && ktime_before(cur, stop));
> 
> That's the obvious way to fix it, but the TOCTTOU problem (which was in
> the buggy code too) is obvious too. :)  And the only other user of
> single_task_running() in drivers/crypto/mcryptd.c has the same issue.

Right, worst thing we fly another round.

I am not sure about the case for mcryptd.c. I think it might be that the worker
there is bounded to one cpu and will not be migrated.

I really need to look more in the details what is happening with that worker.

> In fact, because of the way the function is used ("maybe I can do a
> little bit of work before going to sleep") it will likely be called many
> times in a loop.  This in turn means that:
> 
> - any wrong result due to a concurrent process migration would be
> rectified very soon
> 
> - preempt_disable()/preempt_enable() can actually be just as expensive
> or more expensive than single_task_running() itself.
> 
> Therefore, I wonder if single_task_running() should just use
> raw_smp_processor_id().  At least the TOCTTOU issue can be clearly
> documented in the function comment, instead of being hidden behind each
> of the callers.

Yes to be useful it should probably call raw_smp_processor_id,
and as a lot of code actually already does just does that I do not really see much
down sides.

@Tim, would it be okay if I change single_task_running and add a specific comment on top?

> Thanks,
> 
> Paolo
> 
