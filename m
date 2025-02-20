Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2A1EC01E
	for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 09:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740042875; cv=none; b=ozGLl584qZJXhcwAqM2p0Hmf/DS/eqUsAH8YAETDPzQFbpRvESE5NIEuXFNSNNaeApTmqCozSlmZFmyD7rxU6Tcf5oUKYZJ3MGuGiLqXJ/xzeDnbg7Wq0pnZpA0iyf+wjcstalm8dVab82p7hlieGNug0q1wPZWDog3rkFl9+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740042875; c=relaxed/simple;
	bh=om7yOLIM4Ad44rWX04vkNnR2zDaq3Mg4yJhaSd/Zw78=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XFD6PoI+5oPE7qButcIuvwZTjLiCArahRmHBbRYHU7Gz30/a4ca6GDDrqkUqWLRC6jIzamBgLVYHVjTc9tmk64B87i7XwaM4xH0KwK5lVMci0SQ2S0CBP7Ys5ZSvLLkM4XOI467fVvLfcKdnVQDQWRpZcwOPIxJH/wDLBlhBKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=rPJbbMWg; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="rPJbbMWg"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-545284eac3bso760156e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 01:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1740042871; x=1740647671; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAr22/D1YzPwh7QCkaq5V8bcpDKGDV5/adht3f1OxvU=;
        b=rPJbbMWgp6xlSGg4MwxwGM7WfWEWw1WzxxhSMPxQDQHSmf9yzJ5GTZ01RuzfBWhNb6
         /9omKBlASAwDQBL6jrFXS93MhpRvc9SNjLPRa+0EIeUtfsP/KJ2T38BPTTi8haUhxOU1
         HpWJTkocYUZefcQ3utJsst3rv+MgTJ03NJGURM4mN2XWGcdfvMF3863KQb4nhGiy/7G2
         5NEve38fYDJG9xOJ2ZJJNOBP+nT1E6BMJPmVt5xae9dScGWPKc4JYy6C+UW8jQcdyKQB
         tDbOqYvLTYYZ+VnTuBOj0NENdf3pjiYK90oZhTq0oq14+dCil0d5kOeFkW0lw3iFSh68
         Hq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740042871; x=1740647671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAr22/D1YzPwh7QCkaq5V8bcpDKGDV5/adht3f1OxvU=;
        b=myj2RU6MqIzPGQ/Bw49ELslNTUU1A0KqiY3SVNGoIxDYUYgKJY8QDqdSNbBtUf5lal
         PGyOx/TMJ0yxwuB/fj9eGlq/6lTIRycCXuzWE6Sq2RNZdGDOEa857ejXD7bNMf4MFbTz
         RXhCHUhtaWXE+Lt5X6PDhCVYPAi0zReayjzx/GTQwtztZRwHP/IY5w32IA6yiqg6h2X6
         yTmRcHWVtelZ894tRoPmI8osfrTaf/vQHdGWVo5m25M8BitcfSc/VhpLmYbAZvgeE1rJ
         2FbsQANO1j4f/JMSFoMwxFvYVly0VZXoOoPBgZv9mFo3xHZkgr2A7V76uvQYzTYKVLBl
         ILQw==
X-Forwarded-Encrypted: i=1; AJvYcCWYSRO28cR9+K27DSsqQw7ZNBJ7Tl2HCn0o1cVYLgr+Jn9/T6Q74Onu9113V4fWv1vE8hXuWnN6RmYwGiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMLGtcujWukCxwyUbbxev+oELmRX4f+EsRP6Zm8DDYfylIs27d
	Wy/emx7RD63G3FWHHc75zmCC6fdkhdjVYAIZJpIE8avtcB+q0g5nxUjTM6XK2gM70oljK/DPjGT
	R9OumNcLfapZNdMGiRkeOsIzpixfsTASoc0DNAsCs0zqDNbfNVwQ=
X-Gm-Gg: ASbGncsbs1WkBvSBPzk9NhIWZP4sKCoUvq/4ZyxUcaNEDg7ikZhrEDFuovhq46MR20D
	dPD9kJBhFEYHoPyA/TtHXX7vYTeH5STOLInK23quGT5k9tXnt4I/lpJ6CYAsgm4sdcjE0tO9kEa
	GCQXbpL71OQQ9Y2ZfbsDg6mFtR2wQ=
X-Google-Smtp-Source: AGHT+IHSPk6Oq0kN0bLQwT6LYgMpvGNXVM8z3YJ10Sgvpi/62DQHM13T2sWJ5hnnJGbM2z7QUetZC0ghr5VjffIw3AQ=
X-Received: by 2002:a05:6512:3d15:b0:545:a2f:22bd with SMTP id
 2adb3069b0e04-5462ef23810mr3094783e87.48.1740042871206; Thu, 20 Feb 2025
 01:14:31 -0800 (PST)
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
 <20250118175502.GA66612@sol.localdomain> <CAMRc=MdR-8AnwAsMzHn8zj2awZUumO32C_S1-CkjBEqbuKPdeg@mail.gmail.com>
In-Reply-To: <CAMRc=MdR-8AnwAsMzHn8zj2awZUumO32C_S1-CkjBEqbuKPdeg@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 20 Feb 2025 10:14:20 +0100
X-Gm-Features: AWEUYZnkjAHblurQfFOh0krxMz1j95KqvuePKe-B0dN-covm1P8mMeq0vp8hQYU
Message-ID: <CAMRc=MetohPUcxRLO0qS-LYyzZhiAMAHzLm0xqX8_TXdTgBnVA@mail.gmail.com>
Subject: Re: [PATCH 9/9] crypto: qce - switch to using a mutex
To: Eric Biggers <ebiggers@kernel.org>
Cc: neil.armstrong@linaro.org, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 2:46=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl>=
 wrote:
>
> On Sat, Jan 18, 2025 at 6:55=E2=80=AFPM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > On Sat, Jan 18, 2025 at 10:28:26AM +0100, Bartosz Golaszewski wrote:
> > > I was testing with kcapi-speed and cryptsetup benchmark. I've never
> > > seen any errors.
> > >
> > > Is this after my changes only or did it exist before? You're testing
> > > with the tcrypt module? How are you inserting it exactly? What params=
?
> >
> > Those are all benchmarks, not tests.  The tests run at registration tim=
e if you
> > just enable the kconfig options for them:
> >
> >     # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> >     CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy
> >
> > The test failures and KASAN error occur on mainline too, so yes they oc=
cur
> > before your patchset too.
> >
> > > >
> > > > I personally still struggle to understand how this driver could pla=
usibly be
> > > > useful when the software crypto has no issues, is much faster, and =
is much
> > > > better tested.  What is motivating having this driver in the kernel=
?
> > >
> > > We want to use it in conjunction with the upcoming scminvoke (for
> > > loading TAs and invoking objects - used to program the keys into the
> > > QCE) to support the DRM use-case for decrypting streaming data inside
> > > secure buffers upstream.
> >
> > Notably lacking is any claim that any of the current features of the dr=
iver are
> > actually useful.
> >
>
> Noted. I'm still quite early into working on the upstream-bound code
> supporting the streaming use-case but I will consider a proposal to
> remove existing features that are better provided by ARM CE.
>
> Thanks,
> Bartosz

Just an FYI, I was informed by Qualcomm that upcoming platforms will
contain an upgrade to this IP and it will be up to 3x faster than ARM
CE. In this case we'll keep this driver around and I will focus on
fixing existing issues.

Bart
