Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CAC30F523
	for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930244; cv=none; b=Gh35Xh3D0UnFtj+QHbnx/qFdq1bwkddfIIlPmEAgyfpagms78sV2m+ZYguBIGJjxZdqmna7bvdYFKUpa1GNho+6MDkzzvoo2+tr0FBRO2PcpuobPl8cE5MYnQEfKUjYkYf00cDlwlH0OX/dCHlw9gopGejLLRTYnBLCg8uN4DR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930244; c=relaxed/simple;
	bh=MCRxmX+7Rn0178cBHjmWTp4E/ZXOEC2teYbpMJgEJTI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=lgk691zbBEsgUV9qzwGM3rsuQ+9BAf3x8RLk+/7FQJtDSfEXp7qQuhB7hq7QCHubpCLt5gabeFbtmFUhVR8x43IXhP2lMjx8WOaPFrpkbWunO41jMw7IdSHu3q73mPpESjfBQYmim09p7gbWTZ1REDQwnQuJsSih2cA6ZC+es4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcXtv4Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcXtv4Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68A8C2BCB2;
	Thu, 23 Apr 2026 07:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776930244;
	bh=MCRxmX+7Rn0178cBHjmWTp4E/ZXOEC2teYbpMJgEJTI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=JcXtv4GcOcDEYvcZ5Zr1Od1l+tKOhQuALhVupqfd9opyjJDpAmHRD6lKiMsRTWggz
	 cI7HEOTTcFWMB4zzWW/x57Tw0I9CCK9JcCsbf5javkElZruZYEqqDKr0wzzj9UI2Eh
	 oQe9VRs6kjRZAzAEdXi/atZWpVWRUGV26Z8foiNkF/4Qla64ICTFbmUF896Pp79Otj
	 tfKHpGmPMxHOhFDo/1O4BSNNLbK+mtd2aQbdgkz77ne+m2yLz/z7sjIXm5milZMl/K
	 Yx4q2897eCI4ZPuLV5hMMPnK7sZsEgxZQiigzDCRC3f8MhLwcGF3aJLM7ztvzCWrrp
	 bY1ltyz5olBPA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BFFCCF40069;
	Thu, 23 Apr 2026 03:44:02 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 23 Apr 2026 03:44:02 -0400
X-ME-Sender: <xms:ws3pabDdyS12W8CEM64ur_syQdKwfSZQy8oH6YL7Pd0KUOU0Dy69NA>
    <xme:ws3pacVX7rXkLJBzG94yP6hRDUxPSWa8duH7dJR3bP4riHK74Ql4dcfGouMlSZjWw
    SEOcHBJXlT_hca8iOqXxBzCalJTZvHjlEPMf6bM-vXFYNC1bAs7ISBX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeiieehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrlhgvgigrnhgurhgvrdgsvghllhhonhhisegsohhothhlihhnrdgtohhmpdhrtg
    hpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehlrdhr
    uhgsuhhstghhsehgmhgrihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonh
    guohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehlihhnuhhsfieskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumheslhhinhhugidrug
    gvvhdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhn
    fhhrrgguvggrugdrohhrghdprhgtphhtthhopehnihgtohhlrghsrdhfvghrrhgvsehmih
    gtrhhotghhihhprdgtohhmpdhrtghpthhtoheptghlrghuughiuhdrsggviihnvggrseht
    uhigohhnrdguvghv
X-ME-Proxy: <xmx:ws3paQ6aA68g9Jtp9q47zXTKqwH0VYUcFfFvBJkJMw5b6cOLTY8yjw>
    <xmx:ws3paaD91xQXBkuYTj0Pbg7RgnUjLQOSGT8JqIZbC4hsUEWocinupw>
    <xmx:ws3pae_K7UYcR4YBiJhEtCv8ANYy2Jy6XSwpijxnAhxhbfZKAcKkhw>
    <xmx:ws3paVGgUIA_vjy9gEqQ2p9XzM3s71gDcNl0DWRLQjckYros6Ynxkg>
    <xmx:ws3paQQq-ZdGCP8yLE-1MLreN58G4nvVDMbIjIU2KvxJfIJ6tNhANC4q>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9647E700065; Thu, 23 Apr 2026 03:44:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Apr 2026 09:43:42 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Lothar Rubusch" <l.rubusch@gmail.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Thorsten Blum" <thorsten.blum@linux.dev>, davem@davemloft.net,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@tuxon.dev, "Linus Walleij" <linusw@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <81feaa5f-3f66-40f0-be83-d6efcb6271bf@app.fastmail.com>
