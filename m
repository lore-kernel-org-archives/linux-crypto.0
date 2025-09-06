Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B38315D5A;
	Sat,  6 Sep 2025 08:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145666; cv=none; b=a3Z0GEVIoE8CJzwa9g+MaFaRdi/fuxn82B325htSvF/jL6qvIDoWqGT/n3Wr7gLhTQ5eyka5CLC9iANJc0PyqJs2IKtiYqcaS4yIaxvYNfgZ7T5G9YiSOb8/aeVXmEzKjc8muHQaxF35syqswDvVl8KMrND5S4HxpvOSgbMLWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145666; c=relaxed/simple;
	bh=BZQVn9tHHpKW31HziXOuEwibLzN/tYHPDS4H0rRSNKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj1A1rZ/5nIUa8F3fTvBpTcRnY8McbByuWrM+RHTq4rd6g3cgjiHftmQx+hULkTF77gpDEsfzhQf7dgDfyRQa98nnm7kF2wXErhnaxL15Wp/A4z0OqHcxLFbTjkLo/n4/QO6UnGAHrNk2t0rkGiUJUGtsJwVSrnnctfElDb2PAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aq+Zh2kC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aq+Zh2kC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2eJVnv22kyUSbWsbX8sjAcG1ALobMsJXOAwO7iW9O6I=; b=aq+Zh2kCOr96I1gZpIDngGOQ20
	MGnk6OoMtzOq0NOGKOpXD6pJHRgSXRkBRIrBRZylw+iJ6hqqxFgQjcLG9pQiRJrylRUyVW+KSnlSg
	tp3XJlug8Dm4LfFU5DgLtxvtryiYGKlj7oQY4KlCj1lLAo1n++Q6ykCKhncpTigEU3aJ+hzXRCqEo
	nJ+geZPWinXcbraX+X9kMX9qLIqyttLt5KHdEmq6wEw6uftBm0F/Tgyhxsj01fiigxx8ooGs/oZ2p
	CoMcFzvSoDAW4JjdWR3iYiwJvKmuSwZoTs0rxYEoGF3VdOWLwYCMNpZvRp5weXdjJAx2LhQPzPOEm
	KaPBBvzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uunba-003BP0-0r;
	Sat, 06 Sep 2025 16:00:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Sep 2025 16:00:58 +0800
Date: Sat, 6 Sep 2025 16:00:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com, smueller@chronox.de, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org
Subject: Re: [PATCH V6 0/3] crypto: Add Versal TRNG driver
Message-ID: <aLvqOhdLBRU5ch8Z@gondor.apana.org.au>
References: <20250825071700.819759-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825071700.819759-1-h.jain@amd.com>

On Mon, Aug 25, 2025 at 12:46:57PM +0530, Harsh Jain wrote:
> Versal TRNG module consist of array of Ring Oscillators as entropy source
> and a deterministic CTR_DRBG random bit generator (DRBG). Add driver to
> registers entropy source to hwrng and CTR_DRBG generator to crypto subsystem.
> Derivation Function (DF) defined in NIST SP-800-90A for CTR_DRBG is not
> supported in current TRNG IP. For DF processing, Update drbg module to
> export CTR_DRBG derivation function in df_sp80090a module.
> 
> Testing
> 
> Following compile tests done
> 
> * CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
> * CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = n
> * CONFIG_CRYPTO_DRBG_CTR = n and CONFIG_CRYPTO_DEV_XILINX_TRNG = m
> * CONFIG_CRYPTO_DRBG_CTR = y and CONFIG_CRYPTO_DEV_XILINX_TRNG = m
> 
> Changes in v5
> - Direct include header file in df_sp80090a.c
> - Add internal/drbg.h
> 
> Changes in v5
> - Direct include header file
> - Fix review-by tag position
> 
> Changes in v4
> - Add df_sp80090a module to export CTR_DRBG DF function
> 
> Changes in v3
> - Fix yaml warning introduced in v2.
> - Squash fix patches
> 
> Changes in v2
> - Fixed signoff chain
> - Added 3 patch to fix Kernel test robot bugs
> 
> Harsh Jain (2):
>   crypto: xilinx: Add TRNG driver for Versal
>   crypto: drbg: Export CTR DRBG DF functions
> 
> Mounika Botcha (1):
>   dt-bindings: crypto: Add node for True Random Number Generator
> 
>  .../bindings/crypto/xlnx,versal-trng.yaml     |  36 ++
>  MAINTAINERS                                   |   6 +
>  crypto/Kconfig                                |   8 +-
>  crypto/Makefile                               |   2 +
>  crypto/df_sp80090a.c                          | 247 ++++++++++
>  crypto/drbg.c                                 | 244 +---------
>  drivers/crypto/Kconfig                        |  13 +
>  drivers/crypto/xilinx/Makefile                |   1 +
>  drivers/crypto/xilinx/xilinx-trng.c           | 435 ++++++++++++++++++
>  include/crypto/df_sp80090a.h                  |  27 ++
>  include/crypto/drbg.h                         |  25 +-
>  include/crypto/internal/drbg.h                |  54 +++
>  12 files changed, 833 insertions(+), 265 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
>  create mode 100644 crypto/df_sp80090a.c
>  create mode 100644 drivers/crypto/xilinx/xilinx-trng.c
>  create mode 100644 include/crypto/df_sp80090a.h
>  create mode 100644 include/crypto/internal/drbg.h
> 
> -- 
> 2.34.1

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
