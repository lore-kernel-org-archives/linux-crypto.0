Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9609F819
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 04:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740716354; cv=none; b=LdFMyoH13s3UhbYHM6miYzaVueilbnXDo7YVgCUEgT4z0TmTVG91FL1wiChCmf3LpdZze/863iSOlMfL8f53Ea2cFOg7NMXIIXGvSzX0W2I9SbFkrPmJXuwtjnboINMPT5RAbpt2PbXtLdNb8Jl88G0P+T/vYSh26yojcubsmPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740716354; c=relaxed/simple;
	bh=w8h+xEkaW0uSwgTMdyVntu7KhetHqWXFqXmY56tbe9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jfj31FWCjpU6MJ5RawxBxTK6DfmycV7++e2TaTfkg+ksFfv37hAZG3+Hql20bxCy6o75tw4rHWNnEbRvEoDl9vZwpg8+FFBcC39jTR00Z2xM3iIjrxvmGyXXSBg6C6geVrHjouG3V3TLv7dl3T9L3uX3QkiKN3SGJ0aO2H6kkP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qe8Eleha; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qe8Eleha"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TDS6xnEYeLYUp8c4YAbIZWR3bs6fZ/X4v41XqrujLZM=; b=qe8ElehazZK1neXWRtJ/q/Jg3t
	qzg7OlSgdU5PwjgfrXDvqE3j1drvi+FZSAuYQh2Y0ju7E0RuVcYTZTOjrMFhjg/tKrjazir4eXZbK
	chIL/l4ULPzenmQlhU97D6Ryb6fBr0yUzuCtnCWw6INplGh2TQLQE9sSAb+gkqr2U9zht/s+DgjQ2
	p+LdlKC6J/yzJ1/eAQCk4Dd8MT8xkhpOwT12ng8Ls1GBK1EAZjLhM68+JZczYloKqj5v9XcUJdyF8
	Ddaa/KdxY1TP49su5dupuqlDAzSiiC+Y1L8yqZNnD76gSjX8mWtFLeaN2VGdsptgAT6m8C7iYDYLI
	ZLauWgpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnrq6-002TMQ-2s;
	Fri, 28 Feb 2025 12:19:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Feb 2025 12:19:06 +0800
Date: Fri, 28 Feb 2025 12:19:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
Message-ID: <Z8E5Osowgnheq19L@gondor.apana.org.au>
References: <20250227123338.3033402-1-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227123338.3033402-1-ardb+git@google.com>

On Thu, Feb 27, 2025 at 01:33:38PM +0100, Ard Biesheuvel wrote:
>
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index b01253cac70a..a759e6f6a939 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -135,7 +135,6 @@ config CRYPTO_LIB_CHACHA20POLY1305
>  	depends on CRYPTO
>  	select CRYPTO_LIB_CHACHA
>  	select CRYPTO_LIB_POLY1305
> -	select CRYPTO_ALGAPI

You should add CRYPTO_LIB_UTILS.  It's coming indirectly through
CRYPTO but as Arnd suggested that can now be removed.

> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index a839c0ac60b2..280a4925dd17 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -11,7 +11,6 @@
>  #include <crypto/chacha20poly1305.h>
>  #include <crypto/chacha.h>
>  #include <crypto/poly1305.h>
> -#include <crypto/scatterwalk.h>

Please also replace algapi.h with utils.h.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
