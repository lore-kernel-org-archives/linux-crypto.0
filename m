From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 07/10] spufs: add kernel support for spu task
Date: Sat, 18 Aug 2007 18:48:34 +0200
Message-ID: <200708181848.34705.arnd@arndb.de>
References: <20070816200105.735608000@ml.breakpoint.cc> <20070816200137.051342000@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: cbe-oss-dev@ozlabs.org, herbert@gondor.apana.org.au, jk@ozlabs.org,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXHRQso (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Aug 2007 12:48:44 -0400
In-Reply-To: <20070816200137.051342000@ml.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 16 August 2007, Sebastian Siewior wrote:

> +config KSPU
> +	bool "Support for utilisation of SPU by the kernel"
> +	depends on SPU_FS && EXPERIMENTAL
> +	help
> +	  With this option enabled, the kernel is able to utilize the SPUs for its
> +	  own tasks.


It might be better to not have this user-selectable at all, but to
autoselect the option when it's used by other code.

> +out_archcoredump:
> +	printk("kspu_init() failed\n");
> +	unregister_arch_coredump_calls(&spufs_coredump_calls);
>  out_syscalls:
>  	unregister_spu_syscalls(&spufs_calls);
>  out_fs:
> @@ -804,12 +811,14 @@ out_sched:
>  out_cache:
>  	kmem_cache_destroy(spufs_inode_cache);
>  out:
> +	printk("spufs init not performed\n");
>  	return ret;
>  }

The printk lines don't follow the convention of using KERN_*
printk levels. I suggest you either remove them or turn them
into pr_debug().
> +
> +#include <asm/spu_priv1.h>
> +#include <asm/kspu/kspu.h>
> +#include <asm/kspu/merged_code.h>
> +#include <linux/kthread.h>
> +#include <linux/module.h>
> +#include <linux/init_task.h>
> +#include <linux/hardirq.h>
> +#include <linux/kernel.h>


#include lines should be ordered alphabetically, and <asm/ lines come
after <linux/ lines.

> +/*
> + * based on run.c spufs_run_spu
> + */
> +static int spufs_run_kernel_spu(void *priv)
> +{
> +	struct kspu_context *kctx = (struct kspu_context *) priv;
> +	struct spu_context *ctx = kctx->spu_ctx;
> +	int ret;
> +	u32 status;
> +	unsigned int npc = 0;
> +	int fastpath;
> +	DEFINE_WAIT(wait_for_stop);
> +	DEFINE_WAIT(wait_for_ibox);
> +	DEFINE_WAIT(wait_for_newitem);
> +
> +	spu_enable_spu(ctx);
> +	ctx->event_return = 0;
> +	spu_acquire(ctx);
> +	if (ctx->state == SPU_STATE_SAVED) {
> +		__spu_update_sched_info(ctx);
> +
> +		ret = spu_activate(ctx, 0);
> +		if (ret) {
> +			spu_release(ctx);
> +			printk(KERN_ERR "could not obtain runnable spu: %d\n",
> +					ret);
> +			BUG();
> +		}
> +	} else {
> +		/*
> +		 * We have to update the scheduling priority under active_mutex
> +		 * to protect against find_victim().
> +		 */
> +		spu_update_sched_info(ctx);
> +	}

The code you have copied this from has recently been changed to also set an initial
time slice, you should do the same change here.

> +
> +	spu_run_init(ctx, &npc);
> +	do {
> +		fastpath = 0;
> +		prepare_to_wait(&ctx->stop_wq, &wait_for_stop,
> +				TASK_INTERRUPTIBLE);
> +		prepare_to_wait(&ctx->ibox_wq, &wait_for_ibox,
> +				TASK_INTERRUPTIBLE);
> +		prepare_to_wait(&kctx->newitem_wq, &wait_for_newitem,
> +				TASK_INTERRUPTIBLE);
> +
> +		if (unlikely(test_and_clear_bit(SPU_SCHED_NOTIFY_ACTIVE,
> +						&ctx->sched_flags))) {
> +
> +			if (!(status & SPU_STATUS_STOPPED_BY_STOP)) {
> +				spu_switch_notify(ctx->spu, ctx);
> +			}
> +		}
> +
> +		spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
> +
> +		pr_debug("going to handle class1\n");
> +		ret = spufs_handle_class1(ctx);
> +		if (unlikely(ret)) {
> +			/*
> +			 * SPE_EVENT_SPE_DATA_STORAGE => refernce invalid memory
> +			 */
> +			printk(KERN_ERR "Invalid memory dereferenced by the"
> +					"spu: %d\n", ret);
> +			BUG();
> +		}
> +
> +		/* FIXME BUG: We need a physical SPU to discover
> +		 * ctx->spu->class_0_pending. It is not saved on context
> +		 * switch. We may lose this on context switch.
> +		 */
> +		status = ctx->ops->status_read(ctx);
> +		if (unlikely((ctx->spu && ctx->spu->class_0_pending) ||
> +					status & SPU_STATUS_INVALID_INSTR)) {
> +			printk(KERN_ERR "kspu error, status_register: 0x%08x\n",
> +					status);
> +			printk(KERN_ERR "event return: 0x%08lx, spu's npc: "
> +					"0x%08x\n", kctx->spu_ctx->event_return,
> +					kctx->spu_ctx->ops->npc_read(
> +						kctx->spu_ctx));
> +			printk(KERN_ERR "class_0_pending: 0x%lx\n", ctx->spu->class_0_pending);
> +			print_kctx_debug(kctx);
> +			BUG();
> +		}
> +
> +		if (notify_done_reqs(kctx))
> +			fastpath = 1;
> +
> +		if (queue_requests(kctx))
> +			fastpath = 1;
> +
> +		if (!(status & SPU_STATUS_RUNNING)) {
> +			/* spu is currently not running */
> +			pr_debug("SPU not running, last stop code was: %08x\n",
> +					status >> SPU_STOP_STATUS_SHIFT);
> +			if (pending_spu_work(kctx)) {
> +				/* spu should run again */
> +				pr_debug("Activate SPU\n");
> +				kspu_fill_dummy_reqs(kctx);
> +
> +				spu_run_fini(ctx, &npc, &status);
> +				spu_acquire_runnable(ctx, 0);
> +				spu_run_init(ctx, &npc);
> +			} else {
> +				/* spu finished work */
> +				pr_debug("SPU will remain in stop state\n");
> +				spu_run_fini(ctx, &npc, &status);
> +				spu_yield(ctx);
> +				spu_acquire(ctx);
> +			}
> +		} else {
> +			pr_debug("SPU is running, switch state to util user\n");
> +			spuctx_switch_state(ctx, SPU_UTIL_USER);
> +		}
> +
> +		if (fastpath)
> +			continue;
> +
> +		spu_release(ctx);
> +		schedule();
> +		spu_acquire(ctx);
> +
> +	} while (!kthread_should_stop() || !list_empty(&kctx->work_queue));

The inner loop is rather long, in an already long function. Can you split out
parts into separate functions here?


> +#endif
> --- a/arch/powerpc/platforms/cell/spufs/spufs.h
> +++ b/arch/powerpc/platforms/cell/spufs/spufs.h
> @@ -344,4 +344,18 @@ static inline void spuctx_switch_state(s
>  	}
>  }
>  
> +#ifdef CONFIG_KSPU
> +int __init kspu_init(void);
> +void __exit kspu_exit(void);

The __init and __exit specifiers are not meaningful in the declaration,
you only need them in the definition.

	Arnd <><
