From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] crypto: Per-CPU cryptd thread implementation based
 on kcrypto_wq
Date: Tue, 3 Feb 2009 01:10:38 -0800
Message-ID: <20090203011038.c12acc5b.akpm@linux-foundation.org>
References: <1233556940.19806.58.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZBCJLR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2009 04:11:17 -0500
In-Reply-To: <1233556940.19806.58.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 02 Feb 2009 14:42:20 +0800 Huang Ying <ying.huang@intel.com> wrote:

> Original cryptd thread implementation has scalability issue, this
> patch solve the issue with a per-CPU thread implementation.
> 
> struct cryptd_queue is defined to be a per-CPU queue, which holds one
> struct cryptd_cpu_queue for each CPU. In struct cryptd_cpu_queue, a
> struct crypto_queue holds all requests for the CPU, a struct
> work_struct is used to run all requests for the CPU.
> 
> ...
>
> +int cryptd_init_queue(struct cryptd_queue *queue, unsigned int max_cpu_qlen)
> +{
> +	int cpu;
> +	struct cryptd_cpu_queue *cpu_queue;
> +
> +	queue->cpu_queue = alloc_percpu(struct cryptd_cpu_queue);
> +	if (!queue->cpu_queue)
> +		return -ENOMEM;
> +	for_each_possible_cpu(cpu) {
> +		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> +		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
> +		INIT_WORK(&cpu_queue->work, cryptd_queue_worker);
> +	}
> +	return 0;
> +}

Could be made static, I believe.

> +void cryptd_fini_queue(struct cryptd_queue *queue)
> +{
> +	int cpu;
> +	struct cryptd_cpu_queue *cpu_queue;
> +
> +	for_each_possible_cpu(cpu) {
> +		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> +		BUG_ON(cpu_queue->queue.qlen);
> +	}
> +	free_percpu(queue->cpu_queue);
> +}

Ditto.

> +int cryptd_enqueue_request(struct cryptd_queue *queue,
> +			   struct crypto_async_request *request)
> +{
> +	int cpu, err;
> +	struct cryptd_cpu_queue *cpu_queue;
> +
> +	cpu = get_cpu();
> +	cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> +	err = crypto_enqueue_request(&cpu_queue->queue, request);
> +	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
> +	put_cpu();
> +
> +	return err;
> +}

Ditto?

> +static void cryptd_queue_worker(struct work_struct *work)

A few comments explaining the code wouldn't kill us...

> +{
> +	struct cryptd_cpu_queue *cpu_queue;
> +	struct crypto_async_request *req, *backlog;
> +
> +	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
> +	/* Only handle one request at a time to avoid hogging crypto
> +	 * workqueue */

Not sure what that means.

> +	preempt_disable();
> +	backlog = crypto_get_backlog(&cpu_queue->queue);
> +	req = crypto_dequeue_request(&cpu_queue->queue);
> +	preempt_enable();

This function is run by a per-cpu thread, so it cannot be migrated to
another CPU by the CPU scheduler.

It is quite unclear what this preempt_disable() is needed for.  Please
either remove it or provide adequate comments.

> +	if (!req)
> +		goto out;
> +
> +	if (backlog)
> +		backlog->complete(backlog, -EINPROGRESS);
> +	req->complete(req, 0);
> +out:
> +	if (cpu_queue->queue.qlen)
> +		queue_work(kcrypto_wq, &cpu_queue->work);

Again, unclear and needs commentary.

If we come here via the `goto out;' path above, this CPU queue has no
more work do do, I think?  If so, why does it requeue itself?

> +}
> +
> 
> ...
>

