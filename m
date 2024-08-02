Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF49E1E3CA2;
	Fri,  2 Aug 2024 13:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722604523; cv=none; b=Ws6HUU7Qssf6NVYMLX9RguDSbl6COhSI/SU/GQdPYJT7Z+hP9oxKzaDIt+iY4XJ//PoFZGOR8B3d4kMMebp+Oq2VH4Zp0kcRTTdwaFGQ/4w6+k1P/2EBNAyxFLbP/gl6ccflN4s1eYYszFsLtM/f2UeKTZfpjg3ye2eqAgkDQkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722604523; c=relaxed/simple;
	bh=HP+VjASG1fRugKTbM/srnTXMHrOhoWREf3tT8/KbEi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaQtFzhCgRCwtD0+9cM56xzqsVEi7XAyTaqUDC84a+a7DxAv/GUV0EzUB12ZGwpbuUPSw3BdKqzRgHyB4uy5JptqG9ZpbPJj0wKO+CXklv8ZR8uhwIdRHxIO/e0vumaOuQK9Wg3ATBOOuf9BdHtidWWnD1WcEn8Fm+CvUtuchZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sZrzD-00202k-3B;
	Fri, 02 Aug 2024 21:15:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Aug 2024 21:15:09 +0800
Date: Fri, 2 Aug 2024 21:15:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia He <justin.he@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-crypto@vger.kernel.org, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64/poly1305 - move data to rodata section
Message-ID: <Zqzb3V9mxKxLkbrU@gondor.apana.org.au>
References: <20240715072023.61032-1-justin.he@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715072023.61032-1-justin.he@arm.com>

On Mon, Jul 15, 2024 at 07:20:23AM +0000, Jia He wrote:
> When objtool gains support for ARM in the future, it may encounter issues
> disassembling the following data in the .text section: 
> > .Lzeros:
> > .long   0,0,0,0,0,0,0,0
> > .asciz  "Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> > .align  2
> 
> Move it to .rodata which is a more appropriate section for read-only data.
> 
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
> Inspired by commit 1253cab8a352, although currently objtool hasn't been
> supported on Arm, we should do some preparation(this patch) firstly.
> 
>  arch/arm64/crypto/poly1305-armv8.pl | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
