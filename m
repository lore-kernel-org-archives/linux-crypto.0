Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:38977 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfANKF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 05:05:29 -0500
Date: Mon, 14 Jan 2019 11:05:25 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: linux-rt-users@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RT] padata: Make padata_do_serial() use get_cpu_light()
Message-ID: <20190114100525.4apnsblriimgjvkl@linutronix.de>
References: <5894faebe7c816c6b210ab2616a49330f067a492.1547039140.git.bristot@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5894faebe7c816c6b210ab2616a49330f067a492.1547039140.git.bristot@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2019-01-09 16:59:26 [+0100], Daniel Bristot de Oliveira wrote:
> diff --git a/kernel/padata.c b/kernel/padata.c
> index d568cc56405f..bfcbdeb20ba5 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -295,7 +295,7 @@ static void padata_reorder_timer(struct timer_list *t)
>  	unsigned int weight;
>  	int target_cpu, cpu;
>  
> -	cpu = get_cpu();
> +	cpu = get_cpu_light();

This can become a
	cpu = smp_processor_id()

>  	/* We don't lock pd here to not interfere with parallel processing
>  	 * padata_reorder() calls on other CPUs. We just need any CPU out of
> @@ -321,7 +321,7 @@ static void padata_reorder_timer(struct timer_list *t)
>  		padata_reorder(pd);
>  	}
>  
> -	put_cpu();
> +	put_cpu_light();

and this can go because this is invoked in a timer callback.

>  }
>  
>  static void padata_serial_worker(struct work_struct *serial_work)
> @@ -369,7 +369,7 @@ void padata_do_serial(struct padata_priv *padata)
>  
>  	pd = padata->pd;
>  
> -	cpu = get_cpu();
> +	cpu = get_cpu_light();

this is tricky but I would also say that this can become
smp_processor_id() like in the upper hunk

>  	/* We need to run on the same CPU padata_do_parallel(.., padata, ..)
>  	 * was called on -- or, at least, enqueue the padata object into the
> @@ -387,7 +387,7 @@ void padata_do_serial(struct padata_priv *padata)
>  	list_add_tail(&padata->list, &pqueue->reorder.list);
>  	spin_unlock(&pqueue->reorder.lock);
>  
> -	put_cpu();
> +	put_cpu_light();

and than this can go, too. It looks like this invoked from a worker with
BH disabled. If it does, it is all good. If not then it might be
problematic because later we have
	queue_work_on(cpu, pd->pinst->wq, &pqueue->reorder_work);

and nothing guarantees that the work is carried out by the CPU specified
if CPU-hotplug is involved.

>  	/* If we're running on the wrong CPU, call padata_reorder() via a
>  	 * kernel worker.

Sebastian
