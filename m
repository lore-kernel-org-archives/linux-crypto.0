Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A417C;
	Sat, 25 May 2024 00:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716595599; cv=none; b=r5mq0uAnWheWFsn+HGW1JAZXj5UVLPTyne29sx3KPMnwSY4xwAbmLasOmb0+qL4qzSIkikxjx/Sgw2PBBNSYAmHISIkh2SIkJyeoQgh9ag/WRjheRwC4iZJ+HKp+a7qunA8OFcjDzNHrXKmWDv7M1nQoNf7PmyXoOX90nI4PGOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716595599; c=relaxed/simple;
	bh=EWhgYpCmMrxcuZJ4sW5ipw3sluGXwaCAXLbNAXNrLAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BtIqoOljmioWwz+b8QwlfDIVMZ11iGbFi9bdJ3Us7Eu3m4T/xa3PUQb5u41OROP2/UauEjw/LlSzQ6TmEps82Y6HH7kd9LZc8Tk3GLRouCYoI0rK/CiOFrvm+pqNnYa/BWPxOMN1o1cmaPwVTQgo/V++nn0MX66vL30hnJhRiU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=fMh6PVJC; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="fMh6PVJC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=RilHObJtsLbJvm703RNoBG1z8cyUp2+3mrHjFWX/xMY=; b=fMh6PVJCDdu7SPWF
	t2RPFrBcpC4haU23a8F0mKA/9YVDIdecePAIwSECmNNfhzQmDpz0y7cfnyGs19Jl0plhvKf0BLHZF
	n43+82lZP25yvyPtWQ+xdah+qYbnRw7Ob4h4BnvZBjaocDN+ODSe84SKJPP1fjEN8PCqJkI6gTNwt
	nGMoE5I0mbbSx/gr8lHegf4p09Gh/yLJI8j6yGATzOSrt7x0H40ZYY92NmWdKX/JPKdkje8wtH2fd
	V8TR4DHQKONEYLZeoJI4Yk87RbKwASpbbhao3vSNy+U0QQt3blxtzGkesdmFIsS18sfRmdpZ1/hkq
	YtiFniWykfdK5Hka6g==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sAevg-002TPm-03;
	Sat, 25 May 2024 00:06:32 +0000
Date: Sat, 25 May 2024 00:06:31 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: jesper.nilsson@axis.com, lars.persson@axis.com
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: acix: Remove unused struct 'dbgfs_u32'
Message-ID: <ZlErh687UaEjCkIV@gallifrey>
References: <20240511145017.226166-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240511145017.226166-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 00:05:01 up 16 days, 11:19,  1 user,  load average: 0.01, 0.02, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'dbgfs_u32' appears unused.
> Remove it.
> (pdma_stat_descr is also unused, but I'm assuming it's
> some useful layout description of firmware/hardware
> so best left in)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping.

Dave

> ---
>  drivers/crypto/axis/artpec6_crypto.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
> index dbc1d483f2afa..75440ea6206e2 100644
> --- a/drivers/crypto/axis/artpec6_crypto.c
> +++ b/drivers/crypto/axis/artpec6_crypto.c
> @@ -2811,13 +2811,6 @@ static struct aead_alg aead_algos[] = {
>  
>  #ifdef CONFIG_DEBUG_FS
>  
> -struct dbgfs_u32 {
> -	char *name;
> -	mode_t mode;
> -	u32 *flag;
> -	char *desc;
> -};
> -
>  static struct dentry *dbgfs_root;
>  
>  static void artpec6_crypto_init_debugfs(void)
> -- 
> 2.45.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
