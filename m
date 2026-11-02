Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655867;
	b=EgwhfMDlUc1ZevDPLbwcx/IBwJH0j7+/D4IeQMS+fgQe/foI6UejILBLimLqlm1HBqc4
	 7Wp1+WGluIxn/NYnzuagcjNE03QHLbRWeYsYxU0+gDkrCN21nHWYOoPHr7Tyr8YaN9KXJ
	 yr3Vv4H2PfOs2HrPHqdbl592jIwjghYtgAsy3Obi36BT/fXLaIAWc7k5uRs+tLz/IJoka
	 0/5BBNO5/ksMOHLl50iBVpW9X5uhK7KRe2/z4RPf82Nrs9jYQa6fclFt/FRZkLk5efccp
	 zVTXLwEKyvz0yuCBxifXbXR/IPKAuSL+dNADbPAiOJlnvQX9Ki82uwyUNZgSRci9Tbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655867;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8LwaGdg7RwUBZWnjbInLOk57APMksseRMn6oeVjapqU=;
	b=RQfo1cNRchoY+3haQMIbpGAtGVQzv3Wro7DIxVPijdmO5aqo2PHx/LvoZyE5E8QWfA3Y
	 pPtJ7JdLKgLH3//QLnyduZVJxd0aLpwlqlcqabbf36ObfdSFWRzrqcmxDhk+PLje9Caar
	 1OfgktNDl+YXdkjwSpp3c1SoWEHaciBUsV7ci43s0TTmi8Xrh63nQWk6d+Xyu1Kk0Tq9J
	 BB7zNbXRf+2UPsbNucX0Q3Z+Nyl+7ff+uDTF+MvO7x/fVgnoAM0OmorDL3pEY/H2JkIDn
	 57inSWm+rk6lLUoE+RBjzSRd3poTFswet+CucdFp4o5lO5ZP/sqtcSxOisksmKaYxtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=DltHQtUc;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D579606A327;
	Mon,  2 Nov 2026 21:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D579606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=DltHQtUc
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 77EF540E03BE;
	Mon,  2 Nov 2026 21:44:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ermrslpUmAUc; Mon,  2 Nov 2026 21:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793655860; bh=8LwaGdg7RwUBZWnjbInLOk57APMksseRMn6oeVjapqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DltHQtUcMKhieSAMZ9GNGWLLe+ceAQl2CR/l0lwB/N8RmbhG4cMIevibXafga1LVO
	 YtKO1KmU/x/awS1D1euInXQYe6fHkRqzCtr6JolWfSM7xcxz+aQcA6S6HLQNk4jazo
	 8nl+Ej2ozRbMJoIjN7MIyQivlAJG6o5J7d+P9AhhudOZtVb8hfKLGWBV/004zt0UBO
	 3KMZi0baRawFIj2Fo1RN59Lenfd/gFZbexjmaarOQJSKD0H8rloX5gnB7xrYL0ocfW
	 qt4Cy3G1SR728Fm1Gbktn8/ueSOCPBi7TU9qpAugGqmt6fihHYOwf7H0xjB2Fi9eD3
	 vgFs1MiofzC8IlMHrOm1BvMpi931assWz2sTMgGWqkYN7XgKCe7102//8cdgsmqVk4
	 0PRUDF/0bKyk4f8ciw3pEVMv+MoYIC+18SFhVofr1to6ljb7hIEIv3b415Eqzp0WNH
	 20s92Ebk7b0O9IPFObmgacdLQrZoPv+AqtyGFb8CYSm/1rOHAaIAH4jmsFQG3JN9ZT
	 3LekmPU3UnUw288BXKxK90k46hibrhqsj0SOPnYjknrHQ/Btr9LKOQ12t5tecDP0c9
	 f9giWKbiN1ebgyO6nVX5xs1XltlhnSERr0ttmO4Zc6MbJZH1CM8km2L7Bc2YPUeqzc
	 QIupW72xXbg57n+izonv14k8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5B04A40E0299;
	Mon,  2 Nov 2026 21:43:46 +0000 (UTC)
Date: Mon, 2 Nov 2026 13:43:43 -0800
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Kalra, Ashish" <ashish.kalra@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
	ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
Message-ID: <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>

On Mon, Nov 02, 2026 at 03:25:52PM -0600, Tom Lendacky wrote:
> The current code clears X86_FEATURE_RMPOPT when
> probe_segmented_rmptable_info() fails. The above code doesn't.

See the hunk in cpuid-deps.c

> But since SNP will be disabled on failure of snp_probe_rmptable_info(),
> I guess it doesn't matter. In which case you can eliminate the goto by
> doing:

> 
> 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
> 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
> 		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> 			return probe_segmented_rmptable_info();
> 	}
> 
> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> 	return probe_contiguous_rmptable_info();
> 
> Which looks pretty clean.

Yap.

> > diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
> > index 99801e844b30..acbcec394ef1 100644
> > --- a/arch/x86/kernel/cpu/cpuid-deps.c
> > +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> > @@ -93,6 +93,7 @@ static const struct cpuid_dep cpuid_deps[] = {
> >  	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
> >  	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
> >  	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
> > +	{ X86_FEATURE_RMPOPT,			X86_FEATURE_SEV_SNP   },

This hunk.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
