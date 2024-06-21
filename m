Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCAC179203
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718998823; cv=none; b=j5kdkCre+QNrieGv3RuCdcSPJz8oaqUZI6o/NC2VINug4HYjG5C944BMF9mQU7yU+AGdPgYG2KicdlGZJOiDKZY7K2KJaIGAY7i2XWJs7LJB9v7RV2dxu+x5ctLm6zDM8a3MoUpc7U4ZBcy5YrkV0jqnHjr1DtkVzPLtljxbv4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718998823; c=relaxed/simple;
	bh=6ZPeCGjV8WBzKchfn6bhJls+sDUkHecdyn5jbswwMA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FG+CQNfjFAXgBzf5TPpbRvnlBVt7Sn2+duczmZ7Hs/TyjUIKyZNPmmnbZCXiPuR/YsfwVWC4vG5DCdi81nvhxHJb7cL0lBnei5c4FNoF+CakD8IS6khG43NxEJL9IhM9afCDFqpagSP53fTTKd//QjDWeNHOgVCLE9kLNPtgl/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NdrVElxF; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NdrVElxF"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6325b04c275so24293907b3.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 12:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718998820; x=1719603620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbwyiyWva+x9FYZsLEbwDcBJqBAnnNSOVrVdnz/JzOg=;
        b=NdrVElxFQdKgDZffEK30KtUnF8EkQcdiH4pR6F9xg+kf3PV/XMU0BTo70omSG9QFe6
         K0AwFsYmwmsM5ikZNeUbvWF8fJCmZ3DXo/INLp7J1mNHxxSA3Y+nFOAPQ7FK6NSgDZwu
         THNaVoWMHG2DZYsT4EnDGXv15FGp9stvRPcRS6lzFjWdmqQnMafbxeL/HRUn2d06rtul
         TBWf2cad3lgIIcKFa0F/Q0Hrr/93ehezxTucLnWM1ywy4GkrZK2V8K9mO92z0XYgTwt6
         bgnLUfhpqmyLpKIp9mUZdbQmSiCMtrVpMb9E86M5cpRk3x3J4wsovqQqHv4pP/rxlis7
         T/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718998820; x=1719603620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbwyiyWva+x9FYZsLEbwDcBJqBAnnNSOVrVdnz/JzOg=;
        b=lA386KeO6ZOKhl8/E9Ngxfxu/enMAHW2z/K61iWxS2VDiUCG0SdlEDUFhs8a1zvqJV
         BSB7vd8TH3jIKk6x+OHNTP8LYUl32BpdJ+jS3SXw+gogZW2II+9L4S9idCMo8f8VMaPG
         6HWCZrdV9DMxPuIJIFhau9o039JoTH+Xp6mgnK/a+V+vJWqBDfnwbrl9twNpgFmgap0T
         H7f9IRMuOV5B/fCC3w/KAOjQaSicc7aTNriesX3uOCThcQk56RNc3h+9QWKaGwIloo9E
         KqfOhZiiiMy3HfMX+M17i/7jlyrbbE+zl0cJ9Ah6iV/0B0vXXHmCJ1AK/oKCcUUhVBf5
         +Jkg==
X-Forwarded-Encrypted: i=1; AJvYcCUfNVyfxS20NICKBHotPAT2d43cVN/UxpQkD8VQ9CEhFc1TTVY62RyWqYA012fcJ5n8XIQHq3UJjpuXSsYNi5JSS6d66hT4XCaMgf7D
X-Gm-Message-State: AOJu0YzfXExIyykVV3HTwpc09xE5RyCvptSS7tekd7y1KBWXH9L0e8Sn
	0935VdSZqB9jRkzXPV1UDFhD0i0G3lxktO8gDboVXUkZd6B3p/yC9pPaoJDa1rE6r7O+7D0qghU
	5Ktcpl3qXz/yFY8z0YTuFB8d8rjMRTA3Z7pcgwA==
X-Google-Smtp-Source: AGHT+IEmV0m+/TjcKpWT6y40NzpmbgGYoiiKNqdKPlOSZ6tUU44/DxfiY84Ds0g2/sBfdjZbnUd1cxbqC/UhcIk3SWg=
X-Received: by 2002:a81:f805:0:b0:62f:cb31:1be with SMTP id
 00721157ae682-63a8d543d67mr96963607b3.8.1718998819708; Fri, 21 Jun 2024
 12:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240621190049eucas1p28ba502d86e2f9380315c06add645517c@eucas1p2.samsung.com>
 <20240620231339.1574-6-semen.protsenko@linaro.org> <oypijdplsaruia.fsf%l.stelmach@samsung.com>
