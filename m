Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4294E28727B;
	Fri, 17 Oct 2025 08:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689381; cv=none; b=ETRiw03vwBKgGLYSQAUisCBZLgY5xbNaklMkyXYmdjeg9D6vgiDznjs/xRgkxrRyTkcZK8ZLP9kSb/RGE8hQxeYqdNOqQk9ZmyTR2OJSIEs3D3AVHkhIlzZ21qZbsyZMjlqGXFgwpZCLCyb8jSFiyX8r5C2UqF9p5OZyBD/GF/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689381; c=relaxed/simple;
	bh=OxPPXWaxtS5ARtDeuNtZSj/+wvLkD+KBGcHhEj+azrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VX+LBgE9r6A+ylw0gEX7fx/k0b41iXdEFoKUQhkMePY5LWTD1P7Xeloy39rD50cFuHEbcayofHX/v9HQwV/Y5ScLbbDRsKI6aaPTsjL+6tBUjePm4U6uSXxU+L3uGKMYPUsyxyyQErf55FlmmSdi3BHSwAkwleDrz0WSdwOsbuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=I4BBg2wO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="I4BBg2wO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=f1UgrtkRd8hzFxDQXSida2T4QLJIXoBHA//CXqka/gA=; 
	b=I4BBg2wOqPtr6WipkUrHnbVRKlhH3MvAlzxSK3Wjf63bV0xvxpVwYT4FC4NYcEK/JZvLqD4sJgK
	ZxoNrza5jDZ+S91IQBRgCHU6248RxE3RC+9W+bIqXmFNPLsOmqrJMkvwxJv+EKkdUbDrOtqdgaxkz
	rY3vFbOsHgFOgRpmVWTeMP8GIJvJZnqeqtxMEQnRI3w/4aiDNWY8Ohk6c/hCw71Ty6h9a76GH1RaJ
	sVKgCXaSvUiWFbqnscUi0zfTojMo96+JNBjy1zCtnT3BMBvs0fWUxdRcvP8DbJEnc3oL22bkpPLwk
	ip70R+iNHAELfA4TgbBMa3JfqGlXax/5kkOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fjj-00DN5a-1w;
	Fri, 17 Oct 2025 16:22:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:22:55 +0800
Date: Fri, 17 Oct 2025 16:22:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: meenakshi.aggarwal@nxp.com
Cc: horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] trusted-keys: Add support for protected keys using
 CAAM
Message-ID: <aPH83_rWq8E1dYZ2@gondor.apana.org.au>
References: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006071753.3073538-1-meenakshi.aggarwal@nxp.com>

On Mon, Oct 06, 2025 at 09:17:50AM +0200, meenakshi.aggarwal@nxp.com wrote:
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> 
> Overview:
> This patch set adds:
> - Support for creating and loading protected keys via `keyctl` interface.
> - Documentation updates to describe protected key usage and options.
> - CAAM-specific implementation for protected key encryption algorithms.
> 
> User can create protected/encrypted key using keyctl interface:
> 
> KEYNAME=dm_trust_key_hw
> KEY="$(keyctl add trusted $KEYNAME 'new 32 pk key_enc_algo=1' @s)"
> keyctl pipe $KEY >~/$KEYNAME.blob
> keyctl list @s
> 
> dm-crypt can load the protected key buffer from the keyring and use it to
> initialize encrypted volumes, ensuring that key material is never exposed in plaintext.
> 
> The Protected key buffer is passed to the CAAM driver via the kernel crypto API.
> CAAM driver will decapsulate the protected key buffer and perform cipher operation.
> 
> Protected Keys are identified by a header structure:
> 
> struct caam_pkey_info {
> 	u8  is_pkey;
> 	u8  key_enc_algo;
> 	u16 plain_key_sz;
> 	u8 key_buf[];
> };
> 
> This information is populated based on the parameters provided during key creation such as 'new 32 pk key_enc_algo=1'
> 
> Internal Workflow:
> ::
> 
>  +------------------------+     +-------------------------------+
>  |   Seal Function        |     | paes_skcipher_setkey()        |
>  | - Constructs key buffer|---->| - Parses header and key_buf[] |
>  | - Adds header metadata |     | - Initializes cipher context  |
>  +------------------------+     +-------------------------------+
> 
> I welcome feedback and suggestions from the community.
> 
> Thank you for your time and consideration.
> 
> Best regards,
> Meenakshi Aggarwal 
> 
> Meenakshi Aggarwal (3):
>   Doc: trusted-keys as protected keys
>   KEYS: trusted: caam based protected key
>   crypto:caam: Add support of paes algorithm
> 
>  .../security/keys/trusted-encrypted.rst       |  87 +++++++++++-
>  drivers/crypto/caam/blob_gen.c                |  86 +++++++++---
>  drivers/crypto/caam/caamalg.c                 | 128 ++++++++++++++++--
>  drivers/crypto/caam/caamalg_desc.c            |  87 +++++++++++-
>  drivers/crypto/caam/caamalg_desc.h            |  13 +-
>  drivers/crypto/caam/desc.h                    |   9 +-
>  drivers/crypto/caam/desc_constr.h             |   8 +-
>  include/soc/fsl/caam-blob.h                   |  26 ++++
>  security/keys/trusted-keys/trusted_caam.c     | 108 +++++++++++++++
>  9 files changed, 518 insertions(+), 34 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
