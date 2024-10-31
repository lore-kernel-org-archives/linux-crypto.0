Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF641BD4E2
	for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 18:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399747; cv=none; b=VsJ7+3zOqsBi2xREYyHepbsjmW7GpTAaqcXvkVK5uazUkb2vh0rGA9eCC4ogsi309MF0L9LJ0hXK/r09QNjwiqfZoDmDM7JIXQtXkgs8Z8cA7XmpGO5L0EmvlTyi5M5yND+RQ0ZQu2f778n6OihJLr12TZj88aSm7qfZWCDpDpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399747; c=relaxed/simple;
	bh=jg7VAD2aVLnFNu6KLQ/pbomFTgwL24uoZAQdht5T+Rg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TPBCqt+zipgTymQ8P+5gcaDyB3Z5BBKlvAEF+2jBj6hqImNlm39qVYvFCttsX5KTecUQ9tPNp09l8N38Q7/zLZM1WTn8+SW86tdXQ5gfPk6fSfIgmg4A7PIYdDDoULb7P4N3+ThAooMXCOvt6cBKvFvjFRG4zBsrFcuu0gQPNPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hRI1Ybr1; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hRI1Ybr1"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7e6d04f74faso862566a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 11:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730399744; x=1731004544; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=clclPZtCVo76nq6JvC8BRNLzx95l3mSozKtIXOlYhOw=;
        b=hRI1Ybr1SQd1XwWQnuCqPcvvdwYkGa5W5E4hINhWiYG6jGj3lGpq5i6Invjb2J8XKq
         wSzbsT7r99lCZ0iYJw/bp034ERDFF5orKc0xiIuq4fLy8KS0ChwqgSDOEA5FJfybJAoq
         0sLW3bO75cVJ3U0KMhe+lz2oY4cewfBGxxagY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730399744; x=1731004544;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=clclPZtCVo76nq6JvC8BRNLzx95l3mSozKtIXOlYhOw=;
        b=rbgnGXZVGjHv2v36P0Fmbw3wM0UnBYMRNaHYf7IcoH2HJFK088nQcy6hXtBxgF7h3u
         Ao7xJExSnkwl154/XW8Ng/1/sE2wCkO7PyyNMgxiKyLRPXOIdH18W2byPbaOgkWJ9mdY
         nlEVAqfvMsCGb9RamQ23cqip1kSN7dePu8K4S+p6TevrboUCIJX3qGm/CS378xbkH18g
         0dQQlVSn3F0zXbDdvWOkm1ld9knR0gtDUQsddQQFgYxA+ZAJ+aghKKiRdF8eKjVSo8+B
         2h93Ecb1l0GmxjM8cQJdoAYFHn+LmOW2c9Bp+Ch5rH0PReWPZ1WSXQVMZFxyMj07d3Gi
         Qmbg==
X-Forwarded-Encrypted: i=1; AJvYcCW/jo5Kqbz1yofldRPRnq9EfOoiOxncyoE5ErhVNVeEI2APrFisWBJJzz8d9pF5oLHg7tHPnMFtLnefdb0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfl8dwQcBjZ9IiiJAEDH7GlXI7QeaDdhH7ldIM5cRFf83kvgHQ
	MiuBj0DT3dr+QzyVgBZN563ex929wQwphv+AL8off75V1ukuaHckzRA9qN1SRc2n5TlHgNq+UUr
	BDOEG8Hx6e1Bfiaty6m+X8TugnZ8n/L4aTodR
X-Google-Smtp-Source: AGHT+IHW3PtgJ+3707l1WWNfcjCY4eO8OMoynAIZzOQokfTKBfjzi20ckAen6vyMcZjlYruukCT5PSDTi39c9efruUM=
X-Received: by 2002:a17:90b:3b8f:b0:2e2:878a:fc6 with SMTP id
 98e67ed59e1d1-2e94c23101dmr1451727a91.18.1730399744517; Thu, 31 Oct 2024
 11:35:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030213400.802264-1-mmayer@broadcom.com> <20241030213400.802264-3-mmayer@broadcom.com>
 <c6b02317-e65f-444a-906d-e56f33dac9f4@broadcom.com>
In-Reply-To: <c6b02317-e65f-444a-906d-e56f33dac9f4@broadcom.com>
From: Markus Mayer <mmayer@broadcom.com>
Date: Thu, 31 Oct 2024 11:35:32 -0700
Message-ID: <CAGt4E5uqpv-gzRa4B5av_-f3n9rsuwVKs3H9T8ndH1JSXLsoXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] hwrng: bcm74110 - Add Broadcom BCM74110 RNG driver
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Aurelien Jarno <aurelien@aurel32.net>, Conor Dooley <conor+dt@kernel.org>, 
	Daniel Golle <daniel@makrotopia.org>, Francesco Dolcini <francesco.dolcini@toradex.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
	Device Tree Mailing List <devicetree@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Oct 2024 at 14:41, Florian Fainelli
<florian.fainelli@broadcom.com> wrote:
>
> On 10/30/24 14:33, Markus Mayer wrote:
> > Add a driver for the random number generator present on the Broadcom
> > BCM74110 SoC.
> >
> > Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> > ---
> >   drivers/char/hw_random/Kconfig        |  14 +++
> >   drivers/char/hw_random/Makefile       |   1 +
> >   drivers/char/hw_random/bcm74110-rng.c | 125 ++++++++++++++++++++++++++
> >   3 files changed, 140 insertions(+)
> >   create mode 100644 drivers/char/hw_random/bcm74110-rng.c
> >
> > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > index b51d9e243f35..90ae35aeb23a 100644
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -99,6 +99,20 @@ config HW_RANDOM_BCM2835
> >
> >         If unsure, say Y.
> >
> > +config HW_RANDOM_BCM74110
> > +     tristate "Broadcom BCM74110 Random Number Generator support"
> > +     depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
> > +                ARCH_BCMBCA || BCM63XX || ARCH_BRCMSTB || COMPILE_TEST
>
> AFAICT this driver is only present on STB chips so limiting to
> ARCH_BRCMSTB || COMPILE_TEST should suffice for now.

This is now fixed in my tree. I will resend in a few days.

Regards,
-Markus
