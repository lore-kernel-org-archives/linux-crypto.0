Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23AD13213C;
	Sat, 17 Aug 2024 07:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723878486; cv=none; b=rVxsBRXSawVbvQdB3Zr0kj788GENUtrdqIc7oBQP+r5lGkDLhzPb/PdjR49jrkQtvX0e8AXzIqQLF2I+ih7gFrqI2TewbVVE1I+91PbhQcKOupIwua+2W9Z3FqikSR208Dx8WVotodEhdjg/pfASXg8edyTbcOD2Qf396LbmFyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723878486; c=relaxed/simple;
	bh=LVNUcBsPkT1ZhS8qRJmIktLxJA4GBi66gn9u9snb8NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjHDQ+bPOk0lPr6tMg6ypCDYsR60287HDkzD/ilrqDKJKQNR8bEUvviLVBcVxe5E9vvDInN5KsyUdo/Uw45RMoRFD1b8ARjKNmOGQHyRzzQTwH8Vy3+Qs6vM7Zh+HIRBefP9ctq8v31zwbnV000aWz6f14KO5+y/DUzpHCPFUUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sfDP0-005IJt-0I;
	Sat, 17 Aug 2024 15:07:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Aug 2024 15:07:51 +0800
Date: Sat, 17 Aug 2024 15:07:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia He <justin.he@arm.com>
Cc: Andy Polyakov <appro@cryptogams.org>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: arm64/poly1305 - move data to rodata section
Message-ID: <ZsBMRzbjPvfnhYg3@gondor.apana.org.au>
References: <20240806055444.528932-1-justin.he@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806055444.528932-1-justin.he@arm.com>

On Tue, Aug 06, 2024 at 05:54:44AM +0000, Jia He wrote:
> When objtool gains support for ARM in the future, it may encounter issues
> disassembling the following data in the .text section:
> > .Lzeros:
> > .long   0,0,0,0,0,0,0,0
> > .asciz  "Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> > .align  2
> 
> Move it to .rodata which is a more appropriate section for read-only data.
> 
> There is a limit on how far the label can be from the instruction, hence
> use "adrp" and low 12bits offset of the label to avoid the compilation
> error.
> 
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
> v2:
>   - use adrp+offset to avoid compilation error(kernel test bot and Andy)
> v1: https://lkml.org/lkml/2024/8/2/616
> 
>  arch/arm64/crypto/poly1305-armv8.pl | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
