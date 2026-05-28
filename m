Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E2A2F745C
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779979543; cv=pass; b=W6RaJ0N9aoi0ddx+QYi1C6tcOAr2WylIdEd38CDer18nP+sgKQ+P5k0Tp/4weDC7qFGFVdBotOQF48oz8d1GCApxvuQZAQIhkwA8mA7d/JMfQux+9j8Tb84OUN4NLDn5+YoHKAWP382mst+66M7Rn4nXTJuBwMBd7tgTi3pD0oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779979543; c=relaxed/simple;
	bh=rq8gxBxKbnVaF8wdJLl6SkHZ/ZKLEKE5u5RN3PdP+Jw=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fKG6mW+RcA3SPunjrmWb2dR5fLOYJPVJ3oznFvnW1Q4tPSSsUuvYLTn0ZnTppk04pikEcVZcwm3jz7A35N+yUVLC6pPb6Ij5w/baXOGvorptMnrzp9pvCkdlvxcSMvkkKrtUrh9TE9Tf1KYDCbE8L8EnHWYY1FKVvHftrItBtV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WVv9XEIH; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WVv9XEIH"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1363e78746eso9019584c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 07:45:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779979541; cv=none;
        d=google.com; s=arc-20240605;
        b=Y8Tyer0gMRUPdVT+7SZsYeDB30T5soe7ssnhEOPyY5HJqHvSeTpSvtdPvXD1mk1VKK
         +EyYCtUuu2icWQUUAw6LalEGFoPUXIHCytgiZaiChBNdpU4PtKSTyRMCiuiEUZ0iHnvf
         m5NkDdt9NMu45AeGAxgvKVqtcCcjj6DmyO0sVd7x79qKaeDCbmmzojuuVKEn3xOAulMq
         Ik9G97HAP0Y3+5Wwj3jmq3mmSf4cuJQueW2zvSl1uGbR2UGOtwsya1CvrbNnsutnKJNw
         IlzgaIr9bekmnVIi2Sh9M7o8FjrtLjXuSXq7cYBk+3lDMeqhz5iDKWKhTr6FSq6txaAA
         kczA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=+gjkdBns27ZcM6QB3XftdqjlzU6m8DV5aKnzoL5burk=;
        fh=k7LFp1Bq6D9FNr33agN9m5KJAQUCNkZIeRdocrCZ2Q4=;
        b=H7r0qz7zoCPW+mAW6jyW47BVQwglTBfuUmBjRnWWFuPV+CmlQGhhuCxyjod0QGiioc
         XJgzBh1MvcE/3XB8nuZ1YIoHlYWCHQpcecrWjWM/AQSH3moTpeyE63lpp0n2qQDGmR0K
         EFutzGYu66w77B1w2EE+ZB96b19lD152GwXUkWwYXmsZ3WFbQloAYyZZZ8KSa5ouW4eq
         Ef2kZqPr/R3VSPTftCO5P+plz8ihOChQI/xpAS1el89M6A7/+jmqSB/aPAjqg1ChBVyS
         RaUJKme09QVP3izsE+dd984kSTU4+KlN64bD9/H5V1mZLS2BDjOqQH1fI4lfE5lUj/eL
         AI7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779979541; x=1780584341; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+gjkdBns27ZcM6QB3XftdqjlzU6m8DV5aKnzoL5burk=;
        b=WVv9XEIHJZj8e8aZyIdryXx7XtpB9u/NNIzOc+cuc7bIDG4H1n0W1tX/mBdMNyWAkQ
         ER9Ae/LZCL/jdYrsnLQSvd+QhYxB0B2bpdCBnpxgAs1qqxRSYmMeFIp346fuQ0rOI2vT
         i7l2SskhCD+bq25iU0ScCJMYvxKYope5FQ5caBxNrdAkL/9K/DpDjq2ta7LN0pRnx3Ch
         TH8dqNucCP0asRGcnzhqU925EKwGEORvbSeD9mBnxipPLlJVhd/Hkx5oe9atSoyQuNQR
         +At4RBethXLIta2iru49G7TLxeATne8zoDP6M6R2+vkPfJXrX3eIFqEpWcrQLef9H8Zn
         LbwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779979541; x=1780584341;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+gjkdBns27ZcM6QB3XftdqjlzU6m8DV5aKnzoL5burk=;
        b=NQ2zveUWaCahQyua9J2TAJjQ4ptZ0lzGy2YoZEbQmeYm44ZVRQdoVU7PLOy8ZG8cdd
         LWxY5knTkVgdzs0/0N45ky6f/TDswJVum3k3sBE2fJYTb2iWpNqEs3lV1ZmgYTpKY9R8
         vciMjqth0Jt44d2hb3qWDg8q7dBoS125abdZGAq3I14qLdoi8uSTfJTvBnvcG3jRmNo4
         ELfG0sA7SInCB3I+ffpUinvsLrhM7u6Sp7O7OmMB8D8w/551kJ8tMTc5466k/ZJCLAix
         rMKduIfAB862lxZsY05O/f+wfbffwhQwazCkNyyVMdt83SeZP742vF3lcZFa3OKJ7Uf+
         5YiQ==
