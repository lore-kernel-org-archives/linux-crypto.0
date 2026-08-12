Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B970B29D294;
	Wed, 12 Aug 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786556935; cv=none; b=qt+ML0dqajXZvjwq1z0KF3FDDRZUDDUHeaJ+32bFiqI5JG+bDK3anno2UZD43mz6DmqaaRWIljv6toHh1jUwmNxmWGGaasdafMedQnX+cIEeWvEP7LLmiMXFvY4s+4HARUzxGi3O1+wZcx5g+zo1xhwNfpe05dGZiOUL0STtA7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786556935; c=relaxed/simple;
	bh=dGtJwDiCVav+3RKlsrTeyCjiRD3PJS3iJmYH8KIXFGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNV9bdKvifJ2Nwhy/Wzncfr8ErnoquS1ZxWXYlZKJ4wsstoeYR3KTiAK3QnTEPFHTIU9ja3QDU3M3Mdub43YASKJuPyt9KPOXx78wk4igN3P9hLL3wSiNown0PPXK8FP31w0ECyRdFEDMoJDvzH/psW46FPN8Juk3TVb07Dm6n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cVEMR4aG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cVEMR4aG"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3CEA240E019E;
	Wed, 12 Aug 2026 17:48:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FULEREqZXMOD; Wed, 12 Aug 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786556918; bh=U48iOVl2y8YHea7dTmsTayTNpKejzYbM9D3lEZvcH8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cVEMR4aG/GixXaFyaMNYCrcxpMpYYnYAbSOkWzbX1UgF5kuAlKnfx+qn9eYFAziRC
	 LfCpElyPW0KWg1aiND2L1PSAqDudJdiZ4EB0oic0Xnq8g7mhJfFAw+jJenvvVE7EVZ
	 rAYjtCLhrv2ZZ4M2a9ZRRxkI0tZvwJ5X/g27QydKHlsWcBY46llYfqeNsDD2V8SPfd
	 1Sjy2f+V5fSbeDCsyNqMehy/5d+5r1ONtfuPH5GgSbCcob/vY7sEWGLwn5nm/62bTx
	 U5Tj4ERMhB8MGMuhEDeeP7J1ClmT2wRRITKrXwGl5Y0g4kI+B8LPZdk26l96zDuIjC
	 1UqupJLacnCyf5DbekHZ3IrxIf5KRZ1sqTOvMirrEaAlDe6iWc5l5Ui463G8O0EHfc
	 n8peQp80ahNS6QeKzDKgQF1BJlw/UrO6w1SFyNRcKdWSjShxuh3tZRG5O1OHlYQ8zV
	 9NXbgFVdFxG/9/M/YfmsDpy1ZvKV7gdzcno62fOOVLooPTKjVOcxeI4c4Ktu1uZVM0
	 NeZhpS24vswDl+cjdO4nnXdifsXBYbM3ZoAIDFLTDfrW2vmwNXqlW75nNBGx47AXdX
	 dAYuS1yBcJBG8F/ZhuJc8RcZvv7RI2bTE5g3R6BDfQUsQSbpEnX06ldYlJdXiJi7PT
	 Do0aHmmVsYAJnS/qJhe8cp2c=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9544A40E014A;
	Wed, 12 Aug 2026 17:48:29 +0000 (UTC)
Date: Wed, 12 Aug 2026 10:48:26 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260812174826.GAanyx6vUWv5GLX2AZ@fat_crate.local>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
 <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
 <20260728183447.GB3355536@google.com>
 <20260728225936.GBamk0WK38PByPFkxz@fat_crate.local>
 <20260728233430.GA3277@quark>
 <20260728234726.GCamk_jnl3LtfGbxoC@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728234726.GCamk_jnl3LtfGbxoC@fat_crate.local>

On Tue, Jul 28, 2026 at 04:47:26PM -0700, Borislav Petkov wrote:
> On Tue, Jul 28, 2026 at 04:34:30PM -0700, Eric Biggers wrote:
> > I don't know what your suggestion is.  Are you still asking for the
> > function to be renamed to clear_cpu_caps_xft()?  Note that the
> > abbreviation "xft" doesn't appear anywhere else in arch/x86/.  Maybe you
> > want the argument inverted?  I don't know what you want, sorry.
> 
> That's fine - I'll take a look at the final version after having gone through
> the whole pile and then holler if I still see a need.

