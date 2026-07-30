Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAEC4749F9;
	Thu, 30 Jul 2026 23:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453611; cv=none; b=Ae/4AyVvP1r4iWOGhYH9j5XTNHi7Pj7IOj5Xe75JGPrurquhUJMwVl0BuLpv94tKjplSEithxCz6nYkmI0/HdwJ7t5V1uJ2Nbqd9ScSaPkACqsh3klE8mXq0hmM/aGO42RGiJOb89p88m4o1AGO5MUWl/8sldAxAkugCxe/cMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453611; c=relaxed/simple;
	bh=WzR0+8zgB31qNcckSokICnU3Vwg+fI2hTgeGIm5ULzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CP6s/689qIJgV/4/PPeFXlnpd6jYAmp++d6wTq8BfKaPxOSe358OSoNs2+Gx4PClf69o6zMpbDAkRtcC9me3e0pk1aBPyNEl7fBTwqTmwPcK1yJvQnPurRaD5FNzs/P9rxah9rL6Wq45aOji5J5snZzEE9VJ9eWOfyp+sFOv7uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Zlg+tvmb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Zlg+tvmb"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4B58F40E02C5;
	Thu, 30 Jul 2026 23:20:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YaY55hrjYjXd; Thu, 30 Jul 2026 23:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785453596; bh=sE2CHxzhUtOfnAchtXF11C6P43mpvIdTtGOWYTJ/43s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zlg+tvmbPqxBedQUPXUafoqiF1Hfa4h3zxfivSBLbEjzd1XgiAV5qS+hs0TxmBmpt
	 dHy7k+0VQ1qauzxTilBT1KhhUrd6/YyVjVVu8rEX+8yT+gI9HsLlA7c6f+4xaLdeCf
	 qtVVA3GK7Oy/f2D2HWQCE6C+OEE0WByZxOeom4R2YQOqZ3HIXZ6IlgSZUpxyyxc44I
	 hSe9l3tZcxN3nseTi121BNI5Y9U0jhZ33a6hfsvDxF0dGyAdZk+tz1CSoCdHohrAoV
	 gSOgiOJzGsdnQSX8IccI7tuykhr+zN+5WhPWeQGmb/As4WPNZXSzVKQjhfEYijzSgt
	 iJuejTP2e5OuFsjVEy0c53z/PHKnadEOpeDq3E2OYAs+zSDaUJVuBX8gn8o9SjA4cV
	 /DAHZXwctyNdo/t7vcEq/TqYNAbwg5KuKjmT+DewWM8Ddrk9sIWK14oD2+RBw6WrY5
	 MzfCMdFE8i4B5P+8LNPFV5UOX+9z02aPyrysB6RD+buQg8cctNuhq2ORFJ8dFWP0oa
	 EaSlJq1sRO8do5PGDCnPcPR4vDBwseVieqZCXzZ/DhS5uaOKpx+piAJWNVObvcycr8
	 iT1hQEqCUopIpGk6gCxcfHUOcLchpeS2b/1k9KggwhnJ1HKI/hx48wAnp93UWrrfxB
	 /0Gwo7iRZcvO888SwHZ7ZOa4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B364940E02B7;
	Thu, 30 Jul 2026 23:19:47 +0000 (UTC)
Date: Thu, 30 Jul 2026 16:19:44 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/8] lib/crypto: x86: Stop using cpu_has_xfeatures()
Message-ID: <20260730231944.GLamvcEBNkNIXjQt26@fat_crate.local>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-5-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728021603.79870-5-ebiggers@kernel.org>

On Mon, Jul 27, 2026 at 07:15:59PM -0700, Eric Biggers wrote:
> Checking both boot_cpu_has() and cpu_has_xfeatures() has never really
> been needed in practice, and it's never been universally done (e.g.,
> lib/raid/ omits cpu_has_xfeatures()).  Nevertheless, both x86 and UML
> now explicitly clear the AVX and AVX-512 flags if their xfeatures are
> missing, which should remove any remaining doubts.
> 
> Thus, remove all the calls to cpu_has_xfeatures().
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/blake2s.h  | 4 +---
>  lib/crypto/x86/chacha.h   | 3 +--
>  lib/crypto/x86/nh.h       | 4 +---
>  lib/crypto/x86/poly1305.h | 7 ++-----
>  lib/crypto/x86/sha1.h     | 4 +---
>  lib/crypto/x86/sha256.h   | 4 +---
>  lib/crypto/x86/sha512.h   | 3 +--
>  lib/crypto/x86/sm3.h      | 3 +--
>  8 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/lib/crypto/x86/blake2s.h b/lib/crypto/x86/blake2s.h
> index f8eed6cb042e4..0f7c51f055c8f 100644
> --- a/lib/crypto/x86/blake2s.h
> +++ b/lib/crypto/x86/blake2s.h
> @@ -55,8 +55,6 @@ static void blake2s_mod_init_arch(void)
>  	if (boot_cpu_has(X86_FEATURE_AVX) &&
>  	    boot_cpu_has(X86_FEATURE_AVX2) &&
>  	    boot_cpu_has(X86_FEATURE_AVX512F) &&
> -	    boot_cpu_has(X86_FEATURE_AVX512VL) &&
> -	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
> -			      XFEATURE_MASK_AVX512, NULL))
> +	    boot_cpu_has(X86_FEATURE_AVX512VL))
>  		static_branch_enable(&blake2s_use_avx512);
>  }

You could add a patch at the end or I can do it which does

	s/boot_cpu_has/cpu_feature_enabled/

as latter is the interface we use now everywhere.

But yeah, it should be a separate patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
