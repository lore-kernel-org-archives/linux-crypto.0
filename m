Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3EF16DC20
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 20:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718742337; cv=none; b=otsm1flmKSC4LqNlRxEXwEoEeuWR7mvY2XeyuHQXEs1iKH1LSZ9rPmH198gGHeEuDvhtUPogicUXQnDfQdpeGq6H01dVxPDceTPLz9RaKuvrNZJoWS0fpvWSrGDjjc3L/+M9bShfL5rDWHp9Y8re4uqG2Z6ZsSsrbe+vAaKMLu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718742337; c=relaxed/simple;
	bh=YRwOsnVFLe6p/kcwQwqv47N4rgTeTPM2k+Ln+QF8Fh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJhkJ3e+elxUyTfYs+e9Kbrss5OGsVc7F12aCGfHL5iDJsx6FlOsBz/+QlU6N9WBAoR4PronZEeiXzLiTlUAfBzzaEy+cwRVriHwx/Mrzlcn7lQMsUrnlqEbM6vxVS+vOvVMIKsOKBuhdtbFt/eTeo+nxjlkMK+Ik15BHJ87yRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qXXXbIE+; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qXXXbIE+"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6312f1f83d9so44265327b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 13:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718742334; x=1719347134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w90+p3jzlFRMUniSo2b8ogKD0Fur+lnhSGZA3lnaqUs=;
        b=qXXXbIE+NKRMPRbDJwPrtNn5CmdceaKOHH5JlhyyOQlJKlNuQGoJ4mGPoe1VMNZKcU
         6Vi/ekRKMExenrWocUrnrXnSc1vWoRQq+AAGVybfWkfN+pgH9l4jOGPuMuI6eXeaZRzb
         XQCZlrvX+VpNACZDxILsOiOjELsyZmmSmp87DiK6KxbnhTB7MRWlwTSaRTK+JHhwcQTt
         Ol7AB/Xrv1uib6sDl+LwoD3L3c0WNrFyzy3X2dT8AOj8sooho/3dgT+K64j8SAut96NO
         ad4LNaHr8toHP98dw/9jGzMUpAUcrOeURfOz1pUGagpMPEU67nC+zZjib9XRUxi8ehTW
         WTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718742334; x=1719347134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w90+p3jzlFRMUniSo2b8ogKD0Fur+lnhSGZA3lnaqUs=;
        b=vwO0rvIyP4mz2cSmcSRJIIKLXwj+3bCUisx56DqDwoHKLsKh6UjSSY2gZQYriG0HTk
         vAmnbJT39ULGf1UxHKpHThebXZMsgo/ZewfhM6xq/uh9bFqjkaJH3rlNK5qBm1LuTbT7
         LzcfuDWeyody8tacsRDBa7KloX/hn+p5baoMkvhIlraR4ZKacMTMdd7zm76bquVzsSjc
         NU7f04+k5c4UaqwCQou4aN3t/MHxpNtMZST0S3qNtZ9qS9kVEexzxtK/c37S3BspyGMD
         cqT+qLhupNbDEN27apyjkpy56OhjN3+s+bUgHmSNFtIh4DCZJrS1vqwHsioOx52H2XJk
         yajQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv5n96yY3XCt/2zgJW1xXqg4Q0/+VdqtGLBvxG/LWbPfgzAupjNAJl0oGMKYLD54V6L+iCmQciaR1ZxnjpjmNMWV9yG2kpxPBcfCoo
X-Gm-Message-State: AOJu0Yw2USbrivAPvk2H3sYakJf9e5M+TtZYRLUFQj4fWIw9BuobRC+B
	y7QnL4bwbZr8SUFhxFgc5SSXPqIPFHvq9pUH+JBMuH6EXaAehA1drygF+VTN3XgupnMV6yh3c4x
	56sUBga/t7hXJkPNENx9ZNpdbB34EZUpmb6H5teHUZdm60OUfY/E=
X-Google-Smtp-Source: AGHT+IGpLhokgo384YPPtzeum2gZbC5i+iA9FZlR28A17rfQt8gwax2e5rYT0RauGBa3Y+2aEIDe9j1FBX0e6anXkkM=
X-Received: by 2002:a81:7e0d:0:b0:62f:37c9:77bc with SMTP id
 00721157ae682-63a8ac68875mr9831877b3.0.1718742334043; Tue, 18 Jun 2024
 13:25:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618003743.2975-1-semen.protsenko@linaro.org>
 <20240618003743.2975-7-semen.protsenko@linaro.org> <94d50353-15ba-4769-bd98-57f4430f5fc2@kernel.org>
In-Reply-To: <94d50353-15ba-4769-bd98-57f4430f5fc2@kernel.org>
From: Sam Protsenko <semen.protsenko@linaro.org>
Date: Tue, 18 Jun 2024 15:25:23 -0500
Message-ID: <CAPLW+4mHA4GHHX8TQa-CvMkYBU8me=q=cxKXLWwypGxpOtMpCQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] hwrng: exynos: Enable Exynos850 support
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 1:39=E2=80=AFAM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 18/06/2024 02:37, Sam Protsenko wrote:
> > Add Exynos850 compatible and its driver data. It's only possible to
> > access TRNG block via SMC calls in Exynos850, so specify that fact usin=
g
> > QUIRK_SMC in the driver data.
> >
> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> > ---
> >  drivers/char/hw_random/exynos-trng.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_ran=
dom/exynos-trng.c
> > index 98b7a8ebb909..3368a08df9ce 100644
> > --- a/drivers/char/hw_random/exynos-trng.c
> > +++ b/drivers/char/hw_random/exynos-trng.c
> > @@ -333,6 +333,9 @@ static DEFINE_SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops,=
 exynos_trng_suspend,
> >  static const struct of_device_id exynos_trng_dt_match[] =3D {
> >       {
> >               .compatible =3D "samsung,exynos5250-trng",
> > +     }, {
> > +             .compatible =3D "samsung,exynos850-trng",
> > +             .data =3D (void *)QUIRK_SMC,
>
> Probably this (and in previous patch) should be called flags, not
> quirks. Quirks are for work-arounds.
>

Thanks for the quick review! Will submit v2 soon with all the comments
addressed.


> Best regards,
> Krzysztof
>