In-Reply-To: <oypijdplsaruia.fsf%l.stelmach@samsung.com>
From: Sam Protsenko <semen.protsenko@linaro.org>
Date: Fri, 21 Jun 2024 14:40:08 -0500
Message-ID: <CAPLW+4njmKxXSMqNazX6t6LS=fHNh6Pi8_icF1=aPw27G0J3PQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] hwrng: exynos: Add SMC based TRNG operation
To: Lukasz Stelmach <l.stelmach@samsung.com>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Anand Moon <linux.amoon@gmail.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 2:00=E2=80=AFPM Lukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>
> It was <2024-06-20 czw 18:13>, when Sam Protsenko wrote:
> > On some Exynos chips like Exynos850 the access to Security Sub System
> > (SSS) registers is protected with TrustZone, and therefore only possibl=
e
> > from EL3 monitor software. The Linux kernel is running in EL1, so the
> > only way for the driver to obtain TRNG data is via SMC calls to EL3
> > monitor. Implement such SMC operation and use it when EXYNOS_SMC flag i=
s
> > set in the corresponding chip driver data.
> >
> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > ---
> > Changes in v3:
> >   - Added appropriate error messages for the case when init SMC command=
 fails
> >
> > Changes in v2:
> >   - Used the "reversed Christmas tree" style in the variable declaratio=
n
> >     block in exynos_trng_do_read_smc()
> >   - Renamed .quirks to .flags in the driver structure
> >   - Added Krzysztof's R-b tag
> >
> >  drivers/char/hw_random/exynos-trng.c | 140 +++++++++++++++++++++++++--
> >  1 file changed, 130 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_ran=
dom/exynos-trng.c
> > index 6ef2ee6c9804..9fa30583cc86 100644
> > --- a/drivers/char/hw_random/exynos-trng.c
> > +++ b/drivers/char/hw_random/exynos-trng.c
>
> [...]
>
>
> > @@ -103,6 +163,24 @@ static int exynos_trng_init(struct hwrng *rng)
> >       return 0;
> >  }
> >
> > +static int exynos_trng_init_smc(struct hwrng *rng)
> > +{
> > +     struct exynos_trng_dev *trng =3D (struct exynos_trng_dev *)rng->p=
riv;
> > +     struct arm_smccc_res res;
> > +     int ret =3D 0;
> > +
> > +     arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0, 0, 0, 0, 0, &res)=
;
> > +     if (res.a0 !=3D HWRNG_RET_OK) {
> > +             dev_err(trng->dev, "SMC command for TRNG init failed (%d)=
\n",
> > +                     (int)res.a0);
> > +             ret =3D -EIO;
> > +     }
> > +     if ((int)res.a0 =3D=3D -1)
> > +             dev_info(trng->dev, "Make sure LDFW is loaded by your BL\=
n");
>
> This is good, thank you for adding it. It can be even better though, if
> you don't skimp on message length (-; I mean, I know what BL is, I can
> fingure what LDFW is because you have explained to me and I can see the
> source code, but somewone who sees it for the first time will be only
> slightly less surprised than with v2 error message only. Come on, you
> can make this message twice as long and it will still fit in 80 character=
s (-;
>

Guess my OCD got in the way and I just didn't want to break the line
:) But yeah, LDFW =3D Loadable Firmware, and BL =3D bootloader. There is
an "ldfw" partition on eMMC, and I noticed Samsung usually uses LDFW
term, so I figured it was not a big deal to throw that abbreviation at
the user. But I totally agree on BL part, it might be confusing. I
don't have any strong opinion on this one. If you are going to apply
v3, can I kindly ask you to change that message the way you want it to
be?

> Don't change it if v3 is the last. If not, please, make it more verbose.
>
> > +
> > +     return ret;
> > +}
> > +
>
>
> [...]
>
>
> Kind regards,
> --
> =C5=81ukasz Stelmach
> Samsung R&D Institute Poland
> Samsung Electronics
