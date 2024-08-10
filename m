Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4404409
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270946; cv=none; b=kTkrP0AIBPeUceN9rztzozowODU7eUFuDJOS7zlsKmjOgISXORTkS0JJ/OoyVGGAOrY8LxdZuLH0OBgmxPJq5o8Vaea5+YBEd2kphMHAI10SR8W/rWFWLqasDtV8bK0wp04ttAvq8DATsFScMnBpLCMH9icooDRSKW+LdJM0TqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270946; c=relaxed/simple;
	bh=RIUsss8ajisPCRsRfHd0/pGNiVXwzqff7SUWHuCDRS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UtNkyXuLzqe2pP4h8Gf1hXkRffpgc9t+BCPxvipqLUDt8Fp4rmiud9Jov1+joka3uWKSWz6s2O07De+4pUJfjB1MYjMJTS1E/2FAHNHB25DvQClGUPtX5YKfHIVGPU3mjsztj7Nv7nbPy9Y9TiTVhuicoQvLqC/RngphZD9K0S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfM6-003iqN-2A;
	Sat, 10 Aug 2024 14:22:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:22:19 +0800
Date: Sat, 10 Aug 2024 14:22:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
Message-ID: <ZrcHGxcYnsejQ7H_@gondor.apana.org.au>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>

On Mon, Jul 29, 2024 at 09:43:44AM +0530, Pavitrakumar M wrote:
> Add the driver for SPAcc(Security Protocol Accelerator), which is a
> crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> hash, aead algorithms and various modes.The driver currently supports
> below,
> 
> aead:
> - ccm(sm4)
> - ccm(aes)
> - gcm(sm4)
> - gcm(aes)
> - rfc7539(chacha20,poly1305)
> 
> cipher:
> - cbc(sm4)
> - ecb(sm4)
> - ctr(sm4)
> - xts(sm4)
> - cts(cbc(sm4))
> - cbc(aes)
> - ecb(aes)
> - xts(aes)
> - cts(cbc(aes))
> - ctr(aes)
> - chacha20
> - ecb(des)
> - cbc(des)
> - ecb(des3_ede)
> - cbc(des3_ede)
> 
> hash:
> - cmac(aes)
> - xcbc(aes)
> - cmac(sm4)
> - xcbc(sm4) 
> - hmac(md5)
> - md5
> - hmac(sha1)
> - sha1
> - sha224
> - sha256
> - sha384
> - sha512
> - hmac(sha224)
> - hmac(sha256)
> - hmac(sha384)
> - hmac(sha512)
> - sha3-224
> - sha3-256
> - sha3-384
> - sha3-512
> - hmac(sm3)
> - sm3
> - michael_mic
> 
> Pavitrakumar M (6):
>   Add SPAcc Skcipher support
>   Enable SPAcc AUTODETECT
>   Add SPAcc ahash support
>   Add SPAcc aead support
>   Add SPAcc Kconfig and Makefile
>   Enable Driver compilation in crypto Kconfig and Makefile
> 
>  drivers/crypto/Kconfig                     |    1 +
>  drivers/crypto/Makefile                    |    1 +
>  drivers/crypto/dwc-spacc/Kconfig           |   95 +
>  drivers/crypto/dwc-spacc/Makefile          |   16 +
>  drivers/crypto/dwc-spacc/spacc_aead.c      | 1260 ++++++++++
>  drivers/crypto/dwc-spacc/spacc_ahash.c     |  914 +++++++
>  drivers/crypto/dwc-spacc/spacc_core.c      | 2512 ++++++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++
>  drivers/crypto/dwc-spacc/spacc_device.c    |  340 +++
>  drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++
>  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
>  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
>  drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++
>  drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++
>  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++
>  15 files changed, 8355 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
>  create mode 100644 drivers/crypto/dwc-spacc/Makefile
>  create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> 
> 
> base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