Ok, here's something ontop of yours. It is tested only in a guest but it
should show the intention.

The first call in:

	if (!boot_cpu_has(X86_FEATURE_FPU)) {

is not needed because that is caught earlier:

[    0.553199] x86/fpu: Giving up, no FPU found and no math emulation present

and we stop there.

The second one can then simply do:

                /* Disable all dependent flags too */
                setup_clear_cpu_cap(X86_FEATURE_XSAVE);

because that'll clear all dependent flags and we should be good there:

[    0.560698] do_clear_cpu_cap: clearing 10:0 (xsaveopt)
[    0.561697] do_clear_cpu_cap: clearing 10:1 (xsavec)
[    0.562697] do_clear_cpu_cap: clearing 10:3 (xsaves)
[    0.563697] do_clear_cpu_cap: clearing 4:28 (avx)
[    0.564697] do_clear_cpu_cap: clearing 16:3 (pku)
[    0.565697] do_clear_cpu_cap: clearing 9:14 (mpx)
[    0.566697] do_clear_cpu_cap: clearing 10:2 (xgetbv1)
[    0.567697] do_clear_cpu_cap: clearing 21:9 ((null))
[    0.568698] do_clear_cpu_cap: clearing 12:4 (avx_vnni)
[    0.569697] do_clear_cpu_cap: clearing 4:12 (fma)
[    0.570697] do_clear_cpu_cap: clearing 16:9 (vaes)
[    0.571697] do_clear_cpu_cap: clearing 16:10 (vpclmulqdq)
[    0.572697] do_clear_cpu_cap: clearing 9:5 (avx2)
[    0.573697] do_clear_cpu_cap: clearing 9:16 (avx512f)
[    0.574697] do_clear_cpu_cap: clearing 9:21 (avx512ifma)
[    0.575698] do_clear_cpu_cap: clearing 9:26 (avx512pf)
[    0.576697] do_clear_cpu_cap: clearing 9:27 (avx512er)
[    0.577697] do_clear_cpu_cap: clearing 9:28 (avx512cd)
[    0.578697] do_clear_cpu_cap: clearing 9:17 (avx512dq)
[    0.579697] do_clear_cpu_cap: clearing 9:30 (avx512bw)
[    0.580697] do_clear_cpu_cap: clearing 9:31 (avx512vl)
[    0.581697] do_clear_cpu_cap: clearing 16:1 (avx512vbmi)
[    0.582697] do_clear_cpu_cap: clearing 16:6 (avx512_vbmi2)
[    0.583697] do_clear_cpu_cap: clearing 16:11 (avx512_vnni)
[    0.584697] do_clear_cpu_cap: clearing 16:12 (avx512_bitalg)
[    0.585697] do_clear_cpu_cap: clearing 18:2 (avx512_4vnniw)
[    0.586697] do_clear_cpu_cap: clearing 18:3 (avx512_4fmaps)
[    0.587697] do_clear_cpu_cap: clearing 16:14 (avx512_vpopcntdq)
[    0.588698] do_clear_cpu_cap: clearing 18:8 (avx512_vp2intersect)
[    0.589698] do_clear_cpu_cap: clearing 12:5 (avx512_bf16)
[    0.590697] do_clear_cpu_cap: clearing 18:23 (avx512_fp16)
[    0.592697] do_clear_cpu_cap: clearing 16:29 (enqcmd)
[    0.593697] do_clear_cpu_cap: clearing 10:4 ((null))
[    0.594697] do_clear_cpu_cap: clearing 18:24 (amx_tile)
[    0.595697] do_clear_cpu_cap: clearing 12:21 ((null))
[    0.596697] do_clear_cpu_cap: clearing 18:22 (amx_bf16)
[    0.597697] do_clear_cpu_cap: clearing 18:25 (amx_int8)
[    0.598697] do_clear_cpu_cap: clearing 16:7 ((null))

and then the rest is streamlined into fpu__init_system_xstate() where all
sanity checking should be performed, as I mentioned intially.

Full diff ontop:

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 99801e844b30..96c43ec164f7 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -142,6 +142,8 @@ static void do_clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 				continue;
 
 			changed = true;
+			pr_info("%s: clearing %d:%d (%s)\n",
+				__func__, d->feature >> 5, d->feature & 31, x86_cap_flags[d->feature]);
 			clear_feature(c, d->feature);
 		}
 	} while (changed);
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 3c185b2828c7..406ae0841b5f 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -761,23 +761,6 @@ static u64 __init guest_default_mask(void)
 	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
 }
 
