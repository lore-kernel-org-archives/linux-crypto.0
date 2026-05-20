Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119B33F1656
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290742; cv=none; b=qRZfWiwB/dVg1utqmR2X1jjQWUBvRFpymX0dJ9Gtz2eAEgAzSoEa1+J5uA2M/xtjbfjL5dgc9WluTz7fu17H8HtMqzimKLxTmOCXK16O383RiPe+2qJwv9zp0x3UFcYdhTX8isgsHGiT+sb5kPjQMlP3Wf/tCrmBehw3p8FZf/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290742; c=relaxed/simple;
	bh=30Ta3GeDyzeEDqzMXk9IkXAG48BD9LjaC/vjrDze5ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVqCEv7xPaY6vEziDfUJOF05HqSA/0oB8plBbf8jlEoJW3D1eCnGdrcApJjxy6qkoXWIZdVdBbzTVymXPsZAkpKGo3zXBjMX0BUip/iPeTPYluuQ3C2Y9DoSDooS1Y42hOU/FbobnB9++2n3gbCBEwrr5ur1LI1A5ksCisArjuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=YwPkrOcx; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="YwPkrOcx"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48e8132c6d0so33529425e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779290737; x=1779895537; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFavJwHYbSM6FE0lfLUET7tWipL+OnMgDcLdxX5CbdE=;
        b=YwPkrOcxSTiT7kLP2njirVpm9YCzM+z0EmMkbpjdX/AmxUy0GfmXwMf4Qu1i3f/p6H
         sUdhOLBNxwxr56Cvd6x4/lAPPlzS8qoIGsXGAZ6ogVLIQhEeEnsKaXvN6n4pY0N2EcMn
         NkamzI0dYGOunJ8Xf/Ws35G67fCBc1D7SPNgrAhjmp65RnMMNzmDHnvczjJxjjORj33+
         DlNTE9uft0dlMoQGCiIHxqtVlMdiSoMDSqZRILuF7kk5PHBHBF2MKyuqjWHIK9Lv9E6F
         j+9rQ0x1fPvAtKY2h6YaTgEby2JJ0bTjc9boK/qh5M+dAq9Ph/8tsM3n++ldTHZvjoWQ
         0Nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290737; x=1779895537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oFavJwHYbSM6FE0lfLUET7tWipL+OnMgDcLdxX5CbdE=;
        b=NsxKlzYdh5CdQhUDJLV9VhcpjzyEMcmYRO1za1L4WzwlL7ukhb8mRvWclzoBZstoXQ
         V8cmlFPNb6yuqSXIvillsVCa8ZsbCJY+bPlXRxXhKMyx+ntTf0bZW8ajDTrey3Fi35TD
         eA0H+c0xlyVUu1s/Hx59Wx3UYHV9Ex9CdE4HcOm7exst35m2nOZDskKaBa3RflSiX3xH
         6rj+7QHuNRFWZrVHwchP1nJjotXzIHkQ9WUYIfwOuVTaeqYzDWWJUroY2TqfVXawPZCS
         hSRjbeUdK911/iGc4rOgGls4MPylxYmwogjb8/wpg1bhAHFsPpmL1Or7j1NZZ1yeRMIP
         FO8Q==
X-Forwarded-Encrypted: i=1; AFNElJ8ynAnJVDic2woDzSEGWOiofryukhNIxst+ifxZmlE8oEGHEg9AUq58WJTYRH2NuC3N8UxgHlE318x5ocU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr1Z5GKbHAKy35rjVmQ/tQIvY85FYhtyy41jU42TwCn1keOrT0
	DhyFypXaSvv/3ik9y8/GLlO/+SwvzKgR92WaN3x6a43tCJNa/oxyM1xHyymhHk1UK11KjkuTNiQ
	TXDegqMvpvQ==
X-Gm-Gg: Acq92OG1uTBwigvQzatkvt78HFnXau4xDzsV9uNjWb+Zy65n2y1yKka/cTFf6Y/sSuK
	fPCRwDOmIYZhI0X2A5b5Dq/ERt97jFNyZkIiTLx+2lepBx2VPepLijCKHkOFm2R8JPsF+B0PAFt
	Cth7FsI+LfQgoM+F9Ib6aK8u+ubCgVHsi+7xFfShPyKjQX1zOBnoyBYwypXPPy/7pwJw5HHiktk
	09O8/C3gSt66Y7ZGtCq3xsxegwbwER7mqSLCClhR+CZUGv9CYt4QS1XigwZZGMbVBuawQLA5B+x
	aUQUkqIA0qpcTuMl5SwH5br08tA4fc8t5PcUxCq1KwJHmsUtwvivTSZooM7LUFdZO0XFBuGMl5l
	N5S1lGd3CHgnCx7hVszcMoQXV6Bq3e3c3GqfmnXrskNokpcpdqGkO7GLXU8XHd9co8ax/mhXjvM
	44dMSrmCxAd81drZwrac/gRex9k8B2kFaxhUmnpFRLYYS7y4cZao2ysncso4r3lKT1MkoH/6BXk
	HfH4KLtJg2rNJB3qyEkEJVpSQ==
