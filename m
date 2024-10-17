Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2042D1DDC0F;
	Thu, 17 Oct 2024 13:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170824; cv=none; b=DVXmc3xG4m6lY9OalJEeIdUOhV0IStY9ZurWQ7q3/y5Q62Jhrujh+6eSWe4mrFXNzKHzK/ZKWi9l8Rzjl/pqg1TNVLXl8Y/2MS+S2HKitfho3UC5R0Vso5vPth1ATOvjblVVqEFs5TLxP+wXcoTL1R/Dag+UQDlUhSoAiBP6/ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170824; c=relaxed/simple;
	bh=ks38cldXQ+qom2/nXAIS7rVVbG3reoQ/rayAxCuAne0=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0cgpA5PkwgH3OrjDvI4y5BL4HEly7l5qCxakqXUwEArvZfoQ04gJ3xmHmoUVYzrcSOzBB9n0LJr+zSGHv+Kf0atuY0JaS2x3AS1QZcZGd8QR/rabRU8MnP6FPUhNaO1zVdObJVmrGyjw8j79o1ZsQWnjyDMdlmnHrBFS87L4DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L/xByAKp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L/xByAKp"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-431137d12a5so9892515e9.1;
        Thu, 17 Oct 2024 06:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729170821; x=1729775621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=O9UUCFR2zTOfml+UbZqKlXZwimpmJqPwLWgyjJXS5Ec=;
        b=L/xByAKpwvSowdW1dF0OuSeC8K+I9wVGFv1Ik1uLzwIm52NymYWZJ0qLA0oBhrGq7b
         2o6sGKVTKSNmN2R8MjfeptIBNtHCnXt36s8Q9l44YOoHGVTMKXuLMeuz5SIENbyCi7kb
         fmsl6W0DEbiqiZ3KQ/du9gckMa6VEowUOP2F+HfM3oSA6TkI6jm/Ama+DT4gDtA88VLT
         EdQwc3ghGaRFRNeQCRSQk/WafbkcjDe7JFLkuMsXcMTdqwH8k2gh+rzMMrEk1HW89lLn
         CXe5JFfrVVpP1G3vzO5z8MYXnFwJickUwOPsU7XPDyo6l/TrdviA8gCreiN2fsGYAZ/7
         VJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729170821; x=1729775621;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9UUCFR2zTOfml+UbZqKlXZwimpmJqPwLWgyjJXS5Ec=;
        b=XHh4XJm6h2Fa9l6NXhNTLZv9l/D9vU2oZRPY59YGlBs2S6T56fLk2vdqfnCQTbIZTp
         8d/bUS2iOREmLM242G7R7xAlhEnOtWbAuMyyDC++QYjdBNIox6zPBAuAVo4c+Pm4lo6J
         V0Z2I4llLXnEgCbqBRZ1TCFQ3DxmKgbMSMiT+5PjIMhVozxhiGlt1JhQL1bSbQENe20Z
         c+GJ0BYKEnWLsk8yjeMH9Y1v0mg94Yk/9muYGhGae+iC8ZYumX+dJtrh67h9NzNzoAnQ
         eu2moE+A/3qxFLrewBSpupi3IisWHZHT6t5ae9Z5g39kYMcYesOz8uDSOSgG+wgCniQ0
         k1ow==
X-Forwarded-Encrypted: i=1; AJvYcCVTPpaFe3mNKaLzEVEV9fLBaWMNKIdZa4K9rYjjpIeWuFaVEuxktsqeTMZlnBBQPVs2W9kBtKCl/GQS@vger.kernel.org, AJvYcCW2y1emc+IFyn8HCO1f445AQs/F/m4l1bl/kqWyepYipGAx1gpi17nF984y+T/kAruK5KWr2Bq0opcWjPDe@vger.kernel.org, AJvYcCXbDvIhhl9ttNtxYDRT5wlVZg7Z6+cN4EgfbMDq+HZK2k+kMyucN9fiJGnVO7Va5XLnk4IAhAB5qrI6cT7w@vger.kernel.org
X-Gm-Message-State: AOJu0YxZGm4qpEEdbdeIjVz+PxV4u9fxxxyGY2SGt3/dpXKLPD+aeiv7
	POlGbK0hMzcoJ0uD7wM7LPFeE6QwVytpAyRC7Z16jFVsn+LzV8R/
X-Google-Smtp-Source: AGHT+IEs09lD8CfbNSSrtQl7fd7pmaGnM9ILsqzV0s0TBi3C13Vg21fjUqJBxbIJdouRegNNPNKPsA==
X-Received: by 2002:a05:600c:3c9a:b0:431:51e5:2316 with SMTP id 5b1f17b1804b1-43151e52855mr43998635e9.34.1729170821217;
        Thu, 17 Oct 2024 06:13:41 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43158c620c5sm25791185e9.48.2024.10.17.06.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 06:13:40 -0700 (PDT)
Message-ID: <67110d84.050a0220.2ae4bd.8910@mx.google.com>
X-Google-Original-Message-ID: <ZxENgbSfBzEIrgdJ@Ansuel-XPS.>
Date: Thu, 17 Oct 2024 15:13:37 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: Re: [PATCH 2/2] hwrng: add support for Airoha EN7581 TRNG
References: <20241016151845.23712-1-ansuelsmth@gmail.com>
 <20241016151845.23712-2-ansuelsmth@gmail.com>
 <20241017131112.GA28955@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017131112.GA28955@francesco-nb>

On Thu, Oct 17, 2024 at 03:11:12PM +0200, Francesco Dolcini wrote:
> On Wed, Oct 16, 2024 at 05:18:42PM +0200, Christian Marangi wrote:
> > Add support for Airoha TRNG. The Airoha SoC provide a True RNG module
> > that can output 4 bytes of raw data at times.
> > 
> > The module makes use of various noise source to provide True Random
> > Number Generation.
> > 
> > On probe the module is reset to operate Health Test and verify correct
> > execution of it.
> > 
> > The module can also provide DRBG function but the execution mode is
> > mutually exclusive, running as TRNG doesn't permit to also run it as
> > DRBG.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/char/hw_random/Kconfig       |  13 ++
> >  drivers/char/hw_random/Makefile      |   1 +
> >  drivers/char/hw_random/airoha-trng.c | 243 +++++++++++++++++++++++++++
> >  3 files changed, 257 insertions(+)
> >  create mode 100644 drivers/char/hw_random/airoha-trng.c
> > 
> > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > index 5912c2dd6398..bda283f290bc 100644
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -62,6 +62,19 @@ config HW_RANDOM_AMD
> >  
> >  	  If unsure, say Y.
> >  
> > +config HW_RANDOM_AIROHA
> > +	tristate "Airoha True HW Random Number Generator support"
> > +	depends on ARCH_AIROHA || COMPILE_TEST
> 
> > +	default HW_RANDOM
> This should not be always enabled when HW_RANDOM is enabled. Enabling
> driver should be a opt-in.

Was following the pattern with other HW_RANDOM config. Ok will drop.

-- 
	Ansuel
