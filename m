Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F4C4B66C0;
	Mon, 31 Aug 2026 16:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192500; cv=none; b=dr3AZWaCXmZ+S2wAKULeZEk9gSQmnqhcdA+KfGM4lP+mStFVtInvRSrm1APsMNIxgt9NV5WMwbQ2Vc0e7iqzROcboaF1iF79FR04GH9LhSdJMZlY6irLR08+XGPLibILu1O/87i31dIRJGGhCQ5THSxXKXuN/+rEWWhFd2iiq6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192500; c=relaxed/simple;
	bh=g2MWSvgJvrHUzfntfew8lZZFVuCLmWFpnGqNc5dkZnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTEt2hbZQVJJnHUfELkEloFwwl7GfAkqhX8NO88iaeugiYuaphEe7SbwZ4a+dyvaA3ECF3tjORD4mbPxEKojxuZ7jVPlZk1BNdDaXnL2Zc8KS5n36PGDpw5Qs5IjrLAvWLWYyIAb2/K45MuwJA3r+xxV2Zt3ZlYn3ffqxC9VUxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jB0K7jLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jB0K7jLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1431F00A3F;
	Mon, 31 Aug 2026 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788192498;
	bh=g0pH1l1rU3YbRFeShfY4wk3U3HqcGAKn/fA6tlZNaT0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jB0K7jLAWxn+ZauhusyY00+9E7LfQBFWIMV86Gp7LrehHLUieXfteqjVEnQqgYG6H
	 +ojF//piOKCjTfjR4tXN0Ck/zFqUZYrF1cC6cz19llE4oHTHQAqVAIellULpmjKpgK
	 WagCKTeo/JYdqc332H7afVZiXOxAKQoOhjGRERvrfk2+S8R+NEtdmPtJmlgMXj0cd3
	 UIqFfAS/HXbHh9m3+I+AY3aMvIev8+46fAyy1kHqx7MpH82dl12L1XRYA32oSNVP7V
	 LIZWfCJlU3grNuxgTlKLckibI595v49ySbQiDmSXDy5Ij3NP02+KXTfVioiI+47Xze
	 Sj5qRWl/taxZg==
Message-ID: <7f2bbcf7-ed00-4872-bdef-c07010f5dfad@kernel.org>
Date: Mon, 31 Aug 2026 11:08:17 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: ccp: Initialize DBC ioctl mutex before
 registering device
Content-Language: en-US
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
 <20260830015104.2040153-1-runyu.xiao@seu.edu.cn>
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20260830015104.2040153-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/26 20:51, Runyu Xiao wrote:
> dbc_dev_init() registers the DBC misc device before initializing
> ioctl_mutex. Once misc_register() publishes the device, userspace can
> open it and invoke dbc_ioctl() while the mutex is still uninitialized.
> 
> Initialize ioctl_mutex before calling misc_register() so the published
> ioctl callback always sees an initialized mutex.
> 
> Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260829133410.1708684-1-runyu.xiao@seu.edu.cn/
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> Assisted-by: Codex:GPT-5
I mean my tag to come here, I didn't realize this was threaded with V1 
and V2 together.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
> v2:
> - Move mutex initialization before setting up the misc device, as suggested
>    by Tom Lendacky.
> 
>   drivers/crypto/ccp/dbc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
> index 410084a9039c..4db49a14550c 100644
> --- a/drivers/crypto/ccp/dbc.c
> +++ b/drivers/crypto/ccp/dbc.c
> @@ -235,6 +235,8 @@ int dbc_dev_init(struct psp_device *psp)
>   		goto cleanup_mbox;
>   	}
>   
> +	mutex_init(&dbc_dev->ioctl_mutex);
> +
>   	dbc_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
>   	dbc_dev->char_dev.name = "dbc";
>   	dbc_dev->char_dev.fops = &dbc_fops;
> @@ -243,8 +245,6 @@ int dbc_dev_init(struct psp_device *psp)
>   	if (ret)
>   		goto cleanup_mbox;
>   
> -	mutex_init(&dbc_dev->ioctl_mutex);
> -
>   	return 0;
>   
>   cleanup_mbox:

