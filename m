From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] crypto: drbg - Use callback API for random readiness
Date: Tue, 09 Jun 2015 14:23:39 +0200
Message-ID: <3448831.Xm980FM7Uq@tachyon.chronox.de>
References: <20150609101830.GA10521@gondor.apana.org.au> <E1Z2GdB-0002mv-3N@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, andreas.steffen@strongswan.org,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46168 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874AbbFIMXv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 08:23:51 -0400
In-Reply-To: <E1Z2GdB-0002mv-3N@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. Juni 2015, 18:19:41 schrieb Herbert Xu:

Hi Herbert,

first of all, thanks a lot for your help. I have tested the patch set.

...

>  /*
>   * DRBG instantiation function as required by SP800-90A - this function
>   * sets up the DRBG handle, performs the initial seeding and all sanity
> @@ -1517,15 +1531,23 @@ static int drbg_instantiate(struct drbg_state *drbg,
> struct drbg_string *pers, if (drbg->d_ops->crypto_init(drbg))
>  			goto err;
> 
> +		ret = drbg_prepare_hrng(drbg);
> +		if (ret)
> +			goto free_everything;
> +
> +		if (IS_ERR(drbg->jent)) {
> +			ret = PTR_ERR(drbg->jent);
> +			drbg->jent = NULL;
> +			goto free_everything;

I am wondering about the error here. The Jitter RNG has in its init function a 
test to see whether the RNG really works on the hardware as there are still 
systems out there that have no high-res timer (e.g. I have seen that on old 
Android phones). If the Jitter RNG detects that the system is not appropriate, 
it will not register.

On such systems, the error here would imply that the DRBG does not instantiate 
and we have no stdrng.

> +		}
> +
>  		reseed = false;
>  	}
> 
>  	ret = drbg_seed(drbg, pers, reseed);
> 
> -	if (ret && !reseed) {
> -		drbg->d_ops->crypto_fini(drbg);
> -		goto err;
> -	}
> +	if (ret && !reseed)
> +		goto free_everything;
> 
>  	mutex_unlock(&drbg->drbg_mutex);
>  	return ret;
> @@ -1535,6 +1557,11 @@ err:
>  unlock:
>  	mutex_unlock(&drbg->drbg_mutex);
>  	return ret;
> +
> +free_everything:
> +	mutex_unlock(&drbg->drbg_mutex);
> +	drbg_uninstantiate(drbg);
> +	return ret;
>  }
> 

-- 
Ciao
Stephan
