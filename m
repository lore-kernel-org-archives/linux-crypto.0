Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7F11B86EA
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jul 2024 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720557066; cv=none; b=gy9OCEp6AF9aEQo12EiX2LrEwY1HjToAf8zaFyv6oOhir7EBfQ+nLeaAKuV3wC4PcxGdE1pM5+WoQni7bS/QEFcUgb9bCXdZa1O1XQNXo4sKgJMZ8yANDFzhbQAWpBe8tpiKA1Hqz3KtZ/fGuzk7W4dE2V/31J/XIxEGRJbpSoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720557066; c=relaxed/simple;
	bh=2Z7YUXDJRUr7FzdNAraz0B6iF96kNUQOgG45fdVEbcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJQf6vyEhhYHwy2BpwCHV7ma3OEj5KvhsA+G10CeZAOZADJ/GSzlAakNVTqs/33NZaO7ELyQ+5+FiiVGIjtseeV5Du8NXXKejWliqFzzgjTWVa994CflN9uzaeyLN2JKKWrbcisAQO1+IVHUHiWy4oxmUTY8RFFtM7t9i+iaGO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=WiGyH8Uu; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="WiGyH8Uu"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-64789495923so48147637b3.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jul 2024 13:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1720557060; x=1721161860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGkVmM6g539aCD0PP8KRsb9+ow4RImmM5caLc2hY6sg=;
        b=WiGyH8UuoDi1/wTasS0ICAW9LG6F52wKspQgCSVsJc2CmeOMS2/pMEH9MSJJR3iK5o
         celBTRD3V0Ede5td//q07Wmoc80/x+aOp6uA0POjDegR8CaFDXAFqvwO+PgqFuKe6L77
         LzBfq9Y3VzzXn8NyXu9SO/e+lPSIqGi3EzM9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720557060; x=1721161860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGkVmM6g539aCD0PP8KRsb9+ow4RImmM5caLc2hY6sg=;
        b=Kq+rvjWYIXxcnW7NhzLejDBlezgQ65MIhsp2nxVZlxvBREGHuK6WKFYQR6nj8JjsEg
         h4taKgB4/+DP6T3vChZC/PFpn8Gn1AVP4D5lCqvweWbMMWUuppsf7hbkYZtuMO1O3FJ3
         hpgSV0mE7TqrVJBafNbkB1ZW0p1fmqG8PTj5dRJfKLceUU1POLfS2DOXrjxMnK0LTAt/
         lO4Has/zduM/pvo2BiYdI0N8PRzb7E/Ao0PEJjXSyR2v6moSpgdvm9fyUrnX2luHvdCx
         pCDdcX06NFTbvSgBX/zU/bOWDWTG71XmavMz3+RDpnFP0EVPb6RjMb98EU7pRB+LxVUX
         5LvQ==
X-Gm-Message-State: AOJu0YznE243pzfohMiZzYa+ohBxxGVs6Sj7MJrmunrb9dZSrqOJjL0J
	i4rU4wUKM8L31Y6Mw43+Txy1REwvqUbKfkJQEA8paqfyv+aPz3Y5dXYziyIFLc4T1UPnDvsc/tT
	DrAB8Xl4BTBAU/3/1Wf8pIv1aghWALhYOcbLutg==
X-Google-Smtp-Source: AGHT+IHs5z+LhnnYfKskIlXrTLR/NpD7nNurkkfRq1ZfttKsnGAnctSCCyBCctu4nBBS6Wc1CpK0W+fKL7Odu7bSgiI=
X-Received: by 2002:a81:8ac3:0:b0:646:5f95:9c7d with SMTP id
 00721157ae682-658f01fda1bmr37286687b3.36.1720557060094; Tue, 09 Jul 2024
 13:31:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
 <20240621082053.638952-4-pavitrakumarm@vayavyalabs.com> <Zn4O1bCwLLc8kk1N@gondor.apana.org.au>
In-Reply-To: <Zn4O1bCwLLc8kk1N@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 10 Jul 2024 02:00:49 +0530
Message-ID: <CALxtO0nhCc9GjHpKUBJLez=bo=tMexOu=WjDwJ-vCEvtzc0Zpg@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com, 
	shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Herbert,
  The statesize is taken care of in V6 patchset.
  Appreciate your feedback and review on the same.

Warm regards,
PK


On Fri, Jun 28, 2024 at 6:46=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Jun 21, 2024 at 01:50:49PM +0530, Pavitrakumar M wrote:
> >
> > +static int spacc_hash_cra_init(struct crypto_tfm *tfm)
> > +{
> > +     const struct spacc_alg *salg =3D spacc_tfm_ahash(tfm);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_tfm_ctx(tfm);
> > +     struct spacc_priv *priv =3D NULL;
> > +
> > +     tctx->handle    =3D -1;
> > +     tctx->ctx_valid =3D false;
> > +     tctx->dev       =3D get_device(salg->dev[0]);
> > +
> > +     if (salg->mode->sw_fb) {
> > +             tctx->fb.hash =3D crypto_alloc_ahash(salg->calg->cra_name=
, 0,
> > +                                                CRYPTO_ALG_NEED_FALLBA=
CK);
> > +
> > +             if (IS_ERR(tctx->fb.hash)) {
> > +                     if (tctx->handle >=3D 0)
> > +                             spacc_close(&priv->spacc, tctx->handle);
> > +                     put_device(tctx->dev);
> > +                     return PTR_ERR(tctx->fb.hash);
> > +             }
> > +
> > +             crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> > +                                      sizeof(struct spacc_crypto_reqct=
x) +
> > +                                      crypto_ahash_reqsize(tctx->fb.ha=
sh));
>
> You should also set the statesize here.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
