Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA823DA5C7;
	Fri,  4 Sep 2026 03:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788493277; cv=none; b=mxRGuOBDLc61XrbbNK479YUOCMl/T0xvQdI2/5RWBeY8ufi3XVjh/fjeiDvY7+qTHUdBHi7/W9b13Qm5zvETXBcb2clFxKNnspRPPBl87e4Rd7I86bhLPkWyb9JNWEhLA4JJJ8cjBvToNvl0rOpx6x0R4I6mHjTXA8ZwZvAgHjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788493277; c=relaxed/simple;
	bh=HL8jwUjO629XDL7KipLdBoD+GmefEdo7GKZLrjbkPBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2EZ7dG3bD/50iYLp5rZfuvjkt0XcMJKsDaSBzxPV81TNFMVULeLHAoRn0a0swiFvNxfdrQlARdGunjpn5+B1WSOGThp7CPjZidwuHUbwQ45GCssTM7lMK9WiC9PZvNQ2xMkxxuX6KZkRuNFvv1Ry5hgcqeIYHMsdlIKfGPSwpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=H9gtnUiB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="H9gtnUiB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=stybfMVTtXuwI59eLIII7KLpjHK9l/GyblgfS+jxnm8=; 
	b=H9gtnUiBOIcZ+vkgPBhRMeAMRi/CreJeCvWw7cM5P1+SV+QOrT0+S8ZB+tcr278QWDDovCqimLx
	7SlxrH33F6EsbtM03YdDJntuqbcuwrwUYP20iYgxCBsmOQKfxvJVj5gtF7/GJDRVKwHe6+GiJmP/h
	/kzZqMspE0aFM7FoUV8LZVFMq40B0LbXFR1QS753myERxx2WE2Gs7e3/DYS3sF4wzB3Ax6F8kxX30
	phOyCyRHLSH0I5AsA/mldDu6I6mHjYnX0LhTcD7hUAwUUWbSO3Fd7ymvzmNCY9L2XNPiMkm93+LuL
	qIOBpRL4P8MbdSzjl0w30SGAzyikBreMyaMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2KnV-0000000AhQ7-3FdS;
	Fri, 04 Sep 2026 11:41:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 13:41:01 +1000
Date: Fri, 4 Sep 2026 13:41:01 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, stable@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH RESEND] crypto: x86/aria - add missing vzeroupper in AVX2
 code
Message-ID: <apo9zfsoIOsXbKcW@gondor.apana.org.au>
References: <20260831211715.213121-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831211715.213121-1-ebiggers@kernel.org>

On Mon, Aug 31, 2026 at 02:17:15PM -0700, Eric Biggers wrote:
> Since the AVX2 optimized ARIA code uses YMM registers, execute
> vzeroupper before returning from it.  This is needed to avoid degrading
> the performance of any later SSE code that may happen to be executed.
> 
> Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
> Cc: stable@vger.kernel.org
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This didn't get picked up by the x86 maintainers yet.  Herbert, can you
> take this through the crypto tree?
> 
>  arch/x86/crypto/aria-aesni-avx2-asm_64.S | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
