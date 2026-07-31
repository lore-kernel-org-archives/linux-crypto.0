Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D473537C7;
	Fri, 31 Jul 2026 05:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785476722; cv=none; b=irinYsP3EemQ2ilnXE4jP8S5b6jK8rNy/WZkmfwRSAYMFFl/oFOzJjF3fK6n9hzJ809H7h8MJU+9gGPG5BeI8JQLGblvPYpyQQTMZxHxpEaA13tsWK8M4WcB5WQfRbQZWe4DBsD7Vis3MWAdhFsSooBtRq/a/CnWPDaBY6YlrWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785476722; c=relaxed/simple;
	bh=zOOJ8DeOnYEfhyleSa0bO9fdEyUdlWPrWt3by1HgCV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUCgPlvHXCZ6nhu52C948Ovh5+i7eBlCymW18tGq17z/AbsS+JZFSz56/2dO988TpG0Nz4uh+xfFTBRiWAO10l4R5ac65ij0bWLKeYroN8UsuYlT2AFLKk9HoG8gK7qWGc4l1kGWjZ6taDp8foL1ZfCmKW90q8a2xPM/wAONn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Wu6aBahq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Wu6aBahq"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F16C140E01CE;
	Fri, 31 Jul 2026 05:45:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8_PwlhpFGBNE; Fri, 31 Jul 2026 05:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785476703; bh=G7VWzTnNmnNc6vhXzTYbTJEpS6/d3XUsM+DmxJ+z4VM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wu6aBahqgkgJsXoi5HEueysdb2eC1wxyelov+kGWWcB5Z7bcUFrE1U9XqUfNkUz6q
	 iezceb1dvqkpxhd7Ywn+0zFzfW6Fdbo/1974qlRlQ+eSfkbzT01O3D9hB+35PEnyQ5
	 YJ1t41XypyN3Pz8/iNgW3BbdRYu9ciBhaDr0v7t8wW2T2dZxRlYzarWKBWV27W4ufF
	 lWv+ro9CdLsNud7xPDqkwnp5e3P3Ze4NG+RVAmu5krMgttVLhWXiyufEBUIAGaUFfR
	 1rRwmheov/iXkrBZn26IS365QaRCjrrqowUaH26xNjhXqBJpiOoG0aYuogZ6Mhvj5P
	 t+qVdJVniXRpElv1Yq3Z4MYaaUq3wuwprgVE33xzcgcHDOPIQBXTmbseSn/O9ZdQwm
	 tfLLVSh9wfZIEmyJi+rYeJYGgASEe7Ie61DzgeoOJihRreRipN5T7eGhLhQRxh8UEU
	 sL0XwnyCZTZJfKWYsMg/bJ6m6hgzLfC/LeOdoE9H2bvqTXP1Icc4gpY+R0VmRrBji2
	 wMykaVRpj0RwDK5V6j/ywsDEju2FC4N4sPeE3quznsUIrKit1Womtq5dIJJ8XisTHe
	 BDmoSpIAI7M0o01/HjFjNnjvlUCqX/jMCW1EbVhclczaW7Bz9YYcs80/gN42GJ7yB2
	 jNyV27vJTuFWw/fpyG4Qe3Bg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7169340E014C;
	Fri, 31 Jul 2026 05:44:28 +0000 (UTC)
Date: Thu, 30 Jul 2026 22:44:25 -0700
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
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260731054425.GNamw2OelKuNhVwnrU@fat_crate.local>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>

On Mon, Jul 27, 2026 at 07:05:29PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is enabled, all writes to memory are checked to ensure
> integrity of SNP guest memory. This imposes performance overhead on the

s/SNP//

The checks are done not only on SNP guest memory but on *all* memory, as your
next paragraph suggests.

> whole system.
> 
> RMPOPT is a new instruction that minimizes the performance overhead of
> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
> checks to be skipped for 1GB regions of memory that are known not to
> contain any SEV-SNP guest memory.

Let's tone down the abbreviations. "SNP guest memory" is enough and let's
stick to that.

> Add support for performing RMP optimizations asynchronously using a
> dedicated workqueue.
> 
> Enable RMPOPT optimizations for up to 2TB of system RAM starting from
> the lowest physical memory address aligned down to a 1GB boundary at
> RMP initialization time. RMP checks can initially be skipped for 1GB

Why "initially"? What are you trying to say here?

> memory ranges that do not contain SEV-SNP guest memory (excluding
> preassigned pages such as the RMP table and firmware pages). As SNP
> guests are launched, RMPUPDATE will disable the corresponding RMPOPT
> optimizations.

Because it will add pages to the RMP table?

This paragraph needs clarification.

> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 160 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 158 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 8bfd80284836..04b19e64f832 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -19,6 +19,7 @@
>  #include <linux/iommu.h>
>  #include <linux/amd-iommu.h>
>  #include <linux/nospec.h>
> +#include <linux/workqueue.h>
>  
>  #include <asm/sev.h>
>  #include <asm/processor.h>
> @@ -125,7 +126,18 @@ static void *rmp_bookkeeping __ro_after_init;
>  static u64 probed_rmp_base, probed_rmp_size;
>  
>  static cpumask_var_t rmpopt_cpumask;
> -static phys_addr_t rmpopt_pa_start;
> +static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
> +
> +enum rmpopt_function {

	rmpopt_op_type

> +	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
> +	RMPOPT_FUNC_REPORT_STATUS

RMPOPT_OP_VERIFY...

> +};
> +

