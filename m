Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73773AC25;
	Fri, 17 May 2024 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715943464; cv=none; b=R1wDR2BY/cBV98S4sSgZYDGs4VVdUk79tkC4JGAa5WjYwsdfR3gJvnd5TdmpT01lwyFDS7OB8/IE/mMuNkyBtdB7I7dOKxaXwUdMFOKmkzwXcKIbWV6++18nBuAPxEj0/ZVu5OX7mR28+EQ67twspxoWHngmoU+CDO6RCU2RuO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715943464; c=relaxed/simple;
	bh=SUFy1YwSeXt/BK/QChjzi3KKhYCdsOqTHDS/t45oRV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ro9OaHLnPH5sUPRAAPh+sE9r3AiBdwXy0RAQ3JPsdkBHalTwMe8M7HCeQsxASy1k3VonW1fvv+hIH0+ZDm0YK+3xBoqZmiE1TGO6H9u/z6y138zhQswfhZSKCSk4mNoWuUYaWCwZwJpuH4s/mqiCT74aDrqfHlcRwmY4se5GKM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s7vHH-00GjMI-25;
	Fri, 17 May 2024 18:57:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 May 2024 18:57:32 +0800
Date: Fri, 17 May 2024 18:57:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-kernel@vger.kernel.org, lukas@wunner.de,
	jarkko@kernel.org
Subject: Re: [PATCH v3] crypto: ecc - Prevent ecc_digits_from_bytes from
 reading too many bytes
Message-ID: <Zkc4HKGhDMV4cVOC@gondor.apana.org.au>
References: <20240510015921.179175-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510015921.179175-1-stefanb@linux.ibm.com>

On Thu, May 09, 2024 at 09:59:21PM -0400, Stefan Berger wrote:
> Prevent ecc_digits_from_bytes from reading too many bytes from the input
> byte array in case an insufficient number of bytes is provided to fill the
> output digit array of ndigits. Therefore, initialize the most significant
> digits with 0 to avoid trying to read too many bytes later on. Convert the
> function into a regular function since it is getting too big for an inline
> function.
> 
> If too many bytes are provided on the input byte array the extra bytes
> are ignored since the input variable 'ndigits' limits the number of digits
> that will be filled.
> 
> Fixes: d67c96fb97b5 ("crypto: ecdsa - Convert byte arrays with key coordinates to digits")
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
> 
> ---
> v3:
>  - Applied Jarkko's tag
> 
> v2:
>  - un-inline function
>  - use memset
> ---
>  crypto/ecc.c                  | 22 ++++++++++++++++++++++
>  include/crypto/internal/ecc.h | 15 ++-------------
>  2 files changed, 24 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
