Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382981C3F0C;
	Thu, 23 Jul 2026 01:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769084; cv=none; b=G/478rB4Z+BEX5xpr8kURRxYb+3c3194XFAVSlYvK6X1o0ILw1nsUXxz4BXsTkCGf89MiiccjH6rAPlDdRNP4oC6Lb28OXJfGBDq7u8bFuJtsN1Q0K00oeeYeow3eLd34wABqByUXIU0tnrkpC1YlKKXHDoxhIIfeVgvO9US1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769084; c=relaxed/simple;
	bh=X2ALP+IO9Gdtx5HPiU4kXqe9YUWZzsw0FY5BQ3fpDmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBd5CDafMBJ2kUSVQuDYqrffkXa0PKSXPekEFQZouqf2yhfgIHfeqIYg4qEB282sGGRGAQH6CrV+Q9no/mSp+Ej2uZt8SwjoKxlgPioPLUAKODE4v5+de+iU8I08678ibcP2gNSqrqlL1Vt2loY4Px2Y4hOTlqhDXNUl/IOGEIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=grsXsM8g; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="grsXsM8g"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BAF3940E00DC;
	Thu, 23 Jul 2026 01:11:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DAEo3anjhXux; Thu, 23 Jul 2026 01:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784769069; bh=qinsba83m4ZuhFLz/hcxdtDrgPlvk3cvWxiheYUpLFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grsXsM8g88YCbT1HPIPJV1UL1JKl1fLf0bgMuaCjKk0O3mhglITFzhZclWYqCc2SB
	 QWSl4vh6XgRBCnLuRTF2iG4JR7vtShOURpCD2AAfa30iZyqwynkN+OiQDVZee47VgM
	 Rk31lXCSo6q9+bnglFKidP04B/dYbPDn4C47qciToyljXlPeyWcgfVzuaC+tMob+FT
	 Td6lVuE1AuX2B5qLAjPwA0Wa5DXA25/rE+c7YpsJy9oQQUoxkjm8rSHA+BZFI/RM2a
	 MrO5q9+0kB/bT4Efmv+1O4uvljx7mQR+0SPOIPezomBeZ+16LggJBLV1/9dJbRW4Zc
	 c38xBLBoEUNp9JPdelc1TjmyLCAUchZO7hJsG9zUyk5kh2eRWBYfKjH6Co2eh5jnjV
	 pBrG7ExCUNIgb+xNQkG4ohy94dFQrjLKcAhrrrqznzmYW1QslJH/tN0TV6H4ibn5Vv
	 M/vOxGlmgHKEB81Lj+uWRqgt8Dm+zmIRtfsEIQagZdYPG0v28/Re5IDGILpNNbfKS8
	 /giQs4u5GpLbQrf1WNEHpUBSR8QDXdg0yQSksyymxAxGeR+YqnvWK7yRLzimY/kqzR
	 tQuH54qNxitg3QAXlErtWgVzrdo8z0KMXpf3h6naU0hKULx25XRXCSeylkHV6nKKOX
	 Q8nBXcklcjRytXsV9LQ+ewLA=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D062E40E014C;
	Thu, 23 Jul 2026 01:10:34 +0000 (UTC)
Date: Wed, 22 Jul 2026 18:10:31 -0700
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
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>

On Tue, Jun 30, 2026 at 06:10:13PM +0000, Ashish Kalra wrote:
> +static void rmpopt_cleanup(void)
> +{
> +	int cpu;
> +
> +	scoped_guard(cpus_read_lock) {
> +		for_each_cpu(cpu, rmpopt_cpumask)
> +			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
> +	}
> +
> +	free_cpumask_var(rmpopt_cpumask);

The counterpart function which allocates this cpumask is called
snp_setup_rmpopt(). I'm guessing then this one should be called
snp_cleanup_rmpopt(). For balance...

...

> +void snp_setup_rmpopt(void)
> +{
> +	u64 rmpopt_base;
> +	int cpu;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_capable)
> +		return;
> +
> +	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
> +		pr_err("Failed to allocate RMPOPT cpumask\n");
> +		return;
> +	}
> +
> +	/*
> +	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
> +	 * to set up the RMPOPT_BASE MSR.
> +	 *
> +	 * Note: only online primary threads are included.  If a core's
> +	 * primary thread is offline, that core is not covered.  CPU hotplug

So what happens if not all cores are online?

This should check that and fail if that is the case instead of blindly
continuing here.

> +	 * is not currently supported with SNP enabled.
> +	 */
> +	scoped_guard(cpus_read_lock) {
> +		for_each_online_cpu(cpu)
> +			if (topology_is_primary_thread(cpu))
> +				cpumask_set_cpu(cpu, rmpopt_cpumask);
> +
> +		rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> +		rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
> +
> +		/*
> +		 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
> +		 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
> +		 * to the starting physical address to enable RMP optimizations for
> +		 * up to 2 TB of system RAM on all CPUs.
> +		 */

Simplify this comment.

> +		for_each_cpu(cpu, rmpopt_cpumask)
> +			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +	}

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
