Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7966640855;
	Sat, 21 Mar 2026 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774112771; cv=none; b=BcwvfutpAOpHYxNcThmk8viao6qau0uk6txvMWThT/Mnh77YT/k94C7OSaEuUR3MAOu/ZwGGLze09dRtd/wv/iEkmBF+mip0A4JVnwuweeRiQ9CK3J/A0OtzXEde81s7Zrg0VsgR/UkLuuKhPzz3kUMVjYa/44bzTZlV/GUt4FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774112771; c=relaxed/simple;
	bh=/u2pJ33UUXWQaWc9aFsrUj2SLeNM0seY83AvjYj7qyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyjTMHVXouBfBAU1nEeOR4bto3e4PVjs/EFHwiYVE8a1k9PR/3J7+bsRIe/To6/fVEDIGVU+PdmEt0YjldaBFvTtiUY9DecevjQBdZRsGXvWgYOYRa+ojrxzq+lecB4j5mX5q1/FTJ1hoL4wLo/kCmv+4+o4bA1thS4nPSoOGEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kjFbhBcF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kjFbhBcF"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E078340E01A9;
	Sat, 21 Mar 2026 17:06:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JF03b8QyHV3o; Sat, 21 Mar 2026 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774112762; bh=GZddL1saGHy396VQDmuPf1y2uIozgn39JLE7MlcmNUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kjFbhBcF6mGV49QRjyKkBzFtkPIvT0vSxLWFZWGP7G/JMFYPFJpcaIFpZIsruAQKL
	 g9KSu+kBOiSIXsjemofZA2P190DotDAIKINCIld+aBmgnNKL8wnYAiPeHctezGZ2Zx
	 RwTPQZQOPVK56b1ZI8Bppq5kyt0qSOI/AWunLgV2W1fW0LTBD/VUDVptXU0twbOsPS
	 hw3XHkPitkwqPgY2VNay2oB4AjwfJSceKB6FGg2IVkAokFY2VAcdIW8wkUKpvvLGxe
	 7FUSra8CkxWGAcBnO6P0WtCWER3sF+uw+CwSd2j0ax+2/2tK93MIwWD4pQtUhxSG7a
	 GZEmt/kimOhBA3ZgwZCQrbMPIWmnVq703fUNQ4Vm4elXrrg6pS/XzlcZOxXR09JrHu
	 FYHricdeEJarcZBfPmvlL8mIxr9kdE3GxikcLkZaC0WPwQ3DPPENE4OhJjYKSCZ59v
	 Mr4tGgZzw8fbvjwJWxyOpI7rIOCggPG6vZabM9FHd0+/1/qLHNtaH2oareWOQSG91F
	 0N2ckDRQXQWkFfV20aasRB9hyFF3T2oGa+u3fUrPXclxkw0RJebpi88OTd9W8f3600
	 qMVI/14Cv3JDjNTqmIPRJ5lo0KSagkvokIeXFqW+lCOmD20lRtsVw6tkHwSDPYnGWw
	 9K1dQWHmVP7SORneAQD9n3Lc=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 496BF40E019D;
	Sat, 21 Mar 2026 17:05:41 +0000 (UTC)
Date: Sat, 21 Mar 2026 18:05:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/7] x86/snp: create snp_x86_shutdown()
Message-ID: <20260321170534.GBab7P3t0jJsRmPUE3@fat_crate.local>
References: <20260317162157.150842-1-tycho@kernel.org>
 <20260317162157.150842-4-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317162157.150842-4-tycho@kernel.org>

On Tue, Mar 17, 2026 at 10:21:53AM -0600, Tycho Andersen wrote:
> Subject: Re: [PATCH v3 3/7] x86/snp: create snp_x86_shutdown()

"x86/sev: ..."

The tip tree preferred format for patch subject prefixes is
'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
'genirq/core:'. Please do not use file names or complete file paths as
prefix. 'git log path/to/file' should give you a reasonable hint in most
cases.

The condensed patch description in the subject line should start with a
uppercase letter and should be written in imperative tone.

Check your whole set pls.

> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> After SNP_SHUTDOWN, two architecture-level things should be done:

"architecture-level things"?

> 1. clear the RMP table
> 2. disable MFDM to prevent the FW_WARN in k8_check_syscfg_dram_mod_en() in
>    the event of a kexec
> 
> Create and export to the CCP driver a function that does them.
> 
> Also change the MFDM helper to allow for disabling the bit, since the SNP
> x86 shutdown path needs to disable MFDM. The comment for
> k8_check_syscfg_dram_mod_en() notes, the "BIOS" is supposed clear it, or
> the kernel in the case of module unload and shutdown followed by kexec.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/virt/svm/sev.c    | 23 ++++++++++++++++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)

...

> @@ -521,12 +524,26 @@ void snp_prepare_for_snp_init(void)
>  	 * MtrrFixDramModEn is not shared between threads on a core,
>  	 * therefore it must be set on all CPUs prior to enabling SNP.
>  	 */
> -	on_each_cpu(mfd_enable, NULL, 1);
> +	on_each_cpu(mfd_reconfigure, (void *)1, 1);
				     ^^^^^^^^^
ew.

>  	on_each_cpu(snp_enable, NULL, 1);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
>  
> +void snp_x86_shutdown(void)

"snp" and "x86" prefixes?

> +{
> +	u64 syscfg;
> +
> +	rdmsrq(MSR_AMD64_SYSCFG, syscfg);
> +

^ Superfluous newline.

> +	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
> +		return;
> +
> +	clear_rmp();
> +	on_each_cpu(mfd_reconfigure, 0, 1);

s/0/NULL/

> +}
> +EXPORT_SYMBOL_FOR_MODULES(snp_x86_shutdown, "ccp");
> +
>  /*
>   * Do the necessary preparations which are verified by the firmware as
>   * described in the SNP_INIT_EX firmware command description in the SNP
> -- 
> 2.53.0
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
