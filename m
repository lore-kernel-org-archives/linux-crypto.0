Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC0D175BF
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jan 2025 01:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738287675; cv=none; b=n1QUys/HVFLJlgg9U+tcEcGhRc/jOZQRJGURVntYMCbfrQtfG67SfUUOTM7ke0w/3xje9QnEI55px35ROwwHaax8VbgE9IPicLTVRb5tFY7WJCUqK5llyvqtNxC7rg8uDOLis5VWh54SRMjijdNDOR67W3zh25NJyHCPyNC0EqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738287675; c=relaxed/simple;
	bh=PJkqOHymjlPcreWPVNFW6mgqayEDHRPycMqEzIP++aQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mxifF5FQT8I5/Mz9/QARODHUbSFzZ2OHvkNyqcIbOhv+TmuI9Xddg1HfFA31D9SNsPXjRMKeQErMgU8kB774d/bt06Ei+T/bjTukLaZgejwCQSC5QMPgC0uQHpschmfAA9gC17cGiH2I/geaZ43xmH7PEHToovEUlVUSYjDvX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n03YoF/5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n03YoF/5"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163dc0f5dbso33058405ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jan 2025 17:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738287673; x=1738892473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NYQ0/21qAo7dn2FATF89mSvc0uDJJhpfPlulG5s+Bw4=;
        b=n03YoF/5IQ9731s1NGS73MGVwM/m+z7hREf5s4bZXpL9vnYoozkgt9MSXrypa0V0l/
         kuxQb3RSmmnnhRFDdje2Uw8WQffBLEqaVNhwvyNHbcLub25jVoPbklsEuOh8LGcSr5mK
         6l32avRCaY0IoeHJ6RUVBh7ZFaCUoPL/ZnHFJzZ8DbMHSRttlVA73rz6LZ7NxrNkAdnA
         zRqBUNbLHifQlkJ9hlPPQdJKhXiepS7oYWTpToj3q7Aw2oaQfTJ8B7HfXvNhkgbGK+Qg
         61/xZDWan0X7mgWdeejnfAFKb9P4IxttD20CamzTfFPoukCys01IcI5/7ivmqZ8eXdJX
         lMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738287673; x=1738892473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NYQ0/21qAo7dn2FATF89mSvc0uDJJhpfPlulG5s+Bw4=;
        b=uCXOHOZDcbvN0h4A5nfHE173/6JRUWzX0e2XtqqxSh+Uu9W1zXkXFjf37bAPt1UQMq
         TKzOPSx1co7UADaKYQ1UCUsNCONgY0Tbl/GIv9YZ99GUQuUjf4xScr2zT8qem5z2NK1f
         /F7Y6r82iVEqwaBRsaoD6ZbGS4CrUBhezEuRsVOosicvm++R32YqTu44KASjqmFuymsP
         Iqa887jKV1j6nJ2gTUh+b7DcHxOnH0pNp+1Qv6Qd7j02W7HysqF9j6RqAHMLZ5KwDnJ0
         QFxGuKlpAAVUWFwz0CcEzXZARfPiI7qQ+bAXDxS4FOdWuWURoVLaFklGbVckfFtXeYlp
         afYg==
X-Forwarded-Encrypted: i=1; AJvYcCXcy5XuhSIIARP2VIByW3Rdr++xF7aMq0lQgfvSGObOumbzo6P5SERmkF01LGEamBg3pBFYiQkQAdR/dco=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTTsiKeo+FK6FG4S2kvKujZimxmnV5sNNDOTy+Z7iqjuJTBdtF
	98T95KKon3kCs3rf3A7DdIrXWRBmlHG4qp+fGuVXDiVLf7WbWGSGnVpldD0IacAX88UytRAUcx5
	pug==
