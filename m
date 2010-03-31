From: Brandon Philips <brandon@ifup.org>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Wed, 31 Mar 2010 12:03:51 -0700
Message-ID: <20100331190351.GG25587@jenkins.home.ifup.org>
References: <20100320010849.GA30654@gondor.apana.org.au>
 <20100319.222325.260105122.davem@davemloft.net>
 <20100320122959.GA1930@gondor.apana.org.au>
 <201003300936.58300.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Tim Abbott <tabbott@mit.edu>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0CaTGO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Mar 2010 15:06:14 -0400
Received: by pva18 with SMTP id 18so20175pva.19
        for <linux-crypto@vger.kernel.org>; Wed, 31 Mar 2010 12:06:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <201003300936.58300.rusty@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09:36 Tue 30 Mar 2010, Rusty Russell wrote:
> The real fix here is to drop the lock, like Brandon suggested, but
> we need to do it more carefully: when we re-acquire the lock we need
> to re-lookup the symbol in case the module has vanished or changed.
> 
> Brandon, I can't see how libcrc32c's module_init calls
> crypto_alloc_shash, but the problem is reproducible with simple
> example modules.  Does it fix your problem?

Did you see my email yesterday explaining how this came about? Does
that answer your question?

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04363.html

> module: drop the lock while waiting for module to complete initialization.
> 
> This fixes "gave up waiting for init of module libcrc32c." which
> happened at boot time due to multiple parallel module loads.

Since the root cause is known a bit more detail can be added:

This fixes "gave up waiting for init of module libcrc32c." which is
triggered by parallel modprobes by udev for the same driver. For
example on a machine with two network interfaces:

02:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme II
BCM5709 Gigabit Ethernet [14e4:1639] (rev 01)
02:00.1 Ethernet controller [0200]: Broadcom Corporation NetXtreme II
BCM5709 Gigabit Ethernet [14e4:1639] (rev 01)

udev will fork off two modprobe processes:

/sbin/modprobe pci:v000014E4d00001639sv00001014sd0000037Cbc02sc00i00
/sbin/modprobe pci:v000014E4d00001639sv00001014sd0000037Cbc02sc00i00

> The problem was a deadlock: we wait for a module to finish
> initializing, but we keep the module_lock mutex so it can't
> complete.  In particular, this could reasonably happen if libcrc32c
> does a request_module() in its initialization routine.
> 
> So we change use_module() to return an errno rather than a bool, and if
> it's -EBUSY we drop the lock and wait in the caller, then reaquire the
> lock.
> 
> Reported-by: Brandon Philips <brandon@ifup.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Reviewed the patch and it looks good and I tested it on the machine
and it works. A couple of trivial things inline below if you care.

Signed-off-by: Brandon Philips <brandon@ifup.org>
Cc: stable@kernel.org

Thanks Rusty.

Cheers,

	Brandon


> -	if (b == NULL || already_uses(a, b)) return 1;
> +	if (b == NULL || already_uses(a, b)) return 0;

	if (b == NULL || already_uses(a, b))
		return 0;

>  	/* If we're interrupted or time out, we fail. */
> -	if (wait_event_interruptible_timeout(
> -		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
> -		    30 * HZ) <= 0) {
> -		printk("%s: gave up waiting for init of module %s.\n",
> -		       a->name, b->name);
> -		return 0;
> -	}
> -
> -	/* If strong_try_module_get() returned a different error, we fail. */
> +	err = strong_try_module_get(b);
>  	if (err)
> -		return 0;
> +		return err;
>  
>  	DEBUGP("Allocating new usage for %s.\n", a->name);
>  	use = kmalloc(sizeof(*use), GFP_ATOMIC);
>  	if (!use) {
>  		printk("%s: out of memory loading\n", a->name);

  		printk(KERN_ERR "%s: out of memory loading\n", a->name);

>  		module_put(b);
> -		return 0;
> +		return -ENOMEM;
>  	}
>  
>  	use->module_which_uses = a;
>  	list_add(&use->list, &b->modules_which_use_me);
>  	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
> -	return 1;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(use_module);
>  
> @@ -823,7 +815,7 @@ static inline void module_unload_free(st
>  
>  int use_module(struct module *a, struct module *b)
>  {
> -	return strong_try_module_get(b) == 0;
> +	return strong_try_module_get(b);
>  }
>  EXPORT_SYMBOL_GPL(use_module);
>  
> @@ -994,17 +986,39 @@ static const struct kernel_symbol *resol
>  	struct module *owner;
>  	const struct kernel_symbol *sym;
>  	const unsigned long *crc;
> +	DEFINE_WAIT(wait);
> +	int err;
> +	long timeleft = 30 * HZ;
>  
> +again:
>  	sym = find_symbol(name, &owner, &crc,
>  			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
> -	/* use_module can fail due to OOM,
> -	   or module initialization or unloading */
> -	if (sym) {
> -		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
> -		    || !use_module(mod, owner))
> -			sym = NULL;
> +	if (!sym)
> +		return NULL;
> +
> +	if (!check_version(sechdrs, versindex, name, mod, crc, owner))
> +		return NULL;
> +
> +	prepare_to_wait(&module_wq, &wait, TASK_INTERRUPTIBLE);
> +	err = use_module(mod, owner);
> +	if (likely(!err) || err != -EBUSY || signal_pending(current)) {
> +		finish_wait(&module_wq, &wait);
> +		return err ? NULL : sym;
>  	}
> -	return sym;
> +
> +	/* Module is still loading.  Drop lock and wait. */
> +	mutex_unlock(&module_mutex);
> +	timeleft = schedule_timeout(timeleft);
> +	mutex_lock(&module_mutex);
> +	finish_wait(&module_wq, &wait);
> +
> +	/* Module might be gone entirely, or replaced.  Re-lookup. */
> +	if (timeleft)
> +		goto again;
> +
> +	printk("%s: gave up waiting for init of module %s.\n",
> +	       mod->name, owner->name);

	printk(KERN_ERR "%s: gave up waiting for init of module %s.\n",
	       mod->name, owner->name);

> +	return NULL;
>  }
>  
>  /*
> 
