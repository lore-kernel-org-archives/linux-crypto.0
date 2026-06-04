Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD843391E58
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 07:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780559802; cv=pass; b=FEbmYkdUqM1IrxGojvUE2yxa3nGMtXo+j7Abj/Ftkm1GfVqhzB86YuAml7KpU3Bgh0OdouubqyLzND8Ka9Qbna8BLdQ9+RYcag18E1FMgq8eObZVZ55hQPNCb06AMrSN1OpUHcQhLs/H+Yt2fLxlpPgltXXMxBJj57cOsHQyAUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780559802; c=relaxed/simple;
	bh=W4eBpaCKNBt9F3TWPxb3NCw8aR7zTaqNv6oeGFZdV+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1tQOyEkhsl5rebhtvpcs5icj+aBgD4sNLlHoZOSvK5H3C5ymcOwdFKpsxTcZBo5/TmOuC+xps2aG8cEK5Ue/oltC7HE6JNGN3C5/UjU3Hh79R/horJdVZoA06uMIIcUE8tWYcNruF/mRqw5O9dImh+YgDU1hqQQ7oWj6j8b8qI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsccG/Ol; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsccG/Ol"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66050f7af22so67951d50.0
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jun 2026 00:56:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780559800; cv=none;
        d=google.com; s=arc-20240605;
        b=JIuI4xCzYtMR8S8xB12cefmqpHHSbw6AAS++hRTcnG/tZNpgBO5BA8mHQM9iPJcF3q
         addKEOwdPaeDcxF0TS9Ie82ZIRTPvH7H/4SLL5MQN9Hd5QoSIY7iWxJkfWF5MwR5YkLR
         LnlP1zEt1gMmwOkPQEZRJEpILttsM0GFghhSKv0OEh8tgGNNNKQiSJMkLu0VlcrUDT0F
         q27G1t84CGhEqbqXiMSaWXMsYvs+nsbvA6cdgXxekc5Wa30PIVsYku6FXBRBgiiy9XxN
         8ewjrC2NEp1A3A93Ol26xkm+n6RhaDu4e6wMJfVq0EkU5Qu+GZl8Vmq1djSODhGEnuT+
         mEOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eGgotgVvr2112uvvc1DyL29QVRiLiPk2tEKJibU9Fy8=;
        fh=X0Iz2gzona6KASzVoDOHNmfJAgTn8THqLsOAbp1Yubg=;
        b=LXBqqjJNBO+i+7o5MWphzQQ+VTdGy0CjcylGtTBYiswv9NEb+gyHfpvn+oxearH8lr
         mkKr1HD1yodUAyhCRaNRb1UJxCJ9zXAGewXr5r/9alInJ2eWgc7AJs9ligeGZ7noXuUU
         hHYtTKNmw5dUvymLq9CiyOhZLYI4rak2HKI6HNDpULzzdzbGFh/N/aMFeiQx2w18lCNy
         dQJBVUkk7TJ+N7KJLvu6EoxftpaPL0ob3p5fuwGn9ySh98OM/43SfPuNOsJlOdo9/ysD
         bAFL2RY6uiqL5gtPaFXz7j3EHPBc2lvc3Op30SA6uvAo/1y5splrWEFbPN/IkuALJoNi
         gvtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780559800; x=1781164600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGgotgVvr2112uvvc1DyL29QVRiLiPk2tEKJibU9Fy8=;
        b=PsccG/Ol3aZlkDrRrLz7csF3gHPhc/5hjRewk0TilnDsw0SYc27DK3fTsLcdpIfzDs
         pWZqV2TmJQrEwlfXxzE5KWzEQagufP8LmSNBpQkC/7l2ryiG95Dh75DKOoougtEb9G6t
         nMRiCLZ7BBgewKz1KafCZWUcQTAkTapqmAgKJl6rFB3EH07p4DgGipycf5MgirGIzFVY
         f4iinaCoqpWziz0NucFVtt7YEO3K9X7hnUX00/IRlVTKH+K0n9vcSTfIsSnJOy1RQy6c
         zvUc9dOQ/7p21BF5T+JEE3WNACl4zEcgw1Sf3o9JSy4MuGzFTamulJGlSAgJCjs16BB0
         1/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780559800; x=1781164600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eGgotgVvr2112uvvc1DyL29QVRiLiPk2tEKJibU9Fy8=;
        b=I/AVoBhvn+pRI12Kbi5VLS5+CPdFw5FHnTe7apXrxBboFt95cZO+/3OJTqEyF2O/ve
         qQYpWRsct59nxOkgje4NpuW3wlzLSMRSQN2Ak7VmrhI2t0UgcPwYmJXrUQPB8Ll7sbIM
         M8xsww9SGzQ8gfG20Sg9ja9Fv8zhn5ovYpsuY4zHZ5bM6DJQaBnWNYEwm9CUj7hyq93D
         dFrbLLDFlLPoDx+Axql353EjORa/80CK6tAGXhfrpMxkJi9jADemygRdg2oX05sCjQ9t
         Mbj9sFeO3HWTvzDKHQyOziXidnA8N/sUUCKHu5PQjbXx4rccqSuOhB2xWfhfcfS/m4Li
         Cg6A==
