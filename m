Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116B33B7B96
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 09:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784885386; cv=none; b=fRRJULZius+e3vDGhbcQ+iSInvLqHm/aQqwavlBrZRO4eTym9Wm2glo7hSWA+2TOsItqNWLVEdqmUbba4kmees/IU3hsRAIEXl2eG4bGBJutD/z2hh4YPNqHiDy2a4UIgMC4SZxgotpnsQhbmMcRwDXP0ZSbisk6R/v/U4XJDJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784885386; c=relaxed/simple;
	bh=3D237D5nRqioEUEB3IKGM2oHncuhk0bMN6FQxAbS1TQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SrOL0x9shQmb+VqSsiRwRKW4VcmsysatVENRV3KBecmqRND3Q2tdF3VNqFYhVIelsLi+rVhwE6bf2Bwee8zOyPt/KoKR25BiMQORe9rkgCCRR9LiOZT7qNAfjZBh0F96tnY5JiquM1XTQUZkarEhvUyivTA2f/hdsYNjrhloQCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foILZPri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foILZPri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF57B1F00A3D
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 09:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784885384;
	bh=XlNU1Or4l5o+0AThB881QO3Q6R/MIqKOg4LBnIwykJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=foILZPri5l4otgeJKEYXmq/gKGllx0r6qMcy7EaribQT8w8x4q8sPkPnKsDCzIMXV
	 K8NdFIQWR9fHwCgN9qz+NTadQ+KIL6vQViOGlGT4nNJOSVCt21oCFO2lEbv8HuoVq8
	 ck1l9Cp37i/Ec2XwUD0IazGGzM65xyyvNJf1EpOIrXzlL0iuXas8+/de+t+Wfmjigm
	 dJCjc6y3qxZ0GbXSWmV/yZaPMY5LSdWEIuKDQObqsa6kegbnKkOnMWh3TmfIhFwtub
	 yrJcVgBEf8WriD1anJ87cmihu7pKQl6hs59mM5UAbYLMImeQVXsxc0MV4uSmMB4GvW
	 j20MD9yIut/QA==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b01146b205so128787e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 02:29:44 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxp8VZos0Wp5U5Yh2hiBJ0pqlthGMAcQnGjtvZJzHpYRPF3IqwY
	7ErdE4JvNRaEEHNPi+7t+EHmmI+EK1w30vtciFlNWVkiY/BkVPJ97VpPah7VD6fWuqiB4ujAPgw
	tpgcuDi7wMC1Vnmxuw7j3IUd0205pNWSB4K7aU6kMzw==
X-Received: by 2002:a05:6512:669c:20b0:5ae:b357:1d1a with SMTP id
 2adb3069b0e04-5b2b2e52e6amr870628e87.8.1784885383436; Fri, 24 Jul 2026
 02:29:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724050645.223799-1-ebiggers@kernel.org> <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com> <2026072412-decrease-sandbag-70a1@gregkh>
In-Reply-To: <2026072412-decrease-sandbag-70a1@gregkh>
From: Bartosz Golaszewski <brgl@kernel.org>
Date: Fri, 24 Jul 2026 11:29:30 +0200
X-Gmail-Original-Message-ID: <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
X-Gm-Features: AUfX_mwy71y0qLd88ygHtoEMp3d2oiZ2geN4DNt_v5rVUEAjVAH0o7dlfP4dPGc
Message-ID: <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Demi Marie Obenour <demiobenour@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 10:42=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jul 24, 2026 at 12:36:24AM -0700, Bartosz Golaszewski wrote:
> > I'm against removing this driver but I have a kernel driver policy ques=
tion
> > before I start arguing the case: If I say that I do use this driver and=
 that
> > I volunteer to maintain it and had already started sending out fixes, c=
an
> > Eric still force its removal? Because in this case I can name a whole l=
ot of
> > drivers that I deem useless that we still keep around.
>
> But you aren't using it if it is marked as BROKEN.  If that's not the
> case, and it is not broken, well why is it marked that way?
>

It was marked as BROKEN only a couple of days ago (it hasn't been
released as BROKEN in any upstream tag yet) despite my NAK, making
myself the maintainer for this driver and having sent the first set of
fixes addressing crypto self-tests failures. There's a bit more
context here. :)

> > The alg priority of this driver has been decreased below that of ARM CE=
 and
> > since CRYPTO_ALG_KERN_DRIVER_ONLY it can no longer be used accidentally=
 by
> > user-space either.
>
> If it can't be used, then again, who is using it?  We can't have ONLY
> out of tree users for code that is in the kernel.  We HAVE to have
> in-kernel users for it to stick around.
>

It can't be used *accidentally*. It can still be used by in-kernel
users if you bump its priority via netlink.

> > Even if in practice the driver is used for testing purposes - does this=
 warrant
> > its removal?
>
> testing purposes of what exactly if there is no in-kernel code that
> calls this thing?
>

Of several of the crypto accelerator IP's functionalities. But that's
just an example. We do use it - I was just asking if if we use a
kernel module to test HW functionality of an IP - is this enough of a
reason to keep its driver, not taking into account things like FIPS
140/3 certifications, etc.

Bartosz
