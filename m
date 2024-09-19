Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B9A13AF2;
	Thu, 19 Sep 2024 04:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721755; cv=none; b=PkxgdOktBFvV612cfCjLH0VdkzH0kVS95W5ZF/hRZV5OE2L9NoAvg+xa6CcuebjUOf6Z9pDZUQYXBfyS4M9pSX3d9guK6VXaEjLILLYI7uy3nP3+TNHvi0yec0eMFu8V+qe0EIGzH0Tdfw7gh50NNnnGNfLtmhTCU/V3F4hK+fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721755; c=relaxed/simple;
	bh=HvB7eymv7NaOLCA8lH14ygHPc0r0KGHTISwP3o5W56c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Whd6ugl0UnaKYVRkwoaFaYxJZGP1xWgVxF3GRG+RFpNonC6oC7wjQeN0YaiVKhxskXDjS4fUazIlKXEosTZSTuTseeCK4eHzaFlLccDbL0rwwQjLh6l4QaS1wz/pbjZmU0HXM3+coB1TUVZzPhkhgiYcaWtGnJvKjKomttH91iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=VU5t/152; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="VU5t/152"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1726721748;
	bh=MUErbNaxrktoTpPsP7kf+5jpJMqTd7jZyOeBef4Dt5M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VU5t/152fmhMt0CYkNKVCVGLcCp6XHTDmv/VwV4yScPxg/LAYyqzs85wvHc0X2JWK
	 9kgkbrGiZXoyB6ksDVdM9I5vEXfJoAWMv+fw6T5w3TWmn9P4fqhxnk4zKwacDKEGoa
	 yc2nyUeiOH8T3qpJjSMBn+l1yDUvP1jsmoMZZjFKRwFRgjfzlr2vYOOyucnu+avrvh
	 HuwB8n/UrTN5tg3DSiwyCRMlPW5rKUiuwkbFOdYkTOE9Y4XOtTCrTKvQ5vS1Kj+4GS
	 Y9jpQcR+zgsjYA+H3OYm0LP/b4KBP0/KlXJDJTDRVcBOXmGwOfP5uiMx+HbDB/oNoN
	 WSa3ymoHYee8g==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4X8NWS0mLJz4x6l;
	Thu, 19 Sep 2024 14:55:48 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 appro@cryptogams.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, ltcgcw@linux.vnet.ibm.com,
 dtsen@us.ibm.com, Danny Tsen <dtsen@linux.ibm.com>
Subject: Re: [PATCH] crypto: Removing CRYPTO_AES_GCM_P10.
In-Reply-To: <20240913123043.1636183-1-dtsen@linux.ibm.com>
References: <20240913123043.1636183-1-dtsen@linux.ibm.com>
Date: Thu, 19 Sep 2024 14:55:47 +1000
Message-ID: <87r09gp7ho.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Danny Tsen <dtsen@linux.ibm.com> writes:
> Removing CRYPTO_AES_GCM_P10 in Kconfig first so that we can apply the
> subsequent patches to fix data mismatch over ipsec tunnel.

This change log needs to stand on its own. ie. it needs to explain what
the problem is and why the feature is being disabled, without reference
to subsequent patches (which will probably be merged separately).

It should also have a Fixes/stable tag.

And as Christophe said, just adding a dependency on BROKEN is
sufficient.

cheers


> diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
> index 09ebcbdfb34f..96ca2c4c8827 100644
> --- a/arch/powerpc/crypto/Kconfig
> +++ b/arch/powerpc/crypto/Kconfig
> @@ -105,22 +105,22 @@ config CRYPTO_AES_PPC_SPE
>  	  architecture specific assembler implementations that work on 1KB
>  	  tables or 256 bytes S-boxes.
>  
> -config CRYPTO_AES_GCM_P10
> -	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
> -	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
> -	select CRYPTO_LIB_AES
> -	select CRYPTO_ALGAPI
> -	select CRYPTO_AEAD
> -	select CRYPTO_SKCIPHER
> -	help
> -	  AEAD cipher: AES cipher algorithms (FIPS-197)
> -	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
> -	  Architecture: powerpc64 using:
> -	    - little-endian
> -	    - Power10 or later features
> -
> -	  Support for cryptographic acceleration instructions on Power10 or
> -	  later CPU. This module supports stitched acceleration for AES/GCM.
> +#config CRYPTO_AES_GCM_P10
> +#	tristate "Stitched AES/GCM acceleration support on P10 or later CPU (PPC)"
> +#	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
> +#	select CRYPTO_LIB_AES
> +#	select CRYPTO_ALGAPI
> +#	select CRYPTO_AEAD
> +#	select CRYPTO_SKCIPHER
> +#	help
> +#	  AEAD cipher: AES cipher algorithms (FIPS-197)
> +#	  GCM (Galois/Counter Mode) authenticated encryption mode (NIST SP800-38D)
> +#	  Architecture: powerpc64 using:
> +#	    - little-endian
> +#	    - Power10 or later features
> +#
> +#	  Support for cryptographic acceleration instructions on Power10 or
> +#	  later CPU. This module supports stitched acceleration for AES/GCM.
>  
>  config CRYPTO_CHACHA20_P10
>  	tristate "Ciphers: ChaCha20, XChacha20, XChacha12 (P10 or later)"
> -- 
> 2.43.0
