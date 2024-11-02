Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83786A930
	for <linux-crypto@vger.kernel.org>; Sat,  2 Nov 2024 10:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730542485; cv=none; b=eYJLvjCBeLeuitVgBqswpeQYCbmi2QaiTL/SQM/0PvLXEMzc4H7ZtHmoRh7ta2wimgxbgMEYLJYFoyFepWkpegyw00szZc3X4jqJ0/y3RwbmjejhKUmlsay1Neby4jzEkDig0dNbvPQk+HwObm2/BOct3tT186xjP6rqY+oqFP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730542485; c=relaxed/simple;
	bh=EiQpA+a1GecnPtKppumU6iYIeT5bT37qeJl3lqOUyTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+oZmr7TxIA86XhkB5eCWv1qXdgM2iguW5dgLSFJxVFwOcwOyQNgjUEo2V/Ps34oX1BejWgxLRCv57C7R/qrL6uACh2h8o6B3rXYeYCp308fYr3Kkl31pR26nInkHPpWRzpbHboMa7ZS/2bHxkpotNetY5F8/9ms6l2B6pknvT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Onuj0vzl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Onuj0vzl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lFWrQISqjYlwiInuiCF4BXhnJQL3/rVjjO+VpDuGzRU=; b=Onuj0vzlcR4RA7NDyGGvsDSD46
	WOGxzztUw/LTFPywhwnfJpm7vtHDjee4Ozf+C/5b1yww/2PQsXANvVYbuQoMEsGL2SJISdNOnNNig
	xvaUXuReVTtFJIR5ZV5Le+9kAYInHjqsDlUv0P4mlOv9YCttfHOz1TiaRLh0c0PXwx9/q++IutbRp
	PxweEE6bo6bo8bnDuXIeIEYD+DgMbRVUo/fglZOqrbXu2D7lGsvqlck/3b1QkpP+qwVh1o51DYfvt
	xZy3ul+utyIMEmQpV7RN8A4Qa6tBJWEA1jwtC1exHDdNBCbEM4XjGfeDYOG2lvK6JiVkz0RilLws6
	WBxxaq9w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t7B9O-00DxrY-2q;
	Sat, 02 Nov 2024 18:14:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 02 Nov 2024 18:14:34 +0800
Date: Sat, 2 Nov 2024 18:14:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: linux-crypto@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Olivia Mackall <olivia@selenic.com>
Subject: Re: [PATCH 1/2] [RFC] hwrng: fix khwrng lifecycle
Message-ID: <ZyX7ind-SnHoDt7E@gondor.apana.org.au>
References: <20241024163121.246420-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024163121.246420-1-marex@denx.de>

On Thu, Oct 24, 2024 at 06:30:15PM +0200, Marek Vasut wrote:
>
> @@ -582,15 +585,12 @@ void hwrng_unregister(struct hwrng *rng)
>  	}
>  
>  	new_rng = get_current_rng_nolock();
> -	if (list_empty(&rng_list)) {
> -		mutex_unlock(&rng_mutex);
> -		if (hwrng_fill)
> -			kthread_stop(hwrng_fill);
> -	} else
> -		mutex_unlock(&rng_mutex);
> +	mutex_unlock(&rng_mutex);
>  
>  	if (new_rng)
>  		put_rng(new_rng);
> +	else
> +		kthread_park(hwrng_fill);

The kthread_park should be moved back into the locked region
of rng_mute).  The kthread_stop was moved out because it could
dead-lock waiting on the kthread that's also taking the same
lock.  This is no longer an issue with kthread_park since it
simply sets a flag.

Having it outside of the locked region is potentially dangerous
since a pair of hwrng_unregister and hwrng_register could be
re-ordered resulting in the kthread being parked forever.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