/*
 * This timeout was selected this way because...
 */

> +#define RMPOPT_WORK_TIMEOUT	10000
> +
> +static struct workqueue_struct *rmpopt_wq;
> +static struct delayed_work rmpopt_delayed_work;
> +static DEFINE_MUTEX(rmpopt_wq_mutex);
>  
>  static LIST_HEAD(snp_leaked_pages_list);
>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> @@ -565,11 +577,20 @@ static void snp_cleanup_rmpopt(void)
>  {
>  	int cpu;
>  
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	if (!rmpopt_wq)
> +		return;

If there's no workqueue, you skip all the rest, including undoing things which
are not workqueue-related?

That workqueue pointer must be magical and special. Yet, I don't see anything
explaining that.

> +
> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
> +	destroy_workqueue(rmpopt_wq);
> +
>  	for_each_cpu(cpu, rmpopt_cpumask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
>  
>  	free_cpumask_var(rmpopt_cpumask);
> -	rmpopt_pa_start = 0;
> +	rmpopt_pa_start = rmpopt_pa_end = 0;
> +	rmpopt_wq = NULL;
>  }
>  
>  void snp_shutdown(void)
> @@ -599,6 +620,96 @@ static bool rmpopt_capable(void)
>  	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>  }
>  
> +/*
> + * RMPOPT: F2 0F 01 FC
> + *   Input:  RAX = system physical address (1GB aligned)
> + *           RCX = operation type
> + *   Output: CF set if the range was optimized
> + */
> +static inline bool __rmpopt(u64 pa_start, u64 op_type)
> +{
> +	bool optimized;
> +

	/*
	 * needs a comment here which says which binutils version
	 * supports the RMPOPT mnemonic.
	 */
> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
> +		     : "=@ccc" (optimized)
> +		     : "a" (pa_start), "c" (op_type)
> +		     : "memory", "cc");
> +
> +	return optimized;
> +}
> +
> +static void rmpopt(u64 pa)
> +{
> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
> +	u64 op_type = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;

	enum rmpopt_op_type op = ...

> +
> +	__rmpopt(pa_start, op_type);

Looks like the __rmpopt() carve out is not really necessary and you can merge
it back into rmpopt().

> +}
> +
> +/*
> + * 'val' is a system physical address.
> + */
> +static void rmpopt_smp(void *val)

You don't need that one - you can use rmpopt(). But keep on reading...

> +{
> +	rmpopt((u64)val);
> +}
> +
> +/*
> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this
> + * range of memory does not contain any SNP guest memory.
> + */

Put that comment above rmpopt().

> +static void rmpopt_work_handler(struct work_struct *work)
> +{
> +	cpumask_var_t follower_mask;
> +	phys_addr_t pa;

So either phys_addr_t or u64 but not both for a pa.

> +	int this_cpu;
> +
> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
> +		rmpopt_pa_start, rmpopt_pa_end);

This is going to spam dmesg every time the workqueue runs?

Nope, zap it.

> +	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL)) {
> +		pr_warn("RMP optimization pass skipped: cpumask allocation failed\n");
> +		return;
> +	}

Why? Why isn't the follower mask allocated once at init time?

> +
> +	/*
> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
> +	 * reserved processor memory. The RMP scan is the most expensive
> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> +	 * if they can see a cached result in the reserved processor memory.
> +	 *
> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
> +	 * on every other primary thread. Followers are "designed to"
> +	 * skip the scan if they see the "cached" scan results.
> +	 *
> +	 * Pin the worker to the current CPU for the leader loop so that

Isn't worker == leader here?

> +	 * this_cpu remains valid and the RMPOPT instruction executes on
> +	 * the correct CPU. 

> Use migrate_disable() rather than get_cpu() to
> +	 * prevent migration while still allowing preemption.

No need to explain that.

> +	 */
> +	migrate_disable();
> +	this_cpu = smp_processor_id();
> +
> +	cpumask_andnot(follower_mask, rmpopt_cpumask,
> +		       topology_sibling_cpumask(this_cpu));
> +
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		rmpopt(pa);
> +
> +	migrate_enable();
> +
> +	/*
> +	 * Followers: run RMPOPT on the remaining cores.  cpus_read_lock() is
> +	 * intentionally not held here: CPU hotplug is disabled for the entire
> +	 * time SNP is active (see snp_prepare()), and this work only runs while
> +	 * SNP is active, so the follower set stays valid across the whole scan.
> +	 */
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);

An IPI per 1G pa?!?!? On each CPU?!

Instead of IPIing each CPU and inside the handler, doing the loop?

Nope.

> +
> +	free_cpumask_var(follower_mask);
> +}

Ok, enough for this part. Part II coming up later.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
