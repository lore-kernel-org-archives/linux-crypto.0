Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A912C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D71A613EE
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 05:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhEJFiP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 01:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhEJFiP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 01:38:15 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033FDC061573
        for <linux-crypto@vger.kernel.org>; Sun,  9 May 2021 22:37:11 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q2so12779848pfh.13
        for <linux-crypto@vger.kernel.org>; Sun, 09 May 2021 22:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=NzhVoKmqHHMnG/Q9A4Jmkq1w2M/F5uJL8CFCHkIVomU=;
        b=oAGq8/YNiKxfb6pY9Y3zRRtodpHVOEAWPHq7vSS14CwLEyOBluZA46fh7dOhGYT+bL
         pvuqHl8GVzE1X2txchQvz47kvrm5KMToB8BRnB3oNopl7pcNd+WCpQqf5UWfXoUEPArk
         XAFXzDkz+q7Jrz0D4ittZawRyTURRx3scofHdOBLdjgq0gET8XnQdAIPJzfpdvLoBMgA
         Qqlex24ZQhMSHS6IenWWBAtsQHVM7mkVMAM6nvJlCR3Sb7TvCdXNY1J0Vho/GiMmk68a
         inxkmictwgpgqqAE9zJnq5EE2eHtUyBb8ENQT8ONACLPNbmDprhdGQ0gY286iGwk026K
         o5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=NzhVoKmqHHMnG/Q9A4Jmkq1w2M/F5uJL8CFCHkIVomU=;
        b=CghSADcQJDTlTr881h/7lISC3d74+x8pZhQzW/28/mAAbLEpXv592SsCxntXCTFfoU
         8qZhTqBUkGGG2NMdYAriCBzUdtivLfEvcGe5TmcOMDrsPFlNNaXBZQhE8qK+P1q3hwTn
         KZG6XqDLqoB8bCCPsxnkR1TuYAQdP4yWLa6AmoPlhWSg//kqwQS4S0PiGu4lZ7bNF1MD
         j4uOS4nsQLQFf1xkh3sT9huwSD9Rvm+8xCv3QVJ9edYgvhqCUkUqZLv8JPkPA/pImbVa
         w1Ba8Bojvdu5qOBHMiVwo6Cdzaa8nxegnFXXVapmX0QwJcHLhQ1ppVxTL08hlLrfJu/U
         MBMg==
X-Gm-Message-State: AOAM530Luez8hE77/u6N3cvfh92gvFCsiIihpqCxeUXYCOBooN/z4HT+
        /kRF96at6AbcBOxNmX7LSWM=
X-Google-Smtp-Source: ABdhPJxXyDHeMEDijOyuVYIZTrDmb65nMkxxzTi6sSSfK2y6F7Jgim1y2V62evoAVjAjmx/TzF3xUQ==
X-Received: by 2002:a65:420d:: with SMTP id c13mr23554177pgq.370.1620625030390;
        Sun, 09 May 2021 22:37:10 -0700 (PDT)
Received: from localhost (60-241-47-46.tpgi.com.au. [60.241.47.46])
        by smtp.gmail.com with ESMTPSA id 1sm9903754pfv.159.2021.05.09.22.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 22:37:10 -0700 (PDT)
Date:   Mon, 10 May 2021 15:37:04 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [V3 PATCH 04/16] powerpc/vas: Move update_csb/dump_crb to common
 book3s platform
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
        <f20654f88f746fe1dd26d27a783a04ae036e8833.camel@linux.ibm.com>
In-Reply-To: <f20654f88f746fe1dd26d27a783a04ae036e8833.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1620624520.2d55hpp9yh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of April 18, 2021 7:03 am:
>=20
> NX issues an interrupt when sees fault on user space buffer.

If a coprocessor encounters an error translating an address, the VAS=20
will cause an interrupt in the host.


> The
> kernel processes the fault by updating CSB. This functionality is
> same for both powerNV and pseries. So this patch moves these
> functions to common vas-api.c and the actual functionality is not
> changed.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/vas.h             |   3 +
>  arch/powerpc/platforms/book3s/vas-api.c    | 146 ++++++++++++++++++-
>  arch/powerpc/platforms/powernv/vas-fault.c | 155 ++-------------------
>  3 files changed, 157 insertions(+), 147 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/va=
s.h
> index 2daaa1a2a9a9..66bf8fb1a1be 100644
> --- a/arch/powerpc/include/asm/vas.h
> +++ b/arch/powerpc/include/asm/vas.h
> @@ -210,4 +210,7 @@ int vas_register_coproc_api(struct module *mod, enum =
vas_cop_type cop_type,
>  void vas_unregister_coproc_api(void);
> =20
>  int vas_reference_task(struct vas_win_task *vtask);
> +void vas_update_csb(struct coprocessor_request_block *crb,
> +		    struct vas_win_task *vtask);
> +void vas_dump_crb(struct coprocessor_request_block *crb);
>  #endif /* __ASM_POWERPC_VAS_H */
> diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platf=
orms/book3s/vas-api.c
> index d98caa734154..dc131b2e4acd 100644
> --- a/arch/powerpc/platforms/book3s/vas-api.c
> +++ b/arch/powerpc/platforms/book3s/vas-api.c
> @@ -111,6 +111,150 @@ int vas_reference_task(struct vas_win_task *vtask)
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
> +		    struct vas_win_task *vtask)
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
> +	if (WARN_ON_ONCE(!vtask->mm))
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
> +	pid =3D vtask->pid;
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
> +		pid =3D vtask->tgid;
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
> +
> +	kthread_use_mm(vtask->mm);
> +	rc =3D copy_to_user(csb_addr, &csb, sizeof(csb));
> +	/*
> +	 * User space polls on csb.flags (first byte). So add barrier
> +	 * then copy first byte with csb flags update.
> +	 */
> +	if (!rc) {
> +		csb.flags =3D CSB_V;
> +		/* Make sure update to csb.flags is visible now */
> +		smp_mb();
> +		rc =3D copy_to_user(csb_addr, &csb, sizeof(u8));
> +	}
> +	kthread_unuse_mm(vtask->mm);
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
> @@ -272,7 +416,7 @@ static struct file_operations coproc_fops =3D {
>   * extended to other coprocessor types later.
>   */
>  int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_ty=
pe,
> -			const char *name, struct vas_user_win_ops *vops)
> +			    const char *name, struct vas_user_win_ops *vops)
>  {
>  	int rc =3D -EINVAL;
>  	dev_t devno;

This change should go back where you added the code. But you've=20
brought back vas_register_corpoc_api? In... patch 2, by the looks
which just renames them back. Perhaps think about keeping the
vas_register_coproc_api in patch 1 in that case, and just adding
the new powernv specific wrapper over it.

But for this patch,

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

