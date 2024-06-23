Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBE633EC;
	Sun, 23 Jun 2024 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719151876; cv=none; b=XaGlHPtruTRNyXZrI7BEOmfB7t7CTFCcy1GjNrfuVghqnfctl5G5fjNITDDVtlYkP6G6iZtb9WPktLqnVkk3K6igF8BoC5cKG/TGj7dTizHK1xM3JSsBe2mqJb3z3I0XCbSf9jaXaPKQM1EIaWfTuFg6E1Ut5Ko50gA5skwXHOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719151876; c=relaxed/simple;
	bh=cKpRh1yRoAzuJrO72ZNoJ0qp4W306OEKYJGj3bZhoXA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=cXIdO0MYsl/SpwcqLYhP5nf8A1EyQG4THNfG+h2NPMyZYjDJ3dL4gZSIAMQZe3AzsyDCc4OjDx3PNcGn37fOCCrjppLmvgIjOfBLTVcuNAMrldLptE4/+B2TdeLSIAJBH7SRU9mbSnx3kSX1M7Ff/6KRy4g1t9u49VzoXybZ1f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OEcQp3/y; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OEcQp3/y"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-25caf76158cso1973120fac.0;
        Sun, 23 Jun 2024 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719151873; x=1719756673; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mydsSOgs1yRkpysFjrBR5qnlOOLUTfBZ21Jz7PUY9KI=;
        b=OEcQp3/yMA8aOOs1AYdveM3ZV+gXUSHM1vZrLmyP6k87SWiHLglxiTaEs5tVo79YRJ
         j97/p4uRpIBnX0ZVeUwGGkYF25Td0rnJ0wwDoMxW0kGY8KlAkWOYanZUgtVleVKcBiud
         L1gHzvCEgJPX14fqUSwFZ7A0ytJneFVwqQwY2VBE1VJHOsgQKOhXnYPcL5EvWl9BCQqG
         cPNKY1hoCmRIH63JBn8/rbUI+D54kCe4isoKQdx1LD1UG+/3H33kuXkhkHVCFH8cJB+H
         XTxbNlpLd28ccO8sr/ebZ45s+FROa91L+IDz3CM6SCz0U//dpCif7QGf3UtCfsB9fE6/
         McUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719151873; x=1719756673;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mydsSOgs1yRkpysFjrBR5qnlOOLUTfBZ21Jz7PUY9KI=;
        b=kVodiMYCNeQiU3tFOIAelBHtiyc5FUW+cu+8Kd1oZKdjZqNwfACFaHymEEkUtttOoI
         Ho014O/ZUAmR++T5tXTuJgqjHYGkF3FJaQSRiwu3/a9bZyXTcph+LTGAc+rLy7hl/piP
         +Qo3gjVviUy2Pndf7XJ2ki2gFPyrCon6eR1jjARxJipumAxgMwzJ5C3S6G6t6Gtz2ncg
         Wi7lj5MXxBv7RSjboWtgxCV2RvpoAdQ/EbtfyYbjywEXus3BYhF+QVpnT4tVMLIKGSVy
         Vj3vzlYA9gIU5VgKLMr/Z+avRkukX41vYb+3hsvopbV+8f9wSNjmJZteh25XJf6oNCHZ
         PkmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnHvpeTY27Hjq+ptI+ove/VaSWn0Q+uV/k3JSkJIUqZmfOXFFnVolMKd1cNMNH8OqLfMd5RvLIH0tfIIz6ZXq+cdDAxGhQOKgbiVbbosF6JJaQfKDc95poWLz7MVtVi7aqEhFzAVVtUKi172KqA8jiNHlVHYCCd16N+5orbKI643w1yEbMEA==
X-Gm-Message-State: AOJu0YxxO5WizFL2YFkq9Yoj1fJaqju336mneZjvnDxYUnRp2s4xQLDr
	XOP+0Z7CoCntb2JbPwPNwBUDKi30+1oZ9FCZRR41GnCua8TxXyuLELt6EqXXDxRjPyFtyBxgnuP
	r5aCdUH2cwc3vOuo3BlmtBHioNNU=
