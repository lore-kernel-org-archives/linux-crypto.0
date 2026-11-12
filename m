Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478492;
	b=K3I3qQj6ubc9iKFXc0LZrcnxB3mSPp7RD4aTkkAGtr+3VyzQQ0IGpD31jKAYRgJ6JzMi
	 MbfzoQBuF2Ykui99fh9ojEz5JqJv/OfR3h9TcvRQTVMUKPEunH5skVgmYA7tsU60ulXdW
	 GoPp5IdMVYzjfOqfoVDW47l0Jbn0QtU0xQQ3FK1ulaBPJSRXnlx9wTOm6jG16+VuPM3p1
	 PUY2ZKHXAIq+eOxc9xKNmcWzF7uB7bAnvUPi136KtGQC5ZKxchGy1xtzfdFDaKM1RWWds
	 YxbpJ/9AJ3VptQNuiPp8vCk+vx8Mzk1YCJRTH9SyKojiqX4P9W/sTO+ky8P+fDYNhCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478492;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=IUWNCjYU5nYlUkLVeqwFijQN/43/SDcUwdjnGa0KESo=;
	b=QG+YeW51bvV7r+ztZMgjxsd0CKE7+hvza6Mgzjr1j+R+F/PH8gyKkrLvlalaJOoWJElY
	 qoJD7ZIrvFfXYHcbAgPujd+nC8RLo/9jFeFsLzOX0Y81o2isNJ3tNk+mM/5oLApQEhEEl
	 PaXsSstMDg+11ODzMOerecKyEj3A+CWiQd5JzhhFJ3nyCO6ZWl9CYx9rq+fC/LAhjGHCT
	 CV/tUPhoJLnoH6dD5I9gaJnEoxaL86Nxhz31/M+LOF4gnHgidAHRfhd9g+/BBNUZbKK17
	 aLxNhZWQ39ZmzRUw11JZUzCaFG/rF95PDzKwB2th8xd3Iorr2JyVLhKP6mS1wOpKFbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WjSHTAYd;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3524606A327;
	Thu, 12 Nov 2026 10:14:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3524606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WjSHTAYd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IUWNCjYU5nYlUkLVeqwFijQN/43/SDcUwdjnGa0KESo=; 
	b=WjSHTAYdsOmCPbbfzCqfdmzrLlIU8y4JVZMOttuGVW40MQSHnHeM0NXnMNMHK0CqtYdq/Nw7loM
	g9DcXjcQ+cSoSDx6cw2iBgGr2F1MoheeC16eykM2MVGKeYxX6BhEl5Hh6cQVcTvfBgl9RO4MSUTvG
	v4QtiQxLj/LYzASbXJSywCLp1mfv6xT0z6Zra2832Y1B3c6PPD7RS7jIZCxQMqA6r0jH5hBENcelI
	qs/VUOGwPBvhXzZ2ekieX6kGWFqFf5XFNvqT9WMkQP4Yz9U1bn/8CxG6Pbn4ii9a8fSy8xIO0C1fY
	lwF3Q9SD4nNLGtlE6/wQ1O5gKAGtipy24HHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRpP-0000000EE9f-0sjY;
	Thu, 12 Nov 2026 18:14:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:14:47 +0800
Date: Thu, 12 Nov 2026 18:14:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <blum@kernel.org>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marius Dinu <m95d@psihoexpert.ro>
Subject: Re: [PATCH] crypto: atmel-i2c - find the bus speed behind an I2C mux
Message-ID: <avWRl3HKNhkyJwTj@gondor.apana.org.au>
References: <20261029082616.53365-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029082616.53365-1-pepe.schlehofer@gmail.com>

On Thu, Oct 29, 2026 at 09:26:16AM +0100, Josef Schlehofer wrote:
> On the Turris Omnia, the ATSHA204A sits behind a PCA9547 I2C mux. The
> driver reads "clock-frequency" from the mux channel, which has no such
> property, so the probe fails with -EINVAL:
> 
>   atmel-sha204a 6-0064: failed to read clock-frequency property
> 
> A device tree patch in 2024 added the property to the mux channel. The
> review rejected it, because the I2C core ignores the property there. The
> driver would then compute the wake token for a wrong bus speed. The
> review asked for a fix in the driver, but none was sent.
> 
> Keep reading the property of the client's adapter first, as before. If
> it has none, look at the parent adapters. If no adapter has it, use
> 100 kHz, the default of most I2C controller drivers.
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Cc: stable@vger.kernel.org # v5.19+
> Reported-by: Marius Dinu <m95d@psihoexpert.ro>
> Closes: https://lore.kernel.org/all/46ea55652f8bcdef51d5c552902fd0cc@psihoexpert.ro/
> Link: https://lore.kernel.org/all/20240515104149.2ce3566e@dellmb/
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> ---
> Tested on a Turris Omnia with 7.2.13 and 6.18.59: the driver probes, and
> /dev/hwrng reads random data from the ATSHA204A. The mv64xxx controller
> stops at the address NAK, so this test does not exercise the token size.
> 
>  drivers/crypto/atmel-i2c.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
