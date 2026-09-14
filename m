Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB313436BC8;
	Mon, 14 Sep 2026 23:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789427803; cv=none; b=MX/8PnCBIzBbw932gZaxN3xUxtYgAvAOrr6BpsIbrDrclb08LLHAGJrX4cSlAAFiux0a/1viFTxhoWk/QGBY4o10XmGRXYXFYFWjwO52yhtZCVO0gAdRfRHKAGj1O3/1e1DXBQVr2BjSvffJmvc+VbxvaZDSL6Pdsj2DcMte5gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789427803; c=relaxed/simple;
	bh=DldnhjZ1oz2ZNjDXbZgrA14LZ4lTulHoXSh3SDUsCvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=de+VU6D4JSWuGVMZMCbxadiDaq/GD0KWs4jD5TmiCC0cR222Hv/ycXAL/bGCvdjx1wdp+RfFA8IU0zLAgC79ottY+VpUrL/yeDSKNwSoBJsPx+pQg5e9/XHYoYM7wcQY4C6ASiFh31XgHxWkv3WxOB/PFMCzUxQcO7C7xJkdCrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EfRTl9LS reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EfRTl9LS"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E65AA40E015D;
	Mon, 14 Sep 2026 23:16:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dS8Go-A5k39i; Mon, 14 Sep 2026 23:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789427783; bh=B/FgpwwWwn0BpGvjJbRiA/JDYUnnW8VL4awVzObb4os=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EfRTl9LS/ZA0kGklknMkvMkiK5IFWIQ+pNjIlWYRw82UO39vRuumwUthaFpRgw2bX
	 pzPsNe1Y1rctn5e0+YT1KaGWT1eLKQ02eknazzQEvApG4JoLfjpI+gkocoA1KdBxAw
	 IpQ8+TmS3odLTOlH7pMY8KAVQPfxBZW8H4ddmJJLSFgrz9jDF2pV24kRoeNu1Omrvx
	 lASgMcCRwhTKWEwIy+z/Vd1EivKyIDi6XQoZihOGX7B+NOCHeiRArUM+J+3efqxHSX
	 vYYIl7svHbaV/1trRS1SaULuacybbktXD6siSHAiNs6QyteA6NFjxd4lC2cg1KioWV
	 RqJCXxht9zN1O3usvdTcmiGkY3/oPJmKCqcKCW8jDa+KS8+OvypbL0en6XXKHS3gOi
	 ZX9PoLonNdbO7i5EcolPu6+3bewJZX06SGTmDxyitSGgsT1/7VcBvOWn0nvX01aw97
	 I2y7s9yp2k/moabmDf2Ads/SLR6mCrmJjtmOVEGqqhp3d3imlsX+2uxCU+MsaaTe5U
	 gDCNMWul2vByKC2P+El0UlQGy518S3+iqVR9x4wGpLwyvuB+YU0KZC0PZO0fgBc8hr
	 x9UVlrsY0+7yh7X/5KONwocAzYuWzwxYewKHor3PkZmDQwqBZlrmkMwQjV/asY10LX
	 ZmkK0SLXC3IbnAV6tjY23QZg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C7B1640E022C;
	Mon, 14 Sep 2026 23:15:49 +0000 (UTC)
Date: Mon, 14 Sep 2026 16:15:46 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
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
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v14 4/5] x86/sev: Perform RMP optimizations asynchronously
Message-ID: <20260914231546.GAaqiAIsjGUdsK3MAq@fat_crate.local>
References: <cover.1788984053.git.ashish.kalra@amd.com>
 <1e3d0edb6b275e33fa6f76b0c31db9e999d9a270.1788984053.git.ashish.kalra@amd.com>
 <20260912015336.GJaqSwoBGnp4Zl-jC4@fat_crate.local>
 <279595c8-30bb-4c01-8203-95619bab3d47@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <279595c8-30bb-4c01-8203-95619bab3d47@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 03:00:04PM -0500, Kalra, Ashish wrote:
> Thanks, Boris. Splitting setup from start and collapsing to a single ex=
port makes sense =E2=80=94 a couple of constraints from the RMPOPT
> spec shape how it has to be done.
>=20
> RMPOPT_BASE can only be written (RMPOPT_EN set) when SYSCFG[SnpEn] and =
RMP_CFG[SegmentedRmpEn] are both 1; otherwise the access
> #GP(0)s. So the MSR programming can't run from an init=E2=80=91time ini=
tcall =E2=80=94 SnpEn is 0 then and it would #GP. The software setup can,
> though, so the split becomes:
>=20
>   - an initcall in this file does the software setup =E2=80=94 allocate=
 the workqueue and INIT_DELAYED_WORK(), no export;
>   - snp_enable_rmpopt() (the single export) programs RMPOPT_BASE on the=
 primary threads and queues the pass. ccp calls it after it
>   has enabled SNP, and kvm=E2=80=91amd calls it on teardown.

This programming sure sounds like something we don't need to repeat each =
time
we enable RMPOPT...

rmpopt_pa_start is practically static so I'd love it if those MSRs are wr=
itten
once and that's it. The question is, do they keep their value when we dis=
able
SNP?

And I can basically imagine the answer from hw folks: "yeah, yeah, maybe,=
 but
to be on the safe side, you should always write them after having enabled
SNP."

Because if not, I'd be perfectly fine with us setting them on the *first*=
 SNP
init and not touching them again.

IOW, this pseudo:

	if (!rdmsr(RMPOPT_BASE))
		wrmsr(RMPOPT_BASE, ...):

This should probably be in the snp_enable_rmpopt() function anyway as it
should do what we want.

> The same spec text makes that single entry point safe to call repeatedl=
y: RMPOPT_BASE_ADDR is read=E2=80=91only once RMPOPT_EN is 1 (and
> RMPOPT_EN can't be cleared while SnpEn is 1), so a later call's write i=
s a probably a no=E2=80=91op rather than a reprogram. If we want
> to avoid even the redundant IPIs, snp_enable_rmpopt() can read RMPOPT_B=
ASE and skip programming when RMPOPT_EN is already set =E2=80=94 a
> hardware=E2=80=91state check instead of an if (rmpopt_wq).

Yap, or that. Sounds ok to me if it works.

> On clearing X86_FEATURE_RMPOPT when the allocation fails: that hits the=
 problem we ran into in earlier revisions =E2=80=94 the workqueue
> allocation is at initcall time, after alternatives are patched, where s=
etup_clear_cpu_cap() isn't reliable (static_cpu_has() is
> already baked in), so clearing the cap won't flip rmpopt_capable(). The=
 setup/enable split removes most of the if (rmpopt_wq)
> checks anyway; the only one left is a single guard in snp_enable_rmpopt=
() for the (rare) allocation=E2=80=91failure case, which I will
> probably like to keep rather than rely on clearing the feature.

Or, you can introduce that bool rmpopt_enabled and clear it and test it i=
n
rmpopt_capable(). As long as it stays a static var, only visible in this
compilation unit and not exported, that's good enough.

> I'll respin as v15 with the setup/enable split once we settle the featu=
re=E2=80=91clear question and the RMPOPT_BASE MSR programming
> question (i.e., skipping it if RMPOPT_EN is already set).

Thx.

Btw, you can respin the last two patches only and send them as a reply to=
 that
thread - I have applied the first 3 already so no need to resend them aga=
in.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
