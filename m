Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E98360EC5;
	Wed, 14 Oct 2026 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792020512; cv=none; b=CLnr8GdYWuJA5ZVvUcb1ChtCxRYzmcta2WyyqmICLGJUo6r/Ew21XIkU4MSd0EgGe0c3y9mIyO0uD660vZUomVbXO60A+EZM25nKrNwBZCfxC2gkrk/GipEUg5Jqb/2aD7Be4lapdyeylwYbgDYivoDkQIq5IT98XEYDXXZL23U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792020512; c=relaxed/simple;
	bh=1PnPz/ssIDum+2czs9HoAetAo6DOsRhCTiiWFKOUTmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYdVGgwfSA0476ND26RrwA20au09mgefx1tjSEQtbFWK8iyqUD/rdfoe7vSYfQRuQ7hiV4+VI3z/I6wN9m7ooBgEoxME4h5gGflhOIlui7qzEHVGBKSTBVclMPiE0DRKjHviREIlUUzencVCBKX9U/WaTFpJAcBtbMSzhr86pi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JA3PvtPg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JA3PvtPg"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A534240E02B0;
	Wed, 14 Oct 2026 23:28:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6AdeqXv0RTNt; Wed, 14 Oct 2026 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792020496; bh=dZu9GO3zcx5gvlghTdibBt7uX59ONko2vayhAFoneY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JA3PvtPgAEWmjeXMXheLOmV3iuQG5qEvPu5v8NaVvMDm6xXRgU4N1YBYdAS/xlAKk
	 3kbBcp7JG5TsBPo/KCrO4uwtP5oCbrf0D5fcfqkuZD/yfJhWlyWYAPcW7mUascjSlQ
	 0KzsHdt0sP9v+qCfnW2OPGb/4c2Mmo3YWrUSalBjKsVeU2ldEeRAsqyk/HxAsZ7P+Y
	 hDedNwqAou+GAMEZitA5xv9ak9eCqvQJH4fSd2MKOdChmknN0qUEKsgs7N1IVgQYSo
	 tRUs3UJQVcSvtOL6xUe+Tpk024cCCdTIVTcHPKOT8CPJLsQy1GDQ8zsS0wnGNAZjyC
	 inhl6eXEaG050gDRjAqXoSV+pQ/WAigRPYKRqMVEx78hsOtRW4cJEdixzYfWDOKr08
	 QJbm/VbXrHgNDy1fSLE3l6QYj+E2rwK4etHs43SRhB2da68bfIRSoSaTuxUsv21KNt
	 CIKDTpIV6BOQ4AfCOyCOOaE3s33PpkCD2arXA3Mxl1gLJUPvtN8QHpOEWgGbSWgbMb
	 o9gBLg9zFARfeX/C9QV0JtaDlEhNE6XNi9NcsjzFoLILnXwuuI1M2JxcCkMvlhaZMg
	 sp23cW85ScZIFkEsB5pubejP1TJa/640VOHUvmAnF7iKeNN0gqoNV8f30JGIAJVRjf
	 zca6vUZgA6xRuaLo7k+Fl0PA=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE16B40E048C;
	Wed, 14 Oct 2026 23:27:43 +0000 (UTC)
Date: Wed, 14 Oct 2026 16:27:40 -0700
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
	babu.moger@amd.com, nikunj@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v3 0/2] x86/sev: Fix RMPOPT enablement on non-RMPOPT
 configs
Message-ID: <20261014232740.GAatAP7B55b7VArwS9@fat_crate.local>
References: <cover.1792018839.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1792018839.git.ashish.kalra@amd.com>

On Wed, Oct 14, 2026 at 11:06:32PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Two fixes for the RMPOPT series, both for configurations where the
> RMPOPT CPUID bit is advertised but RMPOPT is not actually usable:

Those are clearly not settled yet.

But you don't have to rush them, take your time with, test them more and
analyze better what you're fixing instead of piling more stuff ontop.

And avoid all that unnecessary commenting you're doing. The stuff you're
saying belongs in the commit message - not spread around the code.

If the code needs more explanation, then perhaps it needs to be simplified
and split properly.

I'm not at all happy about how intertwined and inter-dependent and thus
fragile our SNP init gunk is.

So think about that too, perhaps it can be simplified even more.

I'll take the final versions later, during the 7.4 stabilization phase.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