X-Forwarded-Encrypted: i=1; AFNElJ+u/tu6MCOKIMp6Yno8FTN0NQf8EWmZJFAw9U7r0/yGK91CExbUM+nbkGG4WIzhmgxdEc0AY+wRQCJHkt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWpoIwS5K31gDoy9+I+N43HZSowH+q6laS+y1Yv8mTEhx05qjV
	v/wwnPYPalRyQZ5PsIn0km9HX7BYkSjhlkhsRYNLrJVxNtbJRI7PHNCtR+Czu91byNgmRav9wh4
	VVD8Mv+YxUMdPB/WTtnHgrFyuHXe5ezaHBVXf1R1g
X-Gm-Gg: Acq92OG0UyJY5TLO6PDaLNduDhbpN5lreaE8cqWapXhJ8kJhyt61LerLzhf6//1FkJD
	Dl8Yf8PUfzMCL436RlSdVQbG4me+DJhPgFoVXoQ2neCWJaBtFV/5wPHQNrEj9Ekl5FUH8QUiR76
	pC1OyW/ZGZ9fVB7F3EawRlWHuZiDBuCODMP/nbjsvSKu//tQ0nNzgmZIE8nzJZ5oUN2aP3UxWKw
	1zrpReN9me8vaQKMW2WwHmFVhfsNsYwoixoRllrUYqCM8GJJ4lBxdReTL7+22YDayXaNxGJ/pdN
	Ls3Tc8W1LLKHgJJYAdQrOtUD7VxzUM5Brbt2UtSknUqG/yNoPSJ/RyW9YTW0WhtKzcVPw4K0YS7
	GmVFX
X-Received: by 2002:a05:7022:258a:b0:135:e312:47a0 with SMTP id
 a92af1059eb24-1365fa34af3mr9213804c88.26.1779979539969; Thu, 28 May 2026
 07:45:39 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 07:45:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 28 May 2026 07:45:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.1779133590.git.ashish.kalra@amd.com>
References: <cover.1779133590.git.ashish.kalra@amd.com> <6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.1779133590.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 28 May 2026 07:45:38 -0700
X-Gm-Features: AVHnY4IiVpW6Kxx2WcbuW_kautt7HYMS3rg-qGKju88FQuYeSjZIIv004vFPuvg
Message-ID: <CAEvNRgGfyb7zvZ1u1j7YLomD+JdAxnVW36gtvNG9gxgZ80vMyQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] x86/sev: Add support to perform RMP optimizations asynchronously
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, 
	jackyli@google.com, pgonda@google.com, rientjes@google.com, 
	jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com, 
	darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Ashish Kalra <Ashish.Kalra@amd.com> writes:

Thank you Ashish!

> From: Ashish Kalra <ashish.kalra@amd.com>
>
> When SEV-SNP is enabled, all writes to memory are checked to ensure
> integrity of SNP guest memory. This imposes performance overhead on the
> whole system.
>
> RMPOPT is a new instruction that minimizes the performance overhead of
> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
> checks to be skipped for 1GB regions of memory that are known not to
> contain any SEV-SNP guest memory.
>
> Add support for performing RMP optimizations asynchronously using a
> dedicated workqueue.
>
> Enable RMPOPT optimizations globally for all system RAM up to 2TB at

This should also be updated to say "Enable RMPOPT optimizations for up
to 2TB worth of system RAM at..."

The current phrasing sounds like only addresses [0, 2TB) are allowed to
be optimized, but actually any address [start, start + 2TB) can be
optimized?

> RMP initialization time. RMP checks can initially be skipped for 1GB
> memory ranges that do not contain SEV-SNP guest memory (excluding
> preassigned pages such as the RMP table and firmware pages). As SNP
> guests are launched, RMPUPDATE will disable the corresponding RMPOPT
> optimizations.
>
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 167 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 164 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 82f9dc7a57c3..8876cac052d5 100644
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
>  static cpumask_t rmpopt_cpumask;
> -static phys_addr_t rmpopt_pa_start;
> +static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
> +
> +enum rmpopt_function {
> +	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
> +	RMPOPT_FUNC_REPORT_STATUS
> +};
> +
> +#define RMPOPT_WORK_TIMEOUT	10000
> +
> +static struct workqueue_struct *rmpopt_wq;
> +static struct delayed_work rmpopt_delayed_work;
> +static DEFINE_MUTEX(rmpopt_wq_mutex);
>
>  static LIST_HEAD(snp_leaked_pages_list);
>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> @@ -564,12 +576,21 @@ EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>
>  static void rmpopt_cleanup(void)
>  {
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	if (!rmpopt_wq)
> +		return;
> +
> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
> +	destroy_workqueue(rmpopt_wq);
> +
>  	cpus_read_lock();
>  	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, 0);
>  	cpus_read_unlock();
>
>  	cpumask_clear(&rmpopt_cpumask);
> -	rmpopt_pa_start = 0;
> +	rmpopt_pa_start = rmpopt_pa_end = 0;
> +	rmpopt_wq = NULL;
>  }
>
>  void snp_shutdown(void)
> @@ -587,6 +608,105 @@ void snp_shutdown(void)
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>
> +static inline bool __rmpopt(u64 rax, u64 rcx)

