Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E363BB48;
	Mon, 30 Mar 2026 23:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774912936; cv=none; b=rK1+35sy4QLstHDQtz7/XXOllQYT+zUuN4dRBrSbGkpOxNeVcsGenhKpcwIYXwZWdCGov6XLNR31LqIf1cvdAgHRI7bLRrgHd62gszRyQBIdOf9w/GiFTAeBH89NkTZSBSIbcuINtW1gHXcVyWvQnm9uXF+vyGE+ENi20VsLBPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774912936; c=relaxed/simple;
	bh=ng9W5b/WchynJ+QCgePlqtKnClGVfH9wutZDSpGWAQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IoRCGrwZf4UyArA79zagDOD5Llnu4qDDubtgU6oQSSZ5Q0jWA/mw+sSMFzHJ1N7O3SY5o4ono9Zr1b6b6wnmsTgwXxMDyBw20qsb/7mNONB3iZkrmj19+GEJOgIFnWcaZN0uBR100hfr5UW0erv60cNSWc+2fjVA5DMveJz0mBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hrFNQpd2; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hrFNQpd2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774912935; x=1806448935;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ng9W5b/WchynJ+QCgePlqtKnClGVfH9wutZDSpGWAQ0=;
  b=hrFNQpd2+83NYDThaxJ3OC8zqZZoegPp2LuTNGOjzwX42RDHq2p0iay9
   TgoAmYInKjfZ68sgjEnspgdfSmW0DGTaIEQxALY891JYzWz/2/VxhAuhj
   GTXScElbRE5ceJkAPS2tqbmLXWzbRyXHcRbglII8vivdwlJVUXgUjmxUN
   +MhGLc95RBcqvAqmOi20oDyUUqDYqr3FTnZQiJAP8hq3dFdG37fljGY/u
   tEIiNuiYncAkXqrORmv/Pa+tQHYtCFti64YPwhsOIPn975AmQ3rNRjxKb
   2tuwRK6JdowcfUNX+7ddSTG/SQ6E1Me3E3+DXFT4ylRVlfoaVf2Pk1g38
   A==;
X-CSE-ConnectionGUID: aAoOyiwrTbqubecHpr/9Ug==
X-CSE-MsgGUID: SxTBZNp5R/Cz1UHLGaz38w==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="75933006"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="75933006"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 16:22:15 -0700
X-CSE-ConnectionGUID: Oa2UjkAoTKigWg3WH8W9EQ==
X-CSE-MsgGUID: fGbeimd5SPa57jZBjYC+1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="226165170"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 16:22:13 -0700
Message-ID: <ab41b1d8-e464-4ad6-ac07-7318686db10e@intel.com>
Date: Mon, 30 Mar 2026 16:22:19 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1774755884.git.ashish.kalra@amd.com>
 <6345df31337125280f91ad8f37843aa865fd85fc.1774755884.git.ashish.kalra@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <6345df31337125280f91ad8f37843aa865fd85fc.1774755884.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 15:26, Ashish Kalra wrote:
...
> As SEV-SNP is enabled by default on boot when an RMP table is
> allocated by BIOS, the hypervisor and non-SNP guests are subject to
> RMP write checks to provide integrity of SNP guest memory.

This is a long-winded way of saying:

	When SEV-SNP is enabled, all writes to memory are checked to
	ensure integrity of SNP guest memory. This imposes performance
	overhead on the whole system.

> RMPOPT is a new instruction that minimizes the performance overhead of
> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
> checks to be skipped for 1GB regions of memory that are known not to
> contain any SEV-SNP guest memory.
> 
> Add support for performing RMP optimizations asynchronously using a
> dedicated workqueue, scheduling delayed work to perform RMP
> optimizations every 10 seconds.

Gah, does it really do this _every_ 10 seconds? Whether or not any
guests are running or if the SEV-SNP state has changed at *all*? This
code doesn't implement that, right? If so, why mention it here?

> +static void rmpopt_work_handler(struct work_struct *work)
> +{
> +	phys_addr_t pa;
> +
> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
> +		rmpopt_pa_start, rmpopt_pa_end);
> +
> +	/*
> +	 * RMPOPT optimizations skip RMP checks at 1GB granularity if this
> +	 * range of memory does not contain any SNP guest memory. Optimize
> +	 * each range on one CPU first, then let other CPUs execute RMPOPT
> +	 * in parallel so they can skip most work as the range has already
> +	 * been optimized.
> +	 */

