Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2B133B97F
	for <linux-crypto@vger.kernel.org>; Thu, 23 Apr 2026 07:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776930972; cv=none; b=NKkvsMfwH0Qn19YRKGzn4Pl/PkXK0l+F+gh0MoBUbm7xPRaBDFT/uLePLWRuHoF8cRKuRi+Q8Wj93dcqTYFvDGdnh3BzrK9+wgnztSSBEE8XGUDJGB3Ny1hp/ptzv03wcpCNpOPDK4lPt/O8knLqlU9xl/aX3w4LYdLuqy9XY/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776930972; c=relaxed/simple;
	bh=PHq/Jmc8vV1AGYfd/0udn6Xo3Lo4AyqzA7SRU+5goRk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Yl+/i9hz963AQId2haKVv4dujkNlBBIYkQg251JmRDWLP6sT8mUxirBHHR4zyV9B939oqDqye+MPBY3LMOzUm5UeNGzfCcivzmlUK1ugDb+eiiX+tUyrLGiLI9IMvI3/5tcOEbUqAlKwPLiN9SHcX8lz+CA2yC0nHLwbmo6KFMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t7QzH/n2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t7QzH/n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAB8C2BCAF;
	Thu, 23 Apr 2026 07:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776930972;
	bh=PHq/Jmc8vV1AGYfd/0udn6Xo3Lo4AyqzA7SRU+5goRk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=t7QzH/n28vrs+i3rL1RKgBefWL4wHjuFSjS1qqJRWmTWQ1LXTJ8Bwd/La9BfMHpGu
	 8CRpeAr1gWXUKPAUYNcwj4WDrF9rFzicGpziygo+sMyn93QlcOPGo688Gx5vAPvCpB
	 JZ/B/+JntvpEZ7OkQTEvtCBiQrFYXz25Va2y7FQJ1UeytGQAfsLgprvuwNUzFrKN36
	 /etR7qeJflMkMyR66VBAtkEo6ev1ZwKCkMvptngUTirZsjqZlVlHDIbkWFdQenbFcK
	 Ie6wSlT5lnZ7VBLUWMAVUXrpcz1cDYswIYi8hr6d1FZtYE64o1Ej6cYrdxY7ZMex8G
	 37/uB4LgifqLg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id CAFA6F40069;
	Thu, 23 Apr 2026 03:56:10 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 23 Apr 2026 03:56:10 -0400
X-ME-Sender: <xms:mtDpaafyJ2kbXOHH7VFVCkOXpM7nzR8fro7d8__qKxpTFGe5zT09DQ>
    <xme:mtDpafAuhwl2UH1X7XA8jsl415tMkB8DsWp0X-joDuwgfznX12LsQqVyP4DD0-ypN
    CdiiiFe-cFhzLWi-EPMIU9odV-UAx-VmDvjLslWrv424qhJUm4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeiieeitdcutefuodetggdotefrod
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
X-ME-Proxy: <xmx:mtDpadMFLTOko9oSuo_wdq2OBTbfJVDbFIXeuRn8SLIgB1Vd_ZJ4CA>
    <xmx:mtDpaaYahF8Tsi38KYNtuWz799QJUSFCyvIGAhrLPjqGZ2DGnKFsMQ>
    <xmx:mtDpaTz7ojKwOGNcRLX_YLrtrsxc0Q0EylrbeVv8NGO5revtIEI36A>
    <xmx:mtDpaRMCXR39lQZ7gJnsyABaVqB4VAAR8o0925yzoxDswuNvALJcUA>
    <xmx:mtDpaaeTaNn6tIS2XROiafNjEne5l2lQgigOMgue6AJtUDppBkTpeny8>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A3FEF700065; Thu, 23 Apr 2026 03:56:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 23 Apr 2026 09:55:50 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Lothar Rubusch" <l.rubusch@gmail.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Thorsten Blum" <thorsten.blum@linux.dev>, davem@davemloft.net,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@tuxon.dev, "Linus Walleij" <linusw@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Message-Id: <0da8b7c6-2fb9-4a27-8f2b-a916c85185a8@app.fastmail.com>
In-Reply-To: <20260422210936.20095-3-l.rubusch@gmail.com>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-3-l.rubusch@gmail.com>
Subject: Re: [PATCH v3 2/3] crypto: atmel-sha204a - fix truncated 32-byte blocking read
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 22 Apr 2026, at 23:09, Lothar Rubusch wrote:
> The ATSHA204A returns a 35-byte packet consisting of a 1-byte count,
> 32 bytes of entropy, and a 2-byte CRC. The current blocking read
> implementation was incorrectly copying data starting from the
> count byte, leading to offset data and truncated entropy.
>
> Additionally, the chip requires significant execution time to
> generate random numbers, going by the datasheet. Reading the I2C bus
> too early results in the chip NACK-ing or returning a partial buffer
> followed by zeros.
>
> Verification:
> Tests before showed repeadetly reading only 8 bytes of entropy:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020
>
> After this patch applied, the result will be as follows:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> 00000020
>
> Fix these issues by:
> Increase cmd.msecs to 30ms to provide sufficient execution time. Then
> set cmd.rxsize to RANDOM_RSP_SIZE (35 bytes) to capture the entire
> hardware response. Eventually, correct the memcpy() offset to index 1 of
> the data buffer to skip the count byte and retrieve exactly 32 bytes of
> entropy.
>
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A 
> random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 19720bdd446d..f7dc00d0f4cd 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -19,6 +19,9 @@
>  #include <linux/workqueue.h>
>  #include "atmel-i2c.h"
> 
> +#define ATMEL_RNG_BLOCK_SIZE 32
> +#define ATMEL_RNG_EXEC_TIME 30
> +
>  static void atmel_sha204a_rng_done(struct atmel_i2c_work_data 
> *work_data,
>  				   void *areq, int status)
>  {
> @@ -91,13 +94,15 @@ static int atmel_sha204a_rng_read(struct hwrng 
> *rng, void *data, size_t max,
>  	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
> 
>  	atmel_i2c_init_random_cmd(&cmd);
> +	cmd.msecs = ATMEL_RNG_EXEC_TIME;
> +	cmd.rxsize = RANDOM_RSP_SIZE;
> 


Please fix atmel_i2c_init_random_cmd() instead if it doesn't set the right
values for these fields. But afaict, you are decreasing the execution time
here, so I struggle to see how this could explain the improved behavior.

>  	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
>  	if (ret)
>  		return ret;
> 
> -	max = min(sizeof(cmd.data), max);
> -	memcpy(data, cmd.data, max);
> +	max = min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
> +	memcpy(data, &cmd.data[1], max);
> 

This looks correct - better to put this in a separate patch.

>  	return max;
>  }
> -- 
> 2.53.0