X-Google-Smtp-Source: AGHT+IFu3aSUk0WZAqXIaA214WhWGBp4bx8gFFfbGd9/AyNmFvmqYuPGQ3DfZ2eD+IxbM3Ci6RQ5K2LGLu7tVyFPy18=
X-Received: by 2002:a05:6870:a714:b0:254:d05e:4cd5 with SMTP id
 586e51a60fabf-25d06e3790cmr2478953fac.38.1719151873186; Sun, 23 Jun 2024
 07:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1719106472.git.daniel@makrotopia.org> <240db6e0ab07e8e2a86da99b0fc085eabaf9f0cc.1719106472.git.daniel@makrotopia.org>
 <612bd49c-c44a-41f2-89e9-c96e62e52a0a@kernel.org> <Znf8JeBA4mzVa0V1@aurel32.net>
In-Reply-To: <Znf8JeBA4mzVa0V1@aurel32.net>
From: Anand Moon <linux.amoon@gmail.com>
Date: Sun, 23 Jun 2024 19:40:58 +0530
Message-ID: <CANAwSgTt5MSRkpR9tiZuGRQjdisuKUzoeG6_+8MqLVqKp6pKQg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] hwrng: add Rockchip SoC hwrng driver
To: Krzysztof Kozlowski <krzk@kernel.org>, Daniel Golle <daniel@makrotopia.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Dragan Simic <dsimic@manjaro.org>, Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On Sun, 23 Jun 2024 at 16:13, Aurelien Jarno <aurelien@aurel32.net> wrote:
>
> Hi,
>
> On 2024-06-23 09:00, Krzysztof Kozlowski wrote:
> > On 23/06/2024 05:33, Daniel Golle wrote:
> > > +
> > > +   rk_rng->rng.name = dev_driver_string(dev);
> > > +#ifndef CONFIG_PM
> > > +   rk_rng->rng.init = rk_rng_init;
> > > +   rk_rng->rng.cleanup = rk_rng_cleanup;
> > > +#endif
> > > +   rk_rng->rng.read = rk_rng_read;
> > > +   rk_rng->rng.priv = (unsigned long) dev;
> > > +   rk_rng->rng.quality = 900;
> >
> > I doubt in this value. Usually SoC vendors do not provide datasheet with
> > any reliable and verifiable (so one which could be proven by 3rd party)
> > information. Can you provide a source? (and vendor downstream tree does
> > not really count)
>
> As the original author of the patch, I am the one who have chosen the
> value. I did it as explained in the commit message:
>
> | The TRNG device does not seem to have a signal conditionner and the FIPS
> | 140-2 test returns a lot of failures. They can be reduced by increasing
> | RK_RNG_SAMPLE_CNT, in a tradeoff between quality and speed. This value
> | has been adjusted to get ~90% of successes and the quality value has
> | been set accordingly.
>
> It is also explained, admittedly more briefly, above the
> RK_RNG_SAMPLE_CNT #define, as the commit messages are not really
> relevant anymore once the patches are accepted:
>
> | * TRNG collects osc ring output bit every RK_RNG_SAMPLE_CNT time. The value is
> | * a tradeoff between speed and quality and has been adjusted to get a quality
> | * of ~900 (~90% of FIPS 140-2 successes).
> | */
>
> The decision to adjust RK_RNG_SAMPLE_CNT to reach ~90% of FIPS 140-2
> successes was based on the quality chosen by most hw_random drivers
> currently in the kernel sources. The FIPS 140-2 tests were performed
> using rngtest from the rng-tools project.
>
> All that said, I am not an expert in that domain, so feel free to point
> to the documentation or provide the correct method to determine the
> quality.
>
> Regards
> Aurelien
>
> [1] https://git.kernel.org/pub/scm/utils/kernel/rng-tools/rng-tools.git/

This is an old repository, the latest can be found below
[1] https://github.com/nhorman/rng-tools

However, I could not find the support from ARM and ARM64 in the repository below
because all the assembly is written for the X86 arch.

Thanks

-Anand
