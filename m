Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE07155741;
	Fri, 21 Jun 2024 12:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973325; cv=none; b=cDOvKEGZu7qY0uNLmG8eNtK0KjCknNVSygiJMtCVHuFY0lKRyeo3GvtW6bl88HmGHJ+WmtYbUJiD56Nh13LZkmCZ9J7nkZBrqvFasxgkjhATJWCrPhQPPgDKXo2eHODBf6anOxGKWKT5hL5v3tg/BbhnbZZ9JDXslU1AFIZS88E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973325; c=relaxed/simple;
	bh=DAbfkbzQszqjx9XcJQhPa3kDd4qDzqPlO1ZHE4zgObM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tv/vPp8YgL7NEvW6Vv/dOaMwLxMOWnv77it5rclxwzxVULmp8Ki20XQ5M6KZwFv7KcL/P88mD7FGNUt5J1S8I6/tXlTI3JV1HvFpwqlVSEn4VBAmzMkDUPXpu/2U7N1l4IAs72zmLdTRe1qtEMnWxz3qGDYG6EP4AOeXOzpHMcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdTs-002eps-2d;
	Fri, 21 Jun 2024 22:35:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:35:05 +1000
Date: Fri, 21 Jun 2024 22:35:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: lib - add missing MODULE_DESCRIPTION() macros
Message-ID: <ZnVzeapei4WxSUbQ@gondor.apana.org.au>
References: <20240615-md-arm-lib-crypto-v1-1-27b67bf8573c@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240615-md-arm-lib-crypto-v1-1-27b67bf8573c@quicinc.com>

On Sat, Jun 15, 2024 at 11:14:57PM -0700, Jeff Johnson wrote:
> With ARCH=arm, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libsha256.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro to all
> files which have a MODULE_LICENSE().
> 
> This includes sha1.c and utils.c which, although they did not produce
> a warning with the arm allmodconfig configuration, may cause this
> warning with other configurations.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  lib/crypto/sha1.c   | 1 +
>  lib/crypto/sha256.c | 1 +
>  lib/crypto/utils.c  | 1 +
>  3 files changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
