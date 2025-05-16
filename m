Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865FCA32;
	Fri, 16 May 2025 12:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747398458; cv=none; b=P5oVONDRk5ofQezZrFEy0EhhtTo5jRFIAZFcRZ854PiQg7KNmGNOgXxkGa4zu7UntuxpcIfLzCX6FCmNa7H/nFHdGxACOj6sjlmXMKccG9UPYc/jKoFtz5/gjT8C9me0bSvzOP6ihrMo4MiwKjMW0GUcppjvMIlYHFzjp06mE6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747398458; c=relaxed/simple;
	bh=msf1u6psXmm5YGgNc/J1e9yKeJ4zJ9sPS2p6grmcTnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZ33gIeQlarrO8hmZ6eUIGzqmcHnukaJmw0NoPyfMalAN2v1e3fvrEVjkyPBSNglxrFgM+P1LO7Q8EVAzLaxJdFuwb/n8dX6PNyAZIIVfNh0yrYS5wDvHJRbRiQJxIkh0RX201yLKFtjhVslCsa8e7C4+wmOeHpgUK31fAQVMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OX8m74ex; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OX8m74ex"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 57C6D40E0241;
	Fri, 16 May 2025 12:27:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uwSaCqau6FpN; Fri, 16 May 2025 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1747398447; bh=sG2uaaEQ4UYwgNQ5ATaaMB63qAcs03C2EG0pb4eWOjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OX8m74expZfER3T0uDYUZICIDGPSBDimfLXl0fR3OhC6yCduNSpf2QC5eX8Rr2Gq8
	 jWt4NplxvGpKuKhjX7+GliN3GLBAJ9ZpCkhkZ6LEAGhz5kEpW4Bg5eCaW9eIObotoF
	 VUa8dSBKzkbMjviHTTr+tcvR3ypKNpWipnfjjDQMdkIoS/QveX80eoF6+GahuLDanr
	 Jx2uBfv2K4teXJMO0mBewwkyy9q0aNCNcKVjMj5RS8eTQLvagFDqmoyzDkiuaZ8xG3
	 +mqxZf8JpEIJw3QdgslBdtWqqrVZ9iNNIm/7n4+cSFs9gTeqCf6fVuF9rg5QYC1dol
	 UWA5OvdJv8zjiy2mWJhOoN1QwAB+OlWGLuTslMfyeXdPm1J7Z+sg9hQfAACSy+PyvS
	 Ngr1jdA3qW0PCW7M3NIKOLYx2DGwFIpWER21u8D9+QSwdFy11ADQBG1nzj4iqC0MHh
	 bF5eENJpkrCiMnkoR1GE3NH2+0/ogpmJ/zycq553b73j658M8XG195yUJAKZFHbEtJ
	 FjBAGWtjNQTZHn0a0DglVcqazBEEUXt5LOAgbE3ne2LDJDSHJJP02Zk8z200WTAkI3
	 7u2f/e+4qXKPZYfC/jtlF3QjbFJvLRAwgjbUgIySb28oIBS1otWhLBUsQE9yObQr33
	 Im30v/0KYKyoT+Q9wZAdBO8Q=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C178740E0239;
	Fri, 16 May 2025 12:27:20 +0000 (UTC)
Date: Fri, 16 May 2025 14:27:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ayush Jain <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] crypto: lib/sha256 - Disable SIMD
Message-ID: <20250516122715.GCaCcvI7vq-DBzlNtK@fat_crate.local>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
 <aCcirrsFFrrRqf5A@gondor.apana.org.au>
 <aCcmJGuCnuyHmHbx@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aCcmJGuCnuyHmHbx@gondor.apana.org.au>

On Fri, May 16, 2025 at 07:48:52PM +0800, Herbert Xu wrote:
> On Fri, May 16, 2025 at 07:34:06PM +0800, Herbert Xu wrote:
> > 
> > So what's happened is that previously if you call sha256_update
> > from lib/crypto it would only use the generic C code to perform
> > the operation.
> > 
> > This has now been changed to automatically use SIMD instructions
> > which obviously blew up in your case.
> 
> In the interim you can go back to the old ways and disable SIMD
> for lib/crypto sha256 with this patch:
> 
> ---8<---
> Disable SIMD usage in lib/crypto sha256 as it is causing crashes.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>

Please make that

Reported-by: Ayush Jain <Ayush.Jain3@amd.com>

I'm just the messenger.

> Fixes: 950e5c84118c ("crypto: sha256 - support arch-optimized lib and expose through shash")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
> index b9bccd3ff57f..e1b0308c0539 100644
> --- a/include/crypto/internal/sha2.h
> +++ b/include/crypto/internal/sha2.h
> @@ -32,7 +32,7 @@ static inline void sha256_choose_blocks(
>  	if (!IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256) || force_generic)
>  		sha256_blocks_generic(state, data, nblocks);
>  	else if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD) &&
> -		 (force_simd || crypto_simd_usable()))
> +		 force_simd)
>  		sha256_blocks_simd(state, data, nblocks);
>  	else
>  		sha256_blocks_arch(state, data, nblocks);
> -- 

If you end up doing this, that fixes it, obviously:

Tested-by: Ayush Jain <Ayush.Jain3@amd.com>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
