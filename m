Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3381814F7F
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 05:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703739; cv=none; b=JHYgw+s9x3pe8DgOva1zQ56WnWPRsVJJj0pw0iQ14OsQbm//ql7lWkv7jgsthQM10hTUhpS9+nsyhs6EDx3lSO1CCcQNgU0QV5O00QxxUQuNfFnUAs8RGz9vVtLOQE/uhMpxFRsTOTYMNwlXI6N34BdnsDHBcrMMzGTXdn4oa+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703739; c=relaxed/simple;
	bh=6T1eJxlOvdt1RGWvo1crGDC6OxBpzRLSiVSPp5fupKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rz4bmRpluyZeW3M256oziYhj9c3YpcPeoHh0MW5tNHBnRbgfCtlS1rByNPCfZTiHyrcXVzHRE5QS4ZA95uzN1/OY2BnXqQcqBY/BRd6kP0c0nUwFNLoV1C1oZIR4Q4DXP18FUuZiaSO+U4WKs5FrHK/IXyhREvhPg1/il0vW7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=aP/InSKH; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="aP/InSKH"
Received: from [100.64.0.113] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 583DC20B74C0;
	Tue,  5 Mar 2024 21:42:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 583DC20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709703737;
	bh=yosQRYFyEjGDT5PoXsxRw5zcgZw42Mcdq8G8o6TrH3U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aP/InSKHY3Gd8YIElSFEaoF2t3RNWIsKmImdVSyGzum7gFoO48ZykZbqqvO1xmATQ
	 DiRdg89Kb4e6xklMy/w2+B7C52J/KYuhhhIS8yt7nOkT5lz1N+uV5SE3rsQHYsFRdj
	 ytEje5sXB351s2OqNgZxdtbWr+qbVjL4mYg35LyI=
Message-ID: <820315ee-eb76-4444-bdad-b1e353cfce48@linux.microsoft.com>
Date: Tue, 5 Mar 2024 21:42:16 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] Add SPACC Kconfig and Makefile
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
 herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
 shwetar <shwetar@vayavyalabs.com>
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
 <20240305112831.3380896-3-pavitrakumarm@vayavyalabs.com>
Content-Language: en-US
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <20240305112831.3380896-3-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/2024 3:28 AM, Pavitrakumar M wrote:
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
> index 000000000000..6f40358f7932
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/Kconfig
> @@ -0,0 +1,95 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +config CRYPTO_DEV_SPACC
> +	tristate "Support for dw_spacc Security protocol accelerators"
> +	depends on HAS_DMA
> +	default y

<snip>

Why is the default y rather than n or m? I would prefer it to be a module, but I just want
to understand why it was chosen to be default compiled in.

Thanks,
Easwar

