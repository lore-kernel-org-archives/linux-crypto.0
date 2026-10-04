Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439593A1E67
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150580; cv=pass; b=OuHrd2CfA6M6juE/r2UxQXDgUDnAjG44Y0k5B5uzG2p4O9005xqbhhf4R0HfFoZM2yQpBCKJorhJTPgcQxQ1W+/5xsPi2eY13o0Pphdp/Huvefhw0YvTB7xJcH8mWr0pEBp2cfl3ady/kxbsq/ttt+AedzyHIBuv09o9fkBiaq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150580; c=relaxed/simple;
	bh=n4s2ghS3JpMXeHm1+EjRF8oRBicA/8SRWrzzy3NJ7cQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b1yx58j0A4Jsqsou9iEn4XqeTI/aC3fTAyp3OtVdGgr7xhyuqqih8CxMnnXHvaAqNCGFslCKbKnY8HClDkDlkv/cU9KzDM0VIN1MHyORGs8yDsGteSOaSo4GY8/BNtisCdqjJyPutnOBXO7XOZFSHCkTz8/nZuYMGxi77GZOtLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=quZ7XDO2; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="quZ7XDO2"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a051b737d8so1065062a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Oct 2026 14:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791150577; cv=none;
        d=google.com; s=arc-20260327;
        b=kj8UHOzVLn0Ww2MSIAfRy0Z0JfJeSAECcwgv7U4eJQi2fWDEEm+4Z+Yl8Cbdpc+XRI
         ZlVyd9aMJRh+3YB7hTFlNqHET814gSrlJAgzSo/wN44MNTpkuBEsMSVLz56m8kiUcmk9
         OdkRn5hZNi6egwy+XkVebYWlyOJ47uWuFUkJE3sSEkF/n35+wMvn1rph5o/dE+vCiuNM
         knMNugQZytmGxtmZX7Laeg77W68ADBVhsUdCSieyOsghubjxxoZRV1UDm6rs13riiBnh
         g5wnoPV1L8Xk2Bm9CjgMEejnsDw33B1m3WVVx+wlo1qM7th+CwXWD42XduYqjDojuS/n
         GNxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lk+TjY8//pTex7x3vV7ekqtsLl/eaesFEpZ4BiRMCVU=;
        fh=WNY6UYzEdLKnfizECCRWTprpgbDfe3Vbi5EaM0LD/K0=;
        b=qasyAc78+1t9Ewjvi0qz8TD1JyqkKJ62novewKhDnchJEfG4yCDDjuJmW6iVH6zxve
         hyR7zcp9a4VBaHlPe1ltgU/NE9yN7A/LgeV2fqkIA3hFtoaFR1VohhigieRlTzAGoU9R
         srjSlXGAj7z7FEXFCNjyIVSe7VUVSOZkoNqTkMaO7VUEkPcdtPKqnt8GzXJZUnr41QK0
         jplzHwbE48LWuv85yPRvb+X4ykQnyN3qTffl9jUJispISx10TmD3lQfhNffisdq68lOE
         Inldow+7gdJLB5oCw7NOqnY01k4zgSPhIxWiiany7r5QvIhLc+4+raVK2zXEgjdmbmoV
         hdbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791150577; x=1791755377; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lk+TjY8//pTex7x3vV7ekqtsLl/eaesFEpZ4BiRMCVU=;
        b=quZ7XDO2CUFt1nd8b7WsnGouYRelAcwg7uyW/Y9fhT3HdogIriyqUFVKh+0U6ZHmU3
         VmjHZErH1dwGjwtKRNx6HR+eU7pqmndZLV7tk/1aOmnxILlOPkQv0SwGLYyuQ3nVMakv
         QgXCd+wKeUlcZPyzcUWDXfhbAoUlcqJbacUxLhdQL3lVrqOnohsoh4owwnashWKeODUy
         6+1n8QKI2hnvDS+wszsDEuBsjzYvWhygEC7hZLmlxPZ7nPJy6XrE54PqVB9tNW/ncaZr
         DjT/CmKSflFPqRZHwmEbQJfGNjOTA35jDXobo1iPJtaQ6+FQTXbxn1mKs9wi19hUKaTf
         TYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791150577; x=1791755377;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lk+TjY8//pTex7x3vV7ekqtsLl/eaesFEpZ4BiRMCVU=;
        b=zmtC9Pksh5hvltnsxVap1tHvfzTr5OJNiOLKeut991ybEjetNPxBro0jRcHFcZpgT0
         5aBT5TIlNA+cdQS3DbnZVxP6CsiLe015mVmG5+m7xyb8l8d0XTRBg8Jg6Z8G39b2qBvd
         Q0Ho9oZjLf5WQ9NM/C3PLume4nEHIhCPUDiSgagffgA3/CrqATRZw6SdJfWHAEkaPMjN
         4Xf5ZvPoWNV3fQUkWEmY07CazCtOEsBi/ifSwJxuuBZ8YqxzE69Hk8c4mm6OsksfrPvo
         wKPXYWkmYAccJPPI2FAyaVRaMir3lM/bYZgg58cbu158S9H61EDISFcklsWPZ0L3Aak0
         IeUg==
