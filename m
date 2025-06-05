Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCFA145355
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135701; cv=none; b=SQClCFdpN5fiWODYRF4HC7zJxeZc6/eyXKEHb+Bwd48/zKeF9v2kKVSfefF4SWW9bgejaKzShXVmNIqKNV3FNuFqF6h2dQKpVxprBcxTktanC/NDcaHH5jxQqL6cFUMNSzQNnMw03YUFgSj8lNmkAi+gJSJOTiDZqH+BntVEs+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135701; c=relaxed/simple;
	bh=33MiDYgglWLdm/t9kBa/LdDf63XX8q2ecYMOJYL6yiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuJhrIun9i/SG8iHBN65xyfTvrzoZMRRp+zwj3pTC0QLm5CuOwOPOxqdtxzycw/7BME7uSIcw8aTy+fCZxFPUFLNKfnmdtJ8PXtZLlB/VvZC10gSFYUXr1xa7m3TzR9Ugm85mVyhiEB7gfn3SF466zexK1MvA0QWLq7gI/Uz3Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqSyr2/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqSyr2/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4E9C4CEE7;
	Thu,  5 Jun 2025 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749135701;
	bh=33MiDYgglWLdm/t9kBa/LdDf63XX8q2ecYMOJYL6yiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqSyr2/H+vCDiQO/xRrlqnSK67vX6aw2gP2CeM3y1/WyeBttsArBXJWnBSjiD/cRj
	 NZky2VwLgVKbJaLnmx+M4ZIFwodPcfA4ira+crB+X6tnZIoPs1y30Iss9wEAE54iFh
	 +duIJ5aJEixGU3aKjLDyUVOxLrKeZ7wHT0SzyHi7qow1fTvKp3TyOsaNdq6Wc05yYT
	 uaioFEIN1tz59267aiGsOCOw/1kvSzJNY3+/hX/B66nBe0QHFCjPaZGh+7FCFsSwjb
	 kTRadaV1xtywQNSN2FY/o8xrXQ3NaiZWGokuK9Whvw5byhjQw2bY8a/osz2M+yqOuK
	 VDhkvgVn12lxg==
Date: Thu, 5 Jun 2025 15:01:39 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: zhihang.shao.iscas@gmail.com
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com,
	ou@eecs.berkeley.edu, alex@ghiti.fr, appro@cryptogams.org
Subject: Re: [PATCH] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250605150139.GA945328@google.com>
References: <20250605145634.1075-1-zhihang.shao.iscas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605145634.1075-1-zhihang.shao.iscas@gmail.com>

On Thu, Jun 05, 2025 at 10:56:34PM +0800, zhihang.shao.iscas@gmail.com wrote:
> From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> 
> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
> implementation for riscv authored by Andy Polyakov.
> The file 'poly1305-riscv.pl' is taken straight from this upstream
> GitHub repository [0] at commit 33fe84bc21219a16825459b37c825bf4580a0a7b,
> and this commit fixed a bug in riscv 64bit implementation.
> Also, this patch passed extra run-time self tests.
> 
> [0] https://github.com/dot-asm/cryptogams
> 
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> ---
>  arch/riscv/crypto/Kconfig           |  10 +
>  arch/riscv/crypto/Makefile          |  17 +
>  arch/riscv/crypto/poly1305-glue.c   | 202 +++++++
>  arch/riscv/crypto/poly1305-riscv.pl | 797 ++++++++++++++++++++++++++++
>  drivers/net/Kconfig                 |   1 +
>  lib/crypto/Kconfig                  |   2 +-
>  6 files changed, 1028 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/crypto/poly1305-glue.c
>  create mode 100644 arch/riscv/crypto/poly1305-riscv.pl
> 
> diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
> index c67095a3d669..228bb3c6940d 100644
> --- a/arch/riscv/crypto/Kconfig
> +++ b/arch/riscv/crypto/Kconfig
> @@ -38,6 +38,16 @@ config CRYPTO_GHASH_RISCV64
>  	  Architecture: riscv64 using:
>  	  - Zvkg vector crypto extension
>  
> +config CRYPTO_POLY1305_RISCV
> +	tristate "Hash functions: Poly1305"
> +	select CRYPTO_HASH
> +	select CRYPTO_ARCH_HAVE_LIB_POLY1305
> +	help
> +	  Poly1305 authenticator algorithm (RFC7539)
> +
> +	  Architecture: riscv using:
> +	  - V vector extension
> +
>  config CRYPTO_SHA256_RISCV64
>  	tristate "Hash functions: SHA-224 and SHA-256"
>  	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
> diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
> index 247c7bc7288c..0c96bd9a61b3 100644
> --- a/arch/riscv/crypto/Makefile
> +++ b/arch/riscv/crypto/Makefile
> @@ -10,6 +10,10 @@ chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
>  obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
>  ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
>  
> +obj-$(CONFIG_CRYPTO_POLY1305_RISCV) += poly1305-riscv.o
> +poly1305-riscv-y := poly1305-core.o poly1305-glue.o
> +AFLAGS_poly1305-core.o += -Dpoly1305_init=poly1305_init_riscv
> +
>  obj-$(CONFIG_CRYPTO_SHA256_RISCV64) += sha256-riscv64.o
>  sha256-riscv64-y := sha256-riscv64-glue.o sha256-riscv64-zvknha_or_zvknhb-zvkb.o

Please rebase onto mainline and port your change to arch/riscv/lib/crypto/.
Poly1305 is now available only through the library API, not the crypto_shash
API.

- Eric
