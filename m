Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0765649CF22;
	Tue,  1 Sep 2026 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788290480; cv=none; b=tH2JB+dskSsnPDxdvPIgd5e4mDq2gEB0cBCg/hNEnbmmgOB2S8ah8vP9okzDA/CaTFGHLfTEZcSS0it+qrqhIKsDrSqgAm6nhvcUMrIn4QF832wbbkD31+v3NXWuYjFB9ju3BXMYRebSO4eH+OFexylXOdgmn9+aDVltIINSXUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788290480; c=relaxed/simple;
	bh=rFCR4wvJPqtoOsLRqFRiTraJfKJOCvUH3Vowulw0ArM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmdLCBQmO7TaUK4sSbym+yx0TJKFQQ10Of4zMvOXW50QpMXlDchrTGN7ufXFkbPizg8dI+3bqo1F1IR2SxWd9qz3OD+wOqN+adVW9okbhrtF3aiuau9wnhbxO9M3CdhPMixmsSI6uUXswQgAyCu4pG35Yw9Uxdwq5XZDLYaTzaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JOO1+1L2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JOO1+1L2"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D31DA40E01DD;
	Tue,  1 Sep 2026 19:21:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 42J7P_o6H5Nz; Tue,  1 Sep 2026 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788290463; bh=RnB4UBwIEU5ra0mwZ01BUCuLPy+58IVs4ew37pEMoXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JOO1+1L273NyqfcFGwz2MT94SkwUY+b8uVgDoJa653eT5gtWzVONMMzv+jX3TL0QK
	 DQnQ1yJgZDcxC2tOpBvs1nRWJ8ymnlElQZruVLAJQm4PazrZPgQepckG7RcltsVl8V
	 BuZfc5wfOkZ49YdT8GpN69T5jtUrDID6WbiCmzORwtXRAZVd3DjlGCWkoYiZ8dYbYt
	 llHUv/QtmuDgnr38XOSvF5OazHwO+dq0CEVUc24j5nvvkc2TlugkxKGwWuFe/+GppP
	 Vq1A5SoJxK7qDyytsvsepZ4Q+MdSgqX2L/xm5sAvDbTjabHYNh0mbtnizA615wYU74
	 mNnUPQE17VxdwaHDbzEE2ZRPOADmraP7VF/10NsKy5hEZN7FSnTwB78Pxjg4A7PEmg
	 fk6LBPgj36NvAo3jOYO6HNQ7+sZ1Sph9tEzExKoBfZ0+8IqECTzz/VgMz3F9V28m4L
	 o+uSE7S0TEU+K9mLOb79Qh7RXIccMC7tKxbewNLSrz0k6JjWM07GACH1vf1H4xBFGF
	 ha1kCJjMcTGmfm/101WrWNpsG92FTbxQHADRecgAxHi6n5T2H04SM/0I3Nfl6sxBo2
	 L3TDgOkyJTZS+UmOlYk6CU4GLAwqZdemIvs8It0MMpWW8i0Lf3XEdMfIpeZ3Q4IM8s
	 g4XXoiThC2RTKS3y5TOVozmc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD76340E01E1;
	Tue,  1 Sep 2026 19:20:28 +0000 (UTC)
Date: Tue, 1 Sep 2026 12:20:25 -0700
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
Subject: Re: [PATCH v12 4/5] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260901192025.GHapcleQABEDuwZc3I@fat_crate.local>
References: <cover.1786389115.git.ashish.kalra@amd.com>
 <9c9502278f68af9da19f0dd583ba303d0e6d66d2.1786389115.git.ashish.kalra@amd.com>
 <20260829205208.GDapNGeGMOs02IrkGS@fat_crate.local>
 <c699a686-dab2-4e7b-af6e-3ea89cbed202@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c699a686-dab2-4e7b-af6e-3ea89cbed202@amd.com>

On Mon, Aug 31, 2026 at 03:00:25PM -0500, Kalra, Ashish wrote:
> And we drop the leader/follower bookkeeping, but the warm-up stays.
> 
> Minor nit with the patch below : with the andnot gone, this_cpu is now unused, so please drop it.

Ok, these changes mean, the previous patch "x86/sev: Initialize RMPOPT
configuration MSRs" needs to be redone too so that it doesn't add
rmpopt_cpumask at all.

So please take all the cleanups from this thread and send a new revision
after integrating and testing them.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
