Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E743D994;
	Thu, 23 Apr 2026 07:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931026; cv=none; b=HQBziIsVsvJhvVn9XdkuLA89TKzIz0M3DeThjm1RmDYVh44dGpSTxqJRxzt2Q6UET1uXWDKhxYbpTuwsdXahfHdobb2RiUZwWR0e7a8NKJsCdS3MiOlh+eUy5ZHLsHurxAZfNntT5wsKjyNCkAH7anm1GlI7GTvG04TinUYwMsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931026; c=relaxed/simple;
	bh=rde83I2Ib+S3G9tlWBa7R9Z2TIsgb5yXSMuw/2Hc87w=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=TBquW9T3zfQJK8m8FsW/UYIpUeyiUIqos0TML/vI9xsbrGHPhhwgsLE0ZI4a7uV5PGdoG7VwaiGMyphxkj5s2NCE+ji0EocKOeeujgcc8eFEgPE8OdZKRpbC61LuSTu/NTJZUq0ryJ2/BfLvBimP0sT1GP5iA7nm8LeQRwrDthE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cycOqC3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cycOqC3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9590AC2BCB2;
	Thu, 23 Apr 2026 07:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776931026;
	bh=rde83I2Ib+S3G9tlWBa7R9Z2TIsgb5yXSMuw/2Hc87w=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=cycOqC3MxQO5a9vy9aFVxJRXie2CvuUQe6gqXcDhpygndIVs4BmlKevQguio4/0MO
	 61Kxq5jXxcSN/qTrIvQObH3OSgXBvDKKOQG/j3a8J06tnj+IqmgOYwa5h8WYW+iIuc
	 gvEJuX6lWZEX6B/Pmw95rN3rqGw8HurscsA9Xt+yzPk2lNgX4qof5gkSssmCKTo3Nu
	 e1MfL3GYSpBFSox/W/8Vru5a5Fo4BQ4cMjJAR70tfV2cQSO/BWBksZIvkWiVcpsozd
	 4IBtSCDKG3hjCkvtD0mAcacgm/H4hynYgkqBW6FJe1yAWlKLqWTuRmdWtrET4HXHkn
	 N58HhJnmJBQPw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id A888BF4006B;
	Thu, 23 Apr 2026 03:57:04 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 23 Apr 2026 03:57:04 -0400
X-ME-Sender: <xms:0NDpadyaSdXjeciFtxGcgN3T5_3xlLrtCaDch4N-CZRrvYFqpsHthg>
    <xme:0NDpaYFr11coyxe4jSxYa_HPwJlVMf20azMZJ3Nr88_Sejy2b16EkxOBn85Q52fZv
    Jdr6-G-LDaEgcy4C_wrgBnOqq1QL2WSpgLRY23aZDkrDUcJ_N4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeiieeiudcutefuodetggdotefrod
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
X-ME-Proxy: <xmx:0NDpaVqnhChLo-R4wQt5RnnKclckhH2Gt74Q9QV87PheWkUx9zDchQ>
    <xmx:0NDpafzuzOxDrNkqYLHKTXx33I-2j3KbpjkaysSRAVfOTAoUQ83Sgw>
    <xmx:0NDpaRs34ZOWJJ2WF2tIBqEQSIO4jev80Y8o3rLaHkfEK2guNZXwXA>
    <xmx:0NDpaQ03tddDwDT-xwonfl8Pb4QWJ5yqhg7_6YvgHlPcdEjbiAC17Q>
    <xmx:0NDpaRBAiird2vxrcV4sUmRK-9c9st0TT6cTJIF6xaX8etpWaHvPHjK9>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7DFE570006B; Thu, 23 Apr 2026 03:57:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Apr 2026 09:56:44 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Lothar Rubusch" <l.rubusch@gmail.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Thorsten Blum" <thorsten.blum@linux.dev>, davem@davemloft.net,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@tuxon.dev, "Linus Walleij" <linusw@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <9fe57e89-ca52-4062-976f-5a91a9617680@app.fastmail.com>
In-Reply-To: <20260422210936.20095-4-l.rubusch@gmail.com>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-4-l.rubusch@gmail.com>
Subject: Re: [PATCH v3 3/3] crypto: atmel-sha204a - fix non-blocking read logic
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 22 Apr 2026, at 23:09, Lothar Rubusch wrote:
> The non-blocking path was (also) failing to provide valid entropy
> due to improper buffer management and a lack of hardware execution
> time.
>
> Ensure cmd.msecs (30ms) and cmd.rxsize (35ms) are initialized before
> enqueuing the background work. Fix the data offset to skip the
> 1-byte hardware count header when copying bits to the caller. Correctly
> return 0 (busy) to the hwrng core while hardware execution is in
> progress, preventing zero-filled buffers, which was the situation
> before.
>
> With this fix applied, tests will look similar to this:
> $ socat -u OPEN:/dev/hwrng,nonblock - | head -c 32 | hexdump -C
> 00000000  23 cc 42 3c 90 b1 38 fc  54 37 35 4b 09 c5 e1 0d  
> |#.B<..8.T75K....|
> 2026/03/23 14:30:18 socat[858] E read(5, 0x55be363000, 8192): Resource 
> temporarily unavailable
> 00000010  73 3b af d9 02 70 76 bd  2d 59 4b 12 01 ac ae 2b  
> |s;...pv.-YK....+|
> 00000020
>
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A 
> random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/atmel-sha204a.c 
> b/drivers/crypto/atmel-sha204a.c
> index f7dc00d0f4cd..04cbf80c1411 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -33,7 +33,6 @@ static void atmel_sha204a_rng_done(struct 
> atmel_i2c_work_data *work_data,
>  				     "i2c transaction failed (%d)\n",
>  				     status);
>  		kfree(work_data);
> -		rng->priv = 0;
>  		atomic_dec(&i2c_priv->tfm_count);
>  		return;
>  	}
> @@ -49,20 +48,19 @@ static int 
> atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
> 
>  	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
> 
> -	/* Verify if data available from last run */
>  	if (rng->priv) {
>  		work_data = (struct atmel_i2c_work_data *)rng->priv;
> -		max = min(sizeof(work_data->cmd.data), max);
> -		memcpy(data, &work_data->cmd.data, max);
> +		max = min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
> +		memcpy(data, &work_data->cmd.data[1], max);
> 

Please combine this with the buffer size fix in the previous patch.

> -		/* Now, free memory */
> +		/* Free memory and clear the in-flight flag */
>  		kfree(work_data);
>  		rng->priv = 0;
>  		atomic_dec(&i2c_priv->tfm_count);
>  		return max;
>  	}
> 
> -	/* When a request is still in-flight but not processed */
> +	/* If a request is still in-flight, return 0 (busy) */
>  	if (atomic_read(&i2c_priv->tfm_count) > 0)
>  		return 0;
> 
> @@ -76,8 +74,14 @@ static int atmel_sha204a_rng_read_nonblocking(struct 
> hwrng *rng, void *data,
>  	work_data->client = i2c_priv->client;
> 
>  	atmel_i2c_init_random_cmd(&work_data->cmd);
> +
> +	/* Set the execution time for the RNG command (from datasheet) */
> +	work_data->cmd.msecs = ATMEL_RNG_EXEC_TIME;
> +	work_data->cmd.rxsize = RANDOM_RSP_SIZE;
> +

Again, this is either redundant or wrong.

>  	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
> 
> +	/* Return 0 to indicate 'busy', data will be ready on next call */
>  	return 0;
>  }
> 
> -- 
> 2.53.0
