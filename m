Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C0E2EB85B
	for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763735765; cv=none; b=ppnkoRXCNP3o6bTF73NLjjSTBp8FZCFbD6Lu2/edEtZmri4k9UzoS8+ZaVoEWm7AQr2Mr5cHTduXzBLCtYtlLAowOXKb5kOpF7DnSUaIhakCIzttP0pbY2CB7Foa3rqoZ2X4ZPxe2OtK06G4ENfi1HWVd2jt/1EBgUwca+wynww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763735765; c=relaxed/simple;
	bh=kcvdwzmTHjfImVyX48L1z8kmzHl3/BcWLpJ7S7bBj3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IiVozl8SHDvpgSyNy/IpVEG3tJoIoDGcIkxdjiLynSTjnJDx/A+kWbybfrC2g2n9UyroPsyITWY+dpOKLXBj0Gb+Vi5n3bPv9mJNFJot//a3HoN6SsmVjL4MSs7r/rfmhVgZLVTqQPGyQ/65np+TEaCHF1dU6Cj0XDWMzrrGVB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=mraEb9pi; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="mraEb9pi"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-591c98ebe90so2604953e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Nov 2025 06:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1763735762; x=1764340562; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcvdwzmTHjfImVyX48L1z8kmzHl3/BcWLpJ7S7bBj3M=;
        b=mraEb9pi3/JcMbuoaXF58JeOq0GKs1fotivoH8EZ2pDNlvKjsRnJaLGWfNpqxyBlF/
         bGEvDU6waTMWJI7SwK6hMc8gDL8919T++Fu9AZgU8KpkJOTxDcLZEu6h/HgsBNnXL5QW
         boy2INfbdj3iYviDI2GUA5oIlC2fBQaF7n5CPgo63eQt4fa3ouDXNI0aw7P21g58fi56
         znK1/0i2lRu9Mb4Y/86tFI8ahuoT6GpqKFgdTjx1iF2OqLU2HONTJxI1bP9LNPfbX0Bp
         JWTZOeO0KoGOwJkIf9F9VAAazF5f5HEUXGXdYZCBXtAeQO7LhdBgohf+bQj74LuOsTYz
         a8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763735762; x=1764340562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kcvdwzmTHjfImVyX48L1z8kmzHl3/BcWLpJ7S7bBj3M=;
        b=e52skB41eD5sH+Yudi6sQzykdpsHNiNP52XAbx7VHq46gf+TvMAtjo+b5xWuNerpe1
         68WHn60hj0q7gAszSBPwsT0DlDngXOIoiX82xh6ZzrqZz+LEDfK8KQAJYeC/1na+6Y81
         Rq7LplV5CLkJ7dzWrDGE7dPX5RW+P3tE+LUTptPQzBXL7UETZB56F2VxGebcHbobJooi
         RuIek4B1n+toM+yLD0s6sPBLYmfVDYJ/unNZ2YDku38ejc3UF6EotMU/npPPQZ1Ic3vo
         omicc57hHj2xU7CdO7Q8tSJ1MgnVxi0cix+oVnir2v5CZu1up9xTp0vbkDlK5lQfQPB3
         Z4tg==
X-Forwarded-Encrypted: i=1; AJvYcCXExWWttZJMCF8LzeJ72xBAwiLqAL5WXVfHglTee5OoRWpbmmefh2bTuGCVdPGEJ3UiKHrQ0sRK9p8EIQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOJefmfa+ShjWgexXtGhnxlRJWZRfuVuIs5pPK09ZqHDcSiHhD
	DYfButALEWrvcD+iwzY5zHIndAxEusHpKmUt7f7vHiuRoYh81PM2AcNihL0TAKcZG4/tuXuWlAa
	sJXcIRmbicAoXMcSNMpFcZQFjPsEhLqD0ylt8/qc0NA==
X-Gm-Gg: ASbGncuJF4czkos+EewfIl2o3d7kyWuVW1Jfgy+VsrSH8r2zOV5Z+xTlFC9E1vMxrvH
	NYHllZmfc2A49v11EhFzpfntSQQPgSoMshoEgYo3Mmy0C2uku6KDh87FgzJIhycMaCvWyjKXh4B
	f2vjfOcCn6PVWuhXn1s9ZWOMG42DZihaqnoO6OP1Npqe9XRQlQO8PHJYfOqm94wfNGivBFT4/kd
	8XCqcF9QeT/SImKASAgOPvY/lPRllym7de1AsvWI7pJFPLvUCpari5BKrim/ElFulouRwtP7oWo
	oqwxnMTrTep1lU+LfKwBbbplIGOxftMstL6kJg==
