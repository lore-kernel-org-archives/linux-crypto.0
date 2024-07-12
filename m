Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B1132125;
	Fri, 12 Jul 2024 23:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828675; cv=none; b=L6nfx6xNJgAQD1WBPCOd43fb44+MwnJJzlnnB4+bc4yMjmk3cw5DlD8JB3UGUiJRPJk1Q/YppbYt3MMnzKxQa+Vte/pco8JsXidN6HW7vs04ZewGYLxgpIXp+TC1Pj4AIHYWWCPdhgVPaEGD12b2Ek1p/vXEJxLxR6WTY3qgn2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828675; c=relaxed/simple;
	bh=f5dNxTuK+BlE+0krtXaFn0KunwbLJVjLVYnY5etzQIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t95x9FSjryFJJUdiHTX7eFAfX7vn5RnWgOwFKW8gmXoOPes6mkuqIL4TjF6JPp/WN6X84ksR1Y0i/uZ4wnYdXotT2Bomblar5Rlo4iNAIMag4vvut9ExSIsnUgzL77jDudpmdqhdLPpR4msZzOx73z8Uqw25bTMIZdeHUVzX3e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sSQ8s-001q6Z-29;
	Sat, 13 Jul 2024 09:57:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Jul 2024 11:57:34 +1200
Date: Sat, 13 Jul 2024 11:57:34 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: core - remove (un)register_miscdev()
Message-ID: <ZpHC7j8NvDhbwV92@gondor.apana.org.au>
References: <20240706144205.2301865-1-masahiroy@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240706144205.2301865-1-masahiroy@kernel.org>

On Sat, Jul 06, 2024 at 11:41:24PM +0900, Masahiro Yamada wrote:
> These functions are redundant after commit 0daa7a0afd0f ("hwrng: Avoid
> manual device_create_file() calls").
> 
> Let's call misc_(de)register() directly.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  drivers/char/hw_random/core.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
