Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F4F272E6D;
	Sat, 29 Aug 2026 20:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788036782; cv=none; b=ClBn0fT5/fOeH/FkvWSP4LBXuFKl5k5OAuGy4Nc+tytgRy7MZ7uIxuLqJX1T7CSaBThl3E+s9VUSt7boPGsspXJeCynSx7HoxoNXvWugJMlT3gkESFMWNawhn9pyY+z/qE0gdY1Dr62cszs912kNP5zPvF30uDklTpxC+eWOIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788036782; c=relaxed/simple;
	bh=B4zSGLdJ2v1MrTTIuygmOZOntoAOMbC/y04ayaQhSvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rthWnrRS6CSVVTQ3zu3POlfSzxWIJ7HWRTfnCFR7HCbvcJaD3cvrrT+iMD8xT0Coh5rohlif9154wWNVaIGDgebTtH3ZPmDemVYP1irr1br86oNY2txga71+E8z4PxfOzDCOfi9TkAbNj676NRT5ELPJB9xFqa/6Ii1l5GoJa+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=U4cuRQLV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="U4cuRQLV"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8889640E039E;
	Sat, 29 Aug 2026 20:52:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NNr9zwtt48Ym; Sat, 29 Aug 2026 20:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788036766; bh=RXU+41X6N0UK5DI5Zk12OSxGRdbePYrhCOq4AMtWKbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U4cuRQLVzGJ+NTHQdYb273h+HBXCKwR2cC06XI9/4n/9QbsCPyFSiOF0/cVJbowOp
	 EHHIuDv63tyNaN2mJ9ne5qcEQ3Jtm1HS8A2s9MvAvCb5f0B0yYAiiGPQohc1c1OQa/
	 zBMtNu06C6XLNBTMarq4H2RjD6aMUyPSTA+wFzdpDjd+3Ol3ZMc7hEp32oEsFSYokx
	 uoMG92Xop7mSFq/oFfKSECU1x/91eUFSI+SpuCpZo7tk1E2zZpio7dxXOlKJb2oW1h
	 8787xuggW9V9CHkLmCVPg/03HZY55Pkk6Q9zW6v78xWF5QqKMkKWhUhoYmsABZWceA
	 1eeeFqigi/sNvS/I0tYJMNKJ7Q4Csx8h/L3DPv8v8cV40bU9pIr4nkCzBipxAbTCs1
	 Z8cY6LBWmw9vmvZ0OvAIHGFvN+KM9hXls8gEM8c3yNW989IRXgEufD3PRzaWh/3TTU
	 J9VT9/EXDmjJdWKHEjnIzfco7bmeBXoezU5zMHLxZo57XyqZIJwM1bBILVySmmSwZR
	 KzLfYcjiKc07Q9fAuBISkKGgQO02tZjjpn0tynmGmtWAUoNbFjJmqHdR2m83czQ9sh
	 DJtpzqLo7oo2/xFdQOEakh0Cjb3VB7t0GgpOJJuPGOpT0x2DUPRYw04IeoHpiavuwn
	 J4663te3s3uSVnrMCxhSVi5Y=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7504240E02C2;
	Sat, 29 Aug 2026 20:52:11 +0000 (UTC)
Date: Sat, 29 Aug 2026 13:52:08 -0700
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
Subject: Re: [PATCH v12 4/5] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260829205208.GDapNGeGMOs02IrkGS@fat_crate.local>
References: <cover.1786389115.git.ashish.kalra@amd.com>
 <9c9502278f68af9da19f0dd583ba303d0e6d66d2.1786389115.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c9502278f68af9da19f0dd583ba303d0e6d66d2.1786389115.git.ashish.kalra@amd.com>