X-Forwarded-Encrypted: i=1; AFNElJ8su0W5U2C7xPtFWPpa30OKGxMWeaoQ8JDLDpqInaK/qRQcCCCIJniZ7sqckyq2t0bp3YytD6POjV+M3GA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGJ4LvxUEseYN20j0QtJP6NW1DgPnt1n3w4nqMAyvnWRXlT6wB
	i0qm7+t7QiUxlbREurzQyGTCJ4sb9xwC5bz1XPimd2kP+T2AdKlUt/7TM+7wbEf6+hb/oBjIitA
	EuXny3880LlMeLaFOpw7cXTh3yF2Bn4s=
X-Gm-Gg: Acq92OHiHZKRLvBpYWnMWx7L6uKY3Tgeq0aSpdBQZXk+NeVQiO9v9KcS/TaPdLuJx6j
	6KBA3eJmsKh68BJiLIKwKbtU5vUDeXGahJSLILPPc5THJcp6ji5a9Uab/K+2MrngMttjOusssrx
	xqDbwFU9DwQQ4Mg9tGJSj2nXBQrgXTjXIdo/kGNkIXs54uY0FW9yan1n0BzScnj2z/fGxeqjIpl
	6oXazn2Uo8nY4KOiKdi5WRUASvaTDt7Mu+7Bq5FpdxABOVyamb0StX7z/15OWuyvsjjZJFGj9aH
	W8iCUVWDKbqs0xg=
X-Received: by 2002:a53:ac81:0:b0:65e:3bde:1c8d with SMTP id
 956f58d0204a3-660f3e4dc46mr957229d50.2.1780559799732; Thu, 04 Jun 2026
 00:56:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529092703.33086-1-l.rubusch@gmail.com> <ah381bcuVfN8PQr0@linux.dev>
In-Reply-To: <ah381bcuVfN8PQr0@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Thu, 4 Jun 2026 09:56:03 +0200
X-Gm-Features: AVHnY4J2DHztDoFLLVQlenrixqwpyOZeMKkQ7C8oahq4-g3DlS-OWLO5LNf1rU4
Message-ID: <CAFXKEHamUnW9S2nvDD+iHdZB8+66s2SYVEq7KYvUbs32S4behw@mail.gmail.com>
Subject: Re: [PATCH 1/1] crypto: atmel-ecc - fix use after free situation
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, tudor.ambarus@linaro.org, krzk+dt@kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten, thanks for the feedback. Pls, find my comment down below.