Perhaps use pa_start instead of rax and op_type for rcx?

> +{
> +	bool optimized;
> +
> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
> +		     : "=@ccc" (optimized)
> +		     : "a" (rax), "c" (rcx)
> +		     : "memory", "cc");
> +
> +	return optimized;
> +}
> +
> +static void rmpopt(u64 pa)
> +{
> +	u64 rax = ALIGN_DOWN(pa, SZ_1G);
> +	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
> +

And pa_start and op_type here too.

> +	__rmpopt(rax, rcx);
> +}
> +
> +/*
> + * 'val' is a system physical address.
> + */
> +static void rmpopt_smp(void *val)
> +{
> +	rmpopt((u64)val);
> +}
> +
> +/*
> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this
> + * range of memory does not contain any SNP guest memory.
> + */
> +static void rmpopt_work_handler(struct work_struct *work)
> +{
> +	bool current_cpu_cleared = false;
> +	phys_addr_t pa;
> +	int this_cpu;
> +
> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
> +		rmpopt_pa_start, rmpopt_pa_end);
> +
> +	/*
> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
> +	 * reserved processor memory. The RMP scan is the most expensive
> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> +	 * if they can see a cached result in the reserved processor memory.
> +	 *
> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
> +	 * on every other primary thread. This potentially allows the

I like the leader and follower comments below, thanks! With this
leader/follower setup, will the followers definitely see the cached scan
results, or might the followers still potentially not benefit from the
caching? If it's still only "potentially", why?

> +	 * followers to use the "cached" scan results to avoid repeating
> +	 * full scans.
> +	 */
> +
> +	/*
> +	 * Pin the worker to the current CPU for the leader loop so that
> +	 * this_cpu remains valid and the RMPOPT instruction executes on
> +	 * the CPU that was cleared from the cpumask.  The workqueue is
> +	 * WQ_UNBOUND, so without pinning, the scheduler could migrate
> +	 * the worker between the cpumask manipulation and the leader
> +	 * loop, causing the leader to run on a different CPU while
> +	 * this_cpu's core is skipped entirely.
> +	 *
> +	 * Use migrate_disable() rather than get_cpu() to prevent
> +	 * migration while still allowing preemption.
> +	 *
> +	 * Note: rmpopt_cpumask is modified here without holding
> +	 * rmpopt_wq_mutex.  This is safe because the delayed_work
> +	 * mechanism guarantees single-threaded execution of this
> +	 * handler, and rmpopt_cleanup() calls cancel_delayed_work_sync()
> +	 * to ensure handler completion before tearing down the cpumask.
> +	 */
> +	migrate_disable();
> +	this_cpu = smp_processor_id();
> +	if (cpumask_test_cpu(this_cpu, &rmpopt_cpumask)) {
> +		cpumask_clear_cpu(this_cpu, &rmpopt_cpumask);
> +		current_cpu_cleared = true;
> +	}
> +

Instead of reusing the global rmpopt_cpumask, why not make a copy of
rmpopt_cpumask for this function? Then this function won't have to
figure out current_cpu_cleared or restore rmpopt_cpumask at the end.

I'm thinking to also drop the test and clear, this function can just
always clear, like

  cpumask_clear_cpu(smp_processor_id(), followers_cpumask);

and later

  on_each_cpu_mask(&followers_cpumask, ...);

Actually, if for whatever reason cpumask_test_cpu(this_cpu,
&rmpopt_cpumask) above returns false, would that mean somehow some cpu
exists that wasn't enabled right when rmpopt was initialized? If yes,
what happens if we call rmpopt() on a cpu where it wasn't initialized?

> +	/* Leader: prime the RMPOPT cache on this CPU */
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		rmpopt(pa);
> +
> +	migrate_enable();
> +
> +	/* Followers: run RMPOPT on all other cores */
> +	cpus_read_lock();
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
> +		on_each_cpu_mask(&rmpopt_cpumask, rmpopt_smp,
> +				 (void *)pa, true);
> +
> +		 /* Give a chance for other threads to run */
> +		cond_resched();
> +	}
> +	cpus_read_unlock();
> +
> +	if (current_cpu_cleared)
> +		cpumask_set_cpu(this_cpu, &rmpopt_cpumask);
> +}
> +
>
> [...snip...]
>