X-Gm-Message-State: AFq9FYKnQdgt8clZnjraEyUtgB7GSnCjlzlkkonsulEvrMLGmhhfbh5L
	6pnQuAx4cMBEZsSvcRUwF3hMKRZTPzfGiqINd/yzOrs4qY4m5Hz+CLkebcIq8qcg9y5Juz7kQua
	qJcoVCUvnf134LGjR9E5TvSHmpj67DKo=
X-Gm-Gg: AYBFou2lVxKq5FkXJ8YNZHAd9SL5Dsk+9Zuoi6UsWsQuYgLMEFDnjsFLKoGo75NZFla
	hcmZw3OBxve7tzX2Vh7UGlJFA8FHjq6hFaYo++HO4MFc3HlHOmEFU1lhDwRCqTUSF+OD63s6F+1
	v+O9tncxg4MBHEdipGwVM0ZCp5kgHEdqByafNN4/ftzpxoclRZ0AdpCqDmNKPr/xzamTuBhDzwc
	bjIivvCTNoS5Trtkqd+MTQSKARP8+C2SezyKaKKvi2bNT0nspCeb2JF+6teKWxOuk/u+fgI0VGU
	gB73xwdIzlzDxcPbGfaEUniFtg+j36hjlwCdBqEhNKd/0Ty+O5ENDJmMNTG3Co/0jmQyAYITLK3
	AC71m0AtY8IlYaxA+HB28wp8ck5VfhgGhdYQMAxU7uGBhLf5T3zllzfgPKRgCZdpDgtuYk99WFG
	xytKrsHSVZdAIOGyT4vlQrFdea/LkK5kmSCu+sEfYonFbkyzyB7SROQpvOb/UWMP3M2g==
X-Received: by 2002:a05:6402:2793:b0:6ac:fe75:16a with SMTP id
 4fb4d7f45d1cf-6afad760031mr5024339a12.1.1791150577021; Sun, 04 Oct 2026
 14:49:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003212359.126745-1-rosenp@gmail.com> <DLVJPVEV4SW7.16A8YC0SH3Z63@bootlin.com>
In-Reply-To: <DLVJPVEV4SW7.16A8YC0SH3Z63@bootlin.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Sun, 4 Oct 2026 14:49:25 -0700
X-Gm-Features: AclHuK94cker3Qcgsf3anSmiZ-LVkBl1ZkoEZ3Ob71ltQ4zDtKAMMXhkAMOVqbU
Message-ID: <CAKxU2N-Gxf7ot5OiQ45dff_iMy67+bxf2_FRvpZcz+i9G+3Mfw@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: talitos: fix probe IRQ ordering
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 3, 2026 at 3:11=E2=80=AFPM Paul Louvel <paul.louvel@bootlin.com=
> wrote:
>
> On Sat Oct 3, 2026 at 11:23 PM CEST, Rosen Penev wrote:
> > The talitos interrupt handlers schedule priv->done_task[] via
> > tasklet_schedule().  In probe(), talitos_probe_irq() ran before
> > tasklet_init(), so an interrupt arriving during that window (a shared
> > IRQ, or a completion pending from an earlier transmission) would
> > schedule an uninitialized tasklet.
> >
> > Resolve the IRQ numbers before the tasklet_init() calls so the
> > done_task[] selection can see the secondary IRQ, and only request the
> > IRQs after the channel fifos are allocated and the device is
> > initialized.  Every structure the handlers touch is then fully set up
> > before interrupts are enabled.  This matches remove(), which frees the
> > IRQs before killing the tasklets.
>
> LLM tends to be very verbose on commit messages and describe what the git=
 diff
