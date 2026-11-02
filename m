Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793647920;
	b=DjpwVmViMtqri6XlPC4ESwDfZBHsl7UVOTKE4pfdjKlG2e4SRVGv9EFUiyQBqvOGnPnV
	 0xHDB21dEWY5qaBtHGbRQt0hPM7ZuVjBNiwSB8vDDGuUL0T46J0D7uS9hKen48cZRr4vt
	 +8pm9OEspiyiGZ7gNpNLd/OsiftxkdG7IIcVdl77eB/O1T6GOVpdMh2VKpvCSgl5wYs8+
	 coNKqny6uvMVwuvGIiMPwAAnUwAM51oIO16itC95eIhw0OfEmuuzArJRogx/EEBeSU2wZ
	 HoxX/Xqr6cLGrTec8L+nKk2xn0nzK+PUoT4YKQeXHN93/q6130ldD0kXtWGUF74hivA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793647920;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=BLgevGX1q+auGESh9n3YDJNIkeEojVfypPgZIJKlG3k=;
	b=RlEcH2/sjUq62SAX3Og414ZueZ1hMZg2KNP9r7kZ7ueY60Ak95LPx7kTHw++g9y6+Ryo
	 1OKU/4rpRxSVKKHu2JJGNrowH1jNtsBbWBEG7ZTF+FWfkB11KuC4faRAjgKA5qNKU6xCZ
	 RLBC4pW+VFLjm5b6I3R1z80YwcsU0Zd+IcnTzdkIZnaQkdPrCeAEzhSweLtItIbgr+ESS
	 z1/S1Lgfc9DFQaYLLOll4rnX/kOY67QuFbgnjvU3ZOd5NrJ7xSRvDjQUL/zt9ZfTlwH7x
	 pJgruRewoW8IXb6e79yMCQttP5XjB55NQh3z6l4Jzj7n3mNNSikxFko6G3gWRmYaEIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=k+iERTue;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B4B606A326;
	Mon,  2 Nov 2026 19:31:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62B4B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=k+iERTue
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DEE7140E0299;
	Mon,  2 Nov 2026 19:31:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NnH_WaKQhgPd; Mon,  2 Nov 2026 19:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793647913; bh=BLgevGX1q+auGESh9n3YDJNIkeEojVfypPgZIJKlG3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k+iERTuezNChosvpE6Tro6AzfEppIDTaK9I7Bt0WkKZbzbFb2YIvHaTVoIgMOO+9w
	 QM1pMwaKyYhiyWux4bc0GhyMHH/L8spM3SX3ROHELtPxuhK/b2A33V+fdhiBN5iLEp
	 nNdpwkDk4INveJsG9lYLAz6kkzASl9yjp/TCwN6ny60FBRk++q3212SYg4VLn09C0o
	 I4U5lKQjT9tUvgdrXKaalm1LtP6r+3rdMqccWwicytNaYTc3XDd9R/cxFwDaxXMUWj
	 h5KkWk8UeWcEYI+vKfTG9FAqnYNx+TAhP+F+f9wjNL6997tynHAltVRXzAxnKMA6rP
	 /XaRXx418trKRvodmziy7ImUc3ZQ8jg9fO5afgXegUZzGYk2S+KxpZZldoA73sSjrc
	 tfXCnlN4A5RgXW1gtZsRD9OxvLOJmb7ivFHZuwvr1itR84KieEEtBMjKmaKnj+n2fM
	 vHNMRC7M5h/jNdNADSGtw1HeX52uVXOzd/3jikQ0jE/nAwkA4dxVPXBzAJvImUXZY6
	 fr51FZ3/Z0GWgkNgOZribEoNjgfiONNTAlcbwAB+59hTHmc6ZKqpFZrs6/h9SpfkSo
	 3AwOCNIBgjsQCfgJSSNPY4v7wpiuPk7rDwX2Nkm7tXSYKxVoDNYXF082r8sxQUNATj
	 8q6gjyfffkLU4Z+FsMivwCMY=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D634F40E016C;
	Mon,  2 Nov 2026 19:31:19 +0000 (UTC)
Date: Mon, 2 Nov 2026 11:31:16 -0800
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
Message-ID: <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
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
In-Reply-To: <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>

On Mon, Nov 02, 2026 at 09:50:32AM -0600, Kalra, Ashish wrote:
> The original patch returns false if segmented RMP is enabled but
> probe_segmented_rmptable_info() fails, your version falls through to
> probe_contiguous_rmptable_info() instead. 
> 
> I believe it makes sense to keep the return false there: on a
> segmented RMP enabled platform the RMP is segmented, not contiguous, so the
> contiguous probe shouldn't run.

That simplifies the code even more:

bool snp_probe_rmptable_info(void)
{
        if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
                goto out;

        rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
        if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
                return probe_segmented_rmptable_info();

out:
        setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
        return probe_contiguous_rmptable_info();
}

Along with the below, which should have happened too:

1. RMPOPT depends on SEV_SNP, ofc. This would make sure RMPOPT is cleared
   everytime SNP is cleared, as it should be.

2. snp_enable_rmpopt() needs to check SNP first, ofc, and then RMPOPT.

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
index ff6d17795054..a47b812b2ea3 100644
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

---

here's the full diff. Have a look pls and let me know what else I am missing:

---

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
index bd70c4d0b774..a47b812b2ea3 100644
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
@@ -817,20 +817,15 @@ static bool probe_segmented_rmptable_info(void)
 
 bool snp_probe_rmptable_info(void)
 {
-	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
-		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
-
-		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
-			if (probe_segmented_rmptable_info())
-				return true;
+	if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
+		goto out;
 
-			setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
-			return false;
-		}
-	} else {
-		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
-	}
+	rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
+	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
+		return probe_segmented_rmptable_info();
 
+out:
+	setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 	return probe_contiguous_rmptable_info();
 }

---

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
