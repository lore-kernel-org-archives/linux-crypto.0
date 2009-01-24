From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Fri, 23 Jan 2009 23:07:06 -0800
Message-ID: <20090123230706.4c8ae0ea.akpm@linux-foundation.org>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
	<20090116033105.GB10390@gondor.apana.org.au>
	<1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbZAXHHr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Jan 2009 02:07:47 -0500
In-Reply-To: <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 22 Jan 2009 10:32:17 +0800 Huang Ying <ying.huang@intel.com> wrote:

> Use dedicate workqueue for crypto
> 
> - A dedicated workqueue named kcrypto_wq is created.
> 
> - chainiv uses kcrypto_wq instead of keventd_wq.
> 
> - For cryptd, struct cryptd_queue is defined to be a per-CPU queue,
>   which holds one struct cryptd_cpu_queue for each CPU. In struct
>   cryptd_cpu_queue, a struct crypto_queue holds all requests for the
>   CPU, a struct work_struct is used to run all requests for the CPU.
> 

Please always prefer to include performance measurements when proposing
a performance-enhancing patch.  Otherwise we have no basis upon which
to evaluate the patch's worth.

> +++ b/crypto/crypto_wq.c
> @@ -0,0 +1,39 @@
> +/*
> + * Workqueue for crypto subsystem
> + *
> + * Copyright (c) 2009 Intel Corp.
> + *   Author: Huang Ying <ying.huang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + */
> +
> +#include <linux/workqueue.h>
> +#include <crypto/algapi.h>
> +#include <crypto/crypto_wq.h>
> +
> +struct workqueue_struct *kcrypto_wq;
> +EXPORT_SYMBOL_GPL(kcrypto_wq);
> +
> +static int __init crypto_wq_init(void)
> +{
> +	kcrypto_wq = create_workqueue("crypto");
> +	if (unlikely(!kcrypto_wq))
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void __exit crypto_wq_exit(void)
> +{
> +	if (likely(kcrypto_wq))
> +		destroy_workqueue(kcrypto_wq);

I don't believe that it is possible to get here with kcrypto_wq==NULL.

>
> ...
>
> +int cryptd_enqueue_request(struct cryptd_queue *queue,
> +			   struct crypto_async_request *request)
> +{
> +	int cpu, err, queued;
> +	struct cryptd_cpu_queue *cpu_queue;
> +
> +	cpu = get_cpu();
> +	cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> +	spin_lock_bh(&cpu_queue->lock);
> +	err = crypto_enqueue_request(&cpu_queue->queue, request);
> +	spin_unlock_bh(&cpu_queue->lock);
> +	/* INUSE should be set after queue->qlen assigned, but
> +	 * spin_unlock_bh imply a memory barrior already */
> +	if (!test_and_set_bit_lock(CRYPTD_STATE_INUSE, &cpu_queue->state)) {
> +		queued = queue_work(kcrypto_wq, &cpu_queue->work);
> +		BUG_ON(!queued);
> +	}

Do we actually need to use CRYPTD_STATE_INUSE here?  The
WORK_STRUCT_PENDING handling in the workqueue does basically the same
thing?

> +	put_cpu();
> +
> +	return err;
> +}
> +
> +int cryptd_tfm_in_queue(struct cryptd_queue *queue, struct crypto_tfm *tfm)

Did this need to have global scope?

> +{
> +	int cpu, in_queue;
> +	struct cryptd_cpu_queue *cpu_queue;
> +
> +	for_each_possible_cpu(cpu) {
> +		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
> +		spin_lock_bh(&cpu_queue->lock);
> +		in_queue = crypto_tfm_in_queue(&cpu_queue->queue, tfm);
> +		spin_unlock_bh(&cpu_queue->lock);
> +		if (in_queue)
> +			return 1;
> +	}
> +	return 0;
> +}

Did you consider using for_each_online_cpu() and implementing CPU
hotplug?  There might be situations where the number of possible CPUs
is much greater than the number of online CPUs.

> +static void cryptd_queue_work_done(struct cryptd_cpu_queue *cpu_queue)
> +{
> +	int queued;
> +
> +	if (!cpu_queue->queue.qlen) {
> +		clear_bit_unlock(CRYPTD_STATE_INUSE, &cpu_queue->state);
> +		/* queue.qlen must be checked after INUSE bit cleared */
> +		smp_mb();
> +		if (!cpu_queue->queue.qlen ||
> +		    test_and_set_bit_lock(CRYPTD_STATE_INUSE,
> +					  &cpu_queue->state))
> +			return;
> +	}
> +
> +	queued = queue_work(kcrypto_wq, &cpu_queue->work);
> +	BUG_ON(!queued);
> +}

It is unclear (to me) why this code is using the special "locked"
bitops.  This should be explained in a code comment.

It isn't immediately clear (to me) what this function does, what its
role is in the overall scheme.  It wouldn't hurt at all to put a nice
comment over non-trivial functions explaining such things.

> +static void cryptd_queue_work(struct work_struct *work)
> +{
> +	struct cryptd_cpu_queue *cpu_queue =
> +		container_of(work, struct cryptd_cpu_queue, work);

You could just do

	struct cryptd_cpu_queue *cpu_queue;

	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);

rather than uglifying the code to fit in 80-cols.

> +	struct crypto_async_request *req, *backlog;
> +
> +	/* Only handle one request at a time to avoid hogging crypto
> +	 * workqueue */
> +	spin_lock_bh(&cpu_queue->lock);
> +	backlog = crypto_get_backlog(&cpu_queue->queue);
> +	req = crypto_dequeue_request(&cpu_queue->queue);
> +	spin_unlock_bh(&cpu_queue->lock);
> +
> +	if (!req)
> +		goto out;
> +
> +	if (backlog)
> +		backlog->complete(backlog, -EINPROGRESS);
> +	req->complete(req, 0);
> +out:
> +	cryptd_queue_work_done(cpu_queue);
> +}
> +
> +static inline struct cryptd_queue *cryptd_get_queue(struct crypto_tfm *tfm)
>  {
>  	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
>  	struct cryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
> -	return ictx->state;
> +	return ictx->queue;
>  }
>  
>  static int cryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
> @@ -131,19 +248,13 @@ static int cryptd_blkcipher_enqueue(stru
>  {
>  	struct cryptd_blkcipher_request_ctx *rctx = ablkcipher_request_ctx(req);
>  	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
> -	struct cryptd_state *state =
> -		cryptd_get_state(crypto_ablkcipher_tfm(tfm));
> -	int err;
> +	struct cryptd_queue *queue =
> +		cryptd_get_queue(crypto_ablkcipher_tfm(tfm));

ditto

>
> ...
>

