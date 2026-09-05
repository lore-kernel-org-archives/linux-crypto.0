Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA3B2D6E58;
	Sat,  5 Sep 2026 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788571840; cv=none; b=pS+1I7XsD0V1J2QWtV23JnYYXonpi3R0Wtluu7BUeEUfbJOnvt/YyWF8qGNcMfs4Xeck3nopnfuyZTdqOFkPH/WlO+0Gp6On9lG20gk0tP7GbiBN+5fycFmQsySv/AM6VuIta+2BL8yeXRGE4mONoMnBQR8cLOdlg1ZQ0d0Xsug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788571840; c=relaxed/simple;
	bh=d/CBhLFjbPlAhNAItDfQ/4uJXM2tKA1e3jC+k9LNt3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l01bCsFzIIyfm/jJw6LQnKvlXHRIHJDxHn/7r2ms35ux+ykPBvdZF6e3Tf9xcA0lpLLySUDixYEyj32asSWD/+vDJc694xmEsxwNwwt3v1dw4jGwtBkff4bgIiLC0lV1XBFBZh2lqYjLk9RurqCedE5BaRztF2njwmhpjiC9sf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kULah2Ng; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kULah2Ng"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5AA9940E00E6;
	Sat,  5 Sep 2026 01:30:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Z7EqV71p49rx; Sat,  5 Sep 2026 01:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788571822; bh=YtdiCM8T6f78OsecQ90guY/JrJBZ0tS0yXbieswmS08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kULah2NgfTSLlX2Udor074ue9WpiuYORPvPvOS85ijeG26D6s8FyHKB7u0BJs7LpF
	 ZWpGJpQ1DjFUPJ/WwN3oiOJxs4AsiExWIcivL9TTkfOrVp1QU6pRvUX9Nx7oKyH7z5
	 UbMPUy4QVBTQhpkLcU6M4rNYjcyarjoL5Ex1QAoGlM/TiId4cFdao22W8s+JJufISC
	 F4esj/j3RCyOwQWJHRKClQIZ7yxDAtgGuQ+sjRR1SDklAohN+mnGLVnnRTbk8xJ05Y
	 n7ngBSKqN0HwlsBGXie9J6B8c6gaET8pb5R1FS26rCrPr0YyBAcFVh/8pq1jkcQca9
	 DMET8/9OhsqNssYHnIM8CNpttwy5+EQy6CQkJ3aW+0P1nms/9zMcwNeT/8YHDC2nQm
	 MjjcWy0gl+nemC0RHkl9qYP+MA2YQnM3dueO3eYfv3KwZI1wFgby7gcIqwB3A2Ze5O
	 WXwrLr2J4JIERVKVc+Ls75QFb22TILUZt8WRosY9E7V/abD4P0L3IMY8hfUS8iQyoX
	 SgCMfbXcCyYOjlx7moNJCAezN3KQ2rrSDrGuMqIOYfpb1Gvs0oAoxDgzf+/ClVVy0f
	 8MT0YqACHgwJf3sUyBTvH35+S9/FGS2UOlW+5rZiLW6Gs7UjWhd1RLIrAj4I/jonR4
	 6dbFLY9/i9KALy34IeIIRxQ8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 652B840E016C;
	Sat,  5 Sep 2026 01:29:48 +0000 (UTC)
Date: Fri, 4 Sep 2026 18:29:45 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v13 4/5] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260905012945.GPaptwicVjJ-SwXYzl@fat_crate.local>
References: <cover.1788296083.git.ashish.kalra@amd.com>
 <a31fc8c6d3f6c6bbe50dc4542c7091b0899d3e1b.1788296083.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a31fc8c6d3f6c6bbe50dc4542c7091b0899d3e1b.1788296083.git.ashish.kalra@amd.com>

On Wed, Sep 02, 2026 at 09:28:57PM +0000, Ashish Kalra wrote:
> Subject: Re: [PATCH v13 4/5] x86/sev: Add support to perform RMP optimizations asynchronously

s/Add support to perform/Perform/

> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SNP is enabled, all writes to memory are checked to ensure memory
> integrity. This imposes performance overhead on the whole system.
> 
> RMPOPT is a new instruction that minimizes the performance overhead of
> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
> checks to be skipped for 1GB regions of memory that are known not to
> contain any SNP guest memory.
> 
> Add support for performing RMP optimizations asynchronously using a
> dedicated workqueue.
> 
> At RMP initialization time, run an optimization pass over all physical
> memory (up to 2TB of system RAM, starting from the lowest physical
> memory address aligned down to a 1GB boundary), skipping RMP checks for
> 1GB regions that do not contain SNP guest memory (excluding preassigned
> pages such as the RMP table and firmware pages).
> 
> As SNP guests are launched, RMPUPDATE assigns their private pages to
> guest-owned state; when such a page falls within an optimized 1GB
> region, the hardware clears that region's RMPOPT optimization and RMP
> checks resume there to protect the guest memory.
> 
> Since launching SNP guests clears these optimizations, perform them
> again asynchronously using the dedicated workqueue.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

