Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9F3126DF;
	Mon, 15 Dec 2025 07:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765783596; cv=none; b=WNKYmVsWhVvbHkLW/3zPJAy80m/2DV4sE2VLiqhVvSYQx0wfhcI/AH9I+Yg6WQRVCddeSWpzcgk8gyQhSolZ0ID7e3aItNEFuX4ORvZDba5nhZ2MlROUlwEjQJxbfnZlYUEBEO/RuUUA+y2SLvSfeRJpWycdp2CtjxiyTl2k5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765783596; c=relaxed/simple;
	bh=adTi4XQQUTGymDm5WX6G+3RmsZRhvswJ8uqLtFBbcD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4b+0G/M+HJBR2BwFVgvKuSg8lOI0855pWfA+jkb2xgDfrH2jxsE3U5OmEXcUBeMytzUTGT85cF7VNrkxOXcAfFTl+d5mN4A6isjps4ZshdDAS6UdyE6DTmANWq7S0eSI74JCjPJTPFoWoMTezSoOcQ4Bn5T38X7zBRIUzN2yZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpF2IC4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpF2IC4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC89C4CEF5;
	Mon, 15 Dec 2025 07:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765783596;
	bh=adTi4XQQUTGymDm5WX6G+3RmsZRhvswJ8uqLtFBbcD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpF2IC4S4wICHQTWovp22HK6/b8SoyK20DBohUd6xMEG/R3ZZchat3YL7ibYptPHp
	 N/deQiqZLO3f6FuOqIPar8jUlKvFUkAewQLkm8Qx5Uu94CwMpMGmn563Dn73+NY3Pc
	 hHRRb+mYKKpjkRwNZ/S03NJqrrN6HTxT8suVM6dJ6gKW7UyLdns1D59c9z3bRitQSK
	 bbTTjkyh9Fbmqm9hjAgAmESVF/veiCU1lXRfC/x1DYlBDA44ti3+6+Q1e0qR53ap1A
	 fu5TXJDLmtTIAbvspZeS45gI+G6Sv/8FHtohcAArqeHdYBzrhk3KOdVOwxig8kLEFc
	 nC2K+64DZU3iQ==
Date: Mon, 15 Dec 2025 16:26:30 +0900
From: Sumit Garg <sumit.garg@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 04/17] hwrng: optee - Make use of
 module_tee_client_driver()
Message-ID: <aT-4Ju_vgEf2JGC4@sumit-X1>
References: <cover.1765472125.git.u.kleine-koenig@baylibre.com>
 <a2560b5a16c01dc1f63437ce0d60b3ee9c7cb3b8.1765472125.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2560b5a16c01dc1f63437ce0d60b3ee9c7cb3b8.1765472125.git.u.kleine-koenig@baylibre.com>

nit for subject: s/hwrng: optee -/hwrng: optee:/

On Thu, Dec 11, 2025 at 06:14:58PM +0100, Uwe Kleine-König wrote:
> Reduce boilerplate by using the newly introduced module_tee_client_driver().
> That takes care of assigning the driver's bus, so the explicit assigning
> in this driver can be dropped.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
>

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index 96b5d546d136..6ee748c0cf57 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -281,24 +281,12 @@ static struct tee_client_driver optee_rng_driver = {
>  	.id_table	= optee_rng_id_table,
>  	.driver		= {
>  		.name		= DRIVER_NAME,
> -		.bus		= &tee_bus_type,
>  		.probe		= optee_rng_probe,
>  		.remove		= optee_rng_remove,
>  	},
>  };
>  
> -static int __init optee_rng_mod_init(void)
> -{
> -	return driver_register(&optee_rng_driver.driver);
> -}
> -
> -static void __exit optee_rng_mod_exit(void)
> -{
> -	driver_unregister(&optee_rng_driver.driver);
> -}
> -
> -module_init(optee_rng_mod_init);
> -module_exit(optee_rng_mod_exit);
> +module_tee_client_driver(optee_rng_driver);
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
> -- 
> 2.47.3
> 
> 
