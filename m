Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFB622332E
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 08:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781340785; cv=pass; b=BMxbjje5jXhpevGij+47Ur16JHCV750biwXiUkFnPShHxTjOpzG11rbbsAgoSd8zERgxa7VyJleEtqo+xqb/OuGOM6Vjd/8xoVfwYcep9Ap1UBpiMEn3ULzLT0FrFzjkpsoGeSse7AJ/bfX2p3rh07aNkjaUQY5o8f8pBv9ykd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781340785; c=relaxed/simple;
	bh=DIPTHUE45xaNQm7RajJxuN7HhfF2CK9gZPO0br7sN7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JuY141cN6PnPCRm/gaOvf7YHqlXn6uJLsQ/nHnz0/ZwJvUFztX2xnKCL+vt53j0ULXpKFcEUf7urRASHOwlTR0ONNR9TdOYf5NV9VrFCumFpScjFJOxK1n+MhHb5yTLPtvjQGtqCdiSINBe2l1668DLw7KldadJdhgw1iGK9xxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkinjI3I; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkinjI3I"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-660525a61d3so134039d50.3
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 01:53:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781340783; cv=none;
        d=google.com; s=arc-20240605;
        b=eslfql9+xlXrDeVUL9HgAA3M6O37hNwpVNm/JYXYdZCSBhobjcf9rVOj5+qpiN1tUI
         6cBkuuuUdf8VzaVrQ/ewaTqEAAswccwFR2hWvo5JEkL2n6SlcL9cs51vmQUsDZsNoYI1
         CJ+z5Dz8TnSKK2Bs6n0lFrIiWV7SqGR4IMOeq7Bzfiqx3DANplRDhhY92m9BrqwQgrpC
         7aBxpYQFJ9/2bQEiiEn825afDMaZkPKBAhbhEWb+9XUp5afN0SDvXudc7UG4YITJROwo
         qAktk/PuqnqJhPxFUSnrCdKRM2Ki5rNt4nq94yk4741PGdzhP2y2G6oXRL8AtiVl7h/O
         IH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lzsqau39bl9Mc/gHA7TczwgrY1vpC1GBu2mXHBebm7Q=;
        fh=JixQjcN3EWtfoi1zGvUQUdvx9cexXVFjuMN6yORMJPI=;
        b=Mi3+CgFeMHNqHDxVZ9LSqslgmf1RIu5jzKuZQQsD6GnvrG7ZBRb7vxlBXPF6OtE8Wi
         gdHFILhG9LnZcPVCdvQYEjb3vR5W1e7sRD2mjzavFJKOY0cZQPzBG467p3/6lddGC82A
         YwCFn3Q1v3Q+maASnuSc2fNlY3CowfLYBuDIFXEjo+8iZqEglV/fkQJ65rn7Kn5F7hXk
         8y1NEyCoDJzZIcszobwiJZ5rRmp1W460qGK9YqLRt0JjxGX7tWorXtC6TGdEJeZ9YZA7
         aJBL3pPfbtpYNE2UBIp3NhhWFWOcbZ8/B+xqCkCEpMEjIbA0tKX0XZGLUbnkc8FGPfyq
         aIbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781340783; x=1781945583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lzsqau39bl9Mc/gHA7TczwgrY1vpC1GBu2mXHBebm7Q=;
        b=IkinjI3IdTqZbKYxlABUWh6Ebnyam8rx+PWiVI+rFqPstksupegkgOmhbFNbaEoq9a
         kQzYhTjoqMJAej1LaUrMohvHcKjLaBhNaCypvFo1pjTtwZftoxUAvK0HpkfDpKyROi6Y
         WFzRcTnu/8yv1QEbz//EFYaC3iTPz5hA1sRg8oFbbYfEUt1jAFPDDDE42fEiVo5x8NLi
         6BlDgMF043oNC6A14mGObszRoYY2XRhzDf0wx4nSBDjUq1BXKXUISXYWU9eQJdAMbQM+
         ZScV+zmMPCcx1QGVKzIt0LaTTHZw3aAy33wf/ijTQscKTvIyHhqt7X/ZLfqkBM/A/OaT
         2SPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781340783; x=1781945583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lzsqau39bl9Mc/gHA7TczwgrY1vpC1GBu2mXHBebm7Q=;
        b=s0yH0x95IiWaD/3f6IVTQpzsIeVreSXHwe22gDPDSgw44/v98ub7AKFY+eg2b0O0cD
         godX98JamxYTwkIseFKTtXnmG7xOJprI+WfBJzm0TQemA9LeYkecc4a66u0Hpdt0GfII
         eKJ+xJvrfpHsUtsN57+WYikJxT7t4oUFdAtmf6kM1VXUlkyqqEXhNkyDKtp96O8fW+qZ
         3bI7vnJT9z/CLlEjHd+/fqV0HcqItU7Obi/j7VoijafdvYXA2ybBV1F/iOCdLhgAjhes
         bJN5Q5oDmAQCh2dwbXqQp8eu5ge5ghVcXWVDmHJxnBKyviPXpCDy7I8WFsDDWXOkjO2J
         Hjzg==
X-Forwarded-Encrypted: i=1; AFNElJ/4f4tye/Q7CU1GiLO7REVXIch8+phXixeLBUQQTQwI1ggPugDQkLWKDc2cjbI+th+xc/P756hpLQvj2ks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8PrxhTEo8MsURnANlegc4kiLPLH9IbJEKJtTt4cj00Eho6lCO
	lvNcGUwV1d9VOnUAk2f49eKS7mZ8GbMe6mJJnU1ZaJ0NZoCpYiMJsmEnY1Uk562OMUcw2Vcno/+
	Q1C+DIj2RR6CVfX91ZYRXq8gpFkGm+9M=
