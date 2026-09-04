Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9257A3C8C52;
	Fri,  4 Sep 2026 03:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788493278; cv=none; b=iwb7ndBxuQDWH4ZR+PDviIvR/V8NFruIo2NQleniF0qspL59b53mUmTkAjKKKBsHY4DOi1z2imC5v4arK4CRkxgnfcmL/d/axgVsfVMABDi51LdKergjYQqH9b6TeMrJ80Ggc5NrxjseGoDi54aic8ZqbUZYWfQs5CZ7iIWwhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788493278; c=relaxed/simple;
	bh=foxIeghAg2saABL37v1NutmmyqD4Xn1mhU596aHrAtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asNQp7zHUZzz//juEoqCtW1KhodWmzrqIKw9sjzcPJkGB71p2FbWkoFbxpUEkq43loEpObzOShA98SXP8JBsLDVOULF2LimdbRQdWFG1Rae6Eb3AELC+OfPHgXwnX1xF/rOxXW4eayHA4ERfgxy2YA9WGD+aX0pHNS6NSbhF85s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sdG6JmY9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sdG6JmY9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Hdfi3jZgauIFaRpLs/gfb6nxMfDXlGViRJTkgxXxiNQ=; 
	b=sdG6JmY9Ks4YCQkzcoKYRyHlGggfgmNU/0/i/kfPL1MMpHhojkepsSOd4Nkl8UUib24Lcp5jWhJ
	p7+WwQPWh5W9ULoxQU0bdEZ504URyTIoYUu9e+YkeWqz77pQq00cCSSUeLQXvGPxUYSkYLOYAMM3q
	WPNaT/j//ri22clpfZt78tRglKOh0xA6iXQ7Zq2i1gtXjkUNCLMSgVN5xIqZLY5n2glxxlXn+3o7V
	kCwumLt6JksTOPVTZsomirXZxz8JHxmPRpbKU5AHJqi51vAGC5EEXSrme0khvH/fD3KyYCtZ+z09B
	8LUKVYUJDPQhhqhc72EA8+CcAOawToB2yCvg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Knd-0000000AhQD-2DH4;
	Fri, 04 Sep 2026 11:41:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 13:41:09 +1000
Date: Fri, 4 Sep 2026 13:41:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, stable@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH RESEND] crypto: x86/aria - add missing vzeroupper in
 AVX-512 code
Message-ID: <apo91cGr1a6lhXUc@gondor.apana.org.au>
References: <20260831211812.213262-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831211812.213262-1-ebiggers@kernel.org>

On Mon, Aug 31, 2026 at 02:18:12PM -0700, Eric Biggers wrote:
> Since the AVX-512 optimized ARIA code uses ZMM registers, execute
> vzeroupper before returning from it.  This is needed to avoid degrading
> the performance of any later SSE code that may happen to be executed.
> 
> Fixes: c970d42001f2 ("crypto: x86/aria - implement aria-avx512")
> Cc: stable@vger.kernel.org
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This didn't get picked up by the x86 maintainers yet.  Herbert, can you
> take this through the crypto tree?
> 
>  arch/x86/crypto/aria-gfni-avx512-asm_64.S | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
