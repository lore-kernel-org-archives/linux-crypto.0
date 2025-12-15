Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43269313261;
	Mon, 15 Dec 2025 07:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765783654; cv=none; b=s5dJKCKfHonb8JMiX/jYlxYcR2nGlXqkaCUZP5oSiaNBdYg1h2Mqe2HVV7FQaf9HpHBlhf6hcfl9jV88VyK1S5VosCc50yr32Nz9C2jbg2pyjXP3hbP7vgZjvbk0ceYbKmHxfo7Kk0jGgOk+vcx3jiLy/UR3wmAc4kx2K1FC4ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765783654; c=relaxed/simple;
	bh=pn4RUOECBeVYRLP+Yv3nGf565EQFyqgDPcA79qQqQkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMDy98MNAyO7/8C4yRK2Dz7KrEn5eu2sy+Raqemy8b54wWyyg2xYWUFw3Sfpghl13rn6znT7o65AnE6cVYLU8Tnl9prMoB7lturYcEcgmECEYoSgrpH91umbCxc7b8Rh5P7eIqs0ZAhsAgPE3QbjCEaXA74jcrHJqOL32jeDUvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhwv5XeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhwv5XeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A48AC4CEF5;
	Mon, 15 Dec 2025 07:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765783653;
	bh=pn4RUOECBeVYRLP+Yv3nGf565EQFyqgDPcA79qQqQkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fhwv5XeK3kHHrv6jleo/yJ23crb4Tyk3vjjiXde3HvfewyM/FyZEdRzQxsHFvKCIH
	 +g/5Tnr+AaNYeRxsrj/XLiSv9pGs72kbsGl5OsHYzUG2npx21/IWuHvXriaY1DnmUW
	 199NqQP80GYzlT4j5q5Gqxl84f8t/PwcS7JcXfJjuimIUA865J+a/u6n+Q/YWBl6+T
	 jGCTU4oy9+9iZcqTQS/TpE0U2reQ6TK3qEEwcsJcBMc4YjNVecpwGXiF+GUDaVptVg
	 +e9QRmUQ/+yq2Ag7wW0RzkUCDXZNxgjvw+wKe0AOSz38QiBCShZg+23MA9N3Fv4cgO
	 XHDbaeVzo7n8w==
Date: Mon, 15 Dec 2025 16:27:28 +0900
From: Sumit Garg <sumit.garg@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 05/17] hwrng: optee - Make use of tee bus methods
Message-ID: <aT-4YLINRTXamLfI@sumit-X1>
References: <cover.1765472125.git.u.kleine-koenig@baylibre.com>
 <83301effbb923117122f5f076edbfdad1f947386.1765472125.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <83301effbb923117122f5f076edbfdad1f947386.1765472125.git.u.kleine-koenig@baylibre.com>

nit for subject: s/hwrng: optee -/hwrng: optee:/

On Thu, Dec 11, 2025 at 06:14:59PM +0100, Uwe Kleine-König wrote:
> The tee bus got dedicated callbacks for probe and remove.
> Make use of these. This fixes a runtime warning about the driver needing
> to be converted to the bus methods.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

> 
> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index 6ee748c0cf57..5a3fa0b38497 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -211,9 +211,9 @@ static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
>  		return 0;
>  }
>  
> -static int optee_rng_probe(struct device *dev)
> +static int optee_rng_probe(struct tee_client_device *rng_device)
>  {
> -	struct tee_client_device *rng_device = to_tee_client_device(dev);
> +	struct device *dev = &rng_device->dev;
>  	int ret = 0, err = -ENODEV;
>  	struct tee_ioctl_open_session_arg sess_arg;
>  
> @@ -261,12 +261,10 @@ static int optee_rng_probe(struct device *dev)
>  	return err;
>  }
>  
> -static int optee_rng_remove(struct device *dev)
> +static void optee_rng_remove(struct tee_client_device *tee_dev)
>  {
>  	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
>  	tee_client_close_context(pvt_data.ctx);
> -
> -	return 0;
>  }
>  
>  static const struct tee_client_device_id optee_rng_id_table[] = {
> @@ -278,11 +276,11 @@ static const struct tee_client_device_id optee_rng_id_table[] = {
>  MODULE_DEVICE_TABLE(tee, optee_rng_id_table);
>  
>  static struct tee_client_driver optee_rng_driver = {
> +	.probe		= optee_rng_probe,
> +	.remove		= optee_rng_remove,
>  	.id_table	= optee_rng_id_table,
>  	.driver		= {
>  		.name		= DRIVER_NAME,
> -		.probe		= optee_rng_probe,
> -		.remove		= optee_rng_remove,
>  	},
>  };
>  
> -- 
> 2.47.3
> 
