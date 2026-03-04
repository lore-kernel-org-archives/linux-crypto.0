Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF01317146
	for <linux-crypto@vger.kernel.org>; Wed,  4 Mar 2026 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636465; cv=none; b=VKtRLNefOtF0QFWfWQUrd2jkqqSPgUS52izu/lmT+RROySzhG/YNp0ag5cb2MZhDabvQ5RJkC+3PMMne3CLfD9/oh8EvsR8ml0bINUfMEmxStMlW0DRTQ5AxT9szacaAkBOyoKQ/tpP896YuWuClP5ZY9OY7psOKvnJiLearyfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636465; c=relaxed/simple;
	bh=mCLb0PHQAeQDx00dGHuwh3g1vsMSqGYmFbHwGRfEcTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZHyajRiKw+N3PhIpqlgVWWQYQq3aghKylVqLYLJM1Qn5fTddE4JHNZxGjuGbC8VmdbDsL9pFOiGZwJXzs71vqCgqgbsgOkxa5zSKSHUNPuaTPmoAneQWQ2TFPyUDs9u8RTuNSirqdcSwwHVOI2wBuDMpV1obrJJxEduO2BVZwU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BuJ/rymH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BuJ/rymH"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae3badc00dso45896565ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2026 07:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772636464; x=1773241264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9mFnYWcgeVruYPIwAypZtO50oTC/FQ8Br8I5CLuM3M=;
        b=BuJ/rymH+jdWq7YixgpBuOWhieNSWRRuuyYlHfxb0Poii1kEzcknOVwgUlPnff0X5d
         Rwsc3OPCbnwa3SWASkRQY2IF3XuuzOSemqCf9V+2SJTgF5ieEJ1xPLvxpHKfNNrHrweY
         UJ/WrTjLF9GdCWowCifM/7Uxb3l5n+ZLzCpHQBLXyEpamXequO1Y5jEBZOxEm0zSdfPM
         flwNVzWW4siwBoSedHf2PKzji7E2USW0DvLRVHs4+7+sHqtRh9ajUDDQgYSbXXuaswy9
         R9hPwIeEmukJ7pd+V3ykp1NBjTJ6d11IBQGXaY31TEe8yuL/BBLJCBPE8tzA5WA8DjgP
         YA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772636464; x=1773241264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9mFnYWcgeVruYPIwAypZtO50oTC/FQ8Br8I5CLuM3M=;
        b=dMat444nYHUySeWyBrdYBycCjj1xdV/JzCFJyIexEP+ANwa7Uyd54EW9+vY/F3IqU/
         AKj7ChpZqeLx82REliMEj3iNL8BPVkuFFdv8LrMnkswHFkFlNrAlFJsdCx8USb60N1Zi
         xB9Q0AYVmHR048qLjMbSj6ghtWN/tw8tdWlLwnDneMguZu5w1c352cJGvhNaVJsxTl2J
         1+Q5Hpa5p2p5tvQILCAvcr6eP4pjfp863f0bZnOfGVrTFgi9HzRHJJ9+tjUvCSH3djxS
         jzKIYBkUNxnWNHHhu4W8Id5gePcWZnQaRmU2lHLBh7UEtda8D5sxN5pwvVopHoicPA5I
         Qn8w==
X-Forwarded-Encrypted: i=1; AJvYcCUBGArEj18S48lRyZ6asDgA4PU1mGQL2Pzm7IFBzDglbrZ3cDjKog7100Qs62U8t9v53RCYQpWzwWO+wYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV97SaGmsbS3D8p9fdbNWUAEet/NBAdw7nX6d76O85IrxNGlYG
	9dXDukczY56o7X/MagW3axgDLeEPEGFf/htoxVfXZx/hqd8fGElr8ZTjH7126xDVu9m6x/0kw0Q
	uCRFRxg==
X-Received: from plblq5.prod.google.com ([2002:a17:903:1445:b0:2ae:4e8d:56b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41d0:b0:2ae:6779:c8bb
 with SMTP id d9443c01a7336-2ae6aa0f17emr19749075ad.5.1772636463462; Wed, 04
 Mar 2026 07:01:03 -0800 (PST)
Date: Wed, 4 Mar 2026 07:01:02 -0800
In-Reply-To: <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1772486459.git.ashish.kalra@amd.com> <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
Message-ID: <aahH4XARlftClMrQ@google.com>
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, 
	Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, 
	Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com, 
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com, 
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com, 
	nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 02, 2026, Ashish Kalra wrote:
> @@ -500,6 +508,61 @@ static bool __init setup_rmptable(void)
> +/*
> + * 'val' is a system physical address aligned to 1GB OR'ed with
> + * a function selection. Currently supported functions are 0
> + * (verify and report status) and 1 (report status).
> + */
> +static void rmpopt(void *val)
> +{
> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
> +		     : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
> +		     : "memory", "cc");
> +}
> +
> +static int rmpopt_kthread(void *__unused)
> +{
> +	phys_addr_t pa_start, pa_end;
> +
> +	pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
> +	pa_end = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
> +
> +	/* Limit memory scanning to the first 2 TB of RAM */
> +	pa_end = (pa_end - pa_start) <= SZ_2T ? pa_end : pa_start + SZ_2T;
> +
> +	while (!kthread_should_stop()) {
> +		phys_addr_t pa;
> +
> +		pr_info("RMP optimizations enabled on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
> +			pa_start, pa_end);
> +
> +		/*
> +		 * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
> +		 * memory does not contain any SNP guest memory.
> +		 */
> +		for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
> +			/* Bit zero passes the function to the RMPOPT instruction. */
> +			on_each_cpu_mask(cpu_online_mask, rmpopt,
> +					 (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
> +					 true);
> +
> +			 /* Give a chance for other threads to run */

I'm not terribly concerned with other threads, but I am most definitely concerned
about other CPUs.  IIUC, *every* time a guest_memfd file is destroyed, the kernel
will process *every* 2MiB chunk of memory, interrupting *every* CPU in the process.

Given that the whole point of RMPOPT is to allow running non-SNP and SNP VMs
side-by-side, inducing potentially significant jitter when stopping SNP VMs seems
like a dealbreaker.

Even using a kthread seems flawed, e.g. if all CPUs in the system are being used
to run VMs, then the kernel could be stealing cycles from an arbitrary VM/vCPU to
process RMPOPT.  Contrast that with KVM's NX hugepage recovery thread, which is
spawned in the context of a specific VM so that recovering steady state performance
at the cost of periodically consuming CPU cycles is bound entirely to that VM.

I don't see any performance data in either posted version.  Bluntly, this series
isn't going anywhere without data to guide us.  E.g. comments like this from v1

 : And there is a cost associated with re-enabling the optimizations for all
 : system RAM (even though it runs as a background kernel thread executing RMPOPT
 : on different 1GB regions in parallel and with inline cond_resched()'s),
 : we don't want to run this periodically.

suggest there is meaningful cost associated with the scan.
