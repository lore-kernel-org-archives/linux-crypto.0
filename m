Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964322;
	b=tDWHFvcRG7P/SD8+qE/tdk4/maAPFBpTXdfZ0H/r5YQ+seLwk2+B4NQUSatJ5+/DGH1k
	 EoVW/H+pz+pbUrxJXRYBqTlwpgBFordqPlUWYND0K/meZftvly3z74Nx8q1ofRmJCz0+X
	 lpzEz3PPAjnWAIOoEEdKpjeH/qTMKNvZ4cNF6U/0st41YlAyRvxXzYKXTsvb3gmm6+1yo
	 TQwaPmFWupLkXY85iYVKdpj88txKlFIHCukKXxOxmQjMNuXnIQ98er9X6EmjCzLMXOsI1
	 1UTy7wwOHxfhYL64KNOTGgCCCvLWiVi+PoEqFvj7iQyE3EvVFROWPzByO1Hm9lDVigQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964322;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Trrv0iMPhTtQUqyITn36BdI+UF3+7yotm3GSUj/OMh8=;
	b=DoyjWJ3WBJyYyxkN3ALdVcTRA5fS+s2lgl7XUp1ml2x3I5vNh21MkVB/W/010B0Mq00l
	 Y6QXhNBqp7T1pbbc5Awr5JIR6NjkNSq7SzvXcbwIM9MX77beTzbg7S37Ltda9As/hIODw
	 xAH+3RwCQNMgYmz2kjbMxDWZ8894Ew/wtv6x97pYT+aRHjeHpJtVBl1itDk+9G43DHd3T
	 rmxbZHOI2fNakk6KMiEHmFEvSwO+6h2eCCgMhqKDM4/qJHdaw9rTQkPPua6TMrwv2T5Wr
	 zPs8vStFYfJC7QVUTRpPbwmqjZNLMXEgX/XKXn1kUijVv4cnKN5UzSVO/ORt2oDdt9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="Xalt/f/X";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F8606D804;
	Fri,  6 Nov 2026 11:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D12F8606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Xalt/f/X
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Trrv0iMPhTtQUqyITn36BdI+UF3+7yotm3GSUj/OMh8=; 
	b=Xalt/f/Xt043Y/+vTNh22MawDBUQuE5XrAWejw2UqhqH86/kmWLOr56SEwjKGH0dB9nmNhenZd8
	THDoek5i9hqco5cS9ZPBbmxi8BLmgfLmEvYAFaiHwm098u95fmEwUM7zX6tJtctMRxTiQg/dN8V6X
	6zg9fvQlWzCyeuDRAEKikDcVbqGzN1RoqSzAX57HVpgcTEpnW0LICB1EkGh59hK1BBc98welye82F
	UQaz0GB4CZbNsFiX8kuW16UrQQSFZ+jJ8DMNETyABiYIIhvvDEBgjxk00lEcjsWzz7w3EtAR3CMUp
	Uly5qmBLIRfOmk4ipAAwIIN6kSEq+rcDe5sA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI4L-0000000Br0M-2Ou9;
	Fri, 06 Nov 2026 19:25:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:25:17 +0800
Date: Fri, 6 Nov 2026 19:25:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <kees@kernel.org>
Cc: Taehee Yoo <ap420073@gmail.com>, Nathan Chancellor <nathan@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev,
	kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aria - Take the address of each asm function
 in one file
Message-ID: <au25HZSyqJMjW-F2@gondor.apana.org.au>
References: <20261012031920.i.329-kees@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012031920.i.329-kees@kernel.org>

On Sun, Oct 11, 2026 at 08:19:21PM -0700, Kees Cook wrote:
> A Clang Full LTO bug[1] was fixed in Clang 23 where multiple .o files
> performing an address-take of the same asm-originating typeid weak symbols
> would have those symbols get completely removed instead of just keeping
> one, seen at link time:
> 
>   ld.lld: error: undefined symbol: __kcfi_typeid_aria_aesni_avx_encrypt_16way
>   >>> referenced by aria-aesni-avx-asm_64.S:962
>   >>>               vmlinux.o:(__cfi_aria_aesni_avx_encrypt_16way)
> 
> As a work-around for earlier Clang, add aria_avx_setup_16way_ops() and
> aria_avx2_setup_32way_ops(), exported by the glue that owns each tier's
> asm functions, and fill all three tables with them, so that each asm
> function has its address taken in only one file.
> 
> Build tested ARCH=x86_64 with the kernel test robot's randconfig
> (CONFIG_LTO_CLANG_FULL=y, CONFIG_CFI=y, and all three ARIA drivers built
> in) and W=1, with Clang 22.1.8 and Clang 24.0.0git: vmlinux.o defines all
> fifteen __kcfi_typeid_aria_* symbols, and vmlinux links. Without this
> change, Clang 22.1.8 fails to link it as above, and Clang 24.0.0git,
> which has the LLVM fix, links it.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606041643.GyTZgCk1-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202606122021.pA9TozrA-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202608100432.yIX7TckM-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202610112311.o9XQsWsa-lkp@intel.com/
> Link: https://github.com/llvm/llvm-project/pull/204025 [1]
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  arch/x86/crypto/aria-avx.h              |  3 +++
>  arch/x86/crypto/aria_aesni_avx2_glue.c  | 35 ++++++++++++++-----------
>  arch/x86/crypto/aria_aesni_avx_glue.c   | 29 +++++++++++++-------
>  arch/x86/crypto/aria_gfni_avx512_glue.c |  8 ++----
>  4 files changed, 45 insertions(+), 30 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
