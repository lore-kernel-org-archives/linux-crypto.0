Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA4D25B31B;
	Tue, 18 Nov 2025 03:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436909; cv=none; b=FzQBBE25MW3PehGL5L+8WgCzsUbNETSSDCkABxrM4NlVwC/zDrBFAPuaySXoYBr6Y57dzmpOwtfuJOHQ2etbpX3YzM50zj5rFpQRpCsb9Jy7SZbSnu80sSzQCjDyHeWGsHq0uzOHuiR0PJQc9wpmpiGiamk5UehxhzIUbefLY+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436909; c=relaxed/simple;
	bh=4llNktAFHmag0wadvRM3IGLwPLcCV6SYiWC/f97cN7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewMGsg9RxVuyFewyfMLMX5g0vfd/0hfPgIbkIzHArpYrEsg4xayiOq2jH7sqfTV3QRC4F4WyrvWY8hi3XLpXDgL5EnPipjrJwMB2GelmFvginn0oiT4SkORknrXJN1WJ0Stsah2LAvE4LubEhxf2JKn59kE7eqfZgGFXwtkCTK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=A+c847Zf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="A+c847Zf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kK7QyPM+ihEt5L9TAPPj7gSvSsUm69YbTMRhxbNBmpI=; 
	b=A+c847ZfkNvJ+w+yxDHiMz1/5sfjpwwiR2wVjPeGij386ELW5Fw27FB0KVE/PS1e8fLt3AmI9/a
	3ZsEB/nhSuSFtA2A7+8zH6aVAnho06jnPNOtJwHTlfJlbj+T2XWkl+TZ/mRPy057M59L/riumSPwk
	D+vYzi/ZfvNDBMgHJYSyPSDHCIc3dmhZWY6aiVe82/qDRwuq/Kh3yKu3axmL46CK3D0NF8shWBa7f
	TUlymqMTOgDWZ0ig2320rvUWrxxDGF6j0gLG8lEk1M6wzP/EPISUM9ztMCfMiuYggV1OZZOgn/nzM
	xcUqnbzXQ6CKfZ2Xk6Kw4/vbu9JcuNWy4ISA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vLCUU-003uRO-05;
	Tue, 18 Nov 2025 11:34:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Nov 2025 11:34:50 +0800
Date: Tue, 18 Nov 2025 11:34:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	larryw3i <larryw3i@yeah.net>, stable@vger.kernel.org,
	AlanSong-oc@zhaoxin.com, CobeChen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, HansHu@zhaoxin.com, LeoLiu-oc@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
Message-ID: <aRvpWqwQhndipqx-@gondor.apana.org.au>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116183926.3969-1-ebiggers@kernel.org>

On Sun, Nov 16, 2025 at 10:39:26AM -0800, Eric Biggers wrote:
> This driver is known broken, as it computes the wrong SHA-1 and SHA-256
> hashes.  Correctness needs to be the first priority for cryptographic
> code.  Just disable it, allowing the standard (and actually correct)
> SHA-1 and SHA-256 implementations to take priority.

...
 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index a6688d54984c..16ea3e741350 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -38,11 +38,11 @@ config CRYPTO_DEV_PADLOCK_AES
>  	  If unsure say M. The compiled module will be
>  	  called padlock-aes.
>  
>  config CRYPTO_DEV_PADLOCK_SHA
>  	tristate "PadLock driver for SHA1 and SHA256 algorithms"
> -	depends on CRYPTO_DEV_PADLOCK
> +	depends on CRYPTO_DEV_PADLOCK && BROKEN

It's only broken on ZHAOXIN, so this should be conditional on
CPU_SUP_ZHAOXIN.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
