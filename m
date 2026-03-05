Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC43783A2;
	Thu,  5 Mar 2026 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772715480; cv=none; b=lna8EKOlS+HAbo6fUUHAN2Dm380BTcsNxaghq8JRda10UWF6kqNuWXLQuRh4vA5PlEAaZuH7IoaV52HtP2t708LPYn5dReiFykP0iqQud2N6EMc5H0TYn7Ed9ppWu/7hCqsfndWdXXTdfFJ0HMcmb5khk68Cy7qSz6i7IQYPy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772715480; c=relaxed/simple;
	bh=WQ2Njdb/9oWIlEsZz3Ln1HrmbcOjmXQvor8UjtaGW+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeyLtQ5KD37qpCbKYz18AUZonLI6uIl4gXLU5kuSeuOJrthRK4wCKPuE5efbc8kw5DgDNlbpvDKcTnO98JdHw/KIJO6RVha8x6ekI490miKxBjcentfD7kkdFGStx2g41E9LvOQhg87stLrpSpZmcCHKlcosqytYJ76MCOCCnPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=NDo2SBk7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NDo2SBk7"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8404840E019B;
	Thu,  5 Mar 2026 12:57:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Fa_n2Uo796sR; Thu,  5 Mar 2026 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772715473; bh=VnZZM+inE6N+Di4JQJ/Nelhp+G+JJVKjw05A5KPh4vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NDo2SBk7xBQBqVnIrbeJa6vVZq7x5ftZHar4+uyBUsDXoMi6Whb4L/gRlcU1bWkGJ
	 Sud8gmPoYOvFmrjXKg2o+gE3CvQNMWskwu2KPtQONWoHjbk6PNpoLE551iNFK3vvEi
	 qR1nEhZMDal6hb8o0aMOD0cTG6LPk2LlFQbOCGRBZK8kMEqJizrq+7vwyXO8rtVSc9
	 zqJvy1GW8M+c5A5/5Mvb8bDleeTCD8/3w5cDVq8tr5eL+2+/RfNUmB4HGLEDi4THtB
	 KIBTYWqgP8gnoL6DBuLvi8j8Xm73l7XRm5FtDHF9JhyGYdNLr6W3uvIROSykTvbu4u
	 e4KQjXWGX5vT9G2+tzM3cU6jzv3J8rcI2YFnP21uUHQ3lSsaDO3Qsod/IyCXky/us8
	 nGm22WNeeMvgUWmpdvCIX2A3mk5/rLH5PfNFYaV3+PdFQ/7DcVJVFxnfApRZ14D1gK
	 Ev2oCSn2AkyzmNjzDKd5yPAh4cehbvnUg6gY/94Sh/Et/vOZZxDengbTX41HrcDLBa
	 5iAb5Z700WRu4SPAQI71cBVvOWsOliPo91X/Mcupdf5JBiiLP4HmQVzzDmzPAHjvnN
	 ciq2NnxnkeyZOuHx0AREBlZM8TR87g04WPQk+ib8TMTzZ4ljxoc1HZ33/+YFuee2su
	 qPrqCQ2ivOJvTKCUfhZoBLac=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id E440A40E0198;
	Thu,  5 Mar 2026 12:57:31 +0000 (UTC)
Date: Thu, 5 Mar 2026 13:57:25 +0100
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
Subject: Re: [PATCH 01/11] x86/snp: drop support for SNP hotplug
Message-ID: <20260305125725.GGaal9tdytn8gOpiEO@fat_crate.local>
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-2-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260302191334.937981-2-tycho@kernel.org>

On Mon, Mar 02, 2026 at 12:13:24PM -0700, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> During an SNP_INIT(_EX), the SEV firmware checks that all CPUs have SNPEn

Please write those in a human-readable form - not as code in text. Commit
messages are still predominantly read by humans.

:)

> set, and fails if they do not. As such, it does not make sense to have
> offline CPUs: the firmware will fail initialization because of the offlined
> ones that the kernel did not initialize.
> 
> Futher, there is a bug: SNP_INIT(_EX) require MFDM to be set in addition to
> SNPEn which the previous hotplug code did not do. Since
> k8_check_syscfg_dram_mod_en() enforces this be cleared, hotplug wouldn't
> work.
> 
> Drop the hotplug code. Collapse the __{mfd,snp}__enable() wrappers into
> their non-__ versions, since the cpu number argument is no longer needed.

Please, do not talk about *what* the patch is doing in the commit message
- that should be obvious from the diff itself. Rather, concentrate on the
*why* it needs to be done and why your patch exists.

> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/virt/svm/sev.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index a4f3a364fb65..1446011c6337 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -130,33 +130,26 @@ static unsigned long snp_nr_leaked_pages;
>  #undef pr_fmt
>  #define pr_fmt(fmt)	"SEV-SNP: " fmt
>  
> -static int __mfd_enable(unsigned int cpu)
> +static __init void mfd_enable(void *arg)
>  {
>  	u64 val;
>  
>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> -		return 0;
> +		return;
>  
>  	rdmsrq(MSR_AMD64_SYSCFG, val);
>  
>  	val |= MSR_AMD64_SYSCFG_MFDM;
>  
>  	wrmsrq(MSR_AMD64_SYSCFG, val);
> -
> -	return 0;
>  }

While at it:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 1446011c6337..f404c609582c 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -132,16 +132,10 @@ static unsigned long snp_nr_leaked_pages;
 
 static __init void mfd_enable(void *arg)
 {
-	u64 val;
-
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 
-	rdmsrq(MSR_AMD64_SYSCFG, val);
-
-	val |= MSR_AMD64_SYSCFG_MFDM;
-
-	wrmsrq(MSR_AMD64_SYSCFG, val);
+	msr_set_bit(MSR_AMD64_SYSCFG, MSR_AMD64_SYSCFG_MFDM_BIT);
 }
 
 static __init void snp_enable(void *arg)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
