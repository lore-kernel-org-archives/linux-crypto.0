Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6293A33A70A;
	Sat, 14 Mar 2026 04:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773461910; cv=none; b=Xqo1E7uFb5y3Tt3H3K+5Wt4vG20OqUh8WVAXTLtBY6ZQqUkJ2qntIV8RfG697jAY9SWDrydmjCJNtvD7REh94D3Xs8KJ1sC8crgkA7jLVix2SKJ3pqj6GaL1YqTVpfEfAMcNIpZ0Oj+8XTwxZO6cYk1QjKBOeeVeupTExDNQnvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773461910; c=relaxed/simple;
	bh=fJznUYTq3RwWZa+fxGGn5iQIwwsCX6YKJ1NXVw8KmyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1ygsNFyiN9kqoAwKQfYMEG76ZgWIU10oxwFV2jGEtJTE81lBjQ9UlHUnvX5ZYBN6PSnsf876bjwZX398wxP0FZzMw6IHfMV3000LelOc3iQqFIuaHYyQe22feRgGSXeI8L1Qv2Tuj2Ijo+1axU6fC3cvPxauVFOwP0d8NPVq6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kBQINsA8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kBQINsA8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=beBHipiBLGBskqYpaEQxbecGZ7A9t6EKqQ5iaWL8ofU=; 
	b=kBQINsA8Ayjj9cYKT7OiAyx9CBBWNi7DUBA0dz5L/kHhshEspBsJv7ftdL6MveE6ryVUjY94SoU
	Id3V4jPhqW+J3zIrW/Oh9McM3k7Vbt/4BDxYxAoDvystUYomd5JR7AvcqJS4FvRbz35ONIJlJb8BP
	XzoFev9ocAde2PJx7qWCKE5K/yjLC9VLk6Ue2/HUDJt5t+73wh6H4jS79dtjcKvxPtq7wQ2yiouD8
	R/QBpVUwA3+9WguecFNJcykTwV3qh3fxNYHAdk7OwRPwU+rdlN7IqNl/5bJO1vNSlO/E7Smmi95bH
	rpye9GO3sOE+3Jr+ctcPg+4/rCTJBYGcQO3w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1GRb-00EKe3-0x;
	Sat, 14 Mar 2026 12:17:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 13:17:43 +0900
Date: Sat, 14 Mar 2026 13:17:43 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Lothar Rubusch <l.rubusch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix potential UAF and memory
 leak in remove path
Message-ID: <abThZ1cBEv8de9eA@gondor.apana.org.au>
References: <20260221190424.85984-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221190424.85984-2-thorsten.blum@linux.dev>

On Sat, Feb 21, 2026 at 08:04:25PM +0100, Thorsten Blum wrote:
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 0fcf4a39de27..3afad915aae3 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -190,10 +190,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
>  {
>  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
>  
> -	if (atomic_read(&i2c_priv->tfm_count)) {
> -		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
> -		return;
> -	}
> +	if (atomic_read(&i2c_priv->tfm_count))
> +		dev_warn(&client->dev, "Device is busy, will remove it anyhow\n");
> +
> +	atmel_i2c_flush_queue();

How about only checking tfm_count after flushing the queue?

Removing a device that's in use isn't really something that should
trigger a kernel warning, unless it leads to an unrecovereable
problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
