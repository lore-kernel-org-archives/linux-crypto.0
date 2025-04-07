Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A12335BA;
	Mon,  7 Apr 2025 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003535; cv=none; b=VinLN8ItJAC8CJwSUIKHK4SKbQNvcnhLVMOdzqKH87zUih1YKTAMHwWKg19I72WBgkEe2rl6099lbmS2gN/RhSiqUg/h6qmC7lUuuI/9GeGvVfjVxEOSw0GfJKRWHBRNyle9ryr06phLjDNbRSSufMSjcTVclFhxfcb6sj8Ui/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003535; c=relaxed/simple;
	bh=2WVmEbTiY2wSxCEVkjvBExa3lF5R4OcV9DLNemzxUI0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=UwD+rWq4vgtoX8bWfv0vcDdz6Sa+31mU65WX7qNKQLJDs/30s5gMfjqEqC5b3Un1u/VTdxPyPMeqRzZONp8TijsATTUiXQ8edHXEqxauRka2Tg2G3ejZhdtEkOtqxT6kB2+SgE44m9vfFw8vflTwV2Sx+dHLgEPkOXkoO7zv0MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pYyC8u12; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pYyC8u12"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LCuGOG/tTyT9/frysI18JAYwwUwWje1qfWuRQVpNAMI=; b=pYyC8u12rnZT5lhOgO8vVlqLQA
	pihd5uoLg4O0N3I6SIVNiffuiRWKxIKbllCCl4JmcrIeNgpjaMHr2n/Be1yCszuHlohc+tDxBEo4/
	Vz16oWFF8XwX6hp/dcsQX74PSLWPptjp7+Y2w+l/mexj0pp36Q1Vx0FTVe1PTcCOzwJQJUtrJGKsd
	VdfmIOl35xTVqJqNAabQc80FJ3dIjHNsdd/zOiLYJ+5XfzaX/qrMIbt/ormuRRyOAkCLMTrhSVVmc
	33AL106qcQkY++V/BUmrcq4kqkWUkSm2LjpFb1WZ5n05EvknAhnNL4rfy9jlCvByJxkfkEgM/3odR
	9+zo4tUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1ezB-00DNJK-24;
	Mon, 07 Apr 2025 13:25:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:25:29 +0800
Date: Mon, 7 Apr 2025 13:25:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <Z_NhyZD86JXX_4KW@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402002420.89233-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> Patches 2-9 are almost identical to
> https://lore.kernel.org/r/20250220051325.340691-3-ebiggers@kernel.org/
> but now split into multiple patches.  Patch 1 is just a resend of
> https://lore.kernel.org/r/20250320220648.121990-1-ebiggers@kernel.org/
> which is needed for the series to apply cleanly but is otherwise
> unrelated.  Description of patches 2-9 follows:
> 
> Stop wrapping skcipher and aead algorithms with the crypto SIMD helper
> (crypto/simd.c).  The only purpose of doing so was to work around x86
> not always supporting kernel-mode FPU in softirqs.  Specifically, if a
> hardirq interrupted a task context kernel-mode FPU section and then a
> softirqs were run at the end of that hardirq, those softirqs could not
> use kernel-mode FPU.  This has now been fixed.  In combination with the
> fact that the skcipher and aead APIs only support task and softirq
> contexts, these can now just use kernel-mode FPU unconditionally on x86.
> 
> This simplifies the code and improves performance.
> 
> En/decryption gets at least somewhat faster for everyone, since the
> crypto API functions such as crypto_skcipher_encrypt() now go directly
> to the underlying algorithm rather than taking a detour through
> crypto/simd.c which involved an extra indirect call.  For example, on a
> Ryzen 9 9950X desktop processor, AES-256-XTS is now 23% faster for
> 512-byte messages and 7% faster for 4096-byte messages (when accessed
> through crypto_skcipher_encrypt() or crypto_skcipher_decrypt()).
> 
> There's also a much larger performance improvement for crypto API users
> that only support synchronous algorithms.  These users will now actually
> use the x86 SIMD (e.g. AES-NI or VAES) optimized en/decryption modes,
> which they couldn't before because they were marked as asynchronous.
> 
> Eric Biggers (9):
>  crypto: x86/aes - drop the avx10_256 AES-XTS and AES-CTR code
>  crypto: x86/aegis - stop using the SIMD helper
>  crypto: x86/aes - stop using the SIMD helper
>  crypto: x86/aria - stop using the SIMD helper
>  crypto: x86/camellia - stop using the SIMD helper
>  crypto: x86/cast - stop using the SIMD helper
>  crypto: x86/serpent - stop using the SIMD helper
>  crypto: x86/sm4 - stop using the SIMD helper
>  crypto: x86/twofish - stop using the SIMD helper
> 
> arch/x86/crypto/Kconfig                    |  14 --
> arch/x86/crypto/aegis128-aesni-glue.c      |  13 +-
> arch/x86/crypto/aes-ctr-avx-x86_64.S       |  47 ++----
> arch/x86/crypto/aes-xts-avx-x86_64.S       | 118 ++++++--------
> arch/x86/crypto/aesni-intel_glue.c         | 174 ++++++++-------------
> arch/x86/crypto/aria_aesni_avx2_glue.c     |  22 +--
> arch/x86/crypto/aria_aesni_avx_glue.c      |  20 +--
> arch/x86/crypto/aria_gfni_avx512_glue.c    |  22 +--
> arch/x86/crypto/camellia_aesni_avx2_glue.c |  21 +--
> arch/x86/crypto/camellia_aesni_avx_glue.c  |  21 +--
> arch/x86/crypto/cast5_avx_glue.c           |  21 +--
> arch/x86/crypto/cast6_avx_glue.c           |  20 +--
> arch/x86/crypto/serpent_avx2_glue.c        |  21 +--
> arch/x86/crypto/serpent_avx_glue.c         |  21 +--
> arch/x86/crypto/serpent_sse2_glue.c        |  21 +--
> arch/x86/crypto/sm4_aesni_avx2_glue.c      |  31 ++--
> arch/x86/crypto/sm4_aesni_avx_glue.c       |  31 ++--
> arch/x86/crypto/twofish_avx_glue.c         |  21 +--
> 18 files changed, 227 insertions(+), 432 deletions(-)
> 
> 
> base-commit: 91e5bfe317d8f8471fbaa3e70cf66cae1314a516

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
