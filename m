Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DBE367F54;
	Wed, 27 May 2026 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779913089; cv=none; b=Cn7K4p4MpqgG3Ua2tKHQrJV9wvmU2IYoAS1skTcQ7stIJkRVw52V3VcryPqb8rOKJYd4coNFjkgns9V+CqRTOtFNKZ2WM7HqfZ8Yh2rzXhFu1MOXUtiiHD3Fqgv6rEffYnw+emDQFwO8WozbeBn/+mKuy7+4PP2Hy3Zq75kf9qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779913089; c=relaxed/simple;
	bh=XtYYjMlM6bVPUDCnr22kIaw6GFg+B5OUm5pOtfQlYfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4ocphwJGZO8osExb2YH1OV7gX6YCxiA1RjCgcAZtqT3mW/ldLNqr/2AMuu4bw/rZALJdV00TNLf+c9JzuCOg8CN2Wr+F7nvX6/iPVkOe0T5vF2SzVgMaMipv1F4CR/RHd/ammz6dTgk2TS+r26V5HnYzsbNcvIuR4QQzi73K+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PWtnwTBw reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PWtnwTBw"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 751AC40E0031;
	Wed, 27 May 2026 20:18:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id G1lIHx-rVMOi; Wed, 27 May 2026 20:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1779913073; bh=F3MXa6l0Flj1Bgg1aAsNjVybpJSuhc7kkfOSBEPLJT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PWtnwTBwzUid6OfUVo9fpEPV8kJiBMvI5LtfXIfUhQy+nMWsJedo2Qhjs+F6HvtZ3
	 a54goqO9NJiAZtvs5d0s/CGkyysa2LXz6loArUFAIfl/kyC3oi7iVNvIXYLWOuRQnW
	 MHHHRiAjPVKjdvm3lPJ3oiK4GYmjRF34WsSLTcZcU55qe6RVOScyL1nrPTKjeYsuqo
	 qnxA+GpZhZ/OYj0w6VcgYXCh9n4Hw90QrBvOqvMiAoSxw6ByKLhEpq7mj/5KHyRY4n
	 mooi3UfrjjwO6Tqc2qrbyIrMJoGgyQk4C+09HgmU51P6ag7kk/ViekBH0Vdt8yWo0/
	 4nO+4DizsU/bD78LWKK22E5NBKFRF9D2oRt/sZF0BGf/Pce0m7NUTy25ODTY5ujDFe
	 ERTmJn9PFtB7KxdCV3vUoVZLgMO8joEMkF2X6nzYiXJnJDXUe21QexsYz7Bdo4LT9V
	 983bLiF8A3wUv72/E9SPVfX92EdSnGUZuenvQdECMdp/uD8UIHnT6iFA86bZWzTw6w
	 jD1mO4ZH8Zfg6JVrk7Si8nhxjuDlTEVuc0RHkfOGDWj1SpUER6SkJ5eGcrA17GF8u0
	 kRTFnOBqbnQA3v5gAEwokDiHs1IgjyqPt1pBIqcRl6GklsgzgD/I+S6VEBJ/+9jwW9
	 Fn35BHXAZva0pTbP68YMTnz4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00:b8a3:f58e:8829:9ca6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 90D3940E01A1;
	Wed, 27 May 2026 20:17:18 +0000 (UTC)
Date: Wed, 27 May 2026 13:17:10 -0700
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
Subject: Re: [PATCH v5 1/7] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT
 feature flag
Message-ID: <20260527201710.GAahdRRoHFOor425im@fat_crate.local>
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <305b625c0528f16a95542001c66e643fbd3a2622.1779133590.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <305b625c0528f16a95542001c66e643fbd3a2622.1779133590.git.ashish.kalra@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 09:41:53PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>=20
> Add a flag indicating whether RMPOPT instruction is supported.
>=20
> RMPOPT is a new instruction designed to minimize the performance
> overhead of RMP checks on the hypervisor and on non-SNP guests by
> allowing RMP checks to be skipped when 1G regions of memory are known
> not to contain any SEV-SNP guest memory.

Streamline:

"RMPOPT is a new instruction that reduces the performance overhead of RMP
checks for the hypervisor and non=E2=80=91SNP guests by allowing those ch=
ecks to be
skipped when 1=E2=80=91GB memory regions are known to contain no SEV=E2=80=
=91SNP guest
memory."

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
