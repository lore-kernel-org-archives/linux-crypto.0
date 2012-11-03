From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2 5/9] kernel: padata : use this_cpu_read per-cpu helper
Date: Sat, 3 Nov 2012 09:24:55 +0100
Message-ID: <20121103082455.GB20868@secunet.com>
References: <5093EE63.5000005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, cl@linux-foundation.org
To: Shan Wei <shanwei88@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5093EE63.5000005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>  
> @@ -204,8 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  		goto out;
>  	}
>  
> -	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
> -	if (queue->cpu_index == next_queue->cpu_index) {
> +	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {

This runs with bottom halves off, so we can use __this_cpu_read here.
