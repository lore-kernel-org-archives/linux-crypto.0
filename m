Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1105178CDE;
	Sat, 26 Oct 2024 06:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925971; cv=none; b=Ic/tQPP/h7ww8bFGBifbKuwwGirG2rHCkxg2XejElvPLv1JR6/AvHnO9d/Q3TPMOGAbBSZnkQd6LLTeG/BaBGR+Y3OaxtGs3Oc10eCVbL+LxTttqJVyp9R/Tz5fq8Yd36auLiPUVKcHvu/z9gqhqIg5wCfhXJTu+A/qjcvyMFDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925971; c=relaxed/simple;
	bh=OUCXG4t7eYsAx4y7SsMKUDr2T2CaKDQ8SKQ1nHOaThk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XIABnA+g+N4H47wlljg1PDTd8D7iM6NGGKkoir51Uo0ZpJSY/lbXTj6q5z/U4wwC8ZTJ2BV5s58BhI9OOFlG8vkQGSMPza1cRHhXYpW8fHKImJHEwEwK6ZpK9gkWrw4QCAQ/goqHgdcDRV2lubs/n1YBhNuhN3nyzs6Vo59jlIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RmLCpLax; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RmLCpLax"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qgF1fUbJTJL6DiRAKGCd3jZo/OXIyYxRtY+P1ojFY5w=; b=RmLCpLax/SXvB5W8R2SSmB+Xyl
	6Oo9lWawbqG2MnTnn5A8dz1+wIo8a6FhTfYLRaW7V67sSPhapwXsfv6/zp9TTioXNvh/xnUVfHDnq
	DyjO1J8s8f3T4xEc3kAi7Fg8EsPibGlFGULxkvffEuILD1Zs8qr8mGUeTf1pXQ6wzOjL7QxUwTiA4
	YQUxDtnmMh5V2S1dOaXOm4w7PB0s2RNQUPKXjaLfZJmjzZjPxWDtnhR9Ez+WVOKG9wHepiY2DFTAz
	IJgCPxsvUdRjGKM8cqlXAZo3fF5hDv3HX5WsPjO8WX/jSXczm+CgXyQfosQJ/yf0HBN/LbV1SaUtR
	gTiGwDBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ald-00CFyt-09;
	Sat, 26 Oct 2024 14:59:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:59:21 +0800
Date: Sat, 26 Oct 2024 14:59:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, omosnace@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] AEGIS x86 assembly tuning
Message-ID: <ZxyTSVK5xrcSbkAB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017000051.228294-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This series cleans up the AES-NI optimized implementation of AEGIS-128.
> 
> Performance is improved by 1-5% depending on the input lengths.  Binary
> code size is reduced by about 20% (measuring glue + assembly combined),
> and source code length is reduced by about 150 lines.
> 
> The first patch also fixes a bug which could theoretically cause
> incorrect behavior but was seemingly not being encountered in practice.
> 
> Note: future optimizations for AEGIS-128 could involve adding AVX512 /
> AVX10 optimized assembly code.  However, unfortunately due to the way
> that AEGIS-128 is specified, its level of parallelism is limited, and it
> can't really take advantage of vector lengths greater than 128 bits.
> So, probably this would provide only another modest improvement, mostly
> coming from being able to use the ternary logic instructions.
> 
> Changed in v2:
> - Put assoclen and cryptlen in the correct order in the prototype of
>  aegis128_aesni_final().
> - Expanded commit message of "eliminate some indirect calls"
> - Added Ondrej's Reviewed-by.
> 
> Eric Biggers (10):
>  crypto: x86/aegis128 - access 32-bit arguments as 32-bit
>  crypto: x86/aegis128 - remove no-op init and exit functions
>  crypto: x86/aegis128 - eliminate some indirect calls
>  crypto: x86/aegis128 - don't bother with special code for aligned data
>  crypto: x86/aegis128 - optimize length block preparation using SSE4.1
>  crypto: x86/aegis128 - improve assembly function prototypes
>  crypto: x86/aegis128 - optimize partial block handling using SSE4.1
>  crypto: x86/aegis128 - take advantage of block-aligned len
>  crypto: x86/aegis128 - remove unneeded FRAME_BEGIN and FRAME_END
>  crypto: x86/aegis128 - remove unneeded RETs
> 
> arch/x86/crypto/Kconfig               |   4 +-
> arch/x86/crypto/aegis128-aesni-asm.S  | 532 ++++++++++----------------
> arch/x86/crypto/aegis128-aesni-glue.c | 145 ++++---
> 3 files changed, 261 insertions(+), 420 deletions(-)
> 
> base-commit: 5c20772738e1d1d7bec41664eb9d61497e53c10e

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
