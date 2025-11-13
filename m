Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F9A354AD0
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 15:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763049192; cv=none; b=RaeGKn64gwXg8tHr5rslVcHsK12qppLCSv7X/fJCKnlik6A4Rt0oHt9KrPCTbrXt/4rj7tc6xl4JCeTgsQ3bHcIMQxguztLF2AzlA8XHmC0TQgp47ucOEID5FknuZ1sptgt/DaqyISCtLKHPmf69riz/D5fZu86VXwecodGL/hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763049192; c=relaxed/simple;
	bh=OX60sKiYWBPN5NRPN15Ciaf9MOmCSXUCmyYmlQRE8wQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mOc23oez/9+oGW8oV53VZJj3dFjnR+rDzsG48HFsV52Gk1EKh+1k0Yl7zGtV4G0BdhiYlNw1IsIbbEWlCbFIpvaF77u8Fv8kwddtn7jxJEynIj/gjMvFsXPTw+FUNTtwsBlWb/jsVtek9UJhbUJYMKXSBS2uqbOhBlpesNBYvR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=UnhyHl5P; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="UnhyHl5P"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5958187fa55so544038e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 07:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1763049188; x=1763653988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OX60sKiYWBPN5NRPN15Ciaf9MOmCSXUCmyYmlQRE8wQ=;
        b=UnhyHl5Pnheicwm/Lo3266MWOD40MLGfAm6zN124i5VRXHIGIdAfmPbI+hKGkSA96p
         23cUzQWcaBUZmknmwMOZAgjabWEFqOzRioN6ooYqxGs6OFBymc6rtli14+wArQeA9aPE
         DKQOjlpLSjbAreNJZ2gt3t3Xaz17Zue9OeSdXvw1TzoKgmOh1GtwrjqXcXHCtbq1KAJB
         hzvy+QhJ3JBX+wiPFUPpIoKtPQtPbTSBCkfmLFHlpX8DuJWcgF2RD/4htVqFvzE0QJFm
         v4QKy6NIleF9eTSPZR4lun5A9FQYImGaCpgtPcVk9/twQEJGfSvLDMCwVgyCeIbxUju1
         XLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763049188; x=1763653988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OX60sKiYWBPN5NRPN15Ciaf9MOmCSXUCmyYmlQRE8wQ=;
        b=ANW/SE8L+TOMamM65rKGR5I0aCI2z6FByLHz2YZLMi8/Npn1mRHeHMnqVdb4wNsVi3
         O9nb8TBQXdnDaZigTnPIEJras5WN6W6+VpdvLYPv2eODK2FjenLd2Je+o4uv05RGKNp7
         Dd+J+NX96nkhEIsri2qtMeIfnxDDHVWvpxCxiNSrJPF5G9hDOYFLs2H6aNi8x6Q0/Ep6
         Rrbun8uXWUVJsGG6Kc1DW0gVuqzrziWxckJcbhmmOC+tgVLLTdVfmguigaE//m4+Eeip
         8kl9FA7otMWQedxtXGMCxUfTp3IkZDwa92P7eWadIc4RQdur00V0MKiQeV2loKVQlYxM
         ehug==
X-Forwarded-Encrypted: i=1; AJvYcCVXAnAF2qMENwS15ZTJqejpwz6z7gAiNozF/1Lb93Ngn2zWOoquBbe2P8n9C0xyqv5JQb7gL+Ry6TYVKT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS6q1urHQPwe9nRMqC6G3u9NK0xuvOa5RJN8zWwL3b8QEhYSmO
	dKThBJ65De8XdQAg1cEcO6wl04Dy0Di71W5Ac3EBNa3yxepQ/QHFnB6XCW9dEla1yEGM9atBJ6g
	Ts+xk/R2EImf24uzWTYIez0VqTn+vVoHcG6FKYDAgfA==
X-Gm-Gg: ASbGncuFBH86vGO3xMNVaPitJVL3syKwb4WXWm9D87hY39M7B653aIBxyPCm/tvdfti
	MPcG0I+hhaEebaflAIPVgTmIkOVkHgSZlol50goErCBf6HJ5EPOpy50jm1QRKYQKbaBjaxQY/tq
	bVQpwbl7Bq3wdi0PHYBgBiltPZrCSnrpBFhnBYSnhhx9DmJ1P1os9fKyF2fq2SiJP2yW7++mhs/
	7nQyaO1lJsr74fAezeKvYVI0h3RfgWa+sYLGWMp/QkEctymW+JJtoXGMZBDSQwPNIKQ5UGAStZL
	VkZtNPCx4bi7yIaL
