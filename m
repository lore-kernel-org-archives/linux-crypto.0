Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493EE364EB0
	for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777126303; cv=pass; b=gdZuY8IbZEhtIWtl+96EfInBba/xri5vUj1ar4gZriPIogrOB9A5GD6H0vqcX+r6EW3g/Pt/UzEcdpNjmSUoJiopIfdTd/rUywHgHFYaEf1SngFBa/QHxKPocksyaDgsqEglURaxwNvhj6iexT9gIS26zjqYG858/yQezwvkIKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777126303; c=relaxed/simple;
	bh=RS8oy0Kfl9nK8rR9+4yf6o+CGZxACc7gRxWe5yE8FZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5FtCBkMF2o3Gx7xikuOyeXQ/48lVJ8RwDF6fKywKdwOvE1t2YaAWD7aFx6rNmkIYgtClNpxqfXK8QHG9jchoBbxQg1f0fIdiyvdleYGptCiZ9RNvoCBvlftv7IuV09DWG78Vz1ZItPMTbXMVrW0K3OYFKvDEQUGJ4uX6DsYAn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1rJ3kJ2; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1rJ3kJ2"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6470d549e10so1262017d50.3
        for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 07:11:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777126300; cv=none;
        d=google.com; s=arc-20240605;
        b=Su01xJqM0gZJWv0IrDYisWs+rLX9CU/tKY73KKdvFhl0Ml8iT15EcLjDL8+fsTMIDO
         V6Mo6rGQsRo60y7Ej9HZpam+VaWTQPc1XDZHYiUE7sUCVulMnqP3hA2hx7tvhkHlX+RF
         BU+npWOMChUfg9fYwrdjyhvLXvBFaFUy8pjx5xeU/ItycwYqYow2e/FN6D9ImLI0qb+R
         8DapoZ5vTi8zNWIWI7ufMabvatzYLaISlR8XvJXvsnE+XJUX20Vu4/irJCGyeJFa0G6S
         p/5BDLTvRm7LgcIdCheeTTW+85dFl/7uhQOQ/0DLeMfDOS/srj+q0eaQejPUMoIYRk0R
         woCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7EYHlbPqa3p4xG3vXYgj2RaDIlHF5g4oGE6OypAL558=;
        fh=LVhpYIfv9JghGCaSQYJN+RIAQbCRadMWuhoiQu1DV9A=;
        b=X33hpAmCytKxnJ1nHbIYhIn9dVDs5JethPegLBYCkWW9UWIFxl7seKq0Vxo7aBGHzm
         ilVxFzEI/SAYue8Fgdiz7NGdCsv16loBBBf57DDv+iC5lUBSpfvZuDcdGcUMGSkDIYm5
         Fg/5EvqfBJtkLfJ0Z2sezoD5Se2lErEUsa7l21xAPJq7rx2LUeKbn7JFrjX06GyLYtJl
         rVO54Ogn5mXpgEu+3gVSKlDpDgnn97e20E88cONOMdueJamkCBvronDlvIXgB4VcGi5M
         wie22ND2pSN9R0olNhsP4AlyFJv9uwn+ZsjxXyA6r+yOxdpt5SfSRxt77qh2XUqGnvEn
         swRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777126300; x=1777731100; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EYHlbPqa3p4xG3vXYgj2RaDIlHF5g4oGE6OypAL558=;
        b=C1rJ3kJ2uKDX0zDqnXreAcnKTpIPtTBVi9eVcwCMWjHReWBnx4EqH/ceD/9MdtkS+h
         cXmzkvYwrekrI6r421GZzO/q7HKwfqcJUK5J0RK+snvYq1rjNBtqi0efD9j2qAAdAzI5
         IjJFvune6AdIwEWWz+500vtjBkLW2pKKoWgbhuj1s+8IqPmWW+Dsy8Pgl6OH9b397epd
         1ZLmrex1jIrT0Cz0LzWvRY8yvV6XM/vfEaz+IRDteBgQeqsbtt41f1kk44eEIar/+eW5
         H88lcS15Yr1ueJM6trCW0AZJXS8ZtjdFO2Q0KfFroHBiWr+VBH/ZzLo6mFDmkXrEHQcz
         h9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777126300; x=1777731100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7EYHlbPqa3p4xG3vXYgj2RaDIlHF5g4oGE6OypAL558=;
        b=c3pR7WNxJ/N6ikx/+grBhGaHXpxERBEXicRORUq1BD7oEYY08Rz5DUCPNEhqDD0Et6
         RciN/FsBh4V5ASGIIc3cZQPgPGKTXqistfkE8ansDI3WLhiXBj+hrlshVt5bcX9xDJO7
         r04Dt2XkD53xwixASOvOvXGX8DsGOy/7cVBKB5NG2pBxqvVJ6FPgliMpwrMiRM/C3eOk
         3aLXmtl7gGmnSBYxhO0rxvXyT87O9XHDLF/he0RtxfDXqBrHm9tQW/12A7XdGbeFTUbo
         00T4CVBO1SqDKgFmf5+jKO7LwcZbgTYRTayq38i9zkjUBCQYToJ9ktdHVgT/4cv1nImx
         aN9A==
