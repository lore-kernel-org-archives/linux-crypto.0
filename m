Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F896C49360
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CC9B6138C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Jun 2021 03:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhFNDg4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 23:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhFNDg4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 23:36:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C4C061574
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:34:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso9200002pjb.5
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jun 2021 20:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Ck10j63C/Ig+0Q2ctBl+g4P0uqllrj4wcuXqdz9zwNU=;
        b=spLzc0eEZBv/OWv8LU2JN9fhFI7WYRoVjfjF0RqopUzG3jsevo6+PQUvRF93vT7bh8
         huKQFXmUn465FUqIIObFTdm+CtTZBOh+3bbV1u9anqh8dvf+xULiWxbBkT9nwObC0Bw8
         xBmO/zo7q670OwHteskCpr7i4VQlEQWvTqp+7EksNgtBTcwNMfkFy9QNcdowlmA7jBL9
         dOajyV6ZVHCIOCZ4jrOmXlV9Bn37HDWWUB+qwMgZA4bgTk9tElrm0N11K05dwXMdZ3HU
         W7D5HsTW7vRvgBkjZLl3WyOYLtURlWcmB6vICcVRD6y+F92zic54pYEihStlWUNVQZvH
         C1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Ck10j63C/Ig+0Q2ctBl+g4P0uqllrj4wcuXqdz9zwNU=;
        b=mHwTQGv6Xn9aV6QXhRXWQ36Qxqs+XyV+e9HurbIUz7dzy4NMbC6jbpvaeSIC1NgkcU
         blBRKn1yy1EPyYrlYxkMcggNIBUo0FC3/ElfDUjPVuumvmnuihOyd/z9d/8HyGR0+SSe
         2IpKTTSkKvG6458Sf3QBFWoE2bLdXuBa/9Z18ZmZ5H67de0FbMqVhCUd4GpPmmU/l7f9
         wOl484D9u143iQajrAHgRPHzG2qZm/k6Mnd0OmGtUIqmCEfplxz30pbLHpJeMPvDVABl
         8lp91nQGxLOuE+wRS+UlecEyNCNK+Yx8HB0tOQC+JpI1xHTPneDkj4eh7pzw4Man9zRZ
         zT4Q==
X-Gm-Message-State: AOAM532F7Nx5WavTK81AROqgA64PI9qfDikDfya1v5MUNVZr+E4yNeYk
        A7BDZ/IqQOUTtotIck4ueLp10z1LTPo=
X-Google-Smtp-Source: ABdhPJyZIyZVmK77pLgnkKJDq3k9y7zri2aSjPTHjja8iHIxQPd1+67hkWBBfFvkEfxqpi2GT2B/7g==
X-Received: by 2002:a17:90a:6d47:: with SMTP id z65mr21268161pjj.125.1623641677180;
        Sun, 13 Jun 2021 20:34:37 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id 78sm11422254pgg.73.2021.06.13.20.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 20:34:36 -0700 (PDT)
Date:   Mon, 14 Jun 2021 13:34:31 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 06/17] powerpc/vas: Move update_csb/dump_crb to common
 book3s platform
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
        <acdf224290adc8735144302ac0698801a5e29c33.camel@linux.ibm.com>