X-Google-Smtp-Source: AGHT+IGEIHUfqwrlVSTNHLgDVI05vKsEFSndBnbm0aaakSseNyRK8XPAjnLHbbfGqrZ6iuP/tkAMQ67bsZMfd+4juQg=
X-Received: by 2002:a05:6512:108e:b0:594:34c4:a325 with SMTP id
 2adb3069b0e04-59576e31216mr2694783e87.46.1763049188065; Thu, 13 Nov 2025
 07:53:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
 <20251106-qcom-qce-cmd-descr-v8-1-ecddca23ca26@linaro.org>
 <xozu7tlourkzuclx7brdgzzwomulrbznmejx5d4lr6dksasctd@zngg5ptmedej>
 <CAMRc=MdC7haZ9fkCNGKoGb-8R5iB0P2UA5+Fap8Svjq-WdE-=w@mail.gmail.com> <m4puer7jzmicbjrz54yx3fsrlakz7nwkuhbyfedqwco2udcivp@ctlklvrk3ixg>
In-Reply-To: <m4puer7jzmicbjrz54yx3fsrlakz7nwkuhbyfedqwco2udcivp@ctlklvrk3ixg>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 13 Nov 2025 16:52:56 +0100
X-Gm-Features: AWmQ_blYu02FWethcWw51M6XQQsBTFUfg16XB4nlVnnodZzkOPobVgGS07ncuc4
Message-ID: <CAMRc=MfkVoRGFLSp6gy0aWe_3iA2G5v0U7yvgwLp5JFjmqkzsw@mail.gmail.com>
Subject: Re: [PATCH v8 01/11] dmaengine: Add DMA_PREP_LOCK/DMA_PREP_UNLOCK flags
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Udit Tiwari <quic_utiwari@quicinc.com>, 
	Daniel Perez-Zoghbi <dperezzo@quicinc.com>, Md Sadre Alam <mdalam@qti.qualcomm.com>, 
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 1:28=E2=80=AFPM Dmitry Baryshkov
<dmitry.baryshkov@oss.qualcomm.com> wrote:
>
> On Thu, Nov 13, 2025 at 11:02:11AM +0100, Bartosz Golaszewski wrote:
> > On Tue, Nov 11, 2025 at 1:30=E2=80=AFPM Dmitry Baryshkov
> > <dmitry.baryshkov@oss.qualcomm.com> wrote:
> > >
> > > On Thu, Nov 06, 2025 at 12:33:57PM +0100, Bartosz Golaszewski wrote:
> > > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > >
> > > > Some DMA engines may be accessed from linux and the TrustZone
> > > > simultaneously. In order to allow synchronization, add lock and unl=
ock
> > > > flags for the command descriptor that allow the caller to request t=
he
> > > > controller to be locked for the duration of the transaction in an
> > > > implementation-dependent way.
> > >
> > > What is the expected behaviour if Linux "locks" the engine and then T=
Z
> > > tries to use it before Linux has a chance to unlock it.
> > >
> >
> > Are you asking about the actual behavior on Qualcomm platforms or are
> > you hinting that we should describe the behavior of the TZ in the docs
> > here? Ideally TZ would use the same synchronization mechanism and not
> > get in linux' way. On Qualcomm the BAM, once "locked" will not fetch
> > the next descriptors on pipes other than the current one until
> > unlocked so effectively DMA will just not complete on other pipes.
> > These flags here however are more general so I'm not sure if we should
> > describe any implementation-specific details.
> >
> > We can say: "The DMA controller will be locked for the duration of the
> > current transaction and other users of the controller/TrustZone will
> > not see their transactions complete before it is unlocked"?
>
> So, basically, we are providing a way to stall TZ's DMA transactions?
> Doesn't sound good enough to me.

Can you elaborate because I'm not sure if you're opposed to the idea
itself or the explanation is not good enough?

Bartosz
