Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190213BC2F
	for <linux-crypto@vger.kernel.org>; Thu,  6 Jun 2024 08:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717663994; cv=none; b=lUKQTacRuxXvCnU1fJ4w7oh7/0iqMKFvPX5EGQb9w6bv62+4sIDnPM0d6MqJG21S+CJ7ecFLhpisj2NxyGrQbKN4KrGzPgbVTBiazl9lPmBnI9E37N4w3N2ikI0R11GZGXE5ABYo0k5Ar8e8LDOGvkmWzs4dIUPegof8JZt0faQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717663994; c=relaxed/simple;
	bh=H197RQMx9DAWtYCyrDDhy9rTc/ukhFaiZ582/lFZeJM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mEEFt1QY1UjiZGSL3VR5He0FN2f4HYifi8DoK3BJ6kp8Hci6X+4Jf5tC23IaKrLC0xLbpiMaTO17z8u7MKUSKHT4EP0I/HCh1ICKV16/p4bnoQiTYXH33cnqetfjU8eQQdPeKihv+oBBG7kZMsEz4G2M8X/PSUmNOLYHl1LJiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA4HszPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA4HszPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B7DC4AF19;
	Thu,  6 Jun 2024 08:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717663994;
	bh=H197RQMx9DAWtYCyrDDhy9rTc/ukhFaiZ582/lFZeJM=;
	h=Date:From:To:List-Id:Cc:Subject:In-Reply-To:References:From;
	b=NA4HszPbpXETy9L8mVgyHtQ3buYcLEcjph861/+CYdUn9UnBMcGGSpOxxXYoCvfHr
	 w1Aw1ASyaGz5Qs2kmdiy0+lF8cQWp2laRfjfTSTPdAhHbtKuRdd2YcsmZQgDR2IK6Y
	 /g0RUTu5HQx5z2X5Np0r7ge+1OSLPKq3i7FbvVmxu0U0C0d+wPXXyYl6ad/8SXc7BT
	 ovxOibyJOPPIs7U9F2y6xbtcll5P+P5ur7ExdfSGPHgs+gGqHUsGb5OnZZ/HLahKjJ
	 07SRDuMoGhtwdX4/7xaPfutCus43FElZ3P8FMJdlS1Pt3ov2oyR9ms85irx5waUR2i
	 Pvr3mwPaNwu9Q==
Date: Thu, 6 Jun 2024 10:53:08 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>, Bartosz Golaszewski
 <brgl@bgdev.pl>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>, Arnd Bergmann
 <arnd@arndb.de>, soc@kernel.org, arm@kernel.org, Andy Shevchenko
 <andy@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Olivia Mackall
 <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <20240606105308.3e02cf1e@dellmb>
In-Reply-To: <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
References: <20240605161851.13911-1-kabel@kernel.org>
	<20240605161851.13911-7-kabel@kernel.org>
	<CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Jun 2024 22:00:20 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> > +       irq_idx = omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
> > +       irq = gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > +       if (irq < 0)
> > +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n");  
> 
> Okay, it's a bit more complicated than that. The gpiochip_get_desc()
> shouldn't be used. Bart, what can you suggest to do here? Opencoding
> it doesn't sound to me a (fully) correct approach in a long term.

Note that I can't use gpiochip_request_own_desc(), nor any other
function that calls gpio_request_commit() (like gpiod_get()), because
that checks for gpiochip_line_is_valid(), and this returns false for
the TRNG line, cause that line is not a GPIO line, but interrupt only
line.

That is why I used
  irq = irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
until v7, with no reference to gpio descriptors, since this line is not
a GPIO line.

We have discussed this back in April, in the thread
  https://lore.kernel.org/soc/20240418121116.22184-8-kabel@kernel.org/
where we concluded that
  irq = gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
is better...

Marek
