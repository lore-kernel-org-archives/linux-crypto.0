Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5533859EC;
	Thu, 17 Sep 2026 02:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789611637; cv=none; b=X6BlNPayR/fFPEbRyVxpUMaEqTa8AgwcuoMRCTFlZKNMrdxQ4U30/ct14yMUXMEhv3t8A83kp/G2MgW+4jEZKkB6STtHDmH6BFtwwgkr0qq+WWlolXQE/KiIXp/V3rRtQ6mvqkGu99CpyWzKKjDl8HH4aJv783UaciUpvTN0YT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789611637; c=relaxed/simple;
	bh=2hEhyk0s4WVmFdIupv816I4A+gouGd9M8wYttLHRGbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ID6I/35gzwxFhIQjy3MwqIa3XJZ6/9dOrg6B56HbsNsInNp4KJ1AmNE7LQxHQ9+F8ARiBW1pdh8mQGJMSw8OFwf42eK1nhYVWFTPgxAcvb1hQU6BoPhtk6V4jbvHqUPrqss0MVRaZa15nu42tHDaDYk2ZtwqyN28+j1gCKho6gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CPaKDwdl reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CPaKDwdl"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B90C440E00B9;
	Thu, 17 Sep 2026 02:20:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Oqanxm5HEzvI; Thu, 17 Sep 2026 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789611616; bh=t+xhCY2klvKxUHYu8YVGd1Jq3dnIAaBznhM5u4gjcEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPaKDwdlQE4UQKX5VEGrvNFhWWNdZ5an+ir3VDDwOLNb6Thz2NZnvhPfPvM++nh1s
	 VROsc8PIAf1rBld9VtHkliStCc5QOBkUfvkvLN6XzSyomnq5VgwkOnTcHJYn5y9w4N
	 SE8zZ5Jd3EO/527Jd5FDgUJeeFgZKkqi6SWcTs0LH6a0KFHG5Ff79mpy/E/tLpu8am
	 ZiA7szmkmZy8E+3FKpU+4Eqfvr5JMqail4qIA9Xuu6sufv7nTP2Ohx079BBbTcSCCL
	 kzannFLMQ2DHAqs/tnDbkk9thbJ4iMfo3muzW6OBGoi7XG3n+W64ijBmTVHuwr5wIO
	 B6i/1t0bSpSdzJFB6PmqZ1LSgp8S5eSHypxnfW+BarzoQey4PtjgDGpTWVIwcm+il6
	 bjKC2FbBgFO4QREQRreqD+80QNfypJB6GZJcRSmvruu4RRAoTve2bwj+gKNMFhFjj2
	 5RISMtwUxlPOqPYDNphTDxoIbghtrlNdnVdNcbmfIiv/dqOCMWNr3+1MP2KvnqZy3I
	 6u9m+KPChF6vYRN2QhUwdKCyxQ4Q5X3ghAZENYaa14hVxAK23COKU6uaSESM6BPfc/
	 h2my2Tpa8xQaGxnNFgyShc8qpJGhFS5mY7FESabANNs4/FR9yXHeSoVuBJRZKvqNxf
	 C4zFsSARasged0QxHNaCVV3A=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1CEBE40E015B;
	Thu, 17 Sep 2026 02:19:40 +0000 (UTC)
Date: Wed, 16 Sep 2026 19:19:37 -0700
From: Borislav Petkov <bp@alien8.de>
To: sashiko-reviews@lists.linux.dev
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v16 2/5] x86/sev: Disable CPU hotplug while SNP is active
Message-ID: <20260917021937.GEaqtOOfbceTzNy0um@fat_crate.local>
References: <cover.1789594774.git.ashish.kalra@amd.com>
 <cd6962a88d691a020c2bf40fe77a6a3f3852fdfc.1789594774.git.ashish.kalra@amd.com>
 <20260916223630.C5E1C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916223630.C5E1C1F000FF@smtp.kernel.org>
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 16, 2026 at 10:36:30PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> - [High] x86/sev: CPU hotplug disablement bypassed on early kexec error=
s
> --
>=20
> commit ac084f2d7188c520f2ee3ced2ab76e4c068df91f
> Author: Ashish Kalra <ashish.kalra@amd.com>
>=20
> x86/sev: Disable CPU hotplug while SNP is active
>=20
> This commit disables CPU hotplug when SNP is enabled to prevent SNP gue=
st
> memory from being broken by CPUs coming online without the SnpEn bit se=
t.
> It ties CPU hotplug to the SNP-enable bit, disabling it in snp_prepare(=
)
> and re-enabling it in snp_shutdown() when SNP is disabled. It also
> explicitly disables CPU hotplug during kexec if SNP is already enabled.
>=20
> > diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> > index cff285d8ad8e3..558f7924a3f85 100644
> > --- a/arch/x86/virt/svm/sev.c
> > +++ b/arch/x86/virt/svm/sev.c
>=20
> [ ... ]
>=20
> > @@ -577,6 +582,8 @@ EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
> >   */
> >  int __init snp_rmptable_init(void)
> >  {
> > +	u64 val;
> > +
> >  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
> >  		return -ENOSYS;
> > =20
> > @@ -586,6 +593,15 @@ int __init snp_rmptable_init(void)
> >  	if (!setup_rmptable())
> >  		return -ENOSYS;
> > =20
> > +	/*
> > +	 * On a kexec boot SNP may already be enabled (legacy firmware leav=
es
> > +	 * SnpEn set across shutdown), in which case snp_prepare() bails wi=
thout
> > +	 * disabling CPU hotplug, so disable it here.
> > +	 */
> > +	rdmsrq(MSR_AMD64_SYSCFG, val);
> > +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> > +		cpu_hotplug_disable();
>=20
> [Severity: High]
> If a kexec kernel boots into a system where the previous kernel left
> MSR_AMD64_SYSCFG_SNP_EN active, and an early initialization step fails
> (such as passing amd_iommu=3Doff

amd_iommu=3Doff means no SNP.

> on the kernel command line resulting in !amd_iommu_snp_en, or
> setup_rmptable() failing),

The same happens in that case:

        if (snp_rmptable_init()) {
                pr_warn("SNP: RMP initialization failed, SNP cannot be su=
pported.\n");
                goto disable_snp;
		     ^^^^^^^^^^^

Does Sashiko not see that or somehow it ate a lot of credits so it cannot=
 use
enough now to "swap in" the whole context... if that is the AI that is go=
ing
to destroy the world, then I'm not too worried. :)

Or is my AI failing me right now?

:-P

Leaving in the rest.

> snp_rmptable_init() will
> return -ENOSYS before checking the physical MSR hardware state and
> disabling CPU hotplug.
>=20
> Because hotplug remains enabled and the CCP driver skips initialization=
 on
> failure (bypassing snp_prepare()), could a subsequently hotplugged CPU =
come
> online without the SNP_EN bit set?

Yes, but the above disabled all our intention of running SNP in the first
place...
=20
> If this results in a mixed hardware state, does it violate firmware
> constraints and cause fatal RMP faults when the new CPU accesses memory=
?
>=20
> Should the hardware state be checked and hotplug disabled unconditional=
ly
> before the software configuration checks?
>=20
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.178959477=
4.git.ashish.kalra@amd.com?part=3D2

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
