Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1D1E4A9
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jan 2025 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737380816; cv=none; b=S1e4NAfU/x5Ks1y3bnOT9LIjMXtfmRODptGv3ppqdPDWqiKfWE48e+Vm6Y/8Nd0n3rTkmlFBOD52j3HwFrZe2w8hcl+Zp3X+BWLGbEIm7Ik13wawF5p1GM2Mqv8O9x23MZ18SE9Cr6RAWBC9PS0QUD8NhEeQDQHrp4DhUdBzHCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737380816; c=relaxed/simple;
	bh=vdaZayPM67nF/4Tn0WCZcfScGglX0NHRO8C3emddbL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DdQTY6MuZgTVv7thOB9JT6kkBQvtStdPyUiC3jrX62O7/ioWhqQ+YUyfyGmDvWa5F4mnKIR2VgGcSarPze5H/52yrq/4uqspy0GgDiHpv5/1peJyMFtEBKrcOOuBt3O10v1QmdQLiiUdy/xjT5SWvUYDScH3lWqmiaAa90tZj2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=glF0BiAO; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="glF0BiAO"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30613802a04so46923681fa.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jan 2025 05:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1737380813; x=1737985613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7uWym8aviUECTT7NP343rKz7l6AiGEcMJ6zJloUFKk=;
        b=glF0BiAOrO09M02qRo93wBo2eSSg925tV8xA011LlxTUkk4hS/8DkLMvp+a+B9pVHj
         rxsJpc4NPsPhyUud+srxrdSIGoJmak0gzqFdVB5cyGiBrPKrGGcyvO1xdo5/ouhgaV2T
         ui42LVJBOHSx9sjxtiunxtQmF4B6OtZmwipO9l8OmYFC/wyY3rDNCj4cEYC0Po2bS7kP
         YPwlKRXThhSyEluIkeSe7Xg/dzUqNHF/Ia3U3KcameXlWFV4xgPDvP6Pdt2SMUzDPldt
         Oh1Z1zU3B6Xcy9Sfd3zitpDCwOlWADKsdOES5rKaJGHhJEud0aueLDsOqZ+Z9LiVUdSo
         P3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737380813; x=1737985613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7uWym8aviUECTT7NP343rKz7l6AiGEcMJ6zJloUFKk=;
        b=V/ZJ45l+0tBFybqvbbBQ3ftCGV9cOmhRrEtwNy1NK6A3OfRRjLUVEpYaiLc1YFmo4g
         03UZCX9cbvZxN/JDMn3+zmqG1M7zc2ctQL7NoRNSLtgBpYd8SXrF0tOUh+CM5/pL4UTk
         lYRA4vZejdK0b+637oJuBv5gKfOoYUo/4RCrrp/rUvXCig1R1hP9pH6UohQS07nhR+Qv
         hl/5eJmSMOMyS4vWuY6C9iGZTvVChieIz4vLssADZ5ElSHfQmASbyCptRXhDtSf/rN7W
         /y4OGsg9j25K29clPbGYv7ckZilLM2vEj5HUsul43DWAU8e6yUG0AmlalkVyesG1CGIK
         KeIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGvwSDLoBcUdZVYjhfjwiCjH3CSGjofdUgWHR8BJ0CiDkUKV8wecW2Vo1MurraOBm7UJVVcQ4ZZRAKLZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTG9mMXxH4LEarLsTzantzSUCEJdjcKcPjo8qPxc5FGtJ90Nxk
	3O9jZcWVn5O3YcsEukhGlbyD+/1X1nDl44PLHOanVGIhnt1v/LeoLHyFXM1yFhzh6eWXokYbnUL
	VTrCcP1Lq0gElzG12cKV/E8caJK4vt45w9ZEf0A==
X-Gm-Gg: ASbGnctltPlt8MKiYeJpXQd8wqrOU5I1FSU6KgEjoZOsN66Lw03WatQUDkkbCEqmmvN
	duPgnGNhAIBnFjMaEWSlF5nFjSUHcl80fSNnUlF7QfV4vQP2sGYzTqKRW9aTjwnNsS9DeIXiTRg
	U4h3dmjKI=
X-Google-Smtp-Source: AGHT+IGQFrCMm8vyRK8vl4hzwtqFf/36t7jhpPxV0M0zp0y+Zz7oKVbBwOYsm8AIgJwc3bHgZHJIcWkIRU9kVfObBko=
X-Received: by 2002:a2e:8e76:0:b0:2ff:c67f:5197 with SMTP id
 38308e7fff4ca-3072ca6a6bfmr38519261fa.13.1737380812745; Mon, 20 Jan 2025
 05:46:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-9-c5901d2dd45c@linaro.org>
 <d6220576-eaf5-4415-b25f-b5984255ab78@linaro.org> <CAMRc=MevaM4tUNQUs_LjFYaUtDH=YqE-t2gBponGqtK5xE9Gpw@mail.gmail.com>
 <20250118080604.GA721573@sol.localdomain> <CAMRc=MeFMYzMY4pU9D6fEpg9bQuuzqg4rQhBU8=z_2eMU+Py-g@mail.gmail.com>
 <20250118175502.GA66612@sol.localdomain>
In-Reply-To: <20250118175502.GA66612@sol.localdomain>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 20 Jan 2025 14:46:41 +0100
X-Gm-Features: AbW1kvadA5qf4pLYrGVbYIj86oGONAxbZ9gOjq4aNXiA4bcW9hoyMMQqNC0e_GE
Message-ID: <CAMRc=MdR-8AnwAsMzHn8zj2awZUumO32C_S1-CkjBEqbuKPdeg@mail.gmail.com>
Subject: Re: [PATCH 9/9] crypto: qce - switch to using a mutex
To: Eric Biggers <ebiggers@kernel.org>
Cc: neil.armstrong@linaro.org, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2025 at 6:55=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Sat, Jan 18, 2025 at 10:28:26AM +0100, Bartosz Golaszewski wrote:
> > I was testing with kcapi-speed and cryptsetup benchmark. I've never
> > seen any errors.
> >
> > Is this after my changes only or did it exist before? You're testing
> > with the tcrypt module? How are you inserting it exactly? What params?
>
> Those are all benchmarks, not tests.  The tests run at registration time =
if you
> just enable the kconfig options for them:
>
>     # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>     CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy
>
> The test failures and KASAN error occur on mainline too, so yes they occu=
r
> before your patchset too.
>
> > >
> > > I personally still struggle to understand how this driver could plaus=
ibly be
> > > useful when the software crypto has no issues, is much faster, and is=
 much
> > > better tested.  What is motivating having this driver in the kernel?
> >
> > We want to use it in conjunction with the upcoming scminvoke (for
> > loading TAs and invoking objects - used to program the keys into the
> > QCE) to support the DRM use-case for decrypting streaming data inside
> > secure buffers upstream.
>
> Notably lacking is any claim that any of the current features of the driv=
er are
> actually useful.
>

Noted. I'm still quite early into working on the upstream-bound code
supporting the streaming use-case but I will consider a proposal to
remove existing features that are better provided by ARM CE.

Thanks,
Bartosz
