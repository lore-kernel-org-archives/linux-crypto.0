Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793666778;
	b=nWVh+xOu3XnwG0C2tT49eR6b8fopBPCv63qL+1nuHnwa1wly/U9ONr1DRrgn88ldzPJi
	 atH2GJUL1fXXtpQG9B0QlHdFwUnFfPxE6J30xEsSEpthYiy9lkhbDGbQM//4xMInmujFt
	 BOoeiqoCgc09PJfPKCiujvb/jXVBwHnWbraFeG8uYR1sdUaZFwgHqKuc0r2ks45zC6gVp
	 G4hQIwc2v9pmkoRmfyc02MdsYSdChylWsrhcgOd4Rgo5+MQN0Gki0NxxVshUL8APm1D34
	 tcm4UrmCM/nBIvDgoMEU6sKldEzokLEGG46DxiiQ+511pvR7fFs6j+sGVBwK6VzPePg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793666778;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=P6zdhMrVQdSbUCSy9T5hCPdt8mnqgszANMMXRfbHvQA=;
	b=aODpd8nr2P00jTMkPvUyjGlfv7At2a9CuS2cpCGFRdl7c2m5f1r8go+z5wpfdrSCLUwj
	 vyy6XHNFk34WTOYxKMUotxBTkp1QGTlCF/XzwX8Xps6G01gUjgoRCp9v0IFMK6PKJePxw
	 ra4wuYTNZRf/zbatYU0KTz5onKGvtK0CGMxS20zpdG2CrHEQyJnuw+EWKvOQW/zFYssn1
	 pDjmVmwbCcNqhlpoOUECpVCECHl9gQOW7VbECbvwhFX/rbDm49gQZTfcaFeiBUvt8J7Ik
	 WTWNE/a879jdugmic7T2vIc5jndijxCBiYWnq/3XtZLJtuidS2CipoFXk5S0+lhxURA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=YEJ91bHe;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488A2606A324;
	Tue,  3 Nov 2026 00:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 488A2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=YEJ91bHe
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E63A540E016C;
	Tue,  3 Nov 2026 00:46:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ugQTfxD5SsTq; Tue,  3 Nov 2026 00:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793666768; bh=P6zdhMrVQdSbUCSy9T5hCPdt8mnqgszANMMXRfbHvQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YEJ91bHecdj53GxAo6rc9mKOeHJzKr4cxQ/09btqC8Pv69LWCP//4j7WgIZOmn3K5
	 VuibwijhSdxkNT4FsCPpJZUBr3OVrcIgy4s3C5j3SajV0S65J+GTXjT7Z+rZgv3h4d
	 6SJKg1+GOc7qAdYnQVAX8bJzUPFRWVweKU5MV1pMjmow5DEEFXZ/o4a+KKVvWF4AZQ
	 Lu6z1KTLP/SG+pnZu1np2Ygabrla7JoSxZcfNivK+q7HUoBgs1rMdtl4wIiit1GgCW
	 +MuyKdoZawSr1KPSfxC4OcPMEyFrp5nyc61N+MUgYi66q+gies9M+9Xt/IXQBEiPh+
	 ep7W9jxmSaEJA7ZfLsHklQHYZ777Pnh/jy/Pp4VO9+qq2aiBCTXktaoNJMjGeRT9VC
	 LE/LnHVx93Uo8IRD/9Q5gTLzqhYXbMsZMj1J+iiS+yw/omF8AMjmh6bJ/r7KZmPNYq
	 UCBjPTvRpAMIl9YnNLSYx4xKXYoH3OfCgvs9NP8VJ+dwlA+ZKJi6kXzOUFOz8t3yp2
	 kON4ympmSoJYojttVZiiuoYS6d2v+wSPsHIsi/XWEnWLB0YnZZ0PnBBrj6LgqELFRo
	 6iVFDv8IJG/lPvFLscRfSJY9pyOSoG/2jRQd5t936hQ6sAK5dfyI6D3n9hFoFIntzO
	 HMEL5UFf4veh4Vnki+VDNPXw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CE2B540E029C;
	Tue,  3 Nov 2026 00:45:34 +0000 (UTC)
Date: Mon, 2 Nov 2026 16:45:31 -0800
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
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
Message-ID: <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
References: <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
 <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
 <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>
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
In-Reply-To: <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>

On Mon, Nov 02, 2026 at 06:07:35PM -0600, Kalra, Ashish wrote:
> LGTM, tested on HW.

Ok, thanks.

This below is what I have now, and the code looks a lot better. If there are
no more complaints and it looks like what you tested, you can wait for me to
push out the two patches and then you can test tip:x86/urgent again.

Thx.

---
From: Ashish Kalra <ashish.kalra@amd.com>
Date: Wed, 28 Oct 2026 19:49:22 +0000
Subject: [PATCH] x86/sev: Clear RMPOPT when segmented RMP is disabled by
 firmware

Segmented RMP support is advertised via X86_FEATURE_SEGMENTED_RMP, and the
firmware enables it via MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED]. The latter can be
cleared in platform BIOS by the user, in which case the system runs in
contiguous RMP setting.

snp_probe_rmptable_info() does not clear X86_FEATURE_RMPOPT in the
advertised-but-firmware-disabled case.

As a result, this does not prevent snp_enable_rmpopt() from trying to program
MSR_AMD64_RMPOPT_BASE, which raises a #GP on the MSR access.

Make sure X86_FEATURE_RMPOPT is cleared in all cases where segmented RMP is
not enabled.

  [ bp:
   - Put the commit message on Ozempic
   - Simplify snp_probe_rmptable_info()
   - Fix feature check order in snp_enable_rmpopt()
   - Add RMPOPT feature dependency on SEV_SNP ]

Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com
---
 arch/x86/kernel/cpu/cpuid-deps.c |  1 +
 arch/x86/virt/svm/sev.c          | 17 +++++------------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 99801e844b30..acbcec394ef1 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -93,6 +93,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
 	{ X86_FEATURE_LASS,			X86_FEATURE_SMAP      },
 	{ X86_FEATURE_INVLPGB,			X86_FEATURE_PCID      },
+	{ X86_FEATURE_RMPOPT,			X86_FEATURE_SEV_SNP   },
 	{}
 };
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd70c4d0b774..417e6a41ac60 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -669,10 +669,10 @@ void snp_enable_rmpopt(void)
 	u64 base;
 	int cpu;
 
-	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 
-	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
 		return;
 
 	if (!rmpopt_soft_init)
@@ -819,18 +819,11 @@ bool snp_probe_rmptable_info(void)
 {
 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
-
-		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-			if (probe_segmented_rmptable_info())
-				return true;
-
-			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
-			return false;
-		}
-	} else {
-		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
+		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
+			return probe_segmented_rmptable_info();
 	}
 
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 	return probe_contiguous_rmptable_info();
 }
 
-- 
2.53.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
