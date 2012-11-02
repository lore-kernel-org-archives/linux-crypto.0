From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 5/9] kernel: padata : use this_cpu_read per-cpu
 helper
Date: Fri, 2 Nov 2012 17:46:24 +0000
Message-ID: <0000013ac23b18d9-09a4a129-7762-44ea-9445-827a6223f25a-000000@email.amazonses.com>
References: <5093EE63.5000005@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: steffen.klassert@secunet.com,
	Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Shan Wei <shanwei88@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5093EE63.5000005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

> -	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
> -	if (queue->cpu_index == next_queue->cpu_index) {
> +	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {
>  		padata = ERR_PTR(-ENODATA);

Reviewed-by: Christoph Lameter <cl@linux.com>
