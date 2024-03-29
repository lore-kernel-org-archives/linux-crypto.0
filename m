Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6752E1E893
	for <linux-crypto@vger.kernel.org>; Fri, 29 Mar 2024 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711735294; cv=none; b=FvZialQ/W94W5LJy7nxiWz8yZNaiXN3nPj8gJYfkgTweU4G27S1Oktz6hxaoipxx0IPsNlWyrxdPuMkuzSyTs/YwujnJlcfpND1Vj1vJe6Dmo3koZogqauOkMQKH3g9Klc1T6vPeEcPXUHPbDzZiqzhEFNbHjihZ8MwRfUn1GGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711735294; c=relaxed/simple;
	bh=LvqxXuV1GNxJpQEvil9AqskIScThttSYduLP3O9o5Ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ji7ljxJasJMiZESxR0Cp4cDhoy14E60hygl68bGBrMQNaJfS3r8GQzrcDjKk4ww85Me7LCbDDTWd6qJpzZEXEZHGY+i+rixbaaATVahzidydW20F3tbVX+m5PqvklET/S7stpG3HkDitApVT7pGqsard5+e5nXeVjfQHSHzzTEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MRBCRPU2; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MRBCRPU2"
Received: from [100.64.128.229] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 937B720E6F3A;
	Fri, 29 Mar 2024 11:01:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 937B720E6F3A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1711735291;
	bh=27Fu6mso9Fl15I5zkRRicjDC2gM9vphWAP7wExL7qQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MRBCRPU2S8CVp6u2EaBj2viy1e2XJY/Odd76HmceXOQVmr5DbWbySRyNCfMTB9Va2
	 8C7GzY6+AWiENQeU4GcL6oHHPKYywsK7I9W+7jI8PKE6gko6fCHovCkbFNhSGxDW2i
	 Q7JTi4bbS0eTyN26yBGzUjwBU8zXIqeR+dMvlyZA=
Message-ID: <9b3f0fd8-cb3b-4224-aa85-834b5bf6db66@linux.microsoft.com>
Date: Fri, 29 Mar 2024 11:01:30 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] Add SPACC Kconfig and Makefile
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
 <20240328182652.3587727-3-pavitrakumarm@vayavyalabs.com>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <20240328182652.3587727-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/2024 11:26 AM, Pavitrakumar M wrote:
> Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> ---
>  drivers/crypto/dwc-spacc/Kconfig  | 95 +++++++++++++++++++++++++++++++
>  drivers/crypto/dwc-spacc/Makefile | 16 ++++++
>  2 files changed, 111 insertions(+)
>  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
>  create mode 100644 drivers/crypto/dwc-spacc/Makefile
> 
> diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spacc/Kconfig
> new file mode 100644
> index 000000000000..9eb41a295f9d
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/Kconfig
> @@ -0,0 +1,95 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +config CRYPTO_DEV_SPACC
> +	tristate "Support for dw_spacc Security protocol accelerators"
> +	depends on HAS_DMA
> +	default m
> +
> +	help
> +	  This enables support for the HASH/CRYP/AEAD hw accelerator which can be found
> +	  on dw_spacc IP.

<snip>

Thanks for addressing this from v0. For this patch:

Reviewed-by: Easwar Hariharan <eahariha@linux.microsoft.com>

Thanks,
Easwar