-/* Clear any X86_FEATURE_* used by the kernel whose xfeatures are missing. */
-static void __init clear_cpu_caps_with_missing_xfeatures(u64 xfeatures)
-{
-	u64 mask;
-
-	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM;
-	if (boot_cpu_has(X86_FEATURE_AVX) && (xfeatures & mask) != mask) {
-		pr_err("x86/fpu: Disabling AVX support due to missing xstate features\n");
-		setup_clear_cpu_cap(X86_FEATURE_AVX);
-	}
-	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512;
-	if (boot_cpu_has(X86_FEATURE_AVX512F) && (xfeatures & mask) != mask) {
-		pr_err("x86/fpu: Disabling AVX-512 support due to missing xstate features\n");
-		setup_clear_cpu_cap(X86_FEATURE_AVX512F);
-	}
-}
-
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
@@ -785,20 +768,20 @@ static void __init clear_cpu_caps_with_missing_xfeatures(u64 xfeatures)
 void __init fpu__init_system_xstate(unsigned int legacy_size)
 {
 	unsigned int eax, ebx, ecx, edx;
-	u64 xfeatures;
+	u64 xfeatures, mask;
 	int err;
 	int i;
 
 	if (!boot_cpu_has(X86_FEATURE_FPU)) {
 		pr_info("x86/fpu: No FPU detected\n");
-		clear_cpu_caps_with_missing_xfeatures(0);
 		return;
 	}
 
 	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
 		pr_info("x86/fpu: x87 FPU will use %s\n",
 			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
-		clear_cpu_caps_with_missing_xfeatures(0);
+		/* Disable all dependent flags too */
+		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 		return;
 	}
 
@@ -814,7 +797,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	cpuid_count(CPUID_LEAF_XSTATE, 1, &eax, &ebx, &ecx, &edx);
 	fpu_kernel_cfg.max_features |= ecx + ((u64)edx << 32);
 
-	if ((fpu_kernel_cfg.max_features & XFEATURE_MASK_FPSSE) != XFEATURE_MASK_FPSSE) {
+	mask = XFEATURE_MASK_FPSSE;
+	if ((fpu_kernel_cfg.max_features & mask) != mask) {
 		/*
 		 * This indicates that something really unexpected happened
 		 * with the enumeration.  Disable XSAVE and try to continue
@@ -825,6 +809,22 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 		goto out_disable;
 	}
 
+	mask |= XFEATURE_MASK_YMM;
+	if (boot_cpu_has(X86_FEATURE_AVX)) {
+		if ((fpu_kernel_cfg.max_features & mask) != mask) {
+			pr_err("x86/fpu: Disabling AVX support due to missing xstate features\n");
+			setup_clear_cpu_cap(X86_FEATURE_AVX);
+		}
+	}
+
+	mask |= XFEATURE_MASK_AVX512;
+	if (boot_cpu_has(X86_FEATURE_AVX512F)) {
+		if ((fpu_kernel_cfg.max_features & mask) != mask) {
+			pr_err("x86/fpu: Disabling AVX-512 support due to missing xstate features\n");
+			setup_clear_cpu_cap(X86_FEATURE_AVX512F);
+		}
+	}
+
 	if (fpu_kernel_cfg.max_features & XFEATURE_MASK_APX &&
 	    fpu_kernel_cfg.max_features & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR)) {
 		/*
@@ -836,8 +836,6 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 		goto out_disable;
 	}
 
-	clear_cpu_caps_with_missing_xfeatures(fpu_kernel_cfg.max_features);
-
 	fpu_kernel_cfg.independent_features = fpu_kernel_cfg.max_features &
 					      XFEATURE_MASK_INDEPENDENT;
 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