In-Reply-To: <20260422210936.20095-2-l.rubusch@gmail.com>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-2-l.rubusch@gmail.com>
Subject: Re: [PATCH v3 1/3] crypto: atmel-sha204a - fix memory leak at non-blocking RNG
 work_data
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Lothar,

On Wed, 22 Apr 2026, at 23:09, Lothar Rubusch wrote:
> The driver allocated memory for work_data in the non-blocking read
> path but never free'd it again. After first read-out the memory pointer
> seemed to be recycled and never was allocated again, due to some errors
> in the logic, so that the leak was not growing.
>

Why can't we just reuse the work_data, instead of alloc/freeing it every time?

> Add kfree(work_data) in the completion callback on error. then add
> kfree(work_data) after the data is consumed in the subsequent read
> call. Finally ensure atomic_dec() is called only after the data has
> been consumed or an error occurred to prevent race conditions.
>
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A 
> random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 43 ++++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/crypto/atmel-sha204a.c 
> b/drivers/crypto/atmel-sha204a.c
> index dbb39ed0cea1..19720bdd446d 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -25,13 +25,17 @@ static void atmel_sha204a_rng_done(struct 
> atmel_i2c_work_data *work_data,
>  	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
>  	struct hwrng *rng = areq;
> 
> -	if (status)
> +	if (status) {
>  		dev_warn_ratelimited(&i2c_priv->client->dev,
>  				     "i2c transaction failed (%d)\n",
>  				     status);
> +		kfree(work_data);
> +		rng->priv = 0;
> +		atomic_dec(&i2c_priv->tfm_count);
> +		return;
> +	}
> 
>  	rng->priv = (unsigned long)work_data;
> -	atomic_dec(&i2c_priv->tfm_count);
>  }
> 
>  static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void 
> *data,
> @@ -42,31 +46,36 @@ static int 
> atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
> 
>  	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
> 
> -	/* keep maximum 1 asynchronous read in flight at any time */
> -	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
> -		return 0;
> -
> +	/* Verify if data available from last run */
>  	if (rng->priv) {
>  		work_data = (struct atmel_i2c_work_data *)rng->priv;
>  		max = min(sizeof(work_data->cmd.data), max);
>  		memcpy(data, &work_data->cmd.data, max);
> -		rng->priv = 0;
> -	} else {
> -		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
> -		if (!work_data) {
> -			atomic_dec(&i2c_priv->tfm_count);
> -			return -ENOMEM;
> -		}
> -		work_data->ctx = i2c_priv;
> -		work_data->client = i2c_priv->client;
> 
> -		max = 0;
> +		/* Now, free memory */
> +		kfree(work_data);
> +		rng->priv = 0;
> +		atomic_dec(&i2c_priv->tfm_count);
> +		return max;
>  	}
> 
> +	/* When a request is still in-flight but not processed */
> +	if (atomic_read(&i2c_priv->tfm_count) > 0)
> +		return 0;
> +
> +	/* Start a new request */
> +	work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
> +	if (!work_data)
> +		return -ENOMEM;
> +
> +	atomic_inc(&i2c_priv->tfm_count);
> +	work_data->ctx = i2c_priv;
> +	work_data->client = i2c_priv->client;
> +
>  	atmel_i2c_init_random_cmd(&work_data->cmd);
>  	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
> 
> -	return max;
> +	return 0;
>  }
> 
>  static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
> -- 
> 2.53.0
