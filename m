From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 6/9] kernel: padata : use this_cpu_ptr per-cpu helper
Date: Wed, 31 Oct 2012 17:45:48 +0000
Message-ID: <0000013ab7edd68d-5524bd32-c5a1-4cd8-a467-ca565ee4c854-000000@email.amazonses.com>
References: <50910A10.3090004@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: steffen.klassert@secunet.com,
	Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Shan Wei <shanwei88@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50910A10.3090004@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> From: Shan Wei <davidshan@tencent.com>
>
>
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
>  kernel/padata.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 89fe3d1..70dffe8 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -204,7 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  		goto out;
>  	}
>
> -	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
> +	queue = this_cpu_ptr(pd->pqueue);
>  	if (queue->cpu_index == next_queue->cpu_index) {

Its simpler to just remove the per_cpu op completely and change the if
statement to

	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index))
{

..