> could already tell us.
> The second paragraph could be resumed to:
>
> "Request IRQs after the necessary data structures are initialized, so tha=
t
> interrupts do not schedule uninitialized tasklets."
>
> >
> > Assisted-by: LLM
>
> There are some available skills to improve AI wording, or you can make on=
e
> yourself tell it to avoid verbosity.
>
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  v3: reshuffle again to fix IRQs.
> >  v2: reshuffle code to avoid NULL derefs
> >  drivers/crypto/talitos.c | 48 ++++++++++++++++++++++------------------
> >  1 file changed, 26 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> > index 41a87d7c30a0..70f7ad9e09f9 100644
> > --- a/drivers/crypto/talitos.c
> > +++ b/drivers/crypto/talitos.c
> > @@ -3353,21 +3353,13 @@ static int talitos_probe_irq(struct platform_de=
vice *ofdev)
> >       int err;
> >       bool is_sec1 =3D has_ftr_sec1(priv);
> >
> > -     priv->irq[0] =3D platform_get_irq(ofdev, 0);
> > -     if (priv->irq[0] < 0)
> > -             return priv->irq[0];
> > -
> >       if (is_sec1) {
> >               err =3D request_irq(priv->irq[0], talitos1_interrupt_4ch,=
 0,
> >                                 dev_driver_string(dev), priv);
> >               goto primary_out;
> >       }
> >
> > -     priv->irq[1] =3D platform_get_irq_optional(ofdev, 1);
> > -     if (priv->irq[1] =3D=3D -EPROBE_DEFER)
> > -             return priv->irq[1];
> > -
> > -     /* get the primary irq line */
> > +     /* single (or primary) irq line */
> >       if (priv->irq[1] < 0) {
> >               err =3D request_irq(priv->irq[0], talitos2_interrupt_4ch,=
 0,
> >                                 dev_driver_string(dev), priv);
> > @@ -3379,13 +3371,11 @@ static int talitos_probe_irq(struct platform_de=
vice *ofdev)
> >       if (err)
> >               goto primary_out;
> >
> > -     /* get the secondary irq line */
> > +     /* secondary irq line */
> >       err =3D request_irq(priv->irq[1], talitos2_interrupt_ch1_3, 0,
> >                         dev_driver_string(dev), priv);
> > -     if (err) {
> > +     if (err)
> >               dev_err(dev, "failed to request secondary irq\n");
> > -             priv->irq[1] =3D 0;
> > -     }
> >
> >       return err;
> >
> > @@ -3404,12 +3394,27 @@ static int talitos_probe(struct platform_device=
 *ofdev)
> >       struct device_node *np =3D ofdev->dev.of_node;
> >       struct talitos_private *priv;
> >       unsigned int num_channels;
> > +     void __iomem *reg;
> >       int i, err;
> >       int stride;
> > +     int irq0;
> > +     int irq1;
> >
> >       if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
> >               return -EINVAL;
> >
> > +     irq0 =3D platform_get_irq(ofdev, 0);
> > +     if (irq0 < 0)
> > +             return irq0;
> > +
> > +     irq1 =3D platform_get_irq_optional(ofdev, 1);
> > +     if (irq1 =3D=3D -EPROBE_DEFER)
> > +             return irq1;
> > +
> > +     reg =3D devm_platform_ioremap_resource(ofdev, 0);
> > +     if (IS_ERR(reg))
> > +             return PTR_ERR(reg);
> > +
>
> You are dropping a previous error message here, use dev_err_probe().
Actually in this case I'm removing an extra error message.
devm_platform_ioremap_resource prints its own.
>
> >       priv =3D devm_kzalloc(dev, struct_size(priv, chan, num_channels),=
 GFP_KERNEL);
> >       if (!priv)
> >               return -ENOMEM;
> > @@ -3425,12 +3430,7 @@ static int talitos_probe(struct platform_device =
*ofdev)
> >
> >       spin_lock_init(&priv->reg_lock);
> >
> > -     priv->reg =3D devm_platform_ioremap_resource(ofdev, 0);
> > -     if (IS_ERR(priv->reg)) {
> > -             dev_err(dev, "failed to of_iomap\n");
> > -             err =3D PTR_ERR(priv->reg);
> > -             goto err_out;
> > -     }
> > +     priv->reg =3D reg;
> >
> >       /* get SEC version capabilities from device tree */
> >       of_property_read_u32(np, "fsl,channel-fifo-len", &priv->chfifo_le=
n);
> > @@ -3481,9 +3481,8 @@ static int talitos_probe(struct platform_device *=
ofdev)
> >               stride =3D TALITOS2_CH_STRIDE;
> >       }
> >
> > -     err =3D talitos_probe_irq(ofdev);
> > -     if (err)
> > -             goto err_out;
> > +     priv->irq[0] =3D irq0;
> > +     priv->irq[1] =3D irq1;
> >
> >       if (has_ftr_sec1(priv)) {
> >               if (priv->num_channels =3D=3D 1)
> > @@ -3540,6 +3539,11 @@ static int talitos_probe(struct platform_device =
*ofdev)
> >               goto err_out;
> >       }
> >
> > +     /* enable interrupts once the channel fifos and tasklets are set =
up */
> > +     err =3D talitos_probe_irq(ofdev);
> > +     if (err)
> > +             goto err_out;
> > +
> >       /* register the RNG, if available */
> >       if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
> >               err =3D talitos_register_rng(dev);
>
> I guess to be 100% correct, IRQs could be masked at the beginning of prob=
e
> and unmasked at the end.
>
> Thanks,
> --
> Paul Louvel, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
>
