Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75D219F9;
	Fri, 21 Jun 2024 12:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973115; cv=none; b=mPRqyTsw4bj8PNuHvAcA+cv36fuOIX+Q3T8HiMx1MK3GYRcAlPeCcMxGEY27t0HSUkBDEN+gtpdx//g3Pnabb2ruQv5ay3JX0l67CveaZd8YnPr4FL7aVkZEVsBNGlYKdaqJzKIT95XKkIp1IVPK1scHGk/W97JlQh5r4DbcnFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973115; c=relaxed/simple;
	bh=KkFIaG+IN8bP3wjGhaqksjllG2yOiRAZ5wfBC8geIpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOWQVUpblubgGHSS0eLYT64KMzsw9wBbYcrXijw6Ro9ZaJPMdixehP0Tp4W6MzPis6EWCezAfjWhMUGAfpoQyAAPsM3KTDKqrOK7JVQYy3QWJc/7x5w9+mz6l1tdX2lXFEn/tJnPb0KarIzDt+6Jbc1gk8jl2alCoNAd4Imi7VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdQV-002ejS-2E;
	Fri, 21 Jun 2024 22:31:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:31:36 +1000
Date: Fri, 21 Jun 2024 22:31:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-hardening@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <keescook@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] crypto: arm/crc32 - add kCFI annotations to asm routines
Message-ID: <ZnVyqPEBmHXkMgi9@gondor.apana.org.au>
References: <20240610152638.2755370-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610152638.2755370-2-ardb+git@google.com>

On Mon, Jun 10, 2024 at 05:26:39PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The crc32/crc32c implementations using the scalar CRC32 instructions are
> accessed via indirect calls, and so they must be annotated with type ids
> in order to execute correctly when kCFI is enabled.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/crc32-ce-core.S | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
