Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA001B142D
	for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 19:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773603934; cv=none; b=O5WKQHwe6I1qYEB9H2huI7SVHzY+WKK/7WqvHyafD4Wru+/oqa154l5rgBLn8sQOqKqI1zXwiJI508bUEUtMmBHCsYvlBZpNoZgoSwOlhT7jiwTrgEJtQcT5ulR57mT3A8HzhKaDyUA/VaMuvHZ53gQ/j0iPDyzo+ftNlAn/Nns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773603934; c=relaxed/simple;
	bh=Ob8njINqYFO08+qVz5ifmE6YbAl6ZnE/9DCMU/bTchw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P49JtMFKMEn8blupZfJAPHPTpnW/QZuEqXBWx0nDu43f2gemGuU3dZzUrLjCy1PsZHPPdZt26M2SL1hqFLhUOTSf8CWkWsNfhqbc6WhzPuHmAdz4zNOlcCxXTqjwVqbr/vioVWrVH+JAelT7Tf5D3/aLAkyfz3baDR9eKho9wp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=weobbS4H; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="weobbS4H"
Date: Sun, 15 Mar 2026 20:45:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773603921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gCBoo+mEV27YB5gthmuXt85o/zjrghRMDfZxPhsyaA8=;
	b=weobbS4Hv1F8ODlS8vrWdA66Ly9de1e/g6+IFwRauMqfDPzEvvQGB9UikORp9TjGoxceDy
	JJXuoMaefqyuydDUNb3E9EicVyvq/DFMUuH/qp18ZIz9jw0WEcpW1TCS+LcCdpr4ymlctI
	Q6tCYw+/ml9fVDadMvXinAU5Q59kjmU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - Fix potential UAF and memory
 leak in remove path
Message-ID: <abcMS4YYrHOF6ud1@linux.dev>
References: <20260314193627.728469-3-thorsten.blum@linux.dev>
 <abY2HdOs0768G8G3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abY2HdOs0768G8G3@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Sun, Mar 15, 2026 at 01:31:25PM +0900, Herbert Xu wrote:
> On Sat, Mar 14, 2026 at 08:36:29PM +0100, Thorsten Blum wrote:
> >
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> > index 98d1023007e3..aeadbc9a2759 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -191,10 +191,8 @@ static void atmel_sha204a_remove(struct i2c_client *client)
> >  {
> >  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> >  
> > -	if (atomic_read(&i2c_priv->tfm_count)) {
> > -		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
> > -		return;
> > -	}
> > +	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
> 
> Is it OK to explicitly call devm_hwrng_unregister?
> 
> Perhaps it's best to remove the devm management?

Yes, it should be safe since explicitly unregistering the hwrng removes
the devres entry, and the automatic devm cleanup later essentially
becomes a no-op.

Switching to hwrng_{register,unregister} is more explicit, but it would
require a bool hwrng_registered field in atmel_i2c_client_priv to keep
track of RNG registration success/failure.

Which approach do you prefer? Perhaps the smaller devm change for
backporting, and then switching to hwrng_{register,unregister} in a
separate cleanup patch?
