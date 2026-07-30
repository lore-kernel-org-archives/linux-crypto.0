Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4C4331EA8;
	Thu, 30 Jul 2026 02:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377277; cv=none; b=uhwuJ7w8/Fp/EJLRiXt97WPoGpjLw4k6pkf+gqEnZHYQWORMhWWaz/Th8SKNLaJcenyTL3Uud7VZEW7Yi4dlnqpLJuOT2syBLdtO29IxdWvf0CzRc4t+w1R3CkLchWTU4H1FcAyWThcP4HjYjA/kDWhX8K8znFQM/15YhzL6zDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377277; c=relaxed/simple;
	bh=aJWHacJpNvkUqy1KV7WGqfpoAAn70AijGwGX5jppvWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCGGatMR35wBfe/csCxzNW3Eluo9SL0elx9PPwXYlimGBZCYGpY1S7VaNhXI0Bn5wkzDLPuJ/1kLxBcnb9hKeKLFlIaHHr/1plKjZWUgrIvwBPrwcxmTq6GYCYIg3hOhoAB0q4IlLkb8LVqjcKg9WUIr8jlV3ty53FG9Yb7Q+rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=edvQoA9q; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="edvQoA9q"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1050F40E0140;
	Thu, 30 Jul 2026 02:07:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9P5pICdlhj1k; Thu, 30 Jul 2026 02:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785377262; bh=LdjofRsXZHIzjHWy175uKs1WFHuqJig3LG4T8Scm7zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edvQoA9qqsGfdD8Jv7VevsrhMsd9pDhHFC/oVJz1228v6mSt4/dBA+sNJu206Dyzr
	 lI5KZs729kwro8WzX/CgeCqOZiv0cIwVgDttHrOElLCNCJo4DWmAUOZuo2NVZDOXPi
	 EZjJFi8Aq0M2MSpCFnLPhfw0a5RtGMW6cRP2G4AI1B5UG91MXbNRxG+IGN120srJeJ
	 VoPkhvDmfKHzbYkCC2fCx5ecHiZY15DfQoRI3trs/PMR0FaC/dUTI4o5zquAnvfkJT
	 ZCzvAXXmidBGHwT8i7qwemF7z3nti3j9f1G39Es12VJDCh2rP6FBRikL9wIwe9wiN3
	 C/vn1ucz93sBEYvgRDER4VBbzpPo8Tp2oPmHmxWq0aYvFSJ7WTmQvZyW7CWDCiAYw8
	 kmmzbANIqFoxNk+UK/DbTVNQL2kuNch0h/d2kefbF1uDISwZynQtqvv58z1RZXGmqW
	 ABL4OG7lsaEbWg+qus9RBftE0xhMj/s6JpmwN4c1Q8kIGgXmpdnLy/kSSdyGRPH8ia
	 rKwgFwoSRTYt2LZfiXdxDBySVc6D/0LDlXP+obhWNTNp4mevkfIz3ewEenWi4ccyzF
	 Gf1FM56mvIgRrHZD7uTroF4X6ohrg6HI25p8QbHVKbeZPC6DbhHkcl4tqSQjyERIW1
	 iXu4Rb8na+G90vz1+T6GOQtM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EDE2B40E014C;
	Thu, 30 Jul 2026 02:07:07 +0000 (UTC)
Date: Wed, 29 Jul 2026 19:07:04 -0700
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
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>

On Mon, Jul 27, 2026 at 07:04:57PM +0000, Ashish Kalra wrote:
> @@ -705,10 +760,12 @@ bool snp_probe_rmptable_info(void)
>  	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
>  		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>  
> -	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>  		return probe_segmented_rmptable_info();
> -	else
> +	} else {
> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);

That looks a bit squirreled away in a probing function. Let's make that a bit
more obvious:

bool snp_probe_rmptable_info(void)
{
        if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
                rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);

                if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
                        return probe_segmented_rmptable_info();
        } else {
                /* RMPOPT is supported only with a segmented RMP table. */
                setup_clear_cpu_cap(X86_FEATURE_RMPOPT);

                return probe_contiguous_rmptable_info();
        }       
}

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ca473ca198b8..c002a7ca26a8 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1477,6 +1477,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  	}
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
> +
> +	snp_setup_rmpopt();

Why is this thing here and not at the end?

SEV-TIO is supposed to always run last or it doesn't matter?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