X-Google-Smtp-Source: AGHT+IEt2uZ9UPqWbRRe+8fGSY15wdsKLC5t0faSbXjvG68jFZ1NGNH9efmvDAFLqXO77pWUDjtREMDkD8mv7aijzwE=
X-Received: by 2002:a05:6512:685:b0:594:27eb:e130 with SMTP id
 2adb3069b0e04-596a3ee50b6mr898634e87.46.1763735762108; Fri, 21 Nov 2025
 06:36:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
 <20251106-qcom-qce-cmd-descr-v8-1-ecddca23ca26@linaro.org>
 <xozu7tlourkzuclx7brdgzzwomulrbznmejx5d4lr6dksasctd@zngg5ptmedej>
 <CAMRc=MdC7haZ9fkCNGKoGb-8R5iB0P2UA5+Fap8Svjq-WdE-=w@mail.gmail.com>
 <m4puer7jzmicbjrz54yx3fsrlakz7nwkuhbyfedqwco2udcivp@ctlklvrk3ixg>
 <CAMRc=MfkVoRGFLSp6gy0aWe_3iA2G5v0U7yvgwLp5JFjmqkzsw@mail.gmail.com> <66nhvrt4krn7lvmsrqoc5quygh7ckc36fax3fgol2feymqfbdp@lqlfye47cs2p>
In-Reply-To: <66nhvrt4krn7lvmsrqoc5quygh7ckc36fax3fgol2feymqfbdp@lqlfye47cs2p>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 21 Nov 2025 15:35:50 +0100
X-Gm-Features: AWmQ_bnh7zWBFnvkFmVPhxTMwiWW-abo3yO-revfh4tghVthdoeoEiGc0JMgThA
Message-ID: <CAMRc=McYTdgoAR8AOz-n5JEroyndML1ZQvW=oxiheye3WQmvRw@mail.gmail.com>
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

On Thu, Nov 13, 2025 at 9:12=E2=80=AFPM Dmitry Baryshkov
<dmitry.baryshkov@oss.qualcomm.com> wrote:
>
> On Thu, Nov 13, 2025 at 04:52:56PM +0100, Bartosz Golaszewski wrote:
> > On Thu, Nov 13, 2025 at 1:28=E2=80=AFPM Dmitry Baryshkov
> > <dmitry.baryshkov@oss.qualcomm.com> wrote:
> > >
> > > On Thu, Nov 13, 2025 at 11:02:11AM +0100, Bartosz Golaszewski wrote:
> > > > On Tue, Nov 11, 2025 at 1:30=E2=80=AFPM Dmitry Baryshkov
> > > > <dmitry.baryshkov@oss.qualcomm.com> wrote:
> > > > >
> > > > > On Thu, Nov 06, 2025 at 12:33:57PM +0100, Bartosz Golaszewski wro=
te:
> > > > > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > > > >
> > > > > > Some DMA engines may be accessed from linux and the TrustZone
> > > > > > simultaneously. In order to allow synchronization, add lock and=
 unlock
> > > > > > flags for the command descriptor that allow the caller to reque=
st the
> > > > > > controller to be locked for the duration of the transaction in =
an
> > > > > > implementation-dependent way.
> > > > >
> > > > > What is the expected behaviour if Linux "locks" the engine and th=
en TZ
> > > > > tries to use it before Linux has a chance to unlock it.
> > > > >
> > > >
> > > > Are you asking about the actual behavior on Qualcomm platforms or a=
re
> > > > you hinting that we should describe the behavior of the TZ in the d=
ocs
> > > > here? Ideally TZ would use the same synchronization mechanism and n=
ot
> > > > get in linux' way. On Qualcomm the BAM, once "locked" will not fetc=
h
> > > > the next descriptors on pipes other than the current one until
> > > > unlocked so effectively DMA will just not complete on other pipes.
> > > > These flags here however are more general so I'm not sure if we sho=
uld
> > > > describe any implementation-specific details.
> > > >
> > > > We can say: "The DMA controller will be locked for the duration of =
the
> > > > current transaction and other users of the controller/TrustZone wil=
l
> > > > not see their transactions complete before it is unlocked"?
> > >
> > > So, basically, we are providing a way to stall TZ's DMA transactions?
> > > Doesn't sound good enough to me.
> >
> > Can you elaborate because I'm not sure if you're opposed to the idea
> > itself or the explanation is not good enough?
>
> I find it a bit strange that the NS-OS (Linux) can cause side-effects to
> the TZ. Please correct me if I'm wrong, but I assumed that TZ should be
> able to function even when LInux is misbehaving.
>

Ok, so the consensus after talking to Qualcomm crypto engineers - and
I understand this is Qualcomm-specific but it should apply to any
similar use-cases - is this:

If the TZ uses BAM locking and it locks the BAM and linux tries to
write to the registers protected by this lock, we'll get an external
abort. Making linux use it too addresses that potential problem.

Linux could potentially lock and never unlock the BAM but TZ could
also just reset it. Also: linux could as well turn the entire device
off. :)

For the Qualcomm use-case this is not an issue - it's about making TZ
and linux work together. I suppose the same would apply to any other
users.

If that could be contained within the crypto driver, there would be no
issue. It's just that in order to pass this bit to the DMA controller,
we need a generic flag. If you have better suggestions, please let me
know.

The flag has to be passed to the BAM driver at the time of calling of
dmaengine_prep_slave_sg() and attrs seems to be the only way with the
current interface. Off the top of my head: we could extend struct
scatterlist to allow passing some arbitrary driver data but that
doesn't sound like a good approach.

Bart