X-Received: by 2002:a05:600c:4e13:b0:490:31e:d6fd with SMTP id 5b1f17b1804b1-490031ed899mr279492645e9.25.1779290737373;
        Wed, 20 May 2026 08:25:37 -0700 (PDT)
Received: from localhost (p200300f65f47db04e561655f2aa05c7f.dip0.t-ipconnect.de. [2003:f6:5f47:db04:e561:655f:2aa0:5c7f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48fffb9aac4sm544034675e9.9.2026.05.20.08.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:25:36 -0700 (PDT)
Date: Wed, 20 May 2026 17:25:35 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] crypto: atmel-sha204a - Drop of_device_id data
Message-ID: <ag3RTQEC_HyUM3K4@monoceros>
References: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
 <d0fc3069860f9e31122c1af635a1114dd2c443cf.1779260113.git.u.kleine-koenig@baylibre.com>
 <46130020-eaa5-44ad-9c6d-62ccb30c19d9@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lntws6wrfne5ipt2"
Content-Disposition: inline
In-Reply-To: <46130020-eaa5-44ad-9c6d-62ccb30c19d9@app.fastmail.com>


--lntws6wrfne5ipt2
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/3] crypto: atmel-sha204a - Drop of_device_id data
MIME-Version: 1.0

Hello Ard,

On Wed, May 20, 2026 at 09:49:49AM +0200, Ard Biesheuvel wrote:
> On Wed, 20 May 2026, at 09:01, Uwe Kleine-K=F6nig (The Capable Hub) wrote:
> > The driver binds to i2c devices only and thus in the absence of an
> > assignment for .data in the of_device_id array i2c_get_match_data()
> > falls back to .driver_data from the i2c_device_id array. So only provide
> > &atsha204_quality once to reduce duplication.
> >
> > Signed-off-by: Uwe Kleine-K=F6nig (The Capable Hub) <u.kleine-koenig@ba=
ylibre.com>
> > ---
> >  drivers/crypto/atmel-sha204a.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha2=
04a.c
> > index 6e6ac4770416..f17e1f6af1a3 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -208,8 +208,8 @@ static void atmel_sha204a_remove(struct i2c_client =
*client)
> >  }
> >=20
> >  static const struct of_device_id atmel_sha204a_dt_ids[] =3D {
> > -	{ .compatible =3D "atmel,atsha204", .data =3D &atsha204_quality },
> > -	{ .compatible =3D "atmel,atsha204a", },
> > +	{ .compatible =3D "atmel,atsha204" },
> > +	{ .compatible =3D "atmel,atsha204a" },
> >  	{ }
> >  };
> >  MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
>=20
> Just trying to figure out how this is supposed to work:
>=20
> i2c_get_match_data()
>   data =3D device_get_match_data(&client->dev);
>   ... returns NULL ...
>   if (!data) {
>     match =3D i2c_match_id(driver->id_table, client);
>     ... compares client->name with { "atsha204", "atsha204a" }
>=20
> So we will be relying on client->name having been set to either=20
> "atsha204" or "atsha204a" on the DT probe path before
> i2c_match_data() is called, but I am struggling to see where
> that might happen.

That happens when the client is created. Relevant are:

int of_i2c_get_board_info(struct device *dev, struct device_node *node,
	...
{
	...
	if (of_alias_from_compatible(node, info->type, sizeof(info->type)) < 0) {
		...
}

which sets info->type from .compatible with the vendor part skipped.
Then

static struct i2c_client *of_i2c_register_device(...)
{
	...
	ret =3D of_i2c_get_board_info(&adap->dev, node, &info);
	...
	client =3D i2c_new_client_device(adap, &info);
	...
}

where i2c_new_client_device() uses info->type to populate client->name.

Best regards
Uwe

--lntws6wrfne5ipt2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmoN0m0ACgkQj4D7WH0S
/k7WaQf9FYK31sTuNaQNBScs4kD7Q1pEw2ipCPpXIU2XiiieMxxHqSTb9UAHQPAU
R50AQz2QB1R+nHVvN1KhLjwmTNwShQpRY3YCZhTiWBiw4nq9o7dBh4vs7FTyAV4p
AuDChDsDeU7FKwOvZhmEu7eaUmp037fw3pA44EHyNn/jn75pP7842GFfVuZwvwtT
+IjPrcDiGej30I9uhligYc2ZkohnbHEVumD8KmMskUAJogOFajcKOpxiiAJoPfEy
v5thRa17jUPi04sePMKGcrEyzlOQwep37FP52bdP/cfOB8TJqMpA4uJTDR47YHAv
oUPaSopOv4qFqmH7fPfoI7FM64YYJA==
=vjzT
-----END PGP SIGNATURE-----

--lntws6wrfne5ipt2--
