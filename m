Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ABC46AA6B;
	Tue, 21 Jul 2026 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647999; cv=none; b=fyUwguv8wm3x5x5+jUPCmrf9IzA5Ges6ihxzIekMxwN8MXjpB9uNtNT92jj9ytEohh8HtvyfB4WQlb+8p3Fn3KN7po6/yWEQC+csjeu5yUzOgvoGiqxs2Vp7RCijPd62GfnmGcu4m0gJUdxCQGmbxbChc/L5fIoI4zSC87WD/8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647999; c=relaxed/simple;
	bh=p42FdDG3W2PcF9gjZDhHjj0UxkMFq9DZNUm9D+Yq2wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbSYebM/OrHO+auKmbdC/8aQSfQzLF0GOHrzrw9w/dVIx5B4fSbra7BRza8qX3nAV/u9mOqm28mJLaQf0USzuXLWq0NSNIqqgzkZnlwdkcuOAvIMNHlqkdGtMEqzjUPfPQ+MkMx0ryybjJyqWLnWz4Sggu7Yn6bTzD7PkrgGtJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jBY0WGGL; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jBY0WGGL"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4362E40E014C;
	Tue, 21 Jul 2026 15:33:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qlpVAtYpdz8I; Tue, 21 Jul 2026 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784647984; bh=gfaFDf5tJQ9koeSUXrEkCo3jxffhhLyj8C7mTBh7tfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jBY0WGGLmBbXUc5tvnv8754Mv7jBcWHpeYf1hKruMd1drFq4JIuzhweuI6s53xPIZ
	 THDWkO6QhM1TJpP0kC1GaUTUoJDc1+efHzBZkRnBbknCT0HIeHoCa5xjWuMhV9hkIe
	 vwq//fHgE+glkom2B8ynImLlecW14X6kkyavBttS51wCVKwJ83euISl+vYLv23ybTU
	 Yhxoyb+dmW3KJ5Hd4xsWignJDBUH2kPOCXvSAO1PQkTn8nudibkKIMmXoXpk2DbvTI
	 +ApRx7apy5P1bwBrDwUh9RzVQyfNNz170M8MUvTa8p9P3P/JPm/HI/F7lUzuNlwEyF
	 n7zOthdykyonRPgjDvnKDpbBzl1lfALFm2yNWjHvTM4AnTjzuk4EYDeCAPapQQDPhP
	 fpU3fSajZjK+4q7XqhYZPhbS3Is3LoQsihyhST8gSQwnrCi398F8y45f+ERKzPDTBd
	 qNAv92J1f2LyXY8VLKxgJ9MBqMlnYrHJhdZfWZFQ7PEf4DtTzZncoROp0XsI5jJkXX
	 62MX0Zj5kQlKhTzCMUa7BmrNR4fhVLyWSUAQtXYH0S96XStojBw+JixsxmouFm/xgb
	 iPuiZVedPMxu4UNiUA2DJz03dbTF2ZFcktPX/CYSAJEv8m6EjBHgA8gTI2xcu9sU6R
	 WCxvgaU72GLrUtLFwsgK/M48=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6E6F340E00E6;
	Tue, 21 Jul 2026 15:32:29 +0000 (UTC)
Date: Tue, 21 Jul 2026 08:32:25 -0700
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
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260721153225.GFal-RCQdG54tNiPGb@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
 <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
 <20260721014841.GCal7P-f3ZBHQzR-0_@fat_crate.local>
 <9a183dfc-91fa-4a08-9168-8ea0e53f708c@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a183dfc-91fa-4a08-9168-8ea0e53f708c@amd.com>

On Tue, Jul 21, 2026 at 09:26:48AM -0500, Kalra, Ashish wrote:
> That's why v7 moved to a runtime check. In v11 (as i mentioned) this will be a small local helper,  it will also handles two things
> the cap-clear can't:
>   - a contiguous (non-segmented) RMP, where RMPOPT isn't usable even with X86_FEATURE_RMPOPT set.

That's the point of clearing the flag - to mark it non-usable.

>   - SNP being disabled at runtime (CC_ATTR_HOST_SEV_SNP).

Same as RMPOPT being not usable follows from disabled SNP.

>   static bool rmpopt_capable(void)
>   {
>         return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
>                cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
>                (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&
>                rmp_segment_table;
>   }

But yes, this is a local helper so that's good enough.

We can always change it later if needed.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
