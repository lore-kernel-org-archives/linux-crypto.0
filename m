Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A2742CB17;
	Mon, 31 Aug 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192449; cv=none; b=oCc/EDP3tWugdCFbiaRwUc5eJwL4C+WlI/5QEjnEriJg//EdX891cRthJ7vPLefR6vE13NmFQsHAD27FHwQE0C1th0+8ccayY7DJi70fOMRQRhYbuQY2EFPuIUMxMVXMUXGqH29tm3h27OM3COYSV9a7PA+oaeeVJO/Gc3ioRBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192449; c=relaxed/simple;
	bh=+mqEIaFkSnAoTdUfTipqz7jrFh37VKaHKMg5peWRlzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lz/uHqmoL13GmO8qc7z+t3QHft9Aw0TYGtPWKPeK6fVlNikvGa5kKpF0cQnSa3Z4/2BXw7WJaK8i6TSc0TQkiPHdSDQ6kPPLg2LqI9duhyONG7UFLd/D8K6XafbTlesdzPVqFqCR7+s/0VjuNp0FcKyB24x4HWum76sXUck6c5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOJjzQ6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOJjzQ6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F791F000E9;
	Mon, 31 Aug 2026 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788192447;
	bh=QsymUVOlLWdbMs3U8vbHRLpHZaTC8N2ii/4bbuq6xAM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iOJjzQ6TMi0CDTWfbW4L5+v2mTl5BgxcpyLwVgMt8x8E9HOG9m1B8/jeZaxeXQ+4e
	 buNyajoWPVZIFXaP46sjjVv/m3wj5qoaFiqF0InlWVrrToi3084F4j0O3c40XO1ukf
	 H0OxYHbONq3r5b93FR2lqBCLILiJNrmnKgyiMJqqArCAyOKV4+/1XMh8jE0AeDzKYN
	 wmeuBqv+fkEF+ZtSKDIwt3QNHoE2jZgKDYu/pmGDn9uN9th5bSU+7OTR3n+zT3ved9
	 irxRw2tjkjp1/Yl7Fs+DrFbAqo7Huj+ElY8Dgs09h1PFUU0O1xJgmMaoyj5dpMcih/
	 F0GG/nLTjpy7A==
Message-ID: <6c11e637-9719-47d2-9257-47d5b921129d@kernel.org>
Date: Mon, 31 Aug 2026 11:07:25 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: Initialize DBC ioctl mutex before
 registering device
Content-Language: en-US
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: jianhao.xu@seu.edu.cn, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/26 08:34, Runyu Xiao wrote:
> dbc_dev_init() registers the DBC misc device before initializing
> ioctl_mutex. Once misc_register() publishes the device, userspace can
> open it and invoke dbc_ioctl() while the mutex is still uninitialized.
> 
> Initialize ioctl_mutex before calling misc_register() so the published
> ioctl callback always sees an initialized mutex.
> 
> Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
> Cc: stable@vger.kernel.org
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> Assisted-by: Codex:GPT-5
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
>   drivers/crypto/ccp/dbc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
> index 410084a90..00c864413 100644
> --- a/drivers/crypto/ccp/dbc.c
> +++ b/drivers/crypto/ccp/dbc.c
> @@ -240,12 +240,12 @@ int dbc_dev_init(struct psp_device *psp)
>   	dbc_dev->char_dev.name = "dbc";
>   	dbc_dev->char_dev.fops = &dbc_fops;
>   	dbc_dev->char_dev.mode = 0600;
> +	mutex_init(&dbc_dev->ioctl_mutex);
> +
>   	ret = misc_register(&dbc_dev->char_dev);
>   	if (ret)
>   		goto cleanup_mbox;
>   
> -	mutex_init(&dbc_dev->ioctl_mutex);
> -
>   	return 0;
>   
>   cleanup_mbox:

