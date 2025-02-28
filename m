Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39901494DF
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 03:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740713095; cv=none; b=ggfOSnP1wkwN0qEBg27uMNEl9TnA86QAsHVV15uhAImxnM/nf7fmR+xB3AR+mlLpLfCF8UBVqH+Pv/fETL9jdeKR5QQZ7GxM3alZQsU0caUj3xSg3R1jtIpfrwIuOU+uxKbKvC5/FLvK5J+XTyKEd3+2YomgUF/8FYla1N1ON/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740713095; c=relaxed/simple;
	bh=ob3VzpCA9QDWYHblb66VylePpDbD3WXdY1Jn7CHw3uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGfL9RKxs8FteY2X3kimuGSw7m4B/yiiiCbrK1634oC5QlZevHEvuXcMIsOLK4L2QEuoKQkJHEVZtLlsbwhf9qlt9vcuDgw54HHBfH5BRcnRH1oarC7c7bLNB1tRgu3iwb9ZLaKjphyR2S5GZZUFqnPqpqjaoUBrdrFRjLewHpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M08CuTTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M08CuTTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3564AC4CEE6;
	Fri, 28 Feb 2025 03:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740713094;
	bh=ob3VzpCA9QDWYHblb66VylePpDbD3WXdY1Jn7CHw3uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M08CuTTLstdAuMo2fl2Yg517dYHjKkZdAi4NaLJElMgwTo2hXs0hFXBMTUdIk1gwS
	 UgtRsy7R67XVJ5wr0hihLntaXTT4wSLF3PVh8VmSwJC6ERw6Zbz5clutnGJ/k2SWwC
	 WtoBJ3e9G862mzKU+5WV+dPOWWvXNmcvJFpAWYi3GaEed+EpJ6MbtfmgTDPb6ZRxAW
	 k3iiikjOgXAConAzrY0/G3IMQzt6K+wKkdL5c3jdSyn1pIWohjy0tQBOB+HMwbH1uo
	 tA9jQHT40mp8sVwZw3fsRCmJK+PXpFGQbebm4mBLR6jijZvVRhSfNjOserefT/vQ96
	 RUOGdDCqOx+Uw==
Date: Thu, 27 Feb 2025 19:24:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
Message-ID: <20250228032452.GB5588@sol.localdomain>
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
> instead, and drop the CRYPTO_ALGAPI dependency.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Acked-by: Eric Biggers <ebiggers@kernel.org>

There's indeed redundancy between crypto/scatterwalk.c and lib/scatterlist.c,
and switching to lib/scatterlist.c makes sense here.  I do think that the
implementation in crypto/scatterwalk.c is slightly better (including being
slightly more efficient), especially if my patchset
https://lore.kernel.org/linux-crypto/20250219182341.43961-1-ebiggers@kernel.org/
gets applied.  It would be a good future project to unify them into a single
version, which of course would not depend on CRYPTO.  But for now, just using
the one that already does not depend on CRYPTO here is the right choice.

> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index b01253cac70a..a759e6f6a939 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -135,7 +135,6 @@ config CRYPTO_LIB_CHACHA20POLY1305
>  	depends on CRYPTO
>  	select CRYPTO_LIB_CHACHA
>  	select CRYPTO_LIB_POLY1305
> -	select CRYPTO_ALGAPI

As Arnd mentioned, 'depends on CRYPTO' should be dropped.

> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index a839c0ac60b2..280a4925dd17 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -11,7 +11,6 @@
>  #include <crypto/algapi.h>
>  #include <crypto/chacha20poly1305.h>
>  #include <crypto/chacha.h>
>  #include <crypto/poly1305.h>
> -#include <crypto/scatterwalk.h>

Also replace the include of <crypto/algapi.h> with <crypto/utils.h>, for
consistency with the removal of the selection of CRYPTO_ALGAPI.

- Eric
