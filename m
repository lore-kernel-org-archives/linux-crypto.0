Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF73C109B;
	Mon, 20 Jul 2026 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784582032; cv=none; b=J7SyhJ1eVWShLzh9NCCzyaO86KuhfrVZqmSSfRtZynBQDfBOD8jxumZV8RblKlRTv4Nb9YG1vVSCtgYlf8wOMUA7s+LAQ2YsBvn6YNNwGAjR1DaIAs3ny8CLbEYbqADjNsr3+Ibhj/dz1fC1IVXoqNAFfibPravp7ksbNdzxJNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784582032; c=relaxed/simple;
	bh=+7EsZQ8MDtE3n+BMw5DQDYJgHwNK5QFlPRkzuS7rRhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuv5Iu2/ekm7tLZoqV7YwqPJr/smyat9xilXPgnHBmCrNVjb7Pn10gWVsNRjsba+TX9kuEuG346+WQq3tlhHSRBJuJRVyZzaFFNNHi0Ie9yN/4aG+xCw71VFFISQtIXp0OXgj8o5EWr20Q5GYxP7KjXvCBNaIMP3PPG3SjWrxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Sb/ukags; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Sb/ukags"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E201F40E00DC;
	Mon, 20 Jul 2026 21:13:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id a5T32fnu6LtK; Mon, 20 Jul 2026 21:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784582018; bh=FGhFoRLhMbDrReFu95uGs+7QWPhZ6jTH09K1AIvqN5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sb/ukagsUyi4GM2q6P/SrsLtdzWGAnGx1Lpl839b9tRGxuJjy7xu0DWWGEUqmgPZv
	 WbAIB+ypFG8f8YTps9VTGwSQM/Nw5ktmDSv4xH4I+hKaBp7wv2sHxHaabQ8DtH4K+D
	 6DzkazqOqnllfs4ohiAkP058hINWeUxFEPeOXacx0wgQLWW2v4CU5qsklXFEGrl+fA
	 VQiPELYB3vlqtovK+p1DL1lKKHRMTeSAvbhyAAktO6yt/XKrDu9gQuMe7wxRhGR4E5
	 2vpRy8jpF7BRRooCmTRBBhanLX/fyo2x5Sgzb/qHrdzxkREa//U3FeGn5z8mlBJN3Z
	 apgHBLr3VWB7wqaQU004rjZysEniKDhQhkxcPwsqra4Ygig0vPS1vCrJnH3P8JZ/tB
	 e/M1lqfx8cuGZxvhZy+Yvlr+UsOubCQDMGV4meiSxf7tRTZcLPTjZJBDgU6g7Zjarn
	 YiNSpInFuNiVX27OnLN812ze9/gX+u2YZlJOwKivxBF+/xyC03LZMjmsVwvTV+DEZs
	 qZwwD8G/3ZLwXQdvYqRADfY8Qrpaa/xU05UBWSq5x/MFUXJoqe/O8HGdVo6Nhu6rQ7
	 XwqNvmaEUOfqTRvQmNywDyBsIYNSprXRknTjPg7Dgho5Q1gtgwmZDnrO9QJDT22p6S
	 HrO8lI6jPlQtjYgKZ7tABZ6Q=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3EC9E40E00E6;
	Mon, 20 Jul 2026 21:13:03 +0000 (UTC)
Date: Mon, 20 Jul 2026 14:12:59 -0700
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
Subject: Re: [PATCH v10 1/6] x86/cpufeatures: Add X86_FEATURE_RMPOPT feature
 flag
Message-ID: <20260720211259.GCal6PW5aCGieR5j3W@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <39e9ee269a572c516a3f4e937bfe12d00697d5e6.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <39e9ee269a572c516a3f4e937bfe12d00697d5e6.1782841284.git.ashish.kalra@amd.com>

On Tue, Jun 30, 2026 at 06:09:44PM +0000, Ashish Kalra wrote:
>  arch/x86/include/asm/cpufeatures.h       | 2 +-
>  arch/x86/kernel/cpu/scattered.c          | 1 +
>  tools/arch/x86/include/asm/cpufeatures.h | 2 +-

Yeah, apparently we don't do the tools/ change anymore:

https://lore.kernel.org/r/0af5122c-20df-4aea-8ab4-cba63f71dc3b@amd.com

Final version:

Author: Ashish Kalra <ashish.kalra@amd.com>
Date:   Tue Jun 30 18:09:44 2026 +0000

    x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
    
    Add a flag indicating whether RMPOPT instruction is supported.
    
    RMPOPT is a new instruction that reduces the performance overhead of RMP
    checks for the hypervisor and non-SNP guests by allowing those checks to be
    skipped when 1-GB memory regions are known to contain no SEV-SNP guest memory.
    
    For more information on the RMPOPT instruction, see the AMD64 RMPOPT
    technical documentation.
    
      [ bp: Zap respective tools/ change. ]
    
    Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
    Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
    Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
    Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
    Reviewed-by: Ackerley Tng <ackerleytng@google.com>
    Link: https://patch.msgid.link/39e9ee269a572c516a3f4e937bfe12d00697d5e6.1782841284.git.ashish.kalra@amd.com

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 3d0940a3b9f3..dbccde9ee5cd 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 /* free: was #define X86_FEATURE_UP	( 3*32+ 9) * "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 937129ce6a96..021c0bf22de2 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -67,6 +67,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
+	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
 	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
 	{ 0, 0, 0, 0, 0 }
 };

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