On Mon, Jun 1, 2026 at 11:42=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> On Fri, May 29, 2026 at 09:27:03AM +0000, Lothar Rubusch wrote:
> > Fixes a possible race condition, when having multiple of such devices
> > attached (identified by sashiko feedback).
> >
> > The Scenario:
> >     Thread A (Device 1 Probe): Successfully adds i2c_priv to the global
> >              list (Line 324). The lock is released.
> >     Thread B (An active crypto request): Concurrently calls
> >               atmel_ecc_i2c_client_alloc(). It scans the global list, s=
ees
> >               Device 1, and assigns a crypto job to it.
> >     Thread A: Moves to line 332. crypto_register_kpp() fails (e.g., out=
 of
> >               memory or name clash).
> >     Thread A: Enters the error path. It removes Device 1 from the list =
and
> >               frees the i2c_priv memory.
> >     Thread B: Is still actively trying to talk to the I2C hardware usin=
g
> >               the i2c_priv pointer it grabbed in Step 2. The memory is =
now
> >               gone. Result: Kernel crash (Use-After-Free).
> >
> > Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel E=
CC driver")
> > Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> > ---
> >  drivers/crypto/atmel-ecc.c | 10 ++++++++++
> >  drivers/crypto/atmel-i2c.h |  2 ++
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index 0ca02995a1de..d391fe1462f6 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> > @@ -218,6 +218,8 @@ static struct i2c_client *atmel_ecc_i2c_client_allo=
c(void)
> >
> >       list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
> >                           i2c_client_list_node) {
> > +             if (!i2c_priv->ready)
> > +                     continue;
> >               tfm_cnt =3D atomic_read(&i2c_priv->tfm_count);
> >               if (tfm_cnt < min_tfm_cnt) {
> >                       min_tfm_cnt =3D tfm_cnt;
> > @@ -322,20 +324,24 @@ static int atmel_ecc_probe(struct i2c_client *cli=
ent)
> >               return ret;
> >
> >       i2c_priv =3D i2c_get_clientdata(client);
> > +     i2c_priv->ready =3D false;
> >
> >       spin_lock(&driver_data.i2c_list_lock);
> >       list_add_tail(&i2c_priv->i2c_client_list_node,
> >                     &driver_data.i2c_client_list);
> > +     i2c_priv->ready =3D true;
> >       spin_unlock(&driver_data.i2c_list_lock);
> >
> >       ret =3D crypto_register_kpp(&atmel_ecdh_nist_p256);
> >       if (ret) {
> >               spin_lock(&driver_data.i2c_list_lock);
> > +             i2c_priv->ready =3D false;
> >               list_del(&i2c_priv->i2c_client_list_node);
> >               spin_unlock(&driver_data.i2c_list_lock);
> >
> >               dev_err(&client->dev, "%s alg registration failed\n",
> >                       atmel_ecdh_nist_p256.base.cra_driver_name);
> > +             return ret;
> >       } else {
> >               dev_info(&client->dev, "atmel ecc algorithms registered i=
n /proc/crypto\n");
> >       }
> > @@ -347,6 +353,10 @@ static void atmel_ecc_remove(struct i2c_client *cl=
ient)
> >  {
> >       struct atmel_i2c_client_priv *i2c_priv =3D i2c_get_clientdata(cli=
ent);
> >
> > +     spin_lock(&driver_data.i2c_list_lock);
> > +     i2c_priv->ready =3D false;
> > +     spin_unlock(&driver_data.i2c_list_lock);
> > +
> >       /* Return EBUSY if i2c client already allocated. */
> >       if (atomic_read(&i2c_priv->tfm_count)) {
> >               /*
> > diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
> > index 72f04c15682f..e3b12030f9c4 100644
> > --- a/drivers/crypto/atmel-i2c.h
> > +++ b/drivers/crypto/atmel-i2c.h
> > @@ -129,6 +129,7 @@ struct atmel_ecc_driver_data {
> >   * @wake_token_sz       : size in bytes of the wake_token
> >   * @tfm_count           : number of active crypto transformations on i=
2c client
> >   * @hwrng               : hold the hardware generated rng
> > + * @ready               : hw client is ready to use
> >   *
> >   * Reads and writes from/to the i2c client are sequential. The first b=
yte
> >   * transmitted to the device is treated as the byte size. Any attempt =
to send
> > @@ -145,6 +146,7 @@ struct atmel_i2c_client_priv {
> >       size_t wake_token_sz;
> >       atomic_t tfm_count ____cacheline_aligned;
> >       struct hwrng hwrng;
> > +     bool ready;
> >  };
>
> I don't think the ready flag fixes the race. A concurrent tfm can still
> bind to the shared I2C client after atmel_ecc_probe() adds it to the
> global list and marks it as ready, but before crypto_register_kpp()
> fails.

Argh... I see your point. The "ready" now is transparent to the
i2c_client_list usage and serves for nothing, that's nonsense. Going
some overengineering-steps back, my original idea (to satisfy a
sashiko complaint), in my own words:

Thread A:
1. probe()
  V
2. probe(): add i2c_priv to i2c_client_list <-------------- Thread B reques=
ts
  V
3. probe(): registers kpp
  V
4. probe(): say, register kpp fails
  V
5. probe(): remove i2c_priv from i2c_client_list <-----

Thread B:
Now if a crypto request/TFM comes in (thread B) and requests a client
from the i2c_client_list.
(Note, this is a case where the device must be, say, the second such
device so that kpp is already registered for any atmel driver).

If this happens before step 2 or after step 5, it's fine. This
instance is still not on the list. If it happens at step 2 through
step 4 this is problematic. A i2c_priv could be returned which is
actually (still) not ready. In the meanwhile i2c_priv will be removed,
but the TFM continues refering to this instance.

Question:
- Do you see the issue here, too? Or, is my understanding wrong? Can
this be problematic / lead to UAF?

- If true, my first idea was to set a "ready" state initially to
false, after kpp registered successfully, set it to true. The flag is
checked then, as in this patch. Then I probably messed it up. So,
could this approach solve the situation?

If you not answer I'll present this in the next days.

Best,
L

>
> Thanks,
> Thorsten
