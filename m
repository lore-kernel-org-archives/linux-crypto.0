Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A93CE080;
	Fri, 29 May 2026 11:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780053954; cv=none; b=B6k86XMS2+1owmUK1caCYazL4R6b6BiCMZLWZDWFIGSi6rZxwNv4/TjJ60GJDJMWH5pQpZQVmgJd6NaYTX1ANjmNzHnsSgPA2Bpcvlaef2QDYrl7vrdrw1wNUy2I4Z/vys2wI7cGGN6k+3joEXpORpuzWzlAPdfsHXXjOF5aZNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780053954; c=relaxed/simple;
	bh=7EHFaRw46h3MHwfDroj2sMG5Yewv3cQQtGHaSPiKB8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f5xfDbgvv//jYnhDDS8P2a220/HzUdantGahc29fIOrb4Z5kVYaEExG6gxl+ny4sosmm7d8P8Z0UwYzn89nNcGVIMQuIIjS95EicUoG4wIYusm0ym6JUJOLvYoGZYDceNvBVu+SLMt/wnPIT5CToHij+vlYkGfYAdrlZBk9+Uy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUGk08rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUGk08rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808B41F00893;
	Fri, 29 May 2026 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780053952;
	bh=cCT9/jEDMQzAbzaRSGHvEjacfb8sLjxMTS+WkBZAyO0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XUGk08rhBVzoXhqwMuSpI6ODLXj2ufJKtpBFcYxlvCQ6pqpDvjtUc4eB+UP4COMNE
	 pLZ8X7qp/U1un9LPRbr8i8u+EX4VH65HlPJPm+GpespdWZqTXDnTb70fLkXS9uoY+A
	 EMKWrzPnyGy1It8iFBjo6jKWlgaTh9+foTGZe8EBYq06WSYSEj+Y3HbItL55htBa3L
	 E9X/seLfG4CPFasPSOCJ/svRDjjQLJFQ6DwqiOzQF1V8McX8s7vMGQp38g68Fb/K16
	 0IbduSK9QNDBlecAjxHilw72h5yhJ4SJCUuDY7o4Dt+Pmnhg+rc6HQkn/u7Um2iIMS
	 8qZVVLS9Di/dg==
