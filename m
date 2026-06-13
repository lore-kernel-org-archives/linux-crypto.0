Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D873D669A;
	Sat, 13 Jun 2026 12:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781353753; cv=none; b=DtyDotKu7iFuvcikgaMSWinKFt05W+LlXbUMmmEiZKAIqMBbCyKZ3RRAIfKCJRKA/zArlJJxmgNoxNMqho0j3OP9jOY+oSTfJLpXrE9j5hH8Q2Ru4T0hgGr087WpI+ZBAcfNtj/8RplsbU2xtHjXRCSmCPIseTv08zwLXrBUZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781353753; c=relaxed/simple;
	bh=wFy8i4VQXo4StAkBrDpNqkuZlG9kB4zIBj9OzX6F7nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtQPhuq+5oGcswW80nfrBF68iz8rgT2kTacWYo7OVG2HIa2hneabdFze8F7q2QEa3gDdSTNembtXrr7AWtjeTlDUIq+2zpz9yISp2ySU53aHGECzFfuJ0DP8zyaVD9N0TNkTbUiqZznxyjgEZLGSVWtce/CYhyJDVZENcncvX7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=che4SGPa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="che4SGPa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GxijQ4qpfDULLQ1Xsrny5C+qoSql1IUBsYrdNOivA8E=; 
	b=che4SGPaJaiilM1J5bMsq8iWAhQO7OqxES4kOevvP9bh5FVFLtsp907ihv/m0tEpv/MjckGcnc6
	9uSqtDXTtQtNDzMopuKetrn5Ms5kfSLBOcvg0QXmlT07JdggbS6yBTU4UZS4vVimbwpr+yahdPAxX
	xnZv1433Jm+RABhs8u/FEKVy5r2umxHdjS8Nf0HUIx5SjnGhq2XrIOVQnNhAwDUqQyYiNirNs0GQX
	jcmn2B6hQM07EI/RMAhIFbrvhhecsP3eA8dJ6O/8ntSnLtyWolT3S1dS/iVtyjsZewcJ2kbvqQIEi
	ihtyNtjkGeNKrSl13aMSWidvW6SEN3rFXKeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wYNTg-0000000595r-3sio;
	Sat, 13 Jun 2026 20:28:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Jun 2026 20:28:44 +0800
Date: Sat, 13 Jun 2026 20:28:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: thorsten.blum@linux.dev, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, krzk+dt@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] crypto: atmel-sha204a - fix heap info leak
 on I2C transfer failure
Message-ID: <ai1M_OqDfwMRlcyU@gondor.apana.org.au>
References: <20260609094723.47237-1-l.rubusch@gmail.com>
 <aipAf_uZnX_gwZnl@gondor.apana.org.au>
 <CAFXKEHYcp-0+uCA47mtDe_+LUAZucEPbDJzoh5+e3Q3R20mN9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFXKEHYcp-0+uCA47mtDe_+LUAZucEPbDJzoh5+e3Q3R20mN9Q@mail.gmail.com>

On Sat, Jun 13, 2026 at 10:52:25AM +0200, Lothar Rubusch wrote:
> On Thu, Jun 11, 2026 at 6:59 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Tue, Jun 09, 2026 at 09:47:23AM +0000, Lothar Rubusch wrote:
> > >
> > > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> > > index 4c9af737b33a..20cd915ea8a3 100644
> > > --- a/drivers/crypto/atmel-sha204a.c
> > > +++ b/drivers/crypto/atmel-sha204a.c
> > > @@ -31,10 +31,15 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
> > >       struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
> > >       struct hwrng *rng = areq;
> > >
> > > -     if (status)
> > > +     if (status) {
> > >               dev_warn_ratelimited(&i2c_priv->client->dev,
> > >                                    "i2c transaction failed (%d)\n",
> > >                                    status);
> > > +             kfree(work_data);
> > > +             rng->priv = 0;
> >
> > Why is this necessary? It appears that rng_read_nonblocking already
> > zeroes rng->priv.
> >
> 
> IMHO this is not the same. The patch targets the error path. If the
> `status` in `atmel_sha204a_rng_done()` is failed, then failed `work_data` is
> still assigned and `rng->priv` is not zeroed at the moment. Only a
> subsequent call to `rng_read_nonblocking()` will set `rng->priv = 0;`

Right, the rng->priv gets set on the error path prior to your patch.
But with your patch, there is no need to clear rng->priv because it
never gets set on the error path.

All I'm asking for is to remove the rng->priv = 0 because it only
causes confusion.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
