Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF74C6D;
	Fri, 25 Apr 2025 02:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745549347; cv=none; b=h2ABYomVpWfPUvHC9nvEo6tegQ/HnL8IBpsT+xQeAnbJG61Vnw7leJdv086yOEEPDWf36gXPkSFG83ILaYBBLEhY+79PSeojI8dmcGl5qZnGe9SZvte5zsYkzIXAMVLuJfgI3xzC0lO1j89neC251sSMawufTMcG9q4oewFVq+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745549347; c=relaxed/simple;
	bh=IjZgThLJOqvB9xuumimrb2GgbbBBWLz6m6/8mqn+R3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjv4dZBFsZ6NSJTQKgTYPZ9i2aQh5MzhzfuJvH2OMSvLsnZfMtr78KEftYJAPny0WdOGyQ8vqvdBQdqjvVcPajxwGBGYX2Jv+k3hmyPgml1JNuuC9vLtjwQzfsOeCw/BDMleYJE8OfbozK4FrSeO4DekrXQfjUgz8geHqs1Cjzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ANccXNGd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ANccXNGd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cnV8pteBUZTuj+uhOfEOc824fXoOdF+CLlRvwwfF0wI=; b=ANccXNGdGcg2JeipvXlhXmq2p1
	kOhXe1gyb33uDHyNvPxiIN9ZmFF1oQmf7i9p8dT6Usdeqsxia/QmihmTYdiCK2oRCRCExSKgvIt6P
	IiK9JUiK0T91CqTXL5/W1Z89FX5nMz3a9BC/c3pTpOkoCbP73bO1bbSteqoOUojhrn+1wFeEvagDH
	ELlsKqjlhgpYvzc0q5y3FigvrvR1oqsWq3Ip0iJp0yBU8Km5u4acHS5mdjb0XUSVqmxH2p0MNfz5h
	0nZ1hY8DfbgtyAbIS3gvjfGePHljQIRNQY927YkhFzF07YTqix8Y70UrX/bmbQ9LDZPs3kM4eDXpy
	+Y0LY7UQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u897M-000rbH-26;
	Fri, 25 Apr 2025 10:48:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 10:48:44 +0800
Date: Fri, 25 Apr 2025 10:48:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] riscv: crypto - Use SYM_FUNC_START for functions only
 called directly
Message-ID: <aAr4DFlbPiNKpBmp@gondor.apana.org.au>
References: <20250424-riscv-crypto-fix-cfi-build-v1-1-2d7516737379@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424-riscv-crypto-fix-cfi-build-v1-1-2d7516737379@kernel.org>

On Thu, Apr 24, 2025 at 05:23:22PM -0700, Nathan Chancellor wrote:
> After some recent changes to the RISC-V crypto code that turned some
> indirect function calls into direct ones, builds with CONFIG_CFI_CLANG
> fail with:
> 
>   ld.lld: error: undefined symbol: __kcfi_typeid_sm3_transform_zvksh_zvkb
>   >>> referenced by arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.o:(.text+0x2) in archive vmlinux.a
> 
>   ld.lld: error: undefined symbol: __kcfi_typeid_sha512_transform_zvknhb_zvkb
>   >>> referenced by arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.o:(.text+0x2) in archive vmlinux.a
> 
>   ld.lld: error: undefined symbol: __kcfi_typeid_sha256_transform_zvknha_or_zvknhb_zvkb
>   >>> referenced by arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.o:(.text+0x2) in archive vmlinux.a
> 
> As these functions are no longer indirectly called (i.e., have their
> address taken), the compiler will not emit __kcfi_typeid symbols for
> them but SYM_TYPED_FUNC_START expects these to exist at link time.
> 
> Switch the definitions of these functions to use SYM_FUNC_START, as they
> no longer need kCFI type information since they are only called
> directly.
> 
> Fixes: 1523eaed0ac5 ("crypto: riscv/sm3 - Use API partial block handling")
> Fixes: 561aab1104d8 ("crypto: riscv/sha512 - Use API partial block handling")
> Fixes: e6c5597badf2 ("crypto: riscv/sha256 - Use API partial block handling")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S | 4 ++--
>  arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S           | 4 ++--
>  arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S               | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
