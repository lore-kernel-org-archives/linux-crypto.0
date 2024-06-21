Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BBF16DEC5
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 22:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719010561; cv=none; b=WvpP7G7rjzBV4OGSY0/AiTY6adh0/WgcNxzZo5aZMtLkXcWr7JfkjyPm751T/M+RVCn6nmeaG9nCor0hdAAw10mZIRG7d3Va5ZI31P7a+vgkYFMVg6lzXX8d5XDGX/3VrkPMjqF69Iypk9jYxl5Bt0MwRDZiV8kZPlSRroSRgc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719010561; c=relaxed/simple;
	bh=/fGMQstslMAQ1sAwKBQnY3piKVTdf0FZ+sfr3d5+kQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIbQzVfS54YxsdpKMabx4PmAxdRXkz1/WR0D37xknlzxpuPpTuCAPegHoClnPJ7YLJtsUFTaYkewed4guypyAqrLVwlulYBCmyPkF2iCUwT9mqPM6Ihn4lhEltwbeLnT7qwX+m6rOz5b0EMAZazy5+F49CDfLR9Z8V61kf8DmDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qffyzywr; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qffyzywr"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-63ba688bdc9so25015047b3.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 15:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719010559; x=1719615359; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/fGMQstslMAQ1sAwKBQnY3piKVTdf0FZ+sfr3d5+kQU=;
        b=QffyzywrIMiiOUDrInGm2s+cz3kMzPYkPPwCFB3j5KIOPr355fiTeqBYglaNXBe054
         kCKazQ5sK0diOLVl19gQcT7DWvlNfZAoPYqYtF3KWCYarWFh7qPu/1w7D6RED2aVQVw6
         /5FBs/KRahanQgxXCbMs1L+Xe8cvCYNl/hVQX9XCQT+qUY96wZMe4CDwce54IZCI/c7Y
         J0Op/PEeumJUez43jQjjkOZBNQlDFtM+rqLnVUgEq1WZovuULnjt74yEK8oZqSDI9s51
         ZWEGUfNCgPwD1v1By3ODqSe4Bm6NBA9Af9DAhECATRlAWH+nbIEG9hC8PlSCEXVnPKbv
         C1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719010559; x=1719615359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fGMQstslMAQ1sAwKBQnY3piKVTdf0FZ+sfr3d5+kQU=;
        b=exm4fz7/6Vn0a1hPj/Vb9jiiGWF1wLmVK7yYMoUSp2gQJ/OBd5+1kdV2kZar4LdI86
         7W/XvXgkGt7vm3ZKjI11ESRV4DS1wqUDuo+7X+hRZ0kXxtoW9GpIK6vecyhy4SVntsl2
         o19us0mFfjOLTyhDG7YDMx1y7VBzM2N410+s6YH8+qJYJ+S1Zo4sObBTstsM2N84OC1w
         FFCtaywmvGXRBcVw+7psv85U16rp9M3ExiHMfyXJGj8duBq2R2xbVZ+z0sGNWE1zAKZV
         WoJhVaQtaam9SRnwS+hGf/IJ8f5fEDBTC2iv1i2aIUHRJVqt3NDduRpqGIDhKNGhRdud
         /egA==
X-Forwarded-Encrypted: i=1; AJvYcCXXxBKYwSQsNCmtkcyjxFwZJoexJE2B221A2W9QOQNW1fZAT51XLLlSgXp9CGDFkpwPKweL/K6b0nMrKEiyIA/4kC7UZr4Xr+6qJdtU
X-Gm-Message-State: AOJu0YxFBshBC6Lsdk4JMHoexww5aZRFSWmvzrbFWkGpiK+azmpYJs4x
	vkTZo3gYEEK/kqy7Vd6NONAaOSQdemSUsL1k2gTqqHyXdzutEkvbAUPGEKqahyQ0Jxg1ztlM8QQ
	CoXQR6DOxCyWo/Se5wjGH9eyowiZnyshGHAo8CQ==
X-Google-Smtp-Source: AGHT+IEADyU6jrow5QVvxIIaLO6aTLEpPe+v44mG82CDywhDOOxA21g7uo+yUCib/NcuqiEIGJo5wYXwLqozIVXQNcg=
X-Received: by 2002:a81:be12:0:b0:62f:23c3:1b68 with SMTP id
 00721157ae682-63a8f9fb0b9mr92774257b3.48.1719010559268; Fri, 21 Jun 2024
 15:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240621221113eucas1p25c2fbadceef48913c4a7b164e6d14890@eucas1p2.samsung.com>
 <CAPLW+4njmKxXSMqNazX6t6LS=fHNh6Pi8_icF1=aPw27G0J3PQ@mail.gmail.com> <oypijdcyoarlou.fsf%l.stelmach@samsung.com>
In-Reply-To: <oypijdcyoarlou.fsf%l.stelmach@samsung.com>
From: Sam Protsenko <semen.protsenko@linaro.org>
Date: Fri, 21 Jun 2024 17:55:48 -0500
Message-ID: <CAPLW+4nQa_hnqg=UxgZ7EZ1z26HX+Y0Y-fV8rtHb4Sb7NQ47CQ@mail.gmail.com>
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

On Fri, Jun 21, 2024 at 5:11=E2=80=AFPM Lukasz Stelmach <l.stelmach@samsung=
.com> wrote:

[snip]

> >> This is good, thank you for adding it. It can be even better though, i=
f
> >> you don't skimp on message length (-; I mean, I know what BL is, I can
> >> fingure what LDFW is because you have explained to me and I can see th=
e
> >> source code, but somewone who sees it for the first time will be only
> >> slightly less surprised than with v2 error message only. Come on, you
> >> can make this message twice as long and it will still fit in 80 charac=
ters (-;
> >>
> >
> > Guess my OCD got in the way and I just didn't want to break the line
> > :) But yeah, LDFW =3D Loadable Firmware, and BL =3D bootloader. There i=
s
> > an "ldfw" partition on eMMC, and I noticed Samsung usually uses LDFW
> > term, so I figured it was not a big deal to throw that abbreviation at
> > the user. But I totally agree on BL part, it might be confusing. I
> > don't have any strong opinion on this one. If you are going to apply
> > v3, can I kindly ask you to change that message the way you want it to
> > be?
>
> I guess Olivia or Herbert will be applying it. Let me try=E2=80=A6 How ab=
out:
>
> "Check if your bootloader loads the firmware (SMC) part of the driver."
>

Much better. Thanks, Lukasz!

> >> Don't change it if v3 is the last. If not, please, make it more verbos=
e.
> >>
