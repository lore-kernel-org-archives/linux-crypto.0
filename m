Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDF954774;
	Wed, 29 Jul 2026 02:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291376; cv=none; b=GX5vhGX7r22NUBntRFPpFA5JXqZmzR6a3gU3uZB30B6xNffxDKGWb3Sth8T5Z5ZF1M/Pvkapb2gp0wvpJtGWjbmdnI50PXNFCrc4TVyD+DRnj5mS0nAG603p/8SLFDvwM9WOlORlACJ0IAA0DNvGvQSbPSA60aTWY8M4Y0CdRNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291376; c=relaxed/simple;
	bh=0JvL2EJkmjxe6MoWdRRwkgeS+DWKuQ4Q0ppQJFfPxxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ye7PmRNayRZSwQ+UIThC6hiIkPS9N4SNOxTlCGTesl/fJH5ejQFWx8jCtO5bfFHleTXlW7h09U2hoAyfOPnDt8kYoCs7eyO80hzBqXC811fELXmOn/aP+zZGYo+erlM/WP0wsQkKozjywlZYfHOuwNXGa2Rc3V57uYssZDMfOy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=B+IJ3BqB; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="B+IJ3BqB"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D8EB140E014C;
	Wed, 29 Jul 2026 02:16:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ekmS4jWMetaX; Wed, 29 Jul 2026 02:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785291360; bh=jYfxf+bhIzET99jS5jMhQB/Sinp36qMgGjtIV02FVKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+IJ3BqBpkgyUnNVfzq01FuEVm9RTlVM2StZKdXSlcRxQGAPZIyaRzfnLNer2oSU6
	 s41IKy9EdZKerJA8veMdwatFlv+kBIeTHHBj+Ul5bWvMAVifZBo5H4zMsW02+oWgXN
	 UP52G5qdTebPn+Q4eHCp9ELAzYK7RX2xUvjvatLwT5iyCBa5ugWSDJbclNfGbjRr+U
	 CyivcJgJdXLXsWa/2gLwhFnyahUpOPvjkmdA33MDR/1Zq9nP/DeRK/oH2WvQvQm2d0
	 bfqZpht/WptGD92ptaMOYhKrPAhHMjWxCYLDijrQD7ccfUyFO4g7uabasRj9cEUo+s
	 iGduwwFLQj6Dwr3nwcPeGw0D4tK4V/7pNsEcEOWsuVWtyy/IPyld/5RNN1n1zkiRTl
	 l5TJP534IWCi/97KhIFK99i0kh+/wZfeaK7GILPCfZ6YjknsX3KEqvOp+ew0EwVuiW
	 qhxf4/eIFi19HcCNvQL8JtGiGpXeNYELh3z4wFTBu4g/VFTEVFootYp832+exzXFTt
	 e+02YfzWz0PszwXocnhbkBj9lphp8GOGSmDyDtxVImHOyQGVFUcjiBSxNnBLk1Mbog
	 3HoLS91l+nTd3u/o9RRpHlrDETLviRw+SlmCB8Oyily0wp8oDJVQHzHwbx33qghaf9
	 /h+g4r0vrfqTLfx45fk09elk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 491CB40E00C4;
	Wed, 29 Jul 2026 02:15:25 +0000 (UTC)
Date: Tue, 28 Jul 2026 19:15:20 -0700
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
Subject: Re: [PATCH v11 2/6] x86/sev: Disable CPU hotplug while SNP is active
Message-ID: <20260729021520.GEamliOMT67p8svCoM@fat_crate.local>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>

On Mon, Jul 27, 2026 at 07:04:31PM +0000, Ashish Kalra wrote:
> With CPU hotplug now disabled while SNP is active, the online CPU mask is
> stable, so the cpus_read_lock() previously taken in snp_prepare() to
> iterate it is redundant.  Drop cpus_read_lock()/cpus_read_unlock() here.
> The RMPOPT setup and cleanup added later are introduced after this patch
> and never take the lock for the same reason.

Why do I even bother writing it?

"do ... not talk about future patches because git history is not always
linear"

> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 39 +++++++++++++++++++++++++++++----------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index cff285d8ad8e..e2f69fba0938 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -513,7 +513,6 @@ static void clear_hsave_pa(void *arg)
>  
>  int snp_prepare(void)
>  {
> -	int ret;
>  	u64 val;
>  
>  	/*
> @@ -526,14 +525,21 @@ int snp_prepare(void)
>  
>  	clear_rmp();
>  
> -	cpus_read_lock();
> +	/*
> +	 * Disable CPU hotplug before enabling SNP: no CPU may come online
> +	 * without SnpEn while SNP is active, and none may go offline during
> +	 * enable.  This keeps cpu_online_mask stable for the check and the
> +	 * on_each_cpu() calls below, so cpus_read_lock() is not needed.  It is
> +	 * re-enabled in snp_shutdown() once the firmware disables SNP.
> +	 */
> +	cpu_hotplug_disable();

No need for too much splainin' and besides, that comment'll grow out-of-whack
sooner than you think:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e2f69fba0938..731ea25fba37 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -528,9 +528,7 @@ int snp_prepare(void)
        /*
         * Disable CPU hotplug before enabling SNP: no CPU may come online
         * without SnpEn while SNP is active, and none may go offline during
-        * enable.  This keeps cpu_online_mask stable for the check and the
-        * on_each_cpu() calls below, so cpus_read_lock() is not needed.  It is
-        * re-enabled in snp_shutdown() once the firmware disables SNP.
+        * enable.
         */
        cpu_hotplug_disable();
 
>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> -		ret = -EOPNOTSUPP;
> +		cpu_hotplug_enable();
>  		pr_warn("SNP init failed: not all CPUs online. (%*pbl online <-> %*pbl present masks).\n",
>  			cpumask_pr_args(cpu_online_mask),
>  			cpumask_pr_args(cpu_present_mask));
> -		goto unlock;
> +		return -EOPNOTSUPP;
>  	}
>  
>  	wbinvd_on_all_cpus();
> @@ -548,12 +554,7 @@ int snp_prepare(void)
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(clear_hsave_pa, NULL, 1);
>  
> -	ret = 0;
> -
> -unlock:
> -	cpus_read_unlock();
> -
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  
> @@ -565,6 +566,13 @@ void snp_shutdown(void)
>  	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
>  		return;
>  
> +	/*
> +	 * The firmware has disabled SNP (SnpEn is clear), so re-enable CPU
> +	 * hotplug.  A legacy SNP shutdown returns above with SnpEn still set and
> +	 * leaves hotplug disabled.
> +	 */
> +	cpu_hotplug_enable();

What happens if CPUs get offlined here after hotplug has been enabled and...

>  	clear_rmp();
>  	on_each_cpu(mfd_reconfigure, NULL, 1);

... they miss the mfd_reconfigure()?

>  }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