X-Forwarded-Encrypted: i=1; AFNElJ/spgBwByFPOmxgR2UkhLEU6qtPqYJRwJupJTnS34QNcoFgihx56oCG3hGfDt0fM4H44UjuCG8JIkWmeqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy51nmWIBVlGoTFSlQWAFzo41IIky27pUQvug37Upj6MQoOo3tb
	x4tg+bW5osKnXGglvdZqRvTjRR+6tSJ8obcYHQWiv5QA8ZShPa81Qf2OTmZyVFQ40lU1pzMgA10
	5vJXqBGQVlI82ByTc4cxAlJlkndBcrdDgkfnI
X-Gm-Gg: AeBDieuL23xvjJwKkMiX6W+yGUKRvx/1Jfdhb9m26bkDKzPbuQ+X1r6/npwD+Y9LxX6
	6bYwlShD7wiI+ZYMCB3te2d4vk7DoNAlKk9FA2gFGLjs0ErXSQlJBkGP7Ux9/md6GNJABF2Lp6+
	dTkRlBvuezN8hRF23tAIxWvMoF/cz0XTrnQBqoz7M3tPQTiZmJbECBkWa+MQJ1GVoXy0kwCV2/t
	AUUDX6uKzAI2qNi3KaYtQZr+cCZwud74Kx3nyaqo6nkI4l8p7Sm8sJQ5TQxS23F5w6/ys+waAIl
	hkzEsawtD+OHZn4=
X-Received: by 2002:a05:690e:130d:b0:651:bb8f:743f with SMTP id
 956f58d0204a3-653107c15e9mr22710224d50.1.1777126300230; Sat, 25 Apr 2026
 07:11:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422210936.20095-1-l.rubusch@gmail.com> <20260422210936.20095-3-l.rubusch@gmail.com>
 <aezFsF8gLkABZZ1O@linux.dev>
In-Reply-To: <aezFsF8gLkABZZ1O@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sat, 25 Apr 2026 16:11:04 +0200
X-Gm-Features: AQROBzA9bYbkmLhKL7_Xzf1pHwgDKe9ObTv_Mco1PkAMHTOhGYRQ2E1mPJCUc70
Message-ID: <CAFXKEHZ+tkSWfm858shA4PCK+nz-0gHg=qVRKcGbX+OW6Rg=KA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] crypto: atmel-sha204a - fix truncated 32-byte
 blocking read
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten!

