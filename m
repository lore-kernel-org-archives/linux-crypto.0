Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856B71A264A
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 08:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741422759; cv=none; b=GqRhL99OxOHPlKdqFn1pjheAYUrx7DqoGwqclYjLx/pOn7m3b32M47Qg+Bd8ZkDksP1yCwfxw4oalfquQ4sSPYQeFCuv4uvUyf+blS9wobkJ/HBQ2Q5ENSB7keB9p6W/Mec0bqd4Xm+keXu4m5YJMVx8z+KBiRj1NtvyHlj5HEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741422759; c=relaxed/simple;
	bh=6knG3hYsCnAYCG9d8BSxNc3QPtv6R5KuPBB9Klz+b/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpEEXUvcfDPYcVzxmIsQ/xSW5/QxnwqHxtNXydsZCrXRftGMUg43DBH8tgAmWhEdiWN2uN2ZGFkLKvAlRIIv3zpvEJWkRiw09bw1HuTijt/MMKGo6KVegQkI03NjLi2SKEUGDVulyHGMENsOvz+lJ7+JGTMo2TpdmloABTL41x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=J7u4aDyn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="J7u4aDyn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qL+EfysWeRxu76aO3JuC2OmtFrJjJi2u6Tx65GzCrVQ=; b=J7u4aDyn6PVaAJ2Ug3Pj4V1UnB
	utwuw9lbmIoTW3Z4lIR50jwwTDiJSDxUjrtIp4FByygMqZ906ODQvsQvGBK0PZlZQ5jPSUy6gO7XO
	BlhkiydW7lizocx2y7PO0hWS7RABAlUUxwaHMnqfkgNCSmu9sKPsE/5AXWAj81U5LBZlmzblbMVzi
	3Y6WIYfweSS0EDRwx6NzPLOPxOJMzi/3HX+EFHCCrl+TUTEOsP75in+lniFaX46yZLlAdVJoZa23E
	AVnx7tKOKL+/UdxztUQftVmRsAQiXKzawX0L/dv/ao2ZZR/Y8Ds3gqBtk4XLa2mLJeNz5rFnLi0HL
	Yb8Vua2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqpbl-004ofl-1e;
	Sat, 08 Mar 2025 16:32:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 16:32:33 +0800
Date: Sat, 8 Mar 2025 16:32:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2] crypto: lib/chachapoly - Drop dependency on
 CRYPTO_ALGAPI
Message-ID: <Z8wAocf6S6rA2eFY@gondor.apana.org.au>
References: <20250228121137.3534964-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228121137.3534964-2-ardb+git@google.com>

On Fri, Feb 28, 2025 at 01:11:38PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The ChaCha20-Poly1305 library code uses the sg_miter API to process
> input presented via scatterlists, except for the special case where the
> digest buffer is not covered entirely by the same scatterlist entry as
> the last byte of input. In that case, it uses scatterwalk_map_and_copy()
> to access the memory in the input scatterlist where the digest is stored.
> 
> This results in a dependency on crypto/scatterwalk.c and therefore on
> CONFIG_CRYPTO_ALGAPI, which is unnecessary, as the sg_miter API already
> provides this functionality via sg_copy_to_buffer(). So use that
> instead, and drop the dependencies on CONFIG_CRYPTO_ALGAPI and
> CONFIG_CRYPTO.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2: - replace include of crypto/algapi.h with crypto/utils.h
>     - drop dependency on CONFIG_CRYPTO
> 
>  lib/crypto/Kconfig            | 2 --
>  lib/crypto/chacha20poly1305.c | 7 +++----
>  2 files changed, 3 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