In-Reply-To: <acdf224290adc8735144302ac0698801a5e29c33.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623640157.qoo5je7ptd.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 13, 2021 8:58 pm:
>=20
> If a coprocessor encounters an error translating an address, the
> VAS will cause an interrupt in the host. The kernel processes
> the fault by updating CSB. This functionality is same for both
> powerNV and pseries. So this patch moves these functions to
> common vas-api.c and the actual functionality is not changed.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/vas.h             |   3 +
>  arch/powerpc/platforms/book3s/vas-api.c    | 147 +++++++++++++++++++
>  arch/powerpc/platforms/powernv/vas-fault.c | 155 ++-------------------
>  3 files changed, 159 insertions(+), 146 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index 163460cff59b..c1daab4cc205 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -230,4 +230,7 @@ int vas_register_coproc_api(struct module *mod, enum =
vas_cop_type cop_type,
>  void vas_unregister_coproc_api(void);
> =20
>  int get_vas_user_win_ref(struct vas_user_win_ref *task_ref);
> +void vas_update_csb(struct coprocessor_request_block *crb,
> +		    struct vas_user_win_ref *task_ref);
> +void vas_dump_crb(struct coprocessor_request_block *crb);
>  #endif /* __ASM_POWERPC_VAS_H */
> diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platf=
orms/book3s/vas-api.c
> index 1d7d3273d34b..11c76c7141d2 100644
> --- a/arch/powerpc/platforms/book3s/vas-api.c
> +++ b/arch/powerpc/platforms/book3s/vas-api.c
> @@ -10,6 +10,9 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/kthread.h>
> +#include <linux/sched/signal.h>
> +#include <linux/mmu_context.h>
>  #include <linux/io.h>
>  #include <asm/vas.h>
>  #include <uapi/asm/vas-api.h>
> @@ -94,6 +97,150 @@ int get_vas_user_win_ref(struct vas_user_win_ref *tas=
k_ref)
>  	return 0;
>  }
> =20
> +/*
> + * Update the CSB to indicate a translation error.
> + *
> + * User space will be polling on CSB after the request is issued.
> + * If NX can handle the request without any issues, it updates CSB.
> + * Whereas if NX encounters page fault, the kernel will handle the
> + * fault and update CSB with translation error.
> + *
> + * If we are unable to update the CSB means copy_to_user failed due to
> + * invalid csb_addr, send a signal to the process.
> + */
> +void vas_update_csb(struct coprocessor_request_block *crb,
> +		    struct vas_user_win_ref *task_ref)
> +{
> +	struct coprocessor_status_block csb;
> +	struct kernel_siginfo info;
> +	struct task_struct *tsk;
> +	void __user *csb_addr;
> +	struct pid *pid;
> +	int rc;
> +
> +	/*
> +	 * NX user space windows can not be opened for task->mm=3DNULL
> +	 * and faults will not be generated for kernel requests.
> +	 */
> +	if (WARN_ON_ONCE(!task_ref->mm))
> +		return;
> +
> +	csb_addr =3D (void __user *)be64_to_cpu(crb->csb_addr);
> +
> +	memset(&csb, 0, sizeof(csb));
> +	csb.cc =3D CSB_CC_FAULT_ADDRESS;
> +	csb.ce =3D CSB_CE_TERMINATION;
> +	csb.cs =3D 0;
> +	csb.count =3D 0;
> +
> +	/*
> +	 * NX operates and returns in BE format as defined CRB struct.
> +	 * So saves fault_storage_addr in BE as NX pastes in FIFO and
> +	 * expects user space to convert to CPU format.
> +	 */
> +	csb.address =3D crb->stamp.nx.fault_storage_addr;
> +	csb.flags =3D 0;
> +
> +	pid =3D task_ref->pid;
> +	tsk =3D get_pid_task(pid, PIDTYPE_PID);
> +	/*
> +	 * Process closes send window after all pending NX requests are
> +	 * completed. In multi-thread applications, a child thread can
> +	 * open a window and can exit without closing it. May be some
> +	 * requests are pending or this window can be used by other
> +	 * threads later. We should handle faults if NX encounters
> +	 * pages faults on these requests. Update CSB with translation
> +	 * error and fault address. If csb_addr passed by user space is
> +	 * invalid, send SEGV signal to pid saved in window. If the
> +	 * child thread is not running, send the signal to tgid.
> +	 * Parent thread (tgid) will close this window upon its exit.
> +	 *
> +	 * pid and mm references are taken when window is opened by
> +	 * process (pid). So tgid is used only when child thread opens
> +	 * a window and exits without closing it.
> +	 */
> +	if (!tsk) {
> +		pid =3D task_ref->tgid;
> +		tsk =3D get_pid_task(pid, PIDTYPE_PID);
> +		/*
> +		 * Parent thread (tgid) will be closing window when it
> +		 * exits. So should not get here.
> +		 */
> +		if (WARN_ON_ONCE(!tsk))
> +			return;
> +	}
> +
> +	/* Return if the task is exiting. */
> +	if (tsk->flags & PF_EXITING) {
> +		put_task_struct(tsk);
> +		return;
> +	}

Actually in the previous patch that moves the refcounting into its own=20
functions, could you make a function for this stuff as well?

> +
> +	kthread_use_mm(task_ref->mm);
> +	rc =3D copy_to_user(csb_addr, &csb, sizeof(csb));
> +	/*
> +	 * User space polls on csb.flags (first byte). So add barrier
> +	 * then copy first byte with csb flags update.
> +	 */

So this first writes 0 to the user's csb.flags which was previously 0.

> +	if (!rc) {
> +		csb.flags =3D CSB_V;
> +		/* Make sure update to csb.flags is visible now */
> +		smp_mb();
> +		rc =3D copy_to_user(csb_addr, &csb, sizeof(u8));

And then it stores CSB_V to flags, and that must be visible before the
other stores to the user's CSB?

So that should be smp_wmb()? And memory barrier comments should not say
it makes a store visible, rather it should explain the two sets of=20
memory operations it is enforcing an ordering between. And it should
give a reference to barriers in the other code that relies on this=20
ordering. In this case userspace I assume is expected to enforce=20
load/load ordering between finding CSB_V in csb.flags, and loading the
rest of the data there.

You could make this change at the start of the series, or if you prefer
to do more testing before relaxing smp_mb to smp_wmb then I don't mind=20
if you do it afterwards and change the comment at that time.

> +	}
> +	kthread_unuse_mm(task_ref->mm);
> +	put_task_struct(tsk);
> +
> +	/* Success */
> +	if (!rc)
> +		return;
> +
> +
> +	pr_debug("Invalid CSB address 0x%p signalling pid(%d)\n",
> +			csb_addr, pid_vnr(pid));
> +
> +	clear_siginfo(&info);
> +	info.si_signo =3D SIGSEGV;
> +	info.si_errno =3D EFAULT;
> +	info.si_code =3D SEGV_MAPERR;
> +	info.si_addr =3D csb_addr;
> +	/*
> +	 * process will be polling on csb.flags after request is sent to
> +	 * NX. So generally CSB update should not fail except when an
> +	 * application passes invalid csb_addr. So an error message will
> +	 * be displayed and leave it to user space whether to ignore or
> +	 * handle this signal.
> +	 */
> +	rcu_read_lock();
> +	rc =3D kill_pid_info(SIGSEGV, &info, pid);
> +	rcu_read_unlock();
> +
> +	pr_devel("%s(): pid %d kill_proc_info() rc %d\n", __func__,
> +			pid_vnr(pid), rc);

And a separate function for this bit too. And comment them all in high
level terms of the thread/process/file descriptor/interrupt lifetimes,
coprocessor access to memory and raising of interrupts, etc. rather than
talking about vas windows and CSB addresses and things. The problem is
nobody who understands kernel/fork/exit/signal/pid/etc rules will have=20
any clue what's going on here reading these comments.

It's not actually quite clear what your task_struct ref is doing because=20
you release it before you deliver this signal, so what's it protecting
exactly.

I know it's existing code, but it could go in the previous patch that
already gets halfway there.

Thanks,
Nick

> +}
> +
> +void vas_dump_crb(struct coprocessor_request_block *crb)
> +{
> +	struct data_descriptor_entry *dde;
> +	struct nx_fault_stamp *nx;
> +
> +	dde =3D &crb->source;
> +	pr_devel("SrcDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
> +		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
> +		dde->count, dde->index, dde->flags);
> +
> +	dde =3D &crb->target;
> +	pr_devel("TgtDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
> +		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
> +		dde->count, dde->index, dde->flags);
> +
> +	nx =3D &crb->stamp.nx;
> +	pr_devel("NX Stamp: PSWID 0x%x, FSA 0x%llx, flags 0x%x, FS 0x%x\n",
> +		be32_to_cpu(nx->pswid),
> +		be64_to_cpu(crb->stamp.nx.fault_storage_addr),
> +		nx->flags, nx->fault_status);
> +}
> +
>  static int coproc_open(struct inode *inode, struct file *fp)
>  {
>  	struct coproc_instance *cp_inst;
> diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/pl=
atforms/powernv/vas-fault.c
> index ac3a71ec3bd5..2729ac541fb3 100644
> --- a/arch/powerpc/platforms/powernv/vas-fault.c
> +++ b/arch/powerpc/platforms/powernv/vas-fault.c
> @@ -26,150 +26,6 @@
>   */
>  #define VAS_FAULT_WIN_FIFO_SIZE	(4 << 20)
> =20
> -static void dump_crb(struct coprocessor_request_block *crb)
> -{
> -	struct data_descriptor_entry *dde;
> -	struct nx_fault_stamp *nx;
> -
> -	dde =3D &crb->source;
> -	pr_devel("SrcDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
> -		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
> -		dde->count, dde->index, dde->flags);
> -
> -	dde =3D &crb->target;
> -	pr_devel("TgtDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
> -		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
> -		dde->count, dde->index, dde->flags);
> -
> -	nx =3D &crb->stamp.nx;
> -	pr_devel("NX Stamp: PSWID 0x%x, FSA 0x%llx, flags 0x%x, FS 0x%x\n",
> -		be32_to_cpu(nx->pswid),
> -		be64_to_cpu(crb->stamp.nx.fault_storage_addr),
> -		nx->flags, nx->fault_status);
> -}
> -
> -/*
> - * Update the CSB to indicate a translation error.
> - *
> - * User space will be polling on CSB after the request is issued.
> - * If NX can handle the request without any issues, it updates CSB.
> - * Whereas if NX encounters page fault, the kernel will handle the
> - * fault and update CSB with translation error.
> - *
> - * If we are unable to update the CSB means copy_to_user failed due to
> - * invalid csb_addr, send a signal to the process.
> - */
> -static void update_csb(struct vas_window *window,
> -			struct coprocessor_request_block *crb)
> -{
> -	struct coprocessor_status_block csb;
> -	struct kernel_siginfo info;
> -	struct task_struct *tsk;
> -	void __user *csb_addr;
> -	struct pid *pid;
> -	int rc;
> -
> -	/*
> -	 * NX user space windows can not be opened for task->mm=3DNULL
> -	 * and faults will not be generated for kernel requests.
> -	 */
> -	if (WARN_ON_ONCE(!window->task_ref.mm || !window->user_win))
> -		return;
> -
> -	csb_addr =3D (void __user *)be64_to_cpu(crb->csb_addr);
> -
> -	memset(&csb, 0, sizeof(csb));
> -	csb.cc =3D CSB_CC_FAULT_ADDRESS;
> -	csb.ce =3D CSB_CE_TERMINATION;
> -	csb.cs =3D 0;
> -	csb.count =3D 0;
> -
> -	/*
> -	 * NX operates and returns in BE format as defined CRB struct.
> -	 * So saves fault_storage_addr in BE as NX pastes in FIFO and
> -	 * expects user space to convert to CPU format.
> -	 */
> -	csb.address =3D crb->stamp.nx.fault_storage_addr;
> -	csb.flags =3D 0;
> -
> -	pid =3D window->task_ref.pid;
> -	tsk =3D get_pid_task(pid, PIDTYPE_PID);
> -	/*
> -	 * Process closes send window after all pending NX requests are
> -	 * completed. In multi-thread applications, a child thread can
> -	 * open a window and can exit without closing it. May be some
> -	 * requests are pending or this window can be used by other
> -	 * threads later. We should handle faults if NX encounters
> -	 * pages faults on these requests. Update CSB with translation
> -	 * error and fault address. If csb_addr passed by user space is
> -	 * invalid, send SEGV signal to pid saved in window. If the
> -	 * child thread is not running, send the signal to tgid.
> -	 * Parent thread (tgid) will close this window upon its exit.
> -	 *
> -	 * pid and mm references are taken when window is opened by
> -	 * process (pid). So tgid is used only when child thread opens
> -	 * a window and exits without closing it.
> -	 */
> -	if (!tsk) {
> -		pid =3D window->task_ref.tgid;
> -		tsk =3D get_pid_task(pid, PIDTYPE_PID);
> -		/*
> -		 * Parent thread (tgid) will be closing window when it
> -		 * exits. So should not get here.
> -		 */
> -		if (WARN_ON_ONCE(!tsk))
> -			return;
> -	}
> -
> -	/* Return if the task is exiting. */
> -	if (tsk->flags & PF_EXITING) {
> -		put_task_struct(tsk);
> -		return;
> -	}
> -
> -	kthread_use_mm(window->task_ref.mm);
> -	rc =3D copy_to_user(csb_addr, &csb, sizeof(csb));
> -	/*
> -	 * User space polls on csb.flags (first byte). So add barrier
> -	 * then copy first byte with csb flags update.
> -	 */
> -	if (!rc) {
> -		csb.flags =3D CSB_V;
> -		/* Make sure update to csb.flags is visible now */
> -		smp_mb();
> -		rc =3D copy_to_user(csb_addr, &csb, sizeof(u8));
> -	}
> -	kthread_unuse_mm(window->task_ref.mm);
> -	put_task_struct(tsk);
> -
> -	/* Success */
> -	if (!rc)
> -		return;
> -
> -	pr_debug("Invalid CSB address 0x%p signalling pid(%d)\n",
> -			csb_addr, pid_vnr(pid));
> -
> -	clear_siginfo(&info);
> -	info.si_signo =3D SIGSEGV;
> -	info.si_errno =3D EFAULT;
> -	info.si_code =3D SEGV_MAPERR;
> -	info.si_addr =3D csb_addr;
> -
> -	/*
> -	 * process will be polling on csb.flags after request is sent to
> -	 * NX. So generally CSB update should not fail except when an
> -	 * application passes invalid csb_addr. So an error message will
> -	 * be displayed and leave it to user space whether to ignore or
> -	 * handle this signal.
> -	 */
> -	rcu_read_lock();
> -	rc =3D kill_pid_info(SIGSEGV, &info, pid);
> -	rcu_read_unlock();
> -
> -	pr_devel("%s(): pid %d kill_proc_info() rc %d\n", __func__,
> -			pid_vnr(pid), rc);
> -}
> -
>  static void dump_fifo(struct vas_instance *vinst, void *entry)
>  {
>  	unsigned long *end =3D vinst->fault_fifo + vinst->fault_fifo_size;
> @@ -272,7 +128,7 @@ irqreturn_t vas_fault_thread_fn(int irq, void *data)
>  				vinst->vas_id, vinst->fault_fifo, fifo,
>  				vinst->fault_crbs);
> =20
> -		dump_crb(crb);
> +		vas_dump_crb(crb);
>  		window =3D vas_pswid_to_window(vinst,
>  				be32_to_cpu(crb->stamp.nx.pswid));
> =20
> @@ -293,7 +149,14 @@ irqreturn_t vas_fault_thread_fn(int irq, void *data)
> =20
>  			WARN_ON_ONCE(1);
>  		} else {
> -			update_csb(window, crb);
> +			/*
> +			 * NX sees faults only with user space windows.
> +			 */
> +			if (window->user_win)
> +				vas_update_csb(crb, &window->task_ref);
> +			else
> +				WARN_ON_ONCE(!window->user_win);
> +
>  			/*
>  			 * Return credit for send window after processing
>  			 * fault CRB.
> --=20
> 2.18.2
>=20
>=20
>=20