On Sat, Apr 25, 2026 at 3:46=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Hi Lothar,
>
> On Wed, Apr 22, 2026 at 09:09:35PM +0000, Lothar Rubusch wrote:
> > The ATSHA204A returns a 35-byte packet consisting of a 1-byte count,
> > 32 bytes of entropy, and a 2-byte CRC. The current blocking read
> > implementation was incorrectly copying data starting from the
> > count byte, leading to offset data and truncated entropy.
> >
> > Additionally, the chip requires significant execution time to
> > generate random numbers, going by the datasheet. Reading the I2C bus
> > too early results in the chip NACK-ing or returning a partial buffer
> > followed by zeros.
> >
> > Verification:
> > Tests before showed repeadetly reading only 8 bytes of entropy:
> > $ head -c 32 /dev/hwrng | hexdump -C
> > 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@....=
......|
> > 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..........=
......|
> > 00000020
> >
> > After this patch applied, the result will be as follows:
> > $ head -c 32 /dev/hwrng | hexdump -C
> > 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h.=
...n.i|
> > 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;...=
..ESL.|
> > 00000020
> >
> > Fix these issues by:
> > Increase cmd.msecs to 30ms to provide sufficient execution time. Then
> > set cmd.rxsize to RANDOM_RSP_SIZE (35 bytes) to capture the entire
> > hardware response. Eventually, correct the memcpy() offset to index 1 o=
f
> > the data buffer to skip the count byte and retrieve exactly 32 bytes of
> > entropy.
> >
> > Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A rando=
m number generator")
> > Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
>
> Thank you for your patches. I tested patch 2/3 on real hardware and it
> fixes rngtest for me. However, I have a few comments below.
>
> > ---
> >  drivers/crypto/atmel-sha204a.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha2=
04a.c
> > index 19720bdd446d..f7dc00d0f4cd 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -19,6 +19,9 @@
> >  #include <linux/workqueue.h>
> >  #include "atmel-i2c.h"
> >
> > +#define ATMEL_RNG_BLOCK_SIZE 32
> > +#define ATMEL_RNG_EXEC_TIME 30
> > +
> >  static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_da=
ta,
> >                                  void *areq, int status)
> >  {
> > @@ -91,13 +94,15 @@ static int atmel_sha204a_rng_read(struct hwrng *rng=
, void *data, size_t max,
> >       i2c_priv =3D container_of(rng, struct atmel_i2c_client_priv, hwrn=
g);
> >
> >       atmel_i2c_init_random_cmd(&cmd);
> > +     cmd.msecs =3D ATMEL_RNG_EXEC_TIME;
> > +     cmd.rxsize =3D RANDOM_RSP_SIZE;
>
> atmel_i2c_init_random_cmd() already sets cmd.rxsize to RANDOM_RSP_SIZE.
>
> Changing cmd.msecs does not appear to be strictly necessary for the fix.
> The only difference I observe is that rngtest runs faster with the new
> value.
>
> Here are my test results without changing cmd.msecs:
>
> $ sudo head -c 300000 /dev/hwrng | rngtest -c 100
> [...]
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 2000032
> rngtest: FIPS 140-2 successes: 100
> rngtest: FIPS 140-2 failures: 0
> [...]
> rngtest: input channel speed: (min=3D1.118; avg=3D3.746; max=3D6510416.66=
7)Kibits/s
> rngtest: FIPS tests speed: (min=3D26.272; avg=3D27.471; max=3D32.829)Mibi=
ts/s
> rngtest: Program run time: 538942640 microseconds
>
> and with 'cmd.msecs =3D ATMEL_RNG_EXEC_TIME':
>
> $ sudo head -c 300000 /dev/hwrng | rngtest -c 100
> [...]
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 2000032
> rngtest: FIPS 140-2 successes: 100
> rngtest: FIPS 140-2 failures: 0
> [...]
> rngtest: input channel speed: (min=3D1.584; avg=3D5.295; max=3D6510416.66=
7)Kibits/s
> rngtest: FIPS tests speed: (min=3D26.602; avg=3D27.321; max=3D28.257)Mibi=
ts/s
> rngtest: Program run time: 381309284 microseconds
>
> >       ret =3D atmel_i2c_send_receive(i2c_priv->client, &cmd);
> >       if (ret)
> >               return ret;
> >
> > -     max =3D min(sizeof(cmd.data), max);
> > -     memcpy(data, cmd.data, max);
> > +     max =3D min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
> > +     memcpy(data, &cmd.data[1], max);
>
> This works and fixes rngtest for me on real hardware.
>
> min_t() is not strictly necessary here, since the types are compatible
> and min() is sufficient.
>
> I agree with Ard that patch 2/3 should be a separate patch for easier
> stable backporting.
>

I appreciate your answers and will take the review into account. Looks
like we had similar plans for
this weekend. So, since I answered to Ard quite in parallel to your
review, I'll restructure as I said in my
last mail on this list. I'll go through your comments and think about it.

Best,
L




> Thanks,
> Thorsten
