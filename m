From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mcryptd: protect the per-CPU queue with a lock
Date: Mon, 11 Dec 2017 22:46:27 +1100
Message-ID: <20171211114627.GI12014@gondor.apana.org.au>
References: <20171130123927.GA12606@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Tim Chen <tim.c.chen@linux.intel.com>, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43954 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752208AbdLKLqs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:46:48 -0500
Content-Disposition: inline
In-Reply-To: <20171130123927.GA12606@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 30, 2017 at 01:39:27PM +0100, Sebastian Andrzej Siewior wrote:
> mcryptd_enqueue_request() grabs the per-CPU queue struct and protects
> access to it with disabled preemption. Then it schedules a worker on the
> same CPU. The worker in mcryptd_queue_worker() guards access to the same
> per-CPU variable with disabled preemption.
> 
> If we take CPU-hotplug into account then it is possible that between
> queue_work_on() and the actual invocation of the worker the CPU goes
> down and the worker will be scheduled on _another_ CPU. And here the
> preempt_disable() protection does not work anymore. The easiest thing is
> to add a spin_lock() to guard access to the list.
> 
> Another detail: mcryptd_queue_worker() is not processing more than
> MCRYPTD_BATCH invocation in a row. If there are still items left, then
> it will invoke queue_work() to proceed with more later. *I* would
> suggest to simply drop that check because it does not use a system
> workqueue and the workqueue is already marked as "CPU_INTENSIVE". And if
> preemption is required then the scheduler should do it.
> However if queue_work() is used then the work item is marked as CPU
> unbound. That means it will try to run on the local CPU but it may run
> on another CPU as well. Especially with CONFIG_DEBUG_WQ_FORCE_RR_CPU=y.
> Again, the preempt_disable() won't work here but lock which was
> introduced will help.
> In order to keep work-item on the local CPU (and avoid RR) I changed it
> to queue_work_on().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