X-Gm-Gg: Acq92OFDjx0IXtfPVs8azae+4H4pkPs6vLu4MtwYG1zDnRmwtOXAszEVlouQ//4d7EY
	dxnnf7inEJKUCwa+WfgoPZX5SOiMZoGF8MEb03M11Di0Ioih/veH11tQcvnGFV44lu62tnviiue
	N/S6EKKIr67C27cIvQ1KMs1k7ZYy/X9ZCrAT/do4c9B05qW0lhaEnZ5EhJe1iMvVrsJhT89QZBl
	g2n+l+s4JHffdSIN0Ci+haefDRScwhFxDGY208Y2hVgc60ggSuhXlfoqjQK/Q2B+Ha24b16lSUC
	/GLY
X-Received: by 2002:a05:690e:190e:b0:660:3524:a765 with SMTP id
 956f58d0204a3-66277db878fmr3240708d50.0.1781340783060; Sat, 13 Jun 2026
 01:53:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609094723.47237-1-l.rubusch@gmail.com> <aipAf_uZnX_gwZnl@gondor.apana.org.au>
In-Reply-To: <aipAf_uZnX_gwZnl@gondor.apana.org.au>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sat, 13 Jun 2026 10:52:25 +0200
X-Gm-Features: AVVi8Ccez8ahhZkqU3IHIA6bkI7wgzyq1z6y0SVWiqCmMhkHMjyS-J_FvYv_-S8
Message-ID: <CAFXKEHYcp-0+uCA47mtDe_+LUAZucEPbDJzoh5+e3Q3R20mN9Q@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/1] crypto: atmel-sha204a - fix heap info leak
 on I2C transfer failure
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: thorsten.blum@linux.dev, davem@davemloft.net, nicolas.ferre@microchip.com, 
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev, ardb@kernel.org, 
	krzk+dt@kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 6:59=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Tue, Jun 09, 2026 at 09:47:23AM +0000, Lothar Rubusch wrote:
> >
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha2=
04a.c
> > index 4c9af737b33a..20cd915ea8a3 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -31,10 +31,15 @@ static void atmel_sha204a_rng_done(struct atmel_i2c=
_work_data *work_data,
> >       struct atmel_i2c_client_priv *i2c_priv =3D work_data->ctx;
> >       struct hwrng *rng =3D areq;
> >
> > -     if (status)
> > +     if (status) {
> >               dev_warn_ratelimited(&i2c_priv->client->dev,
> >                                    "i2c transaction failed (%d)\n",
> >                                    status);
> > +             kfree(work_data);
> > +             rng->priv =3D 0;
>
> Why is this necessary? It appears that rng_read_nonblocking already
> zeroes rng->priv.
>

IMHO this is not the same. The patch targets the error path. If the
`status` in `atmel_sha204a_rng_done()` is failed, then failed `work_data` i=
s
still assigned and `rng->priv` is not zeroed at the moment. Only a
subsequent call to `rng_read_nonblocking()` will set `rng->priv =3D 0;`


The call order is something like this:
1. atmel_sha204a_init // module setup
2. atmel_sha204a_rng_read_nonblocking // call 1
3. atmel_sha204a_rng_done             // if fail, still copies
work_data <-- patch clears here
...
4. atmel_sha204a_rng_read_nonblocking // call 2, clears rng->priv =3D 0

Originally this was a sashiko finding, when I move the RNG part into the
common driver. Reason: Actually all Atmel ECC and Atmel SHA204a devices
support the same RNG mech. Thus part of my refactoring is moving it to the
common core driver atmel_i2c. I was advised by the maintainer to use also
sashiko's feedback. So, I went on identifying sashiko issues and have a
look into it, if I can provide a fix for it. This is one of them.

Sashiko asked:
"If the I2C transaction fails here, we still assign the work_data to
rng->priv. Since kmalloc_obj() uses GFP_ATOMIC and does not zero memory,
does this risk leaking uninitialized slab memory or stale data from
previous reads when the next non-blocking read copies from
work_data->cmd.data?"

ref: https://sashiko.dev/#/patchset/20260512224349.64621-1-l.rubusch%40gmai=
l.com
[search for `atmel_i2c_rng_done` on that link]

I'm not sure about the risk or the (real) severity sashiko mentiones
here. But it seems to
be correct, when atmel_sha204a_rng_done() fails in the status, it
continues assigning the
failed result in the work_data:

    static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_dat=
a,
                       void *areq, int status)
    {
        struct atmel_i2c_client_priv *i2c_priv =3D work_data->ctx;
        struct hwrng *rng =3D areq;

        if (status)
            dev_warn_ratelimited(&i2c_priv->client->dev,
                         "i2c transaction failed (%d)\n",
                         status);

        rng->priv =3D (unsigned long)work_data;
        atomic_dec(&i2c_priv->tfm_count);
    }

Hence, my proposed patch will stop it passing work_data, if status is
failed. It will not
assign rng->priv anymore then containing old data, but clear it. It
will free the `work_data`
to provoke a new allocation happening in `atmel_sha204a_rng_read_nonblockin=
g()`.

The patch is sashiko and maintainer reviewed and solves sashikos complaints=
.
ref: https://sashiko.dev/#/patchset/20260609094723.47237-1-l.rubusch%40gmai=
l.com
Setting `rng->priv =3D 0;` is rather safety here.

Thank you for asking. Accept, drop or modification needed - please,
leave me a note,
I'd highly appreciate.

Best,
L

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
