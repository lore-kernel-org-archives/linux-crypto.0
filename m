Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBBD441625
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784904472; cv=none; b=HWW+h7YJ6R5nVNmblloCXIFc2Uk7CPeKFliP1Bpfr5DRug9DtIIp1JuFQfsHTVaKZssE2uB9OaRgJq7NK+W1zzTlRCr1e4Bo3gVHOU3ioqzMZ0zX3vaMrYO3yd8FrHgtXrtREdOi99wqMiv440/GiE0WaWdtBSr4IDVfBxekOa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784904472; c=relaxed/simple;
	bh=4N3ItXJXlLDuayGvYw0Er4J15YWZM3U77r1bMBZFL+E=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RZjEuDYsvlV75Gis67uZm4Z192auJip3SNTUhEoywrC/TNilqnmnQGC1iHE6cYycQWXKWExtUsTYznLlidXE0Hc/aKF4fhgIqjkbzjcgcGKyIeMBstJ6twOdejYICDMZDbcb9ycSr9o7iORdOHjBGXYYlNXaGYkF1KtGUU1jlYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EgUjeDJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgUjeDJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F341F000E9
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784904470;
	bh=4N3ItXJXlLDuayGvYw0Er4J15YWZM3U77r1bMBZFL+E=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=EgUjeDJtYNL2nzAWfSpeNe/52YEjo8oJhCQUGBqIbjCpGdsymwMf2b1pnTrxfFOos
	 pEklBNeNVd9zz/4kLVCbZf3wbTQOaoOb8Is1YfCK8cj1A7UXwyj1nHukN3cFzxq3Mf
	 ggnNQJwVxwA0TwdCsT6iAdoyaOge8dRQJtlDlJOeamOUApdOA481+bWtVYsLgick5D
	 n0bHHe6/lqbN0a/pS45L7M6otPBVnALHoFVGGya6Lz4HXx2s+e8XGRA6UillbdlYyL
	 DDRdY7LJWS371V1TByd/3x8CHSmkIri1xKi61x54a4z4FxWp+Rv4ZPBI2+XwpkQPlD
	 xl7lvWseazeAA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aebd52488cso605385e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 07:47:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpgROdEiiR4lRApoydXoEQo9F1ZzNHneA3rl79YsD6ns5wzX83eF/cpJdygK+x66L/qaBJbR/CzfxLpQTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCmyfzq6kCjI/T3TfLqEXsIuLai1KOMnbt8RdOinHRSF1YFIl1
	LpDygCQzYkIXvjEN8yK0ch2ED8taqmOKAA8QbcIak/yES6Ln1Pc9Bv3/HosnP52SH79z9Vr47Ve
	2nuHACVoXpF58dkB77wPkQixD50FtfOu0+T+YUeJQ/g==
X-Received: by 2002:a05:6512:3706:b0:5ae:af9c:c064 with SMTP id
 2adb3069b0e04-5b2b2f77e76mr1176358e87.60.1784904469670; Fri, 24 Jul 2026
 07:47:49 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 14:47:48 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Jul 2026 14:47:48 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260724141414.GB1876@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724050645.223799-1-ebiggers@kernel.org> <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
 <2026072412-decrease-sandbag-70a1@gregkh> <CAMRc=MeFoG0UXYOAqYhCiKBTs12EjX2-Bz4wDnbeYXmQA3-OaQ@mail.gmail.com>
 <20260724141414.GB1876@sol>
Date: Fri, 24 Jul 2026 14:47:48 +0000
X-Gmail-Original-Message-ID: <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
X-Gm-Features: AUfX_mxiLdlLDPuAY8bGYAp0jB_4PqlJMNgcVDkjsy6Zb-mnOtnr1gmlaGXjefg
Message-ID: <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Demi Marie Obenour <demiobenour@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jul 2026 16:14:14 +0200, Eric Biggers <ebiggers@kernel.org> said:
>
> And with the defaults QCE is *never* used.
>

It's almost EOD here and I'm going to disconnect for the weekend but I just
wanted to say before I leave: this has never been a reason for an aggresive
removal of any driver. We remove drivers when we stop supporting entire
platforms, not mostly unused drivers on actively *supported* platforms where
they can still be used for experimentation and testing. I'm fine with dropping
this from arm64 defconfig but with fixes, the BROKEN tag should be removed
and I definitely object to removing it from the tree. How many people still
use greybus? Should we drop it from the kernel too? And I'm saying it as
a project ARA alumni. :)

Let's pick it up next week.

Thanks,
Bartosz
