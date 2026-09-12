Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974252D8382;
	Sat, 12 Sep 2026 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789178069; cv=none; b=jn4vVbyLmvkb9cyUXnF+4OIQY9b6M8yWHRdauu462evi2XOuIMfwfI3VntWlyfScRzsWNsrPj4QugHkYHfM6gNPakKvyHgVws36gqMjnFsmzxUYghoPK95/ded6pOJqhitDPeWeaeP0aZSZRn5a4IeFdLaDtYFVjaUz89+X5yTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789178069; c=relaxed/simple;
	bh=t6dgR5XfqJ0LsltNbLwKaLG/YP51jLxudDTfG9Vn5+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8QTya0kY9MasqEvF5HTw96EKEtLGqGIgFRwOq2NdNhd1sohnl4YIwUsWO8pXpzxhJNDIexC16k3LL/yojZRVOxH/d7+z32aN7nNPHxiHooJWRnLxR31s79HAlTwzLTtAhciTGsVOkXFj9dxEiNdkM5q9pYY2bce495eZSM2qfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=lMOrdW7F; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lMOrdW7F"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CE3BC40E00B8;
	Sat, 12 Sep 2026 01:54:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id L3BtR2rSBdQj; Sat, 12 Sep 2026 01:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789178053; bh=E4RlSrzg6+x+KQPg9VIPKMj8UpFsQcBzm8LnjlJfedo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lMOrdW7F5Dg6yRxHpiWee8ljes06YDidY7lRkB4S6Mp8B2wp/k+FfiBjWOJJQwOch
	 3bII5XSBuVbiin6Obf7co5Vht5XQ1gELOXlfvI8J38tsxfBM+jM+kH0aG8/JrCVaVa
	 AG4KO24Po0OUvS2cudXhP5SuklXtm9vVtivvAnKWS2lOZQcztNgvWEbIFjt4c1g798
	 tt1+6sAposoAOKZodPCtTO8L+oSJOUvQf1b5RX1Fer9DbcxZ2Bx7rd00X86LsHNX+7
	 LEAN3SkEQ4VEdlIWF8ASTCcGr7owv5PXP4IukBlboX/jkIYA1IdYU3UqV6+rLNTCrG
	 tH53U64r5LJc7EvLRSacL40FEAZE64PFkYAhzCn1DUBSpieQnvjqUnNAyrwuwWEO0h
	 SlByQOq3sJX+sgCBJPPcizKKGG3gG7itKNoc7aJCuZMbATmpMsoNImA2dLYGWvaTRO
	 4a8HY0yQiDXXVGVv5Emxcy3uvIPe2hEKkOuMqXbufnocnq5rs9ufd1ipPBti1ab+e5
	 CnUMOaiLCRjTy31/mXIjoHSCYAP5HM/tJFOiJvxHpl2PBE3v+DGx91kRR+tg1F3vsL
	 rDpBlDLi7Vy8PHlxcMirIcUil/7jkS3WKMSasMxwSBtmJyeSjzOPqFpIMxB+6lpRc2
	 bKUepEeNNVb3aB21PA+BGjCQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EA01B40E016C;
	Sat, 12 Sep 2026 01:53:39 +0000 (UTC)
Date: Fri, 11 Sep 2026 18:53:36 -0700
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
Subject: Re: [PATCH v14 4/5] x86/sev: Perform RMP optimizations asynchronously
Message-ID: <20260912015336.GJaqSwoBGnp4Zl-jC4@fat_crate.local>
References: <cover.1788984053.git.ashish.kalra@amd.com>
 <1e3d0edb6b275e33fa6f76b0c31db9e999d9a270.1788984053.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1e3d0edb6b275e33fa6f76b0c31db9e999d9a270.1788984053.git.ashish.kalra@amd.com>

On Thu, Sep 10, 2026 at 10:00:08PM +0000, Ashish Kalra wrote:
>  void snp_setup_rmpopt(void)
>  {
>  	u64 rmpopt_base;
> @@ -591,6 +648,30 @@ void snp_setup_rmpopt(void)
>  	if (!rmpopt_capable())
>  		return;
>  
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	/*
> +	 * Set up once: the workqueue and RMPOPT_BASE MSRs are left in place on
> +	 * shutdown, so a later re-initialization just re-queues the optimization
> +	 * pass rather than redoing the setup.
> +	 */
> +	if (rmpopt_wq) {
> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
> +		return;
> +	}

No, this is not how this is done. This is a *setup* function but you also use
it to start the workqueue if it has been allocated already. So it should
either setup or start but not both.

So what you do is, you try to allocate the workqueue. If it fails, you clear
X86_FEATURE_RMPOPT so that rmpopt_capable() is false and that can be your
start_workqueue function.

This way you get rid of all that

	if (rmpopt_wq) 

sprinkles everywhere.

> +
> +	/*
> +	 * Use a dedicated per-CPU workqueue so the potentially lengthy warm-up
> +	 * scan does not tie up a shared workqueue worker.
> +	 */
> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
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
> @@ -600,6 +681,15 @@ void snp_setup_rmpopt(void)
>  	 */
>  	for_each_cpu(cpu, cpu_primary_thread_mask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +
> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
> +
> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
> +
> +	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
> +
> +	pr_info("RMPOPT optimizations enabled\n");
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");

There is no ccp driver patch calling this so this export needs to happen when
you're actually adding the ccp code.

Same thing for the snp_rmpopt_all_physmem() export to kvm-amd.

Looking at this more, I would like to get rid of the snp_setup_rmpopt() export
and have this function do the necessary setup stuff from an initcall in this
file. This way you set up the stuff at kernel init time and have everything
ready to go.

Then the ccp will *only* call a function which is called snp_enable_rmpopt()
after it has enabled SNP. That function simply enables the workqueue.

And then kvm-amd can call that function too so we end up with one export.

Oh, and you can zap those comments while at it:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ca99617142be..c8ba71431a5e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -619,7 +619,6 @@ static void rmpopt(u64 pa)
 		     : "memory", "cc");
 }
 
-/* on_each_cpu() callback: optimize the whole RMPOPT range on this CPU. */
 static void rmpopt_scan_range(void *arg)
 {
 	u64 pa;
@@ -632,7 +631,7 @@ static void do_rmpopt_work(struct work_struct *work)
 {
 	/*
 	 * Warm up the RMPOPT cache on this pinned per-CPU worker with interrupts
-	 * on, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
+	 * enabled, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
 	 */
 	rmpopt_scan_range(NULL);
 
@@ -649,11 +648,6 @@ void snp_setup_rmpopt(void)
 
 	guard(mutex)(&rmpopt_wq_mutex);
 
-	/*
-	 * Set up once: the workqueue and RMPOPT_BASE MSRs are left in place on
-	 * shutdown, so a later re-initialization just re-queues the optimization
-	 * pass rather than redoing the setup.
-	 */
 	if (rmpopt_wq) {
 		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
 		return;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
