Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6691A9FA0;
	Thu, 30 Jul 2026 03:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785382800; cv=none; b=mKowxahRGPfHuF/DG0dz/YLJM3EBkCG+EGxibNkqmvoJBXl4mgYbdJG97e/AqUrdziu3tZF0Z/PUYE9gpPg45fjopVI/sAY67TxY/2Ns614qGbVqKxVsc3nIRXssyvXokM1ugeun8vhJ+J/jDM7iaZ8hXySeZPuCCln9jEAI04E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785382800; c=relaxed/simple;
	bh=pI6dHHb7J0ImYITur1BKCoOjWnnLgWpciKwQLbsDc8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvFTelnsejIzjtE8FU56oz5IVLYnsxHBjOVC8Fagejn+GShFFgowgjkqqnLBE2i/D/I5Ax4MI1xi7Py71sIQmZSAWPLmK2XaWYEvbXMwScON73P/+HJpEOBG+SxeRJpo3yDPGRviavmMldjzW95pecz3qkxzGG0Vlq5gWtLnTdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=B+SpsjD9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="B+SpsjD9"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8DC0B40E0140;
	Thu, 30 Jul 2026 03:39:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4CaphDkmoge7; Thu, 30 Jul 2026 03:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785382785; bh=HCL/bk3E2UobBUGwlMQYN8koub9izSikmLau/bwU66s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+SpsjD9zg8A1QmEKGj3YjxpVKGcVM9I7dPXK9uoC90pmuAoPQbIRSdmcdO/popt5
	 9uNeDo2e1gnf60GQI/WqCpi6BNTPzLd4I281tPN1HYUxAoWhOMH0IV+8MdKdQoycwf
	 OZEdDwYqoNWR4DHPz7ULISnSAZ+XjMR0XgwXT4+IS8vXWuJEnE9qpxn7rBaDGl4WAO
	 xgzpeudfe5zsyv8z9dLr7pA07/BNRhvVwdCV2jVy+YqBoGCGmP/kj0beKrcCl6gr1c
	 4xx5Ho82QLHDp9BqE+zuBy8x9sOwODb3dQg6CLwrpJcCfahn3FFFWKS8fuB5zJGPQI
	 zBTR0UtSX56sUDqS1ovYRV4RN5ub+n3ONNeU1DA+YVrnO5go8moqy327w97pJxB4ba
	 ATCuKI45GRJA2FhQ5f47TzSNJD99nUvgZKvWKw6ydYzNtJoA2MCNlxJvxfP/lMTChX
	 nDKRTkdRLnEJAYGuPuPDwoyOQ1uP2H+Tv06SYwo4oA/N2QjB/sVet5/ZFe9ED7e5wY
	 EpqFMEZueVenV/0KPyaVRqmwjGv6k/ew5q+5Zr8Ozq3vgyTDDuLpRIAqGjcExTQQzL
	 AG5Eah1uEAmmfbE1rNAhW21O0Hzq6WPYs6oi2/PlpZdhET2JB8DwpVd1jJna6C7RWo
	 Zm0FsjyizfQ3oMn4GtGav7v8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9A7D640E014C;
	Thu, 30 Jul 2026 03:39:10 +0000 (UTC)
Date: Wed, 29 Jul 2026 20:39:07 -0700
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
	ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260730033907.GFamrHW3v3dbb0UmFL@fat_crate.local>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
 <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
 <7f837674-786a-42b7-a289-4c048fbec6b8@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f837674-786a-42b7-a289-4c048fbec6b8@amd.com>

On Thu, Jul 30, 2026 at 08:25:37AM +0530, K Prateek Nayak wrote:
> I believe there can be cases where CPUID advertises
> X86_FEATURE_SEGMENTED_RMP but rmf_cfg doesn't set
> MSR_AMD64_SEG_RMP_ENABLED because otherwise checking rmp_cfg in
> addition to the feature bit makes no sense.
> 
> In that case we should attempt a probe_contiguous_rmptable_info() even
> for X86_FEATURE_SEGMENTED_RMP.
> 
> Essentially drop that "else" and do something like:
> 
> bool snp_probe_rmptable_info(void)
> {
> 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
> 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> 
> 		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> 			return probe_segmented_rmptable_info();
> 	}
> 
> 	/*
> 	 * Segmented RMP is either not supported on the platform or
> 	 * is disabled by the firmware. RMPOPT is not not supported
> 	 * without segmented RMP.
> 	 */
> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> 
> 	return probe_contiguous_rmptable_info();
> }

That makes sense.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