This comment could be much more clear.

First, the granularity has *zero* to do with this optimization.

Second, the optimization this code is doing only makes sense if the RMP
itself is caching the RMPOPT result in a global, single place. That's
not explained. It needs something like:

	RMPOPT does three things: It scans the RMP table, stores the
	result of the scan in the global RMP table and copies that
	result to a per-CPU table. The scan is the most expensive part.
	If a second RMPOPT occurs, it can skip the expensive scan if it
	sees the "cached" scan result in the RMP.

	Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
	on every other primary thread. This potentially allows the
	followers to use the "cached" scan results to avoid repeating
	full scans.

> +	cpumask_clear_cpu(smp_processor_id(), &primary_threads_cpumask);

How do you know that the current CPU is *in* 'primary_threads_cpumask'
in the first place? I guess it doesn't hurt to do RMPOPT in two places,
but why not just be careful about it?

Also, logically, 'primary_threads_cpumask' never changes (modulo CPU
hotplug). The thing you're tracking here is "primary CPUs that need to
have RMPOPT executed on them". That's a far different thing than the
name for the variable.

> +	/* current CPU */
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		rmpopt((void *)pa);

This _looks_ rather wonky because it's casting a 'pa' to a virtual
address for no apparent reason.

Also, rmpopt() itself does 1G alignment. This code ^ also aligns the
start and end. Why?

> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
> +		on_each_cpu_mask(&primary_threads_cpumask, rmpopt,
> +				 (void *)pa, true);
> +
> +		 /* Give a chance for other threads to run */
> +		cond_resched();
> +
> +	}
> +
> +	cpumask_set_cpu(smp_processor_id(), &primary_threads_cpumask);
> +}

Honestly, I _really_ wish this series would dispense with *all* the
optimizations in the first version. This looks really wonky because
'primary_threads_cpumask' is a global variable and is initialized before
the work function when it could probably be done within the work function.

It's also *really* generically and non-descriptively named for a
global-scope variable.

> +static void rmpopt_all_physmem(bool early)
> +{
> +	if (!rmpopt_wq)
> +		return;
> +
> +	if (early)
> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
> +				   msecs_to_jiffies(1));
> +	else
> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
> +				   msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
> +}

This is rather unfortunate on several levels.

First, even if the 'bool early' thing was a good idea, this should be
written:

	unsigned long timeout = RMPOPT_WORK_TIMEOUT;

	if (early)
		timeout = 1;
	
	queue_delayed_work(rmpopt_wq,
			   &rmpopt_delayed_work,			
			   msecs_to_jiffies(timeout));

But, really, why does it even *need* a bool for early/late? Just do a
late_initcall() if you want this done near boot time.


>  static __init void configure_and_enable_rmpopt(void)
>  {
>  	phys_addr_t pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> @@ -499,6 +582,37 @@ static __init void configure_and_enable_rmpopt(void)
>  	 */
>  	for_each_online_cpu(cpu)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);

What is the scope of MSR_AMD64_RMPOPT_BASE? Can you have it enabled on
one thread and not the other? Could they be different values both for
enabling and the rmpopt_base value?

If it's not per-thread, then why is it being initialized for each thread?

> +	/*
> +	 * Create an RMPOPT-specific workqueue to avoid scheduling
> +	 * RMPOPT workitem on the global system workqueue.
> +	 */
> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
> +	if (!rmpopt_wq)
> +		return;

I'd probably just put this first. Then if the allocation fails, you
don't even bother doing the WRMSRs. Heck if you did that, you could even
use the MSR bit for the indicator of if RMPOPT is supported.

> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
> +
> +	rmpopt_pa_start = pa_start;

Why is there a 'rmpopt_pa_start' and 'pa_start'?

> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
> +
> +	/* Limit memory scanning to the first 2 TB of RAM */
> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
> +
> +	/* Only one thread per core needs to issue RMPOPT instruction */
> +	for_each_online_cpu(cpu) {
> +		if (!topology_is_primary_thread(cpu))
> +			continue;
> +
> +		cpumask_set_cpu(cpu, &primary_threads_cpumask);
> +	}
> +
> +	/*
> +	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
> +	 * optimizations on all physical memory.
> +	 */
> +	rmpopt_all_physmem(TRUE);
>  }
