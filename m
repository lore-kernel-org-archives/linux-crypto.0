Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7002D221267;
	Wed,  3 Sep 2025 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756911236; cv=none; b=WAyd03TewjAgatE1HDb/9s/k2WTGcObiPNzujznU/0lQJXhR41E8RFRLvdtkewPLOTEz1tv4m3XgKJP7VJ0CcMxfyStW6pyl9zBFFyeuSSNNhR+gFTmyj7TaTaMhY0ufgvvOZbOdcN9eNLKUpPAwdXZeT1Z14gyeEYPLH0/36rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756911236; c=relaxed/simple;
	bh=S+jekR2+uyTg2jwBOThCtx7ZOv0IkmkxEqv6QFKCM0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SxMU7Dywyw2Ya3IOw2XiC1LQwF4bJnH+G8FlTDYF+Up3JBFTcOjUn6RcGOuMRz4piNMefEVs5uubI5popM5Nj9U9pb0qjWEqvrL2AFkj3lpYWOs3PGh/Q2+CZ3cj5a9CvhkhpLrmCkVEcY56kg0fUJV5SflNBwm7Z5b7Vupfvkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZ3iyTQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZ3iyTQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3A1C4CEE7;
	Wed,  3 Sep 2025 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756911236;
	bh=S+jekR2+uyTg2jwBOThCtx7ZOv0IkmkxEqv6QFKCM0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iZ3iyTQHOgK+qJrnupKeDX54Es3Mf2FLlXwABFAzxtT7slUltn68ewOydn8GBNtwu
	 ZnrJiGgKaz9ruICC5sqBnJ6R2sBjmMU+qteoeRccZefuPHiFW0zFTQje88UkvgyJHf
	 8ykuZgdcnmJ4hktWo0M7lWJvKAG9vxeLpl0Ykj4ngrWodzhIEWQ+a47mmnIzpFIpp1
	 INeX486R74jHuwKgddWAHt2/+MqU1tTdVArIaIuOZu+dbMyhlkYjn0kxIGR6DajDwL
	 B7UTwlycJsL0ZHKjPbPvy+iPptqnkJaVYXVW71BMMylCa2eBrrLHDVhq9R2E/+WEYp
	 l61ublx0Hx7jg==
Message-ID: <287919c7-b268-4dbe-910a-9b42d62a9094@kernel.org>
Date: Wed, 3 Sep 2025 09:53:54 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Fix incorrect return type for
 psp_get_capability()
To: Yunseong Kim <ysk@kzalloc.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250903135547.19617-2-ysk@kzalloc.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250903135547.19617-2-ysk@kzalloc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/25 8:55 AM, Yunseong Kim wrote:
> psp_get_capability() is declared as returning an 'unsigned int'. However,
> it returns -ENODEV on failure when it cannot access the device registers
> (i.e., when ioread32 returns 0xffffffff).
> 
> Since -ENODEV is a negative value, returning it from a function declared as
> 'unsigned int' results in an implicit cast to a large positive integer.
> This prevents the caller psp_dev_init() from correctly detecting the
> error condition, leading to improper error handling.
> 
> Fix this by changing the return type of psp_get_capability() to 'int'.
> 
> Additionally, change the type of the local variable 'val' to 'u32', which
> is more appropriate for register access, and reformat the long dev_notice
> line to adhere to kernel coding style guidelines.
> 
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>

> ---
>   drivers/crypto/ccp/psp-dev.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 1c5a7189631e..84dde53db25b 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -140,9 +140,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>   	return IRQ_HANDLED;
>   }
>   
> -static unsigned int psp_get_capability(struct psp_device *psp)
> +static int psp_get_capability(struct psp_device *psp)
>   {
> -	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
> +	u32 val = ioread32(psp->io_regs + psp->vdata->feature_reg);
>   
>   	/*
>   	 * Check for a access to the registers.  If this read returns
> @@ -152,7 +152,8 @@ static unsigned int psp_get_capability(struct psp_device *psp)
>   	 * could get properly initialized).
>   	 */
>   	if (val == 0xffffffff) {
> -		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
> +		dev_notice(psp->dev,
> +			"psp: unable to access the device: you might be running a broken BIOS.\n");
>   		return -ENODEV;
>   	}
>   	psp->capability.raw = val;