Message-ID: <d73fe3e3-5a43-488f-ba7b-0136475861bf@kernel.org>
Date: Fri, 29 May 2026 13:25:47 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/29] crypto: talitos - Move driver into dedicated
 directory
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-2-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-2-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Move the talitos driver files from drivers/crypto/ into
> drivers/crypto/talitos/ to accommodate upcoming code
> reorganization.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/Kconfig                 | 38 +---------------------------------
>   drivers/crypto/Makefile                |  2 +-
>   drivers/crypto/talitos/Kconfig         | 36 ++++++++++++++++++++++++++++++++
>   drivers/crypto/talitos/Makefile        |  1 +
>   drivers/crypto/{ => talitos}/talitos.c |  0
>   drivers/crypto/{ => talitos}/talitos.h |  0
>   6 files changed, 39 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index d23b58b81ca3..783b5dc42a42 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -253,43 +253,7 @@ config CRYPTO_DEV_HIFN_795X_RNG
>   	  on the HIFN 795x crypto adapters.
>   
>   source "drivers/crypto/caam/Kconfig"
> -
> -config CRYPTO_DEV_TALITOS
> -	tristate "Talitos Freescale Security Engine (SEC)"
> -	select CRYPTO_AEAD
> -	select CRYPTO_AUTHENC
> -	select CRYPTO_SKCIPHER
> -	select CRYPTO_HASH
> -	select CRYPTO_LIB_DES
> -	select HW_RANDOM
> -	depends on FSL_SOC
> -	help
> -	  Say 'Y' here to use the Freescale Security Engine (SEC)
> -	  to offload cryptographic algorithm computation.
> -
> -	  The Freescale SEC is present on PowerQUICC 'E' processors, such
> -	  as the MPC8349E and MPC8548E.
> -
> -	  To compile this driver as a module, choose M here: the module
> -	  will be called talitos.
> -
> -config CRYPTO_DEV_TALITOS1
> -	bool "SEC1 (SEC 1.0 and SEC Lite 1.2)"
> -	depends on CRYPTO_DEV_TALITOS
> -	depends on PPC_8xx || PPC_82xx
> -	default y
> -	help
> -	  Say 'Y' here to use the Freescale Security Engine (SEC) version 1.0
> -	  found on MPC82xx or the Freescale Security Engine (SEC Lite)
> -	  version 1.2 found on MPC8xx
> -
> -config CRYPTO_DEV_TALITOS2
> -	bool "SEC2+ (SEC version 2.0 or upper)"
> -	depends on CRYPTO_DEV_TALITOS
> -	default y if !PPC_8xx
> -	help
> -	  Say 'Y' here to use the Freescale Security Engine (SEC)
> -	  version 2 and following as found on MPC83xx, MPC85xx, etc ...
> +source "drivers/crypto/talitos/Kconfig"
>   
>   config CRYPTO_DEV_PPC4XX
>   	tristate "Driver AMCC PPC4xx crypto accelerator"
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 283bbc650b5b..a059139d4a75 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -35,7 +35,7 @@ obj-$(CONFIG_CRYPTO_DEV_SA2UL) += sa2ul.o
>   obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
>   obj-$(CONFIG_CRYPTO_DEV_SL3516) += gemini/
>   obj-y += stm32/
> -obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
> +obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos/
>   obj-$(CONFIG_CRYPTO_DEV_TEGRA) += tegra/
>   obj-$(CONFIG_CRYPTO_DEV_VIRTIO) += virtio/
>   obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
> diff --git a/drivers/crypto/talitos/Kconfig b/drivers/crypto/talitos/Kconfig
> new file mode 100644
> index 000000000000..c3470553a966
> --- /dev/null
> +++ b/drivers/crypto/talitos/Kconfig
> @@ -0,0 +1,36 @@
> +config CRYPTO_DEV_TALITOS
> +	tristate "Talitos Freescale Security Engine (SEC)"
> +	select CRYPTO_AEAD
> +	select CRYPTO_AUTHENC
> +	select CRYPTO_SKCIPHER
> +	select CRYPTO_HASH
> +	select CRYPTO_LIB_DES
> +	select HW_RANDOM
> +	depends on FSL_SOC
> +	help
> +	  Say 'Y' here to use the Freescale Security Engine (SEC)
> +	  to offload cryptographic algorithm computation.
> +
> +	  The Freescale SEC is present on PowerQUICC 'E' processors, such
> +	  as the MPC8349E and MPC8548E.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called talitos.
> +
> +config CRYPTO_DEV_TALITOS1
> +	bool "SEC1 (SEC 1.0 and SEC Lite 1.2)"
> +	depends on CRYPTO_DEV_TALITOS
> +	depends on PPC_8xx || PPC_82xx
> +	default y
> +	help
> +	  Say 'Y' here to use the Freescale Security Engine (SEC) version 1.0
> +	  found on MPC82xx or the Freescale Security Engine (SEC Lite)
> +	  version 1.2 found on MPC8xx
> +
> +config CRYPTO_DEV_TALITOS2
> +	bool "SEC2+ (SEC version 2.0 or upper)"
> +	depends on CRYPTO_DEV_TALITOS
> +	default y if !PPC_8xx
> +	help
> +	  Say 'Y' here to use the Freescale Security Engine (SEC)
> +	  version 2 and following as found on MPC83xx, MPC85xx, etc ...
> diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
> new file mode 100644
> index 000000000000..fcc5db5e63c2
> --- /dev/null
> +++ b/drivers/crypto/talitos/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos/talitos.c
> similarity index 100%
> rename from drivers/crypto/talitos.c
> rename to drivers/crypto/talitos/talitos.c
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos/talitos.h
> similarity index 100%
> rename from drivers/crypto/talitos.h
> rename to drivers/crypto/talitos/talitos.h
> 