X-Google-Smtp-Source: AGHT+IEw9DSkqrI1773Jjuk5E4MeYPH5lMu6RB/aYag2H1VizlWlMwoXO+4rIqSRzxjHCDQk+HAz2Fbwrgw=
X-Received: from pfbhm21.prod.google.com ([2002:a05:6a00:6715:b0:72f:f507:4aa1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f8f:b0:1e1:94ee:c37a
 with SMTP id adf61e73a8af0-1ed7a5f0642mr14905550637.15.1738287673375; Thu, 30
 Jan 2025 17:41:13 -0800 (PST)
Date: Thu, 30 Jan 2025 17:41:11 -0800
In-Reply-To: <8f73fc5a68f6713ba7ae1cbdbb7418145c4bd190.1738274758.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738274758.git.ashish.kalra@amd.com> <8f73fc5a68f6713ba7ae1cbdbb7418145c4bd190.1738274758.git.ashish.kalra@amd.com>
Message-ID: <Z5wqN5WSCpJ3OB0A@google.com>
Subject: Re: [PATCH v2 3/4] x86/sev: Fix broken SNP support with KVM module built-in
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com, 
	will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com, 
	dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 31, 2025, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> This patch fixes issues with enabling SNP host support and effectively
  ^^^^^^^^^^

> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/virt/svm/sev.c    | 23 +++++++----------------
>  2 files changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 5d9685f92e5c..1581246491b5 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -531,6 +531,7 @@ static inline void __init snp_secure_tsc_init(void) { }
>  
>  #ifdef CONFIG_KVM_AMD_SEV
>  bool snp_probe_rmptable_info(void);
> +int snp_rmptable_init(void);
>  int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
>  void snp_dump_hva_rmpentry(unsigned long address);
>  int psmash(u64 pfn);
> @@ -541,6 +542,7 @@ void kdump_sev_callback(void);
>  void snp_fixup_e820_tables(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
> +static inline int snp_rmptable_init(void) { return -ENOSYS; }
>  static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
>  static inline void snp_dump_hva_rmpentry(unsigned long address) {}
>  static inline int psmash(u64 pfn) { return -ENODEV; }
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 1dcc027ec77e..42e74a5a7d78 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -505,19 +505,19 @@ static bool __init setup_rmptable(void)
>   * described in the SNP_INIT_EX firmware command description in the SNP
>   * firmware ABI spec.
>   */
> -static int __init snp_rmptable_init(void)
> +int __init snp_rmptable_init(void)
>  {
>  	unsigned int i;
>  	u64 val;
>  
> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> -		return 0;
> +	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
> +		return -ENOSYS;
>  
> -	if (!amd_iommu_snp_en)
> -		goto nosnp;
> +	if (WARN_ON_ONCE(!amd_iommu_snp_en))
> +		return -ENOSYS;
>  
>  	if (!setup_rmptable())
> -		goto nosnp;
> +		return -ENOSYS;
>  
>  	/*
>  	 * Check if SEV-SNP is already enabled, this can happen in case of
> @@ -530,7 +530,7 @@ static int __init snp_rmptable_init(void)
>  	/* Zero out the RMP bookkeeping area */
>  	if (!clear_rmptable_bookkeeping()) {
>  		free_rmp_segment_table();
> -		goto nosnp;
> +		return -ENOSYS;
>  	}
>  
>  	/* Zero out the RMP entries */
> @@ -562,17 +562,8 @@ static int __init snp_rmptable_init(void)
>  	crash_kexec_post_notifiers = true;
>  
>  	return 0;
> -
> -nosnp:
> -	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
> -	return -ENOSYS;
>  }
>  
> -/*
> - * This must be called after the IOMMU has been initialized.
> - */
> -device_initcall(snp_rmptable_init);

There's the wee little problem that snp_rmptable_init() is never called as of
this patch.  Dropping the device_initcall() needs to happen in the same patch
that wires up the IOMMU code to invoke snp_rmptable_init().  At a glance, I don't
see anything in this patch that can reasonably go in before the IOMMU change.