R-by's need to get dropped when a patch changes in more or less significant
way.

> @@ -561,10 +571,26 @@ static void rmpopt_disable(void)
>  {
>  	int cpu;
>  
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	/*
> +	 * rmpopt_wq is non-NULL only after RMPOPT has been fully set up: the
> +	 * workqueue is allocated and the RMPOPT_BASE MSRs are programmed.
> +	 * snp_setup_rmpopt() resets it to NULL if any of those steps fail, so a
> +	 * NULL rmpopt_wq means nothing was set up and there is nothing to tear
> +	 * down.
> +	 */
> +	if (!rmpopt_wq)

Now take your patch and rip all that gunk which destroys the setup work done
by snp_setup_rmpopt(). Instead, you init things once and do not touch them
even if RMP optimizations are disabled.

In case they get enabled again later, you simply reactivate them instead of
doing useless setup work all over again.

> +		return;
> +
> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
> +	destroy_workqueue(rmpopt_wq);
> +
>  	for_each_cpu(cpu, cpu_primary_thread_mask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
>  
> -	rmpopt_pa_start = 0;
> +	rmpopt_pa_start = rmpopt_pa_end = 0;
> +	rmpopt_wq = NULL;
>  }
>  
>  void snp_shutdown(void)
> @@ -595,6 +621,44 @@ static bool rmpopt_capable(void)
>  	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>  }
>  
> +/*
> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
> + * memory does not contain any SNP guest memory.
> + *
> + * @pa is a system physical address; RMPOPT operates on the containing 1GB.
> + */
> +static void rmpopt(u64 pa)
> +{
> +	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
> +

	/* Supported by binutils 2.48+ */

> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
> +		     :: "a" (pa_start), "c" (op)
> +		     : "memory", "cc");
> +}



> +
> +/* on_each_cpu() callback: optimize the whole RMPOPT range on this CPU. */
> +static void rmpopt_scan_range(void *arg)
> +{
> +	u64 pa;
> +
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		rmpopt(pa);
> +}
> +
> +static void do_rmpopt_work(struct work_struct *work)
> +{
> +	/*
> +	 * RMPOPT caches the results of a RMP table scan in reserved processor
> +	 * memory, allowing future invocations to skip such costly operations.
> +	 */

We know already. Drop this comment.

> +	migrate_disable();
> +	rmpopt_scan_range(NULL);
> +	migrate_enable();
> +
> +	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
> +}
> +
>  void snp_setup_rmpopt(void)
>  {
>  	u64 rmpopt_base;
> @@ -603,6 +667,34 @@ void snp_setup_rmpopt(void)
>  	if (!rmpopt_capable())
>  		return;
>  
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	/*
> +	 * On re-initialization after a legacy SNP shutdown (SNP_SHUTDOWN_EX
> +	 * with x86_snp_shutdown=0), snp_shutdown() and thus rmpopt_disable() are
> +	 * skipped, so the workqueue, delayed work and per-CPU RMPOPT_BASE MSRs
> +	 * are still set up and valid (SnpEn stayed set and CPU hotplug stayed
> +	 * disabled).  Rather than re-doing the setup, which would leak the
> +	 * existing state, just re-queue the optimization pass to re-optimize any
> +	 * memory the previous SNP session de-optimized.
> +	 */
> +	if (rmpopt_wq) {
> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
> +		return;
> +	}
> +
> +	/*
> +	 * Create an RMPOPT-specific workqueue to avoid scheduling
> +	 * RMPOPT workitem on the global system workqueue.
> +	 */

Why?

> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
> +	if (!rmpopt_wq) {
> +		pr_err("Failed to allocate RMPOPT workqueue\n");
> +		return;
> +	}
> +
> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
> +
>  	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>  	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
>  
> @@ -612,6 +704,23 @@ void snp_setup_rmpopt(void)
>  	 */
>  	for_each_cpu(cpu, cpu_primary_thread_mask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +
> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
> +
> +	/* Limit memory scanning to 2TB of RAM */

No need for that comment - we know.

> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T) {
> +		pr_info("RMPOPT coverage limited to 2TB; memory above 0x%llx not optimized\n",

No need for that print - nothing we can do about it anyway.

> +			rmpopt_pa_start + SZ_2T);
> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
> +	}
> +
> +	/*
> +	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
> +	 * optimizations on all physical memory.
> +	 */

Drop this comment too.

> +	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
> +
> +	pr_info("RMPOPT optimizations enabled\n");
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
>  
> -- 
> 2.43.0
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