On Mon, Aug 10, 2026 at 07:22:10PM +0000, Ashish Kalra wrote:
> +/*
> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
> + * memory does not contain any SNP guest memory.
> + *
> + * @pa is a system physical address; RMPOPT operates on the containing 1GB.
> + */
> +static void rmpopt(u64 pa)
> +{
> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
> +	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
> +
> +	/*
> +	 * RMPOPT (F2 0F 01 FC): RAX = 1GB-aligned SPA, RCX = op type, CF set if
> +	 * the range was optimized (result unused on this path).
> +	 *
> +	 * Binutils does not support the RMPOPT mnemonic yet, so the instruction
> +	 * is encoded with .byte.
> +	 */

I don't know whether you've checked the binutils sources but this should have
the version of binutils which supports it and I think there is no such version
yet - I've pinged binutils team to see what their plans are.

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
> +static void rmpopt_work_handler(struct work_struct *work)
> +{
> +	int this_cpu;
> +
> +	/*
> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
> +	 * reserved processor memory. The RMP scan is the most expensive
> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> +	 * if they can see a cached result in the reserved processor memory.
> +	 *
> +	 * Run RMPOPT on one CPU first (the leader), then on every other primary
> +	 * thread (the followers).  A follower skips the expensive RMP scan by
> +	 * reusing the cached scan results the leader produced.
> +	 *
> +	 * migrate_disable() pins this work to the current CPU so it stays the
> +	 * leader for the whole leader loop: this_cpu remains valid and the
> +	 * RMPOPT instruction runs on it.
> +	 */
> +	migrate_disable();
> +	this_cpu = smp_processor_id();
> +
> +	cpumask_andnot(rmpopt_follower_mask, rmpopt_cpumask,
> +		       topology_sibling_cpumask(this_cpu));
> +
> +	rmpopt_scan_range(NULL);
> +
> +	migrate_enable();
> +
> +	/*
> +	 * Followers: one IPI per remaining core, each optimizing the whole
> +	 * range.  Each runs with interrupts disabled, but only issues cache-hit
> +	 * RMPOPTs (the leader populated the scan cache above), so the window is
> +	 * short.  cpus_read_lock() is intentionally not held: CPU hotplug is
> +	 * disabled the entire time SNP is active (see snp_prepare()), and this
> +	 * work only runs while SNP is active, so the follower set stays valid.
> +	 */
> +	on_each_cpu_mask(rmpopt_follower_mask, rmpopt_scan_range, NULL, true);

If the leader ran once and the results are cached, then does it matter if
I run RMPOPT on it again? IOW, what's stopping me from doing

	on_each_cpu_mask(rmpopt_cpumask, rmpopt_scan_range, NULL, true);

and don't care about leaders and followers at all?

Also, rmpopt_mask is cpu_primary_thread_mask and you don't need any of those
gymnastics.

IOW, this is how my cleanup ontop looks like so far:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 55a6e2319899..a1f6f3111517 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -125,7 +125,6 @@ static void *rmp_bookkeeping __ro_after_init;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
-static cpumask_var_t rmpopt_cpumask, rmpopt_follower_mask;
 static u64 rmpopt_pa_start, rmpopt_pa_end;
 
 enum rmpopt_op_type {
@@ -587,11 +586,9 @@ static void rmpopt_disable(void)
 	cancel_delayed_work_sync(&rmpopt_delayed_work);
 	destroy_workqueue(rmpopt_wq);
 
-	for_each_cpu(cpu, rmpopt_cpumask)
+	for_each_cpu(cpu, cpu_primary_thread_mask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
 
-	free_cpumask_var(rmpopt_cpumask);
-	free_cpumask_var(rmpopt_follower_mask);
 	rmpopt_pa_start = rmpopt_pa_end = 0;
 	rmpopt_wq = NULL;
 }
@@ -632,16 +629,9 @@ static bool rmpopt_capable(void)
  */
 static void rmpopt(u64 pa)
 {
-	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
 	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
+	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
 
-	/*
-	 * RMPOPT (F2 0F 01 FC): RAX = 1GB-aligned SPA, RCX = op type, CF set if
-	 * the range was optimized (result unused on this path).
-	 *
-	 * Binutils does not support the RMPOPT mnemonic yet, so the instruction
-	 * is encoded with .byte.
-	 */
 	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
 		     :: "a" (pa_start), "c" (op)
 		     : "memory", "cc");
@@ -656,43 +646,22 @@ static void rmpopt_scan_range(void *arg)
 		rmpopt(pa);
 }
 
-static void rmpopt_work_handler(struct work_struct *work)
+static void do_rmpopt_work(struct work_struct *work)
 {
 	int this_cpu;
 
 	/*
-	 * RMPOPT scans the RMP table, stores the result of the scan in the
-	 * reserved processor memory. The RMP scan is the most expensive
-	 * part. If a second RMPOPT occurs, it can skip the expensive scan
-	 * if they can see a cached result in the reserved processor memory.
-	 *
-	 * Run RMPOPT on one CPU first (the leader), then on every other primary
-	 * thread (the followers).  A follower skips the expensive RMP scan by
-	 * reusing the cached scan results the leader produced.
-	 *
-	 * migrate_disable() pins this work to the current CPU so it stays the
-	 * leader for the whole leader loop: this_cpu remains valid and the
-	 * RMPOPT instruction runs on it.
+	 * RMPOPT caches the results of a RMP table scan in reserved processor
+	 * memory, allowing future invocations to skip such costly operations.
 	 */
 	migrate_disable();
 	this_cpu = smp_processor_id();
 
-	cpumask_andnot(rmpopt_follower_mask, rmpopt_cpumask,
-		       topology_sibling_cpumask(this_cpu));
-
 	rmpopt_scan_range(NULL);
 
 	migrate_enable();
 
-	/*
-	 * Followers: one IPI per remaining core, each optimizing the whole
-	 * range.  Each runs with interrupts disabled, but only issues cache-hit
-	 * RMPOPTs (the leader populated the scan cache above), so the window is
-	 * short.  cpus_read_lock() is intentionally not held: CPU hotplug is
-	 * disabled the entire time SNP is active (see snp_prepare()), and this
-	 * work only runs while SNP is active, so the follower set stays valid.
-	 */
-	on_each_cpu_mask(rmpopt_follower_mask, rmpopt_scan_range, NULL, true);
+	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
 }
 
 void snp_setup_rmpopt(void)
@@ -729,30 +698,7 @@ void snp_setup_rmpopt(void)
 		return;
 	}
 
-	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
-
-	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
-		pr_err("Failed to allocate RMPOPT cpumask\n");
-		destroy_workqueue(rmpopt_wq);
-		rmpopt_wq = NULL;
-		return;
-	}
-
-	if (!zalloc_cpumask_var(&rmpopt_follower_mask, GFP_KERNEL)) {
-		pr_err("Failed to allocate RMPOPT follower cpumask\n");
-		free_cpumask_var(rmpopt_cpumask);
-		destroy_workqueue(rmpopt_wq);
-		rmpopt_wq = NULL;
-		return;
-	}
-
-	/*
-	 * The RMPOPT_BASE MSR has core scope. All primary threads are online,
-	 * otherwise SNP would not have been enabled.
-	 */
-	for_each_online_cpu(cpu)
-		if (topology_is_primary_thread(cpu))
-			cpumask_set_cpu(cpu, rmpopt_cpumask);
+	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
 
 	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
 	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
@@ -761,7 +707,7 @@ void snp_setup_rmpopt(void)
 	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
 	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
 	 */
-	for_each_cpu(cpu, rmpopt_cpumask)
+	for_each_cpu(cpu, cpu_primary_thread_mask)
 		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
 
 	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
