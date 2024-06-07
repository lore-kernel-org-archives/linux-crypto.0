Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C95194C79;
	Fri,  7 Jun 2024 12:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717763226; cv=none; b=qulMGCHFmg8iWxH7mbkmFdKxcll4JvJo2BcG6/WX5KPfnxYdzsF9UN/DEemu8aGakviE706ZxAlvpLp+dxa46f5ozHQDD6hmwVNABgxn+SGjMtoFMicouKotiyIHk1ev2K5DHiTDp5tJ7vZ1oIUpjlQDhJZNlSrttw4s9m4BTfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717763226; c=relaxed/simple;
	bh=pvOEQ282S8vyV2vClqgIdGsxzdANxIre+tYGzdQMZGc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=K03iykuWQG62waO0LEi7lQafASM03FNMV9YxtIcWreNmu8rEI7lbF/UObBCl+RIlsIqzpxhUa4aI3EIjmY2DPbG97laVSOGbm1YuFvMDsUbI6yEaI409rUP2ZLCDxXhsILQYijgH2BBlUHLz/z1YpSVkqF+Z5Ip6p4M+UszkBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYgN-006q0S-0H;
	Fri, 07 Jun 2024 20:27:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 20:27:01 +0800
Date: Fri, 7 Jun 2024 20:27:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/2] x86_64 AES-GCM improvements
Message-ID: <ZmL8lZo-h0FYwfNc@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602222221.176625-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This patchset adds a VAES and AVX512 / AVX10 implementation of AES-GCM
> (Galois/Counter Mode), which improves AES-GCM performance by up to 162%.
> In addition, it replaces the old AES-NI GCM code from Intel with new
> code that is slightly faster and fixes a number of issues including the
> massive binary size of over 250 KB.  See the patches for details.
> 
> The end state of the x86_64 AES-GCM assembly code is that we end up with
> two assembly files, one that generates AES-NI code with or without AVX,
> and one that generates VAES code with AVX512 / AVX10 with 256-bit or
> 512-bit vectors.  There's no support for VAES alone (without AVX512 /
> AVX10).  This differs slightly from what I did with AES-XTS where one
> file generates both AVX and AVX512 / AVX10 code including code using
> VAES alone (without AVX512 / AVX10), and another file generates non-AVX
> code only.  For now this seems like the right choice for each particular
> algorithm, though, based on how much being limited to 16 SIMD registers
> and 128-bit vectors resulted in some significantly different design
> choices for AES-GCM, but not quite as much for AES-XTS.  CPUs shipping
> with VAES alone also seems to be a temporary thing, so we perhaps
> shouldn't go too much out of our way to support that combination.
> 
> Changed in v5:
> - Fixed sparse warnings in gcm_setkey()
> - Fixed some comments in aes-gcm-aesni-x86_64.S
> 
> Changed in v4:
> - Added AES-NI rewrite patch.
> - Adjusted the VAES-AVX10 patch slightly to make it possible to cleanly
>  add the AES-NI support on top of it.
> 
> Changed in v3:
> - Optimized the finalization code slightly.
> - Fixed a minor issue in my userspace benchmark program (guard page
>  after key struct made "AVX512_Cloudflare" extra slow on some input
>  lengths) and regenerated tables 3-4.  Also upgraded to Emerald Rapids.
> - Eliminated an instruction from _aes_gcm_precompute.
> 
> Changed in v2:
> - Additional assembly optimizations
> - Improved some comments
> - Aligned key struct to 64 bytes
> - Added comparison with Cloudflare's implementation of AES-GCM
> - Other cleanups
> 
> Eric Biggers (2):
>  crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM
>  crypto: x86/aes-gcm - rewrite the AES-NI optimized AES-GCM
> 
> arch/x86/crypto/Kconfig                  |    1 +
> arch/x86/crypto/Makefile                 |    8 +-
> arch/x86/crypto/aes-gcm-aesni-x86_64.S   | 1128 +++++++++
> arch/x86/crypto/aes-gcm-avx10-x86_64.S   | 1222 ++++++++++
> arch/x86/crypto/aesni-intel_asm.S        | 1503 +-----------
> arch/x86/crypto/aesni-intel_avx-x86_64.S | 2804 ----------------------
> arch/x86/crypto/aesni-intel_glue.c       | 1269 ++++++----
> 7 files changed, 3125 insertions(+), 4810 deletions(-)
> create mode 100644 arch/x86/crypto/aes-gcm-aesni-x86_64.S
> create mode 100644 arch/x86/crypto/aes-gcm-avx10-x86_64.S
> delete mode 100644 arch/x86/crypto/aesni-intel_avx-x86_64.S
> 
> 
> base-commit: aabbf2135f9a9526991f17cb0c78cf1ec878f1c2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
