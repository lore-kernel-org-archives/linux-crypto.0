From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: add helper function for queue length
Date: Fri, 7 Oct 2016 05:15:01 +0200
Message-ID: <20161007031501.GB23615@gauss.secunet.com>
References: <20161002014638.8049-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:43788 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754042AbcJGDPI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Oct 2016 23:15:08 -0400
Content-Disposition: inline
In-Reply-To: <20161002014638.8049-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 02, 2016 at 03:46:38AM +0200, Jason A. Donenfeld wrote:
> Since padata has a maximum number of inflight jobs, currently 1000, it's
> very useful to know how many jobs are currently queued up. This adds a
> simple helper function to expose this information.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  include/linux/padata.h |  2 ++
>  kernel/padata.c        | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/include/linux/padata.h b/include/linux/padata.h
> index 113ee62..4840ae4 100644
> --- a/include/linux/padata.h
> +++ b/include/linux/padata.h
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 2008, 2009 secunet Security Networks AG
>   * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
> + * Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> @@ -181,4 +182,5 @@ extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
>  					    struct notifier_block *nblock);
>  extern int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
>  					      struct notifier_block *nblock);
> +extern int padata_queue_len(struct padata_instance *pinst);
>  #endif
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 9932788..17c1e08 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -5,6 +5,7 @@
>   *
>   * Copyright (C) 2008, 2009 secunet Security Networks AG
>   * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
> + * Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> @@ -1039,3 +1040,18 @@ void padata_free(struct padata_instance *pinst)
>  	kobject_put(&pinst->kobj);
>  }
>  EXPORT_SYMBOL(padata_free);
> +
> +/**
> + * padata_queue_len - retreive the number of in progress jobs
> + *
> + * @padata_inst: padata instance from which to read the queue size
> + */
> +int padata_queue_len(struct padata_instance *pinst)
> +{
> +	int len;
> +	rcu_read_lock_bh();
> +	len = atomic_read(&rcu_dereference_bh(pinst->pd)->refcnt);
> +	rcu_read_unlock_bh();
> +	return len;
> +}
> +EXPORT_SYMBOL(padata_queue_len);

Why you want to have this? Without having a user of this function,
there is no point on adding it.
