Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C4129BDB3;
	Sat, 20 Sep 2025 12:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758370120; cv=none; b=iBM42WgTMV6c5LTMOciSjdvqz1hjtKKsnLfj0eRdVE5fmyZhJ5YVzmrhWLrat9yjkWtryI/2fsPKsWARTowShgsOAQZJ52jC1kVRyck/H7YYJ2uf4oksQDUsLWnBtlyfebGc+dmPvMycJKVxuwnJDTh43DXBewZQXhgPh9FyULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758370120; c=relaxed/simple;
	bh=BMbFsKqtbXZvX5VHkoWRt6rCqXiT1zR7r9GPs5T1aYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avWHln9jaJVwYYrReR5hxLYNjjV8b6JUCuiG/rHo7gVyd0qX08yqpD/gw52Izq0zbESBVNRL45cxqVmy1x3FWcX2H19vAwe7qhua6npOKDaBk+0gInLZkDoBTkU+CuewFILxQlwsOU4NDd11EfI+Fn+tyAIbE1z9qASpCrxD7zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZZJR+96o; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZZJR+96o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=XZbzbXcTQ8HlsTfTlOlwfeJt68vbv0iJz3LYo+9CXQ8=; b=ZZJR+96oh9GLkXt6zdmkPqg0UX
	Un43OzXK+NHjii7R1nc2vq/kqG3HEzuQLETLsSB2scgaAWkBt4tk6eFL8lD8RH382EKsKvNwRBSgl
	sb5o86v1IWBcvCyOxuUI3K+lFWkm+u2zmjX6CZ4sAYydNg/wvYLHFx5SRGaDR+Wm/gibakkJIbibF
	DAdeIiPJ+ZIZG5Jv6d8C9r2WI+N39Q9J5jUU+NI6PPKn4PqNLDjGJZUfXeVNGYn/LlixXtpqKzoL+
	QV4w9uBZkCdaqtnl787oPZONBncukeK3nKQO+Q2Y1qHF0HKkE+6Gwf+TvM/hUyTm4cIOXnrkt9pwz
	e0zrchzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uzwO4-006zyo-0Q;
	Sat, 20 Sep 2025 20:08:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 20 Sep 2025 20:08:20 +0800
Date: Sat, 20 Sep 2025 20:08:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] crypto: ti: Add support for AES-XTS in DTHEv2
 driver
Message-ID: <aM6ZNMR0CtDj01Iu@gondor.apana.org.au>
References: <20250910100742.3747614-1-t-pratham@ti.com>
 <20250910100742.3747614-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910100742.3747614-2-t-pratham@ti.com>

On Wed, Sep 10, 2025 at 02:46:53PM +0530, T Pratham wrote:
>
> @@ -397,7 +446,29 @@ static struct skcipher_engine_alg cipher_algs[] = {
>  			.cra_module		= THIS_MODULE,
>  		},
>  		.op.do_one_request = dthe_aes_run,
> -	} /* CBC AES */
> +	}, /* CBC AES */
> +	{
> +		.base.init			= dthe_cipher_init_tfm,
> +		.base.setkey			= dthe_aes_xts_setkey,
> +		.base.encrypt			= dthe_aes_encrypt,
> +		.base.decrypt			= dthe_aes_decrypt,
> +		.base.min_keysize		= AES_MIN_KEY_SIZE * 2,
> +		.base.max_keysize		= AES_MAX_KEY_SIZE * 2,
> +		.base.ivsize			= AES_IV_SIZE,
> +		.base.base = {
> +			.cra_name		= "xts(aes)",
> +			.cra_driver_name	= "xts-aes-dthev2",
> +			.cra_priority		= 299,
> +			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
> +						  CRYPTO_ALG_KERN_DRIVER_ONLY,

I think it's missing CRYPTO_ALG_ASYNC.

The existing algorithms seem to be missing this bit too so we
should fix that first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
