Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87613BF694;
	Fri, 29 May 2026 11:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780053987; cv=none; b=coLkcLe6goZKn+LgCruUaB9+rmKVub2DZZcZZiXs5bSO8YMbDAlFV6SqNkpkzyv+8UXS1gZU3Mr8v0wzj4jqyFgOc+zZ8C7XXd0qxKDWUB0zvQj1Ui9fjF1xQCazDKYG9nXFwXb/Vt19+ezS4w/LrHdrYYcItitxRM+KydfrOTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780053987; c=relaxed/simple;
	bh=926YqM6G9eJN3OMpyhqI+ZdfUV0EMkA3LHGcx6MEwSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/PbYtNCNMRxjNWM6k1hkzmG6R6wtCMMT30bTwnzmZMj/7Xe/MuvsyelJYp2ao07nspcO1VvBwfAZmlj/TH5BIAi//JBWHQWbnjOsqKThCAHi+2k0LPPruRmdWY3wUVLSBTADdPllrCjalVQJg8/S481Hii3FoTp35EIsZwrCnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldp9pI3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldp9pI3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE641F00893;
	Fri, 29 May 2026 11:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780053985;
	bh=aqCvNq5cLHKiEq2bqnBUY6KLaWSbc9RhzXB8KkhkR1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ldp9pI3TtwATERzKs9JKhq1V0umSSFON3dg229rAR2a6G1Ue4HzR6fbLNuQ4MYrI5
	 VRxMNbbiZdlA4OWWwOiP0Ioja74zRmaBBRJ70XPRRd5WLvf+livr9xLf5TDj3RFbBZ
	 UP8EHfYQ8El7eO0MVt0BKTsln9hVM/AlfyhdhEFbk7XbRDPSLdFMKtCqW2r1oe7vog
	 ZZs6y329M4S9sz2glcu3uOCG9LNKjP0PjjKwFhW6g9vG/WMYJgsI3+JSZm+ba7Y4a6
	 uhABc7KQDGditBq7+Daj9IL4ilkqHf3i0YlRKONVWvoqbuIEzs+gpWctfKR2BNqtCG
	 YpiUuM7SqH//w==
Message-ID: <8d7daf00-4658-4525-bd53-26bae0563973@kernel.org>
Date: Fri, 29 May 2026 13:26:19 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/29] crypto: talitos - Add missing includes to driver
 header file
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-3-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-3-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Add explicit includes for types used by the header file to make
> it self-contained and fix implicit include dependencies.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   drivers/crypto/talitos/talitos.c | 3 ---
>   drivers/crypto/talitos/talitos.h | 6 ++++++
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
> index 3610d9f6d5ea..8ca587b98d92 100644
> --- a/drivers/crypto/talitos/talitos.c
> +++ b/drivers/crypto/talitos/talitos.c
> @@ -15,10 +15,7 @@
>   #include <linux/kernel.h>
>   #include <linux/module.h>
>   #include <linux/mod_devicetable.h>
> -#include <linux/device.h>
> -#include <linux/interrupt.h>
>   #include <linux/crypto.h>
> -#include <linux/hw_random.h>
>   #include <linux/of.h>
>   #include <linux/of_irq.h>
>   #include <linux/platform_device.h>
> diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
> index d4ff8d589f46..56e36a65ddcc 100644
> --- a/drivers/crypto/talitos/talitos.h
> +++ b/drivers/crypto/talitos/talitos.h
> @@ -5,6 +5,12 @@
>    * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
>    */
>   
> +#include <linux/device.h>
> +#include <linux/hw_random.h>
> +#include <linux/interrupt.h>
> +#include <linux/scatterlist.h>
> +#include <linux/types.h>
> +
>   #define TALITOS_TIMEOUT 100000
>   #define TALITOS1_MAX_DATA_LEN 32768
>   #define TALITOS2_MAX_DATA_LEN 65535
> 

